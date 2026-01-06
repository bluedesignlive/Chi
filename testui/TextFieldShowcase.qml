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
                    text: "SmartUI TextField System"
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
                text: "Text input fields with floating labels, icons, validation states, and multiple variants."
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
                    text: "Filled TextField Variants"
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
                        Su.TextField {
                            variant: "filled"
                            placeholderText: "Placeholder text"
                            width: 300
                        }
                        Text {
                            text: "With placeholder"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.TextField {
                            variant: "filled"
                            label: "Label"
                            placeholderText: "Enter text"
                            width: 300
                        }
                        Text {
                            text: "With label"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.TextField {
                            variant: "filled"
                            label: "With value"
                            text: "Sample text"
                            width: 300
                        }
                        Text {
                            text: "With value"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.TextField {
                            variant: "filled"
                            label: "With supporting text"
                            placeholderText: "Enter text"
                            supportingText: "This is helper text"
                            width: 300
                        }
                        Text {
                            text: "With supporting text"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.TextField {
                            variant: "filled"
                            label: "With error"
                            text: "Invalid input"
                            error: true
                            errorText: "This field is required"
                            width: 300
                        }
                        Text {
                            text: "Error state"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.TextField {
                            variant: "filled"
                            label: "Disabled"
                            placeholderText: "Cannot edit"
                            enabled: false
                            width: 300
                        }
                        Text {
                            text: "Disabled"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.TextField {
                            variant: "filled"
                            label: "Read only"
                            text: "Cannot modify"
                            readOnly: true
                            width: 300
                        }
                        Text {
                            text: "Read only"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.TextField {
                            variant: "filled"
                            label: "Password"
                            placeholderText: "Enter password"
                            password: true
                            showPasswordToggle: true
                            width: 300
                        }
                        Text {
                            text: "Password field"
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
                    text: "Outlined TextField Variants"
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
                        Su.TextField {
                            variant: "outlined"
                            placeholderText: "Placeholder text"
                            width: 300
                        }
                        Text {
                            text: "With placeholder"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.TextField {
                            variant: "outlined"
                            label: "With label"
                            placeholderText: "Enter text"
                            width: 300
                        }
                        Text {
                            text: "With label"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.TextField {
                            variant: "outlined"
                            label: "With value"
                            text: "Sample text"
                            width: 300
                        }
                        Text {
                            text: "With value"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.TextField {
                            variant: "outlined"
                            label: "Error state"
                            text: "Invalid"
                            error: true
                            errorText: "Invalid format"
                            width: 300
                        }
                        Text {
                            text: "Error state"
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
                    text: "TextField Sizes"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Column {
                    spacing: 20
                    width: 400

                    Column {
                        spacing: 8
                        Su.TextField {
                            variant: "filled"
                            label: "Small TextField"
                            placeholderText: "Enter text"
                            size: "small"
                            width: 300
                        }
                        Text {
                            text: "Small (48px height)"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.TextField {
                            variant: "filled"
                            label: "Medium TextField"
                            placeholderText: "Enter text"
                            size: "medium"
                            width: 300
                        }
                        Text {
                            text: "Medium (56px height)"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.TextField {
                            variant: "filled"
                            label: "Large TextField"
                            placeholderText: "Enter text"
                            size: "large"
                            width: 300
                        }
                        Text {
                            text: "Large (64px height)"
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
                    text: "TextField with Icons"
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
                        Su.TextField {
                            variant: "filled"
                            label: "With leading icon"
                            placeholderText: "Search"
                            leadingIcon: "🔍"
                            width: 300
                        }
                        Text {
                            text: "Leading icon"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.TextField {
                            variant: "filled"
                            label: "With trailing icon"
                            placeholderText: "Clear text"
                            trailingIcon: "✕"
                            width: 300
                        }
                        Text {
                            text: "Trailing icon"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.TextField {
                            variant: "filled"
                            label: "With both icons"
                            placeholderText: "Search item"
                            leadingIcon: "🔍"
                            trailingIcon: "📅"
                            width: 300
                        }
                        Text {
                            text: "Both icons"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.TextField {
                            variant: "outlined"
                            label: "Outlined with icons"
                            placeholderText: "Email"
                            leadingIcon: "✉"
                            trailingIcon: "✓"
                            width: 300
                        }
                        Text {
                            text: "Outlined variant"
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
                    text: "TextField Character Count & Max Length"
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
                        Su.TextField {
                            variant: "filled"
                            label: "With character count"
                            placeholderText: "Type something"
                            text: "Hello"
                            showCharacterCount: true
                            width: 300
                        }
                        Text {
                            text: "Character count visible"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.TextField {
                            variant: "filled"
                            label: "With max length"
                            placeholderText: "Max 10 characters"
                            text: "1234567890"
                            maxLength: 10
                            showCharacterCount: true
                            width: 300
                        }
                        Text {
                            text: "Max length: 10"
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
                    text: "TextField Shapes"
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
                        Su.TextField {
                            variant: "filled"
                            label: "Default shape"
                            placeholderText: "Enter text"
                            shape: "default"
                            width: 300
                        }
                        Text {
                            text: "Default corners"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.TextField {
                            variant: "filled"
                            label: "Rounded shape"
                            placeholderText: "Enter text"
                            shape: "rounded"
                            width: 300
                        }
                        Text {
                            text: "Rounded corners"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.TextField {
                            variant: "outlined"
                            label: "Outlined default"
                            placeholderText: "Enter text"
                            shape: "default"
                            width: 300
                        }
                        Text {
                            text: "Outlined default"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.TextField {
                            variant: "outlined"
                            label: "Outlined rounded"
                            placeholderText: "Enter text"
                            shape: "rounded"
                            width: 300
                        }
                        Text {
                            text: "Outlined rounded"
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
                    text: "TextField Interactive States"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Text {
                    text: "Try interacting with these fields to see hover, focus, and pressed states"
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: Su.ChiTheme.colors.onSurfaceVariant
                    wrapMode: Text.WordWrap
                    width: parent.width
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Column {
                    spacing: 20
                    width: 400

                    Su.TextField {
                        variant: "filled"
                        label: "Hover me"
                        placeholderText: "Try hovering"
                        width: 350
                    }

                    Su.TextField {
                        variant: "filled"
                        label: "Focus me"
                        placeholderText: "Click to focus"
                        width: 350
                    }

                    Su.TextField {
                        variant: "outlined"
                        label: "Outlined hover"
                        placeholderText: "Try hovering"
                        width: 350
                    }

                    Su.TextField {
                        variant: "outlined"
                        label: "Outlined focus"
                        placeholderText: "Click to focus"
                        width: 350
                    }
                }
            }
        }
    }
}
