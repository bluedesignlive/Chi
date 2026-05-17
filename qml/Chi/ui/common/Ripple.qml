// Ripple.qml - Material 3 Ripple Effect Component
// Reusable ripple animation following Dieter Rams principle #9 (Environmentally friendly - minimal redraws)
// Single source of truth for all ripple animations across the library

import QtQuick
import "../../theme" as Theme

Item {
    id: root

    // ─── Public API ───────────────────────────────────────────
    property color color: "white"
    property real radius: 0
    property bool enabled: true

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

        SequentialAnimation on opacity {
            id: rippleAnimation
            running: false
            NumberAnimation { from: 0; to: Theme.ChiMotion.stateLayer.pressed; duration: Theme.ChiMotion.press.duration; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.ChiMotion.press.curve }
            NumberAnimation { to: 0; duration: Theme.ChiMotion.release.duration; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.ChiMotion.release.curve }
        }
    }
}
