import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme

Item {
    id: root

    property string text: ""
    property string icon: ""
    property string activeIcon: ""
    property bool selected: false
    property bool enabled: true
    property string badge: ""
    property string trailingText: ""

    signal clicked()

    readonly property string displayIcon: selected && activeIcon !== "" ? activeIcon : icon
    readonly property bool hasIcon: icon !== ""
    readonly property bool hasBadge: badge !== ""
    readonly property bool hasTrailingText: trailingText !== ""

    Layout.fillWidth: true
    implicitHeight: 56

    opacity: enabled ? 1.0 : 0.38

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        radius: 28
        color: selected ? colors.secondaryContainer : "transparent"

        Behavior on color {
            ColorAnimation { duration: 150 }
        }

        // State layer
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: selected ? colors.onSecondaryContainer : colors.onSurface
            opacity: {
                if (!enabled) return 0
                if (mouseArea.pressed) return 0.12
                if (mouseArea.containsMouse) return 0.08
                return 0
            }

            Behavior on opacity {
                NumberAnimation { duration: 100 }
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 24
            spacing: 12

            // Icon
            Text {
                visible: hasIcon
                text: displayIcon
                font.family: "Material Icons"
                font.pixelSize: 24
                color: selected ? colors.onSecondaryContainer : colors.onSurfaceVariant
                Layout.alignment: Qt.AlignVCenter

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            // Label
            Text {
                text: root.text
                font.family: "Roboto"
                font.pixelSize: 14
                font.weight: selected ? Font.Bold : Font.Medium
                font.letterSpacing: 0.1
                color: selected ? colors.onSecondaryContainer : colors.onSurfaceVariant
                elide: Text.ElideRight
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            // Trailing text
            Text {
                visible: hasTrailingText
                text: trailingText
                font.family: "Roboto"
                font.pixelSize: 14
                font.weight: Font.Medium
                color: colors.onSurfaceVariant
                Layout.alignment: Qt.AlignVCenter

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            // Badge
            Rectangle {
                visible: hasBadge
                Layout.preferredWidth: Math.max(24, badgeLabel.implicitWidth + 12)
                Layout.preferredHeight: 24
                Layout.alignment: Qt.AlignVCenter
                radius: 12
                color: selected ? colors.secondaryContainer : colors.error

                border.width: selected ? 0 : 0
                border.color: colors.onSecondaryContainer

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }

                Text {
                    id: badgeLabel
                    anchors.centerIn: parent
                    text: badge
                    font.family: "Roboto"
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    color: selected ? colors.onSecondaryContainer : colors.onError

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            enabled: root.enabled
            hoverEnabled: true
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

            onClicked: root.clicked()
        }
    }

    Accessible.role: Accessible.MenuItem
    Accessible.name: text
    Accessible.selected: selected
}
