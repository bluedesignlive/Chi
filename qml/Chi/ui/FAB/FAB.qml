// FAB.qml - Material 3 Floating Action Button
// Uses shared components (Icon, Ripple, StateLayer) following Dieter Rams principles

import QtQuick
import QtQuick.Effects
import "../../theme" as Theme
import "../common" as Common

Item {
    id: fab

    // ─── Public API ───────────────────────────────────────────
    property string icon: "add"
    property string variant: "primary"       // primary | secondary | tertiary | surface
    property string size: "medium"           // small | medium | large
    property bool enabled: true
    property bool menuOpen: false

    signal clicked()

    // ─── Theme Tokens ───────────────────────────────────────────
    readonly property var colors: Theme.ChiTheme.colors
    readonly property var motion: Theme.ChiTheme.motion
    readonly property var spec: Theme.SizeSpecs.getSpec(Theme.SizeSpecs.fab, size)

    // ─── Variant Colors ──────────────────────────────────────────
    readonly property color _containerColor: {
        switch (variant) {
            case "secondary": return colors.secondaryContainer
            case "tertiary": return colors.tertiaryContainer
            case "surface": return colors.surfaceContainerHigh
            default: return colors.primaryContainer
        }
    }

    readonly property color _contentColor: {
        switch (variant) {
            case "secondary": return colors.onSecondaryContainer
            case "tertiary": return colors.onTertiaryContainer
            case "surface": return colors.primary
            default: return colors.onPrimaryContainer
        }
    }

    // ─── Geometry ───────────────────────────────────────────────
    implicitWidth: spec.size
    implicitHeight: spec.size

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity {
        NumberAnimation { duration: motion.durationMedium; easing.type: motion.easeStandard }
    }

    // ─── Visual Container ───────────────────────────────────────
    Rectangle {
        id: container
        anchors.fill: parent
        radius: spec.radius
        clip: true
        color: fab._containerColor

        // Shadow
        layer.enabled: fab.enabled
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.25)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: mouseArea.containsMouse ? 4 : 2
            shadowBlur: mouseArea.containsMouse ? 0.4 : 0.2
        }

        // State Layer
        Common.StateLayer {
            stateColor: fab._contentColor
            stateRadius: parent.radius
            pressed: mouseArea.pressed
            hovered: mouseArea.containsMouse
            focused: fab.activeFocus
            enabled: fab.enabled
        }

        // Ripple
        Common.Ripple {
            id: ripple
            color: fab._contentColor
            radius: parent.radius
            enabled: fab.enabled
        }

        // Icon - using shared Icon component
        Common.Icon {
            anchors.centerIn: parent
            source: fab.icon
            size: spec.iconSize
            color: fab._contentColor
            rotation: fab.menuOpen ? 45 : 0
            Behavior on rotation { NumberAnimation { duration: motion.durationMedium } }
        }
    }

    // ─── Input ──────────────────────────────────────────────────
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: fab.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: fab.clicked()
    }

    // ─── Keyboard Support ───────────────────────────────────────
    Keys.onSpacePressed:  if (enabled) activate()
    Keys.onEnterPressed:  if (enabled) activate()
    Keys.onReturnPressed: if (enabled) activate()

    function activate() {
        clicked()
    }
}
