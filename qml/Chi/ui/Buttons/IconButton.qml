import QtQuick
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
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
        small: { height: 40, iconSize: 24, squareRadius: 8, narrowWidth: 32, defaultWidth: 40, wideWidth: 52 },
        medium: { height: 56, iconSize: 24, squareRadius: 12, narrowWidth: 48, defaultWidth: 56, wideWidth: 68 },
        large: { height: 96, iconSize: 32, squareRadius: 20, narrowWidth: 64, defaultWidth: 96, wideWidth: 128 },
        xlarge: { height: 136, iconSize: 40, squareRadius: 28, narrowWidth: 104, defaultWidth: 136, wideWidth: 184 }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.small
    readonly property int containerWidth: widthMode === "narrow" ? currentSize.narrowWidth : (widthMode === "wide" ? currentSize.wideWidth : currentSize.defaultWidth)
    readonly property bool isIconImage: icon.indexOf("/") >= 0 || icon.indexOf("qrc:") >= 0 || icon.indexOf(".svg") >= 0 || icon.indexOf(".png") >= 0

    implicitWidth: containerWidth
    implicitHeight: currentSize.height
    property var colors: Theme.ChiTheme.colors

    Rectangle {
        id: container
        anchors.centerIn: parent
        width: containerWidth
        height: currentSize.height
        clip: true
        radius: (iconButton.state === "pressed") ? currentSize.squareRadius : (shape === "round" ? 100 : currentSize.squareRadius)

        color: {
            if (!enabled) return variant === "standard" ? "transparent" : Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.12)
            switch (variant) {
                case "filled": return colors.primary
                case "tonal": return colors.secondaryContainer
                case "outlined": return colors.surfaceContainerLow
                default: return "transparent"
            }
        }
        border.width: variant === "outlined" ? 1 : 0
        border.color: variant === "outlined" ? colors.outline : "transparent"
        Behavior on radius { NumberAnimation { duration: 150 } }
        Behavior on color { ColorAnimation { duration: 200 } }

        Rectangle {
            id: ripple
            anchors.fill: parent
            radius: parent.radius
            color: stateLayer.color
            opacity: 0
            SequentialAnimation on opacity { 
                id: rippleAnimation
                running: false
                NumberAnimation { from: 0; to: 0.16; duration: 90 }
                NumberAnimation { to: 0; duration: 210 } 
            }
        }

        Rectangle {
            id: stateLayer
            anchors.fill: parent
            radius: parent.radius
            color: {
                if (variant === "filled") return colors.onPrimary
                if (variant === "tonal") return colors.onSecondaryContainer
                if (variant === "outlined") return colors.primary
                return colors.onSurfaceVariant
            }
            opacity: mouseArea.pressed ? 0.12 : (mouseArea.containsMouse ? 0.08 : 0)
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }

        Image {
            visible: isIconImage
            anchors.centerIn: parent
            width: currentSize.iconSize
            height: currentSize.iconSize
            source: isIconImage ? icon : ""
            fillMode: Image.PreserveAspectFit
        }

        Text {
            visible: !isIconImage
            anchors.centerIn: parent
            text: icon
            font.family: iconButton.iconFont !== "" ? iconButton.iconFont : "Material Icons"
            font.pixelSize: currentSize.iconSize
            color: {
                if (!enabled) return colors.onSurface
                if (variant === "filled") return colors.onPrimary
                if (variant === "tonal") return colors.onSecondaryContainer
                if (variant === "outlined") return colors.primary
                return colors.onSurfaceVariant
            }
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
