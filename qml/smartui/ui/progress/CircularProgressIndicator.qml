// smartui/ui/progress/CircularProgressIndicator.qml
// Circular progress indicator — M3 + M3 Expressive tokens
// Anatomy: active indicator (arc), track (background circle)
import QtQuick
import QtQuick.Shapes
import "../../theme" as Theme

Item {
    id: root

    // ─── Public API ─────────────────────────────────────────
    property real progress: 0.0
    property bool indeterminate: false
    property bool wavy: false
    property string size: "medium"             // "small", "medium", "large", "xlarge"
    property bool enabled: true

    // Direct overrides — default from size presets
    property real diameter: _spec.diameter
    property real strokeWidth: _spec.strokeWidth

    // ─── Size Presets (M3 tokens) ───────────────────────────
    readonly property var _specs: ({
        small:  { diameter: 24, strokeWidth: 2.5 },
        medium: { diameter: 40, strokeWidth: 4   },
        large:  { diameter: 56, strokeWidth: 5   },
        xlarge: { diameter: 80, strokeWidth: 6   }
    })
    readonly property var _spec: _specs[size] || _specs.medium

    // ─── M3 Wave Tokens ─────────────────────────────────────
    readonly property real _waveAmplitude: 1.6
    readonly property real _waveWavelength: 15.0

    // ─── Internal Geometry ──────────────────────────────────
    readonly property real _progress: Math.max(0, Math.min(1, progress))
    readonly property real _d: wavy ? diameter + _waveAmplitude * 4 : diameter
    readonly property real _cx: _d / 2
    readonly property real _cy: _d / 2
    readonly property real _radius: (diameter - strokeWidth) / 2
    readonly property bool _hasProgress: _progress > 0.001

    implicitWidth: _d
    implicitHeight: _d
    opacity: enabled ? 1.0 : 0.38

    // ═══════════════════════════════════════════════════════
    // TRACK
    // ═══════════════════════════════════════════════════════

    Shape {
        anchors.fill: parent
        layer.enabled: false

        ShapePath {
            strokeColor: Theme.ChiTheme.colors.secondaryContainer
            strokeWidth: root.strokeWidth
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: _cx; centerY: _cy
                radiusX: _radius; radiusY: _radius
                startAngle: 0; sweepAngle: 360
            }
        }
    }

    // ═══════════════════════════════════════════════════════
    // DETERMINATE — FLAT
    // ═══════════════════════════════════════════════════════

    Shape {
        visible: !indeterminate && !wavy && _hasProgress
        anchors.fill: parent
        layer.enabled: false

        ShapePath {
            strokeColor: Theme.ChiTheme.colors.primary
            strokeWidth: root.strokeWidth
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: _cx; centerY: _cy
                radiusX: _radius; radiusY: _radius
                startAngle: -90
                sweepAngle: _progress * 360

                Behavior on sweepAngle {
                    NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                }
            }
        }
    }

    // ═══════════════════════════════════════════════════════
    // DETERMINATE — WAVY
    // ═══════════════════════════════════════════════════════

    Shape {
        id: determinateWavy
        visible: !indeterminate && wavy && _hasProgress
        anchors.fill: parent
        layer.enabled: false

        property real _phase: 0.0
        NumberAnimation on _phase {
            from: 0; to: 2 * Math.PI
            duration: 1500
            loops: Animation.Infinite
            running: wavy && !indeterminate && root.visible && root.enabled
        }

        ShapePath {
            strokeColor: Theme.ChiTheme.colors.primary
            strokeWidth: root.strokeWidth
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            PathPolyline {
                path: {
                    var pts = [];
                    var sweep = root._progress * 2 * Math.PI;
                    if (sweep < 0.01) return [Qt.point(root._cx, root._cy - root._radius)];

                    var circumference = 2 * Math.PI * root._radius;
                    var numWaves = circumference / root._waveWavelength;
                    var amp = root._waveAmplitude;
                    var phase = determinateWavy._phase;

                    var steps = Math.max(90, Math.round(numWaves * 24 * root._progress));
                    for (var i = 0; i <= steps; i++) {
                        var t = i / steps;
                        var angle = -Math.PI / 2 + t * sweep;
                        var r = root._radius + amp * Math.sin(numWaves * angle + phase);
                        pts.push(Qt.point(root._cx + r * Math.cos(angle),
                                          root._cy + r * Math.sin(angle)));
                    }
                    return pts;
                }
            }
        }
    }

    // ═══════════════════════════════════════════════════════
    // INDETERMINATE — FLAT
    // ═══════════════════════════════════════════════════════

    Shape {
        id: indeterminateFlat
        visible: indeterminate && !wavy
        anchors.fill: parent
        layer.enabled: false

        rotation: _containerAngle

        property real _containerAngle: 0
        NumberAnimation on _containerAngle {
            from: 0; to: 360
            duration: 1568
            loops: Animation.Infinite
            running: indeterminate && !wavy && root.visible
        }

        property real _arcStart: 0
        property real _arcSweep: 16

        SequentialAnimation {
            running: indeterminate && !wavy && root.visible
            loops: Animation.Infinite

            ParallelAnimation {
                NumberAnimation {
                    target: indeterminateFlat; property: "_arcSweep"
                    from: 16; to: 270
                    duration: 667; easing.type: Easing.InOutCubic
                }
                NumberAnimation {
                    target: indeterminateFlat; property: "_arcStart"
                    from: 0; to: 30
                    duration: 667; easing.type: Easing.InOutCubic
                }
            }
            ParallelAnimation {
                NumberAnimation {
                    target: indeterminateFlat; property: "_arcSweep"
                    from: 270; to: 16
                    duration: 667; easing.type: Easing.InOutCubic
                }
                NumberAnimation {
                    target: indeterminateFlat; property: "_arcStart"
                    from: 30; to: 330
                    duration: 667; easing.type: Easing.InOutCubic
                }
            }
        }

        ShapePath {
            strokeColor: Theme.ChiTheme.colors.primary
            strokeWidth: root.strokeWidth
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: _cx; centerY: _cy
                radiusX: _radius; radiusY: _radius
                startAngle: -90 + indeterminateFlat._arcStart
                sweepAngle: indeterminateFlat._arcSweep
            }
        }
    }

    // ═══════════════════════════════════════════════════════
    // INDETERMINATE — WAVY
    // ═══════════════════════════════════════════════════════

    Item {
        id: indeterminateWavy
        visible: indeterminate && wavy
        anchors.fill: parent

        property real _containerAngle: 0
        NumberAnimation on _containerAngle {
            from: 0; to: 360
            duration: 1568
            loops: Animation.Infinite
            running: indeterminate && wavy && root.visible
        }

        property real _arcStart: 0
        property real _arcSweep: 16
        property real _wavePhase: 0

        SequentialAnimation {
            running: indeterminate && wavy && root.visible
            loops: Animation.Infinite

            ParallelAnimation {
                NumberAnimation {
                    target: indeterminateWavy; property: "_arcSweep"
                    from: 16; to: 270
                    duration: 667; easing.type: Easing.InOutCubic
                }
                NumberAnimation {
                    target: indeterminateWavy; property: "_arcStart"
                    from: 0; to: 30
                    duration: 667; easing.type: Easing.InOutCubic
                }
            }
            ParallelAnimation {
                NumberAnimation {
                    target: indeterminateWavy; property: "_arcSweep"
                    from: 270; to: 16
                    duration: 667; easing.type: Easing.InOutCubic
                }
                NumberAnimation {
                    target: indeterminateWavy; property: "_arcStart"
                    from: 30; to: 330
                    duration: 667; easing.type: Easing.InOutCubic
                }
            }
        }

        NumberAnimation on _wavePhase {
            from: 0; to: 2 * Math.PI
            duration: 1200
            loops: Animation.Infinite
            running: indeterminate && wavy && root.visible
        }

        rotation: _containerAngle

        Shape {
            anchors.fill: parent
            layer.enabled: false

            ShapePath {
                strokeColor: Theme.ChiTheme.colors.primary
                strokeWidth: root.strokeWidth
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.RoundJoin

                PathPolyline {
                    path: {
                        var pts = [];
                        var startDeg = indeterminateWavy._arcStart;
                        var sweepDeg = indeterminateWavy._arcSweep;
                        var startRad = (-90 + startDeg) * Math.PI / 180;
                        var sweepRad = sweepDeg * Math.PI / 180;

                        if (sweepRad < 0.05) return [Qt.point(root._cx, root._cy - root._radius)];

                        var circumference = 2 * Math.PI * root._radius;
                        var numWaves = circumference / root._waveWavelength;
                        var amp = root._waveAmplitude;
                        var phase = indeterminateWavy._wavePhase;

                        var steps = Math.max(36, Math.round(numWaves * 24 * (sweepDeg / 360)));
                        for (var i = 0; i <= steps; i++) {
                            var t = i / steps;
                            var angle = startRad + t * sweepRad;
                            var r = root._radius + amp * Math.sin(numWaves * angle + phase);
                            pts.push(Qt.point(root._cx + r * Math.cos(angle),
                                              root._cy + r * Math.sin(angle)));
                        }
                        return pts;
                    }
                }
            }
        }
    }

    // ═══════════════════════════════════════════════════════
    // CENTER CONTENT SLOT
    // ═══════════════════════════════════════════════════════

    property alias content: contentSlot.children

    Item {
        id: contentSlot
        anchors.centerIn: parent
        width: diameter - strokeWidth * 4
        height: diameter - strokeWidth * 4
    }

    // ═══════════════════════════════════════════════════════
    // ACCESSIBILITY
    // ═══════════════════════════════════════════════════════

    Accessible.role: Accessible.ProgressBar
    Accessible.name: indeterminate ? "Loading" : "Progress"
    Accessible.description: indeterminate
        ? "Loading in progress"
        : "%1% complete".arg(Math.round(_progress * 100))

    function setProgress(value) { progress = value }
    function reset()            { progress = 0 }
    function complete()         { progress = 1.0 }
}
