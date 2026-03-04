// smartui/ui/progress/LinearProgressIndicator.qml
// M3 linear progress indicator — determinate + indeterminate
import QtQuick
import "../../theme" as Theme

Item {
    id: root

    property real progress: 0.0
    property bool indeterminate: false
    property bool wavy: false          // kept for API compat, ignored
    property real trackThickness: 4
    property bool showStopIndicator: true
    property bool enabled: true

    readonly property real _gap: 4.0
    readonly property real _stopSize: 4.0
    readonly property real _r: trackThickness / 2

    readonly property real _progress: Math.max(0, Math.min(1, progress))

    // Animated progress — Behavior handles the smooth transition
    property real _ap: _progress
    Behavior on _ap { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

    readonly property real _activeEnd: width * _ap
    readonly property bool _z: _ap < 0.005
    readonly property bool _f: _ap > 0.995
    readonly property bool _p: !_z && !_f
    readonly property real _trackX: _p ? _activeEnd + _gap : (_f ? width : 0)
    readonly property real _trackW: Math.max(0,
        width - (_p && showStopIndicator ? _stopSize + _gap : 0) - _trackX)

    implicitWidth: 240
    implicitHeight: trackThickness
    opacity: enabled ? 1.0 : 0.38

    // ═══════════════════════════════════════════════════════
    // DETERMINATE
    // ═══════════════════════════════════════════════════════

    // Track at 0%
    Rectangle {
        visible: !root.indeterminate && _z
        anchors.verticalCenter: parent.verticalCenter
        width: root.width; height: trackThickness; radius: _r
        color: Theme.ChiTheme.colors.secondaryContainer
    }

    // Track partial
    Rectangle {
        visible: !root.indeterminate && _p
        anchors.verticalCenter: parent.verticalCenter
        x: _trackX; width: _trackW; height: trackThickness; radius: _r
        color: Theme.ChiTheme.colors.secondaryContainer
    }

    // Active bar
    Rectangle {
        visible: !root.indeterminate && !_z
        anchors.verticalCenter: parent.verticalCenter
        width: _activeEnd; height: trackThickness; radius: _r
        color: Theme.ChiTheme.colors.primary
    }

    // ═══════════════════════════════════════════════════════
    // INDETERMINATE
    // ═══════════════════════════════════════════════════════

    Item {
        id: indet
        visible: root.indeterminate
        anchors.fill: parent
        clip: true

        // Track
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width; height: trackThickness; radius: _r
            color: Theme.ChiTheme.colors.secondaryContainer
        }

        property real h1: 0; property real t1: 0
        property real h2: 0; property real t2: 0

        SequentialAnimation {
            running: root.indeterminate && root.visible
            loops: Animation.Infinite

            ParallelAnimation {
                NumberAnimation { target: indet; property: "h1"; from: 0; to: 0.31; duration: 333; easing.type: Easing.InOutCubic }
                NumberAnimation { target: indet; property: "t1"; from: 0; to: 0; duration: 333 }
                NumberAnimation { target: indet; property: "h2"; from: 0; to: 0; duration: 333 }
                NumberAnimation { target: indet; property: "t2"; from: 0; to: 0; duration: 333 }
            }
            ParallelAnimation {
                NumberAnimation { target: indet; property: "h1"; from: 0.31; to: 0.80; duration: 417; easing.type: Easing.InOutCubic }
                NumberAnimation { target: indet; property: "t1"; from: 0; to: 0.24; duration: 417; easing.type: Easing.InOutCubic }
                NumberAnimation { target: indet; property: "h2"; from: 0; to: 0; duration: 417 }
                NumberAnimation { target: indet; property: "t2"; from: 0; to: 0; duration: 417 }
            }
            ParallelAnimation {
                NumberAnimation { target: indet; property: "h1"; from: 0.80; to: 1.0; duration: 250; easing.type: Easing.OutCubic }
                NumberAnimation { target: indet; property: "t1"; from: 0.24; to: 0.50; duration: 250; easing.type: Easing.InOutCubic }
                NumberAnimation { target: indet; property: "h2"; from: 0; to: 0; duration: 250 }
                NumberAnimation { target: indet; property: "t2"; from: 0; to: 0; duration: 250 }
            }
            ParallelAnimation {
                NumberAnimation { target: indet; property: "h1"; from: 1.0; to: 1.0; duration: 183 }
                NumberAnimation { target: indet; property: "t1"; from: 0.50; to: 0.72; duration: 183; easing.type: Easing.InOutCubic }
                NumberAnimation { target: indet; property: "h2"; from: 0; to: 0.18; duration: 183; easing.type: Easing.InOutCubic }
                NumberAnimation { target: indet; property: "t2"; from: 0; to: 0; duration: 183 }
            }
            ParallelAnimation {
                NumberAnimation { target: indet; property: "h1"; from: 1.0; to: 1.0; duration: 84 }
                NumberAnimation { target: indet; property: "t1"; from: 0.72; to: 1.0; duration: 84; easing.type: Easing.OutCubic }
                NumberAnimation { target: indet; property: "h2"; from: 0.18; to: 0.35; duration: 84; easing.type: Easing.InOutCubic }
                NumberAnimation { target: indet; property: "t2"; from: 0; to: 0; duration: 84 }
            }
            ParallelAnimation {
                NumberAnimation { target: indet; property: "h1"; from: 1.0; to: 1.0; duration: 300 }
                NumberAnimation { target: indet; property: "t1"; from: 1.0; to: 1.0; duration: 300 }
                NumberAnimation { target: indet; property: "h2"; from: 0.35; to: 1.0; duration: 300; easing.type: Easing.InOutCubic }
                NumberAnimation { target: indet; property: "t2"; from: 0; to: 0.42; duration: 300; easing.type: Easing.InOutCubic }
            }
            ParallelAnimation {
                NumberAnimation { target: indet; property: "h1"; from: 1.0; to: 1.0; duration: 233 }
                NumberAnimation { target: indet; property: "t1"; from: 1.0; to: 1.0; duration: 233 }
                NumberAnimation { target: indet; property: "h2"; from: 1.0; to: 1.0; duration: 233 }
                NumberAnimation { target: indet; property: "t2"; from: 0.42; to: 1.0; duration: 233; easing.type: Easing.InOutCubic }
            }
        }

        // Segment 1
        Rectangle {
            id: s1
            visible: indet.h1 > indet.t1 + 0.003
            anchors.verticalCenter: parent.verticalCenter
            x: indet.t1 * root.width
            width: (indet.h1 - indet.t1) * root.width
            height: trackThickness; radius: _r
            color: Theme.ChiTheme.colors.primary
        }
        Rectangle {
            visible: s1.visible && indet.t1 > 0.015
            anchors.verticalCenter: parent.verticalCenter
            x: s1.x - _gap; width: _gap; height: trackThickness
            color: Theme.ChiTheme.colors.surface
        }
        Rectangle {
            visible: s1.visible && indet.h1 < 0.985
            anchors.verticalCenter: parent.verticalCenter
            x: s1.x + s1.width; width: _gap; height: trackThickness
            color: Theme.ChiTheme.colors.surface
        }

        // Segment 2
        Rectangle {
            id: s2
            visible: indet.h2 > indet.t2 + 0.003
            anchors.verticalCenter: parent.verticalCenter
            x: indet.t2 * root.width
            width: (indet.h2 - indet.t2) * root.width
            height: trackThickness; radius: _r
            color: Theme.ChiTheme.colors.primary
        }
        Rectangle {
            visible: s2.visible && indet.t2 > 0.015
            anchors.verticalCenter: parent.verticalCenter
            x: s2.x - _gap; width: _gap; height: trackThickness
            color: Theme.ChiTheme.colors.surface
        }
        Rectangle {
            visible: s2.visible && indet.h2 < 0.985
            anchors.verticalCenter: parent.verticalCenter
            x: s2.x + s2.width; width: _gap; height: trackThickness
            color: Theme.ChiTheme.colors.surface
        }
    }

    // ═══════════════════════════════════════════════════════
    // STOP INDICATOR
    // ═══════════════════════════════════════════════════════

    Rectangle {
        visible: showStopIndicator && _p && !root.indeterminate
        anchors.verticalCenter: parent.verticalCenter
        x: root.width - _stopSize
        width: _stopSize; height: _stopSize; radius: _stopSize / 2
        color: Theme.ChiTheme.colors.primary
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
