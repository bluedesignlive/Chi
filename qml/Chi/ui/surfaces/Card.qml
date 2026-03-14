import QtQuick
import QtQuick.Effects
import "../../theme" as Theme

Item {
    id: card

    property string variant: "filled" // filled, elevated, outlined
    property bool interactive: false  // Does it respond to clicks?

    default property alias content: container.children
    signal clicked()

    // Expressive MD3 often uses larger radii
    property int radius: 12

    implicitWidth: 300
    implicitHeight: 200

    property var colors: Theme.ChiTheme.colors

    readonly property bool _elevated: variant === "elevated"

    Rectangle {
        id: container
        anchors.fill: parent
        radius: card.radius
        clip: true

        color: card._elevated ? colors.surfaceContainerLow :
               (card.variant === "outlined" ? colors.surface : colors.surfaceContainerHighest)

        border.width: card.variant === "outlined" ? 1 : 0
        border.color: colors.outlineVariant

        // State Layer (Hover/Press overlay)
        Rectangle {
            anchors.fill: parent
            color: colors.onSurface
            visible: card.interactive
            opacity: !card.interactive ? 0 :
                     (mouseArea.pressed ? 0.12 :
                     (mouseArea.containsMouse ? 0.08 : 0))
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }

        // Shadow for Elevated variant
        layer.enabled: card._elevated
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.15)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: mouseArea.pressed ? 2 : 1
            shadowBlur: mouseArea.pressed ? 0.2 : 0.1
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            enabled: card.interactive
            hoverEnabled: true
            cursorShape: card.interactive ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: card.clicked()
        }
    }
}
