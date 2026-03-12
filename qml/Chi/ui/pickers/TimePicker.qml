import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../theme" as Theme
import "../common" as Common

Item {
    id: root

    property int hours: 12
    property int minutes: 0
    property bool is24Hour: false
    property bool isAM: true
    property bool showHeader: true
    property bool showActions: true
    property bool enabled: true
    property string mode: "hours"
    property bool inputMode: false

    signal timeSelected(int hours, int minutes)
    signal cancelled()

    readonly property int _displayH: {
        if (is24Hour) return hours
        var h = hours % 12
        return h === 0 ? 12 : h
    }

    readonly property string formattedTime:
        (_displayH < 10 ? "0" : "") + _displayH + ":"
        + (minutes < 10 ? "0" : "") + minutes

    implicitWidth: 328
    implicitHeight: _bg.height

    readonly property var    _c:  Theme.ChiTheme.colors
    readonly property var    _t:  Theme.ChiTheme.typography
    readonly property var    _m:  Theme.ChiTheme.motion
    readonly property string _ff: Theme.ChiTheme.fontFamily

    // ─── Clock geometry ───────────────────────────────────
    // M3: dial is 256dp, numbers at 36dp inset from edge
    // Tip circle 48dp, so hand reaches center of number ring
    readonly property real _dialSize: Math.min(_clockArea.width, _clockArea.height)
    readonly property real _dialR: _dialSize / 2
    readonly property real _numberR: _dialR - 36
    readonly property real _tipSize: 48

    // ─── Hand angle ───────────────────────────────────────
    readonly property real _handAngle: {
        if (mode === "hours") {
            if (is24Hour) return hours * 15
            return _displayH * 30
        }
        return minutes * 6
    }

    // ═══════════════════════════════════════════════════════
    // BACKGROUND
    // ═══════════════════════════════════════════════════════
    Rectangle {
        id: _bg
        width: root.width
        height: _mainCol.implicitHeight + 12
        radius: 28
        color: _c.surfaceContainerHigh

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowVerticalOffset: 6
            shadowBlur: 0.4
            shadowColor: Qt.rgba(0, 0, 0, 0.18)
        }

        MouseArea {
            anchors.fill: parent
            onPressed: function(e) { e.accepted = true }
        }

        ColumnLayout {
            id: _mainCol
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 0

            // ── Header ────────────────────────────────────
            Item {
                visible: root.showHeader
                Layout.fillWidth: true
                Layout.preferredHeight: _headerInner.implicitHeight + 36

                ColumnLayout {
                    id: _headerInner
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.leftMargin: 24
                    anchors.rightMargin: 24
                    anchors.topMargin: 16
                    spacing: 12

                    Text {
                        text: root.inputMode ? "Enter time" : "Select time"
                        font.family: _ff
                        font.pixelSize: _t.labelMedium.size
                        font.weight: _t.labelMedium.weight
                        color: _c.onSurfaceVariant
                    }

                    RowLayout {
                        spacing: 2

                        // Hours selector
                        Rectangle {
                            Layout.preferredWidth: 56
                            Layout.preferredHeight: 48
                            radius: 12
                            color: root.mode === "hours"
                                   ? _c.primaryContainer
                                   : _c.surfaceContainerHighest

                            TextInput {
                                id: _hourInput
                                anchors.fill: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.family: _ff
                                font.pixelSize: 28
                                font.weight: Font.Medium
                                color: root.mode === "hours"
                                       ? _c.onPrimaryContainer
                                       : _c.onSurface
                                selectionColor: _c.primary
                                selectedTextColor: _c.onPrimary
                                maximumLength: 2
                                readOnly: !root.inputMode
                                inputMethodHints: Qt.ImhDigitsOnly
                                validator: IntValidator {
                                    bottom: root.is24Hour ? 0 : 1
                                    top: root.is24Hour ? 23 : 12
                                }
                                text: (root._displayH < 10 ? "0" : "") + root._displayH

                                onTextChanged: {
                                    if (!root.inputMode) return
                                    if (text.length === 2) {
                                        var v = parseInt(text)
                                        if (!isNaN(v)) {
                                            if (root.is24Hour)
                                                root.hours = Math.max(0, Math.min(23, v))
                                            else
                                                root._setHour12(v)
                                        }
                                        root.mode = "minutes"
                                        _minInput.forceActiveFocus()
                                        _minInput.selectAll()
                                    }
                                }

                                onEditingFinished: {
                                    var v = parseInt(text)
                                    if (isNaN(v)) return
                                    if (root.is24Hour)
                                        root.hours = Math.max(0, Math.min(23, v))
                                    else
                                        root._setHour12(v)
                                }

                                onActiveFocusChanged: {
                                    if (activeFocus && root.inputMode) selectAll()
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    visible: !root.inputMode
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.mode = "hours"
                                }
                            }
                        }

                        Text {
                            text: ":"
                            font.family: _ff
                            font.pixelSize: 28
                            font.weight: Font.Medium
                            color: _c.onSurface
                            Layout.alignment: Qt.AlignVCenter
                        }

                        // Minutes selector
                        Rectangle {
                            Layout.preferredWidth: 56
                            Layout.preferredHeight: 48
                            radius: 12
                            color: root.mode === "minutes"
                                   ? _c.primaryContainer
                                   : _c.surfaceContainerHighest

                            TextInput {
                                id: _minInput
                                anchors.fill: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.family: _ff
                                font.pixelSize: 28
                                font.weight: Font.Medium
                                color: root.mode === "minutes"
                                       ? _c.onPrimaryContainer
                                       : _c.onSurface
                                selectionColor: _c.primary
                                selectedTextColor: _c.onPrimary
                                maximumLength: 2
                                readOnly: !root.inputMode
                                inputMethodHints: Qt.ImhDigitsOnly
                                validator: IntValidator { bottom: 0; top: 59 }
                                text: (root.minutes < 10 ? "0" : "") + root.minutes

                                onTextChanged: {
                                    if (!root.inputMode) return
                                    if (text.length === 2) {
                                        var v = parseInt(text)
                                        if (!isNaN(v))
                                            root.minutes = Math.max(0, Math.min(59, v))
                                    }
                                }

                                onEditingFinished: {
                                    var v = parseInt(text)
                                    if (!isNaN(v))
                                        root.minutes = Math.max(0, Math.min(59, v))
                                }

                                onActiveFocusChanged: {
                                    if (activeFocus && root.inputMode) selectAll()
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    visible: !root.inputMode
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.mode = "minutes"
                                }
                            }
                        }

                        Item { Layout.fillWidth: true }

                        // AM/PM segmented selector (M3)
                        Rectangle {
                            visible: !root.is24Hour
                            Layout.preferredWidth: 52
                            Layout.preferredHeight: 48
                            radius: 8
                            color: "transparent"
                            border.width: 1
                            border.color: _c.outline

                            Column {
                                anchors.fill: parent
                                anchors.margins: 1

                                // AM half
                                Item {
                                    width: parent.width
                                    height: (parent.height - 1) / 2

                                    Rectangle {
                                        anchors.fill: parent
                                        color: root.isAM ? _c.tertiaryContainer : "transparent"

                                        // Top corners only
                                        radius: root.isAM ? 7 : 0
                                        Rectangle {
                                            visible: root.isAM
                                            anchors.bottom: parent.bottom
                                            width: parent.width
                                            height: parent.radius
                                            color: parent.color
                                        }
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        text: "AM"
                                        font.family: _ff
                                        font.pixelSize: _t.labelLarge.size
                                        font.weight: Font.Bold
                                        color: root.isAM ? _c.onTertiaryContainer : _c.onSurfaceVariant
                                        opacity: root.isAM ? 1.0 : 0.6
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: root.isAM = true
                                    }
                                }

                                // Divider
                                Rectangle {
                                    width: parent.width
                                    height: 1
                                    color: _c.outline
                                }

                                // PM half
                                Item {
                                    width: parent.width
                                    height: (parent.height - 1) / 2

                                    Rectangle {
                                        anchors.fill: parent
                                        color: !root.isAM ? _c.tertiaryContainer : "transparent"

                                        // Bottom corners only
                                        radius: !root.isAM ? 7 : 0
                                        Rectangle {
                                            visible: !root.isAM
                                            anchors.top: parent.top
                                            width: parent.width
                                            height: parent.radius
                                            color: parent.color
                                        }
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        text: "PM"
                                        font.family: _ff
                                        font.pixelSize: _t.labelLarge.size
                                        font.weight: Font.Bold
                                        color: !root.isAM ? _c.onTertiaryContainer : _c.onSurfaceVariant
                                        opacity: !root.isAM ? 1.0 : 0.6
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: root.isAM = false
                                    }
                                }
                            }
                        }
                    }
                }

                // Divider
                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 1
                    color: _c.outlineVariant
                }
            }

            // ── Dial clock face ───────────────────────────
            Item {
                id: _clockArea
                visible: !root.inputMode
                Layout.fillWidth: true
                Layout.preferredHeight: width - 40
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                Layout.topMargin: 12
                Layout.bottomMargin: 4

                Rectangle {
                    id: _dial
                    anchors.centerIn: parent
                    width: root._dialSize
                    height: width
                    radius: width / 2
                    color: _c.surfaceContainerHighest

                    // ── Selector track (hand line) ────────
                    Rectangle {
                        id: _track
                        width: 2
                        height: root._numberR
                        color: _c.primary
                        antialiasing: true

                        // Position: bottom of this rect = center of dial
                        x: _dial.width / 2 - 1
                        y: _dial.height / 2 - height
                        transformOrigin: Item.Bottom

                        rotation: root._handAngle

                        Behavior on rotation {
                            RotationAnimation {
                                duration: 180
                                direction: RotationAnimation.Shortest
                                easing.type: Easing.OutCubic
                            }
                        }

                        // ── Selector handle (tip) ─────────
                        Rectangle {
                            width: root._tipSize
                            height: root._tipSize
                            radius: root._tipSize / 2
                            color: _c.primary
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: -(root._tipSize - parent.width) / 2 + (root._tipSize / 2 - root._tipSize / 2)
                            y: -height / 2 + 1
                        }
                    }

                    // ── Selector center dot ───────────────
                    Rectangle {
                        anchors.centerIn: parent
                        width: 8
                        height: 8
                        radius: 4
                        color: _c.primary
                        z: 2
                    }

                    // ── Number labels ─────────────────────
                    Repeater {
                        id: _labels
                        model: root.mode === "hours"
                               ? (root.is24Hour ? 24 : 12)
                               : 12

                        Item {
                            required property int index

                            property int value: {
                                if (root.mode !== "hours") return index * 5
                                if (root.is24Hour) return index
                                return index === 0 ? 12 : index
                            }

                            property bool isSelected: {
                                if (root.mode === "hours") {
                                    if (root.is24Hour) return root.hours === index
                                    return root._displayH === value
                                }
                                return Math.floor(root.minutes / 5) === index
                            }

                            // 0° = 12 o'clock, clockwise
                            property real deg: {
                                if (root.mode === "hours")
                                    return index * (root.is24Hour ? 15 : 30)
                                return index * 30
                            }
                            property real rad: deg * Math.PI / 180

                            x: _dial.width / 2 + root._numberR * Math.sin(rad) - width / 2
                            y: _dial.height / 2 - root._numberR * Math.cos(rad) - height / 2
                            width: root._tipSize
                            height: root._tipSize

                            // Hover bg
                            Rectangle {
                                anchors.fill: parent
                                radius: root._tipSize / 2
                                color: _c.onSurface
                                opacity: !parent.isSelected && _numMA.containsMouse ? 0.08 : 0
                            }

                            Text {
                                anchors.centerIn: parent
                                text: {
                                    var v = parent.value
                                    if (root.mode === "hours") return String(v)
                                    return (v < 10 ? "0" : "") + v
                                }
                                font.family: _ff
                                font.pixelSize: _t.bodyLarge.size
                                color: parent.isSelected ? _c.onPrimary : _c.onSurface
                                z: 3
                            }

                            MouseArea {
                                id: _numMA
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root._selectByIndex(parent.index)
                            }
                        }
                    }

                    // ── Touch/drag on dial ────────────────
                    MouseArea {
                        id: _dragMA
                        anchors.fill: parent
                        preventStealing: true

                        function _handle(mx, my) {
                            var dx = mx - width / 2
                            var dy = my - height / 2
                            var dist = Math.sqrt(dx * dx + dy * dy)
                            if (dist < 20) return

                            // Angle: 0 at 12 o'clock, clockwise
                            var a = Math.atan2(dx, -dy) * 180 / Math.PI
                            if (a < 0) a += 360

                            if (root.mode === "hours") {
                                var steps = root.is24Hour ? 24 : 12
                                var idx = Math.round(a / (360 / steps)) % steps
                                root._setHourByIndex(idx)
                            } else {
                                root.minutes = Math.round(a / 6) % 60
                            }
                        }

                        onPressed: function(e) { _handle(e.x, e.y) }
                        onPositionChanged: function(e) { if (pressed) _handle(e.x, e.y) }
                        onReleased: {
                            if (root.mode === "hours") root.mode = "minutes"
                        }
                    }
                }
            }

            // ── Input mode (keyboard entry) ───────────────
            Item {
                visible: root.inputMode
                Layout.fillWidth: true
                Layout.preferredHeight: 120
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.topMargin: 12

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 8

                    Text {
                        text: "Use keyboard to enter time"
                        font.family: _ff
                        font.pixelSize: _t.bodyMedium.size
                        color: _c.onSurfaceVariant
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Tap the time fields above to type"
                        font.family: _ff
                        font.pixelSize: _t.bodySmall.size
                        color: _c.onSurfaceVariant
                        opacity: 0.7
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            // ── Bottom bar: mode toggle + actions ─────────
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                Layout.leftMargin: 12
                Layout.rightMargin: 12
                Layout.topMargin: 4
                spacing: 4

                // Keyboard / dial toggle
                Rectangle {
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    radius: 20
                    color: _toggleMA.containsMouse
                           ? Qt.rgba(_c.onSurface.r, _c.onSurface.g, _c.onSurface.b, 0.08)
                           : "transparent"

                    Common.Icon {
                        anchors.centerIn: parent
                        source: root.inputMode ? "schedule" : "keyboard"
                        size: 20
                        color: _c.onSurfaceVariant
                    }

                    MouseArea {
                        id: _toggleMA
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.inputMode = !root.inputMode
                            if (root.inputMode) {
                                if (root.mode === "hours")
                                    _hourInput.forceActiveFocus()
                                else
                                    _minInput.forceActiveFocus()
                            }
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                // Actions
                Rectangle {
                    visible: root.showActions
                    Layout.preferredWidth: _cancelTxt.implicitWidth + 24
                    Layout.preferredHeight: 40
                    radius: 20
                    color: _cancelMA.containsMouse
                           ? Qt.rgba(_c.primary.r, _c.primary.g, _c.primary.b, 0.08)
                           : "transparent"

                    Text {
                        id: _cancelTxt
                        anchors.centerIn: parent
                        text: "Cancel"
                        font.family: _ff
                        font.pixelSize: _t.labelLarge.size
                        font.weight: _t.labelLarge.weight
                        color: _c.primary
                    }

                    MouseArea {
                        id: _cancelMA
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.cancelled()
                    }
                }

                Rectangle {
                    visible: root.showActions
                    Layout.preferredWidth: _okTxt.implicitWidth + 24
                    Layout.preferredHeight: 40
                    radius: 20
                    color: _okMA.containsMouse
                           ? Qt.rgba(_c.primary.r, _c.primary.g, _c.primary.b, 0.08)
                           : "transparent"

                    Text {
                        id: _okTxt
                        anchors.centerIn: parent
                        text: "OK"
                        font.family: _ff
                        font.pixelSize: _t.labelLarge.size
                        font.weight: _t.labelLarge.weight
                        color: _c.primary
                    }

                    MouseArea {
                        id: _okMA
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            var h = root.hours
                            if (!root.is24Hour) {
                                if (root.isAM && h === 12) h = 0
                                else if (!root.isAM && h !== 12) h += 12
                            }
                            root.timeSelected(h, root.minutes)
                        }
                    }
                }
            }
        }
    }

    // ─── Internal helpers ─────────────────────────────────
    function _selectByIndex(idx) {
        if (mode === "hours") {
            _setHourByIndex(idx)
            mode = "minutes"
        } else {
            minutes = idx * 5
        }
    }

    function _setHourByIndex(idx) {
        if (is24Hour) {
            hours = idx
        } else {
            var h = idx === 0 ? 12 : idx
            if (!isAM && h !== 12) h += 12
            if (isAM && h === 12) h = 0
            hours = h
        }
    }

    function _setHour12(val) {
        var h = Math.max(1, Math.min(12, val))
        if (!isAM && h !== 12) h += 12
        if (isAM && h === 12) h = 0
        hours = h
    }

    Accessible.role: Accessible.Dialog
    Accessible.name: "Time picker"
}
