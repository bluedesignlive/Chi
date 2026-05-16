// ChiApplicationWindow.qml — Material 3 Frameless Application Window
//
// Title:    ElideMiddle truncation, smooth fade, auto-hide at minimum
// Menu:     Overflow (⋯) default with more_horiz, traditional optional
// Toolbar:  Auto-hide with floating window controls bubble
// Global:   menuModel for ChiDBusMenuBridge (Canonical/KDE AppMenu)
// Resize:   Persistent handles, hoverEnabled, wide hit zones
// A11y:     Keyboard-initiated focus rings, tab nav, shortcuts

import QtQuick
import QtQuick.Window
import QtQuick.Controls.Basic
import QtQuick.Effects
import "../../theme" as Theme
import "../common"
import "../menus" as Menus

Window {
    id: root

    visible: true
    color: "transparent"
    flags: Qt.Window | Qt.FramelessWindowHint

    minimumWidth: 360
    minimumHeight: 540

    // ═══════════════════════════════════════════════════════════════
    //  CORE
    // ═══════════════════════════════════════════════════════════════

    property string title: "Application"
    property bool showControls: true
    property var colors: Theme.ChiTheme.colors
    readonly property string fontFamily: Theme.ChiTheme.fontFamily
    readonly property var typography: Theme.ChiTheme.typography
    readonly property var motion: Theme.ChiTheme.motion

    // ═══════════════════════════════════════════════════════════════
    //  TOOLBAR
    // ═══════════════════════════════════════════════════════════════

    property string leadingIcon: ""
    property string leadingTooltip: "Back"
    property bool showTitle: true
    property bool centerTitle: true
    property bool autoHideTitle: true
    property int toolbarHeight: 48
    property bool toolbarVisible: true
    property string toolbarBehavior: "visible"      // "visible" | "autoHide"
    property list<QtObject> toolbarActions: []
    property int titleMinChars: 4

    // ═══════════════════════════════════════════════════════════════
    //  MENU SYSTEM
    //
    //  showMenu: false  → clean toolbar, no menus
    //  showMenu: true   →
    //    "overflow"      — ⋯ button (more_horiz) with dropdown (DEFAULT)
    //    "traditional"   — text labels in toolbar
    //    "auto"          — traditional when space allows, else overflow
    // ═══════════════════════════════════════════════════════════════

    property bool   showMenu: true
    property string menuStyle: "overflow"
    property var    customMenus: []
    property bool   showDefaultMenus: true

    // ═══════════════════════════════════════════════════════════════
    //  GLOBAL MENU  (DBus / Platform)
    // ═══════════════════════════════════════════════════════════════

    property bool globalMenuActive: false
    readonly property var menuModel: _allMenus
    signal globalMenuItemActivated(string menuId, string itemId)

    // ═══════════════════════════════════════════════════════════════
    //  SIDEBAR
    // ═══════════════════════════════════════════════════════════════

    property bool showSidebarButton: false
    property bool sidebarOpen: false

    // ═══════════════════════════════════════════════════════════════
    //  WINDOW CONTROLS
    // ═══════════════════════════════════════════════════════════════

    property string controlsStyle: "macOS"
    readonly property bool controlsOnLeft: controlsStyle === "macOS"

    // ═══════════════════════════════════════════════════════════════
    //  CONTENT
    // ═══════════════════════════════════════════════════════════════

    default property alias content: _contentContainer.data

    // ═══════════════════════════════════════════════════════════════
    //  SIGNALS
    // ═══════════════════════════════════════════════════════════════

    signal leadingActionTriggered()
    signal toolbarActionTriggered(int index)
    signal menuItemTriggered(string menuId, string itemId)
    signal sidebarButtonClicked()
    signal breakpointChanged(string breakpoint)

    // ═══════════════════════════════════════════════════════════════
    //  CONTEXT
    // ═══════════════════════════════════════════════════════════════

    readonly property QtObject context: QtObject {
        id: _ctx

        readonly property bool isMacOS:   Qt.platform.os === "osx"
        readonly property bool isWindows: Qt.platform.os === "windows"
        readonly property bool isLinux:   Qt.platform.os === "linux"
        readonly property bool isMobile:  Qt.platform.os === "android"
                                          || Qt.platform.os === "ios"
        readonly property bool isWeb:     Qt.platform.os === "wasm"
        readonly property bool isDesktop: !isMobile && !isWeb

        readonly property int windowWidth:  root.width
        readonly property int windowHeight: root.height

        property string breakpoint: "expanded"

        readonly property bool isCompact:  breakpoint === "compact"
        readonly property bool isMedium:   breakpoint === "medium"
        readonly property bool isExpanded: breakpoint === "expanded"
        readonly property bool isLarge:    breakpoint === "large"
        readonly property bool isXLarge:   breakpoint === "xlarge"

        readonly property bool showWindowControls: isDesktop && !isWeb
        readonly property bool useOverlaySidebar:  isCompact || isMedium

        readonly property bool globalMenuAvailable: {
            if (isMacOS) return true
            if (isLinux) {
                var desktop = (Qt.runtime.environmentVariable("XDG_CURRENT_DESKTOP") || "").toLowerCase()
                var session = (Qt.runtime.environmentVariable("DESKTOP_SESSION") || "").toLowerCase()
                return desktop.indexOf("kde") >= 0
                    || desktop.indexOf("plasma") >= 0
                    || desktop.indexOf("unity") >= 0
                    || desktop.indexOf("budgie") >= 0
                    || Qt.runtime.environmentVariable("UBUNTU_MENUPROXY") !== ""
            }
            return false
        }

        onBreakpointChanged: root.breakpointChanged(breakpoint)

        function _recalc() {
            var w  = root.width
            var bp = w < 600  ? "compact"
                   : w < 840  ? "medium"
                   : w < 1200 ? "expanded"
                   : w < 1600 ? "large"
                   :            "xlarge"
            if (breakpoint !== bp) breakpoint = bp
        }
    }

    Timer { id: _bpDebounce; interval: 80; onTriggered: _ctx._recalc() }
    onWidthChanged: _bpDebounce.restart()
    Component.onCompleted: _ctx._recalc()

    // ═══════════════════════════════════════════════════════════════
    //  KEYBOARD-INITIATED FOCUS TRACKING
    //
    //  Focus rings only appear after the user presses Tab, arrow keys,
    //  or F10. They disappear on any mouse click. This matches GNOME,
    //  KDE, macOS, and Windows native behavior.
    // ═══════════════════════════════════════════════════════════════

    property bool _keyboardFocusActive: false

    Shortcut {
        sequence: "Tab"
        context: Qt.ApplicationShortcut
        onActivated: { root._keyboardFocusActive = true }
    }

    // Detect mouse clicks anywhere to exit keyboard focus mode
    MouseArea {
        anchors.fill: parent
        z: -100
        acceptedButtons: Qt.AllButtons
        hoverEnabled: false
        onPressed: function(mouse) {
            root._keyboardFocusActive = false
            mouse.accepted = false  // pass through
        }
    }

    // ═══════════════════════════════════════════════════════════════
    //  INTERNAL STATE
    // ═══════════════════════════════════════════════════════════════

    readonly property bool isMaximized:  visibility === Window.Maximized
    readonly property bool isFullScreen: visibility === Window.FullScreen
    readonly property real windowRadius: (isMaximized || isFullScreen) ? 0 : 24

    readonly property string _resolvedMenuStyle: {
        if (!showMenu || globalMenuActive) return "none"
        if (menuStyle === "overflow" || menuStyle === "collapsed") return "overflow"
        if (menuStyle === "traditional") return "traditional"
        var needed = _allMenus.length * 70 + _rightSectionWidth + 100
        return root.width < needed ? "overflow" : "traditional"
    }

    readonly property real _rightSectionWidth:
        (toolbarActions.length * 40) + (controlsOnLeft ? 0 : 120)

    signal openOverflowMenuRequested()
    property bool _toolbarAutoHidden: false
    property bool _anyMenuOpen: false

    readonly property bool _showToolbar: {
        if (isFullScreen) return false
        if (!toolbarVisible) return false
        if (toolbarBehavior === "autoHide")
            return !_toolbarAutoHidden || _hoverTrigger.containsMouse
        return true
    }

    // ═══════════════════════════════════════════════════════════════
    //  DEFAULT MENUS
    // ═══════════════════════════════════════════════════════════════

    readonly property var _defaultMenus: showMenu ? [
        {
            id: "file", title: "File",
            items: [
                { id: "new",    text: "New",       shortcut: "Ctrl+N",       icon: "add" },
                { id: "open",   text: "Open",      shortcut: "Ctrl+O",       icon: "folder_open" },
                { type: "divider" },
                { id: "save",   text: "Save",      shortcut: "Ctrl+S",       icon: "save" },
                { id: "saveAs", text: "Save As…",  shortcut: "Ctrl+Shift+S" },
                { type: "divider" },
                { id: "exit",   text: "Exit",      shortcut: "Alt+F4",       icon: "logout" }
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
                { id: "sidebar",          text: "Toggle Sidebar",      shortcut: "Ctrl+B",       icon: "view_sidebar" },
                { type: "divider" },
                { id: "toolbar_autohide", text: "Auto-Hide Headerbar", shortcut: "Ctrl+Shift+H", icon: "vertical_align_top" },
                { type: "divider" },
                { id: "menu_overflow",    text: "Overflow Menu",       icon: "more_horiz" },
                { id: "menu_traditional", text: "Traditional Menu",    icon: "menu_open" },
                { id: "menu_auto",        text: "Auto Menu",           icon: "tune" }
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
    ] : []

    readonly property var _allMenus: {
        if (!showMenu) return []
        return showDefaultMenus ? _defaultMenus.concat(customMenus) : customMenus
    }

    // ═══════════════════════════════════════════════════════════════
    //  KEYBOARD SHORTCUTS
    // ═══════════════════════════════════════════════════════════════

    Shortcut {
        sequence: "Ctrl+N"
        enabled: root.showMenu && root.showDefaultMenus
        onActivated: root._handleMenuAction("file", "new")
    }
    Shortcut {
        sequence: "Ctrl+O"
        enabled: root.showMenu && root.showDefaultMenus
        onActivated: root._handleMenuAction("file", "open")
    }
    Shortcut {
        sequence: "Ctrl+S"
        enabled: root.showMenu && root.showDefaultMenus
        onActivated: root._handleMenuAction("file", "save")
    }
    Shortcut {
        sequence: "Ctrl+Shift+S"
        enabled: root.showMenu && root.showDefaultMenus
        onActivated: root._handleMenuAction("file", "saveAs")
    }
    Shortcut {
        sequence: "Ctrl+B"
        enabled: root.showSidebarButton
        onActivated: root.sidebarButtonClicked()
    }
    Shortcut {
        sequence: "Ctrl+Shift+H"
        enabled: root.showMenu
        onActivated: root._toggleToolbarAutoHide()
    }
    Shortcut {
        sequence: "F10"
        context: Qt.ApplicationShortcut
        enabled: root.showMenu && root._resolvedMenuStyle === "overflow"
        onActivated: {
            root._keyboardFocusActive = true
            root.openOverflowMenuRequested()
        }
    }

    // ═══════════════════════════════════════════════════════════════
    //  VISUAL TREE
    // ═══════════════════════════════════════════════════════════════

    Rectangle {
        id: _cornerMask
        anchors.fill: parent
        radius: windowRadius
        color: "#FFF"
        visible: false
        layer.enabled: windowRadius > 0
    }

    Item {
        id: _surface
        anchors.fill: parent

        layer.enabled: windowRadius > 0
        layer.smooth: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: _cornerMask
            maskThresholdMin: 0.5
            maskSpreadAtMin: 0.5
        }

        Rectangle {
            anchors.fill: parent
            color: colors.background
        }

        // Auto-hide hover trigger
        MouseArea {
            id: _hoverTrigger
            anchors { top: parent.top; left: parent.left; right: parent.right }
            height: toolbarBehavior === "autoHide" && _toolbarAutoHidden ? 16 : 0
            hoverEnabled: toolbarBehavior === "autoHide"
            enabled:      toolbarBehavior === "autoHide"
            visible:      toolbarBehavior === "autoHide"
            z: 101
            Accessible.ignored: true
        }

        // ═════════════════════════════════════════════════════════
        //  TOOLBAR
        // ═════════════════════════════════════════════════════════

        Rectangle {
            id: _toolbar
            height: root.toolbarHeight
            anchors { top: parent.top; left: parent.left; right: parent.right }
            z: 100
            color: colors.surfaceContainer

            Accessible.role: Accessible.ToolBar
            Accessible.name: "Application toolbar"

            readonly property bool _shouldShow: root._showToolbar
            property real _toolbarOpacity: 0.0
            visible: _toolbarOpacity > 0.001
            opacity: _toolbarOpacity

            on_ShouldShowChanged: {
                if (_shouldShow) {
                    _toolbarOpacity = 0.0
                    visible = true
                    _toolbarOpacity = 1.0
                } else {
                    _toolbarOpacity = 0.0
                }
            }
            on_ToolbarOpacityChanged: {
                if (_toolbarOpacity <= 0.001)
                    visible = false
            }

            Behavior on _toolbarOpacity {
                NumberAnimation {
                    duration: motion.durationMedium
                    easing.type: motion.easeStandard
                }
            }

            // Drag / maximize / window menu
            MouseArea {
                anchors.fill: parent
                z: -1
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onPressed: function(mouse) {
                    root._keyboardFocusActive = false
                    if (mouse.button === Qt.RightButton)
                        _windowMenu.popup(mouse.x, mouse.y)
                    else
                        root.startSystemMove()
                }
                onDoubleClicked: {
                    if (root.isMaximized) root.showNormal()
                    else root.showMaximized()
                }
            }

            // Window menu on right-click title bar
            Menus.ContextMenu {
                id: _windowMenu
                maxWidth: 176
                onOpenChanged: root._anyMenuOpen = open

                Menus.MenuItem {
                    text: "Restore"
                    enabled: root.isMaximized || root.isFullScreen
                    onClicked: root.showNormal()
                }
                Menus.MenuDivider {}
                Menus.MenuItem {
                    text: "Move"
                    onClicked: root.startSystemMove()
                }
                Menus.MenuItem {
                    text: "Size"
                    enabled: !root.isMaximized && !root.isFullScreen
                    onClicked: root.startSystemResize(Qt.BottomEdge | Qt.RightEdge)
                }
                Menus.MenuDivider {}
                Menus.MenuItem {
                    text: "Minimize"
                    onClicked: root.showMinimized()
                }
                Menus.MenuItem {
                    text: "Maximize"
                    enabled: !root.isMaximized && !root.isFullScreen
                    onClicked: root.showMaximized()
                }
                Menus.MenuDivider {}
                Menus.MenuItem {
                    text: "Close"
                    trailingText: "Alt+F4"
                    onClicked: root.close()
                }
            }

            // ═══ LEFT SECTION ═══

            Item {
                id: _leftSection
                anchors {
                    left: parent.left
                    leftMargin: 16
                    verticalCenter: parent.verticalCenter
                }
                width: _leftRow.implicitWidth
                height: parent.height

                Row {
                    id: _leftRow
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 4

                    WindowControls {
                        visible: root.showControls
                                 && root.controlsOnLeft
                                 && _ctx.showWindowControls
                        targetWindow: root
                        variant: root.controlsStyle
                        menuOpen: root._anyMenuOpen
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Item {
                        width: 8; height: 1
                        visible: root.controlsOnLeft
                                 && root.showControls
                                 && _ctx.showWindowControls
                    }

                    // Overflow menu button (⋯)
                    ToolbarIconButton {
                        visible: root._resolvedMenuStyle === "overflow"
                        iconName: "more_horiz"
                        tooltipText: "Application menu (F10)"
                        onClicked: _overflowMenu.open()

                        Accessible.name: "Application menu"
                        Accessible.description: "Press F10 to open"

                        Menus.OverflowMenu {
                            id: _overflowMenu
                            menus: root._allMenus
                            maxHeight: root.height - 100
                            onVisibleChanged: root._anyMenuOpen = visible
                            onItemTriggered: function(menuId, itemId) {
                                root._handleMenuAction(menuId, itemId)
                            }
                        }
                        Connections {
                            target: root
                            function onOpenOverflowMenuRequested() {
                                _overflowMenu.open()
                            }
                        }
                    }

                    ToolbarIconButton {
                        visible: root.showSidebarButton
                        iconName: "view_sidebar"
                        tooltipText: "Toggle sidebar (Ctrl+B)"
                        checked: root.sidebarOpen
                        onClicked: root.sidebarButtonClicked()
                        Accessible.name: root.sidebarOpen ? "Close sidebar" : "Open sidebar"
                    }

                    ToolbarIconButton {
                        visible: root.leadingIcon !== ""
                        iconName: root.leadingIcon
                        tooltipText: root.leadingTooltip
                        onClicked: root.leadingActionTriggered()
                        Accessible.name: root.leadingTooltip
                    }

                    // Traditional menu bar
                    Row {
                        visible: root._resolvedMenuStyle === "traditional"
                        spacing: 0
                        anchors.verticalCenter: parent.verticalCenter

                        Repeater {
                            id: _menuBarRepeater
                            model: root._allMenus

                            MenuBarButton {
                                required property var modelData
                                required property int index
                                menuData: modelData
                                onItemTriggered: function(itemId) {
                                    root._handleMenuAction(modelData.id, itemId)
                                }
                            }
                        }
                    }
                }
            }

            // ═══ RIGHT SECTION ═══

            Item {
                id: _rightSection
                anchors {
                    right: parent.right
                    rightMargin: 16
                    verticalCenter: parent.verticalCenter
                }
                width: _rightRow.implicitWidth
                height: parent.height

                Row {
                    id: _rightRow
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 4

                    Repeater {
                        model: root.toolbarActions

                        ToolbarIconButton {
                            required property var modelData
                            required property int index
                            iconName: modelData.icon || ""
                            tooltipText: modelData.tooltip || ""
                            checked: modelData.checked || false
                            enabled: modelData.enabled !== false
                            Accessible.name: modelData.tooltip || modelData.icon || ("Action " + (index + 1))

                            onClicked: {
                                if (modelData.triggered) modelData.triggered()
                                root.toolbarActionTriggered(index)
                            }
                        }
                    }

                    Item {
                        width: 8; height: 1
                        visible: !root.controlsOnLeft
                                 && root.showControls
                                 && _ctx.showWindowControls
                    }

                    WindowControls {
                        visible: root.showControls
                                 && !root.controlsOnLeft
                                 && _ctx.showWindowControls
                        targetWindow: root
                        variant: root.controlsStyle
                        menuOpen: root._anyMenuOpen
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            // ═══ TITLE ═══
            //
            // Fixed font size from theme (titleSmall). No font scaling.
            //
            // Chain:
            //   1. Full text at theme size
            //   2. Width constrained → ElideMiddle → "Very Lo…Name"
            //   3. Smooth opacity fade as space approaches minimum
            //   4. Hidden when titleMinChars can't fit (if autoHideTitle)

            Item {
                id: _titleContainer
                anchors {
                    left: _leftSection.right
                    leftMargin: 20
                    right: _rightSection.left
                    rightMargin: 20
                    verticalCenter: parent.verticalCenter
                }
                height: parent.height
                visible: root.showTitle

                readonly property real _fontSize: root.typography.titleSmall.size
                readonly property real _minWidth:
                    Math.max(40, root.titleMinChars * _fontSize * 0.65 + 20)
                readonly property real _availableWidth: Math.max(0, width)
                readonly property bool _tooNarrow: _availableWidth < _minWidth

                Accessible.role: Accessible.StaticText
                Accessible.name: root.title

                Text {
                    id: _titleText
                    anchors.verticalCenter: parent.verticalCenter

                    x: {
                        if (!root.centerTitle) return 0
                        var windowCenterLocal = (_toolbar.width / 2) - _titleContainer.x
                        var idealX = windowCenterLocal - (paintedWidth / 2)
                        var maxX = _titleContainer._availableWidth - paintedWidth
                        return Math.max(0, Math.min(idealX, Math.max(0, maxX)))
                    }

                    width: _titleContainer._availableWidth

                    text: root.title
                    font.family: root.fontFamily
                    font.weight: root.typography.titleSmall.weight
                    font.pixelSize: root.typography.titleSmall.size
                    font.letterSpacing: root.typography.titleSmall.spacing
                    color: colors.onSurface
                    elide: Text.ElideMiddle
                    maximumLineCount: 1
                    verticalAlignment: Text.AlignVCenter

                    opacity: {
                        if (!root.autoHideTitle) return 1.0
                        if (_titleContainer._tooNarrow) return 0
                        var fadeStart = _titleContainer._minWidth * 2.0
                        if (_titleContainer._availableWidth >= fadeStart) return 1.0
                        var range = fadeStart - _titleContainer._minWidth
                        if (range <= 0) return 1.0
                        return (_titleContainer._availableWidth - _titleContainer._minWidth) / range
                    }

                    visible: !root.autoHideTitle || !_titleContainer._tooNarrow

                    Behavior on opacity {
                        NumberAnimation {
                            duration: root.motion.durationMedium
                            easing.type: Easing.InOutCubic
                        }
                    }
                }
            }
        }

        // ═════════════════════════════════════════════════════════
        //  CONTENT AREA
        // ═════════════════════════════════════════════════════════

        Item {
            id: _contentContainer
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            clip: true

            readonly property real _topInset: root._showToolbar ? root.toolbarHeight : 0
            anchors.topMargin: _topInset

            Behavior on anchors.topMargin {
                NumberAnimation {
                    duration: root.motion.durationMedium
                    easing.type: root.motion.easeStandard
                }
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════
    //  INACTIVE OVERLAY
    // ═══════════════════════════════════════════════════════════════

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        z: 100000
        opacity: root.active ? 0.0 : 0.08
        visible: opacity > 0

        Behavior on opacity {
            NumberAnimation {
                duration: root.motion.durationFast
                easing.type: Easing.OutCubic
            }
        }
        Accessible.ignored: true
    }

    // ═══════════════════════════════════════════════════════════════
    //  WINDOW BORDER
    // ═══════════════════════════════════════════════════════════════

    Rectangle {
        anchors.fill: parent
        radius: windowRadius
        color: "transparent"
        border.width: 1
        border.color: colors.outlineVariant
        visible: opacity > 0
        opacity: (!root.isMaximized && !root.isFullScreen) ? 1.0 : 0.0
        z: 1000

        Behavior on opacity {
            NumberAnimation {
                duration: root.motion.durationFast
                easing.type: Easing.OutCubic
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════
    //  RESIZE HANDLES
    // ═══════════════════════════════════════════════════════════════

    Item {
        id: _resizeHandles
        anchors.fill: parent
        z: 1010
        visible: !root.isMaximized && !root.isFullScreen
        enabled: !root.isMaximized && !root.isFullScreen
        Accessible.ignored: true

        readonly property int edge: 8
        readonly property int corner: 24

        MouseArea {
            anchors { top: parent.top; left: parent.left; right: parent.right }
            height: _resizeHandles.edge; hoverEnabled: true
            cursorShape: Qt.SizeVerCursor
            onPressed: root.startSystemResize(Qt.TopEdge)
        }
        MouseArea {
            anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
            height: _resizeHandles.edge; hoverEnabled: true
            cursorShape: Qt.SizeVerCursor
            onPressed: root.startSystemResize(Qt.BottomEdge)
        }
        MouseArea {
            anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
            width: _resizeHandles.edge; hoverEnabled: true
            cursorShape: Qt.SizeHorCursor
            onPressed: root.startSystemResize(Qt.LeftEdge)
        }
        MouseArea {
            anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
            width: _resizeHandles.edge; hoverEnabled: true
            cursorShape: Qt.SizeHorCursor
            onPressed: root.startSystemResize(Qt.RightEdge)
        }
        MouseArea {
            anchors { top: parent.top; left: parent.left }
            width: _resizeHandles.corner; height: _resizeHandles.corner
            hoverEnabled: true; cursorShape: Qt.SizeFDiagCursor
            onPressed: root.startSystemResize(Qt.TopEdge | Qt.LeftEdge)
        }
        MouseArea {
            anchors { top: parent.top; right: parent.right }
            width: _resizeHandles.corner; height: _resizeHandles.corner
            hoverEnabled: true; cursorShape: Qt.SizeBDiagCursor
            onPressed: root.startSystemResize(Qt.TopEdge | Qt.RightEdge)
        }
        MouseArea {
            anchors { bottom: parent.bottom; left: parent.left }
            width: _resizeHandles.corner; height: _resizeHandles.corner
            hoverEnabled: true; cursorShape: Qt.SizeBDiagCursor
            onPressed: root.startSystemResize(Qt.BottomEdge | Qt.LeftEdge)
        }
        MouseArea {
            anchors { bottom: parent.bottom; right: parent.right }
            width: _resizeHandles.corner; height: _resizeHandles.corner
            hoverEnabled: true; cursorShape: Qt.SizeFDiagCursor
            onPressed: root.startSystemResize(Qt.BottomEdge | Qt.RightEdge)
        }
    }

    // ═══════════════════════════════════════════════════════════════
    //  INLINE COMPONENTS
    // ═══════════════════════════════════════════════════════════════

    // ── Toolbar Icon Button ──

    component ToolbarIconButton: Item {
        id: _tbtn
        property string iconName: ""
        property string tooltipText: ""
        property bool checked: false
        signal clicked()

        implicitWidth: 36; implicitHeight: 36
        width: 36; height: 36
        opacity: _tbtn.enabled ? 1.0 : 0.38

        activeFocusOnTab: true

        Accessible.role: Accessible.Button
        Accessible.name: _tbtn.tooltipText || _tbtn.iconName.replace(/_/g, " ")
        Accessible.focusable: true
        Accessible.onPressAction: _tbtn.clicked()

        Keys.onReturnPressed: _tbtn.clicked()
        Keys.onEnterPressed: _tbtn.clicked()
        Keys.onSpacePressed: _tbtn.clicked()

        // Focus ring — only visible when keyboard navigation is active
        Rectangle {
            anchors.fill: parent
            anchors.margins: -2
            radius: 12
            color: "transparent"
            border.width: 2
            border.color: root.colors.primary
            visible: _tbtn.activeFocus && root._keyboardFocusActive
            z: 10
        }

        Rectangle {
            anchors.fill: parent
            radius: 10
            color: {
                if (_tbtn.checked)
                    return root.colors.secondaryContainer
                if (_tbtnMouse.pressed)
                    return Qt.rgba(root.colors.primary.r,
                                   root.colors.primary.g,
                                   root.colors.primary.b, 0.15)
                if (_tbtnMouse.containsMouse)
                    return Qt.rgba(root.colors.onSurface.r,
                                   root.colors.onSurface.g,
                                   root.colors.onSurface.b, 0.08)
                return "transparent"
            }

            Behavior on color {
                ColorAnimation { duration: root.motion.durationFast }
            }
        }

        Icon {
            anchors.centerIn: parent
            source: _tbtn.iconName
            size: 20
            color: _tbtn.checked
                   ? root.colors.onSecondaryContainer
                   : root.colors.onSurface
        }

        MouseArea {
            id: _tbtnMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: _tbtn.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: {
                root._keyboardFocusActive = false
                _tbtn.forceActiveFocus()
                _tbtn.clicked()
            }
        }

        // ── Material 3 Expressive Tooltip ──
        // Pops up from below with scale+opacity+translate, matching
        // the seek hover popup style from the video player.

        Item {
            id: _tooltipPopup
            anchors.horizontalCenter: parent.horizontalCenter
            y: _shown ? parent.height + 6 : parent.height + 2
            width: _tooltipLabel.implicitWidth + 20
            height: 32
            z: 2000

            property bool _shown: _tbtnMouse.containsMouse
                                  && _tbtn.tooltipText !== ""
                                  && _tbtn.enabled
                                  && !_tooltipDelay.running
                                  && _tooltipReady
                                  && !root._anyMenuOpen

            property bool _tooltipReady: false

            Timer {
                id: _tooltipDelay
                interval: 1000
                onTriggered: _tooltipPopup._tooltipReady = true
            }

            Connections {
                target: _tbtnMouse
                function onContainsMouseChanged() {
                    if (_tbtnMouse.containsMouse) {
                        _tooltipPopup._tooltipReady = false
                        _tooltipDelay.restart()
                    } else {
                        _tooltipDelay.stop()
                        _tooltipPopup._tooltipReady = false
                    }
                }
            }

            scale: _shown ? 1.0 : 0.85
            opacity: _shown ? 1.0 : 0
            visible: opacity > 0
            transformOrigin: Item.Top

            Behavior on opacity {
                NumberAnimation {
                    duration: _tooltipPopup._shown ? 250 : 150
                    easing.type: _tooltipPopup._shown ? Easing.OutQuart : Easing.InQuart
                }
            }
            Behavior on scale {
                NumberAnimation {
                    duration: _tooltipPopup._shown ? 300 : 150
                    easing.type: _tooltipPopup._shown ? Easing.OutBack : Easing.InQuart
                    easing.overshoot: 1.3
                }
            }
            Behavior on y {
                NumberAnimation {
                    duration: _tooltipPopup._shown ? 250 : 150
                    easing.type: _tooltipPopup._shown ? Easing.OutQuart : Easing.InQuart
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: 8
                color: root.colors.inverseSurface

                // Subtle shadow via layered rectangle
                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: Qt.rgba(0, 0, 0, 0.2)
                    shadowBlur: 0.3
                    shadowVerticalOffset: 2
                    shadowHorizontalOffset: 0
                }
            }

            Text {
                id: _tooltipLabel
                anchors.centerIn: parent
                text: _tbtn.tooltipText
                font.family: root.fontFamily
                font.pixelSize: root.typography.bodySmall.size
                font.weight: root.typography.bodySmall.weight
                color: root.colors.inverseOnSurface
            }
        }
    }

    // ── Menu Bar Button (traditional style) ──

    component MenuBarButton: Item {
        id: _mbtn
        property var menuData: ({})
        property string tooltipText: ""
        property int index: -1
        signal itemTriggered(string itemId)

        implicitWidth: _mbtnLabel.implicitWidth + 24
        implicitHeight: 36
        width: implicitWidth; height: 36

        activeFocusOnTab: true

        Accessible.role: Accessible.MenuItem
        Accessible.name: _mbtn.menuData.title || ""
        Accessible.focusable: true
        Accessible.onPressAction: _ddMenu.open()

        Keys.onReturnPressed: _ddMenu.open()
        Keys.onEnterPressed: _ddMenu.open()
        Keys.onSpacePressed: _ddMenu.open()
        Keys.onRightPressed: {
            if (_ddMenu.visible) return
            var next = _menuBarRepeater.itemAt(index + 1)
            if (next) next.forceActiveFocus()
        }
        Keys.onLeftPressed: {
            if (_ddMenu.visible) return
            var prev = _menuBarRepeater.itemAt(index - 1)
            if (prev) prev.forceActiveFocus()
        }
        Keys.onEscapePressed: {
            if (_ddMenu.visible)
                _ddMenu.close()
        }

        // Focus ring — keyboard only
        Rectangle {
            anchors.fill: parent
            anchors.margins: -2
            radius: 10
            color: "transparent"
            border.width: 2
            border.color: root.colors.primary
            visible: _mbtn.activeFocus && root._keyboardFocusActive
            z: 10
        }

        Rectangle {
            anchors.fill: parent
            radius: 8
            color: {
                if (_mbtnMouse.containsMouse || _ddMenu.visible)
                    return Qt.rgba(root.colors.onSurface.r,
                                   root.colors.onSurface.g,
                                   root.colors.onSurface.b, 0.08)
                return "transparent"
            }

            Behavior on color {
                ColorAnimation { duration: root.motion.durationFast }
            }
        }

        Text {
            id: _mbtnLabel
            anchors.centerIn: parent
            text: _mbtn.menuData.title || ""
            font.family: root.fontFamily
            font.pixelSize: root.typography.labelLarge.size
            font.weight: root.typography.labelLarge.weight
            font.letterSpacing: root.typography.labelLarge.spacing
            color: root.colors.onSurface
        }

        MouseArea {
            id: _mbtnMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                root._keyboardFocusActive = false
                _mbtn.forceActiveFocus()
                _ddMenu.open()
            }
        }

        // Hover-open: open dropdown after short hover delay
        Timer {
            id: _mbtnHoverTimer
            interval: 200
            onTriggered: _ddMenu.open()
        }
        Connections {
            target: _mbtnMouse
            function onContainsMouseChanged() {
                if (_mbtnMouse.containsMouse)
                    _mbtnHoverTimer.restart()
                else
                    _mbtnHoverTimer.stop()
            }
        }

        // Tooltip
        Item {
            id: _mbtnTooltip
            anchors.horizontalCenter: parent.horizontalCenter
            y: _mbtnTooltipShown ? parent.height + 6 : parent.height + 2
            width: _mbtnTooltipLabel.implicitWidth + 20
            height: 32
            z: 2000

            readonly property string _text: _mbtn.tooltipText || _mbtn.menuData.title || ""
            property bool _mbtnTooltipShown: _mbtnMouse.containsMouse
                                              && _text !== ""
                                              && !_mbtnTooltipDelay.running
                                              && _mbtnTooltipReady
                                              && !root._anyMenuOpen

            property bool _mbtnTooltipReady: false

            Timer {
                id: _mbtnTooltipDelay
                interval: 1000
                onTriggered: _mbtnTooltip._mbtnTooltipReady = true
            }

            Connections {
                target: _mbtnMouse
                function onContainsMouseChanged() {
                    if (_mbtnMouse.containsMouse) {
                        _mbtnTooltip._mbtnTooltipReady = false
                        _mbtnTooltipDelay.restart()
                    } else {
                        _mbtnTooltipDelay.stop()
                        _mbtnTooltip._mbtnTooltipReady = false
                    }
                }
            }

            scale: _mbtnTooltipShown ? 1.0 : 0.85
            opacity: _mbtnTooltipShown ? 1.0 : 0
            visible: opacity > 0
            transformOrigin: Item.Top

            Behavior on opacity {
                NumberAnimation {
                    duration: _mbtnTooltip._mbtnTooltipShown ? 250 : 150
                    easing.type: _mbtnTooltip._mbtnTooltipShown ? Easing.OutQuart : Easing.InQuart
                }
            }
            Behavior on scale {
                NumberAnimation {
                    duration: _mbtnTooltip._mbtnTooltipShown ? 300 : 150
                    easing.type: _mbtnTooltip._mbtnTooltipShown ? Easing.OutBack : Easing.InQuart
                    easing.overshoot: 1.3
                }
            }
            Behavior on y {
                NumberAnimation {
                    duration: _mbtnTooltip._mbtnTooltipShown ? 250 : 150
                    easing.type: _mbtnTooltip._mbtnTooltipShown ? Easing.OutQuart : Easing.InQuart
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: 8
                color: root.colors.inverseSurface

                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: Qt.rgba(0, 0, 0, 0.2)
                    shadowBlur: 0.3
                    shadowVerticalOffset: 2
                    shadowHorizontalOffset: 0
                }
            }

            Text {
                id: _mbtnTooltipLabel
                anchors.centerIn: parent
                text: _mbtnTooltip._text
                font.family: root.fontFamily
                font.pixelSize: root.typography.bodySmall.size
                font.weight: root.typography.bodySmall.weight
                color: root.colors.inverseOnSurface
            }
        }

        Menus.DropdownMenu {
            id: _ddMenu
            y: parent.height + 4
            items: _mbtn.menuData.items || []
            onVisibleChanged: root._anyMenuOpen = visible
            onItemClicked: function(itemId) {
                _mbtn.itemTriggered(itemId)
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════
    //  PUBLIC API
    // ═══════════════════════════════════════════════════════════════

    function showToolbar() {
        toolbarVisible = true
        _toolbarAutoHidden = false
    }

    function hideToolbar() {
        if (toolbarBehavior === "autoHide")
            _toolbarAutoHidden = true
        else
            toolbarVisible = false
    }

    function toggleToolbar() {
        if (toolbarBehavior === "autoHide")
            _toolbarAutoHidden = !_toolbarAutoHidden
        else
            toolbarVisible = !toolbarVisible
    }

    function setMenuStyle(style) {
        if (showMenu) menuStyle = style
    }

    function _toggleToolbarAutoHide() {
        if (toolbarBehavior === "autoHide") {
            toolbarBehavior = "visible"
            _toolbarAutoHidden = false
        } else {
            toolbarBehavior = "autoHide"
            _toolbarAutoHidden = true
        }
    }

    // ═══════════════════════════════════════════════════════════════
    //  MENU ACTION DISPATCHER
    // ═══════════════════════════════════════════════════════════════

    function _handleMenuAction(menuId, itemId) {
        if (!showMenu) return

        menuItemTriggered(menuId, itemId)

        if (globalMenuActive)
            globalMenuItemActivated(menuId, itemId)

        switch (menuId + "." + itemId) {
        case "view.sidebar":
            sidebarButtonClicked()
            break
        case "view.toolbar_autohide":
            _toggleToolbarAutoHide()
            break
        case "view.menu_overflow":
            menuStyle = "overflow"
            break
        case "view.menu_traditional":
            menuStyle = "traditional"
            break
        case "view.menu_auto":
            menuStyle = "auto"
            break
        case "file.exit":
            root.close()
            break
        }
    }
}
