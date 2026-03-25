// Ripple.qml - Material 3 Ripple Effect Component
// Reusable ripple animation following Dieter Rams principle #9 (Environmentally friendly - minimal redraws)
// Single source of truth for all ripple animations across the library

import QtQuick

Item {
    id: root

    // ─── Public API ───────────────────────────────────────────
    property color color: "white"          // Ripple tint color
    property real radius: 0                 // Container radius (matches parent)
    property bool enabled: true             // Whether ripple is active

    // Call this to trigger the ripple animation
    function trigger() {
        if (enabled) rippleAnimation.restart()
    }

    // ─── Implementation ───────────────────────────────────────
    implicitWidth: 0
    implicitHeight: 0

    Rectangle {
        anchors.fill: parent
        radius: root.radius
        color: root.color
        opacity: 0
        clip: true

        // Material 3 ripple timing: 90ms fade in, 210ms fade out
        SequentialAnimation on opacity {
            id: rippleAnimation
            running: false
            NumberAnimation { from: 0; to: 0.16; duration: 90; easing.type: Easing.OutCubic }
            NumberAnimation { to: 0; duration: 210; easing.type: Easing.OutCubic }
        }
    }
}
