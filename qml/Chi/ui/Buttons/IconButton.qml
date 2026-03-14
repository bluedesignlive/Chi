import QtQuick
import "../../theme" as Theme

Item {
    id: iconButton

    property string icon: ""
    property string variant: "filled"
    property string size: "small"
    property string widthMode: "default"
    property string shape: "round"
    property bool enabled: true
    property string tooltip: ""

    // Feature: Allow custom icon font
    property string iconFont: ""

    signal clicked()

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity { NumberAnimation { duration: 200 } }

    readonly property var sizeSpecs: ({
        xsmall: { height: 32, iconSize: 20, squareRadius: 8, narrowWidth: 24, defaultWidth: 32, wideWidth: 44 },
        small:  { height: 40, iconSize: 24, squareRadius: 8, narrowWidth: 32, defaultWidth: 40, wideWidth: 52 },
        medium: { height: 56, iconSize: 24, squareRadius: 12, narrowWidth: 48, defaultWidth: 56, wideWidth: 68 },
        large:  { height: 96, iconSize: 32, squareRadius: 20, narrowWidth: 64, defaultWidth: 96, wideWidth: 128 },
        xlarge: { height: 136, iconSize: 40, squareRadius: 28, narrowWidth: 104, defaultWidth: 136, wideWidth: 184 }
    })

    readonly property var cs: sizeSpecs[size] || sizeSpecs.small
    readonly property int containerWidth: widthMode === "narrow" ? cs.narrowWidth :
                                          (widthMode === "wide" ? cs.wideWidth : cs.defaultWidth)
    readonly property bool isIconImage: {
        var s = icon
        return s.indexOf("/") >= 0 || s.indexOf("qrc:") >= 0 ||
               s.indexOf(".svg") >= 0 || s.indexOf(".png") >= 0
    }

    // Cached variant flags — avoids repeated string compares across bindings
    readonly property bool _filled: variant === "filled"
    readonly property bool _tonal: variant === "tonal"
    readonly property bool _outlined: variant === "outlined"

    // Interactive color: used by state layer, ripple, and icon text (when enabled)
    readonly property color _interactColor: _filled ? colors.onPrimary :
                                            _tonal ? colors.onSecondaryContainer :
                                            _outlined ? colors.primary : colors.onSurfaceVariant

    // Icon color: accounts for disabled state
    readonly property color _iconColor: enabled ? _interactColor : colors.onSurface

    implicitWidth: containerWidth
    implicitHeight: cs.height
    property var colors: Theme.ChiTheme.colors

    Rectangle {
        id: container
        anchors.centerIn: parent
        width: iconButton.containerWidth
        height: cs.height
        clip: true
        radius: shape === "round" ? 100 : cs.squareRadius

        color: {
            if (!iconButton.enabled) {
                if (iconButton._filled || iconButton._tonal || iconButton._outlined)
                    return Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.12)
                return "transparent"
            }
            if (iconButton._filled) return colors.primary
            if (iconButton._tonal) return colors.secondaryContainer
            if (iconButton._outlined) return colors.surfaceContainerLow
            return "transparent"
        }
        border.width: iconButton._outlined ? 1 : 0
        border.color: iconButton._outlined ? colors.outline : "transparent"
        Behavior on radius { NumberAnimation { duration: 150 } }
        Behavior on color { ColorAnimation { duration: 200 } }

        // Ripple
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: iconButton._interactColor
            opacity: 0
            SequentialAnimation on opacity {
                id: rippleAnimation
                running: false
                NumberAnimation { from: 0; to: 0.16; duration: 90 }
                NumberAnimation { to: 0; duration: 210 }
            }
        }

        // State layer
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: iconButton._interactColor
            opacity: mouseArea.pressed ? 0.12 : (mouseArea.containsMouse ? 0.08 : 0)
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }

        // Image icon
        Image {
            visible: iconButton.isIconImage
            anchors.centerIn: parent
            width: cs.iconSize
            height: cs.iconSize
            source: iconButton.isIconImage ? iconButton.icon : ""
            fillMode: Image.PreserveAspectFit
        }

        // Text/ligature icon
        Text {
            visible: !iconButton.isIconImage
            anchors.centerIn: parent
            text: iconButton.icon
            font.family: iconButton.iconFont || Theme.ChiTheme.iconFamily
            font.pixelSize: cs.iconSize
            color: iconButton._iconColor
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: iconButton.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onPressed: rippleAnimation.restart()
        onClicked: iconButton.clicked()
    }
}
