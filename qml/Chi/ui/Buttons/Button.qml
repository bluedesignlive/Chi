// ui/Buttons/Button.qml
// SmartUI Button — Desktop-first, Dieter Rams principles applied.
// #1  Innovative — MultiEffect shadow, no legacy GraphicalEffects
// #2  Useful — Five sizes tuned for pointer-driven interfaces
// #3  Aesthetic — Compact, rhythmic spacing; nothing superfluous
// #4  Understandable — Variant names map directly to visual output
// #5  Unobtrusive — Buttons serve content, never dominate it
// #6  Honest — No fake depth unless elevated; states are truthful
// #7  Long-lasting — Theme-driven tokens; zero hardcoded values
// #8  Thorough — Every padding, radius, and opacity is intentional
// #9  Environmentally friendly — Minimal redraws, no unnecessary layers
// #10 As little design as possible — Less, but better

import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Effects
import "../../theme" as Theme

Item {
    id: root

    // ─── Public API (unchanged) ─────────────────────────────
    property string text: "Button"
    property string variant: "filled"       // filled | elevated | tonal | outlined | text
    property string size: "medium"          // xsmall | small | medium | large | xlarge
    property string shape: "round"          // round | square
    property bool showIcon: false
    property string icon: ""
    property bool enabled: true
    property bool loading: false

    signal clicked()

    // ─── Theme Tokens ───────────────────────────────────────
    readonly property var colors:     Theme.ChiTheme.colors
    readonly property var typography: Theme.ChiTheme.typography
    readonly property var motion:     Theme.ChiTheme.motion
    readonly property string fontFamily: Theme.ChiTheme.fontFamily
    readonly property string iconFamily: Theme.ChiTheme.iconFamily

    // ─── Size Specifications — Desktop-Compact ──────────────
    //
    //  xsmall  24px — inline actions, dense toolbars, chips
    //  small   28px — secondary actions, table rows, filters
    //  medium  32px — the workhorse; 90% of desktop UI
    //  large   40px — primary CTA, dialog confirm/cancel
    //  xlarge  48px — hero actions, onboarding, one per view
    //
    readonly property var sizeSpecs: ({
        xsmall: {
            height: 24,
            verticalPadding: 4,
            horizontalPadding: 8,
            gap: 4,
            iconSize: 14,
            typo: "labelSmall",
            squareRadius: 6
        },
        small: {
            height: 28,
            verticalPadding: 4,
            horizontalPadding: 10,
            gap: 4,
            iconSize: 16,
            typo: "labelMedium",
            squareRadius: 6
        },
        medium: {
            height: 34,
            verticalPadding: 6,
            horizontalPadding: 14,
            gap: 6,
            iconSize: 18,
            typo: "labelLarge",
            squareRadius: 8
        },
        large: {
            height: 40,
            verticalPadding: 10,
            horizontalPadding: 20,
            gap: 8,
            iconSize: 20,
            typo: "labelLarge",
            squareRadius: 10
        },
        xlarge: {
            height: 48,
            verticalPadding: 12,
            horizontalPadding: 24,
            gap: 8,
            iconSize: 22,
            typo: "titleMedium",
            squareRadius: 12
        }
    })

    // ─── Derived (computed once, not per-binding) ───────────
    readonly property var spec: sizeSpecs[size] ?? sizeSpecs.medium
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

    // ─── Geometry ───────────────────────────────────────────
    implicitWidth: content.implicitWidth
    implicitHeight: spec.height

    opacity: enabled ? 1.0 : 0.38

    Behavior on opacity {
        NumberAnimation {
            duration: motion.durationMedium
            easing.type: motion.easeStandard
        }
    }

    // ─── Interaction States ─────────────────────────────────
    states: [
        State { name: "disabled"; when: !enabled },
        State { name: "pressed";  when: mouseArea.pressed && enabled },
        State { name: "focused";  when: root.activeFocus && enabled && !mouseArea.pressed },
        State { name: "hovered";  when: mouseArea.containsMouse && enabled && !mouseArea.pressed },
        State { name: "idle";     when: enabled }
    ]

    // ─── Visual Container ───────────────────────────────────
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

        // State layer — hover / focus / press feedback
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: overlayColor

            opacity: {
                switch (root.state) {
                case "pressed": return 0.12
                case "focused": return 0.12
                case "hovered": return 0.08
                default:        return 0
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: root.state === "pressed"
                             ? motion.durationFast
                             : motion.durationMedium
                    easing.type: motion.easeStandard
                }
            }
        }

        // Ripple — full-surface flash, follows container shape
        Rectangle {
            id: ripple
            anchors.fill: parent
            radius: parent.radius
            color: overlayColor
            opacity: 0

            SequentialAnimation on opacity {
                id: rippleAnim
                running: false
                NumberAnimation {
                    from: 0; to: 0.16
                    duration: 90
                    easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    to: 0
                    duration: 210
                    easing.type: Easing.OutCubic
                }
            }
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

            Image {
                visible: showIcon && icon !== "" && root.isIconImage
                width:  spec.iconSize
                height: spec.iconSize
                source: visible ? icon : ""
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                visible: showIcon && icon !== "" && !root.isIconImage
                text: icon
                font.family:    iconFamily
                font.pixelSize: spec.iconSize
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

    // ─── Elevation — Modern MultiEffect (replaces DropShadow) ───
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

    // ─── Input ──────────────────────────────────────────────
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.enabled && !root.loading
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        onPressed: rippleAnim.restart()
        onClicked: root.clicked()
    }

    Keys.onSpacePressed:  if (enabled && !loading) activate()
    Keys.onEnterPressed:  if (enabled && !loading) activate()
    Keys.onReturnPressed: if (enabled && !loading) activate()

    function activate() {
        rippleAnim.restart()
        clicked()
    }
}
