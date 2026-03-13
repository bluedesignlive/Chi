import QtQuick
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Item {
    id: fab

    property string icon: "+"
    property string variant: "primary"
    property bool enabled: true
    property bool menuOpen: false

    signal clicked()

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    implicitWidth: 56
    implicitHeight: 56

    property var colors: Theme.ChiTheme.colors

    readonly property var variantColors: ({
        primary:   { container: colors.primaryContainer,   onContainer: colors.onPrimaryContainer },
        secondary: { container: colors.secondaryContainer, onContainer: colors.onSecondaryContainer },
        tertiary:  { container: colors.tertiaryContainer,  onContainer: colors.onTertiaryContainer },
        surface:   { container: colors.surfaceContainerHigh, onContainer: colors.primary }
    })

    readonly property var currentVariant: variantColors[variant] || variantColors.primary

    Rectangle {
        id: container
        anchors.fill: parent
        radius: 16
        clip: true
        color: currentVariant.container

        layer.enabled: enabled
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: mouseArea.containsMouse ? 4 : 2
            radius: mouseArea.containsMouse ? 8 : 4
            samples: 17
            color: Qt.rgba(0, 0, 0, 0.25)
        }

        Rectangle {
            id: ripple
            anchors.fill: parent
            radius: parent.radius
            color: currentVariant.onContainer
            opacity: 0
            SequentialAnimation on opacity {
                id: rippleAnimation
                running: false
                NumberAnimation { from: 0; to: 0.12; duration: 90 }
                NumberAnimation { to: 0; duration: 210 }
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: currentVariant.onContainer
            opacity: mouseArea.pressed ? 0.12 : (mouseArea.containsMouse ? 0.08 : 0)
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }

        Text {
            anchors.centerIn: parent
            text: icon
            font.family: "Material Icons"
            font.pixelSize: 24
            color: currentVariant.onContainer
            rotation: menuOpen ? 45 : 0
            Behavior on rotation { NumberAnimation { duration: 200 } }
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
