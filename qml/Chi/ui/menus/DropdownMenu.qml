// qml/smartui/ui/menus/DropdownMenu.qml
// M3 dropdown menu — model-driven, desktop-density
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Effects
import QtQuick.Layouts
import "../theme" as Theme
import "../common"

Popup {
    id: root

    property var items: []
    property var colors: Theme.ChiTheme.colors

    signal itemClicked(string itemId)

    width: 200
    padding: 4

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
                required property var modelData
                required property int index

                width: parent ? parent.width : 200
                height: modelData.type === "divider" ? 9 : 36

                readonly property string _id:       modelData.id || ""
                readonly property string _text:     modelData.text || ""
                readonly property string _icon:     modelData.icon || ""
                readonly property string _shortcut: modelData.shortcut || ""
                readonly property bool   _divider:  modelData.type === "divider"

                // Divider
                Rectangle {
                    visible: _divider
                    anchors.centerIn: parent
                    width: parent.width - 16; height: 1
                    color: root.colors.outlineVariant
                }

                // Item
                Rectangle {
                    visible: !_divider
                    anchors.fill: parent
                    anchors.margins: 1
                    radius: 8
                    color: _dropMouse.containsMouse
                        ? Qt.alpha(root.colors.onSurface, 0.08) : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        spacing: 10

                        Icon {
                            visible: _icon !== ""
                            source: _icon
                            size: 18
                            color: root.colors.onSurfaceVariant
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Text {
                            text: _text
                            font.family: Theme.ChiTheme.typography.bodyMedium.family
                            font.pixelSize: Theme.ChiTheme.typography.bodyMedium.size
                            font.weight: Theme.ChiTheme.typography.bodyMedium.weight
                            color: root.colors.onSurface
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        Text {
                            visible: _shortcut !== ""
                            text: _shortcut
                            font.family: Theme.ChiTheme.typography.labelSmall.family
                            font.pixelSize: Theme.ChiTheme.typography.labelSmall.size
                            font.weight: Theme.ChiTheme.typography.labelSmall.weight
                            color: root.colors.onSurfaceVariant
                            opacity: 0.6
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }

                    MouseArea {
                        id: _dropMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.itemClicked(_id)
                            root.close()
                        }
                    }
                }
            }
        }
    }
}
