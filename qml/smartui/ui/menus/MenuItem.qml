import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme

Item {
    id: root

    property string text: ""
    property string leadingIcon: ""
    property string trailingIcon: ""
    property string trailingText: ""
    property bool enabled: true
    property bool selected: false
    property bool destructive: false
    property bool showDivider: false

    signal clicked()

    readonly property bool hasLeadingIcon: leadingIcon !== ""
    readonly property bool hasTrailingIcon: trailingIcon !== ""
    readonly property bool hasTrailingText: trailingText !== ""

    implicitWidth: parent ? parent.width : 200
    implicitHeight: 48 + (showDivider ? 9 : 0)

    opacity: enabled ? 1.0 : 0.38

    property var colors: Theme.ChiTheme.colors

    Column {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            width: parent.width
            height: 48
            radius: 0
            color: selected ? colors.secondaryContainer : "transparent"

            Behavior on color {
                ColorAnimation { duration: 150 }
            }

            // State layer
            Rectangle {
                anchors.fill: parent
                color: colors.onSurface
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
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 12

                // Leading icon
                Text {
                    visible: hasLeadingIcon
                    text: leadingIcon
                    font.family: "Material Icons"
                    font.pixelSize: 24
                    color: {
                        if (destructive) return colors.error
                        if (selected) return colors.onSecondaryContainer
                        return colors.onSurfaceVariant
                    }
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
                    color: {
                        if (destructive) return colors.error
                        if (selected) return colors.onSecondaryContainer
                        return colors.onSurface
                    }
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }

                // Trailing text (shortcut, etc.)
                Text {
                    visible: hasTrailingText
                    text: trailingText
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: colors.onSurfaceVariant
                    Layout.alignment: Qt.AlignVCenter

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }

                // Trailing icon
                Text {
                    visible: hasTrailingIcon
                    text: trailingIcon
                    font.family: "Material Icons"
                    font.pixelSize: 24
                    color: colors.onSurfaceVariant
                    Layout.alignment: Qt.AlignVCenter

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

                onClicked: root.clicked()
            }
        }

        // Divider
        Rectangle {
            visible: showDivider
            width: parent.width
            height: 1
            color: colors.outlineVariant

            Behavior on color {
                ColorAnimation { duration: 200 }
            }

            Item { width: parent.width; height: 8 }
        }
    }

    Accessible.role: Accessible.MenuItem
    Accessible.name: text
}
