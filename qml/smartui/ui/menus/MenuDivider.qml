import QtQuick
import "../../theme" as Theme

Item {
    implicitWidth: parent ? parent.width : 200
    implicitHeight: 17

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        anchors.centerIn: parent
        width: parent.width - 24
        height: 1
        color: colors.outlineVariant
        Behavior on color { ColorAnimation { duration: 200 } }
    }
}
