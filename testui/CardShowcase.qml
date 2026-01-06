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
                    text: "SmartUI Card System"
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
                text: "Container components for displaying related content with elevation and optional click interaction."
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
                    text: "Card Variants"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 3
                    columnSpacing: 30
                    rowSpacing: 30

                    Column {
                        spacing: 8
                        Su.Card {
                            width: 280
                            height: 160
                            variant: "elevated"

                            Column {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 8

                                Text {
                                    text: "Elevated Card"
                                    font.family: "Roboto"
                                    font.pixelSize: 18
                                    font.weight: Font.Medium
                                    color: Su.ChiTheme.colors.onSurface
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }

                                Text {
                                    text: "With shadow elevation for depth"
                                    font.family: "Roboto"
                                    font.pixelSize: 14
                                    color: Su.ChiTheme.colors.onSurfaceVariant
                                    wrapMode: Text.WordWrap
                                    width: parent.width
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }
                            }
                        }
                        Text {
                            text: "Elevated variant"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Card {
                            width: 280
                            height: 160
                            variant: "filled"

                            Column {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 8

                                Text {
                                    text: "Filled Card"
                                    font.family: "Roboto"
                                    font.pixelSize: 18
                                    font.weight: Font.Medium
                                    color: Su.ChiTheme.colors.onSurface
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }

                                Text {
                                    text: "Filled background without elevation"
                                    font.family: "Roboto"
                                    font.pixelSize: 14
                                    color: Su.ChiTheme.colors.onSurfaceVariant
                                    wrapMode: Text.WordWrap
                                    width: parent.width
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }
                            }
                        }
                        Text {
                            text: "Filled variant"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Card {
                            width: 280
                            height: 160
                            variant: "outlined"

                            Column {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 8

                                Text {
                                    text: "Outlined Card"
                                    font.family: "Roboto"
                                    font.pixelSize: 18
                                    font.weight: Font.Medium
                                    color: Su.ChiTheme.colors.onSurface
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }

                                Text {
                                    text: "With border outline"
                                    font.family: "Roboto"
                                    font.pixelSize: 14
                                    color: Su.ChiTheme.colors.onSurfaceVariant
                                    wrapMode: Text.WordWrap
                                    width: parent.width
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }
                            }
                        }
                        Text {
                            text: "Outlined variant"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
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
                    text: "Clickable Cards"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 3
                    columnSpacing: 30
                    rowSpacing: 30

                    Column {
                        spacing: 8
                        Su.Card {
                            width: 280
                            height: 140
                            variant: "elevated"
                            clickable: true

                            Column {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 8

                                Text {
                                    text: "Clickable"
                                    font.family: "Roboto"
                                    font.pixelSize: 18
                                    font.weight: Font.Medium
                                    color: Su.ChiTheme.colors.onSurface
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }

                                Text {
                                    text: "Try hovering and clicking"
                                    font.family: "Roboto"
                                    font.pixelSize: 14
                                    color: Su.ChiTheme.colors.onSurfaceVariant
                                    wrapMode: Text.WordWrap
                                    width: parent.width
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }
                            }
                        }
                        Text {
                            text: "Elevated clickable"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Card {
                            width: 280
                            height: 140
                            variant: "filled"
                            clickable: true

                            Column {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 8

                                Text {
                                    text: "Clickable Filled"
                                    font.family: "Roboto"
                                    font.pixelSize: 18
                                    font.weight: Font.Medium
                                    color: Su.ChiTheme.colors.onSurface
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }

                                Text {
                                    text: "Interactive filled card"
                                    font.family: "Roboto"
                                    font.pixelSize: 14
                                    color: Su.ChiTheme.colors.onSurfaceVariant
                                    wrapMode: Text.WordWrap
                                    width: parent.width
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }
                            }
                        }
                        Text {
                            text: "Filled clickable"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Card {
                            width: 280
                            height: 140
                            variant: "outlined"
                            clickable: true

                            Column {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 8

                                Text {
                                    text: "Clickable Outlined"
                                    font.family: "Roboto"
                                    font.pixelSize: 18
                                    font.weight: Font.Medium
                                    color: Su.ChiTheme.colors.onSurface
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }

                                Text {
                                    text: "Interactive outlined card"
                                    font.family: "Roboto"
                                    font.pixelSize: 14
                                    color: Su.ChiTheme.colors.onSurfaceVariant
                                    wrapMode: Text.WordWrap
                                    width: parent.width
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }
                            }
                        }
                        Text {
                            text: "Outlined clickable"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
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
                    text: "Card States"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 2
                    columnSpacing: 40
                    rowSpacing: 30

                    Column {
                        spacing: 8
                        Su.Card {
                            width: 350
                            height: 120
                            variant: "elevated"

                            Text {
                                anchors.centerIn: parent
                                text: "Enabled"
                                font.family: "Roboto"
                                font.pixelSize: 16
                                color: Su.ChiTheme.colors.onSurface
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }
                        }
                        Text {
                            text: "Enabled card"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Card {
                            width: 350
                            height: 120
                            variant: "elevated"
                            enabled: false

                            Text {
                                anchors.centerIn: parent
                                text: "Disabled"
                                font.family: "Roboto"
                                font.pixelSize: 16
                                color: Su.ChiTheme.colors.onSurface
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }
                        }
                        Text {
                            text: "Disabled card"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
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
                    text: "Card Custom Content"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 2
                    columnSpacing: 40
                    rowSpacing: 30

                    Column {
                        spacing: 8
                        Su.Card {
                            width: 350
                            height: 180
                            variant: "elevated"
                            contentPadding: 20

                            Column {
                                anchors.fill: parent
                                spacing: 12

                                Text {
                                    text: "Custom Padding"
                                    font.family: "Roboto"
                                    font.pixelSize: 20
                                    font.weight: Font.Medium
                                    color: Su.ChiTheme.colors.onSurface
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }

                                Text {
                                    text: "This card has custom content padding of 20px"
                                    font.family: "Roboto"
                                    font.pixelSize: 14
                                    color: Su.ChiTheme.colors.onSurfaceVariant
                                    wrapMode: Text.WordWrap
                                    width: parent.width
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }

                                Item { Layout.fillHeight: true }
                            }
                        }
                        Text {
                            text: "With custom padding"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Card {
                            width: 350
                            height: 180
                            variant: "filled"
                            clickable: true

                            Column {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 12

                                Row {
                                    spacing: 12

                                    Su.Avatar {
                                        size: "medium"
                                        text: "AB"
                                    }

                                    Column {
                                        spacing: 4

                                        Text {
                                            text: "User Card"
                                            font.family: "Roboto"
                                            font.pixelSize: 18
                                            font.weight: Font.Medium
                                            color: Su.ChiTheme.colors.onSurface
                                            Behavior on color { ColorAnimation { duration: 200 } }
                                        }

                                        Text {
                                            text: "user@example.com"
                                            font.family: "Roboto"
                                            font.pixelSize: 14
                                            color: Su.ChiTheme.colors.onSurfaceVariant
                                            Behavior on color { ColorAnimation { duration: 200 } }
                                        }
                                    }
                                }

                                Item { Layout.fillHeight: true }
                            }
                        }
                        Text {
                            text: "With avatar content"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
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
                    text: "Interactive Card Examples"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Text {
                    text: "Hover over cards to see interactive states"
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

                    Su.Card {
                        width: 260
                        height: 140
                        variant: "elevated"
                        clickable: true

                        Column {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 8

                            Text {
                                text: "📁 Project Alpha"
                                font.family: "Roboto"
                                font.pixelSize: 16
                                font.weight: Font.Medium
                                color: Su.ChiTheme.colors.onSurface
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }

                            Text {
                                text: "Last modified: Today"
                                font.family: "Roboto"
                                font.pixelSize: 12
                                color: Su.ChiTheme.colors.onSurfaceVariant
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }
                        }
                    }

                    Su.Card {
                        width: 260
                        height: 140
                        variant: "filled"
                        clickable: true

                        Column {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 8

                            Text {
                                text: "📊 Analytics"
                                font.family: "Roboto"
                                font.pixelSize: 16
                                font.weight: Font.Medium
                                color: Su.ChiTheme.colors.onSurface
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }

                            Text {
                                text: "View your data insights"
                                font.family: "Roboto"
                                font.pixelSize: 12
                                color: Su.ChiTheme.colors.onSurfaceVariant
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }
                        }
                    }

                    Su.Card {
                        width: 260
                        height: 140
                        variant: "outlined"
                        clickable: true

                        Column {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 8

                            Text {
                                text: "⚙️ Settings"
                                font.family: "Roboto"
                                font.pixelSize: 16
                                font.weight: Font.Medium
                                color: Su.ChiTheme.colors.onSurface
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }

                            Text {
                                text: "Configure your app"
                                font.family: "Roboto"
                                font.pixelSize: 12
                                color: Su.ChiTheme.colors.onSurfaceVariant
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }
                        }
                    }
                }
            }
        }
    }
}
