// FABMenuItem.qml - Material 3 FAB Menu Item
// Uses shared components following Dieter Rams principles

import QtQuick
import QtQuick.Effects
import "../../theme" as Theme
import "../common" as Common

Item {
    id: menuItem

    // ─── Public API ───────────────────────────────────────────
    property string text: "Action"
    property string icon: "star"
    property string variant: "primary"       // primary | secondary | tertiary
    property bool enabled: true

    signal clicked()

    // ─── Theme Tokens ───────────────────────────────────────────
    readonly property var colors: Theme.ChiTheme.colors
    readonly property var motion: Theme.ChiTheme.motion
    readonly property var typography: Theme.ChiTheme.typography
    readonly property string fontFamily: Theme.ChiTheme.fontFamily

    implicitWidth: contentRow.implicitWidth + 48
    implicitHeight: 56

    // ─── Variant Colors ──────────────────────────────────────────
    readonly property color _containerColor: {
        switch (variant) {
            case "secondary": return colors.secondaryContainer
            case "tertiary": return colors.tertiaryContainer
            default: return colors.primaryContainer
        }
    }

    readonly property color _contentColor: {
        switch (variant) {
            case "secondary": return colors.onSecondaryContainer
            case "tertiary": return colors.onTertiaryContainer
            default: return colors.onPrimaryContainer
        }
    }

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity {
        NumberAnimation { duration: motion.durationMedium; easing.type: motion.easeStandard }
    }

    // ─── Visual Container ───────────────────────────────────────
    Rectangle {
        id: container
        anchors.fill: parent
        radius: 28
        clip: true
        color: menuItem._containerColor

        // Shadow
        layer.enabled: menuItem.enabled
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.2)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: mouseArea.containsMouse ? 3 : 2
            shadowBlur: mouseArea.containsMouse ? 0.3 : 0.15
        }

        // State Layer
        Common.StateLayer {
            stateColor: menuItem._contentColor
            stateRadius: parent.radius
            pressed: mouseArea.pressed
            hovered: mouseArea.containsMouse
            focused: menuItem.activeFocus
            enabled: menuItem.enabled
        }

        // Ripple
        Common.Ripple {
            color: menuItem._contentColor
            radius: parent.radius
            enabled: menuItem.enabled
        }

        // Content
        Row {
            id: contentRow
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 24
            spacing: 8

            Text {
                text: menuItem.text
                font.family: fontFamily
                font.weight: Font.Medium
                font.pixelSize: typography.titleMedium.size
                font.letterSpacing: typography.titleMedium.spacing
                horizontalAlignment: Text.AlignRight
                color: menuItem._contentColor
                anchors.verticalCenter: parent.verticalCenter
            }

            Common.Icon {
                source: menuItem.icon
                size: 24
                color: menuItem._contentColor
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Focus indicator
        Rectangle {
            visible: menuItem.activeFocus && !mouseArea.pressed
            anchors.fill: parent
            anchors.margins: -2
            radius: 30
            color: "transparent"
            border.width: 3
            border.color: colors.secondary
        }
    }

    // ─── Input ──────────────────────────────────────────────────
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: menuItem.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: menuItem.clicked()
    }

    // ─── Keyboard Support ───────────────────────────────────────
    Keys.onSpacePressed:  if (enabled) activate()
    Keys.onEnterPressed:  if (enabled) activate()
    Keys.onReturnPressed: if (enabled) activate()

    function activate() {
        clicked()
    }
}
