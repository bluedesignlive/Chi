// library/ui/Buttons/SplitButtonShowcase.qml
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import smartui 1.0

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
                    text: "ChiOS Split Button System"
                    font.family: "Roboto"
                    font.pixelSize: 32
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground
                    anchors.verticalCenter: parent.verticalCenter

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
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

            Rectangle {
                width: parent.width
                height: 1
                color: ChiTheme.colors.outline
                opacity: 0.3
            }

            // Button Sizes
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Split Button Sizes"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                Flow {
                    width: parent.width
                    spacing: 20

                    Column {
                        spacing: 8
                        SplitButton {
                            text: "Save"
                            showLeadingIcon: true
                            leadingIcon: "✓"
                            size: "xsmall"
                            variant: "filled"
                            onLeadingClicked: console.log("XSmall leading")
                            onTrailingClicked: console.log("XSmall trailing")
                        }
                        Text {
                            text: "XSmall (32px)"
                            font.pixelSize: 11
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        SplitButton {
                            text: "Send"
                            showLeadingIcon: true
                            leadingIcon: "↗"
                            size: "small"
                            variant: "filled"
                            onLeadingClicked: console.log("Small leading")
                            onTrailingClicked: console.log("Small trailing")
                        }
                        Text {
                            text: "Small (40px)"
                            font.pixelSize: 11
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        SplitButton {
                            text: "Export"
                            showLeadingIcon: true
                            leadingIcon: "⬇"
                            size: "medium"
                            variant: "filled"
                            onLeadingClicked: console.log("Medium leading")
                            onTrailingClicked: console.log("Medium trailing")
                        }
                        Text {
                            text: "Medium (56px)"
                            font.pixelSize: 11
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        SplitButton {
                            text: "Share"
                            showLeadingIcon: true
                            leadingIcon: "↗"
                            size: "large"
                            variant: "filled"
                            onLeadingClicked: console.log("Large leading")
                            onTrailingClicked: console.log("Large trailing")
                        }
                        Text {
                            text: "Large (96px)"
                            font.pixelSize: 11
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        SplitButton {
                            text: "Action"
                            showLeadingIcon: true
                            leadingIcon: "★"
                            size: "xlarge"
                            variant: "filled"
                            onLeadingClicked: console.log("XLarge leading")
                            onTrailingClicked: console.log("XLarge trailing")
                        }
                        Text {
                            text: "XLarge (136px)"
                            font.pixelSize: 11
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
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

            // Button Variants
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Split Button Variants"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                Flow {
                    width: parent.width
                    spacing: 20

                    Column {
                        spacing: 8
                        SplitButton {
                            text: "Filled"
                            showLeadingIcon: true
                            leadingIcon: "✓"
                            variant: "filled"
                        }
                        Text {
                            text: "Filled"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        SplitButton {
                            text: "Tonal"
                            showLeadingIcon: true
                            leadingIcon: "✓"
                            variant: "tonal"
                        }
                        Text {
                            text: "Tonal"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        SplitButton {
                            text: "Outlined"
                            showLeadingIcon: true
                            leadingIcon: "✓"
                            variant: "outlined"
                        }
                        Text {
                            text: "Outlined"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        SplitButton {
                            text: "Elevated"
                            showLeadingIcon: true
                            leadingIcon: "✓"
                            variant: "elevated"
                        }
                        Text {
                            text: "Elevated"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        SplitButton {
                            text: "Disabled"
                            showLeadingIcon: true
                            leadingIcon: "✓"
                            variant: "filled"
                            enabled: false
                        }
                        Text {
                            text: "Disabled"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
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

            // Interactive Demo
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Interactive Demo"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                Text {
                    text: "Click the dropdown arrow to toggle selected state"
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: ChiTheme.colors.onSurfaceVariant

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                Row {
                    spacing: 20

                    SplitButton {
                        text: "Download"
                        showLeadingIcon: true
                        leadingIcon: "⬇"
                        size: "medium"
                        variant: "filled"
                        onLeadingClicked: statusText.text = "Downloading..."
                        onTrailingClicked: statusText.text = trailingSelected ? "Menu opened" : "Menu closed"
                    }

                    SplitButton {
                        text: "Share"
                        showLeadingIcon: true
                        leadingIcon: "↗"
                        size: "medium"
                        variant: "tonal"
                        onLeadingClicked: statusText.text = "Sharing..."
                        onTrailingClicked: statusText.text = trailingSelected ? "Options shown" : "Options hidden"
                    }
                }

                Text {
                    id: statusText
                    text: "Try clicking the buttons →"
                    font.family: "Roboto"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    color: ChiTheme.colors.primary

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }
            }
        }
    }
}
