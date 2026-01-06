import QtQuick
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme
import "../common"

Popup {
    id: root

    property var items: []
    property var colors: Theme.ChiTheme.colors

    signal itemClicked(string itemId)

    width: 220
    padding: 8

    background: Rectangle {
        color: colors.surfaceContainerHigh
        radius: 12
        border.width: 1
        border.color: colors.outlineVariant

        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 4
            radius: 12
            samples: 25
            color: Qt.rgba(0, 0, 0, 0.12)
        }
    }

    contentItem: Column {
        spacing: 0

        Repeater {
            model: root.items

            delegate: Item {
                width: parent.width
                height: modelData.type === "divider" ? 9 : 40

                property string itemId: modelData.id || ""
                property string itemText: modelData.text || ""
                property string itemIcon: modelData.icon || ""
                property string itemShortcut: modelData.shortcut || ""
                property bool isDivider: modelData.type === "divider"

                // Divider
                Rectangle {
                    visible: isDivider
                    anchors.centerIn: parent
                    width: parent.width - 16
                    height: 1
                    color: colors.outlineVariant
                }

                // Menu item
                Rectangle {
                    visible: !isDivider
                    anchors.fill: parent
                    anchors.margins: 2
                    radius: 10
                    color: dropdownItemMouse.containsMouse ? Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.08) : "transparent"

                    // Left side - icon and text
                    Row {
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10

                        Icon {
                            anchors.verticalCenter: parent.verticalCenter
                            source: itemIcon
                            size: 18
                            color: colors.onSurfaceVariant
                            visible: itemIcon !== ""
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: itemText
                            font.family: "Roboto"
                            font.pixelSize: 13
                            color: colors.onSurface
                        }
                    }

                    // Right side - shortcut (anchored to right)
                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        text: itemShortcut
                        font.family: "Roboto"
                        font.pixelSize: 11
                        color: colors.onSurfaceVariant
                        opacity: 0.6
                        visible: itemShortcut !== ""
                    }

                    MouseArea {
                        id: dropdownItemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.itemClicked(itemId)
                            root.close()
                        }
                    }
                }
            }
        }
    }
}
