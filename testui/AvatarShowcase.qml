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
                    text: "SmartUI Avatar System"
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
                text: "User profile images with fallback icons, text, and optional online status indicators."
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
                    text: "Avatar Sizes"
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
                        Su.Avatar {
                            size: "xsmall"
                            text: "AB"
                        }
                        Text {
                            text: "XSmall (24px)"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Avatar {
                            size: "small"
                            text: "AB"
                        }
                        Text {
                            text: "Small (32px)"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Avatar {
                            size: "medium"
                            text: "AB"
                        }
                        Text {
                            text: "Medium (40px)"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Avatar {
                            size: "large"
                            text: "AB"
                        }
                        Text {
                            text: "Large (56px)"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Avatar {
                            size: "xlarge"
                            text: "AB"
                        }
                        Text {
                            text: "XLarge (96px)"
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
                    text: "Avatar Content Types"
                font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Row {
                    spacing: 50
                    width: parent.width

                    Column {
                        spacing: 8
                        Su.Avatar {
                            size: "large"
                            text: "JD"
                        }
                        Text {
                            text: "Text fallback"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Avatar {
                            size: "large"
                            icon: "👤"
                        }
                        Text {
                            text: "Icon fallback"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Avatar {
                            size: "large"
                            text: "📷"
                        }
                        Text {
                            text: "Emoji as icon"
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
                    text: "Avatar with Badges"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Row {
                    spacing: 50
                    width: parent.width

                    Column {
                        spacing: 8
                        Su.Avatar {
                            size: "large"
                            text: "AB"
                            showBadge: true
                            badgeIcon: "✓"
                        }
                        Text {
                            text: "With badge icon"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Avatar {
                            size: "large"
                            text: "AB"
                            showBadge: true
                        }
                        Text {
                            text: "With badge dot"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Avatar {
                            size: "large"
                            text: "AB"
                            showBadge: true
                            badgeIcon: "🔔"
                        }
                        Text {
                            text: "With notification badge"
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
                    text: "Avatar with Online Status"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Row {
                    spacing: 50
                    width: parent.width

                    Column {
                        spacing: 8
                        Su.Avatar {
                            size: "large"
                            text: "JD"
                            online: false
                        }
                        Text {
                            text: "Offline"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Avatar {
                            size: "large"
                            text: "JD"
                            online: true
                        }
                        Text {
                            text: "Online"
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
                    text: "Avatar Sizes with Icons"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Row {
                    spacing: 35
                    width: parent.width

                    Column {
                        spacing: 8
                        Su.Avatar {
                            size: "xsmall"
                            icon: "👤"
                        }
                        Text {
                            text: "XS"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Avatar {
                            size: "small"
                            icon: "👤"
                        }
                        Text {
                            text: "S"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Avatar {
                            size: "medium"
                            icon: "👤"
                        }
                        Text {
                            text: "M"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Avatar {
                            size: "large"
                            icon: "👤"
                        }
                        Text {
                            text: "L"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Avatar {
                            size: "xlarge"
                            icon: "👤"
                        }
                        Text {
                            text: "XL"
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
                    text: "Avatar Usage Examples"
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

                    Su.Card {
                        width: 350
                        height: 120
                        variant: "elevated"

                        Row {
                            anchors.centerIn: parent
                            spacing: 16

                            Su.Avatar {
                                size: "large"
                                text: "JD"
                            }

                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter

                                Text {
                                    text: "John Doe"
                                    font.family: "Roboto"
                                    font.pixelSize: 18
                                    font.weight: Font.Medium
                                    color: Su.ChiTheme.colors.onSurface
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }

                                Text {
                                    text: "Software Engineer"
                                    font.family: "Roboto"
                                    font.pixelSize: 14
                                    color: Su.ChiTheme.colors.onSurfaceVariant
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }
                            }
                        }
                    }

                    Su.Card {
                        width: 350
                        height: 120
                        variant: "filled"

                        Row {
                            anchors.centerIn: parent
                            spacing: 16

                            Su.Avatar {
                                size: "large"
                                text: "AB"
                                online: true
                            }

                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter

                                Text {
                                    text: "Alice Brown"
                                    font.family: "Roboto"
                                    font.pixelSize: 18
                                    font.weight: Font.Medium
                                    color: Su.ChiTheme.colors.onSurface
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }

                                Text {
                                    text: "Online now"
                                    font.family: "Roboto"
                                    font.pixelSize: 14
                                    color: Su.ChiTheme.colors.primary
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }
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
                    text: "Avatar with Badges at Different Sizes"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Row {
                    spacing: 30
                    width: parent.width

                    Column {
                        spacing: 8
                        Su.Avatar {
                            size: "small"
                            text: "AB"
                            showBadge: true
                            badgeIcon: "3"
                        }
                        Text {
                            text: "Small with count"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Avatar {
                            size: "medium"
                            text: "AB"
                            showBadge: true
                            badgeIcon: "5"
                        }
                        Text {
                            text: "Medium with count"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Avatar {
                            size: "large"
                            text: "AB"
                            showBadge: true
                            badgeIcon: "12"
                        }
                        Text {
                            text: "Large with count"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
        }
    }
}
