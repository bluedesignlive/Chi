import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../theme" as Theme

Item {
    id: root

    property string variant: "elevated"      // "elevated", "filled", "outlined"
    property bool enabled: true
    property bool clickable: false
    property real contentPadding: 16
    property real cornerRadius: 12

    default property alias content: contentContainer.data

    signal clicked()
    signal pressAndHold()

    implicitWidth: 320
    implicitHeight: contentContainer.implicitHeight + contentPadding * 2

    opacity: enabled ? 1.0 : 0.38

    Behavior on opacity {
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
    }

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        id: container
        anchors.fill: parent
        radius: cornerRadius

        color: {
            switch (variant) {
            case "elevated": return colors.surfaceContainerLow
            case "filled": return colors.surfaceContainerHighest
            case "outlined": return colors.surface
            default: return colors.surfaceContainerLow
            }
        }

        border.width: variant === "outlined" ? 1 : 0
        border.color: colors.outlineVariant

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
        Behavior on border.color {
            ColorAnimation { duration: 200 }
        }

        // State layer for clickable cards
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: colors.onSurface
            opacity: {
                if (!clickable || !enabled) return 0
                if (mouseArea.pressed) return 0.12
                if (mouseArea.containsMouse) return 0.08
                return 0
            }

            Behavior on opacity {
                NumberAnimation { duration: 150 }
            }
        }

        // Content
        Item {
            id: contentContainer
            anchors.fill: parent
            anchors.margins: contentPadding
        }

        // Shadow for elevated variant
        layer.enabled: variant === "elevated" && enabled
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: mouseArea.containsMouse && clickable ? 2 : 1
            radius: mouseArea.containsMouse && clickable ? 8 : 4
            samples: 17
            color: Qt.rgba(0, 0, 0, 0.2)

            Behavior on verticalOffset {
                NumberAnimation { duration: 150 }
            }
            Behavior on radius {
                NumberAnimation { duration: 150 }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.enabled && root.clickable
        hoverEnabled: true
        cursorShape: clickable ? Qt.PointingHandCursor : Qt.ArrowCursor

        onClicked: root.clicked()
        onPressAndHold: root.pressAndHold()
    }

    Accessible.role: clickable ? Accessible.Button : Accessible.Pane
    Accessible.name: "Card"
}
