// smartui/ui/progress/LinearProgressIndicator.qml
import QtQuick
import "../../theme" as Theme

Item {
    id: root

    // Core properties
    property real progress: 0.0              // 0.0 to 1.0
    property string variant: "flat"          // "flat" or "wave"
    property string thickness: "small"       // "small" (4dp) or "medium" (8dp)
    property string size: "medium"           // "small", "medium", "large", "xlarge"
    property bool showStop: true
    property bool indeterminate: false
    property bool enabled: true

    // Animation properties
    property bool animated: true
    property int animationDuration: 300

    // Size specs
    readonly property var sizeSpecs: ({
        small:  { width: 200, containerHeight: 12 },
        medium: { width: 400, containerHeight: 12 },
        large:  { width: 600, containerHeight: 14 },
        xlarge: { width: 800, containerHeight: 16 }
    })

    readonly property var currentSpec: sizeSpecs[size] || sizeSpecs.medium
    readonly property int trackHeight: thickness === "small" ? 4 : 8
    readonly property int stopSize: thickness === "small" ? 4 : 4
    readonly property int stopContainerSize: thickness === "small" ? 6 : 8
    readonly property real trackRadius: thickness === "small" ? 2 : 4
    readonly property real actualProgress: Math.max(0, Math.min(1, progress))
    readonly property int gapWidth: thickness === "small" ? 6 : 8

    // Wave specs
    readonly property int waveSegmentWidth: 40
    readonly property real waveHeight: thickness === "small" ? 10 : 12

    implicitWidth: currentSpec.width
    implicitHeight: currentSpec.containerHeight

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    Item {
        id: container
        anchors.fill: parent
        clip: true

        property real progressEndX: parent.width * actualProgress
        property real trackStartX: progressEndX > 0 ? progressEndX + gapWidth : 0
        property real trackWidth: parent.width - trackStartX

        // FLAT VARIANT - Progress (left)
        Rectangle {
            id: flatProgress
            visible: variant === "flat" && !indeterminate && actualProgress > 0
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            width: container.progressEndX
            height: trackHeight
            radius: trackRadius
            color: Theme.ChiTheme.colors.primary

            Behavior on width {
                enabled: animated
                NumberAnimation {
                    duration: animationDuration
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on color {
                ColorAnimation { duration: 200 }
            }

            // Rounded caps
            Rectangle {
                visible: actualProgress < 1
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: trackHeight
                height: trackHeight
                radius: trackHeight / 2
                color: parent.color
            }

            Rectangle {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: trackHeight
                height: trackHeight
                radius: trackHeight / 2
                color: parent.color
            }
        }

        // FLAT VARIANT - Track (right)
        Rectangle {
            id: flatTrack
            visible: variant === "flat" && !indeterminate && actualProgress < 1
            anchors.verticalCenter: parent.verticalCenter
            x: container.trackStartX
            width: container.trackWidth
            height: trackHeight
            radius: trackRadius
            color: Theme.ChiTheme.colors.secondaryContainer

            Behavior on x {
                enabled: animated
                NumberAnimation {
                    duration: animationDuration
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on width {
                enabled: animated
                NumberAnimation {
                    duration: animationDuration
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }

        // FLAT VARIANT - 0% background
        Rectangle {
            visible: variant === "flat" && !indeterminate && actualProgress === 0
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            height: trackHeight
            radius: trackRadius
            color: Theme.ChiTheme.colors.secondaryContainer
            Behavior on color { ColorAnimation { duration: 200 } }
        }

        // WAVE VARIANT - Progress (left)
        Canvas {
            id: waveCanvas
            visible: variant === "wave" && !indeterminate && actualProgress > 0
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            width: container.progressEndX
            height: parent.height

            property real animatedProgress: actualProgress

            Behavior on width {
                enabled: animated
                NumberAnimation {
                    duration: animationDuration
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on animatedProgress {
                enabled: animated
                NumberAnimation {
                    duration: animationDuration
                    easing.type: Easing.OutCubic
                }
            }

            onAnimatedProgressChanged: requestPaint()
            onWidthChanged: requestPaint()
            Component.onCompleted: requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                if (width <= 0)
                    return

                ctx.save()

                ctx.strokeStyle = Theme.ChiTheme.colors.primary
                ctx.lineWidth = trackHeight
                ctx.lineCap = "round"
                ctx.lineJoin = "round"

                var centerY = height / 2
                var segmentWidth = waveSegmentWidth
                var amplitude = (waveHeight - trackHeight) / 2

                ctx.beginPath()
                ctx.moveTo(0, centerY)

                var x = 0
                var segmentIndex = 0

                while (x < width) {
                    var nextX = Math.min(x + segmentWidth / 2, width)
                    var isUp = segmentIndex % 2 === 0

                    if (nextX - x > 1) {
                        var cp1x = x + (nextX - x) * 0.25
                        var cp1y = centerY + (isUp ? -amplitude : amplitude)
                        var cp2x = x + (nextX - x) * 0.75
                        var cp2y = centerY + (isUp ? -amplitude : amplitude)

                        ctx.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, nextX, centerY)
                    }

                    x = nextX
                    segmentIndex++
                    if (x >= width)
                        break
                }

                ctx.stroke()
                ctx.restore()
            }
        }

        // WAVE VARIANT - Track (right)
        Rectangle {
            id: waveTrack
            visible: variant === "wave" && !indeterminate && actualProgress < 1
            anchors.verticalCenter: parent.verticalCenter
            x: container.trackStartX
            width: container.trackWidth
            height: trackHeight
            radius: trackRadius
            color: Theme.ChiTheme.colors.secondaryContainer

            Behavior on x {
                enabled: animated
                NumberAnimation {
                    duration: animationDuration
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on width {
                enabled: animated
                NumberAnimation {
                    duration: animationDuration
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }

        // WAVE VARIANT - 0% background
        Rectangle {
            visible: variant === "wave" && !indeterminate && actualProgress === 0
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            height: trackHeight
            radius: trackRadius
            color: Theme.ChiTheme.colors.secondaryContainer
            Behavior on color { ColorAnimation { duration: 200 } }
        }

        // INDETERMINATE
        Item {
            id: indeterminateContainer
            visible: indeterminate
            anchors.fill: parent
            clip: true

            Rectangle {
                id: indeterminateBar
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.3
                height: trackHeight
                radius: trackHeight / 2
                color: Theme.ChiTheme.colors.primary
                x: -width

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }

                SequentialAnimation on x {
                    running: indeterminate
                    loops: Animation.Infinite

                    NumberAnimation {
                        from: -indeterminateBar.width
                        to: indeterminateContainer.width
                        duration: 1500
                        easing.type: Easing.InOutCubic
                    }
                    PauseAnimation { duration: 500 }
                }
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                height: trackHeight
                radius: trackRadius
                color: Theme.ChiTheme.colors.secondaryContainer
                z: -1
                Behavior on color { ColorAnimation { duration: 200 } }
            }
        }

        // Stop indicator
        Rectangle {
            id: stopIndicator
            visible: showStop && !indeterminate && actualProgress < 1
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: stopContainerSize
            height: stopContainerSize
            color: "transparent"

            Rectangle {
                anchors.centerIn: parent
                width: stopSize
                height: stopSize
                radius: thickness === "small" ? 26 : 3
                color: Theme.ChiTheme.colors.primary
                Behavior on color { ColorAnimation { duration: 200 } }
            }
        }
    }

    Accessible.role: Accessible.ProgressBar
    Accessible.name: "Progress indicator"
    Accessible.description: indeterminate
        ? "Loading"
        : (Math.round(actualProgress * 100) + "% complete")

    function setProgress(value, animate = true) {
        animated = animate
        progress = value
        if (!animate)
            animated = true
    }

    function reset()  { progress = 0 }
    function complete() { progress = 1.0 }
}
