import QtQuick
import QtQuick.Effects
import "../../theme" as Theme
import "../common" as Common

Item {
    id: fab
    property string icon: "add"
    property string variant: "primary"
    property string size: "medium"
    property bool enabled: true
    property bool menuOpen: false
    signal clicked

    readonly property var colors: Theme.ChiTheme.colors
    readonly property var spec: Theme.SizeSpecs.getSpec(Theme.SizeSpecs.fab, size)

    readonly property color _containerColor: variant === "secondary" ? colors.secondaryContainer : (variant === "tertiary" ? colors.tertiaryContainer : (variant === "surface" ? colors.surfaceContainerHigh : colors.primaryContainer))
    readonly property color _contentColor: variant === "secondary" ? colors.onSecondaryContainer : (variant === "tertiary" ? colors.onTertiaryContainer : (variant === "surface" ? colors.primary : colors.onPrimaryContainer))

    implicitWidth: spec.size
    implicitHeight: spec.size

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity { NumberAnimation { duration: 200 } }
    
    scale: mouseArea.pressed ? 0.92 : 1.0
    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

    Rectangle {
        id: container
        anchors.fill: parent
        
        radius: fab.menuOpen ? height / 2 : spec.radius
        clip: true
        color: fab._containerColor

        // OutQuart (350ms): Instant reaction, but a long, luxurious, smooth settle
        Behavior on radius { NumberAnimation { duration: 350; easing.type: Easing.OutQuart } }

        layer.enabled: fab.enabled
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.25)
            shadowVerticalOffset: mouseArea.containsMouse ? 4 : 2
            shadowBlur: mouseArea.containsMouse ? 0.4 : 0.2
        }

        Common.StateLayer { layerColor: fab._contentColor; containerRadius: parent.radius; pressed: mouseArea.pressed; hovered: mouseArea.containsMouse; enabled: fab.enabled }
        Common.Ripple { id: ripple; color: fab._contentColor; radius: parent.radius; enabled: fab.enabled }

        Common.Icon {
            anchors.centerIn: parent
            source: fab.icon
            size: spec.iconSize
            color: fab._contentColor
            
            rotation: fab.menuOpen ? 45 : 0
            // Rotation exactly matches the silky morph curve
            Behavior on rotation { NumberAnimation { duration: 350; easing.type: Easing.OutQuart } }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: fab.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onPressed: (mouse) => ripple.addRipple(mouse.x, mouse.y)
        onReleased: ripple.removeRipple()
        onCanceled: ripple.removeRipple()
        onClicked: fab.clicked()
    }
}
