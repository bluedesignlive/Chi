// StateLayer.qml - Material 3 State Layer Component
// Reusable hover/press/focus overlay following Dieter Rams principles
// Single source of truth for all state layer implementations

import QtQuick

Rectangle {
    id: root

    // ─── Public API ───────────────────────────────────────────
    property color color: "white"           // State layer tint color
    property real radius: 0                  // Container radius
    property bool pressed: false             // Pressed state
    property bool hovered: false             // Hovered state
    property bool focused: false             // Focused state
    property bool enabled: true              // Whether state layer is active

    // ─── Material 3 State Layer Opacities ────────────────────
    // Hover: 0.08, Focus: 0.12, Press: 0.12
    readonly property real _opacity: {
        if (!enabled) return 0
        if (pressed) return 0.12
        if (focused) return 0.12
        if (hovered) return 0.08
        return 0
    }

    // ─── Implementation ───────────────────────────────────────
    anchors.fill: parent
    radius: root.radius
    color: root.color
    opacity: _opacity
    clip: true

    // Smooth transitions between states
    Behavior on opacity {
        NumberAnimation {
            duration: pressed ? 50 : 150
            easing.type: Easing.OutCubic
        }
    }
}
