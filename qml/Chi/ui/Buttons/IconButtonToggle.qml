// IconButtonToggle — Toggleable icon button with selected/unselected states
import QtQuick
import QtQuick.Controls.Basic
import "../../theme" as Theme
import "../common" as Common

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
    Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

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

        Behavior on radius { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
        Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.OutCubic } }

        // Ripple
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: root._interactColor
            opacity: 0

            SequentialAnimation on opacity {
                id: rippleAnimation
                running: false
                NumberAnimation { from: 0; to: 0.16; duration: 90; easing.type: Easing.OutCubic }
                NumberAnimation { to: 0; duration: 210; easing.type: Easing.OutCubic }
            }
        }

        // State layer
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: root._interactColor
            opacity: !root.enabled ? 0
                : mouseArea.pressed ? 0.12
                : root.activeFocus ? 0.12
                : mouseArea.containsMouse ? 0.08
                : 0

            Behavior on opacity {
                NumberAnimation {
                    duration: mouseArea.pressed ? 50 : 150
                    easing.type: Easing.OutCubic
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

    ToolTip {
        visible: root.tooltip !== "" && mouseArea.containsMouse
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
