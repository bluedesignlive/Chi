import QtQuick
import "../../theme" as Theme

Item {
    id: root

    property string orientation: "horizontal" // "horizontal", "vertical"
    property real position: 0.3
    property real minPosition: 0.1
    property real maxPosition: 0.9
    property bool enabled: true
    property real handleSize: 6

    property alias firstItem: firstContainer.data
    property alias secondItem: secondContainer.data

    implicitWidth: 600
    implicitHeight: 400

    property var colors: Theme.ChiTheme.colors

    readonly property bool isHorizontal: orientation === "horizontal"

    Item {
        id: firstContainer
        anchors.left: parent.left
        anchors.top: parent.top
        width: isHorizontal ? parent.width * position - handleSize / 2 : parent.width
        height: isHorizontal ? parent.height : parent.height * position - handleSize / 2
    }

    Rectangle {
        id: handle
        color: handleMouse.containsMouse || handleMouse.pressed ? colors.primary : colors.outlineVariant
        opacity: handleMouse.containsMouse || handleMouse.pressed ? 1 : 0.5

        Behavior on color {
            ColorAnimation { duration: 150 }
        }
        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }

        x: isHorizontal ? parent.width * position - handleSize / 2 : 0
        y: isHorizontal ? 0 : parent.height * position - handleSize / 2
        width: isHorizontal ? handleSize : parent.width
        height: isHorizontal ? parent.height : handleSize

        MouseArea {
            id: handleMouse
            anchors.fill: parent
            anchors.margins: -4
            hoverEnabled: true
            cursorShape: isHorizontal ? Qt.SplitHCursor : Qt.SplitVCursor
            enabled: root.enabled

            drag.target: dragProxy
            drag.axis: isHorizontal ? Drag.XAxis : Drag.YAxis
            drag.minimumX: isHorizontal ? root.width * minPosition : 0
            drag.maximumX: isHorizontal ? root.width * maxPosition : 0
            drag.minimumY: isHorizontal ? 0 : root.height * minPosition
            drag.maximumY: isHorizontal ? 0 : root.height * maxPosition
        }
    }

    Item {
        id: dragProxy
        x: isHorizontal ? handle.x : 0
        y: isHorizontal ? 0 : handle.y

        onXChanged: {
            if (handleMouse.pressed && isHorizontal) {
                position = Math.max(minPosition, Math.min(maxPosition, x / root.width))
            }
        }

        onYChanged: {
            if (handleMouse.pressed && !isHorizontal) {
                position = Math.max(minPosition, Math.min(maxPosition, y / root.height))
            }
        }
    }

    Item {
        id: secondContainer
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: isHorizontal ? parent.width * (1 - position) - handleSize / 2 : parent.width
        height: isHorizontal ? parent.height : parent.height * (1 - position) - handleSize / 2
    }
}
