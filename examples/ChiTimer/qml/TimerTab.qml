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
        anchors.bottomMargin: 120
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
        spacing: 32
        visible: root.isIdle

        Label {
            text: "Set Timer"
            font.family: root.fontFamily
            font.pixelSize: 28
            font.weight: Font.Light
            color: colors.onSurface
            anchors.horizontalCenter: parent.horizontalCenter
        }

        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8

            Repeater {
                model: [1, 3, 5, 10, 15, 30]
                delegate: Chip {
                    text: modelData + " min"
                    selected: root.duration === modelData * 60000
                    onClicked: root.setDuration(modelData)
                }
            }
        }

        // Custom duration spinner
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8

            property int hours: Math.floor(root.duration / 3600000)
            property int minutes: Math.floor((root.duration % 3600000) / 60000)
            property int seconds: Math.floor((root.duration % 60000) / 1000)

            TimerSpinner {
                label: "HH"
                value: parent.hours
                max: 99
                onIncrement: { root.duration = root.duration + 3600000 }
                onDecrement: { root.duration = Math.max(0, root.duration - 3600000) }
            }

            Label {
                text: ":"
                font.pixelSize: 32
                font.family: root.fontFamily
                color: colors.onSurface
                anchors.verticalCenter: parent.verticalCenter
            }

            TimerSpinner {
                label: "MM"
                value: parent.minutes
                max: 59
                onIncrement: { root.duration = Math.min(99*3600000, root.duration + 60000) }
                onDecrement: { root.duration = Math.max(0, root.duration - 60000) }
            }

            Label {
                text: ":"
                font.pixelSize: 32
                font.family: root.fontFamily
                color: colors.onSurface
                anchors.verticalCenter: parent.verticalCenter
            }

            TimerSpinner {
                label: "SS"
                value: parent.seconds
                max: 59
                onIncrement: { root.duration = Math.min(99*3600000, root.duration + 1000) }
                onDecrement: { root.duration = Math.max(0, root.duration - 1000) }
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
        spacing: -6
        visible: !root.isIdle

        Label {
            id: timerDisplay
            text: formatCountdown(root.remaining)
            font.family: root.fontFamily
            font.pixelSize: root.isCompleted ? 48 : root.isRunning ? 76 : 72
            font.weight: root.isCompleted ? Font.Light : Font.Bold
            color: root.isCompleted ? colors.tertiary : colors.onSurface
            anchors.horizontalCenter: parent.horizontalCenter

            Behavior on font.pixelSize {
                NumberAnimation {
                    duration: 350
                    easing.type: Easing.OutBack
                }
            }
        }

        Label {
            text: root.isCompleted ? "Time's up" : ""
            font.family: root.fontFamily
            font.pixelSize: 20
            font.weight: Font.Medium
            color: colors.tertiary
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.isCompleted
        }
    }

    RowLayout {
        id: timerControls
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 16
        height: 56
        spacing: 12
        visible: !root.isIdle

        Button {
            text: root.isCompleted ? "Done" : root.isPaused ? "Resume" : "Pause"
            variant: root.isCompleted ? "tonal" : root.isPaused ? "filled" : "outlined"
            Layout.fillWidth: true
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

        Button {
            text: "Cancel"
            variant: "tonal"
            Layout.fillWidth: true
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
            Layout.fillWidth: true
            enabled: !root.isCompleted && (root.isRunning || root.isPaused || root.remaining < root.duration)
            onClicked: {
                countdown.stop()
                root.isRunning = false
                root.isPaused = false
                root.remaining = root.duration
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

    // ─── INLINE COMPONENT ────────────────────────────────────

    component TimerSpinner: Item {
        property string label: ""
        property int value: 0
        property int max: 59
        signal increment()
        signal decrement()

        width: 64
        height: 120

        Column {
            anchors.centerIn: parent
            spacing: 4

            Button {
                text: "+"
                variant: "text"
                anchors.horizontalCenter: parent.horizontalCenter
                enabled: parent.parent.value < parent.parent.max
                onClicked: parent.parent.increment()
            }

            Label {
                text: String(parent.parent.value).padStart(2, '0')
                font.family: root.fontFamily
                font.pixelSize: 32
                font.weight: Font.Medium
                color: colors.onSurface
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Button {
                text: "−"
                variant: "text"
                anchors.horizontalCenter: parent.horizontalCenter
                enabled: parent.parent.value > 0
                onClicked: parent.parent.decrement()
            }
        }
    }
}
