#pragma once

#include <QString>
#include <QUrl>
#include <QDateTime>

struct FileEntry {
    QString fileName;
    QString filePath;
    QUrl    fileUrl;
    bool    isDir        = false;
    qint64  fileSize     = 0;
    QDateTime fileModified;
    QString mimeType;
    QString icon;
    QString typeLabel;
    bool    isHidden     = false;
};
