// IconButtonToggle.qml - Material 3 Expressive Icon Button Toggle
// Implements M3 tokenization while preserving specific morphing behavior

import QtQuick
import "../../theme" as Theme
import "../common" as Common
import "../menus" as Menus

Item {
    id: root

    // ─── Public API ───────────────────────────────────────────
    property string icon: "star_outline"
    property string selectedIcon: "star"
    property string variant: "standard"      // standard | filled | tonal | outlined
    property string size: "medium"           // xsmall | small | medium | large | xlarge
    property string widthMode: "default"     // narrow | default | wide
    property bool selected: false
    property alias toggled: root.selected    // Alias for ButtonsPage compatibility
    property bool enabled: true
    property string tooltip: ""

    signal toggleChanged(bool isSelected)
    signal toggled(bool isSelected)          // Emitted for backward compatibility

    // ─── Tokens & Sizes ───────────────────────────────────────
    readonly property var colors: Theme.ChiTheme.colors
    readonly property var motion: Theme.ChiTheme.motion
    readonly property var spec: Theme.SizeSpecs.getSpec(Theme.SizeSpecs.iconButton, size)

    readonly property string effectiveIcon: selected && selectedIcon !== "" ? selectedIcon : icon

    readonly property bool _filled: variant === "filled"
    readonly property bool _tonal: variant === "tonal"
    readonly property bool _outlined: variant === "outlined"

    readonly property int containerWidth: {
        if (widthMode === "narrow") return spec.narrowWidth
        if (widthMode === "wide") return spec.wideWidth
        return spec.defaultWidth
    }

    // ─── Colors (M3 Toggle Specs) ─────────────────────────────
    readonly property color _containerColor: {
        if (!enabled) {
            if (_filled || _tonal || _outlined)
                return Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.12)
            return "transparent"
        }
        if (_filled) return selected ? colors.primary : colors.surfaceContainerHighest
        if (_tonal) return selected ? colors.secondaryContainer : colors.surfaceContainerHighest
        if (_outlined && selected) return colors.inverseSurface
        return "transparent"
    }

    readonly property color _iconColor: {
        if (!enabled) return Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.38)
        if (_filled) return selected ? colors.onPrimary : colors.primary
        if (_tonal) return selected ? colors.onSecondaryContainer : colors.onSurfaceVariant
        if (_outlined) return selected ? colors.inverseOnSurface : colors.onSurfaceVariant
        return selected ? colors.primary : colors.onSurfaceVariant
    }

    // ─── Geometry ─────────────────────────────────────────────
    implicitWidth: containerWidth
    implicitHeight: spec.height

    opacity: enabled ? 1.0 : 0.6
    Behavior on opacity {
        enabled: motion.animationsEnabled
        NumberAnimation {
            duration: motion.durationMedium
            easing.type: Easing.BezierSpline
            easing.bezierCurve: motion.easing.standard
        }
    }

    Rectangle {
        id: container
        anchors.centerIn: parent
        width: root.containerWidth
        height: spec.height
        clip: true
        
        // M3 Morphing: Round when unselected, Square when selected
        radius: root.selected ? spec.squareRadius : height / 2

        color: _containerColor
        border.width: _outlined && !selected ? 1 : 0
        border.color: _outlined ? colors.outline : "transparent"

        Behavior on radius {
            enabled: motion.animationsEnabled
            NumberAnimation {
                duration: motion.durationMedium
                easing.type: Easing.BezierSpline
                easing.bezierCurve: motion.easing.standard
            }
        }
        Behavior on color {
            enabled: motion.animationsEnabled
            ColorAnimation {
                duration: motion.durationMedium
                easing.type: Easing.BezierSpline
                easing.bezierCurve: motion.easing.standard
            }
        }
        Behavior on border.color {
            enabled: motion.animationsEnabled
            ColorAnimation { duration: motion.durationFast }
        }

        Common.StateLayer {
            layerColor: _iconColor
            containerRadius: parent.radius
            pressed: mouseArea.pressed
            hovered: mouseArea.containsMouse
            focused: root.activeFocus
            enabled: root.enabled
        }

        Common.Ripple {
            color: _iconColor
            radius: parent.radius
            enabled: root.enabled
        }

        Common.Icon {
            anchors.centerIn: parent
            source: root.effectiveIcon
            size: spec.iconSize
            color: root._iconColor
        }

        // Focus indicator
        Rectangle {
            visible: root.activeFocus && !mouseArea.pressed
            anchors.fill: parent
            anchors.margins: -2
            radius: parent.radius + 2
            color: "transparent"
            border.width: 2
            border.color: colors.primary
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: _activate()
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
        root.selected = !root.selected
        root.toggled(root.selected)
        root.toggleChanged(root.selected)
    }
}
