// qml/smartui/ui/menus/DropdownMenu.qml

import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Effects
import "../../theme" as Theme
import "../common"

Popup {
    id: root

    property var items: []
    property var colors: Theme.SmartTheme

    signal itemClicked(string itemId)

    width: 220
    padding: 8

    background: Rectangle {
        color: colors.surfaceContainerHigh
        radius: Theme.SmartTheme.shape.medium
        border.width: 1
        border.color: colors.outlineVariant

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
                height: isDivider ? 9 : 40

                required property var modelData
                required property int index

                readonly property string itemId:       modelData.id || ""
                readonly property string itemText:     modelData.text || ""
                readonly property string itemIcon:     modelData.icon || ""
                readonly property string itemShortcut: modelData.shortcut || ""
                readonly property bool   isDivider:    modelData.type === "divider"

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
                    radius: Theme.SmartTheme.shape.medium
                    color: dropdownItemMouse.containsMouse
                        ? Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b,
                                   Theme.SmartTheme.stateLayer.hover)
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
                            color: colors.onSurfaceVariant
                            visible: itemIcon !== ""
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: itemText
                            font: Theme.SmartTheme.typography.bodyMedium
                            color: colors.onSurface
                        }
                    }

                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        text: itemShortcut
                        font: Theme.SmartTheme.typography.labelSmall
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
