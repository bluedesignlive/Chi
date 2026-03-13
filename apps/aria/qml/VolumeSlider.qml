import QtQuick
import Chi 1.0

// Volume control — Android 15 inspired.
// Pill track with center rail line, smooth fill, hover expand.
Item {
    id: root

    property real volume: 0.75
    property bool muted: false
    property var  colors: ChiTheme.colors

    // Expand on hover to reveal the slider track
    property bool _expanded: hoverSensor.containsMouse || dragArea.pressed
    property real _displayVol: muted ? 0 : volume

    width: _expanded ? 148 : 44
    height: 36

    Behavior on width { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }

    // ── Track container (pill shape) ────────────────────────
    Rectangle {
        id: track
        anchors.fill: parent
        radius: height / 2
        color: colors.surfaceContainerHigh
        clip: true

        // Center rail line — thin horizontal line, always visible when expanded
        Rectangle {
            visible: root._expanded
            anchors.verticalCenter: parent.verticalCenter
            x: 36; width: parent.width - 44
            height: 2; radius: 1
            color: colors.outlineVariant
            opacity: 0.5
        }

        // Active fill — grows from left edge
        Rectangle {
            id: fill
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: root._expanded ? Math.max(0, parent.width * root._displayVol) : 0
            radius: track.radius
            color: colors.primary
            opacity: 0.75

            Behavior on width { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 120 } }
        }

        // Icon + percentage label
        Row {
            id: content
            anchors.centerIn: parent
            spacing: 4

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.muted ? "\uE04F"
                    : root.volume < 0.01 ? "\uE04E"
                    : root.volume < 0.5  ? "\uE04D" : "\uE050"
                font.family: "Material Symbols Outlined"
                font.pixelSize: 20
                color: colors.onSurfaceVariant
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: Math.round(root.volume * 100) + "%"
                font.family: ChiTheme.fontFamily
                font.pixelSize: 12; font.weight: Font.Medium
                color: colors.onSurfaceVariant
                visible: root._expanded
            }
        }

        // Drag / click interaction
        MouseArea {
            id: dragArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            property real _startX: 0
            property real _startVol: 0

            onPressed: function(mouse) {
                _startX = mouse.x
                _startVol = root.volume
            }

            onPositionChanged: function(mouse) {
                if (!pressed || !root._expanded) return
                var delta = (mouse.x - _startX) / (parent.width - 20)
                root.volume = Math.max(0, Math.min(1, _startVol + delta))
                if (root.muted && root.volume > 0) root.muted = false
            }

            // Single click on track sets volume directly
            onClicked: function(mouse) {
                if (root._expanded && mouse.x > 30) {
                    root.volume = Math.max(0, Math.min(1, mouse.x / parent.width))
                    if (root.muted && root.volume > 0) root.muted = false
                }
            }

            // Double-click mutes/unmutes
            onDoubleClicked: root.muted = !root.muted

            // Scroll wheel adjusts volume
            onWheel: function(wheel) {
                root.volume = Math.max(0, Math.min(1, root.volume + (wheel.angleDelta.y > 0 ? 0.05 : -0.05)))
                if (root.muted && root.volume > 0) root.muted = false
            }
        }
    }

    // Hover sensor with overshoot to prevent flickering on edge
    MouseArea {
        id: hoverSensor
        anchors.fill: parent
        anchors.margins: -8
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        propagateComposedEvents: true
    }
}
