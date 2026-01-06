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
                    text: "SmartUI Badge System"
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
                text: "Status indicators and notification counters displayed as small overlays on components."
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
                    text: "Badge Sizes"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Row {
                    spacing: 40
                    width: parent.width

                    Column {
                        spacing: 8
                        Su.Badge {
                            size: "small"
                        }
                        Text {
                            text: "Small (dot)"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Badge {
                            size: "medium"
                            text: "5"
                        }
                        Text {
                            text: "Medium (16px)"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Badge {
                            size: "large"
                            text: "99+"
                        }
                        Text {
                            text: "Large (20px)"
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
                    text: "Badge on Components"
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
                        Su.Badge {
                            size: "medium"
                            text: "3"

                            Su.Button {
                                text: "Messages"
                                variant: "elevated"
                                width: 120
                            }
                        }
                        Text {
                            text: "On button"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Badge {
                            size: "small"

                            Su.IconButton {
                                icon: "🔔"
                                variant: "filled"
                            }
                        }
                        Text {
                            text: "On icon button"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Badge {
                            size: "medium"
                            text: "12"

                            Su.Card {
                                width: 120
                                height: 80
                                variant: "elevated"

                                Text {
                                    anchors.centerIn: parent
                                    text: "Card"
                                    font.family: "Roboto"
                                    font.pixelSize: 14
                                    color: Su.ChiTheme.colors.onSurface
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }
                            }
                        }
                        Text {
                            text: "On card"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Badge {
                            size: "small"

                            Su.Avatar {
                                size: "large"
                                text: "AB"
                            }
                        }
                        Text {
                            text: "On avatar"
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
                    text: "Badge with Different Counts"
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
                        Su.Badge {
                            size: "medium"
                            text: "1"

                            Su.Button {
                                text: "Notifications"
                                variant: "outlined"
                            }
                        }
                        Text {
                            text: "Count: 1"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Badge {
                            size: "medium"
                            text: "5"

                            Su.Button {
                                text: "Messages"
                                variant: "outlined"
                            }
                        }
                        Text {
                            text: "Count: 5"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Badge {
                            size: "medium"
                            text: "99"

                            Su.Button {
                                text: "Updates"
                                variant: "outlined"
                            }
                        }
                        Text {
                            text: "Count: 99"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Badge {
                            size: "medium"
                            text: "999"
                            maxCount: 99

                            Su.Button {
                                text: "Inbox"
                                variant: "outlined"
                            }
                        }
                        Text {
                            text: "Count: 999 (shows 99+)"
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
                    text: "Badge Visibility Toggle"
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
                        Su.Badge {
                            size: "medium"
                            text: "3"
                            showBadge: true

                            Su.Button {
                                text: "Visible"
                                variant: "filled"
                            }
                        }
                        Text {
                            text: "showBadge: true"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Badge {
                            size: "medium"
                            text: "5"
                            showBadge: false

                            Su.Button {
                                text: "Hidden"
                                variant: "filled"
                            }
                        }
                        Text {
                            text: "showBadge: false"
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
                    text: "Dot Badge on Different Components"
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
                        Su.Badge {
                            size: "small"

                            Su.IconButton {
                                icon: "🔔"
                                variant: "filled"
                            }
                        }
                        Text {
                            text: "Notification bell"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Badge {
                            size: "small"

                            Su.IconButton {
                                icon: "📧"
                                variant: "tonal"
                            }
                        }
                        Text {
                            text: "Email icon"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Badge {
                            size: "small"

                            Su.IconButton {
                                icon: "💬"
                                variant: "outlined"
                            }
                        }
                        Text {
                            text: "Chat icon"
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
                    text: "Badge with Custom Max Count"
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
                        Su.Badge {
                            size: "medium"
                            text: "150"
                            maxCount: 100

                            Su.Button {
                                text: "Max: 100"
                                variant: "elevated"
                            }
                        }
                        Text {
                            text: "Shows 100+"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Badge {
                            size: "medium"
                            text: "50"
                            maxCount: 100

                            Su.Button {
                                text: "Max: 100"
                                variant: "elevated"
                            }
                        }
                        Text {
                            text: "Shows 50"
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
                    text: "Badge on Navigation Components"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Su.Card {
                    width: 300
                    height: 200
                    variant: "elevated"

                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 16

                        Row {
                            spacing: 16

                            Column {
                                spacing: 8
                                Su.Badge {
                                    size: "small"

                                    Su.IconButton {
                                        icon: "🏠"
                                        variant: "tonal"
                                    }
                                }
                                Text {
                                    text: "Home"
                                    font.pixelSize: 11
                                    color: Su.ChiTheme.colors.onSurfaceVariant
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                            Column {
                                spacing: 8
                                Su.Badge {
                                    size: "small"

                                    Su.IconButton {
                                        icon: "👤"
                                        variant: "tonal"
                                    }
                                }
                                Text {
                                    text: "Profile"
                                    font.pixelSize: 11
                                    color: Su.ChiTheme.colors.onSurfaceVariant
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                            Column {
                                spacing: 8
                                Su.Badge {
                                    size: "medium"
                                    text: "5"

                                    Su.IconButton {
                                        icon: "⚙"
                                        variant: "tonal"
                                    }
                                }
                                Text {
                                    text: "Settings"
                                    font.pixelSize: 11
                                    color: Su.ChiTheme.colors.onSurfaceVariant
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
