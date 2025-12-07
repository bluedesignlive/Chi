import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Item {
    id: root

    property date selectedDate: new Date()
    property date currentMonth: new Date()
    property date minDate: new Date(1900, 0, 1)
    property date maxDate: new Date(2100, 11, 31)
    property bool showHeader: true
    property bool enabled: true
    property int firstDayOfWeek: 0           // 0 = Sunday, 1 = Monday

    signal dateSelected(date selected)
    signal cancelled()

    readonly property var monthNames: ["January", "February", "March", "April", "May", "June",
                                        "July", "August", "September", "October", "November", "December"]
    readonly property var dayNames: firstDayOfWeek === 1 ?
        ["M", "T", "W", "T", "F", "S", "S"] : ["S", "M", "T", "W", "T", "F", "S"]

    implicitWidth: 328
    implicitHeight: showHeader ? 456 : 360

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
                Layout.preferredHeight: 120
                color: colors.surfaceContainerHigh

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 24
                    spacing: 8

                    Text {
                        text: "Select date"
                        font.family: "Roboto"
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        color: colors.onSurfaceVariant

                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }

                    Text {
                        text: Qt.formatDate(selectedDate, "ddd, MMM d")
                        font.family: "Roboto"
                        font.pixelSize: 32
                        font.weight: Font.Normal
                        color: colors.onSurface

                        Behavior on color {
                            ColorAnimation { duration: 200 }
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

            // Month/Year selector
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 56
                Layout.leftMargin: 12
                Layout.rightMargin: 12
                spacing: 4

                // Month/Year button
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40

                    Row {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 4

                        Text {
                            text: monthNames[currentMonth.getMonth()] + " " + currentMonth.getFullYear()
                            font.family: "Roboto"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: colors.onSurfaceVariant
                            anchors.verticalCenter: parent.verticalCenter

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                        }

                        Text {
                            text: "▼"
                            font.pixelSize: 10
                            color: colors.onSurfaceVariant
                            anchors.verticalCenter: parent.verticalCenter

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        // TODO: Open year/month picker
                    }
                }

                // Previous month
                Item {
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40

                    Rectangle {
                        anchors.fill: parent
                        radius: 20
                        color: colors.onSurface
                        opacity: prevMouse.containsMouse ? 0.08 : 0
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "◀"
                        font.pixelSize: 16
                        color: colors.onSurfaceVariant
                    }

                    MouseArea {
                        id: prevMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            var d = new Date(currentMonth)
                            d.setMonth(d.getMonth() - 1)
                            currentMonth = d
                        }
                    }
                }

                // Next month
                Item {
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40

                    Rectangle {
                        anchors.fill: parent
                        radius: 20
                        color: colors.onSurface
                        opacity: nextMouse.containsMouse ? 0.08 : 0
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "▶"
                        font.pixelSize: 16
                        color: colors.onSurfaceVariant
                    }

                    MouseArea {
                        id: nextMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            var d = new Date(currentMonth)
                            d.setMonth(d.getMonth() + 1)
                            currentMonth = d
                        }
                    }
                }
            }

            // Day names header
            Row {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                Layout.leftMargin: 12
                Layout.rightMargin: 12

                Repeater {
                    model: dayNames

                    Item {
                        width: (parent.width) / 7
                        height: 40

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            font.family: "Roboto"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: colors.onSurface

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                        }
                    }
                }
            }

            // Calendar grid
            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: 12
                Layout.rightMargin: 12
                Layout.bottomMargin: 8
                columns: 7
                rowSpacing: 0
                columnSpacing: 0

                Repeater {
                    model: 42

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40

                        property int dayOffset: {
                            var firstDay = new Date(currentMonth.getFullYear(), currentMonth.getMonth(), 1)
                            var offset = firstDay.getDay() - firstDayOfWeek
                            if (offset < 0) offset += 7
                            return offset
                        }

                        property int dayNumber: index - dayOffset + 1
                        property int daysInMonth: new Date(currentMonth.getFullYear(), currentMonth.getMonth() + 1, 0).getDate()
                        property bool isCurrentMonth: dayNumber >= 1 && dayNumber <= daysInMonth
                        property date thisDate: new Date(currentMonth.getFullYear(), currentMonth.getMonth(), dayNumber)
                        property bool isSelected: isCurrentMonth &&
                            thisDate.getDate() === selectedDate.getDate() &&
                            thisDate.getMonth() === selectedDate.getMonth() &&
                            thisDate.getFullYear() === selectedDate.getFullYear()
                        property bool isToday: {
                            var today = new Date()
                            return isCurrentMonth &&
                                thisDate.getDate() === today.getDate() &&
                                thisDate.getMonth() === today.getMonth() &&
                                thisDate.getFullYear() === today.getFullYear()
                        }
                        property bool isDisabled: !isCurrentMonth || thisDate < minDate || thisDate > maxDate

                        // Selection circle
                        Rectangle {
                            anchors.centerIn: parent
                            width: 40
                            height: 40
                            radius: 20
                            color: isSelected ? colors.primary : "transparent"
                            border.width: isToday && !isSelected ? 1 : 0
                            border.color: colors.primary

                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }

                        // Hover state
                        Rectangle {
                            anchors.centerIn: parent
                            width: 40
                            height: 40
                            radius: 20
                            color: colors.onSurface
                            opacity: !isDisabled && !isSelected && dayMouse.containsMouse ? 0.08 : 0

                            Behavior on opacity {
                                NumberAnimation { duration: 100 }
                            }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: isCurrentMonth ? dayNumber : ""
                            font.family: "Roboto"
                            font.pixelSize: 14
                            color: {
                                if (isSelected) return colors.onPrimary
                                if (isDisabled) return colors.onSurface
                                return colors.onSurface
                            }
                            opacity: isDisabled ? 0.38 : 1

                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }

                        MouseArea {
                            id: dayMouse
                            anchors.fill: parent
                            enabled: !isDisabled && root.enabled
                            hoverEnabled: true
                            cursorShape: !isDisabled ? Qt.PointingHandCursor : Qt.ArrowCursor

                            onClicked: {
                                selectedDate = thisDate
                                dateSelected(thisDate)
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
                        onClicked: dateSelected(selectedDate)
                    }
                }
            }
        }
    }

    Accessible.role: Accessible.Dialog
    Accessible.name: "Date picker"
}
