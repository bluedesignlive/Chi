// smartui/ui/Buttons/ToggleButton.qml
import QtQuick
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Item {
    id: toggleButton

    property string text: "Toggle"
    property string variant: "filled"   // filled, elevated, tonal, outlined
    property string size: "small"       // xsmall..xlarge
    property string shape: "round"      // round, square
    property bool selected: false
    property bool showIcon: false
    property string icon: ""
    property string selectedIcon: ""
    property bool enabled: true

    signal toggled(bool selected)

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
            squareRadius: 12,
            borderWidth: 1
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
            squareRadius: 12,
            borderWidth: 1
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
            squareRadius: 16,
            borderWidth: 1
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
            squareRadius: 28,
            borderWidth: 2
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
            squareRadius: 28,
            borderWidth: 2
        }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.small

    // Robust icon detection
    readonly property bool isIconImage:
        icon.indexOf(".svg") !== -1 ||
        icon.indexOf(".png") !== -1 ||
        icon.indexOf(".jpg") !== -1 ||
        icon.indexOf("qrc:/") === 0

    readonly property string currentIcon: selected && selectedIcon !== "" ? selectedIcon : icon

    implicitWidth: buttonContent.implicitWidth
    implicitHeight: currentSize.height

    states: [
        State { name: "disabled"; when: !enabled },
        State { name: "pressed";  when: mouseArea.pressed && enabled },
        State { name: "hovered";  when: mouseArea.containsMouse && enabled && !mouseArea.pressed },
        State { name: "enabled";  when: enabled && !mouseArea.containsMouse && !mouseArea.pressed }
    ]

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        id: container
        anchors.fill: parent
        radius: shape === "round" ? 100 : currentSize.squareRadius
        clip: true

        color: {
            if (!enabled) return "transparent"

            switch (variant) {
            case "filled":
                return selected ? colors.primary : colors.surfaceContainer
            case "elevated":
                return selected ? colors.primary : colors.surfaceContainerLow
            case "tonal":
                return selected ? colors.inverseSurface : "transparent"
            case "outlined":
                return selected ? colors.secondary : colors.secondaryContainer
            default:
                return colors.primary
            }
        }

        border.width: (!selected && variant === "tonal") ? currentSize.borderWidth : 0
        border.color: (!selected && variant === "tonal") ? colors.outlineVariant : "transparent"

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            visible: !enabled
            color: colors.onSurface
            opacity: 0.12
        }

        Rectangle {
            id: stateLayer
            anchors.fill: parent
            radius: parent.radius

            color: {
                if (!selected) {
                    switch (variant) {
                    case "filled":   return colors.onSurfaceVariant
                    case "elevated": return colors.primary
                    case "tonal":    return colors.onSurfaceVariant
                    case "outlined": return colors.onSecondaryContainer
                    }
                } else {
                    switch (variant) {
                    case "filled":   return colors.onPrimary
                    case "elevated": return colors.onPrimary
                    case "tonal":    return colors.inverseOnSurface
                    case "outlined": return colors.onSecondary
                    }
                }
                return colors.primary
            }

            opacity: {
                if (!enabled) return 0
                switch (toggleButton.state) {
                case "pressed": return 0.12
                case "hovered": return 0.08
                default:        return 0
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: toggleButton.state === "pressed" ? 50 : 150
                    easing.type: Easing.OutCubic
                }
            }
        }

        // Simple, clipped ripple like Button/IconButton
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

        Row {
            id: buttonContent
            anchors.centerIn: parent
            spacing: currentSize.gap
            padding: currentSize.padding
            leftPadding: currentSize.horizontalPadding
            rightPadding: currentSize.horizontalPadding

            Image {
                visible: showIcon && currentIcon !== "" && isIconImage
                width: currentSize.iconSize
                height: currentSize.iconSize
                source: currentIcon
                fillMode: Image.PreserveAspectFit
                smooth: true
                opacity: labelText.opacity
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                visible: showIcon && currentIcon !== "" && !isIconImage
                text: currentIcon
                font.family: "Material Icons"
                font.pixelSize: currentSize.iconSize
                color: labelText.color
                opacity: labelText.opacity
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: labelText
                text: toggleButton.text

                font.family: "Roboto"
                font.weight: currentSize.fontWeight
                font.pixelSize: currentSize.fontSize
                font.letterSpacing: currentSize.letterSpacing
                // lineHeight: currentSize.lineHeight
                // lineHeightMode: Text.FixedHeight
                verticalAlignment: Text.AlignVCenter

                color: {
                    if (!enabled) return colors.onSurface

                    if (!selected) {
                        switch (variant) {
                        case "filled":   return colors.onSurfaceVariant
                        case "elevated": return colors.primary
                        case "tonal":    return colors.onSurfaceVariant
                        case "outlined": return colors.onSecondaryContainer
                        }
                    } else {
                        switch (variant) {
                        case "filled":   return colors.onPrimary
                        case "elevated": return colors.onPrimary
                        case "tonal":    return colors.inverseOnSurface
                        case "outlined": return colors.onSecondary
                        }
                    }
                    return colors.onPrimary
                }

                opacity: enabled ? 1.0 : 0.38
                anchors.verticalCenter: parent.verticalCenter

                Behavior on color { ColorAnimation { duration: 200 } }
            }
        }

        layer.enabled: variant === "elevated" && enabled
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 1
            radius: 3
            samples: 9
            color: Qt.rgba(0, 0, 0, 0.3)
        }

        Behavior on color { ColorAnimation { duration: 200 } }
        Behavior on border.color { ColorAnimation { duration: 200 } }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: toggleButton.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        onPressed: rippleAnimation.restart()
        onClicked: {
            toggleButton.selected = !toggleButton.selected
            toggleButton.toggled(toggleButton.selected)
        }
    }
}
