import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import smartui 1.0

Rectangle {
    width: 1400
    height: 900
    color: ChiTheme.colors.background
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

            // Header
            Row {
                width: parent.width
                spacing: 20

                Text {
                    text: "Icon Toggle Buttons"
                    font.family: "Roboto"
                    font.pixelSize: 32
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground
                    anchors.verticalCenter: parent.verticalCenter
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Item { width: 100; height: 1 }

                Row {
                    spacing: 10
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: "☀️"
                        font.pixelSize: 20
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Switch {
                        checked: ChiTheme.isDarkMode
                        onToggled: ChiTheme.isDarkMode = !ChiTheme.isDarkMode
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
                text: "Binary icon-only controls that support emojis, text icons, and multiple sizes/widths."
                font.pixelSize: 14
                color: ChiTheme.colors.onSurfaceVariant
                wrapMode: Text.WordWrap
                Behavior on color { ColorAnimation { duration: 200 } }
            }

            // BASIC EXAMPLES
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Basic"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Row {
                    spacing: 30

                    Column {
                        spacing: 8
                        IconButtonToggle {
                            icon: "☆"
                            selectedIcon: "★"
                            size: "small"
                            widthMode: "default"
                            tooltip: "Favorite"
                            onToggled: console.log("Favorite:", selected)
                        }
                        Text {
                            text: "Star toggle"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        IconButtonToggle {
                            icon: "♡"
                            selectedIcon: "♥"
                            size: "small"
                            widthMode: "default"
                            tooltip: "Like"
                        }
                        Text {
                            text: "Heart toggle"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        IconButtonToggle {
                            icon: "☑"
                            selectedIcon: "✔"
                            size: "small"
                            widthMode: "default"
                            tooltip: "Done"
                        }
                        Text {
                            text: "Done toggle"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            // WIDTH MODES
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Width Modes (Small size)"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Row {
                    spacing: 40

                    Column {
                        spacing: 8
                        IconButtonToggle {
                            icon: "✕"
                            selectedIcon: "✓"
                            size: "small"
                            widthMode: "narrow"
                            tooltip: "Narrow close/confirm"
                        }
                        Text {
                            text: "Narrow"
                            font.pixelSize: 11
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        IconButtonToggle {
                            icon: "✕"
                            selectedIcon: "✓"
                            size: "small"
                            widthMode: "default"
                            tooltip: "Default close/confirm"
                        }
                        Text {
                            text: "Default"
                            font.pixelSize: 11
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        IconButtonToggle {
                            icon: "✕"
                            selectedIcon: "✓"
                            size: "small"
                            widthMode: "wide"
                            tooltip: "Wide close/confirm"
                        }
                        Text {
                            text: "Wide"
                            font.pixelSize: 11
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            // SIZES
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Sizes"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Flow {
                    width: parent.width
                    spacing: 20

                    Column {
                        spacing: 8
                        IconButtonToggle {
                            icon: "★"
                            selectedIcon: "⭐"
                            size: "xsmall"
                            tooltip: "XS"
                        }
                        Text {
                            text: "XSmall 32px"
                            font.pixelSize: 11
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        IconButtonToggle {
                            icon: "★"
                            selectedIcon: "⭐"
                            size: "small"
                            tooltip: "Small"
                        }
                        Text {
                            text: "Small 40px"
                            font.pixelSize: 11
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        IconButtonToggle {
                            icon: "★"
                            selectedIcon: "⭐"
                            size: "medium"
                            tooltip: "Medium"
                        }
                        Text {
                            text: "Medium 56px"
                            font.pixelSize: 11
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        IconButtonToggle {
                            icon: "★"
                            selectedIcon: "⭐"
                            size: "large"
                            tooltip: "Large"
                        }
                        Text {
                            text: "Large 96px"
                            font.pixelSize: 11
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        IconButtonToggle {
                            icon: "★"
                            selectedIcon: "⭐"
                            size: "xlarge"
                            tooltip: "XL"
                        }
                        Text {
                            text: "XLarge 136px"
                            font.pixelSize: 11
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            // PRACTICAL EXAMPLES
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Practical Examples"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Flow {
                    width: parent.width
                    spacing: 15

                    IconButtonToggle {
                        icon: "☆"
                        selectedIcon: "★"
                        size: "small"
                        tooltip: "Favorite"
                    }

                    IconButtonToggle {
                        icon: "♡"
                        selectedIcon: "♥"
                        size: "small"
                        tooltip: "Like"
                    }

                    IconButtonToggle {
                        icon: "🔔"
                        selectedIcon: "🔕"
                        size: "small"
                        tooltip: "Notifications"
                    }

                    IconButtonToggle {
                        icon: "☾"
                        selectedIcon: "☀"
                        size: "small"
                        tooltip: "Dark / Light"
                    }

                    IconButtonToggle {
                        icon: "🔊"
                        selectedIcon: "🔇"
                        size: "small"
                        tooltip: "Mute"
                    }

                    IconButtonToggle {
                        icon: "★"
                        selectedIcon: "✪"
                        size: "large"
                        widthMode: "wide"
                        tooltip: "Highlight"
                    }
                }
            }
        }
    }
}
