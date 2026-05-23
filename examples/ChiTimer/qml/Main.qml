import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Chi

// ChiTimer — Material 3 Expressive Clock
// Showcase for Chi UI library: segmented ring, hero typography,
// spring-driven motion tokens, morphing bottom nav.

ChiApplicationWindow {
    id: root
    title: "ChiTimer"
    width: 480
    height: 800
    // showThemeToggle: true   // TODO: add to ChiApplicationWindow
    showControls: false

    // ------------------------------------------------------------------
    // STATE
    // ------------------------------------------------------------------
    property int currentTab: 0
    property bool isTiming: false
    property int elapsedMs: 0
    property var laps: []

    // Access theme tokens through ChiTheme singleton
    readonly property var chiColors: ChiTheme.colors
    readonly property string chiFont: ChiTheme.fontFamily

    // ------------------------------------------------------------------
    // TIMER ENGINE
    // ------------------------------------------------------------------
    Timer {
        id: engine
        interval: 16
        repeat: true
        onTriggered: root.elapsedMs += 16
    }

    // ------------------------------------------------------------------
    // CANVAS RENDERER (segmented ring face)
    // ------------------------------------------------------------------
    Canvas {
        id: face
        anchors.fill: parent
        anchors.bottomMargin: 120  // leave room for controls + tab bar
        onPaint: drawFace()
    }

    function drawFace() {
        var ctx = face.getContext("2d")
        var w = face.width, h = face.height
        var cx = w / 2, cy = h / 2
        var r = Math.min(cx, cy) - 40

        ctx.clearRect(0, 0, w, h)

        // Background dotted ring
        ctx.beginPath()
        ctx.arc(cx, cy, r, 0, Math.PI * 2)
        ctx.strokeStyle = Qt.rgba(0,0,0,0.08)
        ctx.lineWidth = 1.5
        ctx.setLineDash([4, 8])
        ctx.stroke()
        ctx.setLineDash([])

        var secAngle = (root.elapsedMs % 60000) / 60000 * 360
        var minAngle = (root.elapsedMs % 3600000) / 3600000 * 360

        // Seconds arc (outer, primary)
        if (secAngle > 0) {
            ctx.beginPath()
            ctx.arc(cx, cy, r, -Math.PI / 2, -Math.PI / 2 + secAngle * Math.PI / 180, false)
            ctx.strokeStyle = chiColors.primary
            ctx.lineWidth = 14
            ctx.lineCap = "round"
            ctx.stroke()
        }

        // Minutes arc (inner, secondary)
        if (minAngle > 0) {
            ctx.beginPath()
            ctx.arc(cx, cy, r - 28, -Math.PI / 2, -Math.PI / 2 + minAngle * Math.PI / 180, false)
            ctx.strokeStyle = chiColors.secondary
            ctx.lineWidth = 10
            ctx.lineCap = "round"
            ctx.stroke()
        }
    }

    // Force redraw on every timer tick
    onElapsedMsChanged: face.requestPaint()

    // ------------------------------------------------------------------
    // HERO TIME DISPLAY
    // ------------------------------------------------------------------
    Column {
        anchors.centerIn: face
        spacing: -6

        Label {
            id: timeDisplay
            text: formatTime(root.elapsedMs)
            font.family: root.chiFont
            font.pixelSize: root.isTiming ? 76 : 72
            font.weight: root.isTiming ? Font.Bold : Font.Light
            color: chiColors.onSurface

            Behavior on font.pixelSize {
                NumberAnimation {
                    duration: 350
                    easing.type: Easing.OutBack
                }
            }
            Behavior on font.weight {
                NumberAnimation {
                    duration: 200
                }   // Qt doesn't animate weight directly; visual handled by scale/size
            }
        }

        Label {
            id: msDisplay
            text: "." + String(root.elapsedMs % 1000).padStart(3, '0')
            font.family: root.chiFont
            font.pixelSize: 28
            font.weight: Font.Light
            color: chiColors.onSurfaceVariant
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    // ------------------------------------------------------------------
    // LAP LIST
    // ------------------------------------------------------------------
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

    // ------------------------------------------------------------------
    // CONTROLS
    // ------------------------------------------------------------------
    RowLayout {
        id: controlsRow
        anchors.bottom: tabBar.top
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

    // ------------------------------------------------------------------
    // MORPHING BOTTOM NAVIGATION
    // ------------------------------------------------------------------
    Rectangle {
        id: tabBar
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 80
        color: chiColors.surfaceContainerLow

        // Morphing indicator pill (slides between tabs)
        Rectangle {
            id: indicator
            width: 64; height: 32; radius: 16
            color: chiColors.secondaryContainer
            y: 24
            x: indicatorX(root.currentTab)

            Behavior on x {
                NumberAnimation {
                    duration: 400
                    easing {
                        type: Easing.BezierSpline
                        // M3 emphasized decelerate ~ [0.05, 0.7, 0.1, 1.0]
                        bezierCurve: [0.05, 0.7, 0.1, 1.0, 1.0, 1.0]
                    }
                }
            }
        }

        Row {
            anchors.fill: parent
            anchors.topMargin: 12

            NavItem { index: 0; icon: "timer"; label: "Timer" }
            NavItem { index: 1; icon: "alarm"; label: "Alarm" }
            NavItem { index: 2; icon: "hourglass_top"; label: "Watch" }
            NavItem { index: 3; icon: "schedule"; label: "World" }
        }
    }

    // ------------------------------------------------------------------
    // NAV ITEM COMPONENT
    // ------------------------------------------------------------------
    component NavItem: Item {
        property int index: 0
        property string icon: ""        // Material symbol name
        property string label: ""        // Label shown below icon
        width: root.width / 4
        height: 80

        Column {
            anchors.centerIn: parent
            spacing: 2

            Icon {
                source: parent.parent.icon
                size: parent.parent.index === root.currentTab ? 28 : 24
                color: parent.parent.index === root.currentTab
                       ? chiColors.onSecondaryContainer
                       : chiColors.onSurfaceVariant
                anchors.horizontalCenter: parent.horizontalCenter

                Behavior on size {
                    NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
                }
            }

            Label {
                text: parent.parent.label
                font.family: root.chiFont
                font.pixelSize: 11
                font.weight: parent.parent.index === root.currentTab ? Font.Medium : Font.Normal
                color: parent.parent.index === root.currentTab
                       ? chiColors.onSecondaryContainer
                       : chiColors.onSurfaceVariant
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.currentTab = parent.index
        }
    }

    // ------------------------------------------------------------------
    // FUNCTIONS
    // ------------------------------------------------------------------
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

    function indicatorX(tabIndex) {
        var tabW = root.width / 4
        return tabIndex * tabW + (tabW - 64) / 2
    }
}
