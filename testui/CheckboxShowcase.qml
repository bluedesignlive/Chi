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
                    text: "SmartUI Checkbox System"
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
                text: "Binary selection controls with three states: unchecked, checked, and indeterminate."
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
                    text: "Unselected (Off) — No Label"
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
                        Su.Checkbox { }
                        Text {
                            text: "Enabled"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Checkbox { }
                        Text {
                            text: "Hovered"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Checkbox {
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
                        Su.Checkbox { }
                        Text {
                            text: "Pressed"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Checkbox {
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
                    text: "Selected (On) — No Label"
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
                        Su.Checkbox { checked: true }
                        Text {
                            text: "Enabled"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Checkbox { checked: true }
                        Text {
                            text: "Hovered"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Checkbox {
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
                        Su.Checkbox { checked: true }
                        Text {
                            text: "Pressed"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Checkbox {
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
                    text: "Indeterminate — No Label"
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
                        Su.Checkbox { indeterminate: true }
                        Text {
                            text: "Enabled"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Checkbox { indeterminate: true }
                        Text {
                            text: "Hovered"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Checkbox {
                            indeterminate: true
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
                        Su.Checkbox { indeterminate: true }
                        Text {
                            text: "Pressed"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Checkbox {
                            indeterminate: true
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
                    text: "Checkbox Sizes"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 3
                    columnSpacing: 40
                    rowSpacing: 30

                    Column {
                        spacing: 8
                        Row {
                            spacing: 12
                            Su.Checkbox {
                                size: "small"
                            }
                            Text {
                                text: "Small checkbox"
                                font.family: "Roboto"
                                font.pixelSize: 13
                                color: Su.ChiTheme.colors.onSurface
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        Text {
                            text: "Small (16px box)"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Row {
                            spacing: 12
                            Su.Checkbox {
                                size: "medium"
                                checked: true
                            }
                            Text {
                                text: "Medium checkbox"
                                font.family: "Roboto"
                                font.pixelSize: 14
                                color: Su.ChiTheme.colors.onSurface
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        Text {
                            text: "Medium (20px box)"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Row {
                            spacing: 12
                            Su.Checkbox {
                                size: "large"
                                indeterminate: true
                            }
                            Text {
                                text: "Large checkbox"
                                font.family: "Roboto"
                                font.pixelSize: 16
                                color: Su.ChiTheme.colors.onSurface
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        Text {
                            text: "Large (24px box)"
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
                    text: "Checkbox with Labels"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Column {
                    spacing: 20
                    width: 400

                    Row {
                        spacing: 12
                        Su.Checkbox {
                            label: "I agree to the terms and conditions"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Row {
                        spacing: 12
                        Su.Checkbox {
                            label: "Subscribe to newsletter"
                            checked: true
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Row {
                        spacing: 12
                        Su.Checkbox {
                            label: "Disabled option"
                            enabled: false
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Row {
                        spacing: 12
                        Su.Checkbox {
                            label: "Pre-checked disabled"
                            checked: true
                            enabled: false
                            anchors.verticalCenter: parent.verticalCenter
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
                    text: "Checkbox Interactive Examples"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Text {
                    text: "Try clicking these checkboxes to test their behavior"
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: Su.ChiTheme.colors.onSurfaceVariant
                    wrapMode: Text.WordWrap
                    width: parent.width
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Column {
                    spacing: 20
                    width: 450

                    Row {
                        spacing: 12
                        Su.Checkbox {
                            label: "Receive email notifications"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Row {
                        spacing: 12
                        Su.Checkbox {
                            label: "Enable dark mode"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Row {
                        spacing: 12
                        Su.Checkbox {
                            label: "Remember me"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Row {
                        spacing: 12
                        Su.Checkbox {
                            label: "Auto-save changes"
                            checked: true
                            anchors.verticalCenter: parent.verticalCenter
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
                    text: "Checkbox States Overview"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 4
                    columnSpacing: 30
                    rowSpacing: 20

                    Column {
                        spacing: 8
                        Su.Checkbox { }
                        Text {
                            text: "Unselected"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Checkbox { checked: true }
                        Text {
                            text: "Selected"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Checkbox { indeterminate: true }
                        Text {
                            text: "Indeterminate"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Checkbox {
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
        }
    }
}
