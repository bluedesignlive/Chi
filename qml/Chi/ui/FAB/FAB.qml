import QtQuick
import QtQuick.Effects
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

    readonly property color _cc: {
        switch (variant) {
            case "secondary": return colors.secondaryContainer
            case "tertiary": return colors.tertiaryContainer
            case "surface": return colors.surfaceContainerHigh
            default: return colors.primaryContainer
        }
    }

    readonly property color _occ: {
        switch (variant) {
            case "secondary": return colors.onSecondaryContainer
            case "tertiary": return colors.onTertiaryContainer
            case "surface": return colors.primary
            default: return colors.onPrimaryContainer
        }
    }

    Rectangle {
        id: container
        anchors.fill: parent
        radius: 16
        clip: true
        color: fab._cc

        layer.enabled: fab.enabled
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.25)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: mouseArea.containsMouse ? 4 : 2
            shadowBlur: mouseArea.containsMouse ? 0.4 : 0.2
        }

        Rectangle {
            id: ripple
            anchors.fill: parent
            radius: parent.radius
            color: fab._occ
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
            color: fab._occ
            opacity: mouseArea.pressed ? 0.12 : (mouseArea.containsMouse ? 0.08 : 0)
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }

        Text {
            anchors.centerIn: parent
            text: fab.icon
            font.family: "Material Icons"
            font.pixelSize: 24
            color: fab._occ
            rotation: fab.menuOpen ? 45 : 0
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
