// SurfaceCard.qml - Simple Material 3 Card for basic container use
// Lightweight card without content padding - children go directly in container
// Uses MultiEffect for Qt 6.10 compatibility

import QtQuick
import QtQuick.Effects
import "../../theme" as Theme

Item {
    id: card

    // ─── Public API ───────────────────────────────────────────
    property string variant: "filled"        // filled | elevated | outlined
    property bool interactive: false         // Does it respond to clicks?
    property int radius: 12                  // Corner radius

    default property alias content: container.children
    signal clicked()

    // ─── Theme Tokens ───────────────────────────────────────────
    readonly property var colors: Theme.ChiTheme.colors
    readonly property var motion: Theme.ChiTheme.motion

    // ─── Geometry ───────────────────────────────────────────────
    implicitWidth: 300
    implicitHeight: 200

    // ─── Visual Container ───────────────────────────────────────
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

        Behavior on color { ColorAnimation { duration: motion.durationMedium } }

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
                NumberAnimation { duration: motion.durationFast }
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

    // Shadow for Elevated variant
    layer.enabled: variant === "elevated"
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: Qt.rgba(0, 0, 0, 0.15)
        shadowHorizontalOffset: 0
        shadowVerticalOffset: mouseArea.pressed ? 2 : 1
        shadowBlur: mouseArea.pressed ? 0.2 : 0.1
    }
}
