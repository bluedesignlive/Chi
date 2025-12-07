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
                    text: "SmartUI FAB Menu System"
                    font.family: "Roboto"
                    font.pixelSize: 32
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground
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
                text: "Floating Action Button menus for multiple related actions. Right-aligned and animated."
                font.family: "Roboto"
                font.pixelSize: 14
                color: ChiTheme.colors.onSurfaceVariant
                wrapMode: Text.WordWrap
                Behavior on color { ColorAnimation { duration: 200 } }
            }

            // FAB Menu Variants
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Variants"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Row {
                    width: parent.width
                    spacing: 60

                    Column {
                        spacing: 12

                        FABMenu {
                            id: primaryMenu
                            variant: "primary"
                            menuItems: [
                                { text: "Edit",   icon: "✎" },
                                { text: "Delete", icon: "🗑" },
                                { text: "Share",  icon: "↗" }
                            ]
                            onItemClicked: (index, text) => console.log("Primary menu:", text)
                        }

                        Text {
                            text: "Primary"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 12

                        FABMenu {
                            id: secondaryMenu
                            variant: "secondary"
                            menuItems: [
                                { text: "Copy",  icon: "📋" },
                                { text: "Paste", icon: "📄" },
                                { text: "Cut",   icon: "✂" }
                            ]
                            onItemClicked: (index, text) => console.log("Secondary menu:", text)
                        }

                        Text {
                            text: "Secondary"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 12

                        FABMenu {
                            id: tertiaryMenu
                            variant: "tertiary"
                            menuItems: [
                                { text: "Play",  icon: "▶" },
                                { text: "Pause", icon: "⏸" },
                                { text: "Stop",  icon: "⏹" }
                            ]
                            onItemClicked: (index, text) => console.log("Tertiary menu:", text)
                        }

                        Text {
                            text: "Tertiary"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            // Different action counts
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Different Action Counts"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Row {
                    width: parent.width
                    spacing: 60

                    Column {
                        spacing: 12

                        FABMenu {
                            variant: "primary"
                            menuItems: [
                                { text: "Yes", icon: "✓" },
                                { text: "No",  icon: "✕" }
                            ]
                        }

                        Text {
                            text: "2 Actions"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 12

                        FABMenu {
                            variant: "secondary"
                            menuItems: [
                                { text: "Home",   icon: "🏠" },
                                { text: "Work",   icon: "💼" },
                                { text: "School", icon: "🎓" },
                                { text: "Other",  icon: "📍" }
                            ]
                        }

                        Text {
                            text: "4 Actions"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 12

                        FABMenu {
                            variant: "tertiary"
                            menuItems: [
                                { text: "File",  icon: "📄" },
                                { text: "Image", icon: "🖼" },
                                { text: "Video", icon: "🎬" },
                                { text: "Audio", icon: "🎵" },
                                { text: "Link",  icon: "🔗" },
                                { text: "Code",  icon: "💻" }
                            ]
                        }

                        Text {
                            text: "6 Actions (max)"
                            font.pixelSize: 12
                            color: ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            // Interactive demo
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Interactive Demo"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Rectangle {
                    width: parent.width
                    height: 400
                    radius: 16
                    color: ChiTheme.colors.surfaceContainer
                    Behavior on color { ColorAnimation { duration: 200 } }

                    FABMenu {
                        id: demoMenu
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.margins: 20
                        variant: "primary"

                        menuItems: [
                            { text: "Create", icon: "+" },
                            { text: "Upload", icon: "↑" },
                            { text: "Scan",   icon: "📷" }
                        ]

                        onItemClicked: (index, text) => {
                            statusText.text = "Action: " + text
                        }
                    }

                    Text {
                        id: statusText
                        anchors.centerIn: parent
                        text: "Click the FAB button →"
                        font.family: "Roboto"
                        font.pixelSize: 18
                        color: ChiTheme.colors.onSurfaceVariant
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }
                }
            }
        }
    }
}
