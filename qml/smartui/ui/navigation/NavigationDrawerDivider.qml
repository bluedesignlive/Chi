import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme

Item {
    id: root

    property string label: ""

    Layout.fillWidth: true
    implicitHeight: label !== "" ? 44 : 17

    property var colors: Theme.ChiTheme.colors

    Column {
        anchors.fill: parent
        anchors.leftMargin: 28
        anchors.rightMargin: 28
        spacing: 0

        Item { width: 1; height: 8 }

        Rectangle {
            width: parent.width
            height: 1
            color: colors.outlineVariant

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }

        Item { width: 1; height: 8 }

        Text {
            visible: label !== ""
            text: label
            font.family: "Roboto"
            font.pixelSize: 14
            font.weight: Font.Medium
            font.letterSpacing: 0.1
            color: colors.onSurfaceVariant
            topPadding: 8

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }
    }
}
