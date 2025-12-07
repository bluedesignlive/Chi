// smartui/ui/Buttons/IconButton.qml
import QtQuick
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Item {
    id: iconButton

    property string icon: ""
    property string variant: "filled"     // filled, tonal, outlined, standard
    property string size: "small"         // xsmall, small, medium, large, xlarge
    property string widthMode: "default"  // narrow, default, wide
    property string shape: "round"        // round, square
    property bool enabled: true
    property string tooltip: ""

    signal clicked()

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    readonly property var sizeSpecs: ({
        xsmall: {
            height: 32,
            iconSize: 20,
            squareRadius: 8,
            narrowWidth: 24,
            defaultWidth: 32,
            wideWidth: 44
        },
        small: {
            height: 40,
            iconSize: 24,
            squareRadius: 8,
            narrowWidth: 32,
            defaultWidth: 40,
            wideWidth: 52
        },
        medium: {
            height: 56,
            iconSize: 24,
            squareRadius: 12,
            narrowWidth: 48,
            defaultWidth: 56,
            wideWidth: 68
        },
        large: {
            height: 96,
            iconSize: 32,
            squareRadius: 20,
            narrowWidth: 64,
            defaultWidth: 96,
            wideWidth: 128
        },
        xlarge: {
            height: 136,
            iconSize: 40,
            squareRadius: 28,
            narrowWidth: 104,
            defaultWidth: 136,
            wideWidth: 184
        }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.small

    readonly property int containerWidth: {
        switch (widthMode) {
        case "narrow": return currentSize.narrowWidth
        case "wide":   return currentSize.wideWidth
        default:       return currentSize.defaultWidth
        }
    }

    // Safe icon detection (no more trying to load "✓" as an image)
    readonly property bool isIconImage:
        icon.indexOf(".svg") !== -1 ||
        icon.indexOf(".png") !== -1 ||
        icon.indexOf(".jpg") !== -1 ||
        icon.indexOf("qrc:/") === 0

    implicitWidth: containerWidth
    implicitHeight: currentSize.height

    states: [
        State { name: "disabled"; when: !enabled },
        State { name: "pressed";  when: mouseArea.pressed && enabled },
        State { name: "focused";  when: iconButton.activeFocus && enabled && !mouseArea.pressed },
        State { name: "hovered";  when: mouseArea.containsMouse && enabled && !mouseArea.pressed },
        State { name: "enabled";  when: enabled && !mouseArea.containsMouse && !mouseArea.pressed && !iconButton.activeFocus }
    ]

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        id: container
        anchors.centerIn: parent
        width: containerWidth
        height: currentSize.height
        clip: true

        radius: iconButton.state === "pressed"
                ? currentSize.squareRadius
                : (shape === "round" ? 100 : currentSize.squareRadius)

        color: {
            if (!enabled) {
                return variant === "standard"
                       ? "transparent"
                       : Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.12)
            }

            switch (variant) {
            case "filled":   return colors.primary
            case "tonal":    return colors.secondaryContainer
            case "outlined": return colors.surfaceContainerLow
            case "standard":
            default:         return "transparent"
            }
        }

        border.width: variant === "outlined" ? 1 : 0
        border.color: {
            if (variant !== "outlined") return "transparent"
            return colors.outline
        }

        Behavior on radius {
            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
        }
        Behavior on color {
            ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
        }

        // Simple, clipped ripple: always inside the button shape
        Rectangle {
            id: ripple
            anchors.fill: parent
            radius: parent.radius
            color: stateLayer.color
            opacity: 0
            z: 0

            SequentialAnimation on opacity {
                id: rippleAnimation
                running: false
                NumberAnimation {
                    from: 0
                    to: 0.16
                    duration: 90
                    easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    to: 0
                    duration: 210
                    easing.type: Easing.OutCubic
                }
            }
        }

        Rectangle {
            id: stateLayer
            anchors.fill: parent
            radius: parent.radius
            z: 1

            color: {
                switch (variant) {
                case "filled":   return colors.onPrimary
                case "tonal":    return colors.onSecondaryContainer
                case "outlined": return colors.primary
                case "standard":
                default:         return colors.onSurfaceVariant
                }
            }

            opacity: {
                if (!enabled) return 0
                switch (iconButton.state) {
                case "pressed": return 0.12
                case "focused": return 0.12
                case "hovered": return 0.08
                default:        return 0
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: iconButton.state === "pressed" ? 50 : 150
                    easing.type: Easing.OutCubic
                }
            }
        }

        Image {
            visible: icon !== "" && isIconImage
            anchors.centerIn: parent
            width: currentSize.iconSize
            height: currentSize.iconSize
            source: icon
            fillMode: Image.PreserveAspectFit
            smooth: true
            z: 2
        }

        Text {
            visible: icon !== "" && !isIconImage
            anchors.centerIn: parent
            text: icon
            font.family: "Material Icons"
            font.pixelSize: currentSize.iconSize
            z: 2

            color: {
                if (!enabled) return colors.onSurface
                switch (variant) {
                case "filled":   return colors.onPrimary
                case "tonal":    return colors.onSecondaryContainer
                case "outlined": return colors.primary
                case "standard":
                default:         return colors.onSurfaceVariant
                }
            }
        }

        Rectangle {
            id: focusIndicator
            visible: iconButton.state === "focused"
            anchors.fill: parent
            anchors.margins: 2
            radius: parent.radius
            color: "transparent"
            border.width: 3
            border.color: colors.secondary
            z: 3
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

    ToolTip {
        visible: tooltip !== "" && mouseArea.containsMouse
        text: tooltip
        delay: 500
    }

    Keys.onSpacePressed:  if (enabled) handleActivation()
    Keys.onEnterPressed:  if (enabled) handleActivation()
    Keys.onReturnPressed: if (enabled) handleActivation()

    function handleActivation() {
        rippleAnimation.restart()
        clicked()
    }
}
