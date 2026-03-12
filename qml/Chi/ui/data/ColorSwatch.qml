import QtQuick
import "../theme" as Theme

Item {
    id: root

    property color color: "#000000"
    property bool selected: false
    property bool showBorder: true
    property bool enabled: true
    property string size: "medium"           // "small", "medium", "large"
    property string shape: "circle"          // "circle", "square", "rounded"

    signal clicked()

    readonly property var sizeSpecs: ({
        small: { size: 24 },
        medium: { size: 32 },
        large: { size: 48 }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.medium

    implicitWidth: currentSize.size
    implicitHeight: currentSize.size

    opacity: enabled ? 1.0 : 0.5

    property var colors: Theme.ChiTheme.colors

    // Selection ring
    Rectangle {
        visible: selected
        anchors.fill: parent
        anchors.margins: -3
        radius: shape === "circle" ? width / 2 : (shape === "rounded" ? 6 : 0)
        color: "transparent"
        border.width: 2
        border.color: colors.primary

        Behavior on border.color {
            ColorAnimation { duration: 150 }
        }
    }

    // Checkerboard for transparency
    Canvas {
        anchors.fill: parent
        visible: root.color.a < 1

        onPaint: {
            var ctx = getContext("2d")
            var sz = 4
            for (var x = 0; x < width; x += sz) {
                for (var y = 0; y < height; y += sz) {
                    ctx.fillStyle = ((x / sz + y / sz) % 2 === 0) ? "#ffffff" : "#cccccc"
                    ctx.fillRect(x, y, sz, sz)
                }
            }
        }

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: root.width
                height: root.height
                radius: shape === "circle" ? width / 2 : (shape === "rounded" ? 4 : 0)
            }
        }
    }

    // Color fill
    Rectangle {
        anchors.fill: parent
        radius: shape === "circle" ? width / 2 : (shape === "rounded" ? 4 : 0)
        color: root.color

        border.width: showBorder ? 1 : 0
        border.color: {
            if (root.color.hslLightness > 0.9) return colors.outline
            return "transparent"
        }
    }

    // Hover state
    Rectangle {
        anchors.fill: parent
        radius: shape === "circle" ? width / 2 : (shape === "rounded" ? 4 : 0)
        color: "#000000"
        opacity: mouseArea.containsMouse && enabled ? 0.1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 100 }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        enabled: root.enabled

        onClicked: root.clicked()
    }

    Accessible.role: Accessible.Button
    Accessible.name: "Color: " + color
}
