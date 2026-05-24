import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Chi

Item {
    id: root

    readonly property var colors: ChiTheme.colors
    readonly property string fontFamily: ChiTheme.fontFamily

    property int duration: 0
    property int remaining: 0
    property bool isRunning: false
    property bool isPaused: false
    property bool isCompleted: false

    readonly property bool isIdle: !isRunning && !isPaused && !isCompleted

    function setDuration(minutes) {
        duration = minutes * 60000
        remaining = duration
        isCompleted = false
    }

    Timer {
        id: countdown
        interval: 100
        repeat: true
        onTriggered: {
            root.remaining = Math.max(0, root.remaining - 100)
            if (root.remaining <= 0) {
                countdown.stop()
                root.isRunning = false
                root.isCompleted = true
            }
        }
    }

    Canvas {
        id: ringCanvas
        anchors.fill: parent
        visible: !root.isIdle
        onPaint: drawRing()
    }

    function drawRing() {
        var ctx = ringCanvas.getContext("2d")
        var w = ringCanvas.width, h = ringCanvas.height
        var cx = w / 2, cy = h / 2
        var r = Math.min(cx, cy) - 40

        ctx.clearRect(0, 0, w, h)

        ctx.beginPath()
        ctx.arc(cx, cy, r, 0, Math.PI * 2)
        ctx.strokeStyle = Qt.rgba(0,0,0,0.08)
        ctx.lineWidth = 1.5
        ctx.setLineDash([4, 8])
        ctx.stroke()
        ctx.setLineDash([])

        if (root.duration > 0) {
            var angle = (root.remaining / root.duration) * 360
            if (angle > 0) {
                ctx.beginPath()
                ctx.arc(cx, cy, r, -Math.PI / 2, -Math.PI / 2 + angle * Math.PI / 180, false)
                ctx.strokeStyle = root.remaining < 10000 ? colors.error : colors.tertiary
                ctx.lineWidth = 14
                ctx.lineCap = "round"
                ctx.stroke()
            }
        }
    }

    onRemainingChanged: ringCanvas.requestPaint()
    onDurationChanged: ringCanvas.requestPaint()

    // ─── DURATION SELECTOR ───────────────────────────────────

    Column {
        anchors.centerIn: parent
        spacing: 36
        visible: root.isIdle

        Label {
            text: "Set Timer"
            font.family: root.fontFamily
            font.pixelSize: 24
            font.weight: Font.Light
            color: colors.onSurfaceVariant
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Flow {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8
            layoutDirection: Qt.LeftToRight

            Repeater {
                model: [1, 3, 5, 10, 15, 30]
                delegate: Chip {
                    text: modelData + " min"
                    selected: root.duration === modelData * 60000
                    onClicked: root.setDuration(modelData)
                }
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12

            property int hours: Math.floor(root.duration / 3600000)
            property int minutes: Math.floor((root.duration % 3600000) / 60000)
            property int seconds: Math.floor((root.duration % 60000) / 1000)

            SpinnerSegment {
                value: parent.hours
                onUp: root.duration = root.duration + 3600000
                onDown: root.duration = Math.max(0, root.duration - 3600000)
                atMax: parent.hours >= 99
                atMin: parent.hours <= 0
            }

            Label {
                text: ":"
                font.pixelSize: 36
                font.family: root.fontFamily
                font.weight: Font.Light
                color: colors.onSurface
                anchors.verticalCenter: parent.verticalCenter
            }

            SpinnerSegment {
                value: parent.minutes
                onUp: root.duration = Math.min(99*3600000, root.duration + 60000)
                onDown: root.duration = Math.max(0, root.duration - 60000)
                atMax: parent.minutes >= 59
                atMin: parent.minutes <= 0
            }

            Label {
                text: ":"
                font.pixelSize: 36
                font.family: root.fontFamily
                font.weight: Font.Light
                color: colors.onSurface
                anchors.verticalCenter: parent.verticalCenter
            }

            SpinnerSegment {
                value: parent.seconds
                onUp: root.duration = Math.min(99*3600000, root.duration + 1000)
                onDown: root.duration = Math.max(0, root.duration - 1000)
                atMax: parent.seconds >= 59
                atMin: parent.seconds <= 0
            }
        }

        Button {
            text: "Start"
            variant: "filled"
            anchors.horizontalCenter: parent.horizontalCenter
            enabled: root.duration > 0
            onClicked: {
                root.remaining = root.duration
                root.isRunning = true
                countdown.start()
            }
        }
    }

    // ─── ACTIVE COUNTDOWN ────────────────────────────────────

    Column {
        anchors.centerIn: ringCanvas
        spacing: 0
        visible: !root.isIdle

        Label {
            id: timerDisplay
            text: root.isCompleted ? "Time's up!" : formatCountdown(root.remaining)
            font.family: root.fontFamily
            font.pixelSize: root.isCompleted ? 40 : 72
            font.weight: root.isCompleted ? Font.Light : Font.Bold
            color: root.isCompleted ? colors.tertiary : colors.onSurface
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            text: root.isCompleted ? "" : "remaining"
            font.family: root.fontFamily
            font.pixelSize: 14
            font.weight: Font.Normal
            color: colors.onSurfaceVariant
            anchors.horizontalCenter: parent.horizontalCenter
            visible: !root.isCompleted
        }
    }

    // ─── CONTROLS (active states) ────────────────────────────

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 48
        spacing: 12
        visible: !root.isIdle

        Button {
            text: root.isCompleted ? "Done" : root.isPaused ? "Resume" : "Pause"
            variant: root.isCompleted ? "tonal" : "filled"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                if (root.isCompleted) {
                    root.duration = 0
                    root.remaining = 0
                    root.isCompleted = false
                    return
                }
                if (root.isPaused) {
                    root.isPaused = false
                    root.isRunning = true
                    countdown.start()
                } else {
                    root.isPaused = true
                    root.isRunning = false
                    countdown.stop()
                }
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 16

            Button {
                text: "Cancel"
                variant: "text"
                enabled: !root.isCompleted
                onClicked: {
                    countdown.stop()
                    root.isRunning = false
                    root.isPaused = false
                    root.remaining = 0
                    root.duration = 0
                }
            }

            Button {
                text: "Reset"
                variant: "text"
                enabled: !root.isCompleted && (root.isRunning || root.isPaused || root.remaining < root.duration)
                onClicked: {
                    countdown.stop()
                    root.isRunning = false
                    root.isPaused = false
                    root.remaining = root.duration
                }
            }
        }
    }

    function formatCountdown(ms) {
        var total = Math.ceil(ms / 1000)
        var h = Math.floor(total / 3600)
        var m = Math.floor((total % 3600) / 60)
        var s = total % 60
        return pad(h) + ":" + pad(m) + ":" + pad(s)
    }

    function pad(n) {
        return String(n).padStart(2, '0')
    }

    // ─── SPINNER SEGMENT ─────────────────────────────────────

    component SpinnerSegment: Item {
        property int value: 0
        property bool atMax: false
        property bool atMin: false
        signal up()
        signal down()

        width: 72
        height: 140

        Column {
            anchors.centerIn: parent
            spacing: 2

            IconButton {
                icon: "expand_less"
                size: "small"
                variant: "standard"
                anchors.horizontalCenter: parent.horizontalCenter
                enabled: !atMax
                onClicked: parent.parent.up()
            }

            Rectangle {
                width: 64
                height: 48
                radius: 12
                color: colors.surfaceContainerHigh
                anchors.horizontalCenter: parent.horizontalCenter

                Label {
                    anchors.centerIn: parent
                    text: String(parent.parent.parent.value).padStart(2, '0')
                    font.family: root.fontFamily
                    font.pixelSize: 28
                    font.weight: Font.Medium
                    color: colors.onSurface
                }
            }

            IconButton {
                icon: "expand_more"
                size: "small"
                variant: "standard"
                anchors.horizontalCenter: parent.horizontalCenter
                enabled: !atMin
                onClicked: parent.parent.down()
            }
        }
    }
}
