// ui/Buttons/Button.qml
// Chi Button — Material 3 Expressive Design System
// Dieter Rams 10 Principles of Good Design applied throughout:
// #1  Innovative — MultiEffect shadow, no legacy GraphicalEffects
// #2  Useful — Five sizes tuned for pointer-driven interfaces
// #3  Aesthetic — Compact, rhythmic spacing; nothing superfluous
// #4  Understandable — Variant names map directly to visual output
// #5  Unobtrusive — Buttons serve content, never dominate it
// #6  Honest — No fake depth unless elevated; states are truthful
// #7  Long-lasting — Theme-driven tokens; zero hardcoded values
// #8  Thorough — Every padding, radius, and opacity is intentional
// #9  Environmentally friendly — Minimal redraws, shared components
// #10 As little design as possible — Less, but better

import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Effects
import "../../theme" as Theme
import "../common" as Common

Item {
    id: root

    // ─── Public API ───────────────────────────────────────────
    property string text: "Button"
    property string variant: "filled"       // filled | elevated | tonal | outlined | text
    property string size: "medium"          // xsmall | small | medium | large | xlarge
    property string shape: "round"          // round | square
    property bool showIcon: false
    property string icon: ""
    property bool enabled: true
    property bool loading: false

    signal clicked()

    // ─── Theme Tokens ───────────────────────────────────────────
    readonly property var colors: Theme.ChiTheme.colors
    readonly property var typography: Theme.ChiTheme.typography
    readonly property var motion: Theme.ChiTheme.motion
    readonly property string fontFamily: Theme.ChiTheme.fontFamily
    readonly property string iconFamily: Theme.ChiTheme.iconFamily

    // ─── Size Specifications — Material 3 Expressive ────────────
    // Expressive design uses larger touch targets for better accessibility
    // Desktop minimum: 40px, Mobile minimum: 48px
    readonly property var spec: Theme.SizeSpecs.getSpec(Theme.SizeSpecs.button, size)
    readonly property var typo: typography[spec.typo] ?? typography.labelLarge

    readonly property bool isIconImage: icon.endsWith(".svg")
                                     || icon.endsWith(".png")
                                     || icon.endsWith(".jpg")
                                     || icon.startsWith("qrc:/")

    readonly property bool isFilled:   variant === "filled"
    readonly property bool isElevated: variant === "elevated"
    readonly property bool isTonal:    variant === "tonal"
    readonly property bool isOutlined: variant === "outlined"

    // Pre-resolve variant colors — single switch, not repeated per-item
    readonly property color fillColor: {
        if (isFilled)   return colors.primary
        if (isElevated) return colors.surfaceContainerLow
        if (isTonal)    return colors.secondaryContainer
        return "transparent"
    }

    readonly property color contentColor: {
        if (!enabled)   return colors.onSurface
        if (isFilled)   return colors.onPrimary
        if (isTonal)    return colors.onSecondaryContainer
        return colors.primary                       // elevated, outlined, text
    }

    readonly property color overlayColor: {
        if (isFilled)   return colors.onPrimary
        if (isTonal)    return colors.onSecondaryContainer
        return colors.primary
    }

    readonly property bool needsShadow: enabled
        && (isElevated || (isFilled && root.state === "hovered"))

    // ─── Geometry ───────────────────────────────────────────────
    implicitWidth: content.implicitWidth
    implicitHeight: spec.height

    opacity: enabled ? 1.0 : 0.38

    Behavior on opacity {
        NumberAnimation {
            duration: motion.durationMedium
            easing.type: motion.easeStandard
        }
    }

    // ─── Interaction States ─────────────────────────────────────
    states: [
        State { name: "disabled"; when: !enabled },
        State { name: "pressed";  when: mouseArea.pressed && enabled },
        State { name: "focused";  when: root.activeFocus && enabled && !mouseArea.pressed },
        State { name: "hovered";  when: mouseArea.containsMouse && enabled && !mouseArea.pressed },
        State { name: "idle";     when: enabled }
    ]

    // ─── Visual Container ───────────────────────────────────────
    Rectangle {
        id: container
        anchors.fill: parent
        visible: !needsShadow

        radius: shape === "round" ? height / 2 : spec.squareRadius
        color: enabled ? fillColor : "transparent"

        // Disabled fill substitute — M3: onSurface @ 12%
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: colors.onSurface
            opacity: 0.12
            visible: !enabled && (isFilled || isElevated)
        }

        border.width: isOutlined ? 1 : 0
        border.color: {
            if (!isOutlined)                return "transparent"
            if (root.state === "focused")   return colors.primary
            return colors.outline
        }

        // State layer — hover / focus / press feedback (using shared component)
        Common.StateLayer {
            color: overlayColor
            radius: parent.radius
            pressed: mouseArea.pressed
            hovered: mouseArea.containsMouse
            focused: root.activeFocus
            enabled: root.enabled
        }

        // Ripple — full-surface flash
        Common.Ripple {
            color: overlayColor
            radius: parent.radius
            enabled: root.enabled
        }

        // Content row — icon + label
        Row {
            id: content
            anchors.centerIn: parent
            spacing: (showIcon && icon !== "") ? spec.gap : 0

            topPadding:    spec.verticalPadding
            bottomPadding: spec.verticalPadding
            leftPadding:   spec.horizontalPadding
            rightPadding:  spec.horizontalPadding

            Common.Icon {
                visible: showIcon && icon !== ""
                source: icon
                size: spec.iconSize
                color: contentColor
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: label
                text: root.text

                font.family:        fontFamily
                font.weight:        typo.weight
                font.pixelSize:     typo.size
                font.letterSpacing: typo.spacing

                verticalAlignment: Text.AlignVCenter
                color: contentColor
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    // ─── Elevation — Modern MultiEffect ──────────────────────────
    MultiEffect {
        source: container
        anchors.fill: container
        visible: needsShadow
        autoPaddingEnabled: true

        shadowEnabled: true
        shadowColor: colors.shadow
        shadowOpacity: 0.3
        shadowHorizontalOffset: 0
        shadowVerticalOffset:   root.state === "hovered" ? 2 : 1
        shadowBlur:             root.state === "hovered" ? 0.4 : 0.2

        Behavior on shadowVerticalOffset {
            NumberAnimation {
                duration: motion.durationMedium
                easing.type: motion.easeStandard
            }
        }
        Behavior on shadowBlur {
            NumberAnimation {
                duration: motion.durationMedium
                easing.type: motion.easeStandard
            }
        }
    }

    // ─── Input ──────────────────────────────────────────────────
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.enabled && !root.loading
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        onClicked: root.clicked()
    }

    Keys.onSpacePressed:  if (enabled && !loading) activate()
    Keys.onEnterPressed:  if (enabled && !loading) activate()
    Keys.onReturnPressed: if (enabled && !loading) activate()

    function activate() {
        clicked()
    }
}
