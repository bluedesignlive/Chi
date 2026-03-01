// qml/smartui/ui/menus/OverflowMenu.qml

import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Effects
import "../../theme" as Theme
import "../common"

Popup {
    id: root

    property var menus: []
    property var colors: Theme.SmartTheme
    property int maxHeight: 500

    signal itemTriggered(string menuId, string itemId)

    x: 0
    y: parent ? parent.height + 4 : 0
    width: 280
    height: Math.min(contentColumn.implicitHeight + 16, maxHeight)
    padding: 0

    background: Rectangle {
        color: colors.surfaceContainerHigh
        radius: Theme.SmartTheme.shape.large
        border.width: 1
        border.color: colors.outlineVariant

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.15)
            shadowVerticalOffset: 4
            shadowBlur: 0.45
        }
    }

    contentItem: Flickable {
        id: flickable
        width: root.width
        height: root.height - 16
        contentWidth: width
        contentHeight: contentColumn.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        ScrollBar.vertical: ScrollBar {
            policy: flickable.contentHeight > flickable.height
                ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
            width: 6
        }

        Column {
            id: contentColumn
            width: parent.width
            padding: 8
            spacing: 0

            Repeater {
                model: root.menus

                delegate: Column {
                    width: parent.width - 16
                    x: 8
                    spacing: 0

                    required property var modelData
                    required property int index

                    readonly property string menuId:    modelData.id || ""
                    readonly property string menuTitle:  modelData.title || ""
                    readonly property var    menuItems:  modelData.items || []

                    // Menu header
                    Item {
                        width: parent.width
                        height: 32

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            text: menuTitle
                            font: Theme.SmartTheme.typography.labelSmall
                            font.weight: Font.Bold
                            color: colors.primary
                        }
                    }

                    // Menu items
                    Repeater {
                        model: menuItems

                        delegate: Item {
                            width: parent.width
                            height: isDivider ? 9 : 44

                            required property var modelData
                            required property int index

                            readonly property string itemId:       modelData.id || ""
                            readonly property string itemText:     modelData.text || ""
                            readonly property string itemIcon:     modelData.icon || ""
                            readonly property string itemShortcut: modelData.shortcut || ""
                            readonly property bool   isDivider:    modelData.type === "divider"
                            readonly property var    subItems:     modelData.items || []
                            readonly property bool   hasSubmenu:   subItems.length > 0

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
                                id: menuItemBg
                                visible: !isDivider
                                anchors.fill: parent
                                anchors.margins: 2
                                radius: Theme.SmartTheme.shape.medium
                                color: menuItemMouse.containsMouse
                                    ? Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b,
                                               Theme.SmartTheme.stateLayer.hover)
                                    : "transparent"

                                Row {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 12

                                    Icon {
                                        anchors.verticalCenter: parent.verticalCenter
                                        source: itemIcon
                                        size: 20
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

                                Row {
                                    anchors.right: parent.right
                                    anchors.rightMargin: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 8

                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: itemShortcut
                                        font: Theme.SmartTheme.typography.labelSmall
                                        color: colors.onSurfaceVariant
                                        opacity: 0.7
                                        visible: itemShortcut !== "" && !hasSubmenu
                                    }

                                    Icon {
                                        anchors.verticalCenter: parent.verticalCenter
                                        source: "chevron_right"
                                        size: 16
                                        color: colors.onSurfaceVariant
                                        visible: hasSubmenu
                                    }
                                }

                                MouseArea {
                                    id: menuItemMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        if (hasSubmenu) {
                                            submenuPopup.open()
                                        } else {
                                            root.itemTriggered(menuId, itemId)
                                            root.close()
                                        }
                                    }
                                }

                                // Submenu popup
                                Popup {
                                    id: submenuPopup
                                    x: parent.width - 8
                                    y: -8
                                    width: 200
                                    padding: 8
                                    visible: false

                                    background: Rectangle {
                                        color: colors.surfaceContainerHigh
                                        radius: Theme.SmartTheme.shape.medium
                                        border.width: 1
                                        border.color: colors.outlineVariant

                                        layer.enabled: true
                                        layer.effect: MultiEffect {
                                            shadowEnabled: true
                                            shadowColor: Qt.rgba(0, 0, 0, 0.12)
                                            shadowVerticalOffset: 2
                                            shadowBlur: 0.25
                                        }
                                    }

                                    contentItem: Column {
                                        spacing: 0

                                        Repeater {
                                            model: subItems

                                            delegate: Item {
                                                width: 184
                                                height: 40

                                                required property var modelData
                                                required property int index

                                                Rectangle {
                                                    anchors.fill: parent
                                                    anchors.margins: 2
                                                    radius: Theme.SmartTheme.shape.medium
                                                    color: subItemMouse.containsMouse
                                                        ? Qt.rgba(colors.onSurface.r, colors.onSurface.g,
                                                                   colors.onSurface.b,
                                                                   Theme.SmartTheme.stateLayer.hover)
                                                        : "transparent"

                                                    Text {
                                                        anchors.left: parent.left
                                                        anchors.leftMargin: 12
                                                        anchors.verticalCenter: parent.verticalCenter
                                                        text: modelData.text || ""
                                                        font: Theme.SmartTheme.typography.bodyMedium
                                                        color: colors.onSurface
                                                    }

                                                    MouseArea {
                                                        id: subItemMouse
                                                        anchors.fill: parent
                                                        hoverEnabled: true
                                                        cursorShape: Qt.PointingHandCursor
                                                        onClicked: {
                                                            root.itemTriggered(menuId, modelData.id)
                                                            submenuPopup.close()
                                                            root.close()
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Separator between menu groups
                    Item {
                        width: parent.width
                        height: 8
                        visible: index < root.menus.length - 1
                    }
                }
            }
        }
    }
}
