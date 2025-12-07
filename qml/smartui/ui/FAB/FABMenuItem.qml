// smartui/ui/FAB/FABMenuItem.qml
import QtQuick
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Item {
    id: menuItem

    property string text: "Action"
    property string icon: "★"
    property string variant: "primary"
    property bool enabled: true

    signal clicked()

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    implicitWidth: contentRow.implicitWidth + 48
    implicitHeight: 56

    states: [
        State { name: "disabled"; when: !enabled },
        State { name: "pressed";  when: mouseArea.pressed && enabled },
        State { name: "focused";  when: menuItem.activeFocus && enabled && !mouseArea.pressed },
        State { name: "hovered";  when: mouseArea.containsMouse && enabled && !mouseArea.pressed },
        State { name: "enabled";  when: enabled && !mouseArea.containsMouse && !mouseArea.pressed && !menuItem.activeFocus }
    ]

    property var colors: Theme.ChiTheme.colors

    readonly property var variantColors: ({
        primary: {
            container: colors.primaryContainer,
            onContainer: colors.onPrimaryContainer
        },
        secondary: {
            container: colors.secondaryContainer,
            onContainer: colors.onSecondaryContainer
        },
        tertiary: {
            container: colors.tertiaryContainer,
            onContainer: colors.onTertiaryContainer
        }
    })

    readonly property var currentVariant: variantColors[variant] || variantColors.primary

    Rectangle {
        id: container
        anchors.fill: parent
        radius: 28
        clip: true

        color: currentVariant.container

        // Simple, clipped ripple
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

        // State layer
        Rectangle {
            id: stateLayer
            anchors.fill: parent
            radius: parent.radius
            z: 1

            color: currentVariant.onContainer

            opacity: {
                if (!enabled) return 0
                switch (menuItem.state) {
                case "pressed": return 0.12
                case "focused": return 0.12
                case "hovered": return 0.08
                default:        return 0
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: menuItem.state === "pressed" ? 50 : 150
                    easing.type: Easing.OutCubic
                }
            }
        }

        // Content row: text + icon, right-aligned
        Row {
            id: contentRow
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 24
            spacing: 8
            z: 2

            Text {
                text: menuItem.text
                font.family: "Roboto"
                font.weight: Font.Medium
                font.pixelSize: 16
                font.letterSpacing: 0.15
                lineHeight: 24
                lineHeightMode: Text.FixedHeight
                horizontalAlignment: Text.AlignRight
                color: currentVariant.onContainer
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: icon
                font.family: "Material Icons"
                font.pixelSize: 24
                color: currentVariant.onContainer
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Focus indicator
        Rectangle {
            id: focusIndicator
            visible: menuItem.state === "focused"
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
        enabled: menuItem.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        onPressed: rippleAnimation.restart()
        onClicked: menuItem.clicked()
    }
}
