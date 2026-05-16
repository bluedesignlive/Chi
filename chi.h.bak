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
#include <QQuickWindow>
#include <QVariantList>
#include <QClipboard>
#include <QGuiApplication>
#include <QUrl>

#ifdef Q_OS_LINUX
#include <QDBusConnection>
#include <QDBusObjectPath>
#include <QDBusVariant>
#endif

// ═══════════════════════════════════════════════════════════════════
//  ThemeBackend
// ═══════════════════════════════════════════════════════════════════

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

// ═══════════════════════════════════════════════════════════════════
//  ChiDBusMenuBridge — Global menu for KDE Plasma / Unity / Budgie
//
//  Implements:
//    com.canonical.dbusmenu           — menu tree export
//    com.canonical.AppMenu.Registrar  — window ↔ menu path binding
//
//  Non-Linux: no-op stub (registered/available always false)
// ═══════════════════════════════════════════════════════════════════

class ChiDBusMenuExporter;

class ChiDBusMenuBridge : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQuickWindow* window READ window WRITE setWindow NOTIFY windowChanged)
    Q_PROPERTY(QVariantList menuModel READ menuModel WRITE setMenuModel NOTIFY menuModelChanged)
    Q_PROPERTY(bool registered READ isRegistered NOTIFY registeredChanged)
    Q_PROPERTY(bool available READ isAvailable CONSTANT)

public:
    explicit ChiDBusMenuBridge(QObject *parent = nullptr);
    ~ChiDBusMenuBridge() override;

    QQuickWindow *window() const;
    void setWindow(QQuickWindow *win);
    QVariantList menuModel() const;
    void setMenuModel(const QVariantList &model);
    bool isRegistered() const;
    bool isAvailable() const;

signals:
    void windowChanged();
    void menuModelChanged();
    void registeredChanged();
    void itemActivated(const QString &menuId, const QString &itemId);

private slots:
    void onWindowVisibleChanged();

private:
    void tryRegister();
    void tryUnregister();
    void rebuildMenuTree();

    struct MenuItem {
        int id = 0;
        int parentId = -1;
        QString menuId;
        QString itemId;
        QString label;
        QString shortcut;
        QString iconName;
        bool isSeparator = false;
        QList<int> children;
    };

    int addMenuItem(const QVariantMap &item, int parentId, const QString &menuId);

    QQuickWindow *m_window = nullptr;
    QVariantList m_menuModel;
    bool m_registered = false;
    bool m_available = false;
    QMap<int, MenuItem> m_items;
    int m_nextId = 1;

#ifdef Q_OS_LINUX
    QDBusConnection m_sessionBus;
    QString m_menuObjectPath;
    uint32_t m_windowId = 0;
    ChiDBusMenuExporter *m_exporter = nullptr;
#endif

    friend class ChiDBusMenuExporter;
};

#ifdef Q_OS_LINUX
class ChiDBusMenuExporter : public QObject
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "com.canonical.dbusmenu")
    Q_PROPERTY(uint Version READ version)
    Q_PROPERTY(QString TextDirection READ textDirection)
    Q_PROPERTY(QString Status READ status)
    Q_PROPERTY(QStringList IconThemePath READ iconThemePath)

public:
    explicit ChiDBusMenuExporter(ChiDBusMenuBridge *bridge, QObject *parent = nullptr);

    uint version() const { return 4; }
    QString textDirection() const;
    QString status() const { return QStringLiteral("normal"); }
    QStringList iconThemePath() const { return {}; }

public slots:
    QDBusVariant GetLayout(int parentId, int recursionDepth, const QStringList &propertyNames);
    QDBusVariant GetGroupProperties(const QList<int> &ids, const QStringList &propertyNames);
    QDBusVariant GetProperty(int id, const QString &name);
    void Event(int id, const QString &eventId, const QDBusVariant &data, uint timestamp);
    void EventGroup(const QList<QVariant> &events);
    bool AboutToShow(int id);
    QList<int> AboutToShowGroup(const QList<int> &ids);

signals:
    void ItemsPropertiesUpdated(const QList<QVariant> &updatedProps, const QList<QVariant> &removedProps);
    void LayoutUpdated(uint revision, int parent);
    void ItemActivationRequested(int id, uint timestamp);

private:
    QVariantMap getItemProperties(int id, const QStringList &filter) const;
    ChiDBusMenuBridge *m_bridge;
    uint m_revision = 1;
    friend class ChiDBusMenuBridge;
};
#endif

// ═══════════════════════════════════════════════════════════════════
//  ClipboardHelper — exposes QClipboard to QML
// ═══════════════════════════════════════════════════════════════════

class ClipboardHelper : public QObject
{
    Q_OBJECT
public:
    explicit ClipboardHelper(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE void copyImage(const QUrl &imageUrl) {
        QImage img(imageUrl.toLocalFile());
        if (!img.isNull())
            QGuiApplication::clipboard()->setImage(img);
    }

    Q_INVOKABLE QString picturesDir() const {
        return QStandardPaths::writableLocation(QStandardPaths::PicturesLocation);
    }
};

// ═══════════════════════════════════════════════════════════════════
//  ChiPlugin
// ═══════════════════════════════════════════════════════════════════

class ChiPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)
public:
    void registerTypes(const char *uri) override;
    void initializeEngine(QQmlEngine *engine, const char *uri) override;
};

#endif
