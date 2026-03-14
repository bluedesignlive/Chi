// ToggleButton — Toggleable button with filled, elevated, tonal, outlined variants
import QtQuick
import QtQuick.Effects
import "../../theme" as Theme

Item {
    id: toggleButton

    property string text: "Toggle"
    property string variant: "filled"   // filled, elevated, tonal, outlined
    property string size: "small"       // xsmall..xlarge
    property string shape: "round"      // round, square
    property bool selected: false
    property bool showIcon: false
    property string icon: ""
    property string selectedIcon: ""
    property bool enabled: true

    signal toggled(bool selected)

    readonly property var sizeSpecs: ({
        xsmall: { height: 32,  padding: 6,  horizontalPadding: 12, gap: 4,  iconSize: 20, fontSize: 14, fontWeight: Font.Medium, letterSpacing: 0.1,  squareRadius: 12, borderWidth: 1 },
        small:  { height: 40,  padding: 10, horizontalPadding: 16, gap: 8,  iconSize: 20, fontSize: 14, fontWeight: Font.Medium, letterSpacing: 0.1,  squareRadius: 12, borderWidth: 1 },
        medium: { height: 56,  padding: 16, horizontalPadding: 24, gap: 8,  iconSize: 24, fontSize: 16, fontWeight: Font.Medium, letterSpacing: 0.15, squareRadius: 16, borderWidth: 1 },
        large:  { height: 96,  padding: 32, horizontalPadding: 48, gap: 12, iconSize: 32, fontSize: 24, fontWeight: Font.Normal, letterSpacing: 0,    squareRadius: 28, borderWidth: 2 },
        xlarge: { height: 136, padding: 48, horizontalPadding: 64, gap: 16, iconSize: 40, fontSize: 32, fontWeight: Font.Normal, letterSpacing: 0,    squareRadius: 28, borderWidth: 2 }
    })

    readonly property var cs: sizeSpecs[size] || sizeSpecs.small

    // Cached variant flags
    readonly property bool _filled: variant === "filled"
    readonly property bool _elevated: variant === "elevated"
    readonly property bool _tonal: variant === "tonal"
    readonly property bool _outlined: variant === "outlined"

    // Robust icon detection
    readonly property bool isIconImage: {
        var s = icon
        return s.indexOf(".svg") !== -1 || s.indexOf(".png") !== -1 ||
               s.indexOf(".jpg") !== -1 || s.indexOf("qrc:/") === 0
    }

    readonly property string currentIcon: selected && selectedIcon !== "" ? selectedIcon : icon

    // Cached interactive color — shared by state layer, ripple, and label
    readonly property color _interactColor: {
        if (!selected) {
            if (_filled)   return colors.onSurfaceVariant
            if (_elevated) return colors.primary
            if (_tonal)    return colors.onSurfaceVariant
            if (_outlined) return colors.onSecondaryContainer
            return colors.primary
        }
        if (_filled || _elevated) return colors.onPrimary
        if (_tonal)    return colors.inverseOnSurface
        if (_outlined) return colors.onSecondary
        return colors.onPrimary
    }

    readonly property color _labelColor: enabled ? _interactColor : colors.onSurface

    implicitWidth: buttonContent.implicitWidth
    implicitHeight: cs.height

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        id: container
        anchors.fill: parent
        radius: shape === "round" ? 100 : cs.squareRadius
        clip: true

        color: {
            if (!toggleButton.enabled) return "transparent"
            if (toggleButton._filled)   return toggleButton.selected ? colors.primary : colors.surfaceContainer
            if (toggleButton._elevated) return toggleButton.selected ? colors.primary : colors.surfaceContainerLow
            if (toggleButton._tonal)    return toggleButton.selected ? colors.inverseSurface : "transparent"
            if (toggleButton._outlined) return toggleButton.selected ? colors.secondary : colors.secondaryContainer
            return colors.primary
        }

        border.width: (!toggleButton.selected && toggleButton._tonal) ? cs.borderWidth : 0
        border.color: (!toggleButton.selected && toggleButton._tonal) ? colors.outlineVariant : "transparent"

        // Disabled overlay
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            visible: !toggleButton.enabled
            color: colors.onSurface
            opacity: 0.12
        }

        // Ripple
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: toggleButton._interactColor
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
            color: toggleButton._interactColor
            opacity: !toggleButton.enabled ? 0 :
                     (mouseArea.pressed ? 0.12 : (mouseArea.containsMouse ? 0.08 : 0))
            Behavior on opacity {
                NumberAnimation { duration: mouseArea.pressed ? 50 : 150; easing.type: Easing.OutCubic }
            }
        }

        Row {
            id: buttonContent
            anchors.centerIn: parent
            spacing: cs.gap
            padding: cs.padding
            leftPadding: cs.horizontalPadding
            rightPadding: cs.horizontalPadding

            // Image icon
            Image {
                visible: toggleButton.showIcon && toggleButton.currentIcon !== "" && toggleButton.isIconImage
                width: cs.iconSize; height: cs.iconSize
                source: toggleButton.currentIcon
                fillMode: Image.PreserveAspectFit
                smooth: true
                opacity: labelText.opacity
                anchors.verticalCenter: parent.verticalCenter
            }

            // Text/ligature icon
            Text {
                visible: toggleButton.showIcon && toggleButton.currentIcon !== "" && !toggleButton.isIconImage
                text: toggleButton.currentIcon
                font.family: Theme.ChiTheme.iconFamily
                font.pixelSize: cs.iconSize
                color: labelText.color
                opacity: labelText.opacity
                anchors.verticalCenter: parent.verticalCenter
            }

            // Label
            Text {
                id: labelText
                text: toggleButton.text
                font.family: Theme.ChiTheme.fontFamily
                font.weight: cs.fontWeight
                font.pixelSize: cs.fontSize
                font.letterSpacing: cs.letterSpacing
                verticalAlignment: Text.AlignVCenter
                color: toggleButton._labelColor
                opacity: toggleButton.enabled ? 1.0 : 0.38
                anchors.verticalCenter: parent.verticalCenter
                Behavior on color { ColorAnimation { duration: 200 } }
            }
        }

        // Elevation for elevated variant
        layer.enabled: toggleButton._elevated && toggleButton.enabled
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.3)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 1
            shadowBlur: 0.15
        }

        Behavior on color { ColorAnimation { duration: 200 } }
        Behavior on border.color { ColorAnimation { duration: 200 } }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: toggleButton.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onPressed: rippleAnimation.restart()
        onClicked: {
            toggleButton.selected = !toggleButton.selected
            toggleButton.toggled(toggleButton.selected)
        }
    }
}
