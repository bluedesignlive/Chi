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
                    text: "SmartUI Slider System"
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
                text: "Range selection controls for adjusting values along a continuous or discrete scale."
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
                    text: "Slider Sizes"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Column {
                    width: 500
                    spacing: 30

                    Column {
                        spacing: 8
                        Su.Slider {
                            size: "small"
                            width: 400
                        }
                        Text {
                            text: "Small slider"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Slider {
                            size: "medium"
                            width: 400
                        }
                        Text {
                            text: "Medium slider"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Slider {
                            size: "large"
                            width: 400
                        }
                        Text {
                            text: "Large slider"
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
                    text: "Slider States"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Column {
                    width: 500
                    spacing: 30

                    Column {
                        spacing: 8
                        Su.Slider {
                            value: 0.5
                            width: 400
                        }
                        Text {
                            text: "Enabled (value: 0.5)"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Slider {
                            value: 0.3
                            enabled: false
                            width: 400
                        }
                        Text {
                            text: "Disabled (value: 0.3)"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Slider {
                            value: 0.8
                            size: "medium"
                            width: 400
                        }
                        Text {
                            text: "Hover and interact"
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
                    text: "Continuous vs Discrete Sliders"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Column {
                    width: 500
                    spacing: 30

                    Column {
                        spacing: 8
                        Su.Slider {
                            value: 0.5
                            size: "medium"
                            width: 400
                        }
                        Text {
                            text: "Continuous slider (smooth movement)"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Su.Slider {
                            value: 0.5
                            size: "medium"
                            width: 400
                        }
                        Text {
                            text: "Discrete slider (snaps to values)"
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
                    text: "Slider with Labels"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Column {
                    width: 500
                    spacing: 30

                    Column {
                        spacing: 8
                        Row {
                            spacing: 12
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                text: "0"
                                font.family: "Roboto"
                                font.pixelSize: 14
                                color: Su.ChiTheme.colors.onSurface
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }

                            Su.Slider {
                                value: 0.25
                                size: "medium"
                                width: 300
                            }

                            Text {
                                text: "100"
                                font.family: "Roboto"
                                font.pixelSize: 14
                                color: Su.ChiTheme.colors.onSurface
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }
                        }
                        Text {
                            text: "With min/max labels"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Row {
                            spacing: 12
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                text: "Volume"
                                font.family: "Roboto"
                                font.pixelSize: 14
                                color: Su.ChiTheme.colors.onSurface
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }

                            Su.Slider {
                                value: 0.6
                                size: "medium"
                                width: 300
                            }
                        }
                        Text {
                            text: "With single label"
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
                    text: "Slider Range Examples"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Column {
                    width: 500
                    spacing: 30

                    Column {
                        spacing: 8
                        Row {
                            spacing: 12
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                text: "Brightness"
                                font.family: "Roboto"
                                font.pixelSize: 14
                                color: Su.ChiTheme.colors.onSurface
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }

                            Su.Slider {
                                value: 0.75
                                size: "medium"
                                width: 350
                            }

                            Text {
                                text: "75%"
                                font.family: "Roboto"
                                font.pixelSize: 14
                                color: Su.ChiTheme.colors.onSurface
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }
                        }
                        Text {
                            text: "Brightness control (0-100%)"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                        }
                    }

                    Column {
                        spacing: 8
                        Row {
                            spacing: 12
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                text: "Volume"
                                font.family: "Roboto"
                                font.pixelSize: 14
                                color: Su.ChiTheme.colors.onSurface
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }

                            Su.Slider {
                                value: 0.4
                                size: "medium"
                                width: 350
                            }

                            Text {
                                text: "40%"
                                font.family: "Roboto"
                                font.pixelSize: 14
                                color: Su.ChiTheme.colors.onSurface
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }
                        }
                        Text {
                            text: "Volume control (0-100%)"
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
                    text: "Interactive Sliders"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Text {
                    text: "Try adjusting these sliders to see the changes"
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: Su.ChiTheme.colors.onSurfaceVariant
                    wrapMode: Text.WordWrap
                    width: parent.width
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 2
                    columnSpacing: 40
                    rowSpacing: 30

                    Su.Card {
                        width: 350
                        height: 180
                        variant: "elevated"

                        property real sliderValue: 0.5

                        Column {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 16

                            Text {
                                text: "Adjust value"
                                font.family: "Roboto"
                                font.pixelSize: 16
                                font.weight: Font.Medium
                                color: Su.ChiTheme.colors.onSurface
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }

                            Su.Slider {
                                value: parent.parent.sliderValue
                                size: "medium"
                                width: parent.width
                            }

                            Text {
                                text: "Value: " + (parent.parent.sliderValue * 100).toFixed(0) + "%"
                                font.family: "Roboto"
                                font.pixelSize: 14
                                color: Su.ChiTheme.colors.onSurfaceVariant
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }
                        }
                    }

                    Su.Card {
                        width: 350
                        height: 180
                        variant: "filled"

                        property real sliderValue2: 0.3

                        Column {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 16

                            Text {
                                text: "Set opacity"
                                font.family: "Roboto"
                                font.pixelSize: 16
                                font.weight: Font.Medium
                                color: Su.ChiTheme.colors.onSurface
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }

                            Su.Slider {
                                value: parent.parent.sliderValue2
                                size: "medium"
                                width: parent.width
                            }

                            Text {
                                text: "Opacity: " + (parent.parent.sliderValue2 * 100).toFixed(0) + "%"
                                font.family: "Roboto"
                                font.pixelSize: 14
                                color: Su.ChiTheme.colors.onSurfaceVariant
                                Behavior on color { ColorAnimation { duration: 200 } }
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
                    text: "Slider in Different Contexts"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Flow {
                    width: parent.width
                    spacing: 30

                    Column {
                        spacing: 8
                        Text {
                            text: "Audio Playback"
                            font.family: "Roboto"
                            font.pixelSize: 14
                            color: Su.ChiTheme.colors.onSurface
                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                        Row {
                            spacing: 8
                            anchors.verticalCenter: parent.verticalCenter

                            Su.IconButton {
                                icon: "⏮"
                                variant: "tonal"
                            }

                            Su.Slider {
                                value: 0.35
                                size: "medium"
                                width: 200
                            }

                            Text {
                                text: "1:23"
                                font.family: "Roboto"
                                font.pixelSize: 12
                                color: Su.ChiTheme.colors.onSurfaceVariant
                                Behavior on color { ColorAnimation { duration: 200 } }
                            }

                            Su.IconButton {
                                icon: "⏭"
                                variant: "tonal"
                            }
                        }
                    }

                    Column {
                        spacing: 8
                        Text {
                            text: "Screen Brightness"
                            font.family: "Roboto"
                            font.pixelSize: 14
                            color: Su.ChiTheme.colors.onSurface
                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                        Row {
                            spacing: 12
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                text: "🔆"
                                font.pixelSize: 20
                            }

                            Su.Slider {
                                value: 0.7
                                size: "medium"
                                width: 180
                            }

                            Text {
                                text: "🔅"
                                font.pixelSize: 20
                            }
                        }
                    }
                }
            }
        }
    }
}
