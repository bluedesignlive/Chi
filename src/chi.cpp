#include "smartui.h"
#include <QDebug>
#include <QColor>

ThemeBackend::ThemeBackend(QObject *parent) : QObject(parent)
{
    // 1. CRITICAL: Set defaults immediately so QML never gets 'undefined'
    m_isDarkMode = true;
    m_primaryColor = "#386a20"; // Forest Green default

    // 2. Define Path: ~/.config/smartui-beta/theme.json
    QString configDir = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation) + "/smartui-beta";
    QDir dir(configDir);
    if (!dir.exists()) dir.mkpath(".");
    m_configPath = configDir + "/theme.json";

    // 3. Setup Watcher
    m_watcher = new QFileSystemWatcher(this);
    if (QFile::exists(m_configPath)) {
        m_watcher->addPath(m_configPath);
    }
    connect(m_watcher, &QFileSystemWatcher::fileChanged, this, &ThemeBackend::loadConfig);

    // 4. Try loading config (will overwrite defaults if file exists)
    loadConfig();
}

bool ThemeBackend::isDarkMode() const { return m_isDarkMode; }
void ThemeBackend::setDarkMode(bool dark) {
    if (m_isDarkMode == dark) return;
    m_isDarkMode = dark;
    saveConfig();
    emit themeChanged();
}

QString ThemeBackend::primaryColor() const { return m_primaryColor; }
void ThemeBackend::setPrimaryColor(const QString &color) {
    // Validation to prevent crashing
    if (m_primaryColor == color || !QColor(color).isValid()) return;
    m_primaryColor = color;
    saveConfig();
    emit themeChanged();
}

void ThemeBackend::saveConfig() {
    QJsonObject json;
    json["darkMode"] = m_isDarkMode;
    json["primary"] = m_primaryColor;
    
    QFile file(m_configPath);
    if (file.open(QIODevice::WriteOnly)) {
        file.write(QJsonDocument(json).toJson());
    }
}

void ThemeBackend::loadConfig() {
    QFile file(m_configPath);
    if (!file.open(QIODevice::ReadOnly)) return;

    QJsonObject json = QJsonDocument::fromJson(file.readAll()).object();
    
    // Fallbacks: If JSON is missing keys, keep existing values
    bool newDark = json.contains("darkMode") ? json["darkMode"].toBool() : m_isDarkMode;
    QString newPrimary = json.contains("primary") ? json["primary"].toString() : m_primaryColor;

    // Safety: Ensure loaded color is valid
    if (!QColor(newPrimary).isValid()) newPrimary = "#386a20";

    if (m_isDarkMode != newDark || m_primaryColor != newPrimary) {
        m_isDarkMode = newDark;
        m_primaryColor = newPrimary;
        emit themeChanged();
    }
    
    if (!m_watcher->files().contains(m_configPath)) {
        m_watcher->addPath(m_configPath);
    }
}

void SmartUIPlugin::registerTypes(const char *uri)
{
    qmlRegisterSingletonType<ThemeBackend>(uri, 1, 0, "ThemeBackend", [](QQmlEngine *, QJSEngine *) -> QObject * {
        return new ThemeBackend();
    });
}
