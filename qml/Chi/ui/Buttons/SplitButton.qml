// SplitButton.qml - Material 3 Split Button
// Uses shared components (Icon, Ripple, StateLayer) following Dieter Rams principles

import QtQuick
import QtQuick.Effects
import "../../theme" as Theme
import "../common" as Common

Item {
    id: splitButton

    // ─── Public API ───────────────────────────────────────────
    property string text: "Action"
    property string leadingIcon: ""
    property bool showLeadingIcon: false
    property string trailingIcon: "expand_more"
    property string variant: "filled"        // filled | elevated | tonal | outlined
    property string size: "small"            // xsmall | small | medium | large | xlarge
    property bool enabled: true
    property bool trailingSelected: false

    signal leadingClicked()
    signal trailingClicked()

    // ─── Theme Tokens ───────────────────────────────────────────
    readonly property var colors: Theme.ChiTheme.colors
    readonly property var motion: Theme.ChiTheme.motion
    readonly property var typography: Theme.ChiTheme.typography
    readonly property string fontFamily: Theme.ChiTheme.fontFamily
    readonly property string iconFamily: Theme.ChiTheme.iconFamily

    // ─── Size Specifications ────────────────────────────────────
    readonly property var sizeSpecs: ({
        xsmall: { height: 36, padding: 6, horizontalPadding: 14, gap: 4, iconSize: 18, fontSize: 12, fontWeight: Font.Medium, letterSpacing: 0.1, fullRadius: 18, smallRadius: 4, buttonGap: 2, trailingIconSize: 16 },
        small:  { height: 44, padding: 10, horizontalPadding: 18, gap: 6, iconSize: 20, fontSize: 14, fontWeight: Font.Medium, letterSpacing: 0.1, fullRadius: 22, smallRadius: 4, buttonGap: 2, trailingIconSize: 18 },
        medium: { height: 56, padding: 16, horizontalPadding: 26, gap: 8, iconSize: 24, fontSize: 16, fontWeight: Font.Medium, letterSpacing: 0.15, fullRadius: 28, smallRadius: 4, buttonGap: 2, trailingIconSize: 20 },
        large:  { height: 72, padding: 24, horizontalPadding: 36, gap: 10, iconSize: 28, fontSize: 18, fontWeight: Font.Normal, letterSpacing: 0, fullRadius: 36, smallRadius: 8, buttonGap: 2, trailingIconSize: 24 },
        xlarge: { height: 96, padding: 32, horizontalPadding: 48, gap: 12, iconSize: 36, fontSize: 22, fontWeight: Font.Normal, letterSpacing: 0, fullRadius: 48, smallRadius: 12, buttonGap: 2, trailingIconSize: 28 }
    })

    readonly property var spec: sizeSpecs[size] || sizeSpecs.small

    // ─── Variant Flags ──────────────────────────────────────────
    readonly property bool _filled: variant === "filled"
    readonly property bool _elevated: variant === "elevated"
    readonly property bool _tonal: variant === "tonal"
    readonly property bool _outlined: variant === "outlined"

    // ─── Colors ─────────────────────────────────────────────────
    readonly property color _interactColor: _filled ? colors.onPrimary :
                                            _tonal ? colors.onSecondaryContainer : colors.primary
    readonly property color _labelColor: enabled ? _interactColor : colors.onSurface
    readonly property color _containerColor: {
        if (!enabled && (_filled || _elevated)) return "transparent"
        if (_filled) return colors.primary
        if (_elevated) return colors.surfaceContainerLow
        if (_tonal) return colors.secondaryContainer
        return "transparent"
    }

    // ─── Geometry ───────────────────────────────────────────────
    implicitWidth: leadingButtonContainer.implicitWidth + spec.buttonGap + trailingButtonContainer.width
    implicitHeight: spec.height

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity { NumberAnimation { duration: motion.durationMedium } }

    Row {
        spacing: spec.buttonGap

        // ─── LEADING BUTTON ───
        Rectangle {
            id: leadingButtonContainer
            implicitWidth: leadingContent.implicitWidth
            height: spec.height
            clip: true

            topLeftRadius: spec.fullRadius
            bottomLeftRadius: spec.fullRadius
            topRightRadius: spec.smallRadius
            bottomRightRadius: spec.smallRadius

            color: splitButton._containerColor
            border.width: splitButton._outlined ? 1 : 0
            border.color: splitButton._outlined ? colors.outline : "transparent"

            // Disabled overlay
            Rectangle {
                anchors.fill: parent
                topLeftRadius: parent.topLeftRadius
                topRightRadius: parent.topRightRadius
                bottomLeftRadius: parent.bottomLeftRadius
                bottomRightRadius: parent.bottomRightRadius
                visible: !splitButton.enabled && (splitButton._filled || splitButton._elevated)
                color: colors.onSurface
                opacity: 0.12
            }

            // State Layer
            Rectangle {
                anchors.fill: parent
                topLeftRadius: parent.topLeftRadius
                topRightRadius: parent.topRightRadius
                bottomLeftRadius: parent.bottomLeftRadius
                bottomRightRadius: parent.bottomRightRadius
                color: splitButton._interactColor

                opacity: !splitButton.enabled ? 0 :
                         (leadingMouseArea.pressed ? 0.12 :
                         (splitButton.activeFocus ? 0.12 :
                         (leadingMouseArea.containsMouse ? 0.08 : 0)))

                Behavior on opacity {
                    NumberAnimation { duration: leadingMouseArea.pressed ? 50 : 150; easing.type: Easing.OutCubic }
                }
            }

            // Ripple
            Rectangle {
                anchors.fill: parent
                topLeftRadius: parent.topLeftRadius
                topRightRadius: parent.topRightRadius
                bottomLeftRadius: parent.bottomLeftRadius
                bottomRightRadius: parent.bottomRightRadius
                color: splitButton._interactColor
                opacity: 0

                SequentialAnimation on opacity {
                    id: leadingRippleAnimation
                    running: false
                    NumberAnimation { from: 0; to: 0.16; duration: 90; easing.type: Easing.OutCubic }
                    NumberAnimation { to: 0; duration: 210; easing.type: Easing.OutCubic }
                }
            }

            // Content
            Row {
                id: leadingContent
                anchors.centerIn: parent
                spacing: spec.gap
                padding: spec.padding
                leftPadding: spec.horizontalPadding
                rightPadding: spec.horizontalPadding

                Common.Icon {
                    visible: splitButton.showLeadingIcon && splitButton.leadingIcon !== ""
                    source: splitButton.leadingIcon
                    size: spec.iconSize
                    color: splitButton._labelColor
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: splitButton.text
                    font.family: fontFamily
                    font.weight: spec.fontWeight
                    font.pixelSize: spec.fontSize
                    font.letterSpacing: spec.letterSpacing
                    verticalAlignment: Text.AlignVCenter
                    color: splitButton._labelColor
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                id: leadingMouseArea
                anchors.fill: parent
                enabled: splitButton.enabled
                hoverEnabled: true
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onPressed: leadingRippleAnimation.restart()
                onClicked: splitButton.leadingClicked()
            }
        }

        // ─── TRAILING BUTTON ───
        Rectangle {
            id: trailingButtonContainer
            width: spec.height
            height: spec.height
            clip: true

            topLeftRadius: splitButton.trailingSelected ? spec.fullRadius :
                          (trailingMouseArea.pressed ? spec.smallRadius * 3 : spec.smallRadius)
            bottomLeftRadius: splitButton.trailingSelected ? spec.fullRadius :
                             (trailingMouseArea.pressed ? spec.smallRadius * 3 : spec.smallRadius)
            topRightRadius: spec.fullRadius
            bottomRightRadius: spec.fullRadius

            Behavior on topLeftRadius { NumberAnimation { duration: motion.durationFast } }
            Behavior on bottomLeftRadius { NumberAnimation { duration: motion.durationFast } }

            color: splitButton._containerColor
            border.width: splitButton._outlined ? 1 : 0
            border.color: splitButton._outlined ? colors.outline : "transparent"

            // State Layer
            Rectangle {
                anchors.fill: parent
                topLeftRadius: parent.topLeftRadius
                topRightRadius: parent.topRightRadius
                bottomLeftRadius: parent.bottomLeftRadius
                bottomRightRadius: parent.bottomRightRadius
                color: splitButton._interactColor

                opacity: !splitButton.enabled ? 0 :
                         (splitButton.trailingSelected ? 0.12 :
                         (trailingMouseArea.pressed ? 0.12 :
                         (trailingMouseArea.containsMouse ? 0.08 : 0)))

                Behavior on opacity {
                    NumberAnimation { duration: trailingMouseArea.pressed ? 50 : 150; easing.type: Easing.OutCubic }
                }
            }

            // Ripple
            Rectangle {
                anchors.fill: parent
                topLeftRadius: parent.topLeftRadius
                topRightRadius: parent.topRightRadius
                bottomLeftRadius: parent.bottomLeftRadius
                bottomRightRadius: parent.bottomRightRadius
                color: splitButton._interactColor
                opacity: 0

                SequentialAnimation on opacity {
                    id: trailingRippleAnimation
                    running: false
                    NumberAnimation { from: 0; to: 0.16; duration: 90; easing.type: Easing.OutCubic }
                    NumberAnimation { to: 0; duration: 210; easing.type: Easing.OutCubic }
                }
            }

            Common.Icon {
                anchors.centerIn: parent
                source: splitButton.trailingIcon
                size: spec.trailingIconSize
                color: splitButton._labelColor
                rotation: splitButton.trailingSelected ? 180 : 0
                Behavior on rotation { NumberAnimation { duration: motion.durationMedium } }
            }

            // Focus indicator
            Rectangle {
                visible: splitButton.trailingSelected && splitButton.activeFocus
                anchors.fill: parent
                anchors.margins: 2
                radius: parent.radius
                color: "transparent"
                border.width: 3
                border.color: colors.secondary
            }

            MouseArea {
                id: trailingMouseArea
                anchors.fill: parent
                enabled: splitButton.enabled
                hoverEnabled: true
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onPressed: trailingRippleAnimation.restart()
                onClicked: {
                    splitButton.trailingSelected = !splitButton.trailingSelected
                    splitButton.trailingClicked()
                }
            }
        }
    }

    // Elevation for elevated variant
    layer.enabled: _elevated && enabled
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: Qt.rgba(0, 0, 0, 0.3)
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 1
        shadowBlur: 0.2
    }
}
