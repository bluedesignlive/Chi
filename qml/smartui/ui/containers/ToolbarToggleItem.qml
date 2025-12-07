import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme

Item {
    id: root

    property string icon: ""
    property string selectedIcon: ""
    property string label: ""
    property bool selected: false
    property bool enabled: true
    property string toolbarType: "standard"  // Set by parent Toolbar

    signal toggled()

    readonly property bool hasLabel: label !== ""
    readonly property bool isVibrant: toolbarType === "vibrant"
    readonly property string displayIcon: selected && selectedIcon !== "" ? selectedIcon : icon

    implicitWidth: hasLabel ? contentRow.implicitWidth + 32 : 48
    implicitHeight: 48

    opacity: enabled ? 1.0 : 0.38

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        id: container
        anchors.centerIn: parent
        width: hasLabel ? parent.width : 40
        height: 40
        radius: mouseArea.pressed ? 8 : 100

        color: {
            if (selected) {
                return colors.secondaryContainer
            }
            if (!enabled) {
                return Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.1)
            }
            return hasLabel ? colors.surfaceContainer : "transparent"
        }

        Behavior on color {
            ColorAnimation { duration: 150 }
        }
        Behavior on radius {
            NumberAnimation { duration: 100 }
        }

        // State layer
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: {
                if (selected) {
                    return colors.onSecondaryContainer
                }
                return isVibrant ? colors.onPrimaryContainer : colors.onSurfaceVariant
            }
            opacity: {
                if (!enabled) return 0
                if (mouseArea.pressed) return 0.1
                if (mouseArea.containsMouse) return 0.08
                if (root.activeFocus) return 0.1
                return 0
            }

            Behavior on opacity {
                NumberAnimation { duration: 100 }
            }
        }

        // Elevation on hover
        layer.enabled: mouseArea.containsMouse && enabled
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 1
            radius: 3
            samples: 9
            color: Qt.rgba(0, 0, 0, 0.2)
        }

        Row {
            id: contentRow
            anchors.centerIn: parent
            spacing: 8

            // Icon
            Text {
                visible: displayIcon !== ""
                text: displayIcon
                font.family: displayIcon.length > 2 ? "Material Icons" : undefined
                font.pixelSize: hasLabel ? 20 : 24
                color: {
                    if (!enabled) {
                        return colors.onSurface
                    }
                    if (selected) {
                        return colors.onSecondaryContainer
                    }
                    return isVibrant ? colors.onPrimaryContainer : colors.onSurfaceVariant
                }
                anchors.verticalCenter: parent.verticalCenter

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            // Label
            Text {
                visible: hasLabel
                text: label
                font.family: "Roboto"
                font.pixelSize: 14
                font.weight: Font.Medium
                font.letterSpacing: 0.1
                color: {
                    if (!enabled) {
                        return colors.onSurface
                    }
                    if (selected) {
                        return colors.onSecondaryContainer
                    }
                    return isVibrant ? colors.onPrimaryContainer : colors.onSurfaceVariant
                }
                anchors.verticalCenter: parent.verticalCenter

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            enabled: root.enabled
            hoverEnabled: true
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

            onClicked: {
                selected = !selected
                root.toggled()
            }
        }
    }

    Accessible.role: Accessible.CheckBox
    Accessible.name: label || icon
    Accessible.checked: selected
}
