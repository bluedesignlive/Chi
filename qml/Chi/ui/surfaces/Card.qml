import QtQuick
import Qt5Compat.GraphicalEffects
import "../theme" as Theme

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

    // Shadow for Elevated variant
    Item {
        anchors.fill: container
        visible: variant === "elevated"
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: mouseArea.pressed ? 2 : 1
            radius: mouseArea.pressed ? 4 : 2
            samples: 9
            color: Qt.rgba(0,0,0,0.15)
        }
    }

    Rectangle {
        id: container
        anchors.fill: parent
        radius: card.radius
        clip: true

        color: {
            switch(variant) {
                case "filled": return colors.surfaceContainerHighest
                case "elevated": return colors.surfaceContainerLow
                case "outlined": return colors.surface
                default: return colors.surface
            }
        }

        border.width: variant === "outlined" ? 1 : 0
        border.color: colors.outlineVariant

        // State Layer (Hover/Press overlay)
        Rectangle {
            anchors.fill: parent
            color: colors.onSurface
            opacity: {
                if (!interactive) return 0
                if (mouseArea.pressed) return 0.12
                if (mouseArea.containsMouse) return 0.08
                return 0
            }
            visible: interactive

            Behavior on opacity {
                NumberAnimation { duration: 150 }
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            enabled: interactive
            hoverEnabled: true
            cursorShape: interactive ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: card.clicked()
        }
    }
}
