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
import QtQuick.Layouts
import QtQuick.Effects
import QtMultimedia
import "../../theme" as Theme
import "../common"
import "../menus" as Menus
import "../dialogs" as Dialogs
import "../feedback" as Feedback
import "../Buttons" as Buttons

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
 property bool showThemeToggle: true
    property var colors: Theme.ChiTheme.colors
    readonly property string fontFamily: Theme.ChiTheme.fontFamily
    readonly property var typography: Theme.ChiTheme.typography
    readonly property var motion: Theme.ChiTheme.motion

    // ═══════════════════════════════════════════════════════════════
    //  TOOLBAR
    // ═══════════════════════════════════════════════════════════════

    property string leadingIcon: ""
    property string leadingTooltip: qsTr("Back")
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

    property bool showMenu: true
    property string menuStyle: "overflow"
    property var customMenus: []
    property bool showDefaultMenus: true

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

    signal leadingActionTriggered
    signal toolbarActionTriggered(int index)
    signal menuItemTriggered(string menuId, string itemId)
    signal sidebarButtonClicked
    signal breakpointChanged(string breakpoint)

    // ═══════════════════════════════════════════════════════════════
    //  CONTEXT
    // ═══════════════════════════════════════════════════════════════

    readonly property QtObject context: QtObject {
        id: _ctx

        readonly property bool isMacOS: Qt.platform.os === "osx"
        readonly property bool isWindows: Qt.platform.os === "windows"
        readonly property bool isLinux: Qt.platform.os === "linux"
        readonly property bool isMobile: Qt.platform.os === "android" || Qt.platform.os === "ios"
        readonly property bool isWeb: Qt.platform.os === "wasm"
        readonly property bool isDesktop: !isMobile && !isWeb

        readonly property int windowWidth: root.width
        readonly property int windowHeight: root.height

        property string breakpoint: "expanded"

        readonly property bool isCompact: breakpoint === "compact"
        readonly property bool isMedium: breakpoint === "medium"
        readonly property bool isExpanded: breakpoint === "expanded"
        readonly property bool isLarge: breakpoint === "large"
        readonly property bool isXLarge: breakpoint === "xlarge"

        readonly property bool showWindowControls: isDesktop && !isWeb
        readonly property bool useOverlaySidebar: isCompact || isMedium

        readonly property bool globalMenuAvailable: {
            if (isMacOS)
                return true;
            if (isLinux) {
                function getEnv(name) {
                    try {
                        return Qt.runtime.environmentVariable(name);
                    } catch (e) {}
                    return "";
                }
                var desktop = getEnv("XDG_CURRENT_DESKTOP").toLowerCase();
                var session = getEnv("DESKTOP_SESSION").toLowerCase();
                return desktop.indexOf("kde") >= 0 || desktop.indexOf("plasma") >= 0 || desktop.indexOf("unity") >= 0 || desktop.indexOf("budgie") >= 0 || getEnv("UBUNTU_MENUPROXY") !== "";
            }
            return false;
        }

        onBreakpointChanged: root.breakpointChanged(breakpoint)

        function _recalc() {
            var w = root.width;
            var bp = w < 600 ? "compact" : w < 840 ? "medium" : w < 1200 ? "expanded" : w < 1600 ? "large" : "xlarge";
            if (breakpoint !== bp)
                breakpoint = bp;
        }
    }

    Timer {
        id: _bpDebounce
        interval: 80
        onTriggered: _ctx._recalc()
    }
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
        onActivated: {
            root._keyboardFocusActive = true;
        }
    }

    // Detect mouse clicks anywhere to exit keyboard focus mode
    MouseArea {
        anchors.fill: parent
        z: -100
        acceptedButtons: Qt.AllButtons
        hoverEnabled: false
        onPressed: function (mouse) {
            root._keyboardFocusActive = false;
            mouse.accepted = false;  // pass through
        }
    }

    // ═══════════════════════════════════════════════════════════════
    //  INTERNAL STATE
    // ═══════════════════════════════════════════════════════════════

    readonly property bool isMaximized: visibility === Window.Maximized
    readonly property bool isFullScreen: visibility === Window.FullScreen
    readonly property real windowRadius: (isMaximized || isFullScreen) ? 0 : 24

    // ─── Recording State ───
    property bool _recording: false
    property int _recordingElapsed: 0
    property var _lastRecSettings: ({
            area: 0,
            quality: 2,
            mic: 0
        })
    property url _recordingOutput: Qt.url("")

    readonly property string _resolvedMenuStyle: {
        if (!showMenu || globalMenuActive)
            return "none";
        if (menuStyle === "overflow" || menuStyle === "collapsed")
            return "overflow";
        if (menuStyle === "traditional")
            return "traditional";
        var needed = _allMenus.length * 70 + _rightSectionWidth + 100;
        return root.width < needed ? "overflow" : "traditional";
    }

    readonly property real _rightSectionWidth: (toolbarActions.length * 40) + (controlsOnLeft ? 0 : 120)

    signal openOverflowMenuRequested
    property bool _toolbarAutoHidden: false
    property bool _anyMenuOpen: false
    property bool _focusMode: false
    property bool _qpOpen: false

    readonly property bool _showToolbar: {
        if (isFullScreen)
            return false;
        if (_focusMode)
            return false;
        if (!toolbarVisible)
            return false;
        if (toolbarBehavior === "autoHide")
            return !_toolbarAutoHidden || _hoverTrigger.containsMouse;
        return true;
    }

    // ═══════════════════════════════════════════════════════════════
    //  DEFAULT MENUS
    // ═══════════════════════════════════════════════════════════════

    readonly property var _defaultMenus: showMenu ? [
        {
            id: "file",
            title: qsTr("File"),
            items: [
                {
                    id: "new",
                    text: qsTr("New"),
                    shortcut: "Ctrl+N",
                    icon: "add"
                },
                {
                    id: "open",
                    text: qsTr("Open"),
                    shortcut: "Ctrl+O",
                    icon: "folder_open"
                },
                {
                    type: "divider"
                },
                {
                    id: "save",
                    text: qsTr("Save"),
                    shortcut: "Ctrl+S",
                    icon: "save"
                },
                {
                    id: "saveAs",
                    text: qsTr("Save As…"),
                    shortcut: "Ctrl+Shift+S"
                },
                {
                    type: "divider"
                },
                {
                    id: "exit",
                    text: qsTr("Exit"),
                    shortcut: "Alt+F4",
                    icon: "logout"
                }
            ]
        },
        {
            id: "edit",
            title: qsTr("Edit"),
            items: [
                {
                    id: "undo",
                    text: qsTr("Undo"),
                    shortcut: "Ctrl+Z",
                    icon: "undo"
                },
                {
                    id: "redo",
                    text: qsTr("Redo"),
                    shortcut: "Ctrl+Y",
                    icon: "redo"
                },
                {
                    type: "divider"
                },
                {
                    id: "cut",
                    text: qsTr("Cut"),
                    shortcut: "Ctrl+X",
                    icon: "content_cut"
                },
                {
                    id: "copy",
                    text: qsTr("Copy"),
                    shortcut: "Ctrl+C",
                    icon: "content_copy"
                },
                {
                    id: "paste",
                    text: qsTr("Paste"),
                    shortcut: "Ctrl+V",
                    icon: "content_paste"
                }
            ]
        },
        {
            id: "view",
            title: qsTr("View"),
            items: [
                {
                    id: "sidebar",
                    text: qsTr("Toggle Sidebar"),
                    shortcut: "Ctrl+B",
                    icon: "view_sidebar"
                },
                {
                    type: "divider"
                },
                {
                    id: "toolbar_autohide",
                    text: qsTr("Auto-Hide Headerbar"),
                    shortcut: "Ctrl+Shift+H",
                    icon: "vertical_align_top"
                },
                {
                    id: "focus",
                    text: qsTr("Focus Mode"),
                    shortcut: "Ctrl+Shift+F",
                    icon: "center_focus_strong"
                },
                {
                    type: "divider"
                },
                {
                    id: "menu_overflow",
                    text: qsTr("Overflow Menu"),
                    icon: "more_horiz"
                },
                {
                    id: "menu_traditional",
                    text: qsTr("Traditional Menu"),
                    icon: "menu_open"
                },
                {
                    id: "menu_auto",
                    text: qsTr("Auto Menu"),
                    icon: "tune"
                }
            ]
        },
        {
            id: "help",
            title: qsTr("Help"),
            items: [
                {
                    id: "docs",
                    text: qsTr("Documentation"),
                    icon: "menu_book"
                },
                {
                    id: "shortcuts",
                    text: qsTr("Keyboard Shortcuts"),
                    icon: "keyboard"
                },
                {
                    type: "divider"
                },
                {
                    id: "about",
                    text: qsTr("About"),
                    icon: "info"
                }
            ]
        }
    ] : []

    readonly property var _allMenus: {
        if (!showMenu)
            return [];
        return showDefaultMenus ? _defaultMenus.concat(customMenus) : customMenus;
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
        sequence: "Ctrl+Shift+F"
        onActivated: root._focusMode = !root._focusMode
    }
    Shortcut {
        sequence: "Ctrl+Shift+P"
        context: Qt.ApplicationShortcut
        enabled: root.showMenu
        onActivated: root._qpOpen = !root._qpOpen
    }
    Shortcut {
        sequence: "Ctrl+Print"
        context: Qt.ApplicationShortcut
        onActivated: _screenshotDialog.openDialog()
    }
    Shortcut {
        sequence: "Ctrl+Shift+R"
        context: Qt.ApplicationShortcut
        onActivated: {
            console.log("Shortcut: Ctrl+Shift+R, recording=" + root._recording);
            if (root._recording)
                root._stopRecording();
            else
                _recDialog.show();
        }
    }
    Shortcut {
        sequence: "Ctrl+Alt+R"
        context: Qt.ApplicationShortcut
        onActivated: {
            console.log("Shortcut: Ctrl+Alt+R, recording=" + root._recording);
            if (root._recording)
                root._stopRecording();
            else
                root._quickRecord();
        }
    }
    Shortcut {
        sequence: "F11"
        context: Qt.ApplicationShortcut
        onActivated: root.visibility = root.visibility === Window.FullScreen ? Window.Windowed : Window.FullScreen
    }
    Shortcut {
        sequence: "Escape"
        context: Qt.ApplicationShortcut
        onActivated: {
            if (root._qpOpen)
                root._qpOpen = false;
            else if (root._focusMode)
                root._focusMode = false;
            else if (root.visibility === Window.FullScreen)
                root.visibility = Window.Windowed;
        }
    }
    // Mouse click to exit fullscreen
    MouseArea {
        anchors.fill: parent
        z: -99
        acceptedButtons: Qt.LeftButton
        onPressed: {
            if (root.visibility === Window.FullScreen && !root._focusMode) {
                // pass — let the content handle it
            }
        }
    }
    Shortcut {
        sequence: "F10"
        context: Qt.ApplicationShortcut
        enabled: root.showMenu && root._resolvedMenuStyle === "overflow"
        onActivated: {
            root._keyboardFocusActive = true;
            root.openOverflowMenuRequested();
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

    property alias dialogLayer: _surface

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
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            height: toolbarBehavior === "autoHide" && _toolbarAutoHidden ? 16 : 0
            hoverEnabled: toolbarBehavior === "autoHide"
            enabled: toolbarBehavior === "autoHide"
            visible: toolbarBehavior === "autoHide"
            z: 101
            Accessible.ignored: true
        }

        // ═════════════════════════════════════════════════════════
        //  TOOLBAR
        // ═════════════════════════════════════════════════════════

        Rectangle {
            id: _toolbar
            height: root.toolbarHeight
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            z: 100
            color: colors.surfaceContainer

            Accessible.role: Accessible.ToolBar
            Accessible.name: qsTr("Application toolbar")

            readonly property bool _shouldShow: root._showToolbar
            property real _toolbarOpacity: 0.0
            visible: _toolbarOpacity > 0.001
            opacity: _toolbarOpacity

            on_ShouldShowChanged: {
                if (_shouldShow) {
                    _toolbarOpacity = 0.0;
                    visible = true;
                    _toolbarOpacity = 1.0;
                } else {
                    _toolbarOpacity = 0.0;
                }
            }
            on_ToolbarOpacityChanged: {
                if (_toolbarOpacity <= 0.001)
                    visible = false;
            }

            Behavior on _toolbarOpacity {
                NumberAnimation {
                    duration: Theme.ChiMotion.duration.medium1
                    easing.type: Easing.BezierSpline
                }
            }

            // Drag / maximize / window menu
            MouseArea {
                anchors.fill: parent
                z: -1
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onPressed: function (mouse) {
                    root._keyboardFocusActive = false;
                    if (mouse.button === Qt.RightButton)
                        _windowMenu.popup(mouse.x, mouse.y);
                    else
                        root.startSystemMove();
                }
                onDoubleClicked: {
                    if (root.isMaximized)
                        root.showNormal();
                    else
                        root.showMaximized();
                }
            }

            // Window menu on right-click title bar
            Menus.ContextMenu {
                id: _windowMenu
                maxWidth: 176
                onOpenChanged: root._anyMenuOpen = open

                Menus.MenuItem {
                    text: qsTr("Restore")
                    enabled: root.isMaximized || root.isFullScreen
                    onClicked: root.showNormal()
                }
                Menus.MenuDivider {}
                Menus.MenuItem {
                    text: qsTr("Move")
                    onClicked: root.startSystemMove()
                }
                Menus.MenuDivider {}
                Menus.MenuItem {
                    text: qsTr("Minimize")
                    onClicked: root.showMinimized()
                }
                Menus.MenuItem {
                    text: qsTr("Maximize")
                    enabled: !root.isMaximized && !root.isFullScreen
                    onClicked: root.showMaximized()
                }
                Menus.MenuDivider {}
                Menus.MenuItem {
                    text: qsTr("Close")
                    trailingText: qsTr("Alt+F4")
                    onClicked: root.close()
                }
                Menus.MenuDivider {}
                Menus.MenuItem {
                    text: qsTr("Arrange")
                    enabled: false
                }
                Menus.MenuItem {
                    text: qsTr("Left half")
                    onClicked: {
                        var s = Screen;
                        root.x = 0;
                        root.y = 0;
                        root.width = Math.round(s.desktopAvailableWidth / 2);
                        root.height = s.desktopAvailableHeight;
                    }
                }
                Menus.MenuItem {
                    text: qsTr("Right half")
                    onClicked: {
                        var s = Screen;
                        root.x = Math.round(s.desktopAvailableWidth / 2);
                        root.y = 0;
                        root.width = Math.round(s.desktopAvailableWidth / 2);
                        root.height = s.desktopAvailableHeight;
                    }
                }
                Menus.MenuItem {
                    text: qsTr("Top-left")
                    onClicked: {
                        var s = Screen;
                        var hw = Math.round(s.desktopAvailableWidth / 2);
                        var hh = Math.round(s.desktopAvailableHeight / 2);
                        root.x = 0;
                        root.y = 0;
                        root.width = hw;
                        root.height = hh;
                    }
                }
                Menus.MenuItem {
                    text: qsTr("Top-right")
                    onClicked: {
                        var s = Screen;
                        var hw = Math.round(s.desktopAvailableWidth / 2);
                        var hh = Math.round(s.desktopAvailableHeight / 2);
                        root.x = hw;
                        root.y = 0;
                        root.width = hw;
                        root.height = hh;
                    }
                }
                Menus.MenuItem {
                    text: qsTr("Bottom-left")
                    onClicked: {
                        var s = Screen;
                        var hw = Math.round(s.desktopAvailableWidth / 2);
                        var hh = Math.round(s.desktopAvailableHeight / 2);
                        root.x = 0;
                        root.y = hh;
                        root.width = hw;
                        root.height = hh;
                    }
                }
                Menus.MenuItem {
                    text: qsTr("Bottom-right")
                    onClicked: {
                        var s = Screen;
                        var hw = Math.round(s.desktopAvailableWidth / 2);
                        var hh = Math.round(s.desktopAvailableHeight / 2);
                        root.x = hw;
                        root.y = hh;
                        root.width = hw;
                        root.height = hh;
                    }
                }
                Menus.MenuItem {
                    text: qsTr("Center")
                    onClicked: {
                        var s = Screen;
                        var w = Math.round(s.desktopAvailableWidth * 0.6);
                        var h = Math.round(s.desktopAvailableHeight * 0.8);
                        root.x = Math.round((s.desktopAvailableWidth - w) / 2);
                        root.y = Math.round((s.desktopAvailableHeight - h) / 2);
                        root.width = w;
                        root.height = h;
                    }
                }
                Menus.MenuDivider {}
                Menus.MenuItem {
                    text: qsTr("Take Screenshot")
                    trailingText: qsTr("Ctrl+Print")
                    onClicked: _screenshotDialog.openDialog()
                }
                Menus.MenuItem {
                    text: qsTr("Screen Recording")
                    trailingText: qsTr("Ctrl+Shift+R")
                    onClicked: _recDialog.show()
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
                        visible: root.showControls && root.controlsOnLeft && _ctx.showWindowControls
                        targetWindow: root
                        variant: root.controlsStyle
                        menuOpen: root._anyMenuOpen
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Item {
                        width: 8
                        height: 1
                        visible: root.controlsOnLeft && root.showControls && _ctx.showWindowControls
                    }

                    // Overflow menu button (⋯)
                    ToolbarIconButton {
                        visible: root._resolvedMenuStyle === "overflow"
                        iconName: "more_horiz"
                        tooltipText: qsTr("Application menu (F10)")
                        onClicked: _overflowMenu.open()

                        Accessible.name: qsTr("Application menu")
                        Accessible.description: qsTr("Press F10 to open")

                        Menus.OverflowMenu {
                            id: _overflowMenu
                            menus: root._allMenus
                            maxHeight: root.height - 100
                            onVisibleChanged: root._anyMenuOpen = visible
                            onItemTriggered: function (menuId, itemId) {
                                root._handleMenuAction(menuId, itemId);
                            }
                        }
                        Connections {
                            target: root
                            function onOpenOverflowMenuRequested() {
                                _overflowMenu.open();
                            }
                        }
                    }

                    ToolbarIconButton {
                        visible: root.showSidebarButton
                        iconName: "view_sidebar"
                        tooltipText: qsTr("Toggle sidebar (Ctrl+B)")
                        checked: root.sidebarOpen
                        onClicked: root.sidebarButtonClicked()
                        Accessible.name: root.sidebarOpen ? qsTr("Close sidebar") : qsTr("Open sidebar")
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
                                onItemTriggered: function (itemId) {
                                    root._handleMenuAction(modelData.id, itemId);
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
 Accessible.name: modelData.tooltip || modelData.icon || qsTr("Action %1").arg(index + 1)

 onClicked: {
 if (modelData.triggered)
 modelData.triggered();
 root.toolbarActionTriggered(index);
 }
 }
 }

 // Dark/Light mode toggle
 ToolbarIconButton {
 id: _themeToggle
 visible: root.showThemeToggle
 iconName: Theme.ChiTheme.isDarkMode ? "light_mode" : "dark_mode"
 tooltipText: Theme.ChiTheme.isDarkMode ? qsTr("Switch to light mode") : qsTr("Switch to dark mode")
 onClicked: Theme.ChiTheme.toggleDarkMode()
 Accessible.name: Theme.ChiTheme.isDarkMode ? qsTr("Switch to light mode") : qsTr("Switch to dark mode")
 }
                    }

                    Item {
                        width: 8
                        height: 1
                        visible: !root.controlsOnLeft && root.showControls && _ctx.showWindowControls
                    }

                    WindowControls {
                        visible: root.showControls && !root.controlsOnLeft && _ctx.showWindowControls
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
                readonly property real _minWidth: Math.max(40, root.titleMinChars * _fontSize * 0.65 + 20)
                readonly property real _availableWidth: Math.max(0, width)
                readonly property bool _tooNarrow: _availableWidth < _minWidth

                Accessible.role: Accessible.StaticText
                Accessible.name: root.title

                Text {
                    id: _titleText
                    anchors.verticalCenter: parent.verticalCenter

                    x: {
                        if (!root.centerTitle)
                            return 0;
                        var windowCenterLocal = (_toolbar.width / 2) - _titleContainer.x;
                        var idealX = windowCenterLocal - (paintedWidth / 2);
                        var maxX = _titleContainer._availableWidth - paintedWidth;
                        return Math.max(0, Math.min(idealX, Math.max(0, maxX)));
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
                        if (!root.autoHideTitle)
                            return 1.0;
                        if (_titleContainer._tooNarrow)
                            return 0;
                        var fadeStart = _titleContainer._minWidth * 2.0;
                        if (_titleContainer._availableWidth >= fadeStart)
                            return 1.0;
                        var range = fadeStart - _titleContainer._minWidth;
                        if (range <= 0)
                            return 1.0;
                        return (_titleContainer._availableWidth - _titleContainer._minWidth) / range;
                    }

                    visible: !root.autoHideTitle || !_titleContainer._tooNarrow

                    Behavior on opacity {
                        NumberAnimation {
                            duration: Theme.ChiMotion.duration.medium1
                            easing.type: Easing.BezierSpline
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
                    duration: Theme.ChiMotion.duration.medium1
                    easing.type: Easing.BezierSpline
                }
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════
    //  INACTIVE OVERLAY
    // ═══════════════════════════════════════════════════════════════

    Rectangle {
        anchors.fill: parent
        radius: windowRadius
        color: "#000000"
        z: 100000
        opacity: root.active ? 0.0 : 0.08
        visible: opacity > 0

        Behavior on opacity {
            NumberAnimation {
                duration: Theme.ChiMotion.duration.short2
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
        opacity: (!root.isMaximized && !root.isFullScreen && !root._focusMode) ? 1.0 : 0.0
        z: 1000

        Behavior on opacity {
            NumberAnimation {
                duration: Theme.ChiMotion.duration.short2
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
        visible: !root.isMaximized && !root.isFullScreen && !root._focusMode
        enabled: !root.isMaximized && !root.isFullScreen && !root._focusMode
        Accessible.ignored: true

        readonly property int edge: 8
        readonly property int corner: 24

        MouseArea {
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            height: _resizeHandles.edge
            hoverEnabled: true
            cursorShape: Qt.SizeVerCursor
            onPressed: root.startSystemResize(Qt.TopEdge)
        }
        MouseArea {
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
            height: _resizeHandles.edge
            hoverEnabled: true
            cursorShape: Qt.SizeVerCursor
            onPressed: root.startSystemResize(Qt.BottomEdge)
        }
        MouseArea {
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            width: _resizeHandles.edge
            hoverEnabled: true
            cursorShape: Qt.SizeHorCursor
            onPressed: root.startSystemResize(Qt.LeftEdge)
        }
        MouseArea {
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            width: _resizeHandles.edge
            hoverEnabled: true
            cursorShape: Qt.SizeHorCursor
            onPressed: root.startSystemResize(Qt.RightEdge)
        }
        MouseArea {
            anchors {
                top: parent.top
                left: parent.left
            }
            width: _resizeHandles.corner
            height: _resizeHandles.corner
            hoverEnabled: true
            cursorShape: Qt.SizeFDiagCursor
            onPressed: root.startSystemResize(Qt.TopEdge | Qt.LeftEdge)
        }
        MouseArea {
            anchors {
                top: parent.top
                right: parent.right
            }
            width: _resizeHandles.corner
            height: _resizeHandles.corner
            hoverEnabled: true
            cursorShape: Qt.SizeBDiagCursor
            onPressed: root.startSystemResize(Qt.TopEdge | Qt.RightEdge)
        }
        MouseArea {
            anchors {
                bottom: parent.bottom
                left: parent.left
            }
            width: _resizeHandles.corner
            height: _resizeHandles.corner
            hoverEnabled: true
            cursorShape: Qt.SizeBDiagCursor
            onPressed: root.startSystemResize(Qt.BottomEdge | Qt.LeftEdge)
        }
        MouseArea {
            anchors {
                bottom: parent.bottom
                right: parent.right
            }
            width: _resizeHandles.corner
            height: _resizeHandles.corner
            hoverEnabled: true
            cursorShape: Qt.SizeFDiagCursor
            onPressed: root.startSystemResize(Qt.BottomEdge | Qt.RightEdge)
        }
    }

    // ═══════════════════════════════════════════════════════════════
    //  FOCUS MODE EXIT PILL
    // ═══════════════════════════════════════════════════════════════

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        y: focusPillShown ? parent.height - 56 : parent.height
        width: focusPillLabel.implicitWidth + 40
        height: 36
        radius: 18
        color: colors.inverseSurface
        z: 100001
        visible: root._focusMode

        property bool focusPillShown: _hoverTrigger.containsMouse || _focusPillMouse.containsMouse

        Behavior on y {
            NumberAnimation {
                duration: Theme.ChiMotion.duration.medium1
                easing.type: Easing.BezierSpline
            }
        }

        Text {
            id: focusPillLabel
            anchors.centerIn: parent
            text: qsTr("Exit focus mode")
            font.pixelSize: 12
            font.weight: Font.Medium
            color: colors.inverseOnSurface
        }

        MouseArea {
            id: _focusPillMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root._focusMode = false
        }

        Accessible.role: Accessible.Button
        Accessible.name: qsTr("Exit focus mode")
        Accessible.onPressAction: root._focusMode = false
    }

    // ═══════════════════════════════════════════════════════════════
    //  QUICK PALETTE
    // ═══════════════════════════════════════════════════════════════

    QuickPalette {
        id: _quickPalette
    }

    // ═══════════════════════════════════════════════════════════════
    //  SCREENSHOT DIALOG
    // ═══════════════════════════════════════════════════════════════

    Dialogs.FileDialog {
        id: _screenshotDialog
        mode: "save"
        title: qsTr("Save Screenshot")
        nameFilters: [qsTr("PNG images (*.png)")]
        fileName: "Chi-screenshot.png"

        function openDialog() {
            fileName = "Chi-screenshot-" + Date.now() + ".png";
            open();
        }

        onAccepted: {
            var path = _screenshotDialog.selectedFile;
            var name = path.toString().split("/").pop();
            _surface.grabToImage(function (r) {
                r.saveToFile(path);
                _clipboard.copyImage(path);
                _snackbar.show(qsTr("Screenshot saved: %1 · Copied to clipboard").arg(name));
            });
        }
    }

    Feedback.Snackbar {
        id: _snackbar
        duration: 4000
    }

    Connections {
        target: _snackbar
        function onActionClicked() {
            if (root._recording)
                root._stopRecording();
        }
    }

    // ═══════════════════════════════════════════════════════════════
    //  SCREEN RECORDING
    // ═══════════════════════════════════════════════════════════════

    Timer {
        id: _recTimer
        interval: 1000
        repeat: true
        onTriggered: root._recordingElapsed++
    }

    Dialogs.FileDialog {
        id: _saveRecDialog
        mode: "save"
        title: qsTr("Save Recording")
        nameFilters: [qsTr("MP4 video (*.mp4)")]
        fileName: "Chi-recording.mp4"

        function openDialog() {
            fileName = "Chi-recording-" + Date.now() + ".mp4";
            open();
        }

        onAccepted: {
            root._recordingOutput = _saveRecDialog.selectedFile;
            console.log("Recording: save dialog accepted, output=" + root._recordingOutput);
            _startRecording();
        }
    }

    CaptureSession {
        id: _captureSession
        screenCapture: ScreenCapture {
            id: _screenCapture
        }
        windowCapture: WindowCapture {
            id: _windowCapture
            onWindowChanged: console.log("Recording: WindowCapture window=" + (_windowCapture.window ? _windowCapture.window.description : "null"))
            onErrorOccurred: function (error, errorString) {
                console.log("Recording: WindowCapture error=" + error + " " + errorString);
            }
        }
        recorder: MediaRecorder {
            id: _mediaRecorder
            outputLocation: root._recordingOutput

            onRecorderStateChanged: function (state) {
                console.log("Recording: MediaRecorder state=" + state);
                if (state === MediaRecorder.StoppedState && !root._recording) {
                    var name = root._recordingOutput.toString().split("/").pop();
                    console.log("Recording: finalized, saved as " + name);
                    _snackbar.duration = 4000;
                    _snackbar.multiLine = false;
                    _snackbar.show(qsTr("Recording saved: %1").arg(name));
                }
            }
            onErrorOccurred: function (error, errorString) {
                console.log("Recording ERROR: code=" + error + " message=" + errorString);
                root._recording = false;
                root._recTimer.stop();
                _screenCapture.active = false;
                _windowCapture.active = false;
                _snackbar.duration = 4000;
                _snackbar.multiLine = false;
                _snackbar.show(qsTr("Recording failed: %1").arg(errorString));
            }
        }
        audioInput: AudioInput {
            id: _audioInput
        }
    }

    Dialogs.Dialog {
        id: _recDialog
        type: "assistant"
        title: qsTr("Screen Recording")
        closeOnOverlayClick: false

        content: Component {
            ColumnLayout {
                spacing: 20
                width: parent ? parent.width : 400

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16

                    Text {
                        text: qsTr("Record area")
                        font.family: Theme.ChiTheme.fontFamily
                        font.pixelSize: root.typography.bodyLarge.size
                        color: root.colors.onSurface
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    ComboBox {
                        id: _areaCombo
                        model: [qsTr("Full Screen"), qsTr("Current Window")]
                        currentIndex: root._lastRecSettings.area
                        font.family: Theme.ChiTheme.fontFamily
                        font.pixelSize: root.typography.bodyMedium.size
                        onCurrentIndexChanged: root._lastRecSettings.area = currentIndex
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16

                    Text {
                        text: qsTr("Quality")
                        font.family: Theme.ChiTheme.fontFamily
                        font.pixelSize: root.typography.bodyLarge.size
                        color: root.colors.onSurface
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    ComboBox {
                        id: _qualityCombo
                        model: [qsTr("Low"), qsTr("Medium"), qsTr("High"), qsTr("Very High")]
                        currentIndex: root._lastRecSettings.quality
                        font.family: Theme.ChiTheme.fontFamily
                        font.pixelSize: root.typography.bodyMedium.size
                        onCurrentIndexChanged: root._lastRecSettings.quality = currentIndex
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16

                    Text {
                        text: qsTr("Microphone")
                        font.family: Theme.ChiTheme.fontFamily
                        font.pixelSize: root.typography.bodyLarge.size
                        color: root.colors.onSurface
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    ComboBox {
                        id: _micCombo
                        model: [qsTr("Off"), qsTr("On")]
                        currentIndex: root._lastRecSettings.mic
                        font.family: Theme.ChiTheme.fontFamily
                        font.pixelSize: root.typography.bodyMedium.size
                        onCurrentIndexChanged: root._lastRecSettings.mic = currentIndex
                    }
                }
            }
        }

        actions: [
            Buttons.Button {
                text: qsTr("Cancel")
                variant: "text"
                onClicked: _recDialog.reject()
            },
            Buttons.Button {
                text: qsTr("Start Recording")
                variant: "text"
                onClicked: {
                    _recDialog.accept();
                }
            }
        ]

        onAccepted: {
            console.log("Recording: dialog accepted");
            _saveRecDialog.openDialog();
        }
    }

    Rectangle {
        id: _recIndicator
        visible: root._recording
        z: 100001
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 16
        anchors.topMargin: 60

        width: _recRow.implicitWidth + 24
        height: 36
        radius: 18
        color: root.colors.errorContainer

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.2)
            shadowBlur: 0.4
            shadowVerticalOffset: 2
        }

        Row {
            id: _recRow
            anchors.centerIn: parent
            spacing: 6

            Rectangle {
                width: 8
                height: 8
                radius: 4
                anchors.verticalCenter: parent.verticalCenter
                color: "#e53935"
                opacity: 0.9
                NumberAnimation on opacity {
                    loops: Animation.Infinite
                    from: 1.0
                    to: 0.3
                    duration: 800
                    running: root._recording
                }
            }

            Text {
                id: _recTime
                anchors.verticalCenter: parent.verticalCenter
                font.family: Theme.ChiTheme.fontFamily
                font.pixelSize: root.typography.labelLarge.size
                font.weight: Font.Medium
                font.features: {
                    "tnum": 1
                }
                color: root.colors.onErrorContainer
                text: {
                    var m = Math.floor(root._recordingElapsed / 60);
                    var s = root._recordingElapsed % 60;
                    return String(m).padStart(2, "0") + ":" + String(s).padStart(2, "0");
                }
            }

            Rectangle {
                width: 24
                height: 24
                radius: 12
                anchors.verticalCenter: parent.verticalCenter
                color: "#e53935"

                Rectangle {
                    anchors.centerIn: parent
                    width: 10
                    height: 10
                    radius: 2
                    color: "white"
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: root._stopRecording()
                }

                Accessible.role: Accessible.Button
                Accessible.name: qsTr("Stop recording")
            }
        }

        Accessible.role: Accessible.StatusBar
        Accessible.name: qsTr("Recording %1").arg(_recTime.text)
    }

    function _startRecording() {
        console.log("Recording: _startRecording called, output=" + root._recordingOutput);
        var qualityMap = [MediaRecorder.VeryLowQuality, MediaRecorder.LowQuality, MediaRecorder.HighQuality, MediaRecorder.VeryHighQuality];
        var qIdx = root._lastRecSettings.quality;
        _mediaRecorder.quality = qualityMap[qIdx];
        console.log("Recording: quality=" + qIdx + " area=" + root._lastRecSettings.area + " mic=" + root._lastRecSettings.mic);

        if (root._lastRecSettings.mic === 1) {
            _captureSession.audioInput = _audioInput;
            console.log("Recording: microphone enabled");
        } else {
            _captureSession.audioInput = null;
            console.log("Recording: microphone disabled");
        }

        _screenCapture.active = false;
        _windowCapture.active = false;

        if (root._lastRecSettings.area === 0) {
            _captureSession.windowCapture = null;
            _captureSession.screenCapture = _screenCapture;
            _screenCapture.screen = Screen;
            _screenCapture.active = true;
            console.log("Recording: full screen capture");
        } else {
            _captureSession.screenCapture = null;
            _captureSession.windowCapture = _windowCapture;
            var w = _findChiWindow();
            if (w && w.isValid) {
                _windowCapture.window = w;
                _windowCapture.active = true;
                console.log("Recording: window capture: " + w.description);
            } else {
                console.log("Recording: no capturable window found, use full screen");
                _captureSession.windowCapture = null;
                _captureSession.screenCapture = _screenCapture;
                _screenCapture.screen = Screen;
                _screenCapture.active = true;
            }
        }
        _recordingElapsed = 0;
        _recording = true;
        _recTimer.start();
        _mediaRecorder.record();
        console.log("Recording: started successfully");

        _snackbar.duration = 0;
        _snackbar.multiLine = false;
        _snackbar.show(qsTr("Recording…"), qsTr("Stop"));
    }

    function _stopRecording() {
        if (!_recording) {
            console.log("Recording: _stopRecording called but not recording, ignored");
            return;
        }
        console.log("Recording: stopping...");
        _recording = false;
        _recTimer.stop();
        _mediaRecorder.stop();
        _screenCapture.active = false;
        _windowCapture.active = false;
        _snackbar.duration = 0;
        _snackbar.hide();
        console.log("Recording: stop requested, waiting for finalization");
    }

    function _findChiWindow() {
        var windows = _windowCapture.capturableWindows();
        console.log("Recording: capturable windows count=" + windows.length);
        for (var i = 0; i < windows.length; i++) {
            console.log("Recording:   window[" + i + "] '" + windows[i].description + "' valid=" + windows[i].isValid);
        }
        for (var j = 0; j < windows.length; j++) {
            if (windows[j].description === root.title)
                return windows[j];
        }
        for (var k = 0; k < windows.length; k++) {
            if (windows[k].isValid)
                return windows[k];
        }
        return null;
    }

    function _quickRecord() {
        root._recordingOutput = _defaultRecordingPath();
        console.log("Recording: quick record, path=" + root._recordingOutput);
        _startRecording();
    }

    function _defaultRecordingPath() {
        var d = new Date();
        var ts = d.getFullYear() + "-" + String(d.getMonth() + 1).padStart(2, "0") + "-" + String(d.getDate()).padStart(2, "0") + "-" + String(d.getHours()).padStart(2, "0") + String(d.getMinutes()).padStart(2, "0") + String(d.getSeconds()).padStart(2, "0");
        return "file://" + _clipboard.videosDir() + "/Chi-recording-" + ts + ".mp4";
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
        signal clicked

        implicitWidth: 36
        implicitHeight: 36
        width: 36
        height: 36
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
                    return root.colors.secondaryContainer;
                if (_tbtnMouse.pressed)
                    return Qt.rgba(root.colors.primary.r, root.colors.primary.g, root.colors.primary.b, 0.15);
                if (_tbtnMouse.containsMouse)
                    return Qt.rgba(root.colors.onSurface.r, root.colors.onSurface.g, root.colors.onSurface.b, 0.08);
                return "transparent";
            }

            Behavior on color {
                ColorAnimation {
                    duration: Theme.ChiMotion.duration.short2
                }
            }
        }

        Icon {
            anchors.centerIn: parent
            source: _tbtn.iconName
            size: 20
            color: _tbtn.checked ? root.colors.onSecondaryContainer : root.colors.onSurface
        }

        MouseArea {
            id: _tbtnMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: _tbtn.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: {
                root._keyboardFocusActive = false;
                _tbtn.forceActiveFocus();
                _tbtn.clicked();
            }
        }

        Menus.Tooltip {
            id: _tooltipPopup
            text: _tbtn.tooltipText !== "" && _tbtn.enabled && !root._anyMenuOpen ? _tbtn.tooltipText : ""
            delay: 500
            positionTarget: _tbtnMouse
        }

        function _clampTbTooltip() {
            _tooltipPopup.x = (_tbtn.width - _tooltipPopup.width) / 2;
            _tooltipPopup.y = _tbtn.height + 6;
            if (root) {
                var sx = _tooltipPopup.mapToItem(root.contentItem, 0, 0).x;
                if (sx < 4)
                    _tooltipPopup.x += 4 - sx;
                if (sx + _tooltipPopup.width > root.width - 4)
                    _tooltipPopup.x -= sx + _tooltipPopup.width - root.width + 4;
            }
            _tooltipPopup._positionCaret();
        }

        Connections {
            target: _tbtnMouse
            function onContainsMouseChanged() {
                if (_tbtnMouse.containsMouse && _tbtn.tooltipText !== "" && _tbtn.enabled && !root._anyMenuOpen) {
                    _clampTbTooltip();
                    _tooltipPopup.show();
                } else {
                    _tooltipPopup.hide();
                }
            }
        }

        Connections {
            target: _tooltipPopup
            function onWidthChanged() {
                if (_tooltipPopup.isVisible) {
                    _clampTbTooltip();
                    _tooltipPopup._positionCaret();
                }
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
        width: implicitWidth
        height: 36

        activeFocusOnTab: true

        Accessible.role: Accessible.MenuItem
        Accessible.name: _mbtn.menuData.title || ""
        Accessible.focusable: true
        Accessible.onPressAction: _ddMenu.open()

        Keys.onReturnPressed: _ddMenu.open()
        Keys.onEnterPressed: _ddMenu.open()
        Keys.onSpacePressed: _ddMenu.open()
        Keys.onRightPressed: {
            if (_ddMenu.visible)
                return;
            var next = _menuBarRepeater.itemAt(index + 1);
            if (next)
                next.forceActiveFocus();
        }
        Keys.onLeftPressed: {
            if (_ddMenu.visible)
                return;
            var prev = _menuBarRepeater.itemAt(index - 1);
            if (prev)
                prev.forceActiveFocus();
        }
        Keys.onEscapePressed: {
            if (_ddMenu.visible)
                _ddMenu.close();
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
                    return Qt.rgba(root.colors.onSurface.r, root.colors.onSurface.g, root.colors.onSurface.b, 0.08);
                return "transparent";
            }

            Behavior on color {
                ColorAnimation {
                    duration: Theme.ChiMotion.duration.short2
                }
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
                root._keyboardFocusActive = false;
                _mbtn.forceActiveFocus();
                if (_ddMenu.open) {
                    _ddMenu.close();
                } else {
                    _ddMenu.open();
                }
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
                    _mbtnHoverTimer.restart();
                else
                    _mbtnHoverTimer.stop();
            }
        }

        Menus.Tooltip {
            id: _mbtnTooltip
            text: {
                var t = _mbtn.tooltipText || _mbtn.menuData.title || "";
                return t !== "" && !root._anyMenuOpen ? t : "";
            }
            delay: 500
            positionTarget: _mbtnMouse
        }

        function _clampMbTooltip() {
            _mbtnTooltip.x = (_mbtn.width - _mbtnTooltip.width) / 2;
            _mbtnTooltip.y = _mbtn.height + 6;
            if (root) {
                var sx = _mbtnTooltip.mapToItem(root.contentItem, 0, 0).x;
                if (sx < 4)
                    _mbtnTooltip.x += 4 - sx;
                if (sx + _mbtnTooltip.width > root.width - 4)
                    _mbtnTooltip.x -= sx + _mbtnTooltip.width - root.width + 4;
            }
            _mbtnTooltip._positionCaret();
        }

        Connections {
            target: _mbtnMouse
            function onContainsMouseChanged() {
                var t = _mbtn.tooltipText || _mbtn.menuData.title || "";
                if (_mbtnMouse.containsMouse && t !== "" && !root._anyMenuOpen) {
                    _clampMbTooltip();
                    _mbtnTooltip.show();
                } else {
                    _mbtnTooltip.hide();
                }
            }
        }

        Connections {
            target: _mbtnTooltip
            function onWidthChanged() {
                if (_mbtnTooltip.isVisible) {
                    _clampMbTooltip();
                    _mbtnTooltip._positionCaret();
                }
            }
        }

        Menus.DropdownMenu {
            id: _ddMenu
            y: parent.height + 4
            items: _mbtn.menuData.items || []
            onVisibleChanged: root._anyMenuOpen = visible
            onItemClicked: function (itemId) {
                _mbtn.itemTriggered(itemId);
            }
        }
    }

    // ── Quick Palette ──

    component QuickPalette: Item {
        id: _qp
        anchors.fill: parent
        z: 100002

        readonly property var _qpAllItems: {
            var r = [];
            for (var mi = 0; mi < root._allMenus.length; mi++) {
                var menu = root._allMenus[mi];
                if (!menu.items)
                    continue;
                for (var ii = 0; ii < menu.items.length; ii++) {
                    var item = menu.items[ii];
                    if (item.type === "divider")
                        continue;
                    r.push({
                        menuId: menu.id,
                        itemId: item.id,
                        text: item.text || "",
                        shortcut: item.shortcut || "",
                        icon: item.icon || ""
                    });
                }
            }
            // Window actions
            r.push({
                menuId: "_window",
                itemId: "screenshot",
                text: qsTr("Take Screenshot"),
                shortcut: "Ctrl+Print",
                icon: "camera"
            }, {
                menuId: "_window",
                itemId: "recording",
                text: qsTr("Screen Recording"),
                shortcut: "Ctrl+Shift+R",
                icon: "videocam"
            }, {
                menuId: "_window",
                itemId: "quickrecord",
                text: qsTr("Quick Record"),
                shortcut: "Ctrl+Alt+R",
                icon: "radio_button_checked"
            }, {
                menuId: "_window",
                itemId: "focus",
                text: qsTr("Toggle Focus Mode"),
                shortcut: "Ctrl+Shift+F",
                icon: "center_focus_strong"
            }, {
                menuId: "_window",
                itemId: "fullscreen",
                text: qsTr("Toggle Fullscreen"),
                shortcut: "F11",
                icon: "fullscreen"
            }, {
                menuId: "_window",
                itemId: "sidebar",
                text: qsTr("Toggle Sidebar"),
                shortcut: "Ctrl+B",
                icon: "view_sidebar"
            });
            return r;
        }

        property string _qpFilter: ""

        readonly property var _qpFiltered: {
            var f = _qpFilter.toLowerCase().trim();
            if (!f)
                return _qpAllItems;
            var r = [];
            for (var i = 0; i < _qpAllItems.length; i++) {
                var it = _qpAllItems[i];
                if ((it.text || "").toLowerCase().indexOf(f) >= 0 || (it.shortcut || "").toLowerCase().indexOf(f) >= 0)
                    r.push(it);
            }
            return r;
        }

        property int _qpNavOffset: 0

        readonly property int _qpSelected: _qpFiltered.length > 0 ? Math.min(_qpNavOffset, _qpFiltered.length - 1) : -1

        visible: root._qpOpen

        // Backdrop
        Rectangle {
            anchors.fill: parent
            color: "#000000"
            opacity: root._qpOpen ? 0.3 : 0.0
            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root._qpOpen = false
            }
        }

        // Panel
        Rectangle {
            anchors.centerIn: parent
            width: Math.min(500, root.width * 0.8)
            height: Math.min(400, root.height * 0.55)
            radius: 12
            color: root.colors.surfaceContainerHigh

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: Qt.rgba(0, 0, 0, 0.25)
                shadowBlur: 0.4
                shadowVerticalOffset: 4
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // Search
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48
                    Layout.leftMargin: 12
                    Layout.rightMargin: 12
                    Layout.topMargin: 12
                    radius: 8
                    color: root.colors.surfaceContainerLow

                    TextInput {
                        id: _qpSearch
                        anchors {
                            left: parent.left
                            leftMargin: 12
                            right: parent.right
                            rightMargin: 12
                            verticalCenter: parent.verticalCenter
                        }
                        font.pixelSize: 14
                        font.family: root.fontFamily
                        color: root.colors.onSurface
                        clip: true

                        focus: true
                        onTextChanged: {
                            _qp._qpFilter = text;
                            _qp._qpNavOffset = 0;
                        }

                        Keys.onUpPressed: {
                            if (_qp._qpNavOffset > 0)
                                _qp._qpNavOffset--;
                        }
                        Keys.onDownPressed: {
                            if (_qp._qpNavOffset < _qp._qpFiltered.length - 1)
                                _qp._qpNavOffset++;
                        }
                        Keys.onReturnPressed: {
                            var s = _qp._qpSelected;
                            if (s >= 0 && s < _qp._qpFiltered.length) {
                                var it = _qp._qpFiltered[s];
                                root._qpOpen = false;
                                root._handleMenuAction(it.menuId, it.itemId);
                            }
                        }

                        Text {
                            anchors {
                                left: parent.left
                                verticalCenter: parent.verticalCenter
                            }
                            text: qsTr("Search commands…")
                            font: parent.font
                            color: root.colors.onSurfaceVariant
                            visible: _qpSearch.text.length === 0
                        }
                    }

                    Accessible.role: Accessible.EditableText
                    Accessible.name: qsTr("Search commands")
                }

                // Results
                ListView {
                    id: _qpList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 8
                    spacing: 2
                    clip: true

                    model: _qp._qpFiltered
                    currentIndex: _qp._qpSelected

                    delegate: Rectangle {
                        required property var modelData
                        required property int index

                        width: _qpList.width
                        height: 36
                        radius: 8
                        color: index === _qp._qpSelected ? root.colors.primaryContainer : (_qpMouse.containsMouse ? Qt.rgba(root.colors.onSurface.r, root.colors.onSurface.g, root.colors.onSurface.b, 0.06) : "transparent")

                        RowLayout {
                            anchors {
                                left: parent.left
                                leftMargin: 12
                                right: parent.right
                                rightMargin: 12
                                verticalCenter: parent.verticalCenter
                            }
                            spacing: 8

                            Text {
                                text: modelData.text || ""
                                font.pixelSize: root.typography.bodyMedium.size
                                font.weight: root.typography.bodyMedium.weight
                                font.family: root.fontFamily
                                color: root.colors.onSurface
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }

                            Text {
                                text: modelData.shortcut || ""
                                font.pixelSize: 11
                                font.family: root.fontFamily
                                color: root.colors.onSurfaceVariant
                                visible: modelData.shortcut !== ""
                            }
                        }

                        MouseArea {
                            id: _qpMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root._qpOpen = false;
                                root._handleMenuAction(modelData.menuId, modelData.itemId);
                            }
                        }
                    }
                }
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════
    //  PUBLIC API
    // ═══════════════════════════════════════════════════════════════

    function showToolbar() {
        toolbarVisible = true;
        _toolbarAutoHidden = false;
    }

    function hideToolbar() {
        if (toolbarBehavior === "autoHide")
            _toolbarAutoHidden = true;
        else
            toolbarVisible = false;
    }

    function toggleToolbar() {
        if (toolbarBehavior === "autoHide")
            _toolbarAutoHidden = !_toolbarAutoHidden;
        else
            toolbarVisible = !toolbarVisible;
    }

    function setMenuStyle(style) {
        if (showMenu)
            menuStyle = style;
    }

    function _toggleToolbarAutoHide() {
        if (toolbarBehavior === "autoHide") {
            toolbarBehavior = "visible";
            _toolbarAutoHidden = false;
        } else {
            toolbarBehavior = "autoHide";
            _toolbarAutoHidden = true;
        }
    }

    // ═══════════════════════════════════════════════════════════════
    //  MENU ACTION DISPATCHER
    // ═══════════════════════════════════════════════════════════════

    function _handleMenuAction(menuId, itemId) {
        if (!showMenu)
            return;
        menuItemTriggered(menuId, itemId);

        if (globalMenuActive)
            globalMenuItemActivated(menuId, itemId);

        switch (menuId + "." + itemId) {
        case "view.sidebar":
            sidebarButtonClicked();
            break;
        case "view.toolbar_autohide":
            _toggleToolbarAutoHide();
            break;
        case "view.focus":
            _focusMode = !_focusMode;
            break;
        case "view.menu_overflow":
            menuStyle = "overflow";
            break;
        case "view.menu_traditional":
            menuStyle = "traditional";
            break;
        case "view.menu_auto":
            menuStyle = "auto";
            break;
        case "file.exit":
            root.close();
            break;
        case "_window.screenshot":
            _screenshotDialog.openDialog();
            break;
        case "_window.recording":
            _recDialog.show();
            break;
        case "_window.quickrecord":
            _quickRecord();
            break;
        case "_window.focus":
            _focusMode = !_focusMode;
            break;
        case "_window.fullscreen":
            root.visibility = root.visibility === Window.FullScreen ? Window.Windowed : Window.FullScreen;
            break;
        case "_window.sidebar":
            sidebarButtonClicked();
            break;
        }
    }
}
