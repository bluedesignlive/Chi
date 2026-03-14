import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../../theme" as Theme

Item {
    id: root

    property bool open: false
    property string placeholder: "Type a command..."
    property var commands: []                // [{id, label, shortcut, icon, category}]
    property string searchText: ""
    property int selectedIndex: 0
    property int maxVisible: 8

    signal commandSelected(var command)
    signal closed()

    readonly property var filteredCommands: {
        if (searchText === "") return commands
        var s = searchText.toLowerCase()
        return commands.filter(function(cmd) {
            return cmd.label.toLowerCase().indexOf(s) !== -1 ||
                   (cmd.category && cmd.category.toLowerCase().indexOf(s) !== -1)
        })
    }

    anchors.fill: parent
    visible: open
    z: 2000

    property var colors: Theme.ChiTheme.colors
    readonly property var _typo: Theme.ChiTheme.typography

    // Backdrop
    Rectangle {
        anchors.fill: parent
        color: colors.scrim
        opacity: 0.5

        MouseArea {
            anchors.fill: parent
            onClicked: root.close()
        }
    }

    // Palette container
    Rectangle {
        id: palette
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.15
        width: Math.min(600, parent.width - 48)
        height: Math.min(searchField.height + commandsList.height + 16, parent.height * 0.6)
        radius: 16
        color: colors.surfaceContainerHigh
        clip: true

        scale: root.open ? 1 : 0.95
        opacity: root.open ? 1 : 0

        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: 150 } }
        Behavior on color { ColorAnimation { duration: 200 } }

        layer.enabled: root.open
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.3)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 16
            shadowBlur: 1.0
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // Search field
            Rectangle {
                id: searchField
                Layout.fillWidth: true
                Layout.preferredHeight: 56
                color: "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 12

                    Text {
                        text: "🔍"
                        font.pixelSize: 20
                        color: colors.onSurfaceVariant
                        Layout.alignment: Qt.AlignVCenter
                    }

                    TextInput {
                        id: searchInput
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        font.family: Theme.ChiTheme.fontFamily
                        font.pixelSize: _typo.bodyLarge.size
                        color: colors.onSurface
                        selectionColor: colors.primaryContainer
                        selectedTextColor: colors.onPrimaryContainer

                        onTextChanged: {
                            root.searchText = text
                            root.selectedIndex = 0
                        }

                        Keys.onUpPressed: { if (root.selectedIndex > 0) root.selectedIndex-- }
                        Keys.onDownPressed: { if (root.selectedIndex < root.filteredCommands.length - 1) root.selectedIndex++ }
                        Keys.onReturnPressed: {
                            if (root.filteredCommands.length > 0) {
                                root.commandSelected(root.filteredCommands[root.selectedIndex])
                                root.close()
                            }
                        }
                        Keys.onEscapePressed: root.close()

                        // Placeholder
                        Text {
                            visible: !searchInput.text
                            anchors.fill: parent
                            text: root.placeholder
                            font: searchInput.font
                            color: colors.onSurfaceVariant
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    // Clear button
                    Text {
                        visible: searchInput.text !== ""
                        text: "✕"
                        font.pixelSize: 18
                        color: colors.onSurfaceVariant
                        Layout.alignment: Qt.AlignVCenter

                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: -8
                            cursorShape: Qt.PointingHandCursor
                            onClicked: { searchInput.clear(); searchInput.forceActiveFocus() }
                        }
                    }
                }

                // Divider
                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 1
                    color: colors.outlineVariant
                }
            }

            // Commands list
            Flickable {
                id: commandsList
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: Math.min(root.filteredCommands.length, root.maxVisible) * 48
                contentHeight: commandsColumn.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                Column {
                    id: commandsColumn
                    width: parent.width

                    Repeater {
                        model: root.filteredCommands

                        Rectangle {
                            width: parent.width
                            height: 48

                            property bool _sel: index === root.selectedIndex

                            color: _sel ? colors.primaryContainer : "transparent"
                            Behavior on color { ColorAnimation { duration: 100 } }

                            // Hover overlay
                            Rectangle {
                                anchors.fill: parent
                                color: colors.onSurface
                                opacity: cmdMouse.containsMouse && !parent._sel ? 0.08 : 0
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 16
                                anchors.rightMargin: 16
                                spacing: 12

                                // Icon
                                Text {
                                    visible: modelData.icon && modelData.icon !== ""
                                    text: modelData.icon || ""
                                    font.pixelSize: 20
                                    color: _sel ? colors.onPrimaryContainer : colors.onSurfaceVariant
                                    Layout.alignment: Qt.AlignVCenter
                                    Behavior on color { ColorAnimation { duration: 100 } }
                                }

                                // Label + category
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 2

                                    Text {
                                        text: modelData.label || ""
                                        font.family: Theme.ChiTheme.fontFamily
                                        font.pixelSize: _typo.bodyMedium.size
                                        color: _sel ? colors.onPrimaryContainer : colors.onSurface
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                        Behavior on color { ColorAnimation { duration: 100 } }
                                    }

                                    Text {
                                        visible: modelData.category && modelData.category !== ""
                                        text: modelData.category || ""
                                        font.family: Theme.ChiTheme.fontFamily
                                        font.pixelSize: _typo.bodySmall.size
                                        color: colors.onSurfaceVariant
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                    }
                                }

                                // Shortcut badge
                                Rectangle {
                                    visible: modelData.shortcut && modelData.shortcut !== ""
                                    Layout.preferredWidth: shortcutLabel.implicitWidth + 12
                                    Layout.preferredHeight: 24
                                    radius: 4
                                    color: colors.surfaceContainerHighest

                                    Text {
                                        id: shortcutLabel
                                        anchors.centerIn: parent
                                        text: modelData.shortcut || ""
                                        font.family: Theme.ChiTheme.fontFamily
                                        font.pixelSize: _typo.bodySmall.size
                                        color: colors.onSurfaceVariant
                                    }
                                }
                            }

                            MouseArea {
                                id: cmdMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: { root.commandSelected(modelData); root.close() }
                                onEntered: root.selectedIndex = index
                            }
                        }
                    }
                }
            }

            // Empty state
            Item {
                visible: root.filteredCommands.length === 0
                Layout.fillWidth: true
                Layout.preferredHeight: 100

                Text {
                    anchors.centerIn: parent
                    text: "No commands found"
                    font.family: Theme.ChiTheme.fontFamily
                    font.pixelSize: _typo.bodyMedium.size
                    color: colors.onSurfaceVariant
                }
            }

            // Footer hint
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                color: colors.surfaceContainerLow

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 16

                    Text {
                        text: "↑↓ Navigate"
                        font.family: Theme.ChiTheme.fontFamily
                        font.pixelSize: _typo.bodySmall.size
                        color: colors.onSurfaceVariant
                    }
                    Text {
                        text: "↵ Select"
                        font.family: Theme.ChiTheme.fontFamily
                        font.pixelSize: _typo.bodySmall.size
                        color: colors.onSurfaceVariant
                    }
                    Text {
                        text: "Esc Close"
                        font.family: Theme.ChiTheme.fontFamily
                        font.pixelSize: _typo.bodySmall.size
                        color: colors.onSurfaceVariant
                    }
                    Item { Layout.fillWidth: true }
                }
            }
        }
    }

    onOpenChanged: {
        if (open) {
            searchInput.clear()
            selectedIndex = 0
            searchInput.forceActiveFocus()
        }
    }

    function show() { open = true }
    function close() { open = false; closed() }
    function toggle() { if (open) close(); else show() }

    Accessible.role: Accessible.Dialog
    Accessible.name: "Command palette"
}
