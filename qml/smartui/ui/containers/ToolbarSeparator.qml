import QtQuick
import "../../theme" as Theme

Item {
    id: root

    property string orientation: "vertical"  // "vertical" for horizontal toolbar, "horizontal" for vertical toolbar

    implicitWidth: orientation === "vertical" ? 1 : 32
    implicitHeight: orientation === "vertical" ? 32 : 1

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        anchors.centerIn: parent
        width: orientation === "vertical" ? 1 : parent.width - 8
        height: orientation === "vertical" ? parent.height - 8 : 1
        color: colors.outlineVariant

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }
}
