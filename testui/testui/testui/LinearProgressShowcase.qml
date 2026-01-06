import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as Basic
import SmartUIBeta 1.0 as Su

Rectangle {
    width: 1200
    height: 900
    color: Su.ChiTheme.colors.background
    radius: 26

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    Flickable {
        anchors.fill: parent
        anchors.margins: 40
        contentHeight: mainColumn.height + 80
        clip: true

        Column {
            id: mainColumn
            width: parent.width
            spacing: 40

            // Header
            Row {
                width: parent.width
                spacing: 20

                Text {
                    text: "Linear Progress Indicators"
                    font.family: "Roboto"
                    font.pixelSize: 32
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    anchors.verticalCenter: parent.verticalCenter
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Item { width: 100; height: 1 }

                Su.Button {
                    text: "Animate All"
                    variant: "filled"
                    size: "small"
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: animateAll()
                }

                Su.Button {
                    text: "Reset All"
                    variant: "outlined"
                    size: "small"
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: resetAll()
                }
            }

            // Flat variant - 4dp
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Flat Variant — Small Thickness (4dp)"
                    font.family: "Roboto"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onSurface
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 2
                    spacing: 30
                    width: parent.width

                    Repeater {
                        model: [0, 0.1, 0.2, 0.5, 0.8, 1.0]

                        Column {
                            spacing: 8

                            Su.LinearProgressIndicator {
                                variant: "flat"
                                thickness: "small"
                                size: "medium"
                                progress: modelData
                            }

                            Text {
                                text: Math.round(modelData * 100) + "%"
                                font.pixelSize: 12
                                color: Su.ChiTheme.colors.onSurfaceVariant
                            }
                        }
                    }
                }
            }

            // Flat variant - 8dp
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Flat Variant — Medium Thickness (8dp)"
                    font.family: "Roboto"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onSurface
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 2
                    spacing: 30
                    width: parent.width

                    Repeater {
                        model: [0, 0.1, 0.2, 0.5, 0.8, 1.0]

                        Column {
                            spacing: 8

                            Su.LinearProgressIndicator {
                                variant: "flat"
                                thickness: "medium"
                                size: "medium"
                                progress: modelData
                            }

                            Text {
                                text: Math.round(modelData * 100) + "%"
                                font.pixelSize: 12
                                color: Su.ChiTheme.colors.onSurfaceVariant
                            }
                        }
                    }
                }
            }

            // Wave variant - 4dp
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Wave Variant — Small Thickness (4dp)"
                    font.family: "Roboto"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onSurface
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Text {
                    text: "Expressive wave pattern for processes that benefit from increased visual interest."
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: Su.ChiTheme.colors.onSurfaceVariant
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 2
                    spacing: 30
                    width: parent.width

                    Repeater {
                        model: [0, 0.1, 0.2, 0.5, 0.8, 1.0]

                        Column {
                            spacing: 8

                            Su.LinearProgressIndicator {
                                variant: "wave"
                                thickness: "small"
                                size: "medium"
                                progress: modelData
                            }

                            Text {
                                text: "Wave — " + Math.round(modelData * 100) + "%"
                                font.pixelSize: 12
                                color: Su.ChiTheme.colors.onSurfaceVariant
                            }
                        }
                    }
                }
            }

            // Wave variant - 8dp
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Wave Variant — Medium Thickness (8dp)"
                    font.family: "Roboto"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onSurface
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 2
                    spacing: 30
                    width: parent.width

                    Repeater {
                        model: [0, 0.1, 0.2, 0.5, 0.8, 1.0]

                        Column {
                            spacing: 8

                            Su.LinearProgressIndicator {
                                variant: "wave"
                                thickness: "medium"
                                size: "medium"
                                progress: modelData
                            }

                            Text {
                                text: "Wave — " + Math.round(modelData * 100) + "%"
                                font.pixelSize: 12
                                color: Su.ChiTheme.colors.onSurfaceVariant
                            }
                        }
                    }
                }
            }

            // Size variations
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Size Variations"
                    font.family: "Roboto"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onSurface
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Column {
                    spacing: 15

                    Repeater {
                        model: ["small", "medium", "large", "xlarge"]

                        Column {
                            spacing: 8

                            Su.LinearProgressIndicator {
                                variant: "wave"
                                thickness: "medium"
                                size: modelData
                                progress: 0.6
                            }

                            Text {
                                text: "Size: " + modelData
                                font.pixelSize: 12
                                color: Su.ChiTheme.colors.onSurfaceVariant
                            }
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
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onSurface
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Row {
                    spacing: 40

                    Column {
                        spacing: 15
                        width: 400

                        Su.LinearProgressIndicator {
                            id: interactiveFlat
                            variant: "flat"
                            thickness: "small"
                            size: "medium"
                            progress: progressSlider.value
                        }

                        Su.LinearProgressIndicator {
                            id: interactiveWave
                            variant: "wave"
                            thickness: "small"
                            size: "medium"
                            progress: progressSlider.value
                        }

                        Su.LinearProgressIndicator {
                            id: interactiveMedium
                            variant: "flat"
                            thickness: "medium"
                            size: "medium"
                            progress: progressSlider.value
                        }

                        Su.LinearProgressIndicator {
                            id: interactiveWaveMedium
                            variant: "wave"
                            thickness: "medium"
                            size: "medium"
                            progress: progressSlider.value
                        }

                        Row {
                            spacing: 10
                            width: parent.width

                            Text {
                                text: "Progress:"
                                font.pixelSize: 14
                                color: Su.ChiTheme.colors.onSurface
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Basic.Slider {
                                id: progressSlider
                                from: 0
                                to: 1
                                value: 0.3
                                width: 250
                            }

                            Text {
                                text: Math.round(progressSlider.value * 100) + "%"
                                font.pixelSize: 14
                                font.weight: Font.Medium
                                color: Su.ChiTheme.colors.primary
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }

                    Column {
                        spacing: 10

                        Text {
                            text: "Options"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: Su.ChiTheme.colors.onSurface
                        }

                        Basic.CheckBox {
                            id: showStopCheck
                            checked: true
                            text: "Show Stop"
                        }

                        Basic.CheckBox {
                            id: animatedCheck
                            checked: true
                            text: "Animated"
                        }
                    }
                }
            }

            // Indeterminate example
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Indeterminate Progress"
                    font.family: "Roboto"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onSurface
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Text {
                    text: "Use when the process duration cannot be determined."
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: Su.ChiTheme.colors.onSurfaceVariant
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Column {
                    spacing: 15

                    Su.LinearProgressIndicator {
                        variant: "flat"
                        thickness: "small"
                        size: "medium"
                        indeterminate: true
                    }

                    Su.LinearProgressIndicator {
                        variant: "flat"
                        thickness: "medium"
                        size: "medium"
                        indeterminate: true
                    }
                }
            }
        }
    }

    function animateAll() {
        timer.restart()
    }

    function resetAll() {
        progressSlider.value = 0
    }

    Timer {
        id: timer
        interval: 50
        repeat: true
        property real p: 0

        onTriggered: {
            p += 0.02
            progressSlider.value = p
            if (p >= 1.0) {
                p = 0
                stop()
            }
        }
    }

    Component.onCompleted: {
        interactiveFlat.showStop       = Qt.binding(() => showStopCheck.checked)
        interactiveWave.showStop       = Qt.binding(() => showStopCheck.checked)
        interactiveMedium.showStop     = Qt.binding(() => showStopCheck.checked)
        interactiveWaveMedium.showStop = Qt.binding(() => showStopCheck.checked)

        interactiveFlat.animated       = Qt.binding(() => animatedCheck.checked)
        interactiveWave.animated       = Qt.binding(() => animatedCheck.checked)
        interactiveMedium.animated     = Qt.binding(() => animatedCheck.checked)
        interactiveWaveMedium.animated = Qt.binding(() => animatedCheck.checked)
    }
}
