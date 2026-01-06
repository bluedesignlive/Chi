import QtQuick
import QtQuick.Window
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme
import "../common"

Window {
    id: root

    visible: true
    color: "transparent"
    flags: Qt.Window | Qt.FramelessWindowHint

    // Strict minimum width - never smaller than mobile phone
    minimumWidth: 320
    minimumHeight: 400

    // ═══════════════════════════════════════════════════════════════
    // CORE PROPERTIES
    // ═══════════════════════════════════════════════════════════════

    property string title: "Application"
    property bool showControls: true
    property var colors: Theme.ChiTheme.colors

    // ═══════════════════════════════════════════════════════════════
    // TOOLBAR CONFIGURATION
    // ═══════════════════════════════════════════════════════════════

    property string leadingIcon: ""
    property bool showTitle: true
    property bool centerTitle: true
    property bool autoHideTitle: true
    property int toolbarHeight: 48
    property bool toolbarVisible: true
    property string toolbarBehavior: "visible"  // visible | autoHide

    property list<QtObject> toolbarActions: []

    // ═══════════════════════════════════════════════════════════════
    // MENU SYSTEM
    // ═══════════════════════════════════════════════════════════════

    property string menuStyle: "auto"  // auto | traditional | collapsed
    property string collapsedMenuIcon: "menu"  // menu | more_horiz
    property var customMenus: []
    property bool showDefaultMenus: true
    property bool showMenuButton: true

    // ═══════════════════════════════════════════════════════════════
    // SIDEBAR BUTTON
    // ═══════════════════════════════════════════════════════════════

    property bool showSidebarButton: false
    property bool sidebarOpen: false

    // ═══════════════════════════════════════════════════════════════
    // WINDOW CONTROLS STYLE - macOS is DEFAULT
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
    // CONTEXT - Platform & Breakpoint Detection
    // ═══════════════════════════════════════════════════════════════

    readonly property QtObject context: QtObject {
        readonly property bool isMacOS: Qt.platform.os === "osx"
        readonly property bool isWindows: Qt.platform.os === "windows"
        readonly property bool isLinux: Qt.platform.os === "linux"
        readonly property bool isMobile: Qt.platform.os === "android" || Qt.platform.os === "ios"
        readonly property bool isWeb: Qt.platform.os === "wasm"
        readonly property bool isDesktop: !isMobile && !isWeb

        readonly property int windowWidth: root.width
        readonly property int windowHeight: root.height

        readonly property string breakpoint: {
            if (windowWidth < 600) return "compact"
            if (windowWidth < 840) return "medium"
            if (windowWidth < 1200) return "expanded"
            if (windowWidth < 1600) return "large"
            return "xlarge"
        }

        readonly property bool isCompact: breakpoint === "compact"
        readonly property bool isMedium: breakpoint === "medium"
        readonly property bool isExpanded: breakpoint === "expanded"
        readonly property bool isLarge: breakpoint === "large"
        readonly property bool isXLarge: breakpoint === "xlarge"

        readonly property bool showWindowControls: isDesktop && !isWeb
        readonly property bool useOverlaySidebar: isCompact || isMedium

        onBreakpointChanged: root.breakpointChanged(breakpoint)
    }

    // ═══════════════════════════════════════════════════════════════
    // INTERNAL STATE
    // ═══════════════════════════════════════════════════════════════

    readonly property bool isMaximized: visibility === Window.Maximized
    readonly property real windowRadius: isMaximized ? 0 : 24
    readonly property real windowMargin: isMaximized ? 0 : 12

    // Menu style - stays traditional as long as physically possible
    // Only collapses when there's truly no space for the menu itself
    readonly property string _effectiveMenuStyle: {
        if (menuStyle === "collapsed") return "collapsed"
        if (menuStyle === "traditional") return "traditional"
        // Auto mode - stay traditional as long as menu fits
        // Menu collapses only when window is too narrow for menu + right actions
        let minSpaceForMenu = _estimatedMenuWidth + _estimatedRightWidth + 60
        if (root.width < minSpaceForMenu) return "collapsed"
        return "traditional"
    }

    // Estimate menu width (roughly 60px per menu item)
    readonly property real _estimatedMenuWidth: _allMenus.length * 60
    // Estimate right section width
    readonly property real _estimatedRightWidth: (toolbarActions.length * 40) + (controlsOnLeft ? 0 : 110)

    property bool _toolbarAutoHidden: false
    readonly property bool _showToolbar: {
        if (!toolbarVisible) return false
        if (toolbarBehavior === "autoHide") return !_toolbarAutoHidden || toolbarHoverArea.containsMouse
        return true
    }

    // ═══════════════════════════════════════════════════════════════
    // DEFAULT MENUS - with Auto option in View
    // ═══════════════════════════════════════════════════════════════

    readonly property var _defaultMenus: [
        {
            id: "file", title: "File",
            items: [
                { id: "new", text: "New", shortcut: "Ctrl+N", icon: "add" },
                { id: "open", text: "Open", shortcut: "Ctrl+O", icon: "folder_open" },
                { type: "divider" },
                { id: "save", text: "Save", shortcut: "Ctrl+S", icon: "save" },
                { id: "saveAs", text: "Save As...", shortcut: "Ctrl+Shift+S" },
                { type: "divider" },
                { id: "exit", text: "Exit", shortcut: "Alt+F4", icon: "logout" }
            ]
        },
        {
            id: "edit", title: "Edit",
            items: [
                { id: "undo", text: "Undo", shortcut: "Ctrl+Z", icon: "undo" },
                { id: "redo", text: "Redo", shortcut: "Ctrl+Y", icon: "redo" },
                { type: "divider" },
                { id: "cut", text: "Cut", shortcut: "Ctrl+X", icon: "content_cut" },
                { id: "copy", text: "Copy", shortcut: "Ctrl+C", icon: "content_copy" },
                { id: "paste", text: "Paste", shortcut: "Ctrl+V", icon: "content_paste" }
            ]
        },
        {
            id: "view", title: "View",
            items: [
                { id: "sidebar", text: "Toggle Sidebar", shortcut: "Ctrl+B", icon: "view_sidebar" },
                { type: "divider" },
                { id: "menu_auto", text: "Auto Menu", icon: "tune" },
                { id: "menu_traditional", text: "Traditional Menu", icon: "menu_open" },
                { id: "menu_collapsed", text: "Collapsed Menu", icon: "menu" },
                { type: "divider" },
                { id: "icon_hamburger", text: "Hamburger Icon", icon: "menu" },
                { id: "icon_dots", text: "Dots Icon", icon: "more_horiz" }
            ]
        },
        {
            id: "help", title: "Help",
            items: [
                { id: "docs", text: "Documentation", icon: "menu_book" },
                { id: "shortcuts", text: "Keyboard Shortcuts", icon: "keyboard" },
                { type: "divider" },
                { id: "about", text: "About", icon: "info" }
            ]
        }
    ]

    readonly property var _allMenus: {
        let result = []
        if (showDefaultMenus) {
            for (let i = 0; i < _defaultMenus.length; i++) {
                result.push(_defaultMenus[i])
            }
        }
        for (let j = 0; j < customMenus.length; j++) {
            result.push(customMenus[j])
        }
        return result
    }

    // ═══════════════════════════════════════════════════════════════
    // DROP SHADOW
    // ═══════════════════════════════════════════════════════════════

    Rectangle {
        id: shadowSource
        anchors.fill: windowShape
        radius: windowRadius
        color: colors.background
        visible: false
    }

    DropShadow {
        anchors.fill: shadowSource
        source: shadowSource
        horizontalOffset: 0
        verticalOffset: 8
        radius: 32
        samples: 65
        color: Qt.rgba(0, 0, 0, 0.25)
        visible: !root.isMaximized
        z: -1
    }

    // ═══════════════════════════════════════════════════════════════
    // WINDOW SHAPE
    // ═══════════════════════════════════════════════════════════════

    Rectangle {
        id: windowShape
        anchors.fill: parent
        anchors.margins: windowMargin
        radius: windowRadius
        visible: false
    }

    // ═══════════════════════════════════════════════════════════════
    // MAIN MASKED CONTENT
    // ═══════════════════════════════════════════════════════════════

    Item {
        id: maskedArea
        anchors.fill: windowShape

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: windowShape
        }
        layer.smooth: true
        layer.samples: 8

        Rectangle {
            anchors.fill: parent
            color: colors.background
        }

        // ═════════════════════════════════════════════════════════
        // AUTO-HIDE HOVER AREA
        // ═════════════════════════════════════════════════════════

        MouseArea {
            id: toolbarHoverArea
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: root.toolbarBehavior === "autoHide" && root._toolbarAutoHidden ? 12 : 0
            hoverEnabled: true
            visible: root.toolbarBehavior === "autoHide"
            z: 101
        }

        // ═════════════════════════════════════════════════════════
        // TOOLBAR
        // ═════════════════════════════════════════════════════════

        Rectangle {
            id: toolbar
            height: root._showToolbar ? root.toolbarHeight : 0
            visible: height > 0
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            z: 100
            clip: true

            color: colors.surfaceContainer

            Behavior on height {
                NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
            }

            // Drag area
            MouseArea {
                anchors.fill: parent
                z: -1
                onPressed: root.startSystemMove()
                onDoubleClicked: {
                    if (root.isMaximized) root.showNormal()
                    else root.showMaximized()
                }
            }

            // ═══ LEFT SECTION ═══
            Item {
                id: leftSection
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                width: leftRow.implicitWidth
                height: parent.height

                Row {
                    id: leftRow
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 4

                    // Window controls (macOS - left)
                    WindowControls {
                        visible: root.showControls && root.controlsOnLeft && root.context.showWindowControls
                        targetWindow: root
                        variant: root.controlsStyle
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Item { 
                        width: 8
                        height: 1
                        visible: root.controlsOnLeft && root.showControls && root.context.showWindowControls 
                    }

                    // Menu button (collapsed mode)
                    ToolbarIconButton {
                        visible: root.showMenuButton && root._effectiveMenuStyle === "collapsed"
                        icon: root.collapsedMenuIcon
                        onClicked: overflowMenu.open()

                        OverflowMenu {
                            id: overflowMenu
                            menus: root._allMenus
                            maxHeight: root.height - 100
                            onItemTriggered: (menuId, itemId) => root._handleMenuAction(menuId, itemId)
                        }
                    }

                    // Sidebar button
                    ToolbarIconButton {
                        visible: root.showSidebarButton
                        icon: "view_sidebar"
                        checked: root.sidebarOpen
                        onClicked: root.sidebarButtonClicked()
                    }

                    // Leading action
                    ToolbarIconButton {
                        visible: root.leadingIcon !== ""
                        icon: root.leadingIcon
                        onClicked: root.leadingActionTriggered()
                    }

                    // Traditional menu bar - stays as long as physically possible
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

            // ═══ RIGHT SECTION ═══
            Item {
                id: rightSection
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                width: rightRow.implicitWidth
                height: parent.height

                Row {
                    id: rightRow
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 4

                    Repeater {
                        model: root.toolbarActions

                        ToolbarIconButton {
                            icon: modelData.icon || ""
                            checked: modelData.checked || false
                            enabled: modelData.enabled !== false

                            onClicked: {
                                if (modelData.triggered) modelData.triggered()
                                root.toolbarActionTriggered(index)
                            }
                        }
                    }

                    Item { 
                        width: 8
                        height: 1
                        visible: !root.controlsOnLeft && root.showControls && root.context.showWindowControls 
                    }

                    // Window controls (Windows - right)
                    WindowControls {
                        visible: root.showControls && !root.controlsOnLeft && root.context.showWindowControls
                        targetWindow: root
                        variant: root.controlsStyle
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            // ═══ CENTER TITLE - Hides when close to menu, menu stays ═══
            Text {
                id: titleText
                // Title hides when it gets close to menu - menu is more important
                visible: root.showTitle && !_titleTooCloseToMenu

                // True center or left-aligned after left section
                x: root.centerTitle ? Math.max(leftEdge, (parent.width - implicitWidth) / 2) : leftEdge
                anchors.verticalCenter: parent.verticalCenter

                text: root.title
                font.family: "Roboto"
                font.weight: Font.Medium
                font.pixelSize: 14
                color: colors.onSurface
                elide: Text.ElideRight

                readonly property real leftEdge: leftSection.x + leftSection.width + 16
                readonly property real rightEdge: rightSection.x - 16
                readonly property real availableSpace: Math.max(0, rightEdge - leftEdge)

                // Title hides when too close to menu/left section
                readonly property bool _titleTooCloseToMenu: {
                    if (!root.autoHideTitle) return false
                    
                    // Not enough space
                    if (availableSpace < 80) return true
                    
                    // For centered title, check if it would get close to left section
                    if (root.centerTitle) {
                        let centeredX = (toolbar.width - implicitWidth) / 2
                        // Too close to left section (within 20px)?
                        if (centeredX < leftEdge + 20) return true
                        // Too close to right section?
                        if (centeredX + implicitWidth > rightEdge - 20) return true
                    }
                    return false
                }

                width: Math.min(implicitWidth, availableSpace)
            }
        }

        // ═════════════════════════════════════════════════════════
        // CONTENT AREA
        // ═════════════════════════════════════════════════════════

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
    // WINDOW BORDER
    // ═══════════════════════════════════════════════════════════════

    Rectangle {
        anchors.fill: windowShape
        radius: windowRadius
        color: "transparent"
        border.width: 1
        border.color: Qt.rgba(colors.shadow.r, colors.shadow.g, colors.shadow.b, 0.15)
        visible: !root.isMaximized
        z: 1000

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: windowRadius - 1
            color: "transparent"
            border.width: 0.5
            border.color: Qt.rgba(1, 1, 1, Theme.ChiTheme.isDarkMode ? 0.05 : 0.5)
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // RESIZE HANDLES
    // ═══════════════════════════════════════════════════════════════

    Item {
        anchors.fill: parent
        visible: !root.isMaximized
        z: 1010

        property int edge: 6
        property int corner: 20

        MouseArea { anchors { top: parent.top; left: parent.left; right: parent.right } height: parent.edge; cursorShape: Qt.SizeVerCursor; onPressed: root.startSystemResize(Qt.TopEdge) }
        MouseArea { anchors { bottom: parent.bottom; left: parent.left; right: parent.right } height: parent.edge; cursorShape: Qt.SizeVerCursor; onPressed: root.startSystemResize(Qt.BottomEdge) }
        MouseArea { anchors { left: parent.left; top: parent.top; bottom: parent.bottom } width: parent.edge; cursorShape: Qt.SizeHorCursor; onPressed: root.startSystemResize(Qt.LeftEdge) }
        MouseArea { anchors { right: parent.right; top: parent.top; bottom: parent.bottom } width: parent.edge; cursorShape: Qt.SizeHorCursor; onPressed: root.startSystemResize(Qt.RightEdge) }
        MouseArea { anchors { top: parent.top; left: parent.left } width: parent.corner; height: parent.corner; cursorShape: Qt.SizeFDiagCursor; onPressed: root.startSystemResize(Qt.TopEdge | Qt.LeftEdge) }
        MouseArea { anchors { top: parent.top; right: parent.right } width: parent.corner; height: parent.corner; cursorShape: Qt.SizeBDiagCursor; onPressed: root.startSystemResize(Qt.TopEdge | Qt.RightEdge) }
        MouseArea { anchors { bottom: parent.bottom; left: parent.left } width: parent.corner; height: parent.corner; cursorShape: Qt.SizeBDiagCursor; onPressed: root.startSystemResize(Qt.BottomEdge | Qt.LeftEdge) }
        MouseArea { anchors { bottom: parent.bottom; right: parent.right } width: parent.corner; height: parent.corner; cursorShape: Qt.SizeFDiagCursor; onPressed: root.startSystemResize(Qt.BottomEdge | Qt.RightEdge) }
    }

    // ═══════════════════════════════════════════════════════════════
    // TOOLBAR ICON BUTTON
    // ═══════════════════════════════════════════════════════════════

    component ToolbarIconButton: Item {
        id: toolBtn
        property string icon: ""
        property bool checked: false
        property alias enabled: toolBtnMouse.enabled
        signal clicked()

        implicitWidth: 36
        implicitHeight: 36
        width: 36
        height: 36
        opacity: enabled ? 1.0 : 0.38

        Rectangle {
            anchors.fill: parent
            radius: 10
            color: {
                if (toolBtn.checked) return colors.secondaryContainer
                if (toolBtnMouse.pressed) return Qt.rgba(colors.primary.r, colors.primary.g, colors.primary.b, 0.15)
                if (toolBtnMouse.containsMouse) return Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.08)
                return "transparent"
            }
        }

        Icon {
            anchors.centerIn: parent
            source: toolBtn.icon
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
    // MENU BAR BUTTON (Traditional)
    // ═══════════════════════════════════════════════════════════════

    component MenuBarButton: Item {
        id: menuBtn
        property var menuData: ({})
        signal itemTriggered(string itemId)

        implicitWidth: menuLabel.implicitWidth + 20
        implicitHeight: 36
        width: implicitWidth
        height: 36

        Rectangle {
            anchors.fill: parent
            radius: 8
            color: menuBtnMouse.containsMouse || dropdownMenu.visible ? Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.08) : "transparent"
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
    // PUBLIC API
    // ═══════════════════════════════════════════════════════════════

    function showToolbar() { toolbarVisible = true; _toolbarAutoHidden = false }
    function hideToolbar() { if (toolbarBehavior === "autoHide") _toolbarAutoHidden = true; else toolbarVisible = false }
    function toggleToolbar() { if (toolbarBehavior === "autoHide") _toolbarAutoHidden = !_toolbarAutoHidden; else toolbarVisible = !toolbarVisible }
    function setMenuStyle(style) { menuStyle = style }

    function _handleMenuAction(menuId, itemId) {
        menuItemTriggered(menuId, itemId)

        if (menuId === "view") {
            if (itemId === "sidebar") sidebarButtonClicked()
            else if (itemId === "menu_auto") menuStyle = "auto"
            else if (itemId === "menu_traditional") menuStyle = "traditional"
            else if (itemId === "menu_collapsed") menuStyle = "collapsed"
            else if (itemId === "icon_hamburger") collapsedMenuIcon = "menu"
            else if (itemId === "icon_dots") collapsedMenuIcon = "more_horiz"
        } else if (menuId === "file" && itemId === "exit") {
            root.close()
        }
    }
}
