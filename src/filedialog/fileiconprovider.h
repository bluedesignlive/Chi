#pragma once

#include <QObject>
#include <QString>

class FileIconProvider : public QObject
{
    Q_OBJECT
public:
    explicit FileIconProvider(QObject *parent = nullptr);

    static QString iconForExtension(const QString &ext);
    static QString iconForMime(const QString &mimeName);

    Q_INVOKABLE static QString iconForFile(const QString &fileName);
};
