#include "chi.h"
#include <QDebug>
#include <QColor>
#include <QGuiApplication>

#ifdef Q_OS_LINUX
#include <QDBusInterface>
#include <QDBusMessage>
#include <QDBusReply>
#endif

// ═══════════════════════════════════════════════════════════════════
//  ThemeBackend
// ═══════════════════════════════════════════════════════════════════

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

// ═══════════════════════════════════════════════════════════════════
//  ChiDBusMenuBridge
// ═══════════════════════════════════════════════════════════════════

ChiDBusMenuBridge::ChiDBusMenuBridge(QObject *parent)
    : QObject(parent)
#ifdef Q_OS_LINUX
    , m_sessionBus(QDBusConnection::sessionBus())
#endif
{
#ifdef Q_OS_LINUX
    QDBusInterface registrar(
        QStringLiteral("com.canonical.AppMenu.Registrar"),
        QStringLiteral("/com/canonical/AppMenu/Registrar"),
        QStringLiteral("com.canonical.AppMenu.Registrar"),
        m_sessionBus);
    m_available = registrar.isValid();
    if (m_available)
        m_menuObjectPath = QStringLiteral("/com/chi/dbusmenu/w%1")
            .arg(reinterpret_cast<quintptr>(this), 0, 16);
#endif
}

ChiDBusMenuBridge::~ChiDBusMenuBridge() { tryUnregister(); }

QQuickWindow *ChiDBusMenuBridge::window() const { return m_window; }
void ChiDBusMenuBridge::setWindow(QQuickWindow *win) {
    if (m_window == win) return;
    if (m_window) {
        disconnect(m_window, &QQuickWindow::visibleChanged, this, &ChiDBusMenuBridge::onWindowVisibleChanged);
        tryUnregister();
    }
    m_window = win;
    emit windowChanged();
    if (m_window) {
        connect(m_window, &QQuickWindow::visibleChanged, this, &ChiDBusMenuBridge::onWindowVisibleChanged);
        if (m_window->isVisible()) tryRegister();
    }
}

QVariantList ChiDBusMenuBridge::menuModel() const { return m_menuModel; }
void ChiDBusMenuBridge::setMenuModel(const QVariantList &model) {
    m_menuModel = model;
    emit menuModelChanged();
    rebuildMenuTree();
}

bool ChiDBusMenuBridge::isRegistered() const { return m_registered; }
bool ChiDBusMenuBridge::isAvailable() const { return m_available; }

void ChiDBusMenuBridge::onWindowVisibleChanged() {
    if (!m_window) return;
    if (m_window->isVisible()) tryRegister(); else tryUnregister();
}

void ChiDBusMenuBridge::tryRegister() {
#ifdef Q_OS_LINUX
    if (m_registered || !m_available || !m_window || !m_window->isVisible()) return;
    m_windowId = static_cast<uint32_t>(m_window->winId());
    if (m_windowId == 0) return;
    if (!m_exporter) m_exporter = new ChiDBusMenuExporter(this, this);
    bool ok = m_sessionBus.registerObject(m_menuObjectPath, m_exporter,
        QDBusConnection::ExportAllSlots | QDBusConnection::ExportAllSignals | QDBusConnection::ExportAllProperties);
    if (!ok) { qWarning() << "ChiDBusMenuBridge: failed to register" << m_menuObjectPath; return; }
    rebuildMenuTree();
    QDBusMessage msg = QDBusMessage::createMethodCall(
        QStringLiteral("com.canonical.AppMenu.Registrar"),
        QStringLiteral("/com/canonical/AppMenu/Registrar"),
        QStringLiteral("com.canonical.AppMenu.Registrar"),
        QStringLiteral("RegisterWindow"));
    msg << m_windowId << QDBusObjectPath(m_menuObjectPath);
    QDBusReply<void> reply = m_sessionBus.call(msg);
    if (reply.isValid()) { m_registered = true; emit registeredChanged(); }
    else { qWarning() << "ChiDBusMenuBridge: RegisterWindow failed:" << reply.error().message(); m_sessionBus.unregisterObject(m_menuObjectPath); }
#endif
}

void ChiDBusMenuBridge::tryUnregister() {
#ifdef Q_OS_LINUX
    if (!m_registered) return;
    QDBusMessage msg = QDBusMessage::createMethodCall(
        QStringLiteral("com.canonical.AppMenu.Registrar"),
        QStringLiteral("/com/canonical/AppMenu/Registrar"),
        QStringLiteral("com.canonical.AppMenu.Registrar"),
        QStringLiteral("UnregisterWindow"));
    msg << m_windowId;
    m_sessionBus.call(msg, QDBus::NoBlock);
    m_sessionBus.unregisterObject(m_menuObjectPath);
    m_registered = false;
    emit registeredChanged();
#endif
}

void ChiDBusMenuBridge::rebuildMenuTree() {
    m_items.clear();
    m_nextId = 1;
    MenuItem root; root.id = 0; root.parentId = -1;
    m_items[0] = root;
    for (const QVariant &menuVar : m_menuModel) {
        QVariantMap menu = menuVar.toMap();
        QString menuId = menu.value(QStringLiteral("id")).toString();
        int topId = m_nextId++;
        MenuItem topItem; topItem.id = topId; topItem.parentId = 0;
        topItem.menuId = menuId; topItem.label = menu.value(QStringLiteral("title")).toString();
        m_items[topId] = topItem; m_items[0].children.append(topId);
        for (const QVariant &itemVar : menu.value(QStringLiteral("items")).toList())
            addMenuItem(itemVar.toMap(), topId, menuId);
    }
#ifdef Q_OS_LINUX
    if (m_exporter) { m_exporter->m_revision++; emit m_exporter->LayoutUpdated(m_exporter->m_revision, 0); }
#endif
}

int ChiDBusMenuBridge::addMenuItem(const QVariantMap &item, int parentId, const QString &menuId) {
    int id = m_nextId++;
    MenuItem mi; mi.id = id; mi.parentId = parentId; mi.menuId = menuId;
    if (item.value(QStringLiteral("type")).toString() == QStringLiteral("divider"))
        mi.isSeparator = true;
    else {
        mi.itemId = item.value(QStringLiteral("id")).toString();
        mi.label = item.value(QStringLiteral("text")).toString();
        mi.shortcut = item.value(QStringLiteral("shortcut")).toString();
        mi.iconName = item.value(QStringLiteral("icon")).toString();
    }
    m_items[id] = mi; m_items[parentId].children.append(id);
    return id;
}

// ═══════════════════════════════════════════════════════════════════
//  ChiDBusMenuExporter
// ═══════════════════════════════════════════════════════════════════

#ifdef Q_OS_LINUX
ChiDBusMenuExporter::ChiDBusMenuExporter(ChiDBusMenuBridge *bridge, QObject *parent)
    : QObject(parent), m_bridge(bridge) {}

QString ChiDBusMenuExporter::textDirection() const {
    return QGuiApplication::isRightToLeft() ? QStringLiteral("rtl") : QStringLiteral("ltr");
}

QVariantMap ChiDBusMenuExporter::getItemProperties(int id, const QStringList &filter) const {
    QVariantMap props;
    auto it = m_bridge->m_items.constFind(id);
    if (it == m_bridge->m_items.constEnd()) return props;
    const auto &item = it.value();
    bool all = filter.isEmpty();
    if (item.isSeparator) {
        if (all || filter.contains(QStringLiteral("type"))) props[QStringLiteral("type")] = QStringLiteral("separator");
        return props;
    }
    if (!item.label.isEmpty() && (all || filter.contains(QStringLiteral("label"))))
        props[QStringLiteral("label")] = item.label;
    if (!item.iconName.isEmpty() && (all || filter.contains(QStringLiteral("icon-name"))))
        props[QStringLiteral("icon-name")] = item.iconName;
    if (!item.shortcut.isEmpty() && (all || filter.contains(QStringLiteral("shortcut")))) {
        QStringList parts = item.shortcut.split(QLatin1Char('+'), Qt::SkipEmptyParts);
        QStringList converted;
        for (const QString &part : parts) {
            QString p = part.trimmed();
            if (p.compare(QStringLiteral("Ctrl"), Qt::CaseInsensitive) == 0) converted << QStringLiteral("Control");
            else if (p.compare(QStringLiteral("Alt"), Qt::CaseInsensitive) == 0) converted << QStringLiteral("Alt");
            else if (p.compare(QStringLiteral("Shift"), Qt::CaseInsensitive) == 0) converted << QStringLiteral("Shift");
            else if (p.compare(QStringLiteral("Meta"), Qt::CaseInsensitive) == 0 || p.compare(QStringLiteral("Super"), Qt::CaseInsensitive) == 0) converted << QStringLiteral("Super");
            else converted << p.toLower();
        }
        QVariantList inner; inner << QVariant(converted);
        props[QStringLiteral("shortcut")] = QVariant(inner);
    }
    if (!item.children.isEmpty() && (all || filter.contains(QStringLiteral("children-display"))))
        props[QStringLiteral("children-display")] = QStringLiteral("submenu");
    return props;
}

QDBusVariant ChiDBusMenuExporter::GetLayout(int parentId, int recursionDepth, const QStringList &propertyNames) {
    std::function<QVariant(int, int)> buildNode = [&](int id, int depth) -> QVariant {
        QVariantMap props = getItemProperties(id, propertyNames);
        QVariantList children;
        if (depth != 0) {
            auto it = m_bridge->m_items.constFind(id);
            if (it != m_bridge->m_items.constEnd())
                for (int childId : it->children) children << buildNode(childId, depth > 0 ? depth - 1 : -1);
        }
        QVariantList node; node << id << props << QVariant(children);
        return QVariant(node);
    };
    QVariantList result; result << m_revision << buildNode(parentId, recursionDepth);
    return QDBusVariant(QVariant(result));
}

QDBusVariant ChiDBusMenuExporter::GetGroupProperties(const QList<int> &ids, const QStringList &propertyNames) {
    QVariantList result;
    for (int id : ids) { QVariantList pair; pair << id << getItemProperties(id, propertyNames); result << QVariant(pair); }
    return QDBusVariant(QVariant(result));
}

QDBusVariant ChiDBusMenuExporter::GetProperty(int id, const QString &name) {
    auto it = m_bridge->m_items.constFind(id);
    if (it != m_bridge->m_items.constEnd()) {
        QVariantMap props = getItemProperties(id, {name});
        if (props.contains(name)) return QDBusVariant(props.value(name));
    }
    return QDBusVariant(QVariant());
}

void ChiDBusMenuExporter::Event(int id, const QString &eventId, const QDBusVariant &data, uint timestamp) {
    Q_UNUSED(data) Q_UNUSED(timestamp)
    if (eventId != QStringLiteral("clicked")) return;
    auto it = m_bridge->m_items.constFind(id);
    if (it != m_bridge->m_items.constEnd() && !it->itemId.isEmpty())
        emit m_bridge->itemActivated(it->menuId, it->itemId);
}

void ChiDBusMenuExporter::EventGroup(const QList<QVariant> &events) {
    for (const QVariant &ev : events) {
        QVariantList parts = ev.toList();
        if (parts.size() >= 4) Event(parts[0].toInt(), parts[1].toString(), QDBusVariant(parts[2]), parts[3].toUInt());
    }
}

bool ChiDBusMenuExporter::AboutToShow(int id) { Q_UNUSED(id) return false; }
QList<int> ChiDBusMenuExporter::AboutToShowGroup(const QList<int> &ids) { Q_UNUSED(ids) return {}; }
#endif

// ═══════════════════════════════════════════════════════════════════
//  ChiPlugin
// ═══════════════════════════════════════════════════════════════════

void ChiPlugin::registerTypes(const char *uri) {
    Q_ASSERT(QLatin1String(uri) == QLatin1String("Chi"));
    qmlRegisterSingletonType<ThemeBackend>(uri, 1, 0, "ThemeBackend",
        [](QQmlEngine *, QJSEngine *) -> QObject * {
            if (!s_instance) s_instance = new ThemeBackend();
            return s_instance;
        });
    qmlRegisterType<ChiDBusMenuBridge>(uri, 1, 0, "ChiDBusMenuBridge");
    qmlRegisterSingletonType<ClipboardHelper>(uri, 1, 0, "ClipboardHelper",
        [](QQmlEngine *, QJSEngine *) -> QObject * {
            return new ClipboardHelper();
        });
}

static ClipboardHelper *s_clipboard = nullptr;

void ChiPlugin::initializeEngine(QQmlEngine *engine, const char *uri) {
    Q_UNUSED(uri)
    if (!s_instance) s_instance = new ThemeBackend();
    engine->rootContext()->setContextProperty("_chiBackend", s_instance);
    if (!s_clipboard) s_clipboard = new ClipboardHelper();
    engine->rootContext()->setContextProperty("_clipboard", s_clipboard);
}
