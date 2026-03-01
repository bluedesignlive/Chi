// qml/smartui/ui/applicationwindow/SmartApplicationWindow.qml
//
// SmartUI — Optimized frameless Material 3 application window
//
// Removed:  Qt5Compat.GraphicalEffects, DropShadow, OpacityMask,
//           8× MSAA FBO, phantom nodes, windowMargin, double border
// Added:    QtQuick.Effects (MultiEffect), debounced breakpoint,
//           lazy resize handles, phone-size minimum, SmartTheme

import QtQuick
import QtQuick.Window
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Effects
import "../../theme" as Theme
import "../common"

Window {
    id: root

    visible: true
    color: "transparent"
    flags: Qt.Window | Qt.FramelessWindowHint

    // ═══════════════════════════════════════════════════════════════
    // PHONE-SIZE MINIMUM — smallest usable handset viewport
    // ═══════════════════════════════════════════════════════════════

    minimumWidth: 360
    minimumHeight: 540

    // ═══════════════════════════════════════════════════════════════
    // CORE PROPERTIES
    // ═══════════════════════════════════════════════════════════════

    property string title: "Application"
    property bool showControls: true

    // Compatibility: consumers use  colors.primary, colors.background …
    // SmartTheme exposes colours as top-level props so this just works.
    property var colors: Theme.SmartTheme

    // ═══════════════════════════════════════════════════════════════
    // TOOLBAR CONFIGURATION
    // ═══════════════════════════════════════════════════════════════

    property string leadingIcon: ""
    property bool showTitle: true
    property bool centerTitle: true
    property bool autoHideTitle: true
    property int toolbarHeight: 48
    property bool toolbarVisible: true
    property string toolbarBehavior: "visible"
    property list<QtObject> toolbarActions: []

    // ═══════════════════════════════════════════════════════════════
    // MENU SYSTEM
    // ═══════════════════════════════════════════════════════════════

    property string menuStyle: "auto"
    property string collapsedMenuIcon: "menu"
    property var customMenus: []
    property bool showDefaultMenus: true
    property bool showMenuButton: true

    // ═══════════════════════════════════════════════════════════════
    // SIDEBAR
    // ═══════════════════════════════════════════════════════════════

    property bool showSidebarButton: false
    property bool sidebarOpen: false

    // ═══════════════════════════════════════════════════════════════
    // WINDOW CONTROLS STYLE
    // ═══════════════════════════════════════════════════════════════

    property string controlsStyle: "macOS"
    readonly property bool controlsOnLeft: controlsStyle === "macOS"

    // ═══════════════════════════════════════════════════════════════
    // CONTENT
    // ═══════════════════════════════════════════════════════════════

    default property alias content: contentContainer.data

    // ═══════════════════════════════════════════════════════════════
    // SIGNALS
    // ═══════════════════════════════════════════════════════════════

    signal leadingActionTriggered()
    signal toolbarActionTriggered(int index)
    signal menuItemTriggered(string menuId, string itemId)
    signal sidebarButtonClicked()
    signal breakpointChanged(string breakpoint)

    // ═══════════════════════════════════════════════════════════════
    // RESPONSIVE CONTEXT — debounced breakpoint (80 ms)
    //
    // Eliminates per-pixel binding cascade during resize.
    // Boolean helpers removed; use  context.breakpoint === "compact"
    // at call sites (zero-cost when not evaluated).
    // ═══════════════════════════════════════════════════════════════

    readonly property QtObject context: QtObject {
        id: ctx

        readonly property bool isMacOS:   Qt.platform.os === "osx"
        readonly property bool isWindows: Qt.platform.os === "windows"
        readonly property bool isLinux:   Qt.platform.os === "linux"
        readonly property bool isMobile:  Qt.platform.os === "android" || Qt.platform.os === "ios"
        readonly property bool isWeb:     Qt.platform.os === "wasm"
        readonly property bool isDesktop: !isMobile && !isWeb

        readonly property int windowWidth:  root.width
        readonly property int windowHeight: root.height

        property string breakpoint: "expanded"

        // ── Compat booleans (kept as functions to avoid 5 idle bindings) ──
        readonly property bool isCompact:  breakpoint === "compact"
        readonly property bool isMedium:   breakpoint === "medium"
        readonly property bool isExpanded: breakpoint === "expanded"
        readonly property bool isLarge:    breakpoint === "large"
        readonly property bool isXLarge:   breakpoint === "xlarge"

        readonly property bool showWindowControls: isDesktop && !isWeb
        readonly property bool useOverlaySidebar:  breakpoint === "compact" || breakpoint === "medium"

        function _recalcBreakpoint() {
            var w = root.width
            var bp = w < 600  ? "compact"
                   : w < 840  ? "medium"
                   : w < 1200 ? "expanded"
                   : w < 1600 ? "large"
                   : "xlarge"
            if (breakpoint !== bp) {
                breakpoint = bp
                root.breakpointChanged(bp)
            }
        }
    }

    Timer {
        id: breakpointTimer
        interval: 80
        onTriggered: ctx._recalcBreakpoint()
    }

    onWidthChanged: breakpointTimer.restart()
    Component.onCompleted: ctx._recalcBreakpoint()

    // ═══════════════════════════════════════════════════════════════
    // INTERNAL STATE
    //
    // windowMargin REMOVED — the visible surface now fills the real
    // Window rect so resize cursors sit at true edges and compositor
    // snapping behaves correctly.
    // ═══════════════════════════════════════════════════════════════

    readonly property bool isMaximized:  visibility === Window.Maximized
    readonly property real windowRadius: isMaximized ? 0 : 24

    readonly property string _effectiveMenuStyle: {
        if (menuStyle !== "auto") return menuStyle
        return root.width < (_allMenus.length * 60 + _rightSectionWidth + 60)
            ? "collapsed" : "traditional"
    }

    readonly property real _rightSectionWidth:
        (toolbarActions.length * 40) + (controlsOnLeft ? 0 : 110)

    property bool _toolbarAutoHidden: false

    readonly property bool _showToolbar: {
        if (!toolbarVisible) return false
        if (toolbarBehavior === "autoHide")
            return !_toolbarAutoHidden || toolbarHoverArea.containsMouse
        return true
    }

    // ═══════════════════════════════════════════════════════════════
    // DEFAULT MENUS
    // ═══════════════════════════════════════════════════════════════

    readonly property var _defaultMenus: [
        {
            id: "file", title: "File",
            items: [
                { id: "new",    text: "New",         shortcut: "Ctrl+N",       icon: "add" },
                { id: "open",   text: "Open",        shortcut: "Ctrl+O",       icon: "folder_open" },
                { type: "divider" },
                { id: "save",   text: "Save",        shortcut: "Ctrl+S",       icon: "save" },
                { id: "saveAs", text: "Save As\u2026", shortcut: "Ctrl+Shift+S" },
                { type: "divider" },
                { id: "exit",   text: "Exit",        shortcut: "Alt+F4",       icon: "logout" }
            ]
        },
        {
            id: "edit", title: "Edit",
            items: [
                { id: "undo",  text: "Undo",  shortcut: "Ctrl+Z", icon: "undo" },
                { id: "redo",  text: "Redo",  shortcut: "Ctrl+Y", icon: "redo" },
                { type: "divider" },
                { id: "cut",   text: "Cut",   shortcut: "Ctrl+X", icon: "content_cut" },
                { id: "copy",  text: "Copy",  shortcut: "Ctrl+C", icon: "content_copy" },
                { id: "paste", text: "Paste", shortcut: "Ctrl+V", icon: "content_paste" }
            ]
        },
        {
            id: "view", title: "View",
            items: [
                { id: "sidebar",          text: "Toggle Sidebar",   shortcut: "Ctrl+B", icon: "view_sidebar" },
                { type: "divider" },
                { id: "menu_auto",        text: "Auto Menu",        icon: "tune" },
                { id: "menu_traditional", text: "Traditional Menu",  icon: "menu_open" },
                { id: "menu_collapsed",   text: "Collapsed Menu",   icon: "menu" },
                { type: "divider" },
                { id: "icon_hamburger",   text: "Hamburger Icon",   icon: "menu" },
                { id: "icon_dots",        text: "Dots Icon",        icon: "more_horiz" }
            ]
        },
        {
            id: "help", title: "Help",
            items: [
                { id: "docs",      text: "Documentation",      icon: "menu_book" },
                { id: "shortcuts", text: "Keyboard Shortcuts",  icon: "keyboard" },
                { type: "divider" },
                { id: "about",     text: "About",              icon: "info" }
            ]
        }
    ]

    // Single native concat — no per-frame JS loop / array allocation
    readonly property var _allMenus: showDefaultMenus
        ? _defaultMenus.concat(customMenus)
        : customMenus

    // ═══════════════════════════════════════════════════════════════
    // CORNER MASK
    //
    // Tiny FBO containing only a solid rounded rect (no children).
    // Disabled when maximized → zero cost.
    // ═══════════════════════════════════════════════════════════════

    Rectangle {
        id: cornerMask
        anchors.fill: parent
        radius: windowRadius
        color: "#FFFFFF"
        visible: false
        layer.enabled: windowRadius > 0
    }

    // ═══════════════════════════════════════════════════════════════
    // MAIN WINDOW SURFACE
    //
    // Fills the entire Window (no margin) so:
    //   • Resize cursors appear at the real window edge
    //   • Compositor snap/tile aligns to what the user sees
    //   • Shadow is delegated to the compositor (Mutter / KWin)
    //
    // MultiEffect mask replaces the old OpacityMask + 8× MSAA FBO.
    // When maximized radius is 0 → layer.enabled false → free.
    // ═══════════════════════════════════════════════════════════════

    Item {
        id: windowSurface
        anchors.fill: parent

        layer.enabled: windowRadius > 0
        layer.smooth: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: cornerMask
            maskThresholdMin: 0.5
            maskSpreadAtMin: 0.5
        }

        // ─── Background fill ────────────────────────────────
        Rectangle {
            anchors.fill: parent
            color: colors.background
        }

        // ═════════════════════════════════════════════════════
        // AUTO-HIDE HOVER ZONE
        //
        // Disabled + invisible when not in autoHide mode so it
        // never participates in hit-testing or hover tracking.
        // ═════════════════════════════════════════════════════

        MouseArea {
            id: toolbarHoverArea
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: root.toolbarBehavior === "autoHide" && root._toolbarAutoHidden ? 12 : 0
            hoverEnabled: root.toolbarBehavior === "autoHide"
            enabled:      root.toolbarBehavior === "autoHide"
            visible:      root.toolbarBehavior === "autoHide"
            z: 101
        }

        // ═════════════════════════════════════════════════════
        // TOOLBAR
        // ═════════════════════════════════════════════════════

        Rectangle {
            id: toolbar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: root._showToolbar ? root.toolbarHeight : 0
            color: colors.surfaceContainer
            clip: true
            visible: height > 0
            z: 100

            Behavior on height {
                NumberAnimation {
                    duration: Theme.SmartTheme.motion.durationShort4
                    easing.type: Easing.OutCubic
                }
            }

            // ─── Drag to move / double-click to maximize ────
            MouseArea {
                anchors.fill: parent
                z: -1
                onPressed: root.startSystemMove()
                onDoubleClicked: {
                    if (root.isMaximized) root.showNormal()
                    else root.showMaximized()
                }
            }

            // ═══ LEFT SECTION ═══════════════════════════════
            Item {
                id: leftSection
                anchors.left: parent.left
                anchors.leftMargin: Theme.SmartTheme.spacing.lg
                anchors.verticalCenter: parent.verticalCenter
                width: leftRow.implicitWidth
                height: parent.height

                Row {
                    id: leftRow
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Theme.SmartTheme.spacing.xs

                    WindowControls {
                        visible: root.showControls && root.controlsOnLeft && root.context.showWindowControls
                        targetWindow: root
                        variant: root.controlsStyle
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Item {
                        width: Theme.SmartTheme.spacing.sm
                        height: 1
                        visible: root.controlsOnLeft && root.showControls && root.context.showWindowControls
                    }

                    ToolbarIconButton {
                        visible: root.showMenuButton && root._effectiveMenuStyle === "collapsed"
                        iconName: root.collapsedMenuIcon
                        onClicked: overflowMenu.open()

                        OverflowMenu {
                            id: overflowMenu
                            menus: root._allMenus
                            maxHeight: root.height - 100
                            onItemTriggered: (menuId, itemId) => root._handleMenuAction(menuId, itemId)
                        }
                    }

                    ToolbarIconButton {
                        visible: root.showSidebarButton
                        iconName: "view_sidebar"
                        checked: root.sidebarOpen
                        onClicked: root.sidebarButtonClicked()
                    }

                    ToolbarIconButton {
                        visible: root.leadingIcon !== ""
                        iconName: root.leadingIcon
                        onClicked: root.leadingActionTriggered()
                    }

                    Row {
                        id: traditionalMenuRow
                        visible: root._effectiveMenuStyle === "traditional"
                        spacing: 0
                        anchors.verticalCenter: parent.verticalCenter

                        Repeater {
                            model: root._allMenus

                            MenuBarButton {
                                menuData: modelData
                                onItemTriggered: (itemId) => root._handleMenuAction(modelData.id, itemId)
                            }
                        }
                    }
                }
            }

            // ═══ RIGHT SECTION ══════════════════════════════
            Item {
                id: rightSection
                anchors.right: parent.right
                anchors.rightMargin: Theme.SmartTheme.spacing.lg
                anchors.verticalCenter: parent.verticalCenter
                width: rightRow.implicitWidth
                height: parent.height

                Row {
                    id: rightRow
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Theme.SmartTheme.spacing.xs

                    Repeater {
                        model: root.toolbarActions

                        ToolbarIconButton {
                            iconName: modelData.icon || ""
                            checked: modelData.checked || false
                            enabled: modelData.enabled !== false
                            onClicked: {
                                if (modelData.triggered) modelData.triggered()
                                root.toolbarActionTriggered(index)
                            }
                        }
                    }

                    Item {
                        width: Theme.SmartTheme.spacing.sm
                        height: 1
                        visible: !root.controlsOnLeft && root.showControls && root.context.showWindowControls
                    }

                    WindowControls {
                        visible: root.showControls && !root.controlsOnLeft && root.context.showWindowControls
                        targetWindow: root
                        variant: root.controlsStyle
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            // ═══ CENTER TITLE ═══════════════════════════════
            Text {
                id: titleText
                visible: root.showTitle && !_titleCollides
                anchors.verticalCenter: parent.verticalCenter

                text: root.title
                font.family: "Roboto"
            font.weight: Font.Medium
            font.pixelSize: 14
                color: colors.onSurface
                elide: Text.ElideRight

                readonly property real leftEdge:  leftSection.x + leftSection.width + 16
                readonly property real rightEdge: rightSection.x - 16
                readonly property real space:     Math.max(0, rightEdge - leftEdge)

                width: Math.min(implicitWidth, space)

                x: root.centerTitle
                    ? Math.max(leftEdge, (toolbar.width - implicitWidth) / 2)
                    : leftEdge

                readonly property bool _titleCollides: {
                    if (!root.autoHideTitle) return false
                    if (space < 80) return true
                    if (!root.centerTitle) return false
                    var cx = (toolbar.width - implicitWidth) / 2
                    return cx < leftEdge + 20 || cx + implicitWidth > rightEdge - 20
                }
            }
        }

        // ═════════════════════════════════════════════════════
        // CONTENT AREA
        // ═════════════════════════════════════════════════════

        Item {
            id: contentContainer
            anchors.top: toolbar.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            clip: true
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // WINDOW BORDER — single rectangle (no double-border overdraw)
    // ═══════════════════════════════════════════════════════════════

    Rectangle {
        anchors.fill: parent
        radius: windowRadius
        color: "transparent"
        border.width: 1
        border.color: Qt.rgba(colors.shadow.r, colors.shadow.g, colors.shadow.b, 0.15)
        visible: !root.isMaximized
        z: 1000
    }

    // ═══════════════════════════════════════════════════════════════
    // RESIZE HANDLES — lazy-loaded, destroyed when maximized
    // ═══════════════════════════════════════════════════════════════

    Loader {
        active: !root.isMaximized
        anchors.fill: parent
        z: 1010

        sourceComponent: Item {
            id: resizeItem
            property int edge:   6
            property int corner: 20

            // ─── Edges ──────────────────────────────────────
            MouseArea {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: resizeItem.edge
                cursorShape: Qt.SizeVerCursor
                onPressed: root.startSystemResize(Qt.TopEdge)
            }
            MouseArea {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: resizeItem.edge
                cursorShape: Qt.SizeVerCursor
                onPressed: root.startSystemResize(Qt.BottomEdge)
            }
            MouseArea {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: resizeItem.edge
                cursorShape: Qt.SizeHorCursor
                onPressed: root.startSystemResize(Qt.LeftEdge)
            }
            MouseArea {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: resizeItem.edge
                cursorShape: Qt.SizeHorCursor
                onPressed: root.startSystemResize(Qt.RightEdge)
            }

            // ─── Corners ────────────────────────────────────
            MouseArea {
                anchors.top: parent.top; anchors.left: parent.left
                width: resizeItem.corner; height: resizeItem.corner
                cursorShape: Qt.SizeFDiagCursor
                onPressed: root.startSystemResize(Qt.TopEdge | Qt.LeftEdge)
            }
            MouseArea {
                anchors.top: parent.top; anchors.right: parent.right
                width: resizeItem.corner; height: resizeItem.corner
                cursorShape: Qt.SizeBDiagCursor
                onPressed: root.startSystemResize(Qt.TopEdge | Qt.RightEdge)
            }
            MouseArea {
                anchors.bottom: parent.bottom; anchors.left: parent.left
                width: resizeItem.corner; height: resizeItem.corner
                cursorShape: Qt.SizeBDiagCursor
                onPressed: root.startSystemResize(Qt.BottomEdge | Qt.LeftEdge)
            }
            MouseArea {
                anchors.bottom: parent.bottom; anchors.right: parent.right
                width: resizeItem.corner; height: resizeItem.corner
                cursorShape: Qt.SizeFDiagCursor
                onPressed: root.startSystemResize(Qt.BottomEdge | Qt.RightEdge)
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // TOOLBAR ICON BUTTON — uses Icon component (embedded font)
    // ═══════════════════════════════════════════════════════════════

    component ToolbarIconButton: Item {
        id: toolBtn
        property string iconName: ""
        property bool checked: false
        property alias enabled: toolBtnMouse.enabled
        signal clicked()

        implicitWidth: 36; implicitHeight: 36
        width: 36; height: 36
        opacity: enabled ? 1.0 : Theme.SmartTheme.stateLayer.dragged

        Rectangle {
            anchors.fill: parent
            radius: Theme.SmartTheme.shape.medium
            color: {
                if (toolBtn.checked)
                    return colors.secondaryContainer
                if (toolBtnMouse.pressed)
                    return Qt.rgba(colors.primary.r, colors.primary.g, colors.primary.b,
                                   Theme.SmartTheme.stateLayer.pressed)
                if (toolBtnMouse.containsMouse)
                    return Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b,
                                   Theme.SmartTheme.stateLayer.hover)
                return "transparent"
            }
        }

        Icon {
            anchors.centerIn: parent
            source: toolBtn.iconName
            size: 20
            color: toolBtn.checked ? colors.onSecondaryContainer : colors.onSurfaceVariant
        }

        MouseArea {
            id: toolBtnMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: toolBtn.clicked()
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // MENU BAR BUTTON
    // ═══════════════════════════════════════════════════════════════

    component MenuBarButton: Item {
        id: menuBtn
        property var menuData: ({})
        signal itemTriggered(string itemId)

        implicitWidth: menuLabel.implicitWidth + 20
        implicitHeight: 36
        width: implicitWidth; height: 36

        Rectangle {
            anchors.fill: parent
            radius: Theme.SmartTheme.shape.small
            color: menuBtnMouse.containsMouse || dropdownMenu.visible
                ? Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b,
                           Theme.SmartTheme.stateLayer.hover)
                : "transparent"
        }

        Text {
            id: menuLabel
            anchors.centerIn: parent
            text: menuData.title || ""
            font.family: "Roboto"
            font.pixelSize: 13
            font.weight: Font.Medium
            color: colors.onSurface
        }

        MouseArea {
            id: menuBtnMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: dropdownMenu.open()
        }

        DropdownMenu {
            id: dropdownMenu
            y: parent.height + 4
            items: menuData.items || []
            onItemClicked: (itemId) => menuBtn.itemTriggered(itemId)
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // PUBLIC API  (unchanged — full backward compat)
    // ═══════════════════════════════════════════════════════════════

    function showToolbar() {
        toolbarVisible = true
        _toolbarAutoHidden = false
    }
    function hideToolbar() {
        if (toolbarBehavior === "autoHide") _toolbarAutoHidden = true
        else toolbarVisible = false
    }
    function toggleToolbar() {
        if (toolbarBehavior === "autoHide") _toolbarAutoHidden = !_toolbarAutoHidden
        else toolbarVisible = !toolbarVisible
    }
    function setMenuStyle(style) { menuStyle = style }

    function _handleMenuAction(menuId, itemId) {
        menuItemTriggered(menuId, itemId)

        if (menuId === "view") {
            switch (itemId) {
                case "sidebar":          sidebarButtonClicked(); break
                case "menu_auto":        menuStyle = "auto"; break
                case "menu_traditional": menuStyle = "traditional"; break
                case "menu_collapsed":   menuStyle = "collapsed"; break
                case "icon_hamburger":   collapsedMenuIcon = "menu"; break
                case "icon_dots":        collapsedMenuIcon = "more_horiz"; break
            }
        } else if (menuId === "file" && itemId === "exit") {
            root.close()
        }
    }
}
