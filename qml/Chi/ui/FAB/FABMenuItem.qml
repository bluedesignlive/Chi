import QtQuick
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

    property var colors: Theme.ChiTheme.colors

    readonly property color _cc: {
        switch (variant) {
            case "secondary": return colors.secondaryContainer
            case "tertiary": return colors.tertiaryContainer
            default: return colors.primaryContainer
        }
    }

    readonly property color _occ: {
        switch (variant) {
            case "secondary": return colors.onSecondaryContainer
            case "tertiary": return colors.onTertiaryContainer
            default: return colors.onPrimaryContainer
        }
    }

    Rectangle {
        id: container
        anchors.fill: parent
        radius: 28
        clip: true
        color: menuItem._cc

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: menuItem._occ
            opacity: 0
            SequentialAnimation on opacity {
                id: rippleAnimation
                running: false
                NumberAnimation { from: 0; to: 0.16; duration: 90; easing.type: Easing.OutCubic }
                NumberAnimation { to: 0; duration: 210; easing.type: Easing.OutCubic }
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: menuItem._occ
            opacity: mouseArea.pressed ? 0.12 :
                     (menuItem.activeFocus ? 0.12 :
                     (mouseArea.containsMouse ? 0.08 : 0))
            Behavior on opacity {
                NumberAnimation { duration: mouseArea.pressed ? 50 : 150; easing.type: Easing.OutCubic }
            }
        }

        Row {
            id: contentRow
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 24
            spacing: 8

            Text {
                text: menuItem.text
                font.family: "Roboto"
                font.weight: Font.Medium
                font.pixelSize: 16
                font.letterSpacing: 0.15
                lineHeight: 24
                lineHeightMode: Text.FixedHeight
                horizontalAlignment: Text.AlignRight
                color: menuItem._occ
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: menuItem.icon
                font.family: "Material Icons"
                font.pixelSize: 24
                color: menuItem._occ
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Rectangle {
            visible: menuItem.activeFocus && !mouseArea.pressed
            anchors.fill: parent
            anchors.margins: -2
            radius: 30
            color: "transparent"
            border.width: 3
            border.color: colors.secondary
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
