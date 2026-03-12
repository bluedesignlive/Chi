// qml/smartui/ui/menus/MenuDivider.qml
// M3 menu divider — thin rule with vertical padding
import QtQuick
import "../theme" as Theme

Item {
    id: root

    implicitWidth: parent ? parent.width : 200
    implicitHeight: 9

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        anchors.centerIn: parent
        width: parent.width - 24
        height: 1
        color: root.colors.outlineVariant
    }
}
