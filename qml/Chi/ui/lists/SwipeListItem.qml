import QtQuick
import QtQuick.Controls.Basic as T
import QtQuick.Layouts
import "../theme" as Theme

T.SwipeDelegate {
    id: control

    property string headline: ""
    property string supportingText: ""
    property string leadingIcon: ""
    property string trailingText: ""
    
    // Swipe Configuration
    property string startActionIcon: "archive"
    property color startActionColor: Theme.ChiTheme.colors.primaryContainer
    property string endActionIcon: "delete"
    property color endActionColor: Theme.ChiTheme.colors.errorContainer
    
    signal startActionTriggered()
    signal endActionTriggered()

    property var colors: Theme.ChiTheme.colors
    
    implicitWidth: 360
    implicitHeight: 72

    // Background
    background: Rectangle {
        color: control.highlighted ? colors.surfaceContainerHighest : colors.surface
        radius: 12
        
        Rectangle {
            anchors.fill: parent
            radius: 12
            color: colors.onSurface
            opacity: control.pressed ? 0.12 : (control.hovered ? 0.08 : 0)
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
    }

    // Content
    contentItem: RowLayout {
        spacing: 16
        
        Item {
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40
            visible: control.leadingIcon !== ""
            Text {
                anchors.centerIn: parent
                text: control.leadingIcon
                font.family: "Material Icons"
                font.pixelSize: 24
                color: colors.onSurfaceVariant
            }
        }

        Column {
            Layout.fillWidth: true
            spacing: 2
            Text {
                text: control.headline
                font.family: "Roboto"
                font.pixelSize: 16
                color: colors.onSurface
                elide: Text.ElideRight
                width: parent.width
            }
            Text {
                text: control.supportingText
                font.family: "Roboto"
                font.pixelSize: 14
                color: colors.onSurfaceVariant
                elide: Text.ElideRight
                width: parent.width
                visible: control.supportingText !== ""
            }
        }

        Text {
            text: control.trailingText
            font.family: "Roboto"
            font.pixelSize: 12
            color: colors.onSurfaceVariant
            visible: control.trailingText !== ""
        }
    }

    // Swipe Actions
    swipe.left: Rectangle {
        width: parent.width; height: parent.height
        radius: 12
        color: control.startActionColor
        clip: true
        Text {
            text: control.startActionIcon
            font.family: "Material Icons"
            font.pixelSize: 24
            color: colors.onPrimaryContainer
            anchors.left: parent.left; anchors.leftMargin: 24; anchors.verticalCenter: parent.verticalCenter
        }
        onVisibleChanged: if(visible && control.swipe.position > 0.4) control.startActionTriggered()
    }

    swipe.right: Rectangle {
        width: parent.width; height: parent.height
        radius: 12
        color: control.endActionColor
        clip: true
        Text {
            text: control.endActionIcon
            font.family: "Material Icons"
            font.pixelSize: 24
            color: colors.onErrorContainer
            anchors.right: parent.right; anchors.rightMargin: 24; anchors.verticalCenter: parent.verticalCenter
        }
        onVisibleChanged: if(visible && control.swipe.position < -0.4) control.endActionTriggered()
    }
}
