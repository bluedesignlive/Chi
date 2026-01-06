import QtQuick
import QtQuick.Layouts
import SmartUIBeta 1.0 as Su

Rectangle {
    width: 1200
    height: 800
    color: Su.ChiTheme.colors.background
    radius: 26

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    Flickable {
        anchors.fill: parent
        anchors.margins: 2
        contentHeight: mainColumn.height + 80
        clip: true

        Column {
            id: mainColumn
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 80
            spacing: 40
            topPadding: 40
            bottomPadding: 40

            Row {
                width: parent.width
                spacing: 20

                Text {
                    text: "SmartUI Menu System"
                    font.family: "Roboto"
                    font.pixelSize: 32
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    anchors.verticalCenter: parent.verticalCenter
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Item { Layout.fillWidth: true; width: 100 }

                Row {
                    spacing: 10
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: "☀️"
                        font.pixelSize: 20
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Su.Switch {
                        checked: Su.ChiTheme.isDarkMode
                        onToggled: Su.ChiTheme.isDarkMode = !Su.ChiTheme.isDarkMode
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "🌙"
                        font.pixelSize: 20
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            Text {
                text: "Popup menus with items, dividers, and various styling options."
                font.family: "Roboto"
                font.pixelSize: 14
                color: Su.ChiTheme.colors.onSurfaceVariant
                wrapMode: Text.WordWrap
                width: parent.width
                Behavior on color { ColorAnimation { duration: 200 } }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Su.ChiTheme.colors.outline
                opacity: 0.3
            }

            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Basic Menu Triggers"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Flow {
                    width: parent.width
                    spacing: 20

                    Su.Button {
                        text: "Open Menu 1"
                        variant: "elevated"
                        onClicked: demoMenu1.show()
                    }

                    Su.Button {
                        text: "Open Menu 2"
                        variant: "filled"
                        onClicked: demoMenu2.show()
                    }

                    Su.Button {
                        text: "Open Menu 3"
                        variant: "outlined"
                        onClicked: demoMenu3.show()
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Su.ChiTheme.colors.outline
                opacity: 0.3
            }

            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Menu Variants"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Text {
                    text: "Different menu styles and configurations"
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: Su.ChiTheme.colors.onSurfaceVariant
                    wrapMode: Text.WordWrap
                    width: parent.width
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Flow {
                    width: parent.width
                    spacing: 20

                    Column {
                        spacing: 8
                        Su.Button {
                            text: "Expressive Menu"
                            variant: "tonal"
                            onClicked: expressiveMenu.show()
                        }
                        Text {
                            text: "Rounded corners (16px)"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Button {
                            text: "Classic Menu"
                            variant: "tonal"
                            onClicked: classicMenu.show()
                        }
                        Text {
                            text: "Square corners (4px)"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Su.ChiTheme.colors.outline
                opacity: 0.3
            }

            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Menu Color Styles"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Flow {
                    width: parent.width
                    spacing: 20

                    Column {
                        spacing: 8
                        Su.Button {
                            text: "Standard"
                            variant: "elevated"
                            onClicked: standardMenu.show()
                        }
                        Text {
                            text: "Default colors"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Button {
                            text: "Vibrant"
                            variant: "elevated"
                            onClicked: vibrantMenu.show()
                        }
                        Text {
                            text: "Tertiary container"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Su.ChiTheme.colors.outline
                opacity: 0.3
            }

            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Menu Content Examples"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Flow {
                    width: parent.width
                    spacing: 20

                    Column {
                        spacing: 8
                        Su.Button {
                            text: "With Icons"
                            variant: "outlined"
                            onClicked: iconMenu.show()
                        }
                        Text {
                            text: "Items with icons"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Button {
                            text: "With Dividers"
                            variant: "outlined"
                            onClicked: dividerMenu.show()
                        }
                        Text {
                            text: "Items separated"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Button {
                            text: "Disabled Items"
                            variant: "outlined"
                            onClicked: disabledMenu.show()
                        }
                        Text {
                            text: "With disabled items"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Su.ChiTheme.colors.outline
                opacity: 0.3
            }

            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Menu States"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Flow {
                    width: parent.width
                    spacing: 20

                    Column {
                        spacing: 8
                        Su.Button {
                            text: "Hover States"
                            variant: "filled"
                            onClicked: hoverMenu.show()
                        }
                        Text {
                            text: "Test hover effects"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Button {
                            text: "Selected Item"
                            variant: "filled"
                            onClicked: selectedMenu.show()
                        }
                        Text {
                            text: "With selection"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Su.ChiTheme.colors.outline
                opacity: 0.3
            }

            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Button Menu Triggers"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Flow {
                    width: parent.width
                    spacing: 30

                    Column {
                        spacing: 8
                        Su.Button {
                            text: "Menu Button"
                            variant: "elevated"
                            onClicked: demoMenu1.show()
                        }
                        Text {
                            text: "Button trigger"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.IconButton {
                            icon: "⋮"
                            variant: "tonal"
                            onClicked: demoMenu2.show()
                        }
                        Text {
                            text: "Icon button"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }
                }
            }
        }
    }

    Su.Menu {
        id: demoMenu1

        Su.MenuItem {
            text: "New"
        }
        Su.MenuItem {
            text: "Open"
        }
        Su.MenuDivider { }
        Su.MenuItem {
            text: "Save"
        }
        Su.MenuItem {
            text: "Save As"
        }
        Su.MenuDivider { }
        Su.MenuItem {
            text: "Exit"
        }
    }

    Su.Menu {
        id: demoMenu2
        variant: "expressive"

        Su.MenuItem {
            text: "Copy"
        }
        Su.MenuItem {
            text: "Cut"
        }
        Su.MenuItem {
            text: "Paste"
        }
        Su.MenuDivider { }
        Su.MenuItem {
            text: "Select All"
        }
    }

    Su.Menu {
        id: demoMenu3
        colorStyle: "vibrant"

        Su.MenuItem {
            text: "View"
        }
        Su.MenuItem {
            text: "Edit"
        }
        Su.MenuItem {
            text: "Tools"
        }
        Su.MenuDivider { }
        Su.MenuItem {
            text: "Help"
        }
    }

    Su.Menu {
        id: expressiveMenu
        variant: "expressive"

        Su.MenuItem {
            text: "Expressive Item 1"
        }
        Su.MenuItem {
            text: "Expressive Item 2"
        }
        Su.MenuItem {
            text: "Expressive Item 3"
        }
    }

    Su.Menu {
        id: classicMenu
        variant: "classic"

        Su.MenuItem {
            text: "Classic Item 1"
        }
        Su.MenuItem {
            text: "Classic Item 2"
        }
        Su.MenuItem {
            text: "Classic Item 3"
        }
    }

    Su.Menu {
        id: standardMenu
        colorStyle: "standard"

        Su.MenuItem {
            text: "Standard Item 1"
        }
        Su.MenuItem {
            text: "Standard Item 2"
        }
        Su.MenuItem {
            text: "Standard Item 3"
        }
    }

    Su.Menu {
        id: vibrantMenu
        colorStyle: "vibrant"

        Su.MenuItem {
            text: "Vibrant Item 1"
        }
        Su.MenuItem {
            text: "Vibrant Item 2"
        }
        Su.MenuItem {
            text: "Vibrant Item 3"
        }
    }

    Su.Menu {
        id: iconMenu

        Su.MenuItem {
            text: "📄 New Document"
        }
        Su.MenuItem {
            text: "📁 Open Folder"
        }
        Su.MenuItem {
            text: "💾 Save"
        }
        Su.MenuItem {
            text: "📤 Export"
        }
        Su.MenuDivider { }
        Su.MenuItem {
            text: "⚙️ Settings"
        }
    }

    Su.Menu {
        id: dividerMenu

        Su.MenuItem {
            text: "Group 1 - Item 1"
        }
        Su.MenuItem {
            text: "Group 1 - Item 2"
        }
        Su.MenuDivider { }
        Su.MenuItem {
            text: "Group 2 - Item 1"
        }
        Su.MenuItem {
            text: "Group 2 - Item 2"
        }
        Su.MenuDivider { }
        Su.MenuItem {
            text: "Group 3 - Item 1"
        }
    }

    Su.Menu {
        id: disabledMenu

        Su.MenuItem {
            text: "Enabled Item"
        }
        Su.MenuItem {
            text: "Disabled Item"
            enabled: false
        }
        Su.MenuDivider { }
        Su.MenuItem {
            text: "Another Enabled"
        }
        Su.MenuItem {
            text: "Also Disabled"
            enabled: false
        }
    }

    Su.Menu {
        id: hoverMenu

        Su.MenuItem {
            text: "Hover over me"
        }
        Su.MenuItem {
            text: "And me"
        }
        Su.MenuItem {
            text: "Hover effect test"
        }
    }

    Su.Menu {
        id: selectedMenu

        Su.MenuItem {
            text: "Not Selected"
        }
        Su.MenuItem {
            text: "Selected Item"
            selected: true
        }
        Su.MenuItem {
            text: "Another Item"
        }
    }
}
