// IconButton.qml - Material 3 Icon Button
// Uses shared components (Icon, Ripple, StateLayer, SizeSpecs)

import QtQuick
import QtQuick.Effects
import "../../theme" as Theme
import "../common" as Common

Item {
    id: iconButton

    // ─── Public API ───────────────────────────────────────────
    property string icon: ""
    property string variant: "filled"        // filled | tonal | outlined | standard
    property string size: "small"            // xsmall | small | medium | large | xlarge
    property string widthMode: "default"     // narrow | default | wide
    property string shape: "round"           // round | square
    property bool enabled: true
    property string tooltip: ""

    signal clicked()

    // ─── Theme Tokens ───────────────────────────────────────────
    readonly property var colors: Theme.ChiTheme.colors
    readonly property var motion: Theme.ChiTheme.motion
    readonly property var spec: Theme.SizeSpecs.getSpec(Theme.SizeSpecs.iconButton, size)

    // ─── Derived Properties ─────────────────────────────────────
    readonly property int containerWidth: widthMode === "narrow" ? spec.narrowWidth :
                                          (widthMode === "wide" ? spec.wideWidth : spec.defaultWidth)

    readonly property bool _filled: variant === "filled"
    readonly property bool _tonal: variant === "tonal"
    readonly property bool _outlined: variant === "outlined"

    readonly property color _containerColor: {
        if (!enabled) {
            if (_filled || _tonal || _outlined)
                return Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.12)
            return "transparent"
        }
        if (_filled) return colors.primary
        if (_tonal) return colors.secondaryContainer
        if (_outlined) return colors.surfaceContainerLow
        return "transparent"
    }

    readonly property color _contentColor: _filled ? colors.onPrimary :
                                           _tonal ? colors.onSecondaryContainer :
                                           _outlined ? colors.primary : colors.onSurfaceVariant

    readonly property color _iconColor: enabled ? _contentColor : colors.onSurface

    // ─── Geometry ───────────────────────────────────────────────
    implicitWidth: containerWidth
    implicitHeight: spec.height

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity { NumberAnimation { duration: motion.durationMedium } }

    // ─── Visual Container ───────────────────────────────────────
    Rectangle {
        id: container
        anchors.centerIn: parent
        width: iconButton.containerWidth
        height: spec.height
        clip: true
        radius: shape === "round" ? 100 : spec.squareRadius

        color: iconButton._containerColor
        border.width: iconButton._outlined ? 1 : 0
        border.color: iconButton._outlined ? colors.outline : "transparent"

        Behavior on radius { NumberAnimation { duration: motion.durationFast } }
        Behavior on color { ColorAnimation { duration: motion.durationMedium } }

        // Shadow for filled/tonal variants
        layer.enabled: iconButton.enabled && (iconButton._filled || iconButton._tonal)
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.15)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: mouseArea.containsMouse ? 2 : 1
            shadowBlur: mouseArea.containsMouse ? 0.3 : 0.15
        }

        // State Layer
        Common.StateLayer {
            stateColor: iconButton._contentColor
            stateRadius: parent.radius
            pressed: mouseArea.pressed
            hovered: mouseArea.containsMouse
            focused: iconButton.activeFocus
            enabled: iconButton.enabled
        }

        // Ripple
        Common.Ripple {
            color: iconButton._contentColor
            radius: parent.radius
            enabled: iconButton.enabled
        }

        // Icon - using shared Icon component
        Common.Icon {
            anchors.centerIn: parent
            source: iconButton.icon
            size: spec.iconSize
            color: iconButton._iconColor
        }
    }

    // ─── Input ──────────────────────────────────────────────────
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: iconButton.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: iconButton.clicked()
    }

    // ─── Keyboard Support ───────────────────────────────────────
    Keys.onSpacePressed:  if (enabled) activate()
    Keys.onEnterPressed:  if (enabled) activate()
    Keys.onReturnPressed: if (enabled) activate()

    function activate() {
        clicked()
    }
}
