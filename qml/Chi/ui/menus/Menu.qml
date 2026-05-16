// qml/smartui/ui/menus/Menu.qml
// M3 menu — desktop-density default, in-place submenu navigation
// Also supports cascade mode (flyout panel to the right, desktop style)
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../../theme" as Theme
import "." as Menus
import "../common" as Common

Item {
    id: root

    // ═══════════════════════════════════════════════════════════════════
    // PUBLIC API
    // ═══════════════════════════════════════════════════════════════════

    property bool open: false
    property real minWidth: 112
    property real maxWidth: 264
    property real maxHeight: 400

    property string variant: "expressive"
    property string colorStyle: "standard"
    property string density: "compact"
    property string submenuStyle: "navigate" // "navigate" | "cascade"

    default property alias items: menuColumn.data

    signal closed()
    signal itemClicked(int index)
    signal submenuItemClicked(string itemId)

    property var colors: Theme.ChiTheme.colors
    property var motion: Theme.ChiTheme.motion

    readonly property color _containerColor: colorStyle === "vibrant"
        ? colors.tertiaryContainer : colors.surfaceContainerLow
    readonly property real _cornerRadius: variant === "expressive" ? 12 : 4
    readonly property real _pad: 4

    // ═══════════════════════════════════════════════════════════════════
    // SUBMENU NAVIGATION STACK
    // ═══════════════════════════════════════════════════════════════════

    property var _navStack: []
    readonly property bool _inSubmenu: _navStack.length > 0
    readonly property string _subTitle: _inSubmenu
        ? _navStack[_navStack.length - 1].title : ""
    readonly property var _subItems: _inSubmenu
        ? _navStack[_navStack.length - 1].items : []

    // Single transition value drives both views — 0 = main, 1 = submenu
    property real _t: _inSubmenu ? 1 : 0
    Behavior on _t {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    function _pushSubmenu(title, items) {
        var s = _navStack.slice()
        s.push({ title: title, items: items })
        _navStack = s
    }

    function _popSubmenu() {
        if (_navStack.length > 0) {
            var s = _navStack.slice()
            s.pop()
            _navStack = s
        }
    }

    function _clearSubmenu() { _navStack = [] }

    // ═══════════════════════════════════════════════════════════════════
    // SIZING
    // ═══════════════════════════════════════════════════════════════════

    readonly property real _mainH: menuColumn.implicitHeight + _pad * 2
    readonly property real _subH: _subColumn.implicitHeight + _pad * 2
    readonly property real _targetH: _inSubmenu ? _subH : _mainH

    // In cascade mode, width stays at max of main width
    implicitWidth: Math.max(minWidth, Math.min(
        Math.max(menuColumn.implicitWidth + 24 + _pad * 2,
                 _subColumn.implicitWidth + 24 + _pad * 2),
        maxWidth))
    implicitHeight: Math.min(_targetH, maxHeight)

    visible: false

    // ═══════════════════════════════════════════════════════════════════
    // APP WINDOW LOOKUP
    // ═══════════════════════════════════════════════════════════════════

    property Item appWindow: null
    Component.onCompleted: {
        var p = root
        while (p && p.parent) p = p.parent
        appWindow = p
        Menus.MenuManager.registerMenu(root)
        _connectMenuItems()
        _applyStyle()
    }
    Component.onDestruction: Menus.MenuManager.unregisterMenu(root)

    property real menuX: 0
    property real menuY: 0

    onColorStyleChanged: _applyStyle()
    onVariantChanged: _applyStyle()
    onDensityChanged: _applyStyle()

    function _applyStyle() {
        for (var i = 0; i < menuColumn.children.length; ++i) {
            var c = menuColumn.children[i]
            if (c.hasOwnProperty("menuColorStyle")) c.menuColorStyle = colorStyle
            if (c.hasOwnProperty("menuVariant")) c.menuVariant = variant
            if (c.hasOwnProperty("menuDensity")) c.menuDensity = density
        }
    }

    function updatePosition() {
        if (!appWindow) return
        var pos = root.mapToItem(appWindow, 0, 0)
        menuX = Math.round(pos.x)
        menuY = Math.round(pos.y)
    }

    // ═══════════════════════════════════════════════════════════════════
    // POPUP CONTAINER
    // ═══════════════════════════════════════════════════════════════════

    Timer {
        id: reopenTimer
        interval: 16
        onTriggered: { updatePosition(); open = true }
    }

    Item {
        id: popupContainer
        visible: root.open || _opacityAnim.running || _scaleAnim.running
        parent: root.appWindow || root.parent
        x: root.menuX; y: root.menuY
        // In cascade mode, width is the same for the surface
        width: root.submenuStyle === "cascade" && root._inSubmenu
            ? root.implicitWidth + _cascadePanel.width
            : root.implicitWidth
        height: root.implicitHeight
        z: 10000

        Behavior on height {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }

        // Dismiss overlay
        MouseArea {
            parent: popupContainer.parent
            anchors.fill: parent
            visible: popupContainer.visible
            z: popupContainer.z - 1
            onClicked: root.close()
        }

        // Menu surface
        Rectangle {
            id: container
            width: root.implicitWidth
            height: popupContainer.height
            radius: root._cornerRadius
            color: root._containerColor
            clip: true
            border.width: 1
            border.color: colors.outlineVariant

            opacity: root.open ? 1 : 0
            scale: root.open ? 1 : 0.92
            transformOrigin: Item.TopLeft

            Behavior on opacity {
                NumberAnimation {
                    id: _opacityAnim
                    duration: 150; easing.type: Easing.OutCubic
                }
            }
            Behavior on scale {
                NumberAnimation {
                    id: _scaleAnim
                    duration: root.open ? 200 : 120
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on color { ColorAnimation { duration: 150 } }

            // Shadow — single-pass MultiEffect
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: Qt.rgba(0, 0, 0, 0.18)
                shadowVerticalOffset: 6
                shadowBlur: 0.4
            }

            // ═══════════════════════════════════════════════════════
            // MAIN VIEW — declarative children
            // ═══════════════════════════════════════════════════════

            Flickable {
                id: _mainFlick
                x: root._pad
                y: root._pad
                width: container.width - root._pad * 2
                height: container.height - root._pad * 2
                contentHeight: menuColumn.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                opacity: root.submenuStyle === "cascade" ? 1 : (1 - root._t)
                visible: root.submenuStyle === "cascade" ? true : (opacity > 0.01)

                Column {
                    id: menuColumn
                    width: parent.width
                    spacing: 0

                    onChildrenChanged: {
                        root._connectMenuItems()
                        root._applyStyle()
                    }
                }
            }

            // ═══════════════════════════════════════════════════════
            // SUBMENU VIEW — data-driven, uses actual MenuItem
            // Only in navigate mode: pure crossfade within same surface
            // In cascade mode: the _cascadePanel handles display
            // ═══════════════════════════════════════════════════════

            Flickable {
                id: _subFlick
                x: root._pad
                y: root._pad
                width: container.width - root._pad * 2
                height: container.height - root._pad * 2
                contentHeight: _subColumn.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                opacity: root.submenuStyle === "cascade" ? 0 : root._t
                visible: opacity > 0.01

                Column {
                    id: _subColumn
                    width: parent.width
                    spacing: 0

                    // Back header — in navigate mode only (in cascade, it's in panel)
                    Menus.MenuItem {
                        width: parent.width
                        text: root._subTitle
                        leadingIcon: "arrow_back"
                        visible: root._inSubmenu
                        menuDensity: root.density
                        menuVariant: root.variant
                        menuColorStyle: root.colorStyle
                        onClicked: root._popSubmenu()
                    }

                    // Divider below back header
                    Menus.MenuDivider {
                        width: parent.width
                        visible: root._inSubmenu
                    }

                    // Submenu items — actual MenuItem and MenuDivider
                    Repeater {
                        model: root._subItems

                        delegate: Item {
                            required property var modelData
                            required property int index

                            width: _subColumn.width
                            height: _isDivider ? _div.implicitHeight : _item.implicitHeight
                            implicitHeight: height

                            readonly property bool _isDivider: (modelData.type || "") === "divider"

                            Menus.MenuDivider {
                                id: _div
                                visible: _isDivider
                                width: parent.width
                            }

                            Menus.MenuItem {
                                id: _item
                                visible: !_isDivider
                                width: parent.width
                                text: modelData.text || ""
                                leadingIcon: modelData.icon || ""
                                trailingText: modelData.shortcut || ""
                                submenu: modelData.submenu || null
                                menuDensity: root.density
                                menuVariant: root.variant
                                menuColorStyle: root.colorStyle

                                onClicked: {
                                    root.submenuItemClicked(modelData.id || "")
                                    root.close()
                                }
                                onSubmenuRequested: function(title, items) {
                                    root._pushSubmenu(title, items)
                                }
                            }
                        }
                    }
                }
            }
        }

        // ═══════════════════════════════════════════════════════
        // CASCADE PANEL (submenuStyle === "cascade" only)
        // Slides out to the right of the main surface
        // ═══════════════════════════════════════════════════════

        Rectangle {
            id: _cascadePanel
            visible: root.submenuStyle === "cascade" && root._inSubmenu
            x: container.width + 4
            y: 0
            width: root.submenuStyle === "cascade" ? Math.max(minWidth, Math.min(
                _cascadeSubCol.implicitWidth + root._pad * 2, maxWidth)) : 0
            height: root.submenuStyle === "cascade" ? Math.min(
                _cascadeSubCol.implicitHeight + root._pad * 2,
                root.maxHeight) : 0
            radius: root._cornerRadius
            color: root._containerColor
            clip: true
            border.width: 1
            border.color: colors.outlineVariant

            // Cascade panel reveal animation
            OpacityAnimator on opacity {
                id: _cascadeOpacityAnim
                running: root.submenuStyle === "cascade" && root._inSubmenu
                from: 0; to: 1
                duration: 180
                easing.type: Easing.OutCubic
            }
            XAnimator on x {
                id: _cascadeXAnim
                running: root.submenuStyle === "cascade" && root._inSubmenu
                from: container.width; to: container.width + 4
                duration: 200
                easing.type: Easing.OutCubic
            }

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: Qt.rgba(0, 0, 0, 0.18)
                shadowVerticalOffset: 6
                shadowBlur: 0.4
            }

            Flickable {
                id: _cascadeSubFlick
                x: root._pad
                y: root._pad
                width: _cascadePanel.width - root._pad * 2
                height: _cascadePanel.height - root._pad * 2
                contentHeight: cascadeSubCol.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                Column {
                    id: _cascadeSubCol
                    width: parent.width
                    spacing: 0

                    // Back header with arrow indicator
                    Menus.MenuItem {
                        width: parent.width
                        text: root._subTitle
                        leadingIcon: "arrow_back"
                        visible: root._inSubmenu
                        menuDensity: root.density
                        menuVariant: root.variant
                        menuColorStyle: root.colorStyle
                        onClicked: root._popSubmenu()
                    }

                    Menus.MenuDivider {
                        width: parent.width
                        visible: root._inSubmenu
                    }

                    Repeater {
                        model: root._subItems

                        delegate: Item {
                            required property var modelData
                            required property int index

                            width: _cascadeSubCol.width
                            height: _isDivider ? _cascadeDiv.implicitHeight : _cascadeItem.implicitHeight
                            implicitHeight: height

                            readonly property bool _isDivider: (modelData.type || "") === "divider"

                            Menus.MenuDivider {
                                id: _cascadeDiv
                                visible: _isDivider
                                width: parent.width
                            }

                            Menus.MenuItem {
                                id: _cascadeItem
                                visible: !_isDivider
                                width: parent.width
                                text: modelData.text || ""
                                leadingIcon: modelData.icon || ""
                                trailingText: modelData.shortcut || ""
                                submenu: modelData.submenu || null
                                menuDensity: root.density
                                menuVariant: root.variant
                                menuColorStyle: root.colorStyle

                                onClicked: {
                                    root.submenuItemClicked(modelData.id || "")
                                    root.close()
                                }
                                onSubmenuRequested: function(title, items) {
                                    root._pushSubmenu(title, items)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════════
    // INTERNAL — connect child MenuItem signals
    // ═══════════════════════════════════════════════════════════════════

    function _connectMenuItems() {
        for (var i = 0; i < menuColumn.children.length; ++i) {
            var c = menuColumn.children[i]
            if (c.hasOwnProperty("clicked")) {
                try { c.clicked.disconnect(_handleItemClick) } catch(e) {}
                c.clicked.connect(_handleItemClick)
            }
            if (c.hasOwnProperty("submenuRequested")) {
                try { c.submenuRequested.disconnect(_pushSubmenu) } catch(e) {}
                c.submenuRequested.connect(_pushSubmenu)
            }
        }
    }

    function _handleItemClick() { close() }

    // ═══════════════════════════════════════════════════════════════════
    // PUBLIC FUNCTIONS
    // ═══════════════════════════════════════════════════════════════════

    function show() {
        Menus.MenuManager.closeAllExcept(root)
        if (open) {
            open = false
            reopenTimer.start()
        } else {
            updatePosition()
            open = true
        }
    }

    function close() {
        reopenTimer.stop()
        open = false
        _clearSubmenu()
        _mainFlick.contentY = 0
        _subFlick.contentY = 0
        closed()
    }

    function toggle() {
        if (open) close(); else show()
    }

    // ═══════════════════════════════════════════════════════════════════
    // KEYBOARD
    // ═══════════════════════════════════════════════════════════════════

    Keys.onEscapePressed: {
        if (root.submenuStyle === "cascade" && _inSubmenu) {
            _popSubmenu()
        } else if (_inSubmenu) {
            _popSubmenu()
        } else {
            close()
        }
    }
    onOpenChanged: if (open) forceActiveFocus()
}