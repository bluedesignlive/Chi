import QtQuick
import "../../theme" as Theme

Item {
    id: root

    property string icon: ""
    property string tooltip: ""
    property bool enabled: true

    signal clicked()

    implicitWidth: 48
    implicitHeight: 48

    opacity: enabled ? 1.0 : 0.38

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        anchors.centerIn: parent
        width: 40
        height: 40
        radius: 20
        color: colors.onSurface
        opacity: mouseArea.containsMouse && enabled ? 0.08 : 0

        Behavior on opacity {
            NumberAnimation { duration: 100 }
        }
    }

    Text {
        anchors.centerIn: parent
        text: icon
        font.family: icon.length > 2 ? "Material Icons" : "Roboto"
        font.pixelSize: 24
        color: colors.onSurfaceVariant

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        onClicked: root.clicked()
    }

    Accessible.role: Accessible.Button
    Accessible.name: tooltip || icon
}
