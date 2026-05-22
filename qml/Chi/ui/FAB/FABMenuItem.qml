import QtQuick
import QtQuick.Effects
import "../../theme" as Theme
import "../common" as Common

Item {
    id: menuItem

    property string text: "Action"
    property string icon: "star"
    property string variant: "primary"
    property bool enabled: true

    signal clicked

    readonly property var colors: Theme.ChiTheme.colors
    readonly property var typography: Theme.ChiTheme.typography

    implicitWidth: contentRow.implicitWidth + 48
    implicitHeight: 56

    readonly property color _containerColor: variant === "secondary" ? colors.secondaryContainer : (variant === "tertiary" ? colors.tertiaryContainer : colors.primaryContainer)
    readonly property color _contentColor: variant === "secondary" ? colors.onSecondaryContainer : (variant === "tertiary" ? colors.onTertiaryContainer : colors.onPrimaryContainer)

    scale: mouseArea.pressed ? 0.94 : 1.0
    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }

    Rectangle {
        id: container
        anchors.fill: parent
        radius: 28
        clip: true
        color: menuItem._containerColor

        layer.enabled: menuItem.enabled
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.2)
            shadowVerticalOffset: mouseArea.containsMouse ? 3 : 2
            shadowBlur: mouseArea.containsMouse ? 0.3 : 0.15
        }

        Common.StateLayer {
            layerColor: menuItem._contentColor
            containerRadius: parent.radius
            pressed: mouseArea.pressed
            hovered: mouseArea.containsMouse
            enabled: menuItem.enabled
        }

        Common.Ripple {
            id: ripple
            color: menuItem._contentColor
            radius: parent.radius
            enabled: menuItem.enabled
        }

        Row {
            id: contentRow
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 24
            spacing: 8

            Text {
                text: menuItem.text
                font.family: Theme.ChiTheme.fontFamily
                font.weight: Font.Medium
                font.pixelSize: typography.titleMedium.size
                color: menuItem._contentColor
                anchors.verticalCenter: parent.verticalCenter
            }

            Common.Icon {
                source: menuItem.icon
                size: 24
                color: menuItem._contentColor
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: menuItem.enabled
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onPressed: (mouse) => ripple.addRipple(mouse.x, mouse.y)
        onReleased: ripple.removeRipple()
        onCanceled: ripple.removeRipple()
        onClicked: menuItem.clicked()
    }
}
