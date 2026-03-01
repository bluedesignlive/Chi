import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Effects
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
        color: root.colors.surfaceContainerHigh
        radius: 12
        border.width: 1
        border.color: root.colors.outlineVariant

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.12)
            shadowVerticalOffset: 4
            shadowBlur: 0.35
        }
    }

    contentItem: Column {
        spacing: 0

        Repeater {
            model: root.items

            delegate: Item {
                width: parent.width
                height: modelData.type === "divider" ? 9 : 40

                property string itemId:       modelData.id || ""
                property string itemText:     modelData.text || ""
                property string itemIcon:     modelData.icon || ""
                property string itemShortcut: modelData.shortcut || ""
                property bool   isDivider:    modelData.type === "divider"

                // Divider
                Rectangle {
                    visible: isDivider
                    anchors.centerIn: parent
                    width: parent.width - 16
                    height: 1
                    color: root.colors.outlineVariant
                }

                // Menu item
                Rectangle {
                    visible: !isDivider
                    anchors.fill: parent
                    anchors.margins: 2
                    radius: 10
                    color: dropdownItemMouse.containsMouse
                        ? Qt.rgba(root.colors.onSurface.r, root.colors.onSurface.g, root.colors.onSurface.b, 0.08)
                        : "transparent"

                    Row {
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10

                        Icon {
                            anchors.verticalCenter: parent.verticalCenter
                            source: itemIcon
                            size: 18
                            color: root.colors.onSurfaceVariant
                            visible: itemIcon !== ""
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: itemText
                            font.family: "Roboto"
                            font.pixelSize: 13
                            color: root.colors.onSurface
                        }
                    }

                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        text: itemShortcut
                        font.family: "Roboto"
                        font.pixelSize: 11
                        color: root.colors.onSurfaceVariant
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
