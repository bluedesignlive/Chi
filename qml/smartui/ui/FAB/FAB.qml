// smartui/ui/FAB/FAB.qml
import QtQuick
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Item {
    id: fab

    property string icon: "+"
    property string variant: "primary"  // primary, secondary, tertiary
    property bool enabled: true
    property bool menuOpen: false

    signal clicked()

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    implicitWidth: 56
    implicitHeight: 56

    states: [
        State { name: "disabled"; when: !enabled },
        State { name: "pressed";  when: mouseArea.pressed && enabled },
        State { name: "focused";  when: fab.activeFocus && enabled && !mouseArea.pressed },
        State { name: "hovered";  when: mouseArea.containsMouse && enabled && !mouseArea.pressed },
        State { name: "enabled";  when: enabled && !mouseArea.containsMouse && !mouseArea.pressed && !fab.activeFocus }
    ]

    property var colors: Theme.ChiTheme.colors

    readonly property var variantColors: ({
        primary: {
            container: colors.primary,
            onContainer: colors.onPrimary
        },
        secondary: {
            container: colors.secondary,
            onContainer: colors.onSecondary
        },
        tertiary: {
            container: colors.tertiary,
            onContainer: colors.onTertiary
        }
    })

    readonly property var currentVariant: variantColors[variant] || variantColors.primary

    Rectangle {
        id: container
        anchors.fill: parent
        radius: 28
        clip: true

        color: currentVariant.container

        // Elevation shadow (one DropShadow per FAB, fine performance-wise)
        layer.enabled: enabled
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: fab.state === "hovered" ? 2 : 1
            radius: fab.state === "hovered" ? 8 : 4
            samples: 17
            color: Qt.rgba(0, 0, 0, 0.3)
        }

        // Simple, clipped ripple: full shape, opacity only
        Rectangle {
            id: ripple
            anchors.fill: parent
            radius: parent.radius
            color: currentVariant.onContainer
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

        // State layer (hover/press)
        Rectangle {
            id: stateLayer
            anchors.fill: parent
            radius: parent.radius
            z: 1

            color: currentVariant.onContainer

            opacity: {
                if (!enabled) return 0
                switch (fab.state) {
                case "pressed": return 0.12
                case "focused": return 0.12
                case "hovered": return 0.08
                default:        return 0
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: fab.state === "pressed" ? 50 : 150
                    easing.type: Easing.OutCubic
                }
            }
        }

        // Icon
        Text {
            anchors.centerIn: parent
            text: icon
            font.family: "Material Icons"
            font.pixelSize: 24
            color: currentVariant.onContainer
            z: 2

            rotation: menuOpen ? 45 : 0
            Behavior on rotation {
                NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
            }
        }

        // Focus indicator
        Rectangle {
            id: focusIndicator
            visible: fab.state === "focused"
            anchors.fill: parent
            anchors.margins: -2
            radius: 30
            color: "transparent"
            border.width: 3
            border.color: colors.secondary
            z: 3
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: fab.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        onPressed: rippleAnimation.restart()
        onClicked: fab.clicked()
    }
}
