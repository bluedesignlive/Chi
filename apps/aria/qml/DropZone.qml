import QtQuick
import Chi 1.0

// Empty state — drop audio files or click the button
Item {
    id: root
    signal filesDropped(var urls)
    signal clicked()

    property var colors: ChiTheme.colors
    property bool _hovering: dropArea.containsDrag

    Rectangle {
        anchors.centerIn: parent
        width: Math.min(parent.width - 80, 360)
        height: 200; radius: 24
        color: _hovering ? colors.primaryContainer : "transparent"
        border.width: 2
        border.color: _hovering ? colors.primary : colors.outlineVariant
        opacity: _hovering ? 1 : 0.6

        Behavior on color { ColorAnimation { duration: 150 } }
        Behavior on border.color { ColorAnimation { duration: 150 } }

        Column {
            anchors.centerIn: parent; spacing: 16

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "\uE2C6"
                font.family: "Material Symbols Outlined"; font.pixelSize: 40
                color: _hovering ? colors.primary : colors.onSurfaceVariant
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Drop audio files here"
                font.family: ChiTheme.fontFamily; font.pixelSize: 15; font.weight: Font.Medium
                color: colors.onSurface
            }

            // Chi library Button
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Browse Files"
                variant: "tonal"
                size: "medium"
                showIcon: true
                icon: "folder_open"
                onClicked: root.clicked()
            }
        }
    }

    DropArea {
        id: dropArea
        anchors.fill: parent
        onDropped: function(drop) { if (drop.hasUrls) root.filesDropped(drop.urls) }
    }
}
