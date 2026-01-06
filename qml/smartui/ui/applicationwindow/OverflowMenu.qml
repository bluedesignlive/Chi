import QtQuick
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme
import "../common"

Popup {
    id: root

    property var menus: []
    property var colors: Theme.ChiTheme.colors
    property int maxHeight: 500

    signal itemTriggered(string menuId, string itemId)

    x: 0
    y: parent ? parent.height + 4 : 0
    width: 280
    height: Math.min(contentColumn.implicitHeight + 16, maxHeight)
    padding: 0

    background: Rectangle {
        color: colors.surfaceContainerHigh
        radius: 16
        border.width: 1
        border.color: colors.outlineVariant

        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 4
            radius: 16
            samples: 33
            color: Qt.rgba(0, 0, 0, 0.15)
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
            policy: flickable.contentHeight > flickable.height ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
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

                    property string menuId: modelData.id || ""
                    property string menuTitle: modelData.title || ""
                    property var menuItems: modelData.items || []

                    // Menu header
                    Item {
                        width: parent.width
                        height: 32

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            text: menuTitle
                            font.family: "Roboto"
                            font.pixelSize: 11
                            font.weight: Font.Bold
                            color: colors.primary
                        }
                    }

                    // Menu items
                    Repeater {
                        model: menuItems

                        delegate: Item {
                            width: parent.width
                            height: modelData.type === "divider" ? 9 : 44

                            property string itemId: modelData.id || ""
                            property string itemText: modelData.text || ""
                            property string itemIcon: modelData.icon || ""
                            property string itemShortcut: modelData.shortcut || ""
                            property bool isDivider: modelData.type === "divider"
                            property var subItems: modelData.items || []
                            property bool hasSubmenu: subItems.length > 0
                            property string parentMenuId: parent.menuId

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
                                radius: 12
                                color: menuItemMouse.containsMouse ? Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.08) : "transparent"

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
                                        font.family: "Roboto"
                                        font.pixelSize: 14
                                        color: colors.onSurface
                                    }
                                }

                                // Right side - shortcut or submenu arrow
                                Row {
                                    anchors.right: parent.right
                                    anchors.rightMargin: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 8

                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: itemShortcut
                                        font.family: "Roboto"
                                        font.pixelSize: 11
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
                                            root.itemTriggered(parentMenuId, itemId)
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
                                        radius: 12
                                        border.width: 1
                                        border.color: colors.outlineVariant

                                        layer.enabled: true
                                        layer.effect: DropShadow {
                                            horizontalOffset: 0
                                            verticalOffset: 2
                                            radius: 8
                                            samples: 17
                                            color: Qt.rgba(0, 0, 0, 0.12)
                                        }
                                    }

                                    contentItem: Column {
                                        spacing: 0

                                        Repeater {
                                            model: subItems

                                            delegate: Item {
                                                width: 184
                                                height: 40

                                                Rectangle {
                                                    anchors.fill: parent
                                                    anchors.margins: 2
                                                    radius: 10
                                                    color: subItemMouse.containsMouse ? Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.08) : "transparent"

                                                    Text {
                                                        anchors.left: parent.left
                                                        anchors.leftMargin: 12
                                                        anchors.verticalCenter: parent.verticalCenter
                                                        text: modelData.text || ""
                                                        font.family: "Roboto"
                                                        font.pixelSize: 13
                                                        color: colors.onSurface
                                                    }

                                                    MouseArea {
                                                        id: subItemMouse
                                                        anchors.fill: parent
                                                        hoverEnabled: true
                                                        cursorShape: Qt.PointingHandCursor
                                                        onClicked: {
                                                            root.itemTriggered(parentMenuId, modelData.id)
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
