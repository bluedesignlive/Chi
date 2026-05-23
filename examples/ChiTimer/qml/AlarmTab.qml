import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Chi

Item {
    id: root

    readonly property var colors: ChiTheme.colors
    readonly property string fontFamily: ChiTheme.fontFamily

    property var alarms: []

    Label {
        id: titleLabel
        text: "Alarms"
        font.family: root.fontFamily
        font.pixelSize: 28
        font.weight: Font.Light
        color: colors.onSurface
        anchors.top: parent.top
        anchors.topMargin: 24
        anchors.horizontalCenter: parent.horizontalCenter
    }

    ListView {
        id: alarmList
        anchors.top: titleLabel.bottom
        anchors.topMargin: 16
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        clip: true
        spacing: 8
        model: root.alarms

        delegate: Item {
            required property var modelData
            required property int index

            width: alarmList.width
            height: 88

            Rectangle {
                anchors.fill: parent
                radius: 16
                color: modelData.enabled ? colors.surfaceContainerLow : colors.surfaceVariant
                opacity: modelData.enabled ? 1.0 : 0.6

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    spacing: 2

                    Label {
                        text: formatAlarmTime(modelData.hour, modelData.minute)
                        font.family: root.fontFamily
                        font.pixelSize: 32
                        font.weight: Font.Light
                        color: colors.onSurface
                    }

                    Label {
                        text: modelData.label
                        font.family: root.fontFamily
                        font.pixelSize: 14
                        color: colors.onSurfaceVariant
                        visible: modelData.label !== ""
                    }

                    Label {
                        text: formatRepeatDays(modelData.repeat)
                        font.family: root.fontFamily
                        font.pixelSize: 12
                        color: colors.onSurfaceVariant
                        visible: modelData.repeat && modelData.repeat.length > 0
                    }
                }

                Switch {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 16
                    checked: modelData.enabled
                    onToggled: {
                        var newAlarms = root.alarms.slice()
                        newAlarms[index] = Object.assign({}, newAlarms[index], { enabled: checked })
                        root.alarms = newAlarms
                    }
                }
            }
        }

        Label {
            anchors.centerIn: parent
            text: "No alarms set"
            font.family: root.fontFamily
            font.pixelSize: 16
            color: colors.onSurfaceVariant
            visible: root.alarms.length === 0
        }
    }

    Button {
        id: addButton
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 24
        text: "Add alarm"
        variant: "filled"
        onClicked: {
            newAlarmHour = 7
            newAlarmMinute = 0
            newAlarmLabel = ""
            newAlarmDays = []
            addSheet.open = true
        }
    }

    property int newAlarmHour: 7
    property int newAlarmMinute: 0
    property string newAlarmLabel: ""
    property var newAlarmDays: []

    BottomSheet {
        id: addSheet
        variant: "modal"
        minHeight: 480
        maxHeight: parent.height * 0.85
        dismissible: true

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 24
            spacing: 24

            Label {
                text: "New Alarm"
                font.family: root.fontFamily
                font.pixelSize: 24
                font.weight: Font.Medium
                color: colors.onSurface
                Layout.alignment: Qt.AlignHCenter
            }

            TimePicker {
                id: alarmTimePicker
                Layout.alignment: Qt.AlignHCenter
                hours: root.newAlarmHour
                minutes: root.newAlarmMinute
                onHoursChanged: root.newAlarmHour = hours
                onMinutesChanged: root.newAlarmMinute = minutes
            }

            TextField {
                id: labelField
                placeholderText: "Label (optional)"
                Layout.fillWidth: true
                onTextChanged: root.newAlarmLabel = text
            }

            RowLayout {
                spacing: 8
                Layout.fillWidth: true

                Repeater {
                    id: dayRepeater
                    model: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                    delegate: Item {
                        required property string modelData
                        required property int index

                        property bool selected: root.newAlarmDays.indexOf(index) >= 0

                        onSelectedChanged: {
                            var days = root.newAlarmDays.slice()
                            var pos = days.indexOf(index)
                            if (selected && pos < 0) days.push(index)
                            else if (!selected && pos >= 0) days.splice(pos, 1)
                            root.newAlarmDays = days
                        }

                        width: 40
                        height: 40

                        Rectangle {
                            anchors.fill: parent
                            radius: 20
                            color: parent.selected ? colors.primary : colors.surfaceContainerHigh

                            Label {
                                anchors.centerIn: parent
                                text: parent.parent.modelData.charAt(0)
                                font.family: root.fontFamily
                                font.pixelSize: 12
                                font.weight: parent.parent.selected ? Font.Bold : Font.Normal
                                color: parent.parent.selected ? colors.onPrimary : colors.onSurface
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: parent.parent.selected = !parent.parent.selected
                            }
                        }
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }

            Button {
                text: "Save"
                variant: "filled"
                Layout.fillWidth: true
                onClicked: {
                    root.alarms = root.alarms.concat([{
                        hour: root.newAlarmHour,
                        minute: root.newAlarmMinute,
                        label: root.newAlarmLabel,
                        repeat: root.newAlarmDays.slice(),
                        enabled: true
                    }])
                    addSheet.open = false
                }
            }
        }
    }

    function formatAlarmTime(hour, minute) {
        var ampm = hour < 12 ? "AM" : "PM"
        var h = hour % 12
        if (h === 0) h = 12
        return pad(h) + ":" + pad(minute) + " " + ampm
    }

    function formatRepeatDays(days) {
        if (!days || days.length === 0) return ""
        var names = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        if (days.length === 7) return "Every day"
        if (days.length === 5 && days.indexOf(1) >= 0 && days.indexOf(5) >= 0) return "Weekdays"
        if (days.length === 2 && days.indexOf(0) >= 0 && days.indexOf(6) >= 0) return "Weekends"
        return days.map(function(d) { return names[d] }).join(", ")
    }

    function pad(n) {
        return String(n).padStart(2, '0')
    }
}
