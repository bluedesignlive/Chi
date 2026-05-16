#include "filelistmodel.h"
#include "fileinfo.h"
#include "fileiconprovider.h"

#include <QDir>
#include <QFileInfo>
#include <QMimeDatabase>
#include <QFileSystemWatcher>
#include <QTimer>
#include <QFutureWatcher>
#include <QtConcurrent>
#include <QCollator>
#include <QThreadPool>
#include <mutex>
#include <algorithm>

using namespace Qt::StringLiterals;

static QThreadPool *loadPool()
{
    static QThreadPool pool;
    static std::once_flag flag;
    std::call_once(flag, [] {
        pool.setMaxThreadCount(2);
        pool.setExpiryTimeout(30000);
    });
    return &pool;
}

FileListModel::FileListModel(QObject *parent)
    : QAbstractListModel(parent)
{
    const auto names = roleNames();
    for (auto it = names.begin(); it != names.end(); ++it)
        m_roleLookup.insert(QString::fromLatin1(it.value()), it.key());

    m_collator.setNumericMode(true);
    m_collator.setCaseSensitivity(Qt::CaseInsensitive);

    m_watcher = new QFileSystemWatcher(this);
    connect(m_watcher, &QFileSystemWatcher::directoryChanged,
            this, [this](const QString &) { m_refreshTimer->start(); });

    m_refreshTimer = new QTimer(this);
    m_refreshTimer->setSingleShot(true);
    m_refreshTimer->setInterval(300);
    connect(m_refreshTimer, &QTimer::timeout, this, &FileListModel::refresh);
}

FileListModel::~FileListModel() = default;

int FileListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) return 0;
    return m_entries.size();
}

QVariant FileListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_entries.size())
        return {};

    const auto &e = m_entries.at(index.row());
    switch (role) {
    case FileNameRole:      return e.fileName;
    case FilePathRole:      return e.filePath;
    case FileUrlRole:       return e.fileUrl;
    case FileIsDirRole:     return e.isDir;
    case FileSizeRole:      return e.fileSize;
    case FileModifiedRole:  return e.fileModified;
    case FileMimeTypeRole:  return e.mimeType;
    case FileIconRole:      return e.icon;
    case FileTypeLabelRole: return e.typeLabel;
    case FileIsHiddenRole:  return e.isHidden;
    default:                return {};
    }
}

QHash<int, QByteArray> FileListModel::roleNames() const
{
    return {
        { FileNameRole,      "fileName" },
        { FilePathRole,      "filePath" },
        { FileUrlRole,       "fileUrl" },
        { FileIsDirRole,     "fileIsDir" },
        { FileSizeRole,      "fileSize" },
        { FileModifiedRole,  "fileModified" },
        { FileMimeTypeRole,  "fileMimeType" },
        { FileIconRole,      "fileIcon" },
        { FileTypeLabelRole, "fileTypeLabel" },
        { FileIsHiddenRole,  "fileIsHidden" }
    };
}

QVariant FileListModel::get(int index, const QString &roleName) const
{
    if (index < 0 || index >= m_entries.size()) return {};
    auto it = m_roleLookup.constFind(roleName);
    if (it == m_roleLookup.constEnd()) return {};
    return data(this->index(index), it.value());
}

void FileListModel::refresh()
{
    loadDirectory();
}

QUrl        FileListModel::folder()        const { return m_folder; }
QStringList FileListModel::nameFilters()   const { return m_nameFilters; }
QString     FileListModel::searchQuery()   const { return m_searchQuery; }
bool        FileListModel::showHidden()    const { return m_showHidden; }
bool        FileListModel::showDirs()      const { return m_showDirs; }
bool        FileListModel::showFiles()     const { return m_showFiles; }
bool        FileListModel::showDirsFirst() const { return m_showDirsFirst; }
FileListModel::SortField FileListModel::sortField() const { return m_sortField; }
bool        FileListModel::sortReversed()  const { return m_sortReversed; }
int         FileListModel::count()         const { return m_entries.size(); }
bool        FileListModel::loading()       const { return m_loading; }
QString     FileListModel::lastError()     const { return m_lastError; }

void FileListModel::setFolder(const QUrl &url)
{
    if (m_folder == url) return;

    const QString oldPath = m_folder.toLocalFile();
    if (!oldPath.isEmpty()) m_watcher->removePath(oldPath);

    m_folder = url;
    emit folderChanged();

    const QString newPath = url.toLocalFile();
    if (!newPath.isEmpty() && QDir(newPath).exists())
        m_watcher->addPath(newPath);

    loadDirectory();
}

void FileListModel::setNameFilters(const QStringList &filters)
{
    if (m_nameFilters == filters) return;
    m_nameFilters = filters;
    emit nameFiltersChanged();
    recompileFilters();
    applyFilterAndSort();
}

void FileListModel::setSearchQuery(const QString &query)
{
    if (m_searchQuery == query) return;
    m_searchQuery = query;
    emit searchQueryChanged();
    applyFilterAndSort();
}

void FileListModel::setShowHidden(bool show)
{
    if (m_showHidden == show) return;
    m_showHidden = show;
    emit showHiddenChanged();
    loadDirectory();
}

void FileListModel::setShowDirs(bool show)
{
    if (m_showDirs == show) return;
    m_showDirs = show;
    emit showDirsChanged();
    loadDirectory();
}

void FileListModel::setShowFiles(bool show)
{
    if (m_showFiles == show) return;
    m_showFiles = show;
    emit showFilesChanged();
    loadDirectory();
}

void FileListModel::setShowDirsFirst(bool show)
{
    if (m_showDirsFirst == show) return;
    m_showDirsFirst = show;
    emit showDirsFirstChanged();
    applyFilterAndSort();
}

void FileListModel::setSortField(SortField field)
{
    if (m_sortField == field) return;
    m_sortField = field;
    emit sortFieldChanged();
    applyFilterAndSort();
}

void FileListModel::setSortReversed(bool reversed)
{
    if (m_sortReversed == reversed) return;
    m_sortReversed = reversed;
    emit sortReversedChanged();
    applyFilterAndSort();
}

void FileListModel::setLoading(bool v)
{
    if (m_loading == v) return;
    m_loading = v;
    emit loadingChanged();
}

void FileListModel::setLastError(const QString &msg)
{
    if (m_lastError == msg) return;
    m_lastError = msg;
    emit lastErrorChanged();
}

void FileListModel::recompileFilters()
{
    m_compiledFilters.clear();
    m_compiledFilters.reserve(m_nameFilters.size());
    for (const auto &f : m_nameFilters) {
        if (f == u"*"_s) continue;
        m_compiledFilters.append(QRegularExpression(
            QRegularExpression::wildcardToRegularExpression(f),
            QRegularExpression::CaseInsensitiveOption));
    }
}

void FileListModel::loadDirectory()
{
    const QString path = m_folder.toLocalFile();

    if (path.isEmpty() || !QDir(path).exists()) {
        setLastError(path.isEmpty() ? QString() : tr("Folder not found"));
        beginResetModel();
        m_rawEntries.clear();
        m_entries.clear();
        endResetModel();
        emit countChanged();
        setLoading(false);
        return;
    }

    const int seq = ++m_loadSequence;
    setLoading(true);
    setLastError(QString());

    const bool snapShowHidden = m_showHidden;
    const bool snapShowDirs   = m_showDirs;
    const bool snapShowFiles  = m_showFiles;

    auto *watcher = new QFutureWatcher<LoadResult>(this);
    connect(watcher, &QFutureWatcher<LoadResult>::finished, this,
            [this, watcher, seq]() {
        watcher->deleteLater();
        if (seq != m_loadSequence) return;

        const LoadResult result = watcher->result();
        m_rawEntries = result.entries;
        applyFilterAndSort();
        setLoading(false);
    });

    watcher->setFuture(QtConcurrent::run(loadPool(),
        [path, snapShowHidden, snapShowDirs, snapShowFiles]() -> LoadResult
    {
        QDir dir(path);
        QDir::Filters flags = QDir::AllEntries | QDir::NoDot | QDir::NoDotDot;
        if (snapShowHidden) flags |= QDir::Hidden;

        const auto infos = dir.entryInfoList(flags);

        QMimeDatabase db;
        QVector<FileEntry> entries;
        entries.reserve(infos.size());

        for (const QFileInfo &fi : infos) {
            if (fi.isDir()  && !snapShowDirs)  continue;
            if (!fi.isDir() && !snapShowFiles) continue;

            FileEntry e;
            e.fileName     = fi.fileName();
            e.filePath     = fi.absoluteFilePath();
            e.fileUrl      = QUrl::fromLocalFile(fi.absoluteFilePath());
            e.isDir        = fi.isDir();
            e.fileSize     = fi.size();
            e.fileModified = fi.lastModified();
            e.isHidden     = fi.isHidden();

            if (fi.isDir()) {
                e.icon      = u"folder"_s;
                e.typeLabel = QStringLiteral("Folder");
                e.mimeType  = u"inode/directory"_s;
            } else {
                const QMimeType mime = db.mimeTypeForFile(
                    fi.fileName(), QMimeDatabase::MatchExtension);
                e.mimeType  = mime.name();
                e.icon      = FileIconProvider::iconForMime(mime.name());
                e.typeLabel = mime.comment();
                if (e.typeLabel.isEmpty())
                    e.typeLabel = QStringLiteral("File");
            }

            entries.append(std::move(e));
        }

        return { entries };
    }));
}

void FileListModel::applyFilterAndSort()
{
    beginResetModel();

    m_entries = m_rawEntries;

    if (!m_compiledFilters.isEmpty()) {
        auto it = std::remove_if(m_entries.begin(), m_entries.end(),
            [this](const FileEntry &e) {
                if (e.isDir) return false;
                for (const auto &re : m_compiledFilters)
                    if (re.match(e.fileName).hasMatch()) return false;
                return true;
            });
        m_entries.erase(it, m_entries.end());
    }

    if (!m_searchQuery.isEmpty()) {
        const QString q = m_searchQuery.toLower();
        auto it = std::remove_if(m_entries.begin(), m_entries.end(),
            [&q](const FileEntry &e) {
                return !e.fileName.toLower().contains(q);
            });
        m_entries.erase(it, m_entries.end());
    }

    sortEntries();

    endResetModel();
    emit countChanged();
}

void FileListModel::sortEntries()
{
    const bool dirsFirst = m_showDirsFirst;
    const bool reversed  = m_sortReversed;
    const SortField sf   = m_sortField;
    QCollator &col       = m_collator;

    std::sort(m_entries.begin(), m_entries.end(),
        [&](const FileEntry &a, const FileEntry &b) -> bool
    {
        if (dirsFirst && a.isDir != b.isDir)
            return a.isDir;

        int cmp = 0;
        switch (sf) {
        case SortByName:
            cmp = col.compare(a.fileName, b.fileName);
            break;
        case SortBySize:
            cmp = (a.fileSize < b.fileSize) ? -1
                : (a.fileSize > b.fileSize) ?  1 : 0;
            break;
        case SortByDate:
            cmp = (a.fileModified < b.fileModified) ? -1
                : (a.fileModified > b.fileModified) ?  1 : 0;
            break;
        case SortByType:
            cmp = QString::compare(a.typeLabel, b.typeLabel, Qt::CaseInsensitive);
            if (cmp == 0) cmp = col.compare(a.fileName, b.fileName);
            break;
        }

        return reversed ? (cmp > 0) : (cmp < 0);
    });
}

// ═══ Phase 2: File operations ═══

bool FileListModel::createFolder(const QString &name)
{
    const QString basePath = m_folder.toLocalFile();
    if (basePath.isEmpty() || name.isEmpty()) return false;

    QDir dir(basePath);
    if (!dir.exists()) return false;

    bool ok = dir.mkdir(name);
    if (ok) refresh();
    return ok;
}

bool FileListModel::fileExists(const QString &path) const
{
    QString p = path;
    if (p.startsWith(u"file://"_s)) p = QUrl(p).toLocalFile();
    return QFile::exists(p);
}
