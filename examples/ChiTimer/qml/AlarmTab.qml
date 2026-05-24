import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Chi

Item {
    id: root

    readonly property var colors: ChiTheme.colors
    readonly property string fontFamily: ChiTheme.fontFamily

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

    ListModel {
        id: alarmModel
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
        model: alarmModel

        delegate: Item {
            width: alarmList.width
            height: 88

            Rectangle {
                anchors.fill: parent
                radius: 16
                color: model.enabled ? colors.surfaceContainerLow : colors.surfaceVariant
                opacity: model.enabled ? 1.0 : 0.6

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    spacing: 2

                    Label {
                        text: formatAlarmTime(model.hour, model.minute)
                        font.family: root.fontFamily
                        font.pixelSize: 32
                        font.weight: Font.Light
                        color: colors.onSurface
                    }

                    Label {
                        text: model.label
                        font.family: root.fontFamily
                        font.pixelSize: 14
                        color: colors.onSurfaceVariant
                        visible: model.label !== ""
                    }

                    Label {
                        text: formatRepeatDays(model.repeat)
                        font.family: root.fontFamily
                        font.pixelSize: 12
                        color: colors.onSurfaceVariant
                        visible: model.repeat && model.repeat.length > 0
                    }
                }

                Switch {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 16
                    checked: model.enabled
                    onToggled: alarmModel.setProperty(index, "enabled", checked)
                }
            }
        }

        Label {
            anchors.centerIn: parent
            text: "No alarms set"
            font.family: root.fontFamily
            font.pixelSize: 16
            color: colors.onSurfaceVariant
            visible: alarmModel.count === 0
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
            alarmTimePicker.hours = 7
            alarmTimePicker.minutes = 0
            labelField.text = ""
            monBtn.selected = false
            tueBtn.selected = false
            wedBtn.selected = false
            thuBtn.selected = false
            friBtn.selected = false
            satBtn.selected = false
            sunBtn.selected = false
            addSheet.open = true
        }
    }

    BottomSheet {
        id: addSheet
        variant: "modal"
        minHeight: 520
        maxHeight: parent.height * 0.85
        dismissible: true

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 24
            spacing: 20

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
            }

            TextField {
                id: labelField
                placeholderText: "Label (optional)"
                Layout.fillWidth: true
            }

            RowLayout {
                spacing: 6
                Layout.alignment: Qt.AlignHCenter

                IconButtonToggle { id: monBtn; icon: "calendar_clear_day"; selectedIcon: "calendar_month"; tooltip: "Monday"; variant: "tonal" }
                IconButtonToggle { id: tueBtn; icon: "calendar_clear_day"; selectedIcon: "calendar_month"; tooltip: "Tuesday"; variant: "tonal" }
                IconButtonToggle { id: wedBtn; icon: "calendar_clear_day"; selectedIcon: "calendar_month"; tooltip: "Wednesday"; variant: "tonal" }
                IconButtonToggle { id: thuBtn; icon: "calendar_clear_day"; selectedIcon: "calendar_month"; tooltip: "Thursday"; variant: "tonal" }
                IconButtonToggle { id: friBtn; icon: "calendar_clear_day"; selectedIcon: "calendar_month"; tooltip: "Friday"; variant: "tonal" }
                IconButtonToggle { id: satBtn; icon: "calendar_clear_day"; selectedIcon: "calendar_month"; tooltip: "Saturday"; variant: "tonal" }
                IconButtonToggle { id: sunBtn; icon: "calendar_clear_day"; selectedIcon: "calendar_month"; tooltip: "Sunday"; variant: "tonal" }
            }

            Label {
                text: {
                    var names = []
                    if (monBtn.selected) names.push("Mon")
                    if (tueBtn.selected) names.push("Tue")
                    if (wedBtn.selected) names.push("Wed")
                    if (thuBtn.selected) names.push("Thu")
                    if (friBtn.selected) names.push("Fri")
                    if (satBtn.selected) names.push("Sat")
                    if (sunBtn.selected) names.push("Sun")
                    return names.length > 0 ? names.join(", ") : "No repeat"
                }
                font.family: root.fontFamily
                font.pixelSize: 13
                color: colors.onSurfaceVariant
                Layout.alignment: Qt.AlignHCenter
            }

            Item {
                Layout.fillHeight: true
            }

            Button {
                text: "Save"
                variant: "filled"
                Layout.fillWidth: true
                onClicked: {
                    var days = []
                    if (monBtn.selected) days.push(1)
                    if (tueBtn.selected) days.push(2)
                    if (wedBtn.selected) days.push(3)
                    if (thuBtn.selected) days.push(4)
                    if (friBtn.selected) days.push(5)
                    if (satBtn.selected) days.push(6)
                    if (sunBtn.selected) days.push(0)
                    alarmModel.append({
                        hour: alarmTimePicker.hours,
                        minute: alarmTimePicker.minutes,
                        label: labelField.text,
                        repeat: days,
                        enabled: true
                    })
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
        var mapped = days.map(function(d) { return names[d] })
        return mapped.join(", ")
    }

    function pad(n) {
        return String(n).padStart(2, '0')
    }
}
