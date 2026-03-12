#ifndef CHI_H
#define CHI_H

#include <QObject>
#include <QQmlExtensionPlugin>
#include <QQmlEngine>
#include <QJSEngine>
#include <QJsonDocument>
#include <QJsonObject>
#include <QFile>
#include <QDir>
#include <QStandardPaths>
#include <QFileSystemWatcher>
#include <QTimer>

// ─── ThemeBackend ──────────────────────────────────────────
// Persists dark/light mode and primary color to:
//   ~/.config/chi/theme.json
// Watches the file for external edits (hot-reload from CLI).
// ────────────────────────────────────────────────────────────

class ThemeBackend : public QObject
{
    Q_OBJECT

    // ── Bindable properties for QML ────────────────────────
    Q_PROPERTY(bool   isDarkMode    READ isDarkMode    WRITE setDarkMode    NOTIFY themeChanged)
    Q_PROPERTY(QString primaryColor READ primaryColor  WRITE setPrimaryColor NOTIFY themeChanged)
    Q_PROPERTY(int    revision      READ revision      NOTIFY themeChanged)

public:
    explicit ThemeBackend(QObject *parent = nullptr);

    bool    isDarkMode()    const;
    QString primaryColor()  const;
    int     revision()      const;          // increments on every change — QML rebind trigger

    void setDarkMode(bool dark);
    void setPrimaryColor(const QString &color);

    Q_INVOKABLE void resetToDefaults();     // callable from QML
    Q_INVOKABLE void applyTheme(bool dark, const QString &primary);  // atomic batch set

signals:
    void themeChanged();

private:
    void saveConfig();
    void loadConfig();
    void scheduleReload();                  // debounced file-change handler

    bool    m_isDarkMode;
    QString m_primaryColor;
    int     m_revision = 0;

    QString             m_configPath;
    QFileSystemWatcher *m_watcher  = nullptr;
    QTimer             *m_debounce = nullptr;

    static constexpr const char* DEFAULT_PRIMARY = "#386a20";
};

// ─── QML Plugin Registration ──────────────────────────────
class ChiPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)

public:
    void registerTypes(const char *uri) override;
};

#endif // CHI_H
