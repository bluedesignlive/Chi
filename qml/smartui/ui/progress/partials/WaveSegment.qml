import QtQuick

Item {
    id: seg
    property int stroke: 4
    property color color: "magenta"
    property bool up: true
    property bool mirrored: false
    property int segmentWidth: 40
    property int containerHeight: 12

    width: segmentWidth
    height: containerHeight

    Canvas {
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            ctx.save()

            if (seg.mirrored) {
                ctx.translate(width, 0)
                ctx.scale(-1, 1)
            }

            ctx.strokeStyle = seg.color
            ctx.lineWidth = seg.stroke
            ctx.lineCap = "round"
            ctx.lineJoin = "round"

            var cy = height / 2
            var waveH = (seg.stroke === 4 ? 10 : 12)
            var amplitude = (waveH - seg.stroke) / 2

            ctx.beginPath()
            ctx.moveTo(0, cy)

            var cp1x = width * 0.25
            var cp2x = width * 0.75
            var cpY = cy + (seg.up ? -amplitude : amplitude)
            ctx.bezierCurveTo(cp1x, cpY, cp2x, cpY, width, cy)
            ctx.stroke()

            ctx.restore()
        }
    }
}
