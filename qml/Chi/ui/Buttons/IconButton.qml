// IconButton.qml - Material 3 Icon Button
// All sizes and tokens per M3 Expressive spec
// All animation from ChiMotion — no hardcoded values

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
    property bool selected: false
    property string tooltip: ""

    signal clicked

    // ─── Theme Tokens ───────────────────────────────────────────
    readonly property var colors: Theme.ChiTheme.colors
    readonly property int animDur: Theme.ChiMotion.spring.fast.effects.duration

    // ─── Size Specifications ─────────────────────────────────────
    readonly property var spec: Theme.SizeSpecs.getSpec(Theme.SizeSpecs.iconButton, size)

    // ─── Derived Properties ─────────────────────────────────────
    readonly property int containerWidth: {
        if (widthMode === "narrow")
            return spec.narrowWidth;
        if (widthMode === "wide")
            return spec.wideWidth;
        return spec.defaultWidth;
    }

    readonly property bool _filled: variant === "filled"
    readonly property bool _tonal: variant === "tonal"
    readonly property bool _outlined: variant === "outlined"
    readonly property bool _standard: variant === "standard"

    readonly property color _containerColor: {
        if (!enabled) {
            if (_filled || _tonal || _outlined)
                return Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.12);
            return "transparent";
        }
        if (_filled)
            return colors.primary;
        if (_tonal)
            return colors.secondaryContainer;
        if (_outlined)
            return "transparent";
        return "transparent";
    }

    readonly property color _iconColor: {
        if (!enabled)
            return colors.onSurface;
        if (_filled)
            return colors.onPrimary;
        if (_tonal)
            return colors.onSecondaryContainer;
        if (_outlined) {
            if (selected)
                return colors.onSurface;
            return colors.onSurfaceVariant;
        }
        // standard
        if (selected)
            return colors.primary;
        return colors.onSurfaceVariant;
    }

    readonly property color _stateLayerColor: {
        if (_filled)
            return colors.onPrimary;
        if (_tonal)
            return colors.onSecondaryContainer;
        if (_outlined)
            return colors.onSurfaceVariant;
        return colors.onSurfaceVariant;
    }

    // ─── Geometry ───────────────────────────────────────────────
    implicitWidth: containerWidth
    implicitHeight: spec.height

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity {
        enabled: Theme.ChiMotion.animationsEnabled
        NumberAnimation {
            duration: animDur
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Theme.ChiMotion.easing.standard
        }
    }

    // ─── Visual Container ───────────────────────────────────────
    Rectangle {
        id: container
        anchors.centerIn: parent
        width: iconButton.containerWidth
        height: spec.height
        clip: true
        radius: shape === "round" ? spec.height / 2 : spec.squareRadius

        color: iconButton._containerColor
        border.width: _outlined && !selected ? 1 : 0
        border.color: _outlined ? colors.outline : "transparent"

        Behavior on radius {
            enabled: Theme.ChiMotion.animationsEnabled
            NumberAnimation {
                duration: animDur
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Theme.ChiMotion.easing.standard
            }
        }
        Behavior on color {
            enabled: Theme.ChiMotion.animationsEnabled
            ColorAnimation {
                duration: animDur
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Theme.ChiMotion.easing.standard
            }
        }

        // Selected — outlined variant gets filled background
        Rectangle {
            visible: iconButton.selected && iconButton._outlined
            anchors.fill: parent
            radius: parent.radius
            color: colors.onSurface
            Behavior on opacity {
                enabled: Theme.ChiMotion.animationsEnabled
                NumberAnimation {
                    duration: animDur
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Theme.ChiMotion.easing.standard
                }
            }
        }

        // Elevation for filled/tonal
        layer.enabled: iconButton.enabled && (iconButton._filled || iconButton._tonal)
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Theme.ChiElevation.shadowColor(Theme.ChiElevation.level1)
            shadowOpacity: Theme.ChiElevation.shadowOpacity(Theme.ChiElevation.level1)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: mouseArea.containsMouse ? Theme.ChiElevation.verticalOffset(Theme.ChiElevation.level2) : Theme.ChiElevation.verticalOffset(Theme.ChiElevation.level1)
            shadowBlur: mouseArea.containsMouse ? Theme.ChiElevation.blurRadius(Theme.ChiElevation.level2) : Theme.ChiElevation.blurRadius(Theme.ChiElevation.level1)
        }

        // State Layer
        Common.StateLayer {
            layerColor: _stateLayerColor
            containerRadius: parent.radius
            pressed: mouseArea.pressed
            hovered: mouseArea.containsMouse
            focused: iconButton.activeFocus
            enabled: iconButton.enabled
        }

        // Ripple
        Common.Ripple {
            id: rippleLayer
            color: _stateLayerColor
            radius: parent.radius
            enabled: iconButton.enabled
        }

        // Icon
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
        onPressed: (mouse) => rippleLayer.addRipple(mouse.x, mouse.y)
        onReleased: rippleLayer.removeRipple()
        onCanceled: rippleLayer.removeRipple()
        onClicked: iconButton.clicked()
    }

    // ─── Keyboard Support ───────────────────────────────────────
    Keys.onSpacePressed: if (enabled)
        activate()
    Keys.onEnterPressed: if (enabled)
        activate()
    Keys.onReturnPressed: if (enabled)
        activate()

    function activate() {
        rippleLayer.addRipple();
        rippleLayer.removeRipple();
        clicked();
    }
}
