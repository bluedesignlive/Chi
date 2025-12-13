import QtQuick
import QtQuick.Controls.Basic as T
import "../../theme" as Theme

T.MenuItem {
    id: control
    property string iconName: ""
    property string shortcutText: ""
    property var colors: Theme.ChiTheme.colors

    implicitWidth: 240
    implicitHeight: 48

    background: Rectangle {
        implicitWidth: 240
        implicitHeight: 48
        color: "transparent"
        
        Rectangle {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            anchors.topMargin: 2
            anchors.bottomMargin: 2
            radius: 24 
            color: control.highlighted ? colors.onSurface : "transparent"
            opacity: control.highlighted ? 0.12 : 0
            Behavior on opacity { NumberAnimation { duration: 100 } }
        }
    }

    contentItem: Item {
        anchors.fill: parent
        Row {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 12
            Text {
                visible: control.iconName !== ""
                text: control.iconName
                font.family: "Material Icons"
                font.pixelSize: 20
                color: control.enabled ? colors.onSurfaceVariant : colors.onSurface
                opacity: control.enabled ? 1.0 : 0.38
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: control.text
                font.family: "Roboto"
                font.pixelSize: 14
                color: control.enabled ? colors.onSurface : colors.onSurface
                opacity: control.enabled ? 1.0 : 0.38
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideRight
                width: parent.width - (control.iconName !== "" ? 32 : 0) - (control.shortcutText !== "" ? 50 : 0)
            }
        }
        Text {
            visible: control.shortcutText !== ""
            text: control.shortcutText
            font.family: "Roboto"
            font.pixelSize: 12
            color: colors.onSurfaceVariant
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
