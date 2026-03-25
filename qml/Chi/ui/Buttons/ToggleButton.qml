// ToggleButton.qml - Material 3 Toggle Button
// Uses shared components (Icon, Ripple, StateLayer) following Dieter Rams principles

import QtQuick
import QtQuick.Effects
import "../../theme" as Theme
import "../common" as Common

Item {
    id: toggleButton

    // ─── Public API ───────────────────────────────────────────
    property string text: "Toggle"
    property string variant: "filled"       // filled | elevated | tonal | outlined
    property string size: "small"           // xsmall | small | medium | large | xlarge
    property string shape: "round"          // round | square
    property bool selected: false
    property bool showIcon: false
    property string icon: ""
    property string selectedIcon: ""
    property bool enabled: true

    signal toggled(bool selected)

    // ─── Theme Tokens ───────────────────────────────────────────
    readonly property var colors: Theme.ChiTheme.colors
    readonly property var motion: Theme.ChiTheme.motion
    readonly property var typography: Theme.ChiTheme.typography
    readonly property string fontFamily: Theme.ChiTheme.fontFamily
    readonly property string iconFamily: Theme.ChiTheme.iconFamily

    // ─── Size Specifications ────────────────────────────────────
    readonly property var sizeSpecs: ({
        xsmall: { height: 36, padding: 6, horizontalPadding: 14, gap: 4, iconSize: 18, fontSize: 12, fontWeight: Font.Medium, letterSpacing: 0.1, squareRadius: 10, borderWidth: 1 },
        small:  { height: 44, padding: 10, horizontalPadding: 18, gap: 6, iconSize: 20, fontSize: 14, fontWeight: Font.Medium, letterSpacing: 0.1, squareRadius: 12, borderWidth: 1 },
        medium: { height: 56, padding: 16, horizontalPadding: 26, gap: 8, iconSize: 24, fontSize: 16, fontWeight: Font.Medium, letterSpacing: 0.15, squareRadius: 16, borderWidth: 1 },
        large:  { height: 72, padding: 24, horizontalPadding: 36, gap: 10, iconSize: 28, fontSize: 18, fontWeight: Font.Normal, letterSpacing: 0, squareRadius: 20, borderWidth: 2 },
        xlarge: { height: 96, padding: 32, horizontalPadding: 48, gap: 12, iconSize: 36, fontSize: 22, fontWeight: Font.Normal, letterSpacing: 0, squareRadius: 28, borderWidth: 2 }
    })

    readonly property var spec: sizeSpecs[size] || sizeSpecs.small

    // ─── Variant Flags ──────────────────────────────────────────
    readonly property bool _filled: variant === "filled"
    readonly property bool _elevated: variant === "elevated"
    readonly property bool _tonal: variant === "tonal"
    readonly property bool _outlined: variant === "outlined"

    readonly property string currentIcon: selected && selectedIcon !== "" ? selectedIcon : icon

    // ─── Colors ─────────────────────────────────────────────────
    readonly property color _interactColor: {
        if (!selected) {
            if (_filled)   return colors.onSurfaceVariant
            if (_elevated) return colors.primary
            if (_tonal)    return colors.onSurfaceVariant
            if (_outlined) return colors.onSecondaryContainer
            return colors.primary
        }
        if (_filled || _elevated) return colors.onPrimary
        if (_tonal)    return colors.inverseOnSurface
        if (_outlined) return colors.onSecondary
        return colors.onPrimary
    }

    readonly property color _labelColor: enabled ? _interactColor : colors.onSurface

    // ─── Geometry ───────────────────────────────────────────────
    implicitWidth: buttonContent.implicitWidth
    implicitHeight: spec.height

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity { NumberAnimation { duration: motion.durationMedium } }

    // ─── Visual Container ───────────────────────────────────────
    Rectangle {
        id: container
        anchors.fill: parent
        radius: shape === "round" ? 100 : spec.squareRadius
        clip: true

        color: {
            if (!toggleButton.enabled) return "transparent"
            if (toggleButton._filled)   return toggleButton.selected ? colors.primary : colors.surfaceContainer
            if (toggleButton._elevated) return toggleButton.selected ? colors.primary : colors.surfaceContainerLow
            if (toggleButton._tonal)    return toggleButton.selected ? colors.inverseSurface : "transparent"
            if (toggleButton._outlined) return toggleButton.selected ? colors.secondary : colors.secondaryContainer
            return colors.primary
        }

        border.width: (!toggleButton.selected && toggleButton._tonal) ? spec.borderWidth : 0
        border.color: (!toggleButton.selected && toggleButton._tonal) ? colors.outlineVariant : "transparent"

        // Disabled overlay
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            visible: !toggleButton.enabled
            color: colors.onSurface
            opacity: 0.12
        }

        // State Layer
        Common.StateLayer {
            color: toggleButton._interactColor
            radius: parent.radius
            pressed: mouseArea.pressed
            hovered: mouseArea.containsMouse
            focused: toggleButton.activeFocus
            enabled: toggleButton.enabled
        }

        // Ripple
        Common.Ripple {
            color: toggleButton._interactColor
            radius: parent.radius
            enabled: toggleButton.enabled
        }

        // Content
        Row {
            id: buttonContent
            anchors.centerIn: parent
            spacing: spec.gap
            padding: spec.padding
            leftPadding: spec.horizontalPadding
            rightPadding: spec.horizontalPadding

            Common.Icon {
                visible: toggleButton.showIcon && toggleButton.currentIcon !== ""
                source: toggleButton.currentIcon
                size: spec.iconSize
                color: toggleButton._labelColor
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: labelText
                text: toggleButton.text
                font.family: fontFamily
                font.weight: spec.fontWeight
                font.pixelSize: spec.fontSize
                font.letterSpacing: spec.letterSpacing
                verticalAlignment: Text.AlignVCenter
                color: toggleButton._labelColor
                anchors.verticalCenter: parent.verticalCenter
                Behavior on color { ColorAnimation { duration: motion.durationMedium } }
            }
        }

        // Elevation for elevated variant
        layer.enabled: toggleButton._elevated && toggleButton.enabled
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.3)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 1
            shadowBlur: 0.15
        }

        Behavior on color { ColorAnimation { duration: motion.durationMedium } }
        Behavior on border.color { ColorAnimation { duration: motion.durationMedium } }
    }

    // ─── Input ──────────────────────────────────────────────────
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: toggleButton.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: {
            toggleButton.selected = !toggleButton.selected
            toggleButton.toggled(toggleButton.selected)
        }
    }

    // ─── Keyboard Support ───────────────────────────────────────
    Keys.onSpacePressed:  if (enabled) activate()
    Keys.onEnterPressed:  if (enabled) activate()
    Keys.onReturnPressed: if (enabled) activate()

    function activate() {
        selected = !selected
        toggled(selected)
    }
}
