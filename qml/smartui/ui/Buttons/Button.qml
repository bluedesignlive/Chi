// ui/Buttons/Button.qml - FIXED for standalone QML module
import QtQuick
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme    // instead of import ChiOS / smartui

Item {
    id: button

    property string text: "Button"
    property string variant: "filled"
    property string size: "small"
    property string shape: "round"
    property bool showIcon: false
    property string icon: ""
    property bool enabled: true
    property bool loading: false

    signal clicked()

    // Disabled opacity
    opacity: enabled ? 1.0 : 0.38

    Behavior on opacity {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    readonly property var sizeSpecs: ({
        xsmall: {
            height: 32,
            padding: 6,
            horizontalPadding: 12,
            gap: 4,
            iconSize: 20,
            fontSize: 14,
            fontWeight: Font.Medium,
            letterSpacing: 0.1,
            lineHeight: 20,
            squareRadius: 12
        },
        small: {
            height: 40,
            padding: 10,
            horizontalPadding: 16,
            gap: 8,
            iconSize: 20,
            fontSize: 14,
            fontWeight: Font.Medium,
            letterSpacing: 0.1,
            lineHeight: 20,
            squareRadius: 12
        },
        medium: {
            height: 56,
            padding: 16,
            horizontalPadding: 24,
            gap: 8,
            iconSize: 24,
            fontSize: 16,
            fontWeight: Font.Medium,
            letterSpacing: 0.15,
            lineHeight: 24,
            squareRadius: 16
        },
        large: {
            height: 96,
            padding: 32,
            horizontalPadding: 48,
            gap: 12,
            iconSize: 32,
            fontSize: 24,
            fontWeight: Font.Normal,
            letterSpacing: 0,
            lineHeight: 32,
            squareRadius: 28
        },
        xlarge: {
            height: 136,
            padding: 48,
            horizontalPadding: 64,
            gap: 16,
            iconSize: 40,
            fontSize: 32,
            fontWeight: Font.Normal,
            letterSpacing: 0,
            lineHeight: 40,
            squareRadius: 28
        }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.small
    readonly property bool isIconImage: icon.indexOf(".svg") !== -1 || icon.indexOf(".png") !== -1 ||
                                       icon.indexOf(".jpg") !== -1 || icon.indexOf("qrc:/") === 0

    implicitWidth: buttonContent.implicitWidth
    implicitHeight: currentSize.height

    states: [
        State { name: "disabled"; when: !enabled },
        State { name: "pressed"; when: mouseArea.pressed && enabled },
        State { name: "focused"; when: button.activeFocus && enabled && !mouseArea.pressed },
        State { name: "hovered"; when: mouseArea.containsMouse && enabled && !mouseArea.pressed },
        State { name: "enabled"; when: enabled && !mouseArea.containsMouse && !mouseArea.pressed && !button.activeFocus }
    ]

    // Use Theme.ChiTheme singleton inside the module
    property var colors: Theme.ChiTheme.colors

    Rectangle {
        id: container
        anchors.fill: parent
        radius: shape === "round" ? 100 : currentSize.squareRadius
        clip: true

        color: {
            if (!enabled && variant === "filled") return "transparent"
            if (!enabled && variant === "elevated") return "transparent"

            switch (variant) {
            case "filled": return colors.primary
            case "elevated": return colors.surfaceContainerLow
            case "tonal": return colors.secondaryContainer
            case "outlined":
            case "text":
            default: return "transparent"
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            visible: !enabled && (variant === "filled" || variant === "elevated")
            color: colors.onSurface
            opacity: 0.12
        }

        border.width: variant === "outlined" ? 1 : 0
        border.color: {
            if (variant !== "outlined") return "transparent"
            if (!enabled) return Qt.rgba(0, 0, 0, 0.12)
            if (button.state === "focused") return colors.primary
            return colors.outline
        }

        // Simple ripple: follows button shape, always stays inside
        Rectangle {
            id: ripple
            anchors.fill: parent
            radius: parent.radius
            color: stateLayer.color
            opacity: 0
            z: 0    // under stateLayer and content

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
                case "filled": return colors.onPrimary
                case "elevated": return colors.primary
                case "tonal": return colors.onSecondaryContainer
                case "outlined":
                case "text":
                default: return colors.primary
                }
            }

            opacity: {
                if (!enabled) return 0
                switch (button.state) {
                case "pressed": return 0.12
                case "focused": return 0.12
                case "hovered": return 0.08
                default: return 0
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: button.state === "pressed" ? 50 : 150
                    easing.type: Easing.OutCubic
                }
            }
        }

        Row {
            id: buttonContent
            anchors.centerIn: parent
            spacing: currentSize.gap
            padding: currentSize.padding
            leftPadding: currentSize.horizontalPadding
            rightPadding: currentSize.horizontalPadding
            z: 2

            Image {
                visible: showIcon && icon !== "" && isIconImage
                width: currentSize.iconSize
                height: currentSize.iconSize
                source: icon
                fillMode: Image.PreserveAspectFit
                smooth: true
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                visible: showIcon && icon !== "" && !isIconImage
                text: icon
                font.family: "Material Icons"
                font.pixelSize: currentSize.iconSize
                color: labelText.color
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: labelText
                text: button.text

                font.family: "Roboto"
                font.weight: currentSize.fontWeight
                font.pixelSize: currentSize.fontSize
                font.letterSpacing: currentSize.letterSpacing
                // Use natural line height; avoids vertical bias
                // lineHeight: currentSize.lineHeight
                // lineHeightMode: Text.FixedHeight

                verticalAlignment: Text.AlignVCenter

                color: {
                    switch (variant) {
                    case "filled":
                        return enabled ? colors.onPrimary : colors.onSurface
                    case "elevated":
                        return enabled ? colors.primary : colors.onSurface
                    case "tonal":
                        return enabled ? colors.onSecondaryContainer : colors.onSurface
                    case "outlined":
                    case "text":
                    default:
                        return enabled ? colors.primary : colors.onSurface
                    }
                }

                anchors.verticalCenter: parent.verticalCenter
            }
        }

        layer.enabled: {
            if (variant === "filled" && button.state === "hovered") return true
            if (variant === "elevated" && enabled) return true
            return false
        }

        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: variant === "elevated" && button.state === "hovered" ? 2 : 1
            radius: variant === "elevated" && button.state === "hovered" ? 6 : 3
            samples: variant === "elevated" && button.state === "hovered" ? 13 : 9
            color: Qt.rgba(0, 0, 0, 0.3)
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: button.enabled && !loading
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        // onPressed: (mouse) => {
        //     ripple.origin = Qt.point(mouse.x, mouse.y)
        //     rippleAnimation.restart()
        // }

        onPressed: {
            rippleAnimation.restart()
        }

        onClicked: button.clicked()
    }

    Keys.onSpacePressed: if (enabled && !loading) handleActivation()
    Keys.onEnterPressed: if (enabled && !loading) handleActivation()
    Keys.onReturnPressed: if (enabled && !loading) handleActivation()

    // function handleActivation() {
    //     ripple.origin = Qt.point(width/2, height/2)
    //     rippleAnimation.restart()
    //     clicked()
    // }

    function handleActivation() {
        rippleAnimation.restart()
        clicked()
    }
}
