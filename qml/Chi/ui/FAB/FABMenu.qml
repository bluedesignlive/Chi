// smartui/ui/FAB/FABMenu.qml
import QtQuick
import "../../theme" as Theme
import "."    // FAB and FABMenuItem in this directory

Item {
    id: fabMenu

    property string variant: "primary"
    property bool open: false
    property var menuItems: []   // array of { text, icon, enabled? }

    signal itemClicked(int index, string text)

    readonly property var motion: Theme.ChiTheme.motion

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
            scale: open ? 1 : 0.88
            transformOrigin: Item.BottomRight

            Behavior on opacity {
                enabled: fabMenu.motion.animationsEnabled
                NumberAnimation {
                    duration: fabMenu.motion.entry.duration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: fabMenu.motion.entry.curve
                }
            }

            Behavior on scale {
                enabled: fabMenu.motion.animationsEnabled
                NumberAnimation {
                    duration: fabMenu.motion.spring.fast.spatial.duration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: fabMenu.motion.spring.fast.spatial.curve
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
                        fabMenu.itemClicked(index, text);
                        fabMenu.open = false;
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
