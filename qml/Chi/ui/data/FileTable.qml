import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import "../../theme" as Theme

Item {
    id: root
    
    property var colors: Theme.ChiTheme.colors
    readonly property string fontFamily: Theme.ChiTheme.fontFamily
    readonly property string iconFamily: Theme.ChiTheme.iconFamily
    property alias model: listView.model
    
    // Header Component (Internal for simplicity or extracted if needed)
    component HeaderCell: Rectangle {
        color: ma.containsMouse ? colors.surfaceContainerHighest : "transparent"
        radius: 4
        property string label: ""
        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left; anchors.leftMargin: 8
            text: parent.label
            font.family: fontFamily; font.weight: Font.Medium; font.pixelSize: 14; color: colors.onSurfaceVariant
        }
        MouseArea { id: ma; anchors.fill: parent; hoverEnabled: true }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Table Header
        Rectangle {
            Layout.fillWidth: true; height: 48
            color: colors.surface
            
            RowLayout {
                anchors.fill: parent; anchors.leftMargin: 16; anchors.rightMargin: 16; spacing: 0
                HeaderCell { Layout.fillWidth: true; Layout.fillHeight: true; label: "Name" }
                HeaderCell { Layout.preferredWidth: 180; Layout.fillHeight: true; label: "Date Modified" }
                HeaderCell { Layout.preferredWidth: 120; Layout.fillHeight: true; label: "Type" }
                HeaderCell { Layout.preferredWidth: 100; Layout.fillHeight: true; label: "Size" }
            }
            Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: colors.outlineVariant }
        }

        // Table Body
        ListView {
            id: listView
            Layout.fillWidth: true; Layout.fillHeight: true
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            
            delegate: Rectangle {
                id: row
                width: listView.width; height: 40; radius: 4
                property bool selected: ListView.isCurrentItem
                color: selected ? colors.secondaryContainer : (ma.containsMouse ? colors.surfaceContainer : "transparent")
                
                RowLayout {
                    anchors.fill: parent; anchors.leftMargin: 16; anchors.rightMargin: 16; spacing: 0
                    
                    // Name
                    Item {
                        Layout.fillWidth: true; Layout.fillHeight: true
                        Row {
                            anchors.verticalCenter: parent.verticalCenter; spacing: 12
                            Text { text: model.icon || "description"; font.family: iconFamily; font.pixelSize: 20; color: row.selected ? colors.onSecondaryContainer : colors.primary; anchors.verticalCenter: parent.verticalCenter }
                            Text { text: model.name; font.family: fontFamily; font.pixelSize: 14; color: row.selected ? colors.onSecondaryContainer : colors.onSurface; anchors.verticalCenter: parent.verticalCenter }
                        }
                    }
                    // Date
                    Item { Layout.preferredWidth: 180; Layout.fillHeight: true; Text { text: model.date; font.family: fontFamily; font.pixelSize: 13; color: colors.onSurfaceVariant; anchors.verticalCenter: parent.verticalCenter; anchors.left: parent.left; anchors.leftMargin: 8 } }
                    // Type
                    Item { Layout.preferredWidth: 120; Layout.fillHeight: true; Text { text: model.type; font.family: fontFamily; font.pixelSize: 13; color: colors.onSurfaceVariant; anchors.verticalCenter: parent.verticalCenter; anchors.left: parent.left; anchors.leftMargin: 8 } }
                    // Size
                    Item { Layout.preferredWidth: 100; Layout.fillHeight: true; Text { text: model.size; font.family: fontFamily; font.pixelSize: 13; color: colors.onSurfaceVariant; anchors.verticalCenter: parent.verticalCenter; anchors.left: parent.left; anchors.leftMargin: 8 } }
                }
                MouseArea { id: ma; anchors.fill: parent; hoverEnabled: true; onClicked: listView.currentIndex = index }
            }
        }
    }
}
