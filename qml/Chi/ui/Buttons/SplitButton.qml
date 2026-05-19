// SplitButton.qml - Material 3 Expressive Split Button
// Implements flawless shape morphing and integrated menu states

import QtQuick
import QtQuick.Effects
import QtQuick.Controls.Basic as QQC2
import "../../theme" as Theme
import "../common" as Common

Item {
    id: root

    // ─── Public API ───────────────────────────────────────────
    property string text: "Action"
    property string leadingIcon: ""
    property bool showLeadingIcon: false
    property alias showIcon: root.showLeadingIcon // Backward compat
    property string trailingIcon: "arrow_drop_down" // M3 Standard Chevron
    property string variant: "filled"        // filled | elevated | tonal | outlined
    property string size: "medium"           // xsmall | small | medium | large | xlarge
    property bool enabled: true
    
    // Pass a QtQuick.Controls.Menu here. The button will automatically manage it.
    property var dropDownMenu: null
    property bool trailingSelected: false

    signal leadingClicked()
    signal trailingClicked()

    // ─── Menu State Tracker ───────────────────────────────────
    Connections {
        target: root.dropDownMenu
        ignoreUnknownSignals: true
        function onOpened() { root.trailingSelected = true }
        function onAboutToShow() { root.trailingSelected = true }
        function onClosed() { root.trailingSelected = false }
        function onAboutToHide() { root.trailingSelected = false }
    }

    // ─── Tokens ───────────────────────────────────────────────
    readonly property var colors: Theme.ChiTheme.colors
    readonly property var motion: Theme.ChiTheme.motion
    readonly property var typo: Theme.ChiTheme.typography
    readonly property var spec: Theme.SizeSpecs.getSpec(Theme.SizeSpecs.splitButton, size)
    readonly property var typeStyle: typo[spec.typo] ?? typo.labelMedium

    // ─── Variant Flags ────────────────────────────────────────
    readonly property bool _filled: variant === "filled"
    readonly property bool _elevated: variant === "elevated"
    readonly property bool _tonal: variant === "tonal"
    readonly property bool _outlined: variant === "outlined"

    // ─── Colors ───────────────────────────────────────────────
    readonly property color _interactColor: _filled ? colors.onPrimary : (_tonal ? colors.onSecondaryContainer : colors.primary)
    readonly property color _labelColor: enabled ? _interactColor : Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.38)
    
    readonly property color _containerColor: {
        if (!enabled) return "transparent"
        if (_filled) return colors.primary
        if (_elevated) return colors.surfaceContainerLow
        if (_tonal) return colors.secondaryContainer
        return "transparent"
    }

    // ─── Geometry ─────────────────────────────────────────────
    implicitWidth: leadingRect.width + spec.betweenSpace + trailingRect.width
    implicitHeight: spec.height

    opacity: enabled ? 1.0 : 0.8
    Behavior on opacity { 
        enabled: motion.animationsEnabled
        NumberAnimation { duration: motion.durationMedium; easing.type: motion.easeStandard } 
    }

    Row {
        spacing: spec.betweenSpace

        // ══════════════════════════════════════════════════════════
        // LEADING BUTTON
        // ══════════════════════════════════════════════════════════
        Rectangle {
            id: leadingRect
            width: leadingContent.implicitWidth + spec.leadingLeading + spec.leadingTrailing
            height: spec.height
            color: _containerColor
            
            border.width: _outlined ? spec.outlineWidth : 0
            border.color: _outlined ? colors.outline : "transparent"

            topLeftRadius: spec.outerRadius
            bottomLeftRadius: spec.outerRadius
            topRightRadius: spec.innerCorner
            bottomRightRadius: spec.innerCorner

            Rectangle {
                anchors.fill: parent
                topLeftRadius: parent.topLeftRadius; bottomLeftRadius: parent.bottomLeftRadius
                topRightRadius: parent.topRightRadius; bottomRightRadius: parent.bottomRightRadius
                color: colors.onSurface
                opacity: 0.12
                visible: !root.enabled && (_filled || _elevated)
            }

            Rectangle {
                anchors.fill: parent
                topLeftRadius: parent.topLeftRadius; bottomLeftRadius: parent.bottomLeftRadius
                topRightRadius: parent.topRightRadius; bottomRightRadius: parent.bottomRightRadius
                color: _interactColor
                opacity: !root.enabled ? 0 : leadingMouse.pressed ? 0.10 : (root.activeFocus ? 0.10 : (leadingMouse.containsMouse ? 0.08 : 0))

                Behavior on opacity {
                    enabled: motion.animationsEnabled
                    NumberAnimation { duration: motion.durationFast; easing.type: motion.easeStandard }
                }
            }

            Rectangle {
                anchors.fill: parent
                topLeftRadius: parent.topLeftRadius; bottomLeftRadius: parent.bottomLeftRadius
                topRightRadius: parent.topRightRadius; bottomRightRadius: parent.bottomRightRadius
                color: _interactColor
                opacity: 0
                SequentialAnimation on opacity {
                    id: leadingRippleAnim
                    running: false
                    NumberAnimation { from: 0; to: Theme.ChiMotion.stateLayer.pressed; duration: Theme.ChiMotion.press.duration; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.ChiMotion.press.curve }
                    NumberAnimation { to: 0; duration: Theme.ChiMotion.release.duration; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.ChiMotion.release.curve }
                }
            }

            Row {
                id: leadingContent
                anchors.centerIn: parent
                spacing: spec.gap
                
                Common.Icon {
                    visible: root.showLeadingIcon && root.leadingIcon !== ""
                    source: root.leadingIcon
                    size: spec.iconSize
                    color: _labelColor
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    text: root.text
                    font.family: typeStyle.family ?? Theme.ChiTheme.fontFamily
                    font.weight: spec.fontWeight ?? Font.Medium
                    font.pixelSize: typeStyle.size ?? 14
                    font.letterSpacing: spec.fontLetterSpacing ?? 0
                    color: _labelColor
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            
            MouseArea { 
                id: leadingMouse
                anchors.fill: parent
                enabled: root.enabled
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onPressed: leadingRippleAnim.restart()
                onClicked: root.leadingClicked() 
            }
        }

        // ══════════════════════════════════════════════════════════
        // TRAILING BUTTON (Menu Trigger)
        // ══════════════════════════════════════════════════════════
        Rectangle {
            id: trailingRect
            width: spec.height // Keeps it perfectly square so fully rounded = perfect circle
            height: spec.height
            color: _containerColor
            
            border.width: _outlined ? spec.outlineWidth : 0
            border.color: _outlined ? colors.outline : "transparent"

            // M3 Expressive Morphing: When menu is active, morph to perfect circle
            readonly property int _morphRadius: root.trailingSelected ? spec.outerRadius : spec.innerCorner

            topLeftRadius: _morphRadius
            bottomLeftRadius: _morphRadius
            topRightRadius: spec.outerRadius
            bottomRightRadius: spec.outerRadius

            // Superior Spatial Bezier Spring Animation for smooth, high-quality M3 Morphing
            Behavior on topLeftRadius { 
                enabled: motion.animationsEnabled
                NumberAnimation { 
                    duration: motion.shapeMorph.duration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: motion.shapeMorph.curve
                } 
            }
            Behavior on bottomLeftRadius { 
                enabled: motion.animationsEnabled
                NumberAnimation { 
                    duration: motion.shapeMorph.duration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: motion.shapeMorph.curve
                } 
            }

            Rectangle {
                anchors.fill: parent
                topLeftRadius: parent.topLeftRadius; bottomLeftRadius: parent.bottomLeftRadius
                topRightRadius: parent.topRightRadius; bottomRightRadius: parent.bottomRightRadius
                color: colors.onSurface
                opacity: 0.12
                visible: !root.enabled && (_filled || _elevated)
            }

            Rectangle {
                anchors.fill: parent
                topLeftRadius: parent.topLeftRadius; bottomLeftRadius: parent.bottomLeftRadius
                topRightRadius: parent.topRightRadius; bottomRightRadius: parent.bottomRightRadius
                color: _interactColor
                opacity: !root.enabled ? 0 : root.trailingSelected ? 0.10 : trailingMouse.pressed ? 0.10 : (trailingMouse.containsMouse ? 0.08 : 0)

                Behavior on opacity {
                    enabled: motion.animationsEnabled
                    NumberAnimation { duration: motion.durationFast; easing.type: motion.easeStandard }
                }
            }

            Rectangle {
                anchors.fill: parent
                topLeftRadius: parent.topLeftRadius; bottomLeftRadius: parent.bottomLeftRadius
                topRightRadius: parent.topRightRadius; bottomRightRadius: parent.bottomRightRadius
                color: _interactColor
                opacity: 0
                SequentialAnimation on opacity {
                    id: trailingRippleAnim
                    running: false
                    NumberAnimation { from: 0; to: Theme.ChiMotion.stateLayer.pressed; duration: Theme.ChiMotion.press.duration; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.ChiMotion.press.curve }
                    NumberAnimation { to: 0; duration: Theme.ChiMotion.release.duration; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.ChiMotion.release.curve }
                }
            }

            // Precisely centered Chevron
            Common.Icon {
                id: chevronIcon
                anchors.centerIn: parent
                source: root.trailingIcon
                size: spec.trailingIconSize ?? 24
                color: _labelColor
                rotation: root.trailingSelected ? -180 : 0
                
                // M3 Smooth Rotation Easing
                Behavior on rotation { 
                    enabled: motion.animationsEnabled
                    NumberAnimation { 
                        duration: motion.durationMedium
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: motion.easing.standard
                    } 
                }
            }

            MouseArea { 
                id: trailingMouse
                anchors.fill: parent
                enabled: root.enabled
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onPressed: trailingRippleAnim.restart()
                onClicked: {
                    if (root.dropDownMenu) {
                        if (typeof root.dropDownMenu.popup === "function") {
                            // Perfect drop-down anchor placement
                            root.dropDownMenu.popup(trailingRect, 0, trailingRect.height + 4)
                        } else if (typeof root.dropDownMenu.open === "function") {
                            root.dropDownMenu.open()
                        }
                    } else {
                        // Fallback toggle if no menu provided
                        root.trailingSelected = !root.trailingSelected
                    }
                    root.trailingClicked()
                }
            }
        }
    }

    // ─── Global Elevation ─────────────────────────────────────
    layer.enabled: _elevated && enabled
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: Theme.ChiElevation.shadowColor(Theme.ChiElevation.level1)
        shadowOpacity: Theme.ChiElevation.shadowOpacity(Theme.ChiElevation.level1)
        shadowHorizontalOffset: 0
        shadowVerticalOffset: Theme.ChiElevation.verticalOffset(Theme.ChiElevation.level1)
        shadowBlur: Theme.ChiElevation.blurRadius(Theme.ChiElevation.level1)
    }
}
