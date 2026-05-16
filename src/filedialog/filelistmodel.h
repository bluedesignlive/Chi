#pragma once

#include <QAbstractListModel>
#include <QUrl>
#include <QVector>
#include <QRegularExpression>
#include <QCollator>

class QThreadPool;
class QFileSystemWatcher;
class QTimer;

struct FileEntry;

class FileListModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(QUrl        folder        READ folder        WRITE setFolder        NOTIFY folderChanged)
    Q_PROPERTY(QStringList nameFilters   READ nameFilters   WRITE setNameFilters   NOTIFY nameFiltersChanged)
    Q_PROPERTY(QString     searchQuery   READ searchQuery   WRITE setSearchQuery   NOTIFY searchQueryChanged)
    Q_PROPERTY(bool        showHidden    READ showHidden    WRITE setShowHidden    NOTIFY showHiddenChanged)
    Q_PROPERTY(bool        showDirs      READ showDirs      WRITE setShowDirs      NOTIFY showDirsChanged)
    Q_PROPERTY(bool        showFiles     READ showFiles     WRITE setShowFiles     NOTIFY showFilesChanged)
    Q_PROPERTY(bool        showDirsFirst READ showDirsFirst WRITE setShowDirsFirst NOTIFY showDirsFirstChanged)
    Q_PROPERTY(SortField   sortField     READ sortField     WRITE setSortField     NOTIFY sortFieldChanged)
    Q_PROPERTY(bool        sortReversed  READ sortReversed  WRITE setSortReversed  NOTIFY sortReversedChanged)
    Q_PROPERTY(int         count         READ count                                NOTIFY countChanged)
    Q_PROPERTY(bool        loading       READ loading                              NOTIFY loadingChanged)
    Q_PROPERTY(QString     lastError     READ lastError                            NOTIFY lastErrorChanged)

public:
    enum SortField { SortByName = 0, SortBySize, SortByDate, SortByType };
    Q_ENUM(SortField)

    enum Roles {
        FileNameRole = Qt::UserRole + 1,
        FilePathRole,
        FileUrlRole,
        FileIsDirRole,
        FileSizeRole,
        FileModifiedRole,
        FileMimeTypeRole,
        FileIconRole,
        FileTypeLabelRole,
        FileIsHiddenRole
    };

    explicit FileListModel(QObject *parent = nullptr);
    ~FileListModel() override;

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE QVariant get(int index, const QString &roleName) const;
    Q_INVOKABLE void refresh();

    Q_INVOKABLE bool createFolder(const QString &name);
    Q_INVOKABLE bool fileExists(const QString &path) const;

    QUrl        folder()        const;
    QStringList nameFilters()   const;
    QString     searchQuery()   const;
    bool        showHidden()    const;
    bool        showDirs()      const;
    bool        showFiles()     const;
    bool        showDirsFirst() const;
    SortField   sortField()     const;
    bool        sortReversed()  const;
    int         count()         const;
    bool        loading()       const;
    QString     lastError()     const;

    void setFolder(const QUrl &url);
    void setNameFilters(const QStringList &filters);
    void setSearchQuery(const QString &query);
    void setShowHidden(bool show);
    void setShowDirs(bool show);
    void setShowFiles(bool show);
    void setShowDirsFirst(bool show);
    void setSortField(SortField field);
    void setSortReversed(bool reversed);

signals:
    void folderChanged();
    void nameFiltersChanged();
    void searchQueryChanged();
    void showHiddenChanged();
    void showDirsChanged();
    void showFilesChanged();
    void showDirsFirstChanged();
    void sortFieldChanged();
    void sortReversedChanged();
    void countChanged();
    void loadingChanged();
    void lastErrorChanged();

private:
    struct LoadResult {
        QVector<FileEntry> entries;
    };

    void loadDirectory();
    void applyFilterAndSort();
    void sortEntries();
    void recompileFilters();
    void setLoading(bool v);
    void setLastError(const QString &msg);

    QUrl        m_folder;
    QStringList m_nameFilters;
    QString     m_searchQuery;
    bool        m_showHidden    = false;
    bool        m_showDirs      = true;
    bool        m_showFiles     = true;
    bool        m_showDirsFirst = true;
    SortField   m_sortField     = SortByName;
    bool        m_sortReversed  = false;
    bool        m_loading       = false;
    QString     m_lastError;

    QVector<FileEntry>          m_rawEntries;
    QVector<FileEntry>          m_entries;
    QVector<QRegularExpression> m_compiledFilters;

    QFileSystemWatcher *m_watcher     = nullptr;
    QTimer             *m_refreshTimer = nullptr;
    int                 m_loadSequence = 0;

    QHash<QString, int> m_roleLookup;
    QCollator           m_collator;
};
