// library/ui/Buttons/IconButton.qml - ORIGINAL WITH RIPPLE FIX ONLY
import QtQuick
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import ChiOS

Item {
    id: iconButton

    property string icon: ""
    property string variant: "filled"
    property string size: "small"
    property string widthMode: "default"
    property string shape: "round"
    property bool enabled: true
    property string tooltip: ""

    signal clicked()

    // FIXED: Disabled opacity like switch
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
            case "wide": return currentSize.wideWidth
            default: return currentSize.defaultWidth
        }
    }

    readonly property bool isIconImage: icon.includes(".svg") || icon.includes(".png") ||
                                       icon.includes(".jpg") || icon.includes("qrc:/")

    implicitWidth: containerWidth
    implicitHeight: currentSize.height

    states: [
        State { name: "disabled"; when: !enabled },
        State { name: "pressed"; when: mouseArea.pressed && enabled },
        State { name: "focused"; when: iconButton.activeFocus && enabled && !mouseArea.pressed },
        State { name: "hovered"; when: mouseArea.containsMouse && enabled && !mouseArea.pressed },
        State { name: "enabled"; when: enabled && !mouseArea.containsMouse && !mouseArea.pressed && !iconButton.activeFocus }
    ]

    property var colors: ChiTheme.colors

    Rectangle {
        id: container
        anchors.centerIn: parent
        width: containerWidth
        height: currentSize.height
        clip: true  // FIXED: Clip ripple to bounds

        radius: {
            if (iconButton.state === "pressed") return currentSize.squareRadius
            return shape === "round" ? 100 : currentSize.squareRadius
        }

        color: {
            if (!enabled) {
                return variant === "standard" ? "transparent" : Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.12)
            }

            switch (variant) {
                case "filled": return colors.primary
                case "tonal": return colors.secondaryContainer
                case "outlined": return colors.surfaceContainerLow
                case "standard":
                default: return "transparent"
            }
        }

        border.width: variant === "outlined" ? 1 : 0
        border.color: {
            if (variant !== "outlined") return "transparent"
            if (!enabled) return colors.outline
            return colors.outline
        }

        // FIXED: Ripple FIRST so it renders behind everything
        Rectangle {
            id: ripple
            property real diameter: 0
            property point origin: Qt.point(width/2, height/2)

            x: origin.x - diameter/2
            y: origin.y - diameter/2
            width: diameter
            height: diameter
            radius: diameter/2
            color: stateLayer.color
            opacity: 0
            z: 0  // FIXED: Ensure it's behind

            ParallelAnimation {
                id: rippleAnimation

                NumberAnimation {
                    target: ripple
                    property: "diameter"
                    from: 0
                    to: Math.max(container.width, container.height) * 2.5
                    duration: 300
                    easing.type: Easing.OutCubic
                }

                SequentialAnimation {
                    NumberAnimation {
                        target: ripple
                        property: "opacity"
                        from: 0
                        to: 0.12
                        duration: 75
                        easing.type: Easing.OutCubic
                    }
                    NumberAnimation {
                        target: ripple
                        property: "opacity"
                        to: 0
                        duration: 225
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }

        Rectangle {
            id: stateLayer
            anchors.fill: parent
            radius: parent.radius
            z: 1  // FIXED: Above ripple

            color: {
                switch (variant) {
                    case "filled": return colors.onPrimary
                    case "tonal": return colors.onSecondaryContainer
                    case "outlined": return colors.primary
                    case "standard":
                    default: return colors.onSurfaceVariant
                }
            }

            opacity: {
                if (!enabled) return 0

                switch (iconButton.state) {
                    case "pressed": return 0.12
                    case "focused": return 0.12
                    case "hovered": return 0.08
                    default: return 0
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
            z: 2  // FIXED: On top
        }

        Text {
            visible: icon !== "" && !isIconImage
            anchors.centerIn: parent
            text: icon
            font.family: "Material Icons"
            font.pixelSize: currentSize.iconSize
            z: 2  // FIXED: On top

            color: {
                if (!enabled) return colors.onSurface

                switch (variant) {
                    case "filled": return colors.onPrimary
                    case "tonal": return colors.onSecondaryContainer
                    case "outlined": return colors.primary
                    case "standard":
                    default: return colors.onSurfaceVariant
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
            z: 3  // FIXED: On top of everything
        }

        Behavior on radius {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
            }
        }

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: iconButton.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        onPressed: (mouse) => {
            ripple.origin = Qt.point(mouse.x, mouse.y)
            rippleAnimation.restart()
        }

        onClicked: iconButton.clicked()
    }

    ToolTip {
        visible: tooltip !== "" && mouseArea.containsMouse
        text: tooltip
        delay: 500
    }

    Keys.onSpacePressed: if (enabled) handleActivation()
    Keys.onEnterPressed: if (enabled) handleActivation()
    Keys.onReturnPressed: if (enabled) handleActivation()

    function handleActivation() {
        ripple.origin = Qt.point(width/2, height/2)
        rippleAnimation.restart()
        clicked()
    }
}

// // library/ui/Buttons/IconButton.qml - COMPLETE FIX
// import QtQuick
// import QtQuick.Controls.Basic
// import Qt5Compat.GraphicalEffects
// import ChiOS

// Item {
//     id: iconButton

//     property string icon: ""
//     property string variant: "filled"
//     property string size: "small"
//     property string widthMode: "default"
//     property string shape: "round"
//     property bool enabled: true
//     property string tooltip: ""

//     signal clicked()

//     // FIXED: Disabled opacity like switch
//     opacity: enabled ? 1.0 : 0.38

//     Behavior on opacity {
//         NumberAnimation {
//             duration: 200
//             easing.type: Easing.OutCubic
//         }
//     }

//     // FIXED: Correct specs from Figma (different width/height for narrow mode)
//     readonly property var sizeSpecs: ({
//         xsmall: {
//             height: 32,
//             iconSize: 20,
//             squareRadius: 8,
//             narrowWidth: 28,    // From specs
//             narrowHeight: 32,   // From specs
//             defaultWidth: 32,
//             defaultHeight: 40,
//             wideWidth: 44,
//             wideHeight: 48
//         },
//         small: {
//             height: 40,
//             iconSize: 24,
//             squareRadius: 12,
//             narrowWidth: 32,    // From specs
//             narrowHeight: 40,   // From specs
//             defaultWidth: 40,
//             defaultHeight: 48,
//             wideWidth: 52,
//             wideHeight: 56
//         },
//         medium: {
//             height: 56,
//             iconSize: 24,
//             squareRadius: 12,
//             narrowWidth: 48,
//             narrowHeight: 56,
//             defaultWidth: 56,
//             defaultHeight: 56,
//             wideWidth: 68,
//             wideHeight: 68
//         },
//         large: {
//             height: 96,
//             iconSize: 32,
//             squareRadius: 20,
//             narrowWidth: 64,
//             narrowHeight: 96,
//             defaultWidth: 96,
//             defaultHeight: 96,
//             wideWidth: 128,
//             wideHeight: 128
//         },
//         xlarge: {
//             height: 136,
//             iconSize: 40,
//             squareRadius: 28,
//             narrowWidth: 104,
//             narrowHeight: 136,
//             defaultWidth: 136,
//             defaultHeight: 136,
//             wideWidth: 184,
//             wideHeight: 184
//         }
//     })

//     readonly property var currentSize: sizeSpecs[size] || sizeSpecs.small

//     readonly property int containerWidth: {
//         switch (widthMode) {
//             case "narrow": return currentSize.narrowWidth
//             case "wide": return currentSize.wideWidth
//             default: return currentSize.defaultWidth
//         }
//     }

//     readonly property int containerHeight: {
//         switch (widthMode) {
//             case "narrow": return currentSize.narrowHeight
//             case "wide": return currentSize.wideHeight
//             default: return currentSize.defaultHeight
//         }
//     }

//     readonly property bool isIconImage: icon.includes(".svg") || icon.includes(".png") ||
//                                        icon.includes(".jpg") || icon.includes("qrc:/")

//     implicitWidth: containerWidth
//     implicitHeight: containerHeight

//     states: [
//         State { name: "disabled"; when: !enabled },
//         State { name: "pressed"; when: mouseArea.pressed && enabled },
//         State { name: "focused"; when: iconButton.activeFocus && enabled && !mouseArea.pressed },
//         State { name: "hovered"; when: mouseArea.containsMouse && enabled && !mouseArea.pressed },
//         State { name: "enabled"; when: enabled && !mouseArea.containsMouse && !mouseArea.pressed && !iconButton.activeFocus }
//     ]

//     property var colors: ChiTheme.colors

//     Rectangle {
//         id: container
//         anchors.centerIn: parent
//         width: containerWidth
//         height: containerHeight
//         clip: true

//         // FIXED: ALL sizes deform on press (round → square)
//         radius: {
//             if (iconButton.state === "pressed") return currentSize.squareRadius
//             return shape === "round" ? 100 : currentSize.squareRadius
//         }

//         color: {
//             if (!enabled) {
//                 return variant === "standard" ? "transparent" : Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.12)
//             }

//             switch (variant) {
//                 case "filled": return colors.primary
//                 case "tonal": return colors.secondaryContainer
//                 case "outlined": return colors.surfaceContainerLow
//                 case "standard":
//                 default: return "transparent"
//             }
//         }

//         border.width: variant === "outlined" ? 1 : 0
//         border.color: {
//             if (variant !== "outlined") return "transparent"
//             if (!enabled) return colors.outline
//             return colors.outline
//         }

//         Behavior on radius {
//             NumberAnimation {
//                 duration: 200
//                 easing.type: Easing.OutCubic
//             }
//         }

//         Behavior on color {
//             ColorAnimation {
//                 duration: 200
//                 easing.type: Easing.OutCubic
//             }
//         }

//         Rectangle {
//             id: stateLayer
//             anchors.fill: parent
//             radius: parent.radius

//             color: {
//                 switch (variant) {
//                     case "filled": return colors.onPrimary
//                     case "tonal": return colors.onSecondaryContainer
//                     case "outlined": return colors.primary
//                     case "standard":
//                     default: return colors.onSurfaceVariant
//                 }
//             }

//             opacity: {
//                 if (!enabled) return 0

//                 switch (iconButton.state) {
//                     case "pressed": return 0.12
//                     case "focused": return 0.12
//                     case "hovered": return 0.08
//                     default: return 0
//                 }
//             }

//             Behavior on opacity {
//                 NumberAnimation {
//                     duration: iconButton.state === "pressed" ? 50 : 150
//                     easing.type: Easing.OutCubic
//                 }
//             }
//         }

//         Rectangle {
//             id: ripple
//             property real diameter: 0
//             property point origin: Qt.point(width/2, height/2)

//             x: origin.x - diameter/2
//             y: origin.y - diameter/2
//             width: diameter
//             height: diameter
//             radius: diameter/2
//             color: stateLayer.color
//             opacity: 0

//             ParallelAnimation {
//                 id: rippleAnimation

//                 NumberAnimation {
//                     target: ripple
//                     property: "diameter"
//                     from: 0
//                     to: Math.max(container.width, container.height) * 2.5
//                     duration: 300  // FIXED: 300ms ripple
//                     easing.type: Easing.OutCubic
//                 }

//                 SequentialAnimation {
//                     NumberAnimation {
//                         target: ripple
//                         property: "opacity"
//                         from: 0
//                         to: 0.12
//                         duration: 75
//                         easing.type: Easing.OutCubic
//                     }
//                     NumberAnimation {
//                         target: ripple
//                         property: "opacity"
//                         to: 0
//                         duration: 225  // FIXED: 300 - 75 = 225
//                         easing.type: Easing.OutCubic
//                     }
//                 }
//             }
//         }

//         Image {
//             visible: icon !== "" && isIconImage
//             anchors.centerIn: parent
//             width: currentSize.iconSize
//             height: currentSize.iconSize
//             source: icon
//             fillMode: Image.PreserveAspectFit
//             smooth: true
//         }

//         Text {
//             visible: icon !== "" && !isIconImage
//             anchors.centerIn: parent
//             text: icon
//             font.family: "Material Icons"
//             font.pixelSize: currentSize.iconSize

//             color: {
//                 if (!enabled) return colors.onSurface

//                 switch (variant) {
//                     case "filled": return colors.onPrimary
//                     case "tonal": return colors.onSecondaryContainer
//                     case "outlined": return colors.primary
//                     case "standard":
//                     default: return colors.onSurfaceVariant
//                 }
//             }
//         }

//         Rectangle {
//             id: focusIndicator
//             visible: iconButton.state === "focused"
//             anchors.fill: parent
//             anchors.margins: 2
//             radius: parent.radius
//             color: "transparent"
//             border.width: 3
//             border.color: colors.secondary

//             Behavior on radius {
//                 NumberAnimation {
//                     duration: 200
//                     easing.type: Easing.OutCubic
//                 }
//             }
//         }
//     }

//     MouseArea {
//         id: mouseArea
//         anchors.fill: parent
//         enabled: iconButton.enabled
//         hoverEnabled: true
//         cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

//         onPressed: (mouse) => {
//             ripple.origin = Qt.point(mouse.x, mouse.y)
//             rippleAnimation.restart()
//         }

//         onClicked: iconButton.clicked()
//     }

//     ToolTip {
//         visible: tooltip !== "" && mouseArea.containsMouse
//         text: tooltip
//         delay: 500
//     }

//     Keys.onSpacePressed: if (enabled) handleActivation()
//     Keys.onEnterPressed: if (enabled) handleActivation()
//     Keys.onReturnPressed: if (enabled) handleActivation()

//     function handleActivation() {
//         ripple.origin = Qt.point(width/2, height/2)
//         rippleAnimation.restart()
//         clicked()
//     }
// }

// // library/ui/Buttons/IconButton.qml - SMOOTH ANIMATIONS + CLIPPED RIPPLE
// import QtQuick
// import QtQuick.Controls.Basic
// import Qt5Compat.GraphicalEffects
// import ChiOS

// Item {
//     id: iconButton

//     property string icon: ""
//     property string variant: "filled"
//     property string size: "small"
//     property string widthMode: "default"
//     property string shape: "round"
//     property bool enabled: true
//     property string tooltip: ""

//     signal clicked()

//     readonly property var sizeSpecs: ({
//         xsmall: {
//             height: 32,
//             iconSize: 20,
//             squareRadius: 8,
//             narrowWidth: 24,
//             defaultWidth: 32,
//             wideWidth: 44
//         },
//         small: {
//             height: 40,
//             iconSize: 24,
//             squareRadius: 8,
//             narrowWidth: 32,
//             defaultWidth: 40,
//             wideWidth: 52
//         },
//         medium: {
//             height: 56,
//             iconSize: 24,
//             squareRadius: 12,
//             narrowWidth: 48,
//             defaultWidth: 56,
//             wideWidth: 68
//         },
//         large: {
//             height: 96,
//             iconSize: 32,
//             squareRadius: 20,
//             narrowWidth: 64,
//             defaultWidth: 96,
//             wideWidth: 128
//         },
//         xlarge: {
//             height: 136,
//             iconSize: 40,
//             squareRadius: 28,
//             narrowWidth: 104,
//             defaultWidth: 136,
//             wideWidth: 184
//         }
//     })

//     readonly property var currentSize: sizeSpecs[size] || sizeSpecs.small
//     readonly property int containerWidth: {
//         switch (widthMode) {
//             case "narrow": return currentSize.narrowWidth
//             case "wide": return currentSize.wideWidth
//             default: return currentSize.defaultWidth
//         }
//     }

//     readonly property bool isIconImage: icon.includes(".svg") || icon.includes(".png") ||
//                                        icon.includes(".jpg") || icon.includes("qrc:/")

//     implicitWidth: containerWidth
//     implicitHeight: currentSize.height

//     states: [
//         State { name: "disabled"; when: !enabled },
//         State { name: "pressed"; when: mouseArea.pressed && enabled },
//         State { name: "focused"; when: iconButton.activeFocus && enabled && !mouseArea.pressed },
//         State { name: "hovered"; when: mouseArea.containsMouse && enabled && !mouseArea.pressed },
//         State { name: "enabled"; when: enabled && !mouseArea.containsMouse && !mouseArea.pressed && !iconButton.activeFocus }
//     ]

//     property var colors: ChiTheme.colors

//     Rectangle {
//         id: container
//         anchors.centerIn: parent
//         width: containerWidth
//         height: currentSize.height
//         clip: true  // FIXED: Clip ripple to container bounds

//         // FIXED: Smooth radius animation like switch
//         radius: {
//             if (iconButton.state === "pressed") return currentSize.squareRadius
//             return shape === "round" ? 100 : currentSize.squareRadius
//         }

//         color: {
//             if (!enabled) {
//                 return variant === "standard" ? "transparent" : Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.12)
//             }

//             switch (variant) {
//                 case "filled": return colors.primary
//                 case "tonal": return colors.secondaryContainer
//                 case "outlined": return colors.surfaceContainerLow
//                 case "standard":
//                 default: return "transparent"
//             }
//         }

//         border.width: variant === "outlined" ? 1 : 0
//         border.color: {
//             if (variant !== "outlined") return "transparent"
//             if (!enabled) return colors.outline
//             return colors.outline
//         }

//         // FIXED: Smooth radius transition
//         Behavior on radius {
//             NumberAnimation {
//                 duration: 200
//                 easing.type: Easing.OutCubic
//             }
//         }

//         Behavior on color {
//             ColorAnimation {
//                 duration: 200
//                 easing.type: Easing.OutCubic
//             }
//         }

//         // State layer - now properly clipped
//         Rectangle {
//             id: stateLayer
//             anchors.fill: parent
//             radius: parent.radius

//             color: {
//                 switch (variant) {
//                     case "filled": return colors.onPrimary
//                     case "tonal": return colors.onSecondaryContainer
//                     case "outlined": return colors.primary
//                     case "standard":
//                     default: return colors.onSurfaceVariant
//                 }
//             }

//             opacity: {
//                 if (!enabled) return 0

//                 switch (iconButton.state) {
//                     case "pressed": return 0.12
//                     case "focused": return 0.12
//                     case "hovered": return 0.08
//                     default: return 0
//                 }
//             }

//             Behavior on opacity {
//                 NumberAnimation {
//                     duration: iconButton.state === "pressed" ? 50 : 150
//                     easing.type: Easing.OutCubic
//                 }
//             }
//         }

//         // Icon - Image
//         Image {
//             visible: icon !== "" && isIconImage
//             anchors.centerIn: parent
//             width: currentSize.iconSize
//             height: currentSize.iconSize
//             source: icon
//             fillMode: Image.PreserveAspectFit
//             smooth: true
//             opacity: enabled ? 1.0 : 0.38
//         }

//         // Icon - Text
//         Text {
//             visible: icon !== "" && !isIconImage
//             anchors.centerIn: parent
//             text: icon
//             font.family: "Material Icons"
//             font.pixelSize: currentSize.iconSize

//             color: {
//                 if (!enabled) return colors.onSurface

//                 switch (variant) {
//                     case "filled": return colors.onPrimary
//                     case "tonal": return colors.onSecondaryContainer
//                     case "outlined": return colors.primary
//                     case "standard":
//                     default: return colors.onSurfaceVariant
//                 }
//             }

//             opacity: enabled ? 1.0 : 0.38
//         }

//         // FIXED: Ripple now properly clipped
//         Rectangle {
//             id: ripple
//             property real diameter: 0
//             property point origin: Qt.point(width/2, height/2)

//             x: origin.x - diameter/2
//             y: origin.y - diameter/2
//             width: diameter
//             height: diameter
//             radius: diameter/2
//             color: stateLayer.color
//             opacity: 0

//             ParallelAnimation {
//                 id: rippleAnimation

//                 NumberAnimation {
//                     target: ripple
//                     property: "diameter"
//                     from: 0
//                     to: Math.max(container.width, container.height) * 2.5
//                     duration: 550
//                     easing.type: Easing.OutCubic
//                 }

//                 SequentialAnimation {
//                     NumberAnimation {
//                         target: ripple
//                         property: "opacity"
//                         from: 0
//                         to: 0.12
//                         duration: 75
//                         easing.type: Easing.OutCubic
//                     }
//                     NumberAnimation {
//                         target: ripple
//                         property: "opacity"
//                         to: 0
//                         duration: 475
//                         easing.type: Easing.OutCubic
//                     }
//                 }
//             }
//         }

//         // Focus indicator
//         Rectangle {
//             id: focusIndicator
//             visible: iconButton.state === "focused"
//             anchors.fill: parent
//             anchors.margins: 2
//             radius: parent.radius
//             color: "transparent"
//             border.width: 3
//             border.color: colors.secondary

//             Behavior on radius {
//                 NumberAnimation {
//                     duration: 200
//                     easing.type: Easing.OutCubic
//                 }
//             }
//         }
//     }

//     MouseArea {
//         id: mouseArea
//         anchors.fill: parent
//         enabled: iconButton.enabled
//         hoverEnabled: true
//         cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

//         onPressed: (mouse) => {
//             ripple.origin = Qt.point(mouse.x, mouse.y)
//             rippleAnimation.restart()
//         }

//         onClicked: iconButton.clicked()
//     }

//     ToolTip {
//         visible: tooltip !== "" && mouseArea.containsMouse
//         text: tooltip
//         delay: 500
//     }

//     Keys.onSpacePressed: if (enabled) handleActivation()
//     Keys.onEnterPressed: if (enabled) handleActivation()
//     Keys.onReturnPressed: if (enabled) handleActivation()

//     function handleActivation() {
//         ripple.origin = Qt.point(width/2, height/2)
//         rippleAnimation.restart()
//         clicked()
//     }
// }
