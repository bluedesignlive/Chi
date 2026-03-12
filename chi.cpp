#include "chi.h"
#include <QDebug>
#include <QColor>

// ─── Constructor ─────────────────────────────────────────────
ThemeBackend::ThemeBackend(QObject *parent)
    : QObject(parent)
    , m_isDarkMode(true)
    , m_primaryColor(DEFAULT_PRIMARY)
    , m_revision(0)
{
    // 1. Config directory: ~/.config/chi/
    QString configDir =
        QStandardPaths::writableLocation(QStandardPaths::ConfigLocation) + "/chi";
    QDir dir(configDir);
    if (!dir.exists())
        dir.mkpath(".");
    m_configPath = configDir + "/theme.json";

    // 2. Debounce timer — coalesces rapid file-change events
    m_debounce = new QTimer(this);
    m_debounce->setSingleShot(true);
    m_debounce->setInterval(100);  // 100ms debounce
    connect(m_debounce, &QTimer::timeout, this, &ThemeBackend::loadConfig);

    // 3. File system watcher
    m_watcher = new QFileSystemWatcher(this);
    if (QFile::exists(m_configPath))
        m_watcher->addPath(m_configPath);
    connect(m_watcher, &QFileSystemWatcher::fileChanged,
            this, &ThemeBackend::scheduleReload);

    // 4. Initial load — writes defaults if file doesn't exist
    if (!QFile::exists(m_configPath)) {
        saveConfig();              // create the file with defaults
        m_watcher->addPath(m_configPath);
    } else {
        loadConfig();
    }

    qDebug() << "[Chi] Theme backend ready. Config:" << m_configPath;
}

// ─── Property Accessors ──────────────────────────────────────
bool    ThemeBackend::isDarkMode()    const { return m_isDarkMode; }
QString ThemeBackend::primaryColor()  const { return m_primaryColor; }
int     ThemeBackend::revision()      const { return m_revision; }

void ThemeBackend::setDarkMode(bool dark) {
    if (m_isDarkMode == dark) return;
    m_isDarkMode = dark;
    m_revision++;
    saveConfig();
    emit themeChanged();
}

void ThemeBackend::setPrimaryColor(const QString &color) {
    if (m_primaryColor == color || !QColor(color).isValid()) return;
    m_primaryColor = color;
    m_revision++;
    saveConfig();
    emit themeChanged();
}

// ─── Batch Apply (avoids double signal + double write) ───────
void ThemeBackend::applyTheme(bool dark, const QString &primary) {
    bool changed = false;

    if (m_isDarkMode != dark) {
        m_isDarkMode = dark;
        changed = true;
    }

    if (QColor(primary).isValid() && m_primaryColor != primary) {
        m_primaryColor = primary;
        changed = true;
    }

    if (changed) {
        m_revision++;
        saveConfig();
        emit themeChanged();
    }
}

void ThemeBackend::resetToDefaults() {
    applyTheme(true, DEFAULT_PRIMARY);
}

// ─── Persistence ─────────────────────────────────────────────
void ThemeBackend::saveConfig() {
    QJsonObject json;
    json["darkMode"] = m_isDarkMode;
    json["primary"]  = m_primaryColor;

    QFile file(m_configPath);
    if (file.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
        file.write(QJsonDocument(json).toJson(QJsonDocument::Indented));
        file.close();
    } else {
        qWarning() << "[Chi] Failed to write config:" << m_configPath;
    }
}

void ThemeBackend::loadConfig() {
    QFile file(m_configPath);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "[Chi] Cannot read config:" << m_configPath;
        return;
    }

    QJsonParseError err;
    QJsonDocument doc = QJsonDocument::fromJson(file.readAll(), &err);
    file.close();

    if (err.error != QJsonParseError::NoError) {
        qWarning() << "[Chi] JSON parse error:" << err.errorString();
        return;
    }

    QJsonObject json = doc.object();

    bool    newDark    = json.value("darkMode").toBool(m_isDarkMode);
    QString newPrimary = json.value("primary").toString(m_primaryColor);

    if (!QColor(newPrimary).isValid())
        newPrimary = DEFAULT_PRIMARY;

    if (m_isDarkMode != newDark || m_primaryColor != newPrimary) {
        m_isDarkMode   = newDark;
        m_primaryColor = newPrimary;
        m_revision++;
        emit themeChanged();
        qDebug() << "[Chi] Theme reloaded — dark:" << newDark
                 << "primary:" << newPrimary << "rev:" << m_revision;
    }

    // Re-add watcher (some systems remove it after file modification)
    if (!m_watcher->files().contains(m_configPath))
        m_watcher->addPath(m_configPath);
}

void ThemeBackend::scheduleReload() {
    // Re-add watcher immediately (Linux inotify drops it on overwrite)
    if (!m_watcher->files().contains(m_configPath))
        m_watcher->addPath(m_configPath);
    m_debounce->start();
}

// ─── Plugin Registration ─────────────────────────────────────
void ChiPlugin::registerTypes(const char *uri)
{
    // uri will be "Chi" when loaded via qmldir
    qmlRegisterSingletonType<ThemeBackend>(
        uri, 1, 0, "ThemeBackend",
        [](QQmlEngine *, QJSEngine *) -> QObject * {
            return new ThemeBackend();
        });
}
