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

    property bool dialogOpen1: false
    property bool dialogOpen2: false
    property bool dialogOpen3: false
    property bool dialogOpen4: false

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
                    text: "SmartUI Dialog System"
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
                text: "Modal dialogs for important information, confirmations, and user interactions."
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
                    text: "Dialog Sizes"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 4
                    columnSpacing: 20
                    rowSpacing: 20

                    Column {
                        spacing: 8
                        Su.Button {
                            text: "Small Dialog"
                            variant: "filled"
                            onClicked: dialogOpen1 = true
                        }
                        Text {
                            text: "Small (280px)"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Button {
                            text: "Medium Dialog"
                            variant: "filled"
                            onClicked: dialogOpen2 = true
                        }
                        Text {
                            text: "Medium (400px)"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Button {
                            text: "Large Dialog"
                            variant: "filled"
                            onClicked: dialogOpen3 = true
                        }
                        Text {
                            text: "Large (560px)"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Button {
                            text: "Fullscreen Dialog"
                            variant: "filled"
                            onClicked: dialogOpen4 = true
                        }
                        Text {
                            text: "Fullscreen"
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
                    text: "Dialog Variations"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Text {
                    text: "Different dialog configurations with titles, icons, and content"
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

                    Su.Button {
                        text: "Alert Dialog"
                        variant: "elevated"
                        onClicked: alertDemo()
                    }

                    Su.Button {
                        text: "Confirmation Dialog"
                        variant: "elevated"
                        onClicked: confirmDemo()
                    }

                    Su.Button {
                        text: "With Icon"
                        variant: "elevated"
                        onClicked: iconDemo()
                    }

                    Su.Button {
                        text: "No Actions"
                        variant: "elevated"
                        onClicked: noActionsDemo()
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
                    text: "Dialog Content Examples"
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
                        Su.Button {
                            text: "Text Content"
                            variant: "outlined"
                            onClicked: textContentDemo()
                        }
                        Text {
                            text: "Simple text dialog"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Button {
                            text: "Form Content"
                            variant: "outlined"
                            onClicked: formContentDemo()
                        }
                        Text {
                            text: "Dialog with form inputs"
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
                    text: "Dialog Behavior"
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
                            text: "Modal"
                            variant: "filled"
                            onClicked: modalDemo()
                        }
                        Text {
                            text: "Blocks interactions"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Button {
                            text: "Close on overlay click"
                            variant: "filled"
                            onClicked: closeOnOverlayDemo()
                        }
                        Text {
                            text: "Click outside to close"
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
                    text: "Dialog Actions"
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
                            text: "Single Action"
                            variant: "tonal"
                            onClicked: singleActionDemo()
                        }
                        Text {
                            text: "One button only"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Button {
                            text: "Two Actions"
                            variant: "tonal"
                            onClicked: twoActionsDemo()
                        }
                        Text {
                            text: "Cancel and confirm"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Button {
                            text: "Three Actions"
                            variant: "tonal"
                            onClicked: threeActionsDemo()
                        }
                        Text {
                            text: "Multiple options"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }
                }
            }
        }
    }

    function alertDemo() {
        alertDialog.open()
    }

    function confirmDemo() {
        confirmDialog.open()
    }

    function iconDemo() {
        iconDialog.open()
    }

    function noActionsDemo() {
        noActionsDialog.open()
    }

    function textContentDemo() {
        textContentDialog.open()
    }

    function formContentDemo() {
        formContentDialog.open()
    }

    function modalDemo() {
        modalDialog.open()
    }

    function closeOnOverlayDemo() {
        closeOnOverlayDialog.open()
    }

    function singleActionDemo() {
        singleActionDialog.open()
    }

    function twoActionsDemo() {
        twoActionsDialog.open()
    }

    function threeActionsDemo() {
        threeActionsDialog.open()
    }

    Su.Dialog {
        id: alertDialog
        title: "Alert"
        supportingText: "This is an alert dialog with important information."
        icon: "⚠"
        size: "medium"

        actions: [
            Su.Button {
                text: "OK"
                variant: "filled"
                onClicked: alertDialog.close()
            }
        ]
    }

    Su.Dialog {
        id: confirmDialog
        title: "Confirm Action"
        supportingText: "Are you sure you want to proceed with this action? This cannot be undone."
        size: "medium"

        actions: [
            Su.Button {
                text: "Cancel"
                variant: "text"
                onClicked: confirmDialog.close()
            },
            Su.Button {
                text: "Confirm"
                variant: "filled"
                onClicked: confirmDialog.close()
            }
        ]
    }

    Su.Dialog {
        id: iconDialog
        title: "Success"
        supportingText: "Your action was completed successfully!"
        icon: "✓"
        size: "medium"

        actions: [
            Su.Button {
                text: "Great!"
                variant: "filled"
                onClicked: iconDialog.close()
            }
        ]
    }

    Su.Dialog {
        id: noActionsDialog
        title: "Information"
        supportingText: "This dialog has no action buttons. You can close it by clicking outside or pressing Escape."
        size: "medium"
    }

    Su.Dialog {
        id: textContentDialog
        title: "Terms and Conditions"
        supportingText: "Please read the following terms carefully."
        size: "large"

        Text {
            text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
            font.family: "Roboto"
            font.pixelSize: 14
            color: Su.ChiTheme.colors.onSurface
            wrapMode: Text.WordWrap
            width: parent.width
            Behavior on color { ColorAnimation { duration: 200 } }
        }

        actions: [
            Su.Button {
                text: "Decline"
                variant: "text"
                onClicked: textContentDialog.close()
            },
            Su.Button {
                text: "Accept"
                variant: "filled"
                onClicked: textContentDialog.close()
            }
        ]
    }

    Su.Dialog {
        id: formContentDialog
        title: "Edit Profile"
        supportingText: "Update your information below."
        size: "medium"

        Column {
            spacing: 16
            width: parent.width

            Su.TextField {
                label: "Full Name"
                placeholderText: "Enter your name"
                width: parent.width
            }

            Su.TextField {
                label: "Email"
                placeholderText: "Enter your email"
                width: parent.width
            }
        }

        actions: [
            Su.Button {
                text: "Cancel"
                variant: "text"
                onClicked: formContentDialog.close()
            },
            Su.Button {
                text: "Save"
                variant: "filled"
                onClicked: formContentDialog.close()
            }
        ]
    }

    Su.Dialog {
        id: modalDialog
        title: "Modal Dialog"
        supportingText: "This is a modal dialog. You cannot interact with the content behind it."
        size: "medium"
        modal: true

        actions: [
            Su.Button {
                text: "Close"
                variant: "filled"
                onClicked: modalDialog.close()
            }
        ]
    }

    Su.Dialog {
        id: closeOnOverlayDialog
        title: "Close on Overlay"
        supportingText: "Click outside this dialog to close it."
        size: "medium"
        closeOnOverlayClick: true

        actions: [
            Su.Button {
                text: "Close"
                variant: "text"
                onClicked: closeOnOverlayDialog.close()
            }
        ]
    }

    Su.Dialog {
        id: singleActionDialog
        title: "Notification"
        supportingText: "You have a new message waiting for you."
        size: "medium"

        actions: [
            Su.Button {
                text: "View"
                variant: "filled"
                onClicked: singleActionDialog.close()
            }
        ]
    }

    Su.Dialog {
        id: twoActionsDialog
        title: "Delete Item"
        supportingText: "Are you sure you want to delete this item?"
        icon: "🗑"
        size: "medium"

        actions: [
            Su.Button {
                text: "Cancel"
                variant: "text"
                onClicked: twoActionsDialog.close()
            },
            Su.Button {
                text: "Delete"
                variant: "filled"
                onClicked: twoActionsDialog.close()
            }
        ]
    }

    Su.Dialog {
        id: threeActionsDialog
        title: "Export Options"
        supportingText: "Choose an export format for your data."
        size: "medium"

        actions: [
            Su.Button {
                text: "Cancel"
                variant: "text"
                onClicked: threeActionsDialog.close()
            },
            Su.Button {
                text: "CSV"
                variant: "outlined"
                onClicked: threeActionsDialog.close()
            },
            Su.Button {
                text: "Excel"
                variant: "filled"
                onClicked: threeActionsDialog.close()
            }
        ]
    }

    Su.Dialog {
        id: demoDialog1
        title: "Small Dialog"
        supportingText: "This is a small dialog for quick interactions."
        open: dialogOpen1
        onClosed: dialogOpen1 = false
        size: "small"

        actions: [
            Su.Button {
                text: "Close"
                variant: "filled"
                onClicked: demoDialog1.close()
            }
        ]
    }

    Su.Dialog {
        id: demoDialog2
        title: "Medium Dialog"
        supportingText: "This is a medium dialog, suitable for most use cases."
        open: dialogOpen2
        onClosed: dialogOpen2 = false
        size: "medium"

        Text {
            text: "Medium dialogs work well for forms, confirmations, and detailed information."
            font.family: "Roboto"
            font.pixelSize: 14
            color: Su.ChiTheme.colors.onSurface
            wrapMode: Text.WordWrap
            width: parent.width
            Behavior on color { ColorAnimation { duration: 200 } }
        }

        actions: [
            Su.Button {
                text: "Cancel"
                variant: "text"
                onClicked: demoDialog2.close()
            },
            Su.Button {
                text: "OK"
                variant: "filled"
                onClicked: demoDialog2.close()
            }
        ]
    }

    Su.Dialog {
        id: demoDialog3
        title: "Large Dialog"
        supportingText: "This is a large dialog for complex content."
        open: dialogOpen3
        onClosed: dialogOpen3 = false
        size: "large"

        Column {
            spacing: 12
            width: parent.width

            Text {
                text: "Large dialogs are useful for:"
                font.family: "Roboto"
                font.pixelSize: 14
                font.weight: Font.Medium
                color: Su.ChiTheme.colors.onSurface
                Behavior on color { ColorAnimation { duration: 200 } }
            }

            Text {
                text: "• Complex forms with multiple fields\n• Displaying detailed information\n• Multi-step processes\n• Settings panels"
                font.family: "Roboto"
                font.pixelSize: 14
                color: Su.ChiTheme.colors.onSurface
                Behavior on color { ColorAnimation { duration: 200 } }
            }
        }

        actions: [
            Su.Button {
                text: "Cancel"
                variant: "text"
                onClicked: demoDialog3.close()
            },
            Su.Button {
                text: "Proceed"
                variant: "filled"
                onClicked: demoDialog3.close()
            }
        ]
    }

    Su.Dialog {
        id: demoDialog4
        title: "Fullscreen Dialog"
        supportingText: "This dialog fills most of the screen."
        open: dialogOpen4
        onClosed: dialogOpen4 = false
        size: "fullscreen"

        Column {
            spacing: 20
            width: parent.width
            anchors.centerIn: parent

            Text {
                text: "Fullscreen Dialog Content"
                font.family: "Roboto"
                font.pixelSize: 24
                font.weight: Font.Medium
                color: Su.ChiTheme.colors.onSurface
                Behavior on color { ColorAnimation { duration: 200 } }
            }

            Text {
                text: "This dialog takes up most of the available space. It's useful for immersive experiences or when you need maximum screen real estate."
                font.family: "Roboto"
                font.pixelSize: 16
                color: Su.ChiTheme.colors.onSurfaceVariant
                wrapMode: Text.WordWrap
                width: 600
                horizontalAlignment: Text.AlignHCenter
                Behavior on color { ColorAnimation { duration: 200 } }
            }
        }

        actions: [
            Su.Button {
                text: "Close"
                variant: "text"
                onClicked: demoDialog4.close()
            },
            Su.Button {
                text: "Done"
                variant: "filled"
                onClicked: demoDialog4.close()
            }
        ]
    }
}
