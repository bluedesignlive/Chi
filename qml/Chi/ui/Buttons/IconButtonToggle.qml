// smartui/ui/Buttons/IconButtonToggle.qml
import QtQuick
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import "../theme" as Theme

Item {
    id: toggleIconButton

    property string icon: "☆"
    property string selectedIcon: "★"
    property string size: "small"         // xsmall..xlarge
    property string widthMode: "default"  // narrow, default, wide
    property bool selected: false
    property bool enabled: true
    property string tooltip: ""

    signal toggled(bool selected)

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
            squareRadius: 12,
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

    readonly property string effectiveIcon:
        selected && selectedIcon !== "" ? selectedIcon : icon

    // Safe image detection based on effectiveIcon
    readonly property bool isIconImage:
        effectiveIcon.indexOf(".svg") !== -1 ||
        effectiveIcon.indexOf(".png") !== -1 ||
        effectiveIcon.indexOf(".jpg") !== -1 ||
        effectiveIcon.indexOf("qrc:/") === 0

    implicitWidth: containerWidth
    implicitHeight: currentSize.height

    states: [
        State { name: "disabled"; when: !enabled },
        State { name: "pressed";  when: mouseArea.pressed && enabled },
        State { name: "focused";  when: toggleIconButton.activeFocus && enabled && !mouseArea.pressed },
        State { name: "hovered";  when: mouseArea.containsMouse && enabled && !mouseArea.pressed },
        State { name: "enabled";  when: enabled && !mouseArea.containsMouse && !mouseArea.pressed && !toggleIconButton.activeFocus }
    ]

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        id: container
        anchors.centerIn: parent
        width: containerWidth
        height: currentSize.height
        clip: true

        radius: selected ? currentSize.squareRadius : 100

        color: {
            if (!enabled)
                return Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.12)
            return selected ? colors.primary : colors.surfaceContainer
        }

        Behavior on radius {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }
        Behavior on color {
            ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
        }

        // Simple, clipped ripple: full shape, opacity only
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

            color: selected ? colors.onPrimary : colors.onSurfaceVariant

            opacity: {
                if (!enabled) return 0
                switch (toggleIconButton.state) {
                case "pressed": return 0.12
                case "focused": return 0.12
                case "hovered": return 0.08
                default:        return 0
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: toggleIconButton.state === "pressed" ? 50 : 150
                    easing.type: Easing.OutCubic
                }
            }
        }

        Image {
            visible: effectiveIcon !== "" && isIconImage
            anchors.centerIn: parent
            width: currentSize.iconSize
            height: currentSize.iconSize
            source: effectiveIcon
            fillMode: Image.PreserveAspectFit
            smooth: true
            z: 2
        }

        Text {
            visible: effectiveIcon !== "" && !isIconImage
            anchors.centerIn: parent
            text: effectiveIcon
            font.family: "Material Icons"
            font.pixelSize: currentSize.iconSize
            z: 2

            color: {
                if (!enabled) return colors.onSurface
                return selected ? colors.onPrimary : colors.onSurfaceVariant
            }
        }

        Rectangle {
            id: focusIndicator
            visible: toggleIconButton.state === "focused"
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
        enabled: toggleIconButton.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        onPressed: rippleAnimation.restart()
        onClicked: {
            toggleIconButton.selected = !toggleIconButton.selected
            toggleIconButton.toggled(toggleIconButton.selected)
        }
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
        toggleIconButton.selected = !toggleIconButton.selected
        toggleIconButton.toggled(toggleIconButton.selected)
    }
}
