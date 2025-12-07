import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Item {
    id: root

    property string text: ""
    property string placeholderText: "Search"
    property string leadingIcon: "🔍"
    property bool showAvatar: false
    property string avatarSource: ""
    property bool expanded: false
    property bool enabled: true
    property bool showClearButton: true

    property alias suggestions: suggestionsRepeater.model

    signal search(string query)
    signal cleared()
    signal suggestionClicked(int index, var item)

    readonly property bool hasText: text.length > 0
    readonly property bool showSuggestions: expanded && suggestionsRepeater.count > 0

    implicitWidth: 360
    implicitHeight: expanded ? Math.min(56 + suggestionsContainer.height, 400) : 56

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        id: container
        anchors.fill: parent
        radius: expanded ? 28 : 28
        color: colors.surfaceContainerHigh
        clip: true

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
        Behavior on radius {
            NumberAnimation { duration: 200 }
        }

        layer.enabled: expanded
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 4
            radius: 12
            samples: 17
            color: Qt.rgba(0, 0, 0, 0.15)
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // Search input row
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 56
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                spacing: 16

                // Leading icon or avatar
                Item {
                    Layout.preferredWidth: 24
                    Layout.preferredHeight: 24
                    Layout.alignment: Qt.AlignVCenter

                    Rectangle {
                        visible: showAvatar
                        anchors.fill: parent
                        radius: 12
                        color: colors.primaryContainer

                        Image {
                            visible: avatarSource !== ""
                            anchors.fill: parent
                            source: avatarSource
                            fillMode: Image.PreserveAspectCrop
                            layer.enabled: true
                            layer.effect: OpacityMask {
                                maskSource: Rectangle {
                                    width: 24; height: 24; radius: 12
                                }
                            }
                        }
                    }

                    Text {
                        visible: !showAvatar
                        anchors.centerIn: parent
                        text: leadingIcon
                        font.pixelSize: 20
                        color: colors.onSurface

                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }
                }

                // Input field
                TextInput {
                    id: searchInput
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter

                    text: root.text
                    font.family: "Roboto"
                    font.pixelSize: 16
                    color: colors.onSurface
                    selectionColor: colors.primaryContainer
                    selectedTextColor: colors.onPrimaryContainer
                    clip: true

                    enabled: root.enabled

                    onTextChanged: root.text = text
                    onAccepted: root.search(text)
                    onActiveFocusChanged: {
                        if (activeFocus) expanded = true
                    }

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }

                    Text {
                        visible: !searchInput.text
                        anchors.fill: parent
                        text: placeholderText
                        font: searchInput.font
                        color: colors.onSurfaceVariant
                        verticalAlignment: Text.AlignVCenter

                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }
                }

                // Clear button
                Item {
                    visible: showClearButton && hasText
                    Layout.preferredWidth: 24
                    Layout.preferredHeight: 24
                    Layout.alignment: Qt.AlignVCenter

                    Rectangle {
                        anchors.fill: parent
                        radius: 12
                        color: colors.onSurface
                        opacity: clearMouse.containsMouse ? 0.08 : 0
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        font.pixelSize: 18
                        color: colors.onSurfaceVariant
                    }

                    MouseArea {
                        id: clearMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            searchInput.clear()
                            root.cleared()
                        }
                    }
                }

                // Trailing icon
                Item {
                    visible: !hasText
                    Layout.preferredWidth: 24
                    Layout.preferredHeight: 24
                    Layout.alignment: Qt.AlignVCenter

                    Text {
                        anchors.centerIn: parent
                        text: "🎤"
                        font.pixelSize: 20
                        color: colors.onSurfaceVariant
                    }
                }
            }

            // Divider
            Rectangle {
                visible: showSuggestions
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: colors.outlineVariant
            }

            // Suggestions
            Item {
                id: suggestionsContainer
                visible: showSuggestions
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(suggestionsColumn.implicitHeight, 300)

                Flickable {
                    anchors.fill: parent
                    contentHeight: suggestionsColumn.implicitHeight
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds

                    Column {
                        id: suggestionsColumn
                        width: parent.width

                        Repeater {
                            id: suggestionsRepeater

                            delegate: Item {
                                width: parent.width
                                height: 48

                                Rectangle {
                                    anchors.fill: parent
                                    color: colors.onSurface
                                    opacity: suggestionMouse.containsMouse ? 0.08 : 0
                                }

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 16
                                    anchors.rightMargin: 16
                                    spacing: 16

                                    Text {
                                        text: "🕐"
                                        font.pixelSize: 20
                                        color: colors.onSurfaceVariant
                                        Layout.alignment: Qt.AlignVCenter
                                    }

                                    Text {
                                        text: modelData.text || modelData
                                        font.family: "Roboto"
                                        font.pixelSize: 16
                                        color: colors.onSurface
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                        Layout.alignment: Qt.AlignVCenter
                                    }

                                    Text {
                                        text: "↗"
                                        font.pixelSize: 20
                                        color: colors.onSurfaceVariant
                                        Layout.alignment: Qt.AlignVCenter
                                    }
                                }

                                MouseArea {
                                    id: suggestionMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        root.text = modelData.text || modelData
                                        root.suggestionClicked(index, modelData)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Click outside to collapse
    MouseArea {
        parent: root.parent
        anchors.fill: parent
        visible: expanded
        z: -1
        onClicked: expanded = false
    }

    function focus() {
        searchInput.forceActiveFocus()
    }

    function clear() {
        searchInput.clear()
        cleared()
    }

    Accessible.role: Accessible.EditableText
    Accessible.name: placeholderText
}
