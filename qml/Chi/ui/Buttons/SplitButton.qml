// smartui/ui/Buttons/SplitButton.qml
import QtQuick
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Item {
    id: splitButton

    property string text: "Action"
    property string leadingIcon: ""
    property bool showLeadingIcon: false
    property string trailingIcon: "⌄"

    property string variant: "filled"
    property string size: "small"
    property bool enabled: true
    property bool trailingSelected: false

    signal leadingClicked()
    signal trailingClicked()

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
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
            fullRadius: 16,
            smallRadius: 4,
            buttonGap: 2,
            trailingIconSize: 16
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
            fullRadius: 20,
            smallRadius: 4,
            buttonGap: 2,
            trailingIconSize: 18
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
            fullRadius: 28,
            smallRadius: 4,
            buttonGap: 2,
            trailingIconSize: 20
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
            fullRadius: 48,
            smallRadius: 8,
            buttonGap: 2,
            trailingIconSize: 28
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
            fullRadius: 68,
            smallRadius: 12,
            buttonGap: 2,
            trailingIconSize: 36
        }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.small
    readonly property bool isIconImage:
        leadingIcon.indexOf(".svg") !== -1 ||
        leadingIcon.indexOf(".png") !== -1 ||
        leadingIcon.indexOf(".jpg") !== -1 ||
        leadingIcon.indexOf("qrc:/") === 0

    implicitWidth: leadingButtonContainer.implicitWidth + currentSize.buttonGap + trailingButtonContainer.width
    implicitHeight: currentSize.height

    property var colors: Theme.ChiTheme.colors

    states: [
        State { name: "disabled";        when: !enabled },
        State { name: "leadingPressed";  when: leadingMouseArea.pressed && enabled },
        State { name: "leadingFocused";  when: splitButton.activeFocus && enabled && !leadingMouseArea.pressed },
        State { name: "leadingHovered";  when: leadingMouseArea.containsMouse && enabled && !leadingMouseArea.pressed },
        State { name: "enabled";         when: enabled }
    ]

    Row {
        spacing: currentSize.buttonGap

        // LEADING BUTTON
        Rectangle {
            id: leadingButtonContainer
            implicitWidth: leadingContent.implicitWidth
            height: currentSize.height
            clip: true

            topLeftRadius: currentSize.fullRadius
            bottomLeftRadius: currentSize.fullRadius
            topRightRadius: currentSize.smallRadius
            bottomRightRadius: currentSize.smallRadius

            color: {
                if (!enabled && variant === "filled")   return "transparent"
                if (!enabled && variant === "elevated") return "transparent"

                switch (variant) {
                case "filled":   return colors.primary
                case "elevated": return colors.surfaceContainerLow
                case "tonal":    return colors.secondaryContainer
                case "outlined":
                case "text":
                default:         return "transparent"
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: 0
                topLeftRadius: parent.topLeftRadius
                topRightRadius: parent.topRightRadius
                bottomLeftRadius: parent.bottomLeftRadius
                bottomRightRadius: parent.bottomRightRadius
                visible: !enabled && (variant === "filled" || variant === "elevated")
                color: colors.onSurface
                opacity: 0.12
            }

            border.width: variant === "outlined" ? 1 : 0
            border.color: variant === "outlined" ? colors.outline : "transparent"

            // Simple ripple for leading side
            Rectangle {
                id: leadingRipple
                anchors.fill: parent
                radius: 0
                topLeftRadius: parent.topLeftRadius
                topRightRadius: parent.topRightRadius
                bottomLeftRadius: parent.bottomLeftRadius
                bottomRightRadius: parent.bottomRightRadius
                color: leadingStateLayer.color
                opacity: 0
                z: 0

                SequentialAnimation on opacity {
                    id: leadingRippleAnimation
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
                id: leadingStateLayer
                anchors.fill: parent
                radius: 0
                topLeftRadius: parent.topLeftRadius
                topRightRadius: parent.topRightRadius
                bottomLeftRadius: parent.bottomLeftRadius
                bottomRightRadius: parent.bottomRightRadius
                z: 1

                color: {
                    switch (variant) {
                    case "filled":   return colors.onPrimary
                    case "elevated": return colors.primary
                    case "tonal":    return colors.onSecondaryContainer
                    case "outlined":
                    case "text":
                    default:         return colors.primary
                    }
                }

                opacity: {
                    if (!enabled) return 0
                    if (splitButton.state === "leadingPressed") return 0.12
                    if (splitButton.state === "leadingFocused") return 0.12
                    if (splitButton.state === "leadingHovered") return 0.08
                    return 0
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: splitButton.state === "leadingPressed" ? 50 : 150
                        easing.type: Easing.OutCubic
                    }
                }
            }

            Row {
                id: leadingContent
                anchors.centerIn: parent
                spacing: currentSize.gap
                padding: currentSize.padding
                leftPadding: currentSize.horizontalPadding
                rightPadding: currentSize.horizontalPadding
                z: 2

                Text {
                    visible: showLeadingIcon && leadingIcon !== "" && !isIconImage
                    text: leadingIcon
                    font.family: "Material Icons"
                    font.pixelSize: currentSize.iconSize
                    color: leadingLabel.color
                    anchors.verticalCenter: parent.verticalCenter
                }

                Image {
                    visible: showLeadingIcon && leadingIcon !== "" && isIconImage
                    width: currentSize.iconSize
                    height: currentSize.iconSize
                    source: leadingIcon
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    id: leadingLabel
                    text: splitButton.text

                    font.family: "Roboto"
                    font.weight: currentSize.fontWeight
                    font.pixelSize: currentSize.fontSize
                    font.letterSpacing: currentSize.letterSpacing
                    // Better vertical centering
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

            MouseArea {
                id: leadingMouseArea
                anchors.fill: parent
                enabled: splitButton.enabled
                hoverEnabled: true
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

                onPressed: leadingRippleAnimation.restart()
                onClicked: splitButton.leadingClicked()
            }
        }

        // TRAILING BUTTON
        Rectangle {
            id: trailingButtonContainer
            width: currentSize.height
            height: currentSize.height
            clip: true

            topLeftRadius: trailingSelected ? currentSize.fullRadius :
                          (trailingMouseArea.pressed ? currentSize.smallRadius * 3 : currentSize.smallRadius)
            bottomLeftRadius: trailingSelected ? currentSize.fullRadius :
                             (trailingMouseArea.pressed ? currentSize.smallRadius * 3 : currentSize.smallRadius)
            topRightRadius: trailingSelected ? currentSize.fullRadius : currentSize.fullRadius
            bottomRightRadius: trailingSelected ? currentSize.fullRadius : currentSize.fullRadius

            Behavior on topLeftRadius {
                NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
            }
            Behavior on bottomLeftRadius {
                NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
            }

            color: leadingButtonContainer.color
            border.width: leadingButtonContainer.border.width
            border.color: leadingButtonContainer.border.color

            // Simple ripple for trailing side
            Rectangle {
                id: trailingRipple
                anchors.fill: parent
                radius: 0
                topLeftRadius: parent.topLeftRadius
                topRightRadius: parent.topRightRadius
                bottomLeftRadius: parent.bottomLeftRadius
                bottomRightRadius: parent.bottomRightRadius
                color: leadingStateLayer.color
                opacity: 0
                z: 0

                SequentialAnimation on opacity {
                    id: trailingRippleAnimation
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
                id: trailingStateLayer
                anchors.fill: parent
                radius: 0
                topLeftRadius: parent.topLeftRadius
                topRightRadius: parent.topRightRadius
                bottomLeftRadius: parent.bottomLeftRadius
                bottomRightRadius: parent.bottomRightRadius
                z: 1

                color: leadingStateLayer.color

                opacity: {
                    if (!enabled) return 0
                    if (trailingSelected)              return 0.12
                    if (trailingMouseArea.pressed)     return 0.12
                    if (trailingMouseArea.containsMouse) return 0.08
                    return 0
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: trailingMouseArea.pressed ? 50 : 150
                        easing.type: Easing.OutCubic
                    }
                }
            }

            Text {
                id: trailingIconText
                anchors.centerIn: parent
                text: trailingIcon
                font.family: "Roboto"
                font.pixelSize: currentSize.trailingIconSize
                font.weight: Font.Bold
                color: leadingLabel.color
                z: 2
                rotation: trailingSelected ? 180 : 0

                Behavior on rotation {
                    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                }
            }

            Rectangle {
                visible: trailingSelected && splitButton.activeFocus
                anchors.fill: parent
                anchors.margins: 2
                radius: parent.radius
                color: "transparent"
                border.width: 3
                border.color: colors.secondary
                z: 3
            }

            MouseArea {
                id: trailingMouseArea
                anchors.fill: parent
                enabled: splitButton.enabled
                hoverEnabled: true
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

                onPressed: trailingRippleAnimation.restart()
                onClicked: {
                    splitButton.trailingSelected = !splitButton.trailingSelected
                    splitButton.trailingClicked()
                }
            }
        }
    }

    layer.enabled: variant === "elevated" && enabled
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 1
        radius: 4
        samples: 9
        color: Qt.rgba(0, 0, 0, 0.3)
    }
}
