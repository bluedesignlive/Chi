import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Chi

Item {
    id: root

    readonly property var colors: ChiTheme.colors
    readonly property string fontFamily: ChiTheme.fontFamily

    property bool isTiming: false
    property int elapsedMs: 0
    property var laps: []

    Timer {
        id: engine
        interval: 16
        repeat: true
        onTriggered: root.elapsedMs += 16
    }

    Canvas {
        id: face
        anchors.fill: parent
        anchors.bottomMargin: 120
        onPaint: drawFace()
    }

    function drawFace() {
        var ctx = face.getContext("2d")
        var w = face.width, h = face.height
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

        var secAngle = (root.elapsedMs % 60000) / 60000 * 360
        var minAngle = (root.elapsedMs % 3600000) / 3600000 * 360

        if (secAngle > 0) {
            ctx.beginPath()
            ctx.arc(cx, cy, r, -Math.PI / 2, -Math.PI / 2 + secAngle * Math.PI / 180, false)
            ctx.strokeStyle = colors.primary
            ctx.lineWidth = 14
            ctx.lineCap = "round"
            ctx.stroke()
        }

        if (minAngle > 0) {
            ctx.beginPath()
            ctx.arc(cx, cy, r - 28, -Math.PI / 2, -Math.PI / 2 + minAngle * Math.PI / 180, false)
            ctx.strokeStyle = colors.secondary
            ctx.lineWidth = 10
            ctx.lineCap = "round"
            ctx.stroke()
        }
    }

    onElapsedMsChanged: face.requestPaint()

    Column {
        anchors.centerIn: face
        spacing: -6

        Label {
            id: timeDisplay
            text: formatTime(root.elapsedMs)
            font.family: root.fontFamily
            font.pixelSize: root.isTiming ? 76 : 72
            font.weight: root.isTiming ? Font.Bold : Font.Light
            color: colors.onSurface

            Behavior on font.pixelSize {
                NumberAnimation {
                    duration: 350
                    easing.type: Easing.OutBack
                }
            }
        }

        Label {
            text: "." + String(root.elapsedMs % 1000).padStart(3, '0')
            font.family: root.fontFamily
            font.pixelSize: 28
            font.weight: Font.Light
            color: colors.onSurfaceVariant
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    ListView {
        id: lapList
        anchors.top: face.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: controlsRow.top
        anchors.margins: 16
        model: root.laps
        visible: root.laps.length > 0
        clip: true
        spacing: 4

        delegate: ListItem {
            width: lapList.width
            text: modelData.name
            secondaryText: modelData.time
            leadingIcon: "flag"
            onClicked: console.log("Lap:", modelData.name)
        }
    }

    RowLayout {
        id: controlsRow
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 16
        height: 56
        spacing: 12

        Button {
            text: root.isTiming ? "Stop" : "Start"
            variant: root.isTiming ? "outlined" : "filled"
            Layout.fillWidth: true
            onClicked: toggleTimer()
        }

        Button {
            text: "Reset"
            variant: "tonal"
            Layout.fillWidth: true
            enabled: root.elapsedMs > 0 || root.isTiming
            onClicked: resetTimer()
        }

        Button {
            text: "Lap"
            variant: "tonal"
            Layout.fillWidth: true
            enabled: root.isTiming
            onClicked: recordLap()
        }
    }

    function toggleTimer() {
        if (root.isTiming) {
            root.isTiming = false
            engine.stop()
        } else {
            root.isTiming = true
            engine.start()
        }
    }

    function resetTimer() {
        root.isTiming = false
        root.elapsedMs = 0
        root.laps = []
        engine.stop()
    }

    function recordLap() {
        root.laps = root.laps.concat([{
            name: "Lap " + (root.laps.length + 1),
            time: formatTime(root.elapsedMs)
        }])
    }

    function formatTime(ms) {
        var total = Math.floor(ms / 1000)
        var h = Math.floor(total / 3600)
        var m = Math.floor((total % 3600) / 60)
        var s = total % 60
        return pad(h) + ":" + pad(m) + ":" + pad(s)
    }

    function pad(n) {
        return String(n).padStart(2, '0')
    }
}
