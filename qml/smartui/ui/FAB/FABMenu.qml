// smartui/ui/FAB/FABMenu.qml
import QtQuick
import "."    // FAB and FABMenuItem in this directory

Item {
    id: fabMenu

    property string variant: "primary"
    property bool open: false
    property var menuItems: []   // array of { text, icon, enabled? }

    signal itemClicked(int index, string text)

    implicitWidth: 135
    implicitHeight: column.height

    Column {
        id: column
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        spacing: 8

        // Menu items
        Column {
            id: menuColumn
            anchors.right: parent.right
            spacing: 4

            opacity: open ? 1 : 0
            visible: opacity > 0
            scale: open ? 1 : 0.8
            transformOrigin: Item.BottomRight

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutBack
                }
            }

            Repeater {
                model: fabMenu.menuItems

                FABMenuItem {
                    anchors.right: parent.right
                    text: modelData.text
                    icon: modelData.icon
                    variant: fabMenu.variant
                    enabled: modelData.enabled !== undefined ? modelData.enabled : true

                    onClicked: {
                        fabMenu.itemClicked(index, text)
                        fabMenu.open = false
                    }
                }
            }
        }

        // FAB aligned with menu
        FAB {
            anchors.right: parent.right
            variant: fabMenu.variant
            icon: "+"
            menuOpen: fabMenu.open

            onClicked: fabMenu.open = !fabMenu.open
        }
    }
}
