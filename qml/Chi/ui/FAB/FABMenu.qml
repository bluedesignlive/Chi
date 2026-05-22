import QtQuick
import "../../theme" as Theme
import "."

Item {
    id: fabMenu
    property string variant: "primary"
    property bool open: false
    property var menuItems: []
    signal itemClicked(int index, string text)

    implicitWidth: 135
    implicitHeight: column.height

    Column {
        id: column
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        spacing: 8

        Column {
            id: menuColumn
            anchors.right: parent.right
            spacing: 4
            transformOrigin: Item.BottomRight

            states: [
                State {
                    name: "open"
                    when: fabMenu.open
                    PropertyChanges { target: menuColumn; opacity: 1.0; scale: 1.0 }
                },
                State {
                    name: "closed"
                    when: !fabMenu.open
                    PropertyChanges { target: menuColumn; opacity: 0.0; scale: 0.5 }
                }
            ]

            transitions: [
                Transition {
                    from: "closed"; to: "open"
                    NumberAnimation { property: "opacity"; duration: 250; easing.type: Easing.InOutQuad }
                    NumberAnimation { property: "scale";   duration: 400; easing.type: Easing.OutBack; easing.overshoot: 1.1 }
                },
                Transition {
                    from: "open"; to: "closed"
                    NumberAnimation { property: "opacity"; duration: 200; easing.type: Easing.InOutQuad }
                    NumberAnimation { property: "scale";   duration: 250; easing.type: Easing.InQuad }
                }
            ]

            Repeater {
                model: fabMenu.menuItems
                FABMenuItem {
                    anchors.right: parent.right
                    text: modelData.text
                    icon: modelData.icon
                    variant: fabMenu.variant
                    enabled: (modelData.enabled !== undefined ? modelData.enabled : true) && fabMenu.open
                    onClicked: { fabMenu.itemClicked(index, text); fabMenu.open = false }
                }
            }
        }

        FAB {
            anchors.right: parent.right
            variant: fabMenu.variant
            icon: "add"
            menuOpen: fabMenu.open
            onClicked: fabMenu.open = !fabMenu.open
        }
    }
}
