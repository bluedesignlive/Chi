import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as Basic
import smartui 1.0 as Su

Rectangle {
    width: 1400
    height: 900
    color: Su.ChiTheme.colors.background

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 40

        Column {
            spacing: 20
            Layout.preferredWidth: 280

            Text {
                text: "Navigation Rail"
                font.family: "Roboto"
                font.pixelSize: 28
                font.weight: Font.Medium
                color: Su.ChiTheme.colors.onBackground
                Behavior on color { ColorAnimation { duration: 200 } }
            }

            Text {
                text: "Primary navigation surface. Supports collapsed rail and expanded modes, menu button, FAB, and badges."
                font.family: "Roboto"
                font.pixelSize: 14
                color: Su.ChiTheme.colors.onSurfaceVariant
                wrapMode: Text.WordWrap
                width: parent.width
                Behavior on color { ColorAnimation { duration: 200 } }
            }

            Column {
                spacing: 10
                Text {
                    text: "Variant"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onSurface
                }
                Basic.ComboBox {
                    id: variantCombo
                    model: ["rail", "expanded"]
                    currentIndex: 0
                }
            }

            Column {
                spacing: 10
                Text {
                    text: "Alignment"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onSurface
                }
                Basic.ComboBox {
                    id: alignCombo
                    model: ["top", "middle"]
                    currentIndex: 0
                }
            }

            Basic.CheckBox {
                id: menuCheck
                text: "Show Menu Button"
                checked: true
            }

            Basic.CheckBox {
                id: fabCheck
                text: "Show FAB"
                checked: true
            }

            Text {
                id: statusText
                text: "Selected: Home"
                font.pixelSize: 14
                color: Su.ChiTheme.colors.primary
                wrapMode: Text.WordWrap
                width: parent.width
            }
        }

        Rectangle {
            id: railHost
            color: Su.ChiTheme.colors.surfaceContainer
            radius: 26
            Layout.fillWidth: true
            Layout.fillHeight: true
            Behavior on color { ColorAnimation { duration: 200 } }

            Su.NavigationRail {
                id: rail
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                    leftMargin: 20
                    topMargin: 20
                    bottomMargin: 20
                }

                width: variantCombo.currentIndex === 0 ? rail.railWidth : 260

                variant: variantCombo.currentIndex === 0 ? "rail" : "expanded"
                alignment: alignCombo.currentIndex === 0 ? "top" : "middle"
                showMenuButton: menuCheck.checked
                showFab: fabCheck.checked
                fabIcon: "+"
                fabText: "New"

                items: navItemsModel

                onItemClicked: function(idx) {
                    var elt = navItemsModel.get(idx)
                    statusText.text = "Selected: " + elt.label
                }
                onMenuClicked: statusText.text = "Menu clicked"
                onFabClicked: statusText.text = "FAB clicked"
            }

            Rectangle {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: rail.right
                    right: parent.right
                    margins: 20
                }
                radius: 20
                color: Su.ChiTheme.colors.surface

                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    Text {
                        text: "Page Content"
                        font.family: "Roboto"
                        font.pixelSize: 22
                        font.weight: Font.Medium
                        color: Su.ChiTheme.colors.onSurface
                    }

                    Text {
                        text: statusText.text
                        font.pixelSize: 14
                        color: Su.ChiTheme.colors.onSurfaceVariant
                    }
                }
            }

            ListModel {
                id: navItemsModel
                ListElement { icon: "home";    activeIcon: "home";    label: "Home" }
                ListElement { icon: "search";  activeIcon: "search";  label: "Search" }
                ListElement { icon: "mail";    activeIcon: "mail";    label: "Inbox";   badge: "large"; badgeText: "9+" }
                ListElement { icon: "person";  activeIcon: "person";  label: "Profile" }
                ListElement { icon: "settings";activeIcon: "settings";label: "Settings" }
            }
        }
    }
}
