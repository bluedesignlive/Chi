// StateLayer.qml - Material 3 State Layer Component
// Reusable hover/press/focus overlay following Dieter Rams principles
// Single source of truth for all state layer implementations

import QtQuick
import "../../theme" as Theme

Rectangle {
    id: root

    // ─── Public API ───────────────────────────────────────────
    property color layerColor: "white"
    property real containerRadius: 0
    property bool pressed: false
    property bool hovered: false
    property bool focused: false
    property bool dragged: false
    property bool enabled: true

    // ─── Material 3 State Layer Opacities ────────────────────
    readonly property real _opacity: {
        if (!enabled) return 0
        if (dragged)  return Theme.ChiMotion.stateLayer.dragged
        if (pressed) return Theme.ChiMotion.stateLayer.pressed
        if (focused) return Theme.ChiMotion.stateLayer.focus
        if (hovered) return Theme.ChiMotion.stateLayer.hover
        return 0
    }

    // ─── Implementation ───────────────────────────────────────
    anchors.fill: parent
    radius: root.containerRadius
    color: root.layerColor
    opacity: _opacity
    clip: true

    // Smooth transitions between states
    Behavior on opacity {
        enabled: Theme.ChiMotion.animationsEnabled
        OpacityAnimator {
            duration: pressed
                ? Theme.ChiMotion.press.duration
                : Theme.ChiMotion.hoverState.duration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: pressed
                ? Theme.ChiMotion.press.curve
                : Theme.ChiMotion.hoverState.curve
        }
    }
}
