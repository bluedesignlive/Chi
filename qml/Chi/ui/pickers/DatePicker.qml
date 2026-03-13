import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls.Basic
import "../../theme" as Theme
import "../common" as Common

Item {
    id: root

    property date selectedDate: new Date()
    property date currentMonth: new Date()
    property date minDate: new Date(1900, 0, 1)
    property date maxDate: new Date(2100, 11, 31)
    property bool showHeader: true
    property bool showActions: true
    property bool enabled: true
    property int firstDayOfWeek: 0

    signal dateSelected(date selected)
    signal cancelled()

    readonly property var _monthNames: [
        "January","February","March","April","May","June",
        "July","August","September","October","November","December"
    ]
    readonly property var _dayNames: firstDayOfWeek === 1
        ? ["M","T","W","T","F","S","S"]
        : ["S","M","T","W","T","F","S"]

    implicitWidth: 328
    implicitHeight: _bg.height

    readonly property var    _c:  Theme.ChiTheme.colors
    readonly property var    _t:  Theme.ChiTheme.typography
    readonly property var    _m:  Theme.ChiTheme.motion
    readonly property string _ff: Theme.ChiTheme.fontFamily

    // ─── Month index helpers ──────────────────────────────
    readonly property int _baseYear: 1900
    readonly property int _monthCount: (2101 - _baseYear) * 12

    function _monthToIndex(d) {
        return (d.getFullYear() - _baseYear) * 12 + d.getMonth()
    }

    function _indexToDate(idx) {
        return new Date(_baseYear + Math.floor(idx / 12), idx % 12, 1)
    }

    // ─── State ────────────────────────────────────────────
    property bool _yearPickerOpen: false
    property bool _syncing: false

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

        // Eat clicks so dialog scrim doesn't close
        MouseArea {
            anchors.fill: parent
            onPressed: function(e) { e.accepted = true }
        }

        ColumnLayout {
            id: _mainCol
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 0
            spacing: 0

            // ── Header ────────────────────────────────────
            Rectangle {
                visible: root.showHeader
                Layout.fillWidth: true
                Layout.preferredHeight: 120
                color: "transparent"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 24
                    anchors.rightMargin: 24
                    anchors.topMargin: 24
                    anchors.bottomMargin: 16
                    spacing: 8

                    Text {
                        text: "Select date"
                        font.family: _ff
                        font.pixelSize: _t.labelMedium.size
                        font.weight: _t.labelMedium.weight
                        color: _c.onSurfaceVariant
                    }

                    Text {
                        text: Qt.formatDate(root.selectedDate, "ddd, MMM d")
                        font.family: _ff
                        font.pixelSize: 32
                        font.weight: Font.Normal
                        color: _c.onSurface
                    }
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 1
                    color: _c.outlineVariant
                }
            }

            // ── Month/Year nav bar ────────────────────────
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                Layout.leftMargin: 12
                Layout.rightMargin: 4
                spacing: 0

                // Month/Year label + dropdown toggle
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    radius: 20
                    color: _yearLabelMA.containsMouse
                           ? Qt.rgba(_c.onSurface.r, _c.onSurface.g, _c.onSurface.b, 0.08)
                           : "transparent"

                    RowLayout {
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 4

                        Text {
                            text: _monthNames[root.currentMonth.getMonth()] + " " + root.currentMonth.getFullYear()
                            font.family: _ff
                            font.pixelSize: _t.labelLarge.size
                            font.weight: _t.labelLarge.weight
                            color: _c.onSurfaceVariant
                        }

                        Common.Icon {
                            source: root._yearPickerOpen ? "arrow_drop_up" : "arrow_drop_down"
                            size: 20
                            color: _c.onSurfaceVariant
                        }
                    }

                    MouseArea {
                        id: _yearLabelMA
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root._yearPickerOpen = !root._yearPickerOpen
                    }
                }

                // Navigation buttons (hidden when year picker open)
                RowLayout {
                    visible: !root._yearPickerOpen
                    spacing: 0

                    Rectangle {
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: 40
                        radius: 20
                        color: _prevMA.containsMouse
                               ? Qt.rgba(_c.onSurface.r, _c.onSurface.g, _c.onSurface.b, 0.08)
                               : "transparent"

                        Common.Icon {
                            anchors.centerIn: parent
                            source: "chevron_left"
                            size: 24
                            color: _c.onSurfaceVariant
                        }

                        MouseArea {
                            id: _prevMA
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (_monthView.currentIndex > 0)
                                    _monthView.currentIndex--
                            }
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: 40
                        radius: 20
                        color: _nextMA.containsMouse
                               ? Qt.rgba(_c.onSurface.r, _c.onSurface.g, _c.onSurface.b, 0.08)
                               : "transparent"

                        Common.Icon {
                            anchors.centerIn: parent
                            source: "chevron_right"
                            size: 24
                            color: _c.onSurfaceVariant
                        }

                        MouseArea {
                            id: _nextMA
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (_monthView.currentIndex < _monthCount - 1)
                                    _monthView.currentIndex++
                            }
                        }
                    }
                }
            }

            // ── Day name headers ──────────────────────────
            Row {
                visible: !root._yearPickerOpen
                Layout.fillWidth: true
                Layout.preferredHeight: 28
                Layout.leftMargin: 12
                Layout.rightMargin: 12

                Repeater {
                    model: root._dayNames

                    Item {
                        width: parent.width / 7
                        height: parent.height

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            font.family: _ff
                            font.pixelSize: _t.bodySmall.size
                            font.weight: _t.bodySmall.weight
                            color: _c.onSurfaceVariant
                        }
                    }
                }
            }

            // ── Calendar grid (swipeable months) ──────────
            Item {
                visible: !root._yearPickerOpen
                Layout.fillWidth: true
                Layout.preferredHeight: _monthView.currentItem ? _monthView.currentItem.rowCount * 36 : 6 * 36
                Layout.leftMargin: 12
                Layout.rightMargin: 12
                clip: true

                ListView {
                    id: _monthView
                    anchors.fill: parent
                    orientation: ListView.Horizontal
                    snapMode: ListView.SnapOneItem
                    highlightRangeMode: ListView.StrictlyEnforceRange
                    highlightMoveDuration: _m.durationMedium
                    boundsBehavior: Flickable.StopAtBounds
                    cacheBuffer: width
                    model: root._monthCount
                    interactive: root.enabled

                    currentIndex: root._monthToIndex(root.currentMonth)

                    onCurrentIndexChanged: {
                        if (!root._syncing) {
                            root._syncing = true
                            root.currentMonth = root._indexToDate(currentIndex)
                            root._syncing = false
                        }
                    }

                    delegate: Item {
                        width: ListView.view.width
                        height: rowCount * 36

                        required property int index

                        property int year: root._baseYear + Math.floor(index / 12)
                        property int month: index % 12
                        property int daysInMonth: new Date(year, month + 1, 0).getDate()
                        property int dayOffset: {
                            var d = new Date(year, month, 1).getDay() - root.firstDayOfWeek
                            return d < 0 ? d + 7 : d
                        }
                        property int rowCount: Math.ceil((dayOffset + daysInMonth) / 7)

                        GridLayout {
                            anchors.fill: parent
                            columns: 7
                            rowSpacing: 0
                            columnSpacing: 0

                            Repeater {
                                model: 42

                                Item {
                                    required property int index

                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 36

                                    property int dayNum: index - dayOffset + 1
                                    property bool inMonth: dayNum >= 1 && dayNum <= daysInMonth
                                    property int thisYear: year
                                    property int thisMonth: month

                                    property bool isSelected: inMonth
                                        && dayNum === root.selectedDate.getDate()
                                        && thisMonth === root.selectedDate.getMonth()
                                        && thisYear === root.selectedDate.getFullYear()

                                    property bool isToday: {
                                        var t = new Date()
                                        return inMonth
                                            && dayNum === t.getDate()
                                            && thisMonth === t.getMonth()
                                            && thisYear === t.getFullYear()
                                    }

                                    property bool isDisabled: {
                                        if (!inMonth) return true
                                        var d = new Date(thisYear, thisMonth, dayNum)
                                        return d < root.minDate || d > root.maxDate
                                    }

                                    // Selection circle
                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: 36
                                        height: 36
                                        radius: 18
                                        color: isSelected ? _c.primary : "transparent"
                                        border.width: isToday && !isSelected ? 1 : 0
                                        border.color: _c.primary
                                    }

                                    // Hover
                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: 36
                                        height: 36
                                        radius: 18
                                        color: _c.onSurface
                                        opacity: !isDisabled && !isSelected && _dayMA.containsMouse ? 0.08 : 0
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        text: inMonth ? dayNum : ""
                                        font.family: _ff
                                        font.pixelSize: _t.bodyMedium.size
                                        color: isSelected ? _c.onPrimary : _c.onSurface
                                        opacity: isDisabled ? 0.38 : 1
                                    }

                                    MouseArea {
                                        id: _dayMA
                                        anchors.fill: parent
                                        enabled: !isDisabled && root.enabled
                                        hoverEnabled: true
                                        cursorShape: !isDisabled ? Qt.PointingHandCursor : Qt.ArrowCursor

                                        onClicked: {
                                            var d = new Date(thisYear, thisMonth, dayNum)
                                            root.selectedDate = d
                                            root.dateSelected(d)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // ── Year picker grid ──────────────────────────
            Item {
                visible: root._yearPickerOpen
                Layout.fillWidth: true
                Layout.preferredHeight: 5 * 52
                Layout.leftMargin: 12
                Layout.rightMargin: 12
                clip: true

                GridView {
                    id: _yearGrid
                    anchors.fill: parent
                    cellWidth: width / 3
                    cellHeight: 52
                    boundsBehavior: Flickable.StopAtBounds

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                        width: 4
                        contentItem: Rectangle {
                            implicitWidth: 4
                            radius: 2
                            color: _c.onSurfaceVariant
                            opacity: 0.4
                        }
                    }

                    model: root.maxDate.getFullYear() - root.minDate.getFullYear() + 1

                    Component.onCompleted: _scrollToCurrent()

                    function _scrollToCurrent() {
                        var idx = root.currentMonth.getFullYear() - root.minDate.getFullYear()
                        positionViewAtIndex(Math.max(0, idx - 6), GridView.Beginning)
                    }

                    Connections {
                        target: root
                        function on_YearPickerOpenChanged() {
                            if (root._yearPickerOpen)
                                _yearGrid._scrollToCurrent()
                        }
                    }

                    delegate: Item {
                        required property int index

                        width: _yearGrid.cellWidth
                        height: _yearGrid.cellHeight

                        property int yearVal: root.minDate.getFullYear() + index
                        property bool isCurrent: yearVal === root.currentMonth.getFullYear()
                        property bool isSelectedYear: yearVal === root.selectedDate.getFullYear()

                        Rectangle {
                            anchors.centerIn: parent
                            width: 76
                            height: 40
                            radius: 20
                            color: isSelectedYear ? _c.primary
                                 : (isCurrent ? _c.primaryContainer : "transparent")
                            border.width: isCurrent && !isSelectedYear ? 1 : 0
                            border.color: _c.primary
                        }

                        Rectangle {
                            anchors.centerIn: parent
                            width: 76
                            height: 40
                            radius: 20
                            color: _c.onSurface
                            opacity: _yearMA.containsMouse && !isSelectedYear ? 0.08 : 0
                        }

                        Text {
                            anchors.centerIn: parent
                            text: yearVal
                            font.family: _ff
                            font.pixelSize: _t.bodyLarge.size
                            font.weight: isSelectedYear || isCurrent ? Font.Medium : Font.Normal
                            color: isSelectedYear ? _c.onPrimary
                                 : (isCurrent ? _c.onPrimaryContainer : _c.onSurfaceVariant)
                        }

                        MouseArea {
                            id: _yearMA
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                var m = root.currentMonth.getMonth()
                                root.currentMonth = new Date(yearVal, m, 1)
                                // Sync ListView without animation for large jumps
                                root._syncing = true
                                _monthView.highlightMoveDuration = 0
                                _monthView.currentIndex = root._monthToIndex(root.currentMonth)
                                _monthView.highlightMoveDuration = root._m.durationMedium
                                root._syncing = false
                                root._yearPickerOpen = false
                            }
                        }
                    }
                }
            }

            // ── Actions ───────────────────────────────────
            RowLayout {
                visible: root.showActions
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                Layout.leftMargin: 12
                Layout.rightMargin: 12
                spacing: 8

                Item { Layout.fillWidth: true }

                Rectangle {
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
                        onClicked: root.dateSelected(root.selectedDate)
                    }
                }
            }
        }
    }

    // ─── Public helpers ───────────────────────────────────
    function goToDate(d) {
        currentMonth = new Date(d.getFullYear(), d.getMonth(), 1)
        _syncing = true
        _monthView.currentIndex = _monthToIndex(currentMonth)
        _syncing = false
    }

    function goToToday() {
        goToDate(new Date())
    }

    Accessible.role: Accessible.Dialog
    Accessible.name: "Date picker"
}
