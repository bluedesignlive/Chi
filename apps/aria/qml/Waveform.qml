import QtQuick
import Chi 1.0
import Aria 1.0

// Waveform visualization using Canvas.
// Single paint call replaces 60+ Rectangle items → much faster.
// Automatically adapts bar count to available width.
Item {
    id: root

    property alias source: generator.source
    property real  progress: 0.0           // 0–1
    property color activeColor: ChiTheme.colors.primary
    property color inactiveColor: ChiTheme.colors.surfaceContainerHighest

    signal seekTriggered(real position)

    implicitHeight: 80

    // Bar geometry
    readonly property real barWidth: 3
    readonly property real barGap: 2
    readonly property real minBarRatio: 0.06

    // Drag state — preview position while scrubbing
    property real  _previewPos: -1
    property bool  _dragging: false

    // High-res sample data (512 points)
    WaveformGenerator { id: generator }

    // Repaint only when something visual changes
    onProgressChanged:    canvas.requestPaint()
    onWidthChanged:       canvas.requestPaint()
    onHeightChanged:      canvas.requestPaint()
    onActiveColorChanged: canvas.requestPaint()
    on_PreviewPosChanged: canvas.requestPaint()

    Connections {
        target: generator
        function onSamplesChanged() { canvas.requestPaint() }
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            var samples = generator.samples
            if (!samples || samples.length === 0) return

            // Compute how many bars fit
            var totalBar = root.barWidth + root.barGap
            var count = Math.max(1, Math.floor(width / totalBar))
            var resLen = samples.length
            var displayProgress = root._dragging ? root._previewPos : root.progress
            var cy = height / 2

            for (var i = 0; i < count; i++) {
                // Map bar index to sample range
                var sStart = Math.floor((i / count) * resLen)
                var sEnd   = Math.floor(((i + 1) / count) * resLen)
                sEnd = Math.max(sEnd, sStart + 1)

                // Peak in this bucket
                var peak = 0
                for (var s = sStart; s < Math.min(sEnd, resLen); s++)
                    if (samples[s] > peak) peak = samples[s]

                // Enforce minimum bar height
                if (peak < root.minBarRatio) peak = root.minBarRatio

                var barH = peak * height
                var x = i * totalBar
                var y = cy - barH / 2

                // Active vs inactive color
                var barRatio = (i + 0.5) / count
                ctx.fillStyle = barRatio <= displayProgress
                    ? root.activeColor.toString()
                    : root.inactiveColor.toString()

                // Draw rounded bar using roundRect
                ctx.beginPath()
                var r = root.barWidth / 2
                ctx.roundedRect(x, y, root.barWidth, barH, r, r)
                ctx.fill()
            }
        }
    }

    // Loading placeholder — flat bars
    Canvas {
        anchors.fill: parent
        visible: !generator.ready && source.toString() !== ""
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            ctx.fillStyle = root.inactiveColor.toString()
            ctx.globalAlpha = 0.4
            var totalBar = root.barWidth + root.barGap
            var count = Math.floor(width / totalBar)
            var cy = height / 2
            var barH = height * 0.25
            for (var i = 0; i < count; i++) {
                var r = root.barWidth / 2
                ctx.beginPath()
                ctx.roundedRect(i * totalBar, cy - barH / 2, root.barWidth, barH, r, r)
                ctx.fill()
            }
        }
        Component.onCompleted: requestPaint()
    }

    // Seek interaction — precise to the pixel
    MouseArea {
        anchors.fill: parent
        enabled: generator.ready
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        onPressed: function(mouse) {
            root._dragging = true
            root._previewPos = Math.max(0, Math.min(1, mouse.x / width))
        }
        onPositionChanged: function(mouse) {
            if (root._dragging)
                root._previewPos = Math.max(0, Math.min(1, mouse.x / width))
        }
        onReleased: function(mouse) {
            var pos = Math.max(0, Math.min(1, mouse.x / width))
            root._dragging = false
            root._previewPos = -1
            root.seekTriggered(pos)
        }
        onCanceled: { root._dragging = false; root._previewPos = -1 }
    }
}
