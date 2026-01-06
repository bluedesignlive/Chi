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
                    text: "SmartUI Tabs System"
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
                text: "Navigation tabs for organizing content at the same level of hierarchy."
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
                    text: "Basic Tabs"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Column {
                    width: 600
                    spacing: 20

                    Su.Tabs {
                        currentIndex: 0

                        Su.Tab { text: "Home" }
                        Su.Tab { text: "About" }
                        Su.Tab { text: "Contact" }
                    }

                    Su.Tabs {
                        currentIndex: 1

                        Su.Tab { text: "Overview" }
                        Su.Tab { text: "Details" }
                        Su.Tab { text: "Settings" }
                        Su.Tab { text: "Help" }
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
                    text: "Tab States"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Column {
                    width: 600
                    spacing: 20

                    Su.Tabs {
                        currentIndex: 0

                        Su.Tab { text: "Active" }
                        Su.Tab { text: "Inactive" }
                        Su.Tab { text: "Inactive" }
                    }

                    Su.Tabs {
                        currentIndex: 1

                        Su.Tab { text: "Inactive" }
                        Su.Tab { text: "Active" }
                        Su.Tab { text: "Inactive" }
                    }

                    Su.Tabs {
                        currentIndex: 0

                        Su.Tab { text: "Active" }
                        Su.Tab { text: "Disabled" }
                        Su.Tab { text: "Disabled" }
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
                    text: "Interactive Tabs with Content"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Column {
                    width: parent.width
                    spacing: 20

                    property int currentTab: 0

                    Su.Tabs {
                        width: 500
                        currentIndex: parent.currentTab

                        Su.Tab {
                            text: "Overview"
                            onClicked: parent.currentTab = 0
                        }
                        Su.Tab {
                            text: "Features"
                            onClicked: parent.currentTab = 1
                        }
                        Su.Tab {
                            text: "Pricing"
                            onClicked: parent.currentTab = 2
                        }
                    }

                    Su.Card {
                        width: 500
                        height: 200
                        variant: "elevated"

                        Column {
                            anchors.fill: parent
                            anchors.margins: 24
                            spacing: 12

                            Text {
                                text: parent.parent.parent.currentTab === 0 ? "Overview" :
                                       parent.parent.parent.currentTab === 1 ? "Features" : "Pricing"
                                font.family: "Roboto"
                                font.pixelSize: 24
                                font.weight: Font.Medium
                                color: Su.ChiTheme.colors.onSurface
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }

                            Text {
                                text: parent.parent.parent.currentTab === 0 ?
                                      "Welcome to the overview section. Click on the tabs above to see different content." :
                                      parent.parent.parent.currentTab === 1 ?
                                      "Explore our amazing features designed to help you succeed." :
                                      "Choose a plan that fits your needs. We offer flexible pricing options."
                                font.family: "Roboto"
                                font.pixelSize: 14
                                color: Su.ChiTheme.colors.onSurfaceVariant
                                wrapMode: Text.WordWrap
                                width: parent.width
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }
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
                    text: "Tabs with Different Lengths"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Column {
                    width: parent.width
                    spacing: 20

                    Su.Tabs {
                        width: 600
                        currentIndex: 0

                        Su.Tab { text: "Short" }
                        Su.Tab { text: "A longer label here" }
                        Su.Tab { text: "Medium" }
                    }

                    Su.Tabs {
                        width: 600
                        currentIndex: 0

                        Su.Tab { text: "Tab 1" }
                        Su.Tab { text: "Second tab label" }
                        Su.Tab { text: "Third tab label text" }
                        Su.Tab { text: "Fourth" }
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
                    text: "Tabs Navigation Example"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Text {
                    text: "Click on tabs to navigate between different sections"
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: Su.ChiTheme.colors.onSurfaceVariant
                    wrapMode: Text.WordWrap
                    width: parent.width
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Column {
                    width: parent.width
                    spacing: 20

                    property int navIndex: 0

                    Su.Tabs {
                        width: 500
                        currentIndex: parent.navIndex

                        Su.Tab {
                            text: "Dashboard"
                            onClicked: parent.navIndex = 0
                        }
                        Su.Tab {
                            text: "Analytics"
                            onClicked: parent.navIndex = 1
                        }
                        Su.Tab {
                            text: "Reports"
                            onClicked: parent.navIndex = 2
                        }
                        Su.Tab {
                            text: "Settings"
                            onClicked: parent.navIndex = 3
                        }
                    }

                    Su.Card {
                        width: 500
                        height: 180
                        variant: "filled"

                        Column {
                            anchors.fill: parent
                            anchors.margins: 24
                            spacing: 8

                            Text {
                                text: parent.parent.parent.navIndex === 0 ? "📊 Dashboard" :
                                       parent.parent.parent.navIndex === 1 ? "📈 Analytics" :
                                       parent.parent.parent.navIndex === 2 ? "📄 Reports" : "⚙️ Settings"
                                font.family: "Roboto"
                                font.pixelSize: 20
                                font.weight: Font.Medium
                                color: Su.ChiTheme.colors.onSurface
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }

                            Text {
                                text: "This is the content area for the selected tab."
                                font.family: "Roboto"
                                font.pixelSize: 14
                                color: Su.ChiTheme.colors.onSurfaceVariant
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }
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
                    text: "Tab Positioning Examples"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Column {
                    width: parent.width
                    spacing: 30

                    Text {
                        text: "Primary tabs (top of page):"
                        font.family: "Roboto"
                        font.pixelSize: 16
                        font.weight: Font.Medium
                        color: Su.ChiTheme.colors.onSurface
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }

                    Su.Tabs {
                        width: 500
                        currentIndex: 0

                        Su.Tab { text: "Discover" }
                        Su.Tab { text: "Trending" }
                        Su.Tab { text: "New" }
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
                    text: "Tabs with Icon Labels"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Column {
                    width: 500
                    spacing: 20

                    property int iconTab: 0

                    Su.Tabs {
                        currentIndex: parent.iconTab

                        Su.Tab {
                            text: "📁 Files"
                            onClicked: parent.iconTab = 0
                        }
                        Su.Tab {
                            text: "📋 Tasks"
                            onClicked: parent.iconTab = 1
                        }
                        Su.Tab {
                            text: "📅 Calendar"
                            onClicked: parent.iconTab = 2
                        }
                    }

                    Su.Card {
                        width: 500
                        height: 120
                        variant: "outlined"

                        Text {
                            anchors.centerIn: parent
                            text: parent.parent.iconTab === 0 ? "Files Section" :
                                   parent.parent.iconTab === 1 ? "Tasks Section" : "Calendar Section"
                            font.family: "Roboto"
                            font.pixelSize: 16
                            color: Su.ChiTheme.colors.onSurface
                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                    }
                }
            }
        }
    }
}
