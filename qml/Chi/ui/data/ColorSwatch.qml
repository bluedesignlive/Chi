import QtQuick
import QtQuick.Effects
import "../../theme" as Theme

Item {
    id: root

    property color color: "#000000"
    property bool selected: false
    property bool showBorder: true
    property bool enabled: true
    property string size: "medium"           // "small", "medium", "large"
    property string shape: "circle"          // "circle", "square", "rounded"

    signal clicked()

    readonly property int _dim: size === "small" ? 24 : (size === "large" ? 48 : 32)
    readonly property bool _isCircle: shape === "circle"
    readonly property bool _isRounded: shape === "rounded"
    readonly property real _radius: _isCircle ? _dim * 0.5 : (_isRounded ? 4 : 0)

    implicitWidth: _dim
    implicitHeight: _dim

    opacity: enabled ? 1.0 : 0.5

    property var colors: Theme.ChiTheme.colors

    // Selection ring
    Rectangle {
        visible: root.selected
        anchors.fill: parent
        anchors.margins: -3
        radius: root._isCircle ? width * 0.5 : (root._isRounded ? 6 : 0)
        color: "transparent"
        border.width: 2
        border.color: colors.primary
        Behavior on border.color { ColorAnimation { duration: 150 } }
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
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: Rectangle {
                width: root._dim
                height: root._dim
                radius: root._radius
                visible: false
            }
        }
    }

    // Color fill
    Rectangle {
        anchors.fill: parent
        radius: root._radius
        color: root.color
        border.width: root.showBorder ? 1 : 0
        border.color: root.color.hslLightness > 0.9 ? colors.outline : "transparent"
    }

    // Hover state
    Rectangle {
        anchors.fill: parent
        radius: root._radius
        color: "#000000"
        opacity: mouseArea.containsMouse && root.enabled ? 0.1 : 0
        Behavior on opacity { NumberAnimation { duration: 100 } }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        enabled: root.enabled
        onClicked: root.clicked()
    }

    Accessible.role: Accessible.Button
    Accessible.name: "Color: " + color
}
