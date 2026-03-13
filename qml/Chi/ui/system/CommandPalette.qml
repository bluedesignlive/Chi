import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Item {
    id: root

    property bool open: false
    property string placeholder: "Type a command..."
    property var commands: []                // [{id: "", label: "", shortcut: "", icon: "", category: ""}]
    property string searchText: ""
    property int selectedIndex: 0
    property int maxVisible: 8

    signal commandSelected(var command)
    signal closed()

    readonly property var filteredCommands: {
        if (searchText === "") return commands
        var search = searchText.toLowerCase()
        return commands.filter(function(cmd) {
            return cmd.label.toLowerCase().indexOf(search) !== -1 ||
                   (cmd.category && cmd.category.toLowerCase().indexOf(search) !== -1)
        })
    }

    anchors.fill: parent
    visible: open
    z: 2000

    property var colors: Theme.ChiTheme.colors

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

        scale: open ? 1 : 0.95
        opacity: open ? 1 : 0

        Behavior on scale {
            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
        }
        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }
        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 16
            radius: 32
            samples: 33
            color: Qt.rgba(0, 0, 0, 0.3)
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

                        font.family: "Roboto"
                        font.pixelSize: 16
                        color: colors.onSurface
                        selectionColor: colors.primaryContainer
                        selectedTextColor: colors.onPrimaryContainer

                        onTextChanged: {
                            searchText = text
                            selectedIndex = 0
                        }

                        Keys.onUpPressed: {
                            if (selectedIndex > 0) selectedIndex--
                        }

                        Keys.onDownPressed: {
                            if (selectedIndex < filteredCommands.length - 1) selectedIndex++
                        }

                        Keys.onReturnPressed: {
                            if (filteredCommands.length > 0) {
                                commandSelected(filteredCommands[selectedIndex])
                                root.close()
                            }
                        }

                        Keys.onEscapePressed: root.close()

                        Text {
                            visible: !searchInput.text
                            anchors.fill: parent
                            text: placeholder
                            font: searchInput.font
                            color: colors.onSurfaceVariant
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

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
                            onClicked: {
                                searchInput.clear()
                                searchInput.forceActiveFocus()
                            }
                        }
                    }
                }

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
                Layout.preferredHeight: Math.min(filteredCommands.length * 48, maxVisible * 48)
                contentHeight: commandsColumn.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                Column {
                    id: commandsColumn
                    width: parent.width

                    Repeater {
                        model: filteredCommands

                        Rectangle {
                            width: parent.width
                            height: 48

                            property bool isSelected: index === selectedIndex

                            color: isSelected ? colors.primaryContainer : "transparent"

                            Behavior on color {
                                ColorAnimation { duration: 100 }
                            }

                            Rectangle {
                                anchors.fill: parent
                                color: colors.onSurface
                                opacity: cmdMouse.containsMouse && !isSelected ? 0.08 : 0
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 16
                                anchors.rightMargin: 16
                                spacing: 12

                                // Icon
                                Text {
                                    visible: modelData.icon && modelData.icon !== ""
                                    text: modelData.icon
                                    font.pixelSize: 20
                                    color: isSelected ? colors.onPrimaryContainer : colors.onSurfaceVariant
                                    Layout.alignment: Qt.AlignVCenter

                                    Behavior on color {
                                        ColorAnimation { duration: 100 }
                                    }
                                }

                                // Label
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 2

                                    Text {
                                        text: modelData.label
                                        font.family: "Roboto"
                                        font.pixelSize: 14
                                        color: isSelected ? colors.onPrimaryContainer : colors.onSurface
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true

                                        Behavior on color {
                                            ColorAnimation { duration: 100 }
                                        }
                                    }

                                    Text {
                                        visible: modelData.category && modelData.category !== ""
                                        text: modelData.category
                                        font.family: "Roboto"
                                        font.pixelSize: 12
                                        color: colors.onSurfaceVariant
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                    }
                                }

                                // Shortcut
                                Rectangle {
                                    visible: modelData.shortcut && modelData.shortcut !== ""
                                    Layout.preferredWidth: shortcutLabel.implicitWidth + 12
                                    Layout.preferredHeight: 24
                                    radius: 4
                                    color: colors.surfaceContainerHighest

                                    Text {
                                        id: shortcutLabel
                                        anchors.centerIn: parent
                                        text: modelData.shortcut
                                        font.family: "Roboto"
                                        font.pixelSize: 12
                                        color: colors.onSurfaceVariant
                                    }
                                }
                            }

                            MouseArea {
                                id: cmdMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    commandSelected(modelData)
                                    root.close()
                                }

                                onEntered: selectedIndex = index
                            }
                        }
                    }
                }
            }

            // Empty state
            Item {
                visible: filteredCommands.length === 0
                Layout.fillWidth: true
                Layout.preferredHeight: 100

                Text {
                    anchors.centerIn: parent
                    text: "No commands found"
                    font.family: "Roboto"
                    font.pixelSize: 14
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
                        font.family: "Roboto"
                        font.pixelSize: 12
                        color: colors.onSurfaceVariant
                    }

                    Text {
                        text: "↵ Select"
                        font.family: "Roboto"
                        font.pixelSize: 12
                        color: colors.onSurfaceVariant
                    }

                    Text {
                        text: "Esc Close"
                        font.family: "Roboto"
                        font.pixelSize: 12
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

    function show() {
        open = true
    }

    function close() {
        open = false
        closed()
    }

    function toggle() {
        if (open) close()
        else show()
    }

    Accessible.role: Accessible.Dialog
    Accessible.name: "Command palette"
}
