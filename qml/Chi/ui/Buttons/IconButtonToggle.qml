// IconButtonToggle — Toggleable icon button with selected/unselected states
// All sizes and tokens per M3 Expressive spec
// All animation from ChiMotion — no hardcoded values

import QtQuick
import "../../theme" as Theme
import "../common" as Common
import "../menus" as Menus

Item {
    id: root

    // ─── Public API ───────────────────────────────────────────
    property string icon: "star_outline"
    property string selectedIcon: "star"
    property string variant: "filled"        // filled | tonal | outlined | standard
    property string size: "small"
    property string widthMode: "default"
    property bool selected: false
    property bool enabled: true
    property string tooltip: ""

    signal toggled(bool selected)

    // ─── Theme Tokens ───────────────────────────────────────────
    readonly property var colors: Theme.ChiTheme.colors
    readonly property int animDur: Theme.ChiMotion.spring.fast.effects.duration

    // ─── Size Specifications ─────────────────────────────────────
    readonly property var sizeSpecs: Theme.SizeSpecs.iconButton
    readonly property var cs: sizeSpecs[size] || sizeSpecs.small

    readonly property int containerWidth: {
        if (widthMode === "narrow") return cs.narrowWidth
        if (widthMode === "wide") return cs.wideWidth
        return cs.defaultWidth
    }

    readonly property string effectiveIcon:
        selected && selectedIcon !== "" ? selectedIcon : icon

    // ─── Variant Flags ──────────────────────────────────────────
    readonly property bool _filled: variant === "filled"
    readonly property bool _tonal: variant === "tonal"
    readonly property bool _outlined: variant === "outlined"
    readonly property bool _standard: variant === "standard"

    // ─── Derived Colors ─────────────────────────────────────────
    readonly property color _containerColor: {
        if (!enabled) {
            if (_filled || _tonal || _outlined)
                return Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.12)
            return "transparent"
        }
        if (selected) {
            if (_filled) return colors.primary
            if (_tonal) return colors.secondaryContainer
            if (_outlined) return "transparent"
            return "transparent"
        }
        // unselected
        if (_filled || _tonal) return colors.surfaceContainer
        return "transparent"
    }

    readonly property color _iconColor: {
        if (!enabled) return colors.onSurface
        if (selected) {
            if (_filled) return colors.onPrimary
            if (_tonal) return colors.onSecondaryContainer
            if (_outlined) return colors.inverseOnSurface
            return colors.primary
        }
        if (_outlined) return colors.primary
        return colors.onSurfaceVariant
    }

    readonly property color _stateLayerColor: {
        if (_filled) return colors.onPrimary
        if (_tonal) return colors.onSecondaryContainer
        if (_outlined) return selected ? colors.inverseOnSurface : colors.primary
        return colors.onSurfaceVariant
    }

    // ─── Geometry ───────────────────────────────────────────────
    implicitWidth: containerWidth
    implicitHeight: cs.height

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity {
        enabled: Theme.ChiMotion.animationsEnabled
        NumberAnimation {
            duration: Theme.ChiMotion.colorChange.duration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Theme.ChiMotion.colorChange.curve
        }
    }

    // ─── Visual Container ───────────────────────────────────────
    Rectangle {
        id: container
        anchors.centerIn: parent
        width: root.containerWidth
        height: cs.height
        clip: true
        radius: root.selected ? cs.squareRadius : height / 2

        color: root._containerColor
        border.width: _outlined && !selected ? 1 : 0
        border.color: _outlined && !selected ? colors.outline : "transparent"

        Behavior on radius {
            enabled: Theme.ChiMotion.animationsEnabled
            NumberAnimation {
                duration: 250
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Theme.ChiMotion.spring.fast.effects.curve
            }
        }
        Behavior on color {
            enabled: Theme.ChiMotion.animationsEnabled
            ColorAnimation {
                duration: Theme.ChiMotion.colorChange.duration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Theme.ChiMotion.colorChange.curve
            }
        }

        // Selected — outlined variant gets filled background
        Rectangle {
            visible: root.selected && root._outlined
            anchors.fill: parent
            radius: parent.radius
            color: colors.inverseSurface
            Behavior on opacity {
                enabled: Theme.ChiMotion.animationsEnabled
                NumberAnimation {
                    duration: animDur
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Theme.ChiMotion.easing.standard
                }
            }
        }

        // Ripple
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: root._stateLayerColor
            opacity: 0

            SequentialAnimation on opacity {
                id: rippleAnimation
                running: false
                NumberAnimation { from: 0; to: 0.16; duration: Theme.ChiMotion.press.duration; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.ChiMotion.press.curve }
                NumberAnimation { to: 0; duration: Theme.ChiMotion.release.duration; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.ChiMotion.release.curve }
            }
        }

        // State layer
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: root._stateLayerColor
            opacity: !root.enabled ? 0
                : mouseArea.pressed ? Theme.ChiMotion.stateLayer.pressed
                : root.activeFocus ? Theme.ChiMotion.stateLayer.focus
                : mouseArea.containsMouse ? Theme.ChiMotion.stateLayer.hover
                : 0

            Behavior on opacity {
                enabled: Theme.ChiMotion.animationsEnabled
                NumberAnimation {
                    duration: mouseArea.pressed ? Theme.ChiMotion.press.duration : Theme.ChiMotion.hoverState.duration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: mouseArea.pressed ? Theme.ChiMotion.press.curve : Theme.ChiMotion.hoverState.curve
                }
            }
        }

        // Icon — uses Common.Icon for cross-platform reliability
        Common.Icon {
            anchors.centerIn: parent
            source: root.effectiveIcon
            size: cs.iconSize
            color: root._iconColor
        }

        // Focus indicator
        Rectangle {
            visible: root.activeFocus && !mouseArea.pressed
            anchors.fill: parent
            anchors.margins: 2
            radius: parent.radius
            color: "transparent"
            border.width: 3
            border.color: colors.secondary
        }
    }

    // ─── Input ──────────────────────────────────────────────────
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onPressed: rippleAnimation.restart()
        onClicked: {
            root.selected = !root.selected
            root.toggled(root.selected)
        }
    }

    Menus.Tooltip {
        target: mouseArea
        text: root.tooltip
        delay: 500
    }

    Keys.onSpacePressed: if (enabled) _activate()
    Keys.onEnterPressed: if (enabled) _activate()
    Keys.onReturnPressed: if (enabled) _activate()

    function _activate() {
        rippleAnimation.restart()
        selected = !selected
        toggled(selected)
    }
}
