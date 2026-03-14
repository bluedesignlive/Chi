// IconButtonToggle — Toggleable icon button with selected/unselected states
import QtQuick
import QtQuick.Controls.Basic  // ToolTip
import "../../theme" as Theme

Item {
    id: toggleIconButton

    property string icon: "☆"
    property string selectedIcon: "★"
    property string size: "small"         // xsmall..xlarge
    property string widthMode: "default"  // narrow, default, wide
    property bool selected: false
    property bool enabled: true
    property string tooltip: ""

    signal toggled(bool selected)

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

    readonly property var sizeSpecs: ({
        xsmall: { height: 32, iconSize: 20, squareRadius: 8,  narrowWidth: 24,  defaultWidth: 32,  wideWidth: 44 },
        small:  { height: 40, iconSize: 24, squareRadius: 12, narrowWidth: 32,  defaultWidth: 40,  wideWidth: 52 },
        medium: { height: 56, iconSize: 24, squareRadius: 12, narrowWidth: 48,  defaultWidth: 56,  wideWidth: 68 },
        large:  { height: 96, iconSize: 32, squareRadius: 20, narrowWidth: 64,  defaultWidth: 96,  wideWidth: 128 },
        xlarge: { height: 136, iconSize: 40, squareRadius: 28, narrowWidth: 104, defaultWidth: 136, wideWidth: 184 }
    })

    readonly property var cs: sizeSpecs[size] || sizeSpecs.small
    readonly property int containerWidth: widthMode === "narrow" ? cs.narrowWidth :
                                          (widthMode === "wide" ? cs.wideWidth : cs.defaultWidth)

    readonly property string effectiveIcon:
        selected && selectedIcon !== "" ? selectedIcon : icon

    // Safe image detection
    readonly property bool isIconImage: {
        var s = effectiveIcon
        return s.indexOf(".svg") !== -1 || s.indexOf(".png") !== -1 ||
               s.indexOf(".jpg") !== -1 || s.indexOf("qrc:/") === 0
    }

    // Cached interactive color — shared by ripple, state layer, and icon
    readonly property color _interactColor: selected ? colors.onPrimary : colors.onSurfaceVariant
    readonly property color _iconColor: enabled ? _interactColor : colors.onSurface

    implicitWidth: containerWidth
    implicitHeight: cs.height

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        id: container
        anchors.centerIn: parent
        width: toggleIconButton.containerWidth
        height: cs.height
        clip: true
        radius: toggleIconButton.selected ? cs.squareRadius : 100

        color: !toggleIconButton.enabled ?
            Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.12) :
            (toggleIconButton.selected ? colors.primary : colors.surfaceContainer)

        Behavior on radius { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
        Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.OutCubic } }

        // Ripple
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: toggleIconButton._interactColor
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
            color: toggleIconButton._interactColor
            opacity: !toggleIconButton.enabled ? 0 :
                     (mouseArea.pressed ? 0.12 :
                     (toggleIconButton.activeFocus ? 0.12 :
                     (mouseArea.containsMouse ? 0.08 : 0)))
            Behavior on opacity {
                NumberAnimation { duration: mouseArea.pressed ? 50 : 150; easing.type: Easing.OutCubic }
            }
        }

        // Image icon
        Image {
            visible: toggleIconButton.effectiveIcon !== "" && toggleIconButton.isIconImage
            anchors.centerIn: parent
            width: cs.iconSize; height: cs.iconSize
            source: toggleIconButton.isIconImage ? toggleIconButton.effectiveIcon : ""
            fillMode: Image.PreserveAspectFit
            smooth: true
        }

        // Text/ligature icon
        Text {
            visible: toggleIconButton.effectiveIcon !== "" && !toggleIconButton.isIconImage
            anchors.centerIn: parent
            text: toggleIconButton.effectiveIcon
            font.family: Theme.ChiTheme.iconFamily
            font.pixelSize: cs.iconSize
            color: toggleIconButton._iconColor
        }

        // Focus indicator
        Rectangle {
            visible: toggleIconButton.activeFocus && !mouseArea.pressed
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
        enabled: toggleIconButton.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onPressed: rippleAnimation.restart()
        onClicked: {
            toggleIconButton.selected = !toggleIconButton.selected
            toggleIconButton.toggled(toggleIconButton.selected)
        }
    }

    ToolTip {
        visible: toggleIconButton.tooltip !== "" && mouseArea.containsMouse
        text: toggleIconButton.tooltip
        delay: 500
    }

    Keys.onSpacePressed:  if (enabled) _activate()
    Keys.onEnterPressed:  if (enabled) _activate()
    Keys.onReturnPressed: if (enabled) _activate()

    function _activate() {
        rippleAnimation.restart()
        selected = !selected
        toggled(selected)
    }
}
