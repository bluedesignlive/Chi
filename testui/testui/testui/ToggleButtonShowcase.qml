// library/ui/Buttons/ToggleButtonShowcase.qml - VARIETY SHOWCASE
import QtQuick
import QtQuick.Controls.Basic
import SmartUIBeta 1.0

Rectangle {
    width: 1200
    height: 800
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
                    text: "Toggle Buttons"
                    font.family: "Roboto"
                    font.pixelSize: 32
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground
                    anchors.verticalCenter: parent.verticalCenter

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
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
                text: "For binary selections like Save or Favorite. Click to toggle between states."
                font.pixelSize: 14
                color: ChiTheme.colors.onSurfaceVariant
                Behavior on color { ColorAnimation { duration: 200 } }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: ChiTheme.colors.outline
                opacity: 0.3
            }

            // FILLED TOGGLES
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Filled Toggle Buttons"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 3
                    columnSpacing: 40
                    rowSpacing: 20

                    Column {
                        spacing: 8
                        Text {
                            text: "With Icon (Round)"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: ChiTheme.colors.onBackground
                        }
                        ToggleButton {
                            text: "Favorite"
                            variant: "filled"
                            shape: "round"
                            showIcon: true
                            icon: "☆"
                            selectedIcon: "★"
                            onToggled: (sel) => console.log("Filled Round toggled:", sel)
                        }
                    }

                    Column {
                        spacing: 8
                        Text {
                            text: "No Icon (Round)"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: ChiTheme.colors.onBackground
                        }
                        ToggleButton {
                            text: "Subscribe"
                            variant: "filled"
                            shape: "round"
                            onToggled: (sel) => console.log("Filled Round no-icon toggled:", sel)
                        }
                    }

                    Column {
                        spacing: 8
                        Text {
                            text: "With Icon (Square)"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: ChiTheme.colors.onBackground
                        }
                        ToggleButton {
                            text: "Like"
                            variant: "filled"
                            shape: "square"
                            showIcon: true
                            icon: "♡"
                            selectedIcon: "♥"
                            onToggled: (sel) => console.log("Filled Square toggled:", sel)
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: ChiTheme.colors.outline
                opacity: 0.3
            }

            // ELEVATED TOGGLES
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Elevated Toggle Buttons"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 3
                    columnSpacing: 40
                    rowSpacing: 20

                    Column {
                        spacing: 8
                        Text {
                            text: "With Icon (Round)"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: ChiTheme.colors.onBackground
                        }
                        ToggleButton {
                            text: "Follow"
                            variant: "elevated"
                            shape: "round"
                            showIcon: true
                            icon: "+"
                            selectedIcon: "✓"
                            onToggled: (sel) => console.log("Elevated Round toggled:", sel)
                        }
                    }

                    Column {
                        spacing: 8
                        Text {
                            text: "No Icon (Square)"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: ChiTheme.colors.onBackground
                        }
                        ToggleButton {
                            text: "Active"
                            variant: "elevated"
                            shape: "square"
                            onToggled: (sel) => console.log("Elevated Square no-icon toggled:", sel)
                        }
                    }

                    Column {
                        spacing: 8
                        Text {
                            text: "With Icon (Square)"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: ChiTheme.colors.onBackground
                        }
                        ToggleButton {
                            text: "Pin"
                            variant: "elevated"
                            shape: "square"
                            showIcon: true
                            icon: "📌"
                            selectedIcon: "📍"
                            onToggled: (sel) => console.log("Elevated Square toggled:", sel)
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: ChiTheme.colors.outline
                opacity: 0.3
            }

            // TONAL TOGGLES
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Tonal Toggle Buttons"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 3
                    columnSpacing: 40
                    rowSpacing: 20

                    Column {
                        spacing: 8
                        Text {
                            text: "No Icon (Round)"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: ChiTheme.colors.onBackground
                        }
                        ToggleButton {
                            text: "Enable"
                            variant: "tonal"
                            shape: "round"
                            onToggled: (sel) => console.log("Tonal Round no-icon toggled:", sel)
                        }
                    }

                    Column {
                        spacing: 8
                        Text {
                            text: "With Icon (Round)"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: ChiTheme.colors.onBackground
                        }
                        ToggleButton {
                            text: "Mute"
                            variant: "tonal"
                            shape: "round"
                            showIcon: true
                            icon: "🔊"
                            selectedIcon: "🔇"
                            onToggled: (sel) => console.log("Tonal Round toggled:", sel)
                        }
                    }

                    Column {
                        spacing: 8
                        Text {
                            text: "With Icon (Square)"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: ChiTheme.colors.onBackground
                        }
                        ToggleButton {
                            text: "Lock"
                            variant: "tonal"
                            shape: "square"
                            showIcon: true
                            icon: "🔓"
                            selectedIcon: "🔒"
                            onToggled: (sel) => console.log("Tonal Square toggled:", sel)
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: ChiTheme.colors.outline
                opacity: 0.3
            }

            // OUTLINED TOGGLES
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Outlined Toggle Buttons"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 3
                    columnSpacing: 40
                    rowSpacing: 20

                    Column {
                        spacing: 8
                        Text {
                            text: "With Icon (Round)"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: ChiTheme.colors.onBackground
                        }
                        ToggleButton {
                            text: "Notify"
                            variant: "outlined"
                            shape: "round"
                            showIcon: true
                            icon: "🔔"
                            selectedIcon: "🔕"
                            onToggled: (sel) => console.log("Outlined Round toggled:", sel)
                        }
                    }

                    Column {
                        spacing: 8
                        Text {
                            text: "With Icon (Square)"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: ChiTheme.colors.onBackground
                        }
                        ToggleButton {
                            text: "Save"
                            variant: "outlined"
                            shape: "square"
                            showIcon: true
                            icon: "🏷"
                            selectedIcon: "🔖"
                            onToggled: (sel) => console.log("Outlined Square toggled:", sel)
                        }
                    }

                    Column {
                        spacing: 8
                        Text {
                            text: "No Icon (Square)"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: ChiTheme.colors.onBackground
                        }
                        ToggleButton {
                            text: "Archive"
                            variant: "outlined"
                            shape: "square"
                            onToggled: (sel) => console.log("Outlined Square no-icon toggled:", sel)
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: ChiTheme.colors.outline
                opacity: 0.3
            }

            // SIZES DEMO
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Toggle Button Sizes"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Flow {
                    width: parent.width
                    spacing: 20

                    ToggleButton {
                        text: "XS"
                        size: "xsmall"
                        variant: "filled"
                        showIcon: true
                        icon: "☆"
                        selectedIcon: "★"
                    }

                    ToggleButton {
                        text: "Small"
                        size: "small"
                        variant: "filled"
                        showIcon: true
                        icon: "☆"
                        selectedIcon: "★"
                    }

                    ToggleButton {
                        text: "Medium"
                        size: "medium"
                        variant: "filled"
                        showIcon: true
                        icon: "☆"
                        selectedIcon: "★"
                    }

                    ToggleButton {
                        text: "Large"
                        size: "large"
                        variant: "filled"
                        showIcon: true
                        icon: "☆"
                        selectedIcon: "★"
                    }

                    ToggleButton {
                        text: "XL"
                        size: "xlarge"
                        variant: "filled"
                        showIcon: true
                        icon: "☆"
                        selectedIcon: "★"
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: ChiTheme.colors.outline
                opacity: 0.3
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

                    ToggleButton {
                        text: "Wifi"
                        variant: "filled"
                        shape: "square"
                        showIcon: true
                        icon: "📶"
                        selectedIcon: "📡"
                    }

                    ToggleButton {
                        text: "Bluetooth"
                        variant: "tonal"
                        shape: "square"
                        showIcon: true
                        icon: "🔵"
                        selectedIcon: "🟦"
                    }

                    ToggleButton {
                        text: "Location"
                        variant: "outlined"
                        shape: "round"
                        showIcon: true
                        icon: "📍"
                        selectedIcon: "🎯"
                    }

                    ToggleButton {
                        text: "Auto-play"
                        variant: "elevated"
                        shape: "round"
                    }

                    ToggleButton {
                        text: "HD"
                        variant: "filled"
                        size: "xsmall"
                        shape: "square"
                    }

                    ToggleButton {
                        text: "4K"
                        variant: "tonal"
                        size: "xsmall"
                        shape: "square"
                    }
                }
            }
        }
    }
}
