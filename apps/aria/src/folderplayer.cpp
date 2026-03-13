#include "folderplayer.h"
#include <QDir>
#include <QFileInfo>
#include <QCollator>
#include <algorithm>

FolderPlayer::FolderPlayer(QObject *parent)
    : QObject(parent)
{
    m_audioExtensions << "mp3" << "wav" << "flac" << "ogg" << "m4a"
                      << "aac" << "wma" << "opus" << "aiff" << "ape";
}

QUrl FolderPlayer::folder() const { return m_folder; }

QUrl FolderPlayer::currentFile() const {
    if (m_currentIndex >= 0 && m_currentIndex < m_files.size())
        return QUrl::fromLocalFile(m_files.at(m_currentIndex));
    return QUrl();
}

QString FolderPlayer::currentFileName() const {
    if (m_currentIndex >= 0 && m_currentIndex < m_files.size())
        return QFileInfo(m_files.at(m_currentIndex)).fileName();
    return QString();
}

int  FolderPlayer::currentIndex() const { return m_currentIndex; }
int  FolderPlayer::count()        const { return m_files.size(); }
bool FolderPlayer::hasNext()      const { return m_currentIndex < m_files.size() - 1; }
bool FolderPlayer::hasPrevious()  const { return m_currentIndex > 0; }
QStringList FolderPlayer::files() const { return m_files; }

void FolderPlayer::setCurrentIndex(int index) {
    if (index >= -1 && index < m_files.size() && m_currentIndex != index) {
        m_currentIndex = index;
        emit currentIndexChanged();
        emit currentFileChanged();
    }
}

void FolderPlayer::loadFile(const QUrl &file) {
    QString path = file.toLocalFile();
    QFileInfo info(path);
    if (info.isDir()) { loadFolder(file); return; }
    if (!isAudioFile(path)) return;

    QString dirPath = info.absolutePath();
    m_folder = QUrl::fromLocalFile(dirPath);
    scanFolder(dirPath);
    int idx = m_files.indexOf(info.absoluteFilePath());
    if (idx >= 0) setCurrentIndex(idx);
    emit folderChanged();
}

void FolderPlayer::loadFolder(const QUrl &folder) {
    m_folder = folder;
    scanFolder(folder.toLocalFile());
    if (!m_files.isEmpty()) setCurrentIndex(0);
    emit folderChanged();
}

void FolderPlayer::loadUrls(const QList<QUrl> &urls) {
    if (urls.isEmpty()) return;
    if (urls.size() == 1) { loadFile(urls.first()); return; }

    m_files.clear();
    for (const QUrl &url : urls) {
        QString path = url.toLocalFile();
        QFileInfo info(path);
        if (info.isDir()) {
            for (const QFileInfo &fi : QDir(path).entryInfoList(QDir::Files))
                if (isAudioFile(fi.absoluteFilePath()))
                    m_files.append(fi.absoluteFilePath());
        } else if (isAudioFile(path)) {
            m_files.append(info.absoluteFilePath());
        }
    }
    sortFiles();
    emit filesChanged();
    emit countChanged();
    if (!m_files.isEmpty()) setCurrentIndex(0);
}

void FolderPlayer::next()     { if (hasNext())     setCurrentIndex(m_currentIndex + 1); }
void FolderPlayer::previous() { if (hasPrevious()) setCurrentIndex(m_currentIndex - 1); }

void FolderPlayer::clear() {
    m_files.clear();
    m_currentIndex = -1;
    m_folder = QUrl();
    emit filesChanged(); emit countChanged();
    emit currentIndexChanged(); emit currentFileChanged(); emit folderChanged();
}

void FolderPlayer::scanFolder(const QString &path) {
    m_files.clear();
    QDir dir(path);
    if (!dir.exists()) return;
    for (const QFileInfo &fi : dir.entryInfoList(QDir::Files))
        if (isAudioFile(fi.absoluteFilePath()))
            m_files.append(fi.absoluteFilePath());
    sortFiles();
    m_currentIndex = -1;
    emit filesChanged(); emit countChanged();
    emit currentIndexChanged(); emit currentFileChanged();
}

void FolderPlayer::sortFiles() {
    QCollator c;
    c.setNumericMode(true);
    c.setCaseSensitivity(Qt::CaseInsensitive);
    std::sort(m_files.begin(), m_files.end(), [&c](const QString &a, const QString &b) {
        return c.compare(QFileInfo(a).fileName(), QFileInfo(b).fileName()) < 0;
    });
}

bool FolderPlayer::isAudioFile(const QString &path) const {
    return m_audioExtensions.contains(QFileInfo(path).suffix().toLower());
}
