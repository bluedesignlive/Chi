import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Item {
    id: root

    property bool open: false
    property real minWidth: 112
    property real maxWidth: 280
    property real maxHeight: 400

    default property alias items: menuColumn.data

    signal closed()

    z: 1000

    property var colors: Theme.ChiTheme.colors

    // Calculate content size
    implicitWidth: Math.max(minWidth, Math.min(menuColumn.implicitWidth + 16, maxWidth))
    implicitHeight: Math.min(menuColumn.implicitHeight + 16, maxHeight)

    visible: open || hideAnimation.running

    // Background overlay (optional, for modal menus)
    MouseArea {
        anchors.fill: parent
        parent: root.parent
        visible: open
        z: root.z - 1
        onClicked: root.close()
    }

    Rectangle {
        id: container
        width: root.implicitWidth
        height: root.implicitHeight
        radius: 4
        color: colors.surfaceContainer
        clip: true

        opacity: open ? 1 : 0
        scale: open ? 1 : 0.9
        transformOrigin: Item.TopLeft

        Behavior on opacity {
            NumberAnimation {
                id: hideAnimation
                duration: 150
                easing.type: Easing.OutCubic
            }
        }
        Behavior on scale {
            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
        }
        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 4
            radius: 12
            samples: 17
            color: Qt.rgba(0, 0, 0, 0.25)
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
            }
        }
    }

    function show() {
        open = true
    }

    function close() {
        open = false
        closed()
    }

    function toggle() {
        if (open) close()
        else show()
    }

    Keys.onEscapePressed: close()
}
