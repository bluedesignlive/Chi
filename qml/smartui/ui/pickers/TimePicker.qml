import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Item {
    id: root

    property int hours: 12
    property int minutes: 0
    property bool is24Hour: false
    property bool isAM: true
    property bool showHeader: true
    property bool enabled: true
    property string mode: "hours"            // "hours", "minutes"

    signal timeSelected(int hours, int minutes)
    signal cancelled()

    readonly property int displayHours: is24Hour ? hours : (hours === 0 ? 12 : (hours > 12 ? hours - 12 : hours))
    readonly property string formattedTime: (displayHours < 10 ? "0" : "") + displayHours + ":" +
                                            (minutes < 10 ? "0" : "") + minutes

    implicitWidth: 328
    implicitHeight: showHeader ? 456 : 380

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        anchors.fill: parent
        radius: 28
        color: colors.surfaceContainerHigh
        clip: true

        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 8
            radius: 24
            samples: 25
            color: Qt.rgba(0, 0, 0, 0.2)
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // Header
            Rectangle {
                visible: showHeader
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                color: colors.surfaceContainerHigh

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 24
                    spacing: 16

                    Text {
                        text: "Select time"
                        font.family: "Roboto"
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        color: colors.onSurfaceVariant

                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }

                    RowLayout {
                        spacing: 4

                        // Hours input
                        Rectangle {
                            Layout.preferredWidth: 56
                            Layout.preferredHeight: 48
                            radius: 8
                            color: mode === "hours" ? colors.primaryContainer : colors.surfaceContainerHighest

                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: (displayHours < 10 ? "0" : "") + displayHours
                                font.family: "Roboto"
                                font.pixelSize: 32
                                color: mode === "hours" ? colors.onPrimaryContainer : colors.onSurface

                                Behavior on color {
                                    ColorAnimation { duration: 150 }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: mode = "hours"
                            }
                        }

                        Text {
                            text: ":"
                            font.family: "Roboto"
                            font.pixelSize: 32
                            color: colors.onSurface
                        }

                        // Minutes input
                        Rectangle {
                            Layout.preferredWidth: 56
                            Layout.preferredHeight: 48
                            radius: 8
                            color: mode === "minutes" ? colors.primaryContainer : colors.surfaceContainerHighest

                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: (minutes < 10 ? "0" : "") + minutes
                                font.family: "Roboto"
                                font.pixelSize: 32
                                color: mode === "minutes" ? colors.onPrimaryContainer : colors.onSurface

                                Behavior on color {
                                    ColorAnimation { duration: 150 }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: mode = "minutes"
                            }
                        }

                        Item { Layout.fillWidth: true }

                        // AM/PM selector (12-hour mode)
                        Column {
                            visible: !is24Hour
                            spacing: 0

                            Rectangle {
                                width: 52
                                height: 28
                                radius: 8
                                color: isAM ? colors.tertiaryContainer : colors.surfaceContainerHighest
                                border.width: isAM ? 0 : 1
                                border.color: colors.outline

                                Text {
                                    anchors.centerIn: parent
                                    text: "AM"
                                    font.family: "Roboto"
                                    font.pixelSize: 14
                                    font.weight: Font.Medium
                                    color: isAM ? colors.onTertiaryContainer : colors.onSurface
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: isAM = true
                                }
                            }

                            Rectangle {
                                width: 52
                                height: 28
                                radius: 8
                                color: !isAM ? colors.tertiaryContainer : colors.surfaceContainerHighest
                                border.width: !isAM ? 0 : 1
                                border.color: colors.outline

                                Text {
                                    anchors.centerIn: parent
                                    text: "PM"
                                    font.family: "Roboto"
                                    font.pixelSize: 14
                                    font.weight: Font.Medium
                                    color: !isAM ? colors.onTertiaryContainer : colors.onSurface
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: isAM = false
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 1
                    color: colors.outlineVariant
                }
            }

            // Clock face
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 24

                Rectangle {
                    id: clockFace
                    anchors.centerIn: parent
                    width: Math.min(parent.width, parent.height)
                    height: width
                    radius: width / 2
                    color: colors.surfaceContainerHighest

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }

                    // Clock hand
                    Rectangle {
                        id: clockHand
                        anchors.centerIn: parent
                        width: 2
                        height: parent.width / 2 - 40
                        color: colors.primary
                        transformOrigin: Item.Bottom

                        rotation: mode === "hours" ?
                            (is24Hour ? hours * 15 : displayHours * 30) :
                            minutes * 6

                        Behavior on rotation {
                            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                        }

                        Rectangle {
                            anchors.top: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 40
                            height: 40
                            radius: 20
                            color: colors.primary
                        }
                    }

                    // Center dot
                    Rectangle {
                        anchors.centerIn: parent
                        width: 8
                        height: 8
                        radius: 4
                        color: colors.primary
                    }

                    // Hour/Minute markers
                    Repeater {
                        model: mode === "hours" ? (is24Hour ? 24 : 12) : 12

                        Item {
                            anchors.centerIn: parent
                            width: parent.width
                            height: parent.height

                            property int value: mode === "hours" ?
                                (is24Hour ? index : (index === 0 ? 12 : index)) :
                                index * 5
                            property bool isSelected: mode === "hours" ?
                                (is24Hour ? hours === index : displayHours === value) :
                                Math.floor(minutes / 5) === index
                            property real angle: index * (mode === "hours" ? (is24Hour ? 15 : 30) : 30) - 90
                            property real radius: parent.width / 2 - 40

                            Rectangle {
                                x: parent.width / 2 + parent.radius * Math.cos(parent.angle * Math.PI / 180) - 20
                                y: parent.height / 2 + parent.radius * Math.sin(parent.angle * Math.PI / 180) - 20
                                width: 40
                                height: 40
                                radius: 20
                                color: isSelected ? colors.primary : "transparent"

                                Text {
                                    anchors.centerIn: parent
                                    text: mode === "hours" ? parent.parent.value :
                                        (parent.parent.value < 10 ? "0" : "") + parent.parent.value
                                    font.family: "Roboto"
                                    font.pixelSize: 16
                                    color: isSelected ? colors.onPrimary : colors.onSurface

                                    Behavior on color {
                                        ColorAnimation { duration: 150 }
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        if (mode === "hours") {
                                            hours = is24Hour ? index : (index === 0 ? 12 : index)
                                            if (!is24Hour && !isAM && hours !== 12) hours += 12
                                            if (!is24Hour && isAM && hours === 12) hours = 0
                                            mode = "minutes"
                                        } else {
                                            minutes = index * 5
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Actions
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 52
                Layout.leftMargin: 12
                Layout.rightMargin: 12
                Layout.bottomMargin: 12
                spacing: 8

                Item { Layout.fillWidth: true }

                Item {
                    Layout.preferredWidth: cancelLabel.implicitWidth + 24
                    Layout.preferredHeight: 40

                    Rectangle {
                        anchors.fill: parent
                        radius: 20
                        color: colors.primary
                        opacity: cancelMouse.containsMouse ? 0.08 : 0
                    }

                    Text {
                        id: cancelLabel
                        anchors.centerIn: parent
                        text: "Cancel"
                        font.family: "Roboto"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        color: colors.primary
                    }

                    MouseArea {
                        id: cancelMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.cancelled()
                    }
                }

                Item {
                    Layout.preferredWidth: okLabel.implicitWidth + 24
                    Layout.preferredHeight: 40

                    Rectangle {
                        anchors.fill: parent
                        radius: 20
                        color: colors.primary
                        opacity: okMouse.containsMouse ? 0.08 : 0
                    }

                    Text {
                        id: okLabel
                        anchors.centerIn: parent
                        text: "OK"
                        font.family: "Roboto"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        color: colors.primary
                    }

                    MouseArea {
                        id: okMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            var h = hours
                            if (!is24Hour) {
                                if (isAM && h === 12) h = 0
                                else if (!isAM && h !== 12) h += 12
                            }
                            timeSelected(h, minutes)
                        }
                    }
                }
            }
        }
    }

    Accessible.role: Accessible.Dialog
    Accessible.name: "Time picker"
}
