// smartui/ui/progress/LinearProgressIndicator.qml
// Linear progress indicator — M3 + M3 Expressive tokens
// Anatomy: active indicator, track, stop indicator, gap
import QtQuick
import QtQuick.Shapes
import "../../theme" as Theme

Item {
    id: root

    // ─── Public API ─────────────────────────────────────────
    property real progress: 0.0
    property bool indeterminate: false
    property bool wavy: false
    property real trackThickness: 4
    property bool showStopIndicator: true
    property bool enabled: true

    // ─── M3 Tokens ──────────────────────────────────────────
    readonly property real _amplitude: 3.0
    readonly property real _wavelength: 40.0
    readonly property real _indeterminateWavelength: 20.0
    readonly property real _stopSize: 4.0
    readonly property real _gap: 4.0

    // ─── Internal State ─────────────────────────────────────
    readonly property real _progress: Math.max(0, Math.min(1, progress))
    readonly property real _containerHeight: wavy
        ? Math.max(trackThickness + _amplitude * 2, 10)
        : trackThickness
    readonly property real _radius: trackThickness / 2

    readonly property real _activeWidth: width * _progress
    readonly property bool _hasProgress: _progress > 0.001
    readonly property bool _isComplete: _progress > 0.999
    readonly property real _gapPx: (_hasProgress && !_isComplete) ? _gap : 0
    readonly property real _trackX: _activeWidth + _gapPx
    readonly property real _trackW: Math.max(0, width - _trackX)

    implicitWidth: 240
    implicitHeight: _containerHeight
    opacity: enabled ? 1.0 : 0.38

    // ═══════════════════════════════════════════════════════
    // DETERMINATE — FLAT
    // ═══════════════════════════════════════════════════════

    Rectangle {
        id: flatTrack
        visible: !indeterminate && !wavy
        anchors.verticalCenter: parent.verticalCenter
        x: _hasProgress ? _trackX : 0
        width: _hasProgress ? _trackW : root.width
        height: trackThickness
        radius: _radius
        color: Theme.ChiTheme.colors.secondaryContainer

        Behavior on x     { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
        Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
    }

    Rectangle {
        id: flatActive
        visible: !indeterminate && !wavy && _hasProgress
        anchors.verticalCenter: parent.verticalCenter
        x: 0
        width: _activeWidth
        height: trackThickness
        radius: _radius
        color: Theme.ChiTheme.colors.primary

        Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
    }

    // ═══════════════════════════════════════════════════════
    // DETERMINATE — WAVY
    // ═══════════════════════════════════════════════════════

    Rectangle {
        id: wavyTrack
        visible: !indeterminate && wavy
        anchors.verticalCenter: parent.verticalCenter
        x: _hasProgress ? _trackX : 0
        width: _hasProgress ? _trackW : root.width
        height: trackThickness
        radius: _radius
        color: Theme.ChiTheme.colors.secondaryContainer

        Behavior on x     { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
        Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
    }

    Item {
        id: wavyActiveClip
        visible: !indeterminate && wavy && _hasProgress
        anchors.verticalCenter: parent.verticalCenter
        width: _activeWidth
        height: _containerHeight
        clip: true

        Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

        property real _phase: 0.0
        NumberAnimation on _phase {
            from: 0; to: _wavelength
            duration: 1200
            loops: Animation.Infinite
            running: wavy && !indeterminate && root.visible && root.enabled
        }

        Shape {
            x: -wavyActiveClip._phase
            width: wavyActiveClip.width + _wavelength * 2
            height: parent.height
            layer.enabled: false

            ShapePath {
                strokeColor: Theme.ChiTheme.colors.primary
                strokeWidth: root.trackThickness
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.RoundJoin

                PathPolyline {
                    path: {
                        var pts = [];
                        var w = wavyActiveClip.width + root._wavelength * 2;
                        var cy = root._containerHeight / 2;
                        var amp = root._amplitude;
                        var wl = root._wavelength;
                        if (w <= 0 || wl <= 0) return [Qt.point(0, cy)];
                        var step = 2;
                        for (var x = 0; x <= w; x += step) {
                            pts.push(Qt.point(x, cy + amp * Math.sin(2 * Math.PI * x / wl)));
                        }
                        if (pts.length > 0 && pts[pts.length - 1].x < w)
                            pts.push(Qt.point(w, cy + amp * Math.sin(2 * Math.PI * w / wl)));
                        return pts;
                    }
                }
            }
        }
    }

    // ═══════════════════════════════════════════════════════
    // INDETERMINATE — FLAT
    // ═══════════════════════════════════════════════════════

    Item {
        id: indeterminateFlat
        visible: indeterminate && !wavy
        anchors.fill: parent
        clip: true

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            height: trackThickness
            radius: _radius
            color: Theme.ChiTheme.colors.secondaryContainer
        }

        Rectangle {
            id: bar1
            anchors.verticalCenter: parent.verticalCenter
            height: trackThickness
            radius: _radius
            color: Theme.ChiTheme.colors.primary

            SequentialAnimation {
                running: indeterminate && !wavy && root.visible
                loops: Animation.Infinite

                ParallelAnimation {
                    NumberAnimation {
                        target: bar1; property: "x"
                        from: -root.width * 0.5; to: root.width * 0.7
                        duration: 1000; easing.type: Easing.InOutCubic
                    }
                    NumberAnimation {
                        target: bar1; property: "width"
                        from: root.width * 0.08; to: root.width * 0.55
                        duration: 1000; easing.type: Easing.InOutCubic
                    }
                }
                ParallelAnimation {
                    NumberAnimation {
                        target: bar1; property: "x"
                        from: root.width * 0.7; to: root.width * 1.1
                        duration: 800; easing.type: Easing.InCubic
                    }
                    NumberAnimation {
                        target: bar1; property: "width"
                        from: root.width * 0.55; to: root.width * 0.04
                        duration: 800; easing.type: Easing.InCubic
                    }
                }
            }
        }

        Rectangle {
            id: bar2
            anchors.verticalCenter: parent.verticalCenter
            height: trackThickness
            radius: _radius
            color: Theme.ChiTheme.colors.primary

            SequentialAnimation {
                running: indeterminate && !wavy && root.visible
                loops: Animation.Infinite

                PauseAnimation { duration: 600 }
                ParallelAnimation {
                    NumberAnimation {
                        target: bar2; property: "x"
                        from: -root.width * 0.3; to: root.width * 0.8
                        duration: 900; easing.type: Easing.InOutCubic
                    }
                    NumberAnimation {
                        target: bar2; property: "width"
                        from: root.width * 0.04; to: root.width * 0.45
                        duration: 900; easing.type: Easing.InOutCubic
                    }
                }
                ParallelAnimation {
                    NumberAnimation {
                        target: bar2; property: "x"
                        from: root.width * 0.8; to: root.width * 1.05
                        duration: 700; easing.type: Easing.InCubic
                    }
                    NumberAnimation {
                        target: bar2; property: "width"
                        from: root.width * 0.45; to: root.width * 0.02
                        duration: 700; easing.type: Easing.InCubic
                    }
                }
                PauseAnimation { duration: 100 }
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
        clip: true

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            height: trackThickness
            radius: _radius
            color: Theme.ChiTheme.colors.secondaryContainer
        }

        Item {
            id: wavyBar
            anchors.verticalCenter: parent.verticalCenter
            height: _containerHeight
            clip: true

            property real _phase: 0.0
            NumberAnimation on _phase {
                from: 0; to: _indeterminateWavelength
                duration: 600
                loops: Animation.Infinite
                running: indeterminate && wavy && root.visible
            }

            SequentialAnimation {
                running: indeterminate && wavy && root.visible
                loops: Animation.Infinite

                ParallelAnimation {
                    NumberAnimation {
                        target: wavyBar; property: "x"
                        from: -root.width * 0.4; to: root.width * 0.75
                        duration: 1000; easing.type: Easing.InOutCubic
                    }
                    NumberAnimation {
                        target: wavyBar; property: "width"
                        from: root.width * 0.08; to: root.width * 0.55
                        duration: 1000; easing.type: Easing.InOutCubic
                    }
                }
                ParallelAnimation {
                    NumberAnimation {
                        target: wavyBar; property: "x"
                        from: root.width * 0.75; to: root.width * 1.1
                        duration: 800; easing.type: Easing.InCubic
                    }
                    NumberAnimation {
                        target: wavyBar; property: "width"
                        from: root.width * 0.55; to: root.width * 0.04
                        duration: 800; easing.type: Easing.InCubic
                    }
                }
            }

            Shape {
                x: -wavyBar._phase
                width: wavyBar.width + _indeterminateWavelength * 2
                height: parent.height
                layer.enabled: false

                ShapePath {
                    strokeColor: Theme.ChiTheme.colors.primary
                    strokeWidth: root.trackThickness
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    joinStyle: ShapePath.RoundJoin

                    PathPolyline {
                        path: {
                            var pts = [];
                            var w = wavyBar.width + root._indeterminateWavelength * 2;
                            var cy = root._containerHeight / 2;
                            var amp = root._amplitude;
                            var wl = root._indeterminateWavelength;
                            if (w <= 0 || wl <= 0) return [Qt.point(0, cy)];
                            var step = 2;
                            for (var x = 0; x <= w; x += step) {
                                pts.push(Qt.point(x, cy + amp * Math.sin(2 * Math.PI * x / wl)));
                            }
                            return pts;
                        }
                    }
                }
            }
        }
    }

    // ═══════════════════════════════════════════════════════
    // STOP INDICATOR
    // ═══════════════════════════════════════════════════════

    Rectangle {
        visible: showStopIndicator && !indeterminate && !_isComplete && _hasProgress
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        width: _stopSize
        height: _stopSize
        radius: _stopSize / 2
        color: Theme.ChiTheme.colors.primary
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
