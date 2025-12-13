import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme
import "." as Menus

Item {
    id: root

    property bool open: false
    property real minWidth: 112
    property real maxWidth: 280
    property real maxHeight: 400

    property string variant: "expressive"
    property string colorStyle: "standard"

    default property alias items: menuColumn.data

    signal closed()
    signal itemClicked(int index)

    property var colors: Theme.ChiTheme.colors

    readonly property color containerColor: {
        if (colorStyle === "vibrant") return colors.tertiaryContainer
        return colors.surfaceContainerLow
    }

    readonly property real cornerRadius: variant === "expressive" ? 16 : 4

    implicitWidth: Math.max(minWidth, Math.min(menuColumn.implicitWidth + 24, maxWidth))
    implicitHeight: Math.min(menuColumn.implicitHeight + 16, maxHeight)

    visible: false

    property Item appWindow: {
        var p = root
        while (p) {
            if (p.toString().indexOf("ApplicationWindow") !== -1 ||
                p.toString().indexOf("Window") !== -1 ||
                !p.parent) {
                return p
            }
            p = p.parent
        }
        return null
    }

    property real menuX: 0
    property real menuY: 0

    Component.onCompleted: Menus.MenuManager.registerMenu(root)
    Component.onDestruction: Menus.MenuManager.unregisterMenu(root)

    onColorStyleChanged: updateChildrenStyle()
    onVariantChanged: updateChildrenStyle()

    function updateChildrenStyle() {
        for (var i = 0; i < menuColumn.children.length; i++) {
            var child = menuColumn.children[i]
            if (child.hasOwnProperty("menuColorStyle")) child.menuColorStyle = colorStyle
            if (child.hasOwnProperty("menuVariant")) child.menuVariant = variant
        }
    }

    function updatePosition() {
        if (!appWindow) return
        var pos = root.mapToItem(appWindow, 0, 0)
        menuX = Math.round(pos.x)
        menuY = Math.round(pos.y)
    }

    // Timer for re-triggering animation
    Timer {
        id: reopenTimer
        interval: 16
        onTriggered: {
            updatePosition()
            open = true
        }
    }

    Item {
        id: popupContainer
        visible: root.open || scaleAnim.running || opacityAnim.running
        parent: root.appWindow || root.parent
        x: root.menuX
        y: root.menuY
        width: root.implicitWidth
        height: root.implicitHeight
        z: 10000

        MouseArea {
            id: dismissArea
            parent: popupContainer.parent
            anchors.fill: parent
            visible: popupContainer.visible
            z: popupContainer.z - 1
            onClicked: root.close()
        }

        Rectangle {
            id: container
            width: popupContainer.width
            height: popupContainer.height
            radius: cornerRadius
            color: containerColor
            clip: true

            opacity: root.open ? 1 : 0
            scale: root.open ? 1 : 0.9
            transformOrigin: Item.TopLeft

            Behavior on opacity {
                NumberAnimation {
                    id: opacityAnim
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on scale {
                NumberAnimation {
                    id: scaleAnim
                    duration: root.open ? 200 : 150
                    easing.type: root.open ? Easing.OutBack : Easing.OutCubic
                    easing.overshoot: 1.2
                }
            }

            Behavior on color { ColorAnimation { duration: 200 } }

            border.width: 1
            border.color: colors.outlineVariant

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 6
                radius: 16
                samples: 25
                color: Qt.rgba(0, 0, 0, 0.18)
            }

            Flickable {
                anchors.fill: parent
                anchors.margins: 8
                contentHeight: menuColumn.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                Column {
                    id: menuColumn
                    width: parent.width
                    spacing: 0

                    onChildrenChanged: {
                        connectMenuItems()
                        root.updateChildrenStyle()
                    }
                    Component.onCompleted: {
                        connectMenuItems()
                        root.updateChildrenStyle()
                    }
                }
            }
        }
    }

    function connectMenuItems() {
        for (var i = 0; i < menuColumn.children.length; i++) {
            var child = menuColumn.children[i]
            if (child.hasOwnProperty("clicked")) {
                try { child.clicked.disconnect(handleItemClick) } catch(e) {}
                child.clicked.connect(handleItemClick)
            }
        }
    }

    function handleItemClick() { close() }

    function show() {
        Menus.MenuManager.closeAllExcept(root)
        
        // If already open, close and reopen to retrigger animation
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
        closed()
    }

    function toggle() {
        if (open) close()
        else show()
    }

    Keys.onEscapePressed: close()
    onOpenChanged: if (open) forceActiveFocus()
}
