// library/ui/Buttons/ButtonShowcase.qml
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

            // Header with theme toggle
            Row {
                width: parent.width
                spacing: 20

                Text {
                    text: "ChiOS Button System"
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
                        id: themeSwitch
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

            // SHAPES
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Button Shapes"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                Grid {
                    columns: 2
                    columnSpacing: 40
                    rowSpacing: 20

                    Column {
                        spacing: 8
                        Button {
                            text: "Round"
                            shape: "round"
                            variant: "filled"
                            showIcon: true
                            icon: "○"
                        }
                        Text {
                            text: "Pill shape (radius: 100)"
                            font.pixelSize: 11
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Square"
                            shape: "square"
                            variant: "filled"
                            showIcon: true
                            icon: "□"
                        }
                        Text {
                            text: "Rounded corners (radius: 12)"
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

            // BUTTON SIZES
            Column {
                width: parent.width
                spacing: 30

                Text {
                    text: "Button Sizes"
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
                        Button {
                            text: "XSmall"
                            size: "xsmall"
                            variant: "filled"
                        }
                        Text {
                            text: "32px"
                            font.pixelSize: 11
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Small"
                            size: "small"
                            variant: "filled"
                        }
                        Text {
                            text: "40px"
                            font.pixelSize: 11
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Medium"
                            size: "medium"
                            variant: "filled"
                        }
                        Text {
                            text: "56px"
                            font.pixelSize: 11
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Large"
                            size: "large"
                            variant: "filled"
                        }
                        Text {
                            text: "96px"
                            font.pixelSize: 11
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "XLarge"
                            size: "xlarge"
                            variant: "filled"
                        }
                        Text {
                            text: "136px"
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

            // FILLED BUTTONS
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Filled Buttons"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                Text {
                    text: "High-emphasis buttons for important, final actions"
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: ChiTheme.colors.onSurfaceVariant
                    wrapMode: Text.WordWrap
                    width: parent.width

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                Grid {
                    columns: 5
                    spacing: 40
                    rowSpacing: 30

                    Column {
                        spacing: 8
                        Button {
                            text: "Enabled"
                            variant: "filled"
                        }
                        Text {
                            text: "Enabled"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Hovered"
                            variant: "filled"
                        }
                        Text {
                            text: "Hovered"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Focused"
                            variant: "filled"
                            focus: true
                        }
                        Text {
                            text: "Focused"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Pressed"
                            variant: "filled"
                        }
                        Text {
                            text: "Pressed"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Disabled"
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

                Row {
                    spacing: 20
                    Button {
                        text: "Save"
                        variant: "filled"
                        showIcon: true
                        icon: "✓"
                        onClicked: console.log("Save clicked")
                    }
                    Button {
                        text: "Confirm"
                        variant: "filled"
                        shape: "square"
                        onClicked: console.log("Confirm clicked")
                    }
                    Button {
                        text: "Join now"
                        variant: "filled"
                        onClicked: console.log("Join now clicked")
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: ChiTheme.colors.outline
                opacity: 0.3
            }

            // OUTLINED BUTTONS
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Outlined Buttons"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                Text {
                    text: "Medium-emphasis buttons for important, but not primary actions"
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: ChiTheme.colors.onSurfaceVariant

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                Grid {
                    columns: 5
                    spacing: 40
                    rowSpacing: 30

                    Column {
                        spacing: 8
                        Button {
                            text: "Enabled"
                            variant: "outlined"
                        }
                        Text {
                            text: "Enabled"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Hovered"
                            variant: "outlined"
                        }
                        Text {
                            text: "Hovered"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Focused"
                            variant: "outlined"
                            focus: true
                        }
                        Text {
                            text: "Focused"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Pressed"
                            variant: "outlined"
                        }
                        Text {
                            text: "Pressed"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Disabled"
                            variant: "outlined"
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

                Row {
                    spacing: 20
                    Button {
                        text: "Cancel"
                        variant: "outlined"
                        onClicked: console.log("Cancel clicked")
                    }
                    Button {
                        text: "Back"
                        variant: "outlined"
                        shape: "square"
                        onClicked: console.log("Back clicked")
                    }
                    Button {
                        text: "Learn more"
                        variant: "outlined"
                        onClicked: console.log("Learn more clicked")
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: ChiTheme.colors.outline
                opacity: 0.3
            }

            // TEXT BUTTONS
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Text Buttons"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                Text {
                    text: "Low-emphasis buttons for less important or optional actions"
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: ChiTheme.colors.onSurfaceVariant

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                Grid {
                    columns: 5
                    spacing: 40
                    rowSpacing: 30

                    Column {
                        spacing: 8
                        Button {
                            text: "Enabled"
                            variant: "text"
                        }
                        Text {
                            text: "Enabled"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Hovered"
                            variant: "text"
                        }
                        Text {
                            text: "Hovered"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Focused"
                            variant: "text"
                            focus: true
                        }
                        Text {
                            text: "Focused"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Pressed"
                            variant: "text"
                        }
                        Text {
                            text: "Pressed"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Disabled"
                            variant: "text"
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

                Row {
                    spacing: 20
                    Button {
                        text: "Skip"
                        variant: "text"
                        onClicked: console.log("Skip clicked")
                    }
                    Button {
                        text: "Maybe later"
                        variant: "text"
                        shape: "square"
                        onClicked: console.log("Maybe later clicked")
                    }
                    Button {
                        text: "Dismiss"
                        variant: "text"
                        onClicked: console.log("Dismiss clicked")
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: ChiTheme.colors.outline
                opacity: 0.3
            }

            // ELEVATED BUTTONS
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Elevated Buttons"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                Text {
                    text: "Elevated buttons for actions requiring visual separation from patterned backgrounds"
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: ChiTheme.colors.onSurfaceVariant

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                Grid {
                    columns: 5
                    spacing: 40
                    rowSpacing: 30

                    Column {
                        spacing: 8
                        Button {
                            text: "Enabled"
                            variant: "elevated"
                        }
                        Text {
                            text: "Enabled"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Hovered"
                            variant: "elevated"
                        }
                        Text {
                            text: "Hovered"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Focused"
                            variant: "elevated"
                            focus: true
                        }
                        Text {
                            text: "Focused"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Pressed"
                            variant: "elevated"
                        }
                        Text {
                            text: "Pressed"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Disabled"
                            variant: "elevated"
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

                Row {
                    spacing: 20
                    Button {
                        text: "Add to card"
                        variant: "elevated"
                        showIcon: true
                        icon: "+"
                        onClicked: console.log("Add to card clicked")
                    }
                    Button {
                        text: "Upload"
                        variant: "elevated"
                        shape: "square"
                        onClicked: console.log("Upload clicked")
                    }
                    Button {
                        text: "Continue"
                        variant: "elevated"
                        onClicked: console.log("Continue clicked")
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: ChiTheme.colors.outline
                opacity: 0.3
            }

            // TONAL BUTTONS
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Tonal Buttons"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                Text {
                    text: "Medium-emphasis buttons that are an alternative to filled buttons"
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: ChiTheme.colors.onSurfaceVariant

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                Grid {
                    columns: 5
                    spacing: 40
                    rowSpacing: 30

                    Column {
                        spacing: 8
                        Button {
                            text: "Enabled"
                            variant: "tonal"
                        }
                        Text {
                            text: "Enabled"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Hovered"
                            variant: "tonal"
                        }
                        Text {
                            text: "Hovered"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Focused"
                            variant: "tonal"
                            focus: true
                        }
                        Text {
                            text: "Focused"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Pressed"
                            variant: "tonal"
                        }
                        Text {
                            text: "Pressed"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Button {
                            text: "Disabled"
                            variant: "tonal"
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

                Row {
                    spacing: 20
                    Button {
                        text: "Settings"
                        variant: "tonal"
                        showIcon: true
                        icon: "⚙"
                        onClicked: console.log("Settings clicked")
                    }
                    Button {
                        text: "View details"
                        variant: "tonal"
                        shape: "square"
                        onClicked: console.log("View details clicked")
                    }
                    Button {
                        text: "Try it"
                        variant: "tonal"
                        onClicked: console.log("Try it clicked")
                    }
                }
            }
        }
    }
}
