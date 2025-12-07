// library/ui/Buttons/SplitButton.qml - MODERN ICONS
import QtQuick
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import ChiOS

Item {
    id: splitButton

    property string text: "Action"
    property string leadingIcon: ""
    property bool showLeadingIcon: false
    property string trailingIcon: "⌄"  // MODERN: Clean chevron down

    property string variant: "filled"
    property string size: "small"
    property bool enabled: true
    property bool trailingSelected: false

    signal leadingClicked()
    signal trailingClicked()

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
            fullRadius: 16,
            smallRadius: 4,
            buttonGap: 2,
            trailingIconSize: 16  // Smaller for xsmall
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
    readonly property bool isIconImage: leadingIcon.includes(".svg") || leadingIcon.includes(".png") ||
                                       leadingIcon.includes(".jpg") || leadingIcon.includes("qrc:/")

    implicitWidth: leadingButtonContainer.implicitWidth + currentSize.buttonGap + trailingButtonContainer.width
    implicitHeight: currentSize.height

    property var colors: ChiTheme.colors

    // Leading button states
    states: [
        State { name: "disabled"; when: !enabled },
        State { name: "leadingPressed"; when: leadingMouseArea.pressed && enabled },
        State { name: "leadingFocused"; when: splitButton.activeFocus && enabled && !leadingMouseArea.pressed },
        State { name: "leadingHovered"; when: leadingMouseArea.containsMouse && enabled && !leadingMouseArea.pressed },
        State { name: "enabled"; when: enabled }
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
            border.color: variant === "outlined" ? colors.outline : "transparent"

            Rectangle {
                id: leadingRipple
                property real diameter: 0
                property point origin: Qt.point(width/2, height/2)

                x: origin.x - diameter/2
                y: origin.y - diameter/2
                width: diameter
                height: diameter
                radius: diameter/2
                color: leadingStateLayer.color
                opacity: 0
                z: 0

                ParallelAnimation {
                    id: leadingRippleAnimation

                    NumberAnimation {
                        target: leadingRipple
                        property: "diameter"
                        from: 0
                        to: Math.max(leadingButtonContainer.width, leadingButtonContainer.height) * 2.5
                        duration: 300
                        easing.type: Easing.OutCubic
                    }

                    SequentialAnimation {
                        NumberAnimation {
                            target: leadingRipple
                            property: "opacity"
                            from: 0
                            to: 0.12
                            duration: 75
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: leadingRipple
                            property: "opacity"
                            to: 0
                            duration: 225
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }

            Rectangle {
                id: leadingStateLayer
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
                    lineHeight: currentSize.lineHeight
                    lineHeightMode: Text.FixedHeight

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

                onPressed: (mouse) => {
                    leadingRipple.origin = Qt.point(mouse.x, mouse.y)
                    leadingRippleAnimation.restart()
                }

                onClicked: splitButton.leadingClicked()
            }
        }

        // TRAILING BUTTON (Dropdown)
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

            Rectangle {
                id: trailingRipple
                property real diameter: 0
                property point origin: Qt.point(width/2, height/2)

                x: origin.x - diameter/2
                y: origin.y - diameter/2
                width: diameter
                height: diameter
                radius: diameter/2
                color: leadingStateLayer.color
                opacity: 0
                z: 0

                ParallelAnimation {
                    id: trailingRippleAnimation

                    NumberAnimation {
                        target: trailingRipple
                        property: "diameter"
                        from: 0
                        to: Math.max(trailingButtonContainer.width, trailingButtonContainer.height) * 2.5
                        duration: 300
                        easing.type: Easing.OutCubic
                    }

                    SequentialAnimation {
                        NumberAnimation {
                            target: trailingRipple
                            property: "opacity"
                            from: 0
                            to: 0.12
                            duration: 75
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: trailingRipple
                            property: "opacity"
                            to: 0
                            duration: 225
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }

            Rectangle {
                id: trailingStateLayer
                anchors.fill: parent
                radius: parent.radius
                z: 1

                color: leadingStateLayer.color

                opacity: {
                    if (!enabled) return 0
                    if (trailingSelected) return 0.12
                    if (trailingMouseArea.pressed) return 0.12
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

            // MODERN ICON - Clean chevron that scales properly
            Text {
                id: trailingIconText
                anchors.centerIn: parent
                text: trailingIcon
                font.family: "Roboto"  // Use Roboto for geometric characters
                font.pixelSize: currentSize.trailingIconSize
                font.weight: Font.Bold  // Make it more visible
                color: leadingLabel.color
                z: 2

                // Rotate when selected to indicate state
                rotation: trailingSelected ? 180 : 0

                Behavior on rotation {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
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

                onPressed: (mouse) => {
                    trailingRipple.origin = Qt.point(mouse.x, mouse.y)
                    trailingRippleAnimation.restart()
                }

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


///////////////////////////////////////// bad icon


// // library/ui/Buttons/SplitButton.qml
// import QtQuick
// import QtQuick.Controls.Basic
// import Qt5Compat.GraphicalEffects
// import ChiOS

// Item {
//     id: splitButton

//     property string text: "Action"
//     property string leadingIcon: ""
//     property bool showLeadingIcon: false
//     property string trailingIcon: "▼"

//     property string variant: "filled"
//     property string size: "small"
//     property bool enabled: true
//     property bool trailingSelected: false

//     signal leadingClicked()
//     signal trailingClicked()

//     opacity: enabled ? 1.0 : 0.38

//     Behavior on opacity {
//         NumberAnimation {
//             duration: 200
//             easing.type: Easing.OutCubic
//         }
//     }

//     readonly property var sizeSpecs: ({
//         xsmall: {
//             height: 32,
//             padding: 6,
//             horizontalPadding: 12,
//             gap: 4,
//             iconSize: 20,
//             fontSize: 14,
//             fontWeight: Font.Medium,
//             letterSpacing: 0.1,
//             lineHeight: 20,
//             fullRadius: 16,
//             smallRadius: 4,
//             buttonGap: 2
//         },
//         small: {
//             height: 40,
//             padding: 10,
//             horizontalPadding: 16,
//             gap: 8,
//             iconSize: 20,
//             fontSize: 14,
//             fontWeight: Font.Medium,
//             letterSpacing: 0.1,
//             lineHeight: 20,
//             fullRadius: 20,
//             smallRadius: 4,
//             buttonGap: 2
//         },
//         medium: {
//             height: 56,
//             padding: 16,
//             horizontalPadding: 24,
//             gap: 8,
//             iconSize: 24,
//             fontSize: 16,
//             fontWeight: Font.Medium,
//             letterSpacing: 0.15,
//             lineHeight: 24,
//             fullRadius: 28,
//             smallRadius: 4,
//             buttonGap: 2
//         },
//         large: {
//             height: 96,
//             padding: 32,
//             horizontalPadding: 48,
//             gap: 12,
//             iconSize: 32,
//             fontSize: 24,
//             fontWeight: Font.Normal,
//             letterSpacing: 0,
//             lineHeight: 32,
//             fullRadius: 48,
//             smallRadius: 8,
//             buttonGap: 2
//         },
//         xlarge: {
//             height: 136,
//             padding: 48,
//             horizontalPadding: 64,
//             gap: 16,
//             iconSize: 40,
//             fontSize: 32,
//             fontWeight: Font.Normal,
//             letterSpacing: 0,
//             lineHeight: 40,
//             fullRadius: 68,
//             smallRadius: 12,
//             buttonGap: 2
//         }
//     })

//     readonly property var currentSize: sizeSpecs[size] || sizeSpecs.small
//     readonly property bool isIconImage: leadingIcon.includes(".svg") || leadingIcon.includes(".png") ||
//                                        leadingIcon.includes(".jpg") || leadingIcon.includes("qrc:/")

//     implicitWidth: leadingButtonContainer.implicitWidth + currentSize.buttonGap + trailingButtonContainer.width
//     implicitHeight: currentSize.height

//     property var colors: ChiTheme.colors

//     // Leading button states
//     states: [
//         State { name: "disabled"; when: !enabled },
//         State { name: "leadingPressed"; when: leadingMouseArea.pressed && enabled },
//         State { name: "leadingFocused"; when: splitButton.activeFocus && enabled && !leadingMouseArea.pressed },
//         State { name: "leadingHovered"; when: leadingMouseArea.containsMouse && enabled && !leadingMouseArea.pressed },
//         State { name: "enabled"; when: enabled }
//     ]

//     Row {
//         spacing: currentSize.buttonGap

//         // LEADING BUTTON
//         Rectangle {
//             id: leadingButtonContainer
//             implicitWidth: leadingContent.implicitWidth
//             height: currentSize.height
//             clip: true

//             // Asymmetric radius - rounded left, square right
//             topLeftRadius: currentSize.fullRadius
//             bottomLeftRadius: currentSize.fullRadius
//             topRightRadius: currentSize.smallRadius
//             bottomRightRadius: currentSize.smallRadius

//             color: {
//                 if (!enabled && variant === "filled") return "transparent"
//                 if (!enabled && variant === "elevated") return "transparent"

//                 switch (variant) {
//                     case "filled": return colors.primary
//                     case "elevated": return colors.surfaceContainerLow
//                     case "tonal": return colors.secondaryContainer
//                     case "outlined":
//                     case "text":
//                     default: return "transparent"
//                 }
//             }

//             Rectangle {
//                 anchors.fill: parent
//                 radius: parent.radius
//                 visible: !enabled && (variant === "filled" || variant === "elevated")
//                 color: colors.onSurface
//                 opacity: 0.12
//             }

//             border.width: variant === "outlined" ? 1 : 0
//             border.color: variant === "outlined" ? colors.outline : "transparent"

//             // Ripple (bottom)
//             Rectangle {
//                 id: leadingRipple
//                 property real diameter: 0
//                 property point origin: Qt.point(width/2, height/2)

//                 x: origin.x - diameter/2
//                 y: origin.y - diameter/2
//                 width: diameter
//                 height: diameter
//                 radius: diameter/2
//                 color: leadingStateLayer.color
//                 opacity: 0
//                 z: 0

//                 ParallelAnimation {
//                     id: leadingRippleAnimation

//                     NumberAnimation {
//                         target: leadingRipple
//                         property: "diameter"
//                         from: 0
//                         to: Math.max(leadingButtonContainer.width, leadingButtonContainer.height) * 2.5
//                         duration: 300
//                         easing.type: Easing.OutCubic
//                     }

//                     SequentialAnimation {
//                         NumberAnimation {
//                             target: leadingRipple
//                             property: "opacity"
//                             from: 0
//                             to: 0.12
//                             duration: 75
//                             easing.type: Easing.OutCubic
//                         }
//                         NumberAnimation {
//                             target: leadingRipple
//                             property: "opacity"
//                             to: 0
//                             duration: 225
//                             easing.type: Easing.OutCubic
//                         }
//                     }
//                 }
//             }

//             // State layer (middle)
//             Rectangle {
//                 id: leadingStateLayer
//                 anchors.fill: parent
//                 radius: parent.radius
//                 z: 1

//                 color: {
//                     switch (variant) {
//                         case "filled": return colors.onPrimary
//                         case "elevated": return colors.primary
//                         case "tonal": return colors.onSecondaryContainer
//                         case "outlined":
//                         case "text":
//                         default: return colors.primary
//                     }
//                 }

//                 opacity: {
//                     if (!enabled) return 0
//                     if (splitButton.state === "leadingPressed") return 0.12
//                     if (splitButton.state === "leadingFocused") return 0.12
//                     if (splitButton.state === "leadingHovered") return 0.08
//                     return 0
//                 }

//                 Behavior on opacity {
//                     NumberAnimation {
//                         duration: splitButton.state === "leadingPressed" ? 50 : 150
//                         easing.type: Easing.OutCubic
//                     }
//                 }
//             }

//             // Content (top)
//             Row {
//                 id: leadingContent
//                 anchors.centerIn: parent
//                 spacing: currentSize.gap
//                 padding: currentSize.padding
//                 leftPadding: currentSize.horizontalPadding
//                 rightPadding: currentSize.horizontalPadding
//                 z: 2

//                 // Icon
//                 Text {
//                     visible: showLeadingIcon && leadingIcon !== "" && !isIconImage
//                     text: leadingIcon
//                     font.family: "Material Icons"
//                     font.pixelSize: currentSize.iconSize
//                     color: leadingLabel.color
//                     anchors.verticalCenter: parent.verticalCenter
//                 }

//                 Image {
//                     visible: showLeadingIcon && leadingIcon !== "" && isIconImage
//                     width: currentSize.iconSize
//                     height: currentSize.iconSize
//                     source: leadingIcon
//                     fillMode: Image.PreserveAspectFit
//                     smooth: true
//                     anchors.verticalCenter: parent.verticalCenter
//                 }

//                 // Label
//                 Text {
//                     id: leadingLabel
//                     text: splitButton.text

//                     font.family: "Roboto"
//                     font.weight: currentSize.fontWeight
//                     font.pixelSize: currentSize.fontSize
//                     font.letterSpacing: currentSize.letterSpacing
//                     lineHeight: currentSize.lineHeight
//                     lineHeightMode: Text.FixedHeight

//                     color: {
//                         switch (variant) {
//                             case "filled":
//                                 return enabled ? colors.onPrimary : colors.onSurface
//                             case "elevated":
//                                 return enabled ? colors.primary : colors.onSurface
//                             case "tonal":
//                                 return enabled ? colors.onSecondaryContainer : colors.onSurface
//                             case "outlined":
//                             case "text":
//                             default:
//                                 return enabled ? colors.primary : colors.onSurface
//                         }
//                     }

//                     anchors.verticalCenter: parent.verticalCenter
//                 }
//             }

//             MouseArea {
//                 id: leadingMouseArea
//                 anchors.fill: parent
//                 enabled: splitButton.enabled
//                 hoverEnabled: true
//                 cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

//                 onPressed: (mouse) => {
//                     leadingRipple.origin = Qt.point(mouse.x, mouse.y)
//                     leadingRippleAnimation.restart()
//                 }

//                 onClicked: splitButton.leadingClicked()
//             }
//         }

//         // TRAILING BUTTON (Dropdown)
//         Rectangle {
//             id: trailingButtonContainer
//             width: currentSize.height  // Square
//             height: currentSize.height
//             clip: true

//             // Dynamic radius based on state
//             topLeftRadius: trailingSelected ? currentSize.fullRadius :
//                           (trailingMouseArea.pressed ? currentSize.smallRadius * 3 : currentSize.smallRadius)
//             bottomLeftRadius: trailingSelected ? currentSize.fullRadius :
//                              (trailingMouseArea.pressed ? currentSize.smallRadius * 3 : currentSize.smallRadius)
//             topRightRadius: trailingSelected ? currentSize.fullRadius : currentSize.fullRadius
//             bottomRightRadius: trailingSelected ? currentSize.fullRadius : currentSize.fullRadius

//             Behavior on topLeftRadius {
//                 NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
//             }
//             Behavior on bottomLeftRadius {
//                 NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
//             }

//             color: leadingButtonContainer.color
//             border.width: leadingButtonContainer.border.width
//             border.color: leadingButtonContainer.border.color

//             // Ripple (bottom)
//             Rectangle {
//                 id: trailingRipple
//                 property real diameter: 0
//                 property point origin: Qt.point(width/2, height/2)

//                 x: origin.x - diameter/2
//                 y: origin.y - diameter/2
//                 width: diameter
//                 height: diameter
//                 radius: diameter/2
//                 color: leadingStateLayer.color
//                 opacity: 0
//                 z: 0

//                 ParallelAnimation {
//                     id: trailingRippleAnimation

//                     NumberAnimation {
//                         target: trailingRipple
//                         property: "diameter"
//                         from: 0
//                         to: Math.max(trailingButtonContainer.width, trailingButtonContainer.height) * 2.5
//                         duration: 300
//                         easing.type: Easing.OutCubic
//                     }

//                     SequentialAnimation {
//                         NumberAnimation {
//                             target: trailingRipple
//                             property: "opacity"
//                             from: 0
//                             to: 0.12
//                             duration: 75
//                             easing.type: Easing.OutCubic
//                         }
//                         NumberAnimation {
//                             target: trailingRipple
//                             property: "opacity"
//                             to: 0
//                             duration: 225
//                             easing.type: Easing.OutCubic
//                         }
//                     }
//                 }
//             }

//             // State layer (middle)
//             Rectangle {
//                 id: trailingStateLayer
//                 anchors.fill: parent
//                 radius: parent.radius
//                 z: 1

//                 color: leadingStateLayer.color

//                 opacity: {
//                     if (!enabled) return 0
//                     if (trailingSelected) return 0.12
//                     if (trailingMouseArea.pressed) return 0.12
//                     if (trailingMouseArea.containsMouse) return 0.08
//                     return 0
//                 }

//                 Behavior on opacity {
//                     NumberAnimation {
//                         duration: trailingMouseArea.pressed ? 50 : 150
//                         easing.type: Easing.OutCubic
//                     }
//                 }
//             }

//             // Icon (top)
//             Text {
//                 anchors.centerIn: parent
//                 text: trailingIcon
//                 font.family: "Material Icons"
//                 font.pixelSize: currentSize.iconSize + 2
//                 color: leadingLabel.color
//                 z: 2
//             }

//             // Focus indicator (for trailing when selected/focused)
//             Rectangle {
//                 visible: trailingSelected && splitButton.activeFocus
//                 anchors.fill: parent
//                 anchors.margins: 2
//                 radius: parent.radius
//                 color: "transparent"
//                 border.width: 3
//                 border.color: colors.secondary
//                 z: 3
//             }

//             MouseArea {
//                 id: trailingMouseArea
//                 anchors.fill: parent
//                 enabled: splitButton.enabled
//                 hoverEnabled: true
//                 cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

//                 onPressed: (mouse) => {
//                     trailingRipple.origin = Qt.point(mouse.x, mouse.y)
//                     trailingRippleAnimation.restart()
//                 }

//                 onClicked: {
//                     splitButton.trailingSelected = !splitButton.trailingSelected
//                     splitButton.trailingClicked()
//                 }
//             }
//         }
//     }

//     // Group shadow for elevated variant
//     layer.enabled: variant === "elevated" && enabled
//     layer.effect: DropShadow {
//         transparentBorder: true
//         horizontalOffset: 0
//         verticalOffset: 1
//         radius: 4
//         samples: 9
//         color: Qt.rgba(0, 0, 0, 0.3)
//     }
// }
