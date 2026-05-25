import QtQuick
import QtQuick.Layouts
import Chi

ChiApplicationWindow {
    id: root
    title: "ChiCounter"
    width: 360
    height: 500

    property int count: 0

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 24

        Text {
            text: root.count
            font.pixelSize: 96
            font.weight: Font.Bold
            color: ChiTheme.colors.primary
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
        }

        RowLayout {
            spacing: 24
            Layout.alignment: Qt.AlignHCenter

            IconButton {
                icon: "remove"
                size: "xlarge"
                variant: "tonal"
                enabled: root.count > 0
                onClicked: root.count--
            }

            IconButton {
                icon: "add"
                size: "xlarge"
                variant: "tonal"
                onClicked: root.count++
            }
        }

        Button {
            text: "Reset"
            variant: "outlined"
            onClicked: root.count = 0
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
