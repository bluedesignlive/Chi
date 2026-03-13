#ifndef FOLDERPLAYER_H
#define FOLDERPLAYER_H

#include <QObject>
#include <QUrl>
#include <QStringList>

// Manages a playlist of audio files from drag-drop, file picker, or folder scan.
// Provides sequential navigation and natural sort order.
class FolderPlayer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUrl        folder          READ folder          NOTIFY folderChanged)
    Q_PROPERTY(QUrl        currentFile     READ currentFile     NOTIFY currentFileChanged)
    Q_PROPERTY(QString     currentFileName READ currentFileName NOTIFY currentFileChanged)
    Q_PROPERTY(int         currentIndex    READ currentIndex    WRITE setCurrentIndex NOTIFY currentIndexChanged)
    Q_PROPERTY(int         count           READ count           NOTIFY countChanged)
    Q_PROPERTY(bool        hasNext         READ hasNext         NOTIFY currentIndexChanged)
    Q_PROPERTY(bool        hasPrevious     READ hasPrevious     NOTIFY currentIndexChanged)
    Q_PROPERTY(QStringList files           READ files           NOTIFY filesChanged)

public:
    explicit FolderPlayer(QObject *parent = nullptr);

    QUrl folder() const;
    QUrl currentFile() const;
    QString currentFileName() const;
    int  currentIndex() const;
    void setCurrentIndex(int index);
    int  count() const;
    bool hasNext() const;
    bool hasPrevious() const;
    QStringList files() const;

    Q_INVOKABLE void loadFile(const QUrl &file);
    Q_INVOKABLE void loadFolder(const QUrl &folder);
    Q_INVOKABLE void loadUrls(const QList<QUrl> &urls);
    Q_INVOKABLE void next();
    Q_INVOKABLE void previous();
    Q_INVOKABLE void clear();

signals:
    void folderChanged();
    void currentFileChanged();
    void currentIndexChanged();
    void countChanged();
    void filesChanged();

private:
    void scanFolder(const QString &path);
    void sortFiles();
    bool isAudioFile(const QString &path) const;

    QUrl        m_folder;
    QStringList m_files;
    int         m_currentIndex = -1;
    QStringList m_audioExtensions;
};

#endif // FOLDERPLAYER_H
