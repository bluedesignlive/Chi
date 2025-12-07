// qml/smartui/ui/progress/CircularProgressIndicator.qml
import QtQuick
import "../../theme" as Theme

Item {
    id: root

    property real progress: 0.0              // 0.0 to 1.0
    property bool indeterminate: false
    property string size: "medium"           // "small", "medium", "large"
    property bool enabled: true
    property bool animated: true
    property int animationDuration: 300

    readonly property var sizeSpecs: ({
        small: { diameter: 24, strokeWidth: 3 },
        medium: { diameter: 40, strokeWidth: 4 },
        large: { diameter: 56, strokeWidth: 5 }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.medium
    readonly property real actualProgress: Math.max(0, Math.min(1, progress))

    implicitWidth: currentSize.diameter
    implicitHeight: currentSize.diameter

    opacity: enabled ? 1.0 : 0.38

    Behavior on opacity {
        NumberAnimation { duration: 150 }
    }

    property var colors: Theme.ChiTheme.colors

    // Track (background circle)
    Canvas {
        id: trackCanvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            var centerX = width / 2
            var centerY = height / 2
            var radius = (Math.min(width, height) - currentSize.strokeWidth) / 2

            ctx.beginPath()
            ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI)
            ctx.strokeStyle = colors.secondaryContainer
            ctx.lineWidth = currentSize.strokeWidth
            ctx.lineCap = "round"
            ctx.stroke()
        }

        Component.onCompleted: requestPaint()

        Connections {
            target: Theme.ChiTheme
            function onColorsChanged() { trackCanvas.requestPaint() }
        }
    }

    // Determinate progress
    Canvas {
        id: progressCanvas
        anchors.fill: parent
        visible: !indeterminate

        property real animatedProgress: actualProgress

        Behavior on animatedProgress {
            enabled: animated
            NumberAnimation {
                duration: animationDuration
                easing.type: Easing.OutCubic
            }
        }

        onAnimatedProgressChanged: requestPaint()

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            if (animatedProgress <= 0) return

            var centerX = width / 2
            var centerY = height / 2
            var radius = (Math.min(width, height) - currentSize.strokeWidth) / 2

            var startAngle = -Math.PI / 2
            var endAngle = startAngle + (2 * Math.PI * animatedProgress)

            ctx.beginPath()
            ctx.arc(centerX, centerY, radius, startAngle, endAngle)
            ctx.strokeStyle = colors.primary
            ctx.lineWidth = currentSize.strokeWidth
            ctx.lineCap = "round"
            ctx.stroke()
        }

        Component.onCompleted: requestPaint()

        Connections {
            target: Theme.ChiTheme
            function onColorsChanged() { progressCanvas.requestPaint() }
        }
    }

    // Indeterminate spinner
    Canvas {
        id: indeterminateCanvas
        anchors.fill: parent
        visible: indeterminate

        property real rotation: 0
        property real dashOffset: 0

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            ctx.save()
            ctx.translate(width / 2, height / 2)
            ctx.rotate(rotation * Math.PI / 180)
            ctx.translate(-width / 2, -height / 2)

            var centerX = width / 2
            var centerY = height / 2
            var radius = (Math.min(width, height) - currentSize.strokeWidth) / 2

            // Draw arc that varies in length
            var arcLength = 0.25 + 0.5 * Math.abs(Math.sin(dashOffset * Math.PI / 180))
            var startAngle = -Math.PI / 2 + (dashOffset * Math.PI / 180)
            var endAngle = startAngle + (2 * Math.PI * arcLength)

            ctx.beginPath()
            ctx.arc(centerX, centerY, radius, startAngle, endAngle)
            ctx.strokeStyle = colors.primary
            ctx.lineWidth = currentSize.strokeWidth
            ctx.lineCap = "round"
            ctx.stroke()

            ctx.restore()
        }

        SequentialAnimation on rotation {
            running: indeterminate && root.visible
            loops: Animation.Infinite

            NumberAnimation {
                from: 0
                to: 360
                duration: 1500
                easing.type: Easing.Linear
            }
        }

        SequentialAnimation on dashOffset {
            running: indeterminate && root.visible
            loops: Animation.Infinite

            NumberAnimation {
                from: 0
                to: 360
                duration: 2000
                easing.type: Easing.InOutQuad
            }
        }

        onRotationChanged: requestPaint()
        onDashOffsetChanged: requestPaint()

        Component.onCompleted: requestPaint()

        Connections {
            target: Theme.ChiTheme
            function onColorsChanged() { indeterminateCanvas.requestPaint() }
        }
    }

    // Center content (for percentage, icon, etc.)
    property alias content: contentContainer.children

    Item {
        id: contentContainer
        anchors.centerIn: parent
        width: parent.width - currentSize.strokeWidth * 4
        height: parent.height - currentSize.strokeWidth * 4
    }

    function setProgress(value, animate = true) {
        animated = animate
        progress = value
        if (!animate) animated = true
    }

    function reset() { progress = 0 }
    function complete() { progress = 1.0 }

    Accessible.role: Accessible.ProgressBar
    Accessible.name: "Circular progress indicator"
    Accessible.description: indeterminate
        ? "Loading"
        : (Math.round(actualProgress * 100) + "% complete")
}
