#ifndef SMARTUI_H
#define SMARTUI_H

#include <QObject>
#include <QQmlEngine>
#include <QColor>
#include <QFileSystemWatcher>
#include <QJsonObject>
#include <QFile>
#include <QDir>
#include <QStandardPaths>
#include <QJsonDocument>
#include <QQmlExtensionPlugin>

// The Backend Logic
class ThemeBackend : public QObject
{
    Q_OBJECT
    // Properties that QML will listen to
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

// The Plugin Entry Point (Required for SHARED libraries)
class SmartUIPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)
public:
    void registerTypes(const char *uri) override;
};

#endif
