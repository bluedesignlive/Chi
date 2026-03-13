#ifndef CHI_H
#define CHI_H

#include <QObject>
#include <QQmlEngine>
#include <QQmlContext>
#include <QColor>
#include <QFileSystemWatcher>
#include <QJsonObject>
#include <QFile>
#include <QDir>
#include <QStandardPaths>
#include <QJsonDocument>
#include <QQmlExtensionPlugin>

class ThemeBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isDarkMode READ isDarkMode WRITE setDarkMode NOTIFY themeChanged)
    Q_PROPERTY(QString primaryColor READ primaryColor WRITE setPrimaryColor NOTIFY themeChanged)

public:
    explicit ThemeBackend(QObject *parent = nullptr);

    bool isDarkMode() const;
    void setDarkMode(bool dark);
    QString primaryColor() const;
    void setPrimaryColor(const QString &color);

signals:
    void themeChanged();

private:
    void loadConfig();
    void saveConfig();

    bool m_isDarkMode;
    QString m_primaryColor;
    QString m_configPath;
    QFileSystemWatcher *m_watcher;
};

class ChiPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)
public:
    void registerTypes(const char *uri) override;
    void initializeEngine(QQmlEngine *engine, const char *uri) override;
};

#endif
