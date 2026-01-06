import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as BasicControls
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

            // Header + theme toggle
            Row {
                width: parent.width
                spacing: 20

                Text {
                    text: "SmartUI Switch System"
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

                    BasicControls.Switch {
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
                text: "Binary on/off controls with optional icon, sized touch target, and proper hover/focus behavior."
                font.family: "Roboto"
                font.pixelSize: 14
                color: Su.ChiTheme.colors.onSurfaceVariant
                wrapMode: Text.WordWrap
                width: parent.width
                Behavior on color { ColorAnimation { duration: 200 } }
            }

            // Selected (On) - No Icon
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Selected (On) — No Icon"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 5
                    columnSpacing: 40
                    rowSpacing: 30

                    Column {
                        spacing: 8
                        Su.Switch { checked: true }
                        Text {
                            text: "Enabled"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Switch { checked: true }
                        Text {
                            text: "Hovered"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Switch {
                            checked: true
                            focus: true
                        }
                        Text {
                            text: "Focused"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Switch { checked: true }
                        Text {
                            text: "Pressed"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Switch {
                            checked: true
                            enabled: false
                        }
                        Text {
                            text: "Disabled"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            // Selected (On) - With Icon
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Selected (On) — With Icons"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 5
                    columnSpacing: 40
                    rowSpacing: 30

                    Column {
                        spacing: 8
                        Su.Switch {
                            checked: true
                            showIcon: true
                        }
                        Text {
                            text: "Enabled"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Switch {
                            checked: true
                            showIcon: true
                        }
                        Text {
                            text: "Hovered"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Switch {
                            checked: true
                            showIcon: true
                            focus: true
                        }
                        Text {
                            text: "Focused"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Switch {
                            checked: true
                            showIcon: true
                        }
                        Text {
                            text: "Pressed"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Switch {
                            checked: true
                            showIcon: true
                            enabled: false
                        }
                        Text {
                            text: "Disabled"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            // Unselected (Off) - No Icon
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Unselected (Off) — No Icon"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 5
                    columnSpacing: 40
                    rowSpacing: 30

                    Column {
                        spacing: 8
                        Su.Switch { checked: false }
                        Text {
                            text: "Enabled"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Switch { checked: false }
                        Text {
                            text: "Hovered"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Switch {
                            checked: false
                            focus: true
                        }
                        Text {
                            text: "Focused"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Switch { checked: false }
                        Text {
                            text: "Pressed"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Switch {
                            checked: false
                            enabled: false
                        }
                        Text {
                            text: "Disabled"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            // Unselected (Off) - With Icon
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Unselected (Off) — With Icons"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 5
                    columnSpacing: 40
                    rowSpacing: 30

                    Column {
                        spacing: 8
                        Su.Switch {
                            checked: false
                            showIcon: true
                            icon: "✕"
                        }
                        Text {
                            text: "Enabled"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Switch {
                            checked: false
                            showIcon: true
                            icon: "✕"
                        }
                        Text {
                            text: "Hovered"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Switch {
                            checked: false
                            showIcon: true
                            icon: "✕"
                            focus: true
                        }
                        Text {
                            text: "Focused"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Switch {
                            checked: false
                            showIcon: true
                            icon: "✕"
                        }
                        Text {
                            text: "Pressed"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Switch {
                            checked: false
                            showIcon: true
                            icon: "✕"
                            enabled: false
                        }
                        Text {
                            text: "Disabled"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            // Interactive example list
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Interactive Examples"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Column {
                    width: parent.width
                    spacing: 16

                    Repeater {
                        model: [
                            { label: "Wi-Fi",           icon: "📶", checked: true },
                            { label: "Bluetooth",       icon: "🔵", checked: true },
                            { label: "Airplane Mode",   icon: "✈️", checked: false },
                            { label: "Do Not Disturb",  icon: "🔕", checked: false },
                            { label: "Auto-brightness", icon: "☀️", checked: true }
                        ]

                        Rectangle {
                            width: parent.width
                            height: 64
                            radius: 16
                            color: Su.ChiTheme.colors.surfaceContainer
                            Behavior on color { ColorAnimation { duration: 200 } }

                            Row {
                                anchors.fill: parent
                                anchors.leftMargin: 20
                                anchors.rightMargin: 20
                                spacing: 16

                                Text {
                                    text: modelData.icon
                                    font.pixelSize: 24
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    text: modelData.label
                                    font.family: "Roboto"
                                    font.pixelSize: 16
                                    color: Su.ChiTheme.colors.onSurface
                                    anchors.verticalCenter: parent.verticalCenter
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }

                                Item {
                                    Layout.fillWidth: true
                                    width: 1
                                }

                                Su.Switch {
                                    id: settingSwitch
                                    checked: modelData.checked
                                    showIcon: true
                                    anchors.verticalCenter: parent.verticalCenter

                                    onToggled: console.log(modelData.label, "toggled to", checked)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
