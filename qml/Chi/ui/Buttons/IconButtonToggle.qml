// IconButtonToggle — Toggleable icon button with selected/unselected states
import QtQuick
import "../../theme" as Theme
import "../common" as Common
import "../menus" as Menus

Item {
    id: root

    property string icon: "star_outline"
    property string selectedIcon: "star"
    property string size: "small"
    property string widthMode: "default"
    property bool selected: false
    property bool enabled: true
    property string tooltip: ""

    signal toggled(bool selected)

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity {
        enabled: Theme.ChiMotion.animationsEnabled
        NumberAnimation {
            duration: Theme.ChiMotion.colorChange.duration
            easing.type: Easing.Bezier
            easing.bezierCurve: Theme.ChiMotion.colorChange.curve
        }
    }

    readonly property var sizeSpecs: Theme.SizeSpecs.iconButton
    readonly property var cs: sizeSpecs[size] || sizeSpecs.small

    readonly property int containerWidth: {
        if (widthMode === "narrow") return cs.narrowWidth
        if (widthMode === "wide") return cs.wideWidth
        return cs.defaultWidth
    }

    readonly property string effectiveIcon:
        selected && selectedIcon !== "" ? selectedIcon : icon

    property var colors: Theme.ChiTheme.colors

    readonly property color _interactColor: selected ? colors.onPrimary : colors.onSurfaceVariant
    readonly property color _iconColor: enabled ? _interactColor : colors.onSurface

    implicitWidth: containerWidth
    implicitHeight: cs.height

    Rectangle {
        id: container
        anchors.centerIn: parent
        width: root.containerWidth
        height: cs.height
        clip: true
        radius: root.selected ? cs.squareRadius : height / 2

        color: !root.enabled
            ? Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.12)
            : (root.selected ? colors.primary : colors.surfaceContainer)

        Behavior on radius {
            enabled: Theme.ChiMotion.animationsEnabled
            NumberAnimation {
                duration: Theme.ChiMotion.shapeMorph.duration
                easing.type: Easing.Bezier
                easing.bezierCurve: Theme.ChiMotion.shapeMorph.curve
            }
        }
        Behavior on color {
            enabled: Theme.ChiMotion.animationsEnabled
            ColorAnimation {
                duration: Theme.ChiMotion.colorChange.duration
                easing.type: Easing.Bezier
                easing.bezierCurve: Theme.ChiMotion.colorChange.curve
            }
        }

        // Ripple
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: root._interactColor
            opacity: 0

            SequentialAnimation on opacity {
                id: rippleAnimation
                running: false
                NumberAnimation { from: 0; to: 0.16; duration: Theme.ChiMotion.press.duration; easing.type: Easing.Bezier; easing.bezierCurve: Theme.ChiMotion.press.curve }
                NumberAnimation { to: 0; duration: Theme.ChiMotion.release.duration; easing.type: Easing.Bezier; easing.bezierCurve: Theme.ChiMotion.release.curve }
            }
        }

        // State layer
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: root._interactColor
            opacity: !root.enabled ? 0
                : mouseArea.pressed ? Theme.ChiMotion.stateLayer.pressed
                : root.activeFocus ? Theme.ChiMotion.stateLayer.focus
                : mouseArea.containsMouse ? Theme.ChiMotion.stateLayer.hover
                : 0

            Behavior on opacity {
                enabled: Theme.ChiMotion.animationsEnabled
                NumberAnimation {
                    duration: mouseArea.pressed ? Theme.ChiMotion.press.duration : Theme.ChiMotion.hoverState.duration
                    easing.type: Easing.Bezier
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
