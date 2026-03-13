#include "chi.h"
#include <QDebug>
#include <QColor>

static ThemeBackend* s_instance = nullptr;

ThemeBackend::ThemeBackend(QObject *parent) : QObject(parent)
{
    m_isDarkMode = true;
    m_primaryColor = "#673AB7";

    QString configDir = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation) + "/chi";
    QDir dir(configDir);
    if (!dir.exists()) dir.mkpath(".");
    m_configPath = configDir + "/theme.json";

    m_watcher = new QFileSystemWatcher(this);
    if (QFile::exists(m_configPath))
        m_watcher->addPath(m_configPath);
    connect(m_watcher, &QFileSystemWatcher::fileChanged, this, &ThemeBackend::loadConfig);

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
    if (file.open(QIODevice::WriteOnly))
        file.write(QJsonDocument(json).toJson());
}

void ThemeBackend::loadConfig() {
    QFile file(m_configPath);
    if (!file.open(QIODevice::ReadOnly)) return;

    QJsonObject json = QJsonDocument::fromJson(file.readAll()).object();
    bool newDark = json.contains("darkMode") ? json["darkMode"].toBool() : m_isDarkMode;
    QString newPrimary = json.contains("primary") ? json["primary"].toString() : m_primaryColor;
    if (!QColor(newPrimary).isValid()) newPrimary = "#673AB7";

    if (m_isDarkMode != newDark || m_primaryColor != newPrimary) {
        m_isDarkMode = newDark;
        m_primaryColor = newPrimary;
        emit themeChanged();
    }

    if (!m_watcher->files().contains(m_configPath))
        m_watcher->addPath(m_configPath);
}

void ChiPlugin::registerTypes(const char *uri)
{
    qmlRegisterSingletonType<ThemeBackend>(uri, 1, 0, "ThemeBackend",
        [](QQmlEngine *, QJSEngine *) -> QObject * {
            if (!s_instance) s_instance = new ThemeBackend();
            return s_instance;
        });
}

void ChiPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    Q_UNUSED(uri)
    if (!s_instance) s_instance = new ThemeBackend();
    engine->rootContext()->setContextProperty("_chiBackend", s_instance);
}
