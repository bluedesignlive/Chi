// smartui/ui/progress/CircularProgressIndicator.qml
// M3 circular progress indicator — determinate + indeterminate
import QtQuick
import QtQuick.Shapes
import "../../theme" as Theme

Item {
    id: root

    property real progress: 0.0
    property bool indeterminate: false
    property bool wavy: false          // kept for API compat, ignored
    property string size: "medium"
    property bool enabled: true
    property real diameter: _spec.diameter
    property real strokeWidth: _spec.strokeWidth

    readonly property var _specs: ({
        small:  { diameter: 24, strokeWidth: 2.5 },
        medium: { diameter: 40, strokeWidth: 4   },
        large:  { diameter: 56, strokeWidth: 5   },
        xlarge: { diameter: 80, strokeWidth: 6   }
    })
    readonly property var _spec: _specs[size] || _specs.medium

    readonly property real _cx: diameter / 2
    readonly property real _cy: diameter / 2
    readonly property real _radius: (diameter - strokeWidth) / 2
    // Gap angle: convert 4 px arc-length to degrees  (rad = px/r, deg = rad·180/π)
    readonly property real _ga: (4.0 / _radius) * 57.2957795

    readonly property real _progress: Math.max(0, Math.min(1, progress))

    // Animated progress — Behavior handles the smooth transition
    property real _ap: _progress
    Behavior on _ap { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

    readonly property bool _z: _ap < 0.005
    readonly property bool _f: _ap > 0.995

    readonly property real _activeStart: -90 + _ga
    readonly property real _activeSweep: Math.max(0, _ap * 360 - 2 * _ga)
    readonly property real _trackStart: -90 + _ap * 360 + _ga
    readonly property real _trackSweep: Math.max(0, (1 - _ap) * 360 - 2 * _ga)

    implicitWidth: diameter
    implicitHeight: diameter
    opacity: enabled ? 1.0 : 0.38
    layer.enabled: visible
    layer.samples: 4
    layer.smooth: true

    // ═══════════════════════════════════════════════════════
    // DETERMINATE
    // ═══════════════════════════════════════════════════════

    Shape {
        visible: !root.indeterminate
        anchors.fill: parent

        // Track arc (remaining unfilled portion)
        ShapePath {
            strokeColor: Theme.ChiTheme.colors.secondaryContainer
            strokeWidth: root.strokeWidth
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: _cx; centerY: _cy
                radiusX: _radius; radiusY: _radius
                startAngle: _z ? -90 : (_f ? 0 : _trackStart)
                sweepAngle: _z ? 360 : (_f ? 0 : _trackSweep)
            }
        }

        // Active arc (filled portion)
        ShapePath {
            strokeColor: _z ? "transparent" : Theme.ChiTheme.colors.primary
            strokeWidth: root.strokeWidth
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: _cx; centerY: _cy
                radiusX: _radius; radiusY: _radius
                startAngle: _activeStart
                sweepAngle: _f ? 360 - 2 * _ga : _activeSweep
            }
        }
    }

    // ═══════════════════════════════════════════════════════
    // INDETERMINATE — no gaps, smooth easing
    // ═══════════════════════════════════════════════════════

    Item {
        id: iFlat
        visible: root.indeterminate
        anchors.fill: parent

        // Continuous base rotation
        property real _rot: 0
        NumberAnimation on _rot {
            from: 0; to: 360; duration: 2400
            loops: Animation.Infinite
            running: root.indeterminate && root.visible
        }

        property real _tail: 0
        property real _head: 8
        readonly property real _sw: Math.max(6, _head - _tail)

        SequentialAnimation {
            running: root.indeterminate && root.visible
            loops: Animation.Infinite

            ParallelAnimation {
                NumberAnimation { target: iFlat; property: "_head"; from: 8; to: 280; duration: 800; easing.type: Easing.InOutCubic }
                NumberAnimation { target: iFlat; property: "_tail"; from: 0; to: 20; duration: 800; easing.type: Easing.InOutQuad }
            }
            ParallelAnimation {
                NumberAnimation { target: iFlat; property: "_head"; from: 280; to: 360; duration: 800; easing.type: Easing.InOutQuad }
                NumberAnimation { target: iFlat; property: "_tail"; from: 20; to: 344; duration: 800; easing.type: Easing.InOutCubic }
            }
        }

        Shape {
            anchors.fill: parent
            rotation: iFlat._rot

            // Track — full remaining arc
            ShapePath {
                strokeColor: Theme.ChiTheme.colors.secondaryContainer
                strokeWidth: root.strokeWidth
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    centerX: _cx; centerY: _cy
                    radiusX: _radius; radiusY: _radius
                    startAngle: -90 + iFlat._head
                    sweepAngle: 360 - iFlat._sw
                }
            }

            // Active arc
            ShapePath {
                strokeColor: Theme.ChiTheme.colors.primary
                strokeWidth: root.strokeWidth
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    centerX: _cx; centerY: _cy
                    radiusX: _radius; radiusY: _radius
                    startAngle: -90 + iFlat._tail
                    sweepAngle: iFlat._sw
                }
            }
        }
    }

    // ═══════════════════════════════════════════════════════
    // CENTER CONTENT SLOT
    // ═══════════════════════════════════════════════════════

    property alias content: _slot.children
    Item {
        id: _slot
        anchors.centerIn: parent
        width: diameter - strokeWidth * 4
        height: diameter - strokeWidth * 4
    }

    // ═══════════════════════════════════════════════════════
    // ACCESSIBILITY
    // ═══════════════════════════════════════════════════════

    Accessible.role: Accessible.ProgressBar
    Accessible.name: root.indeterminate ? "Loading" : "Progress"
    Accessible.description: root.indeterminate
        ? "Loading in progress"
        : "%1% complete".arg(Math.round(_progress * 100))

    function setProgress(value) { progress = value }
    function reset()            { progress = 0 }
    function complete()         { progress = 1.0 }
}
