// ToggleButton.qml - Text-based Toggle Button

import QtQuick
import QtQuick.Effects
import "../../theme" as Theme
import "../common" as Common

Item {
    id: root

    property string text: "Toggle"
    property string icon: ""
    property bool showIcon: icon !== ""
    property string variant: "filled"
    property string size: "medium"
    property string shape: "round"
    property bool enabled: true
    property bool selected: false

    signal toggled(bool isSelected)

    readonly property var colors: Theme.ChiTheme.colors
    readonly property var motion: Theme.ChiTheme.motion
    readonly property var typo: Theme.ChiTheme.typography
    readonly property var spec: Theme.SizeSpecs.getSpec(Theme.SizeSpecs.button, size)
    readonly property var typeStyle: typo[spec.typo] ?? typo.labelLarge

    readonly property bool _filled: variant === "filled"
    readonly property bool _elevated: variant === "elevated"
    readonly property bool _tonal: variant === "tonal"
    readonly property bool _outlined: variant === "outlined"

    readonly property color _bgColor: {
        if (!enabled) return "transparent"
        if (_filled || _elevated) return selected ? colors.primary : colors.surfaceContainerLow
        if (_tonal) return selected ? colors.secondaryContainer : "transparent"
        if (_outlined && selected) return colors.inverseSurface
        return "transparent"
    }

    readonly property color _fgColor: {
        if (!enabled) return colors.onSurface
        if (_filled || _elevated) return selected ? colors.onPrimary : colors.primary
        if (_tonal) return selected ? colors.onSecondaryContainer : colors.onSurfaceVariant
        if (_outlined) return selected ? colors.inverseOnSurface : colors.primary
        return colors.primary
    }

    implicitWidth: contentRow.implicitWidth + (spec.horizontalPadding * 2)
    implicitHeight: spec.height

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity { enabled: motion.animationsEnabled; NumberAnimation { duration: motion.durationMedium } }

    Rectangle {
        id: container
        anchors.fill: parent
        color: _bgColor
        radius: shape === "round" ? height / 2 : spec.squareRadius

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: colors.onSurface
            opacity: 0.12
            visible: !enabled && (_filled || _elevated)
        }

        border.width: _outlined && !selected ? (spec.outlineWidth ?? 1) : 0
        border.color: _outlined ? colors.outline : "transparent"

        Behavior on color { enabled: motion.animationsEnabled; ColorAnimation { duration: motion.durationFast } }
        Behavior on border.color { enabled: motion.animationsEnabled; ColorAnimation { duration: motion.durationFast } }

        Common.StateLayer {
            layerColor: _fgColor; containerRadius: parent.radius
            pressed: mouseArea.pressed; hovered: mouseArea.containsMouse; enabled: root.enabled
        }
        Common.Ripple { color: _fgColor; radius: parent.radius; enabled: root.enabled }

        Row {
            id: contentRow
            anchors.centerIn: parent
            spacing: spec.gap ?? 8
            
            Common.Icon {
                visible: root.showIcon && root.icon !== ""
                source: root.icon
                size: spec.iconSize ?? 20
                color: _fgColor
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                visible: root.text !== ""
                text: root.text
                font.family: typeStyle.family ?? Theme.ChiTheme.fontFamily
                font.weight: spec.fontWeight ?? Font.Medium
                font.pixelSize: typeStyle.size ?? 14
                font.letterSpacing: spec.fontLetterSpacing ?? 0
                color: _fgColor
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
    
    layer.enabled: _elevated && enabled
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: Theme.ChiElevation.shadowColor(Theme.ChiElevation.level1)
        shadowOpacity: Theme.ChiElevation.shadowOpacity(Theme.ChiElevation.level1)
        shadowHorizontalOffset: 0
        shadowVerticalOffset: Theme.ChiElevation.verticalOffset(Theme.ChiElevation.level1)
        shadowBlur: Theme.ChiElevation.blurRadius(Theme.ChiElevation.level1)
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.selected = !root.selected
            root.toggled(root.selected)
        }
    }
}
