// ToggleButton.qml - Material 3 Toggle Button
// All sizes and tokens per M3 Expressive spec

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
    readonly property var motion: Theme.ChiMotion
    readonly property var typo: Theme.ChiTheme.typography
    readonly property int animDur: Theme.ChiMotion.duration.short4

    // ─── Size Specifications ────────────────────────────────────
    readonly property var spec: Theme.SizeSpecs.getSpec(Theme.SizeSpecs.button, size)
    readonly property var typeStyle: typo[spec.typo] ?? typo.labelLarge

    // ─── Variant Flags ──────────────────────────────────────────
    readonly property bool _filled: variant === "filled"
    readonly property bool _elevated: variant === "elevated"
    readonly property bool _tonal: variant === "tonal"
    readonly property bool _outlined: variant === "outlined"

    readonly property string currentIcon: selected && selectedIcon !== "" ? selectedIcon : icon

    // ─── Colors from semantic tokens ─────────────────────────────
    readonly property color _interactColor: {
        if (!selected) {
            if (_filled)
                return colors.onSurfaceVariant;
            if (_elevated)
                return colors.primary;
            if (_tonal)
                return colors.onSurfaceVariant;
            if (_outlined)
                return colors.onSecondaryContainer;
            return colors.primary;
        }
        if (_filled || _elevated)
            return colors.onPrimary;
        if (_tonal)
            return colors.inverseOnSurface;
        if (_outlined)
            return colors.onSecondary;
        return colors.onPrimary;
    }

    readonly property color _labelColor: enabled ? _interactColor : colors.onSurface

    readonly property color _containerColor: {
        if (!enabled)
            return "transparent";
        if (_filled)
            return selected ? colors.primary : colors.surfaceContainerLow;
        if (_elevated)
            return selected ? colors.primary : colors.surfaceContainerLow;
        if (_tonal)
            return selected ? colors.inverseSurface : "transparent";
        if (_outlined)
            return selected ? colors.secondaryContainer : "transparent";
        return colors.primary;
    }

    readonly property color _outlineColor: {
        if (!_outlined)
            return "transparent";
        if (selected)
            return colors.secondary;
        return colors.outline;
    }

    // ─── Geometry ───────────────────────────────────────────────
    implicitWidth: buttonContent.implicitWidth
    implicitHeight: spec.height

    opacity: enabled ? 1.0 : 0.38

    Behavior on opacity {
        enabled: Theme.ChiMotion.animationsEnabled
        NumberAnimation {
            duration: animDur
        }
    }

    // ─── Visual Container ───────────────────────────────────────
    Rectangle {
        id: container
        anchors.fill: parent
        radius: shape === "round" ? height / 2 : spec.squareRadius
        clip: true

        color: toggleButton._containerColor
        border.width: (!toggleButton.selected && toggleButton._tonal) ? 1 : toggleButton._outlined ? 1 : 0
        border.color: toggleButton._outlineColor

        // Disabled overlay
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            visible: !toggleButton.enabled
            color: colors.onSurface
            opacity: 0.12
        }

        // Shape morph on press
        Behavior on radius {
            enabled: Theme.ChiMotion.animationsEnabled
            SpringAnimation {
                spring: Theme.ChiMotion.fastStiffness
                damping: Theme.ChiMotion.fastDamping
                duration: animDur
            }
        }

        Behavior on color {
            enabled: Theme.ChiMotion.animationsEnabled
            ColorAnimation {
                duration: animDur
            }
        }
        Behavior on border.color {
            enabled: Theme.ChiMotion.animationsEnabled
            ColorAnimation {
                duration: animDur
            }
        }

        // State Layer
        Common.StateLayer {
            layerColor: toggleButton._interactColor
            containerRadius: parent.radius
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
            topPadding: spec.verticalPadding
            bottomPadding: spec.verticalPadding
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
                font.family: typeStyle.family
                font.weight: typeStyle.weight
                font.pixelSize: typeStyle.size
                font.letterSpacing: typeStyle.spacing
                verticalAlignment: Text.AlignVCenter
                color: toggleButton._labelColor
                anchors.verticalCenter: parent.verticalCenter
                Behavior on color {
                    enabled: Theme.ChiMotion.animationsEnabled
                    ColorAnimation {
                        duration: animDur
                    }
                }
            }
        }

        // Elevation for elevated variant
        layer.enabled: toggleButton._elevated && toggleButton.enabled && !mouseArea.pressed
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Theme.ChiElevation.shadowColor(Theme.ChiElevation.level1)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: Theme.ChiElevation.verticalOffset(Theme.ChiElevation.level1)
            shadowBlur: Theme.ChiElevation.blurRadius(Theme.ChiElevation.level1)
        }
    }

    // ─── Input ──────────────────────────────────────────────────
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: toggleButton.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: {
            toggleButton.selected = !toggleButton.selected;
            toggleButton.toggled(toggleButton.selected);
        }
    }

    // ─── Keyboard Support ───────────────────────────────────────
    Keys.onSpacePressed: if (enabled)
        activate()
    Keys.onEnterPressed: if (enabled)
        activate()
    Keys.onReturnPressed: if (enabled)
        activate()

    function activate() {
        selected = !selected;
        toggled(selected);
    }
}
