import QtQuick
import "../../theme" as Theme
import "../common"

Item {
    id: root

    property string path: ""
    property bool searching: false
    property string placeholder: "Search files..."
    readonly property alias currentText: input.text

    signal pathAccepted(string path)
    signal searchToggled(bool active)

    implicitHeight: 36
    implicitWidth: 200

    property var colors: Theme.ChiTheme.colors
    readonly property var _t: Theme.ChiTheme.typography

    onSearchingChanged: {
        if (searching) {
            input.text = ""
            input.forceActiveFocus()
        } else {
            input.text = root.path
        }
    }

    onPathChanged: {
        if (!searching) input.text = path
    }

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: colors.surfaceContainerHighest
        border.width: root.searching ? 1.5 : 0
        border.color: colors.primary
        Behavior on border.width { NumberAnimation { duration: 150 } }

        Icon {
            id: leadingIcon
            anchors.left: parent.left
            anchors.leftMargin: 14
            anchors.verticalCenter: parent.verticalCenter
            source: root.searching ? "search" : "folder"
            size: 20
            color: root.searching ? colors.primary : colors.onSurfaceVariant
        }

        TextInput {
            id: input
            anchors.left: leadingIcon.right
            anchors.leftMargin: 8
            anchors.right: trailingAction.left
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: root.path
            font.family: _t.bodyMedium.family
            font.pixelSize: _t.bodyMedium.size
            color: colors.onSurface
            selectionColor: colors.primaryContainer
            selectedTextColor: colors.onPrimaryContainer
            selectByMouse: true
            clip: true

            onAccepted: {
                if (!root.searching) root.pathAccepted(text)
            }

            Keys.onEscapePressed: {
                if (root.searching) root.searchToggled(false)
            }

            Text {
                visible: !input.text && root.searching
                text: root.placeholder
                font: input.font
                color: colors.onSurfaceVariant
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Rectangle {
            id: trailingAction
            anchors.right: parent.right
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            width: 28; height: 28; radius: 6
            color: "transparent"

            Rectangle {
                anchors.fill: parent; radius: parent.radius
                color: colors.onSurface
                opacity: trailingMouse.pressed ? 0.12 : trailingMouse.containsMouse ? 0.08 : 0
            }

            Icon {
                anchors.centerIn: parent
                source: root.searching ? "close" : "search"
                size: 20
                color: root.searching ? colors.primary : colors.onSurfaceVariant
            }

            MouseArea {
                id: trailingMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (root.searching && input.text.length > 0) {
                        input.text = ""
                        input.forceActiveFocus()
                    } else {
                        root.searchToggled(!root.searching)
                    }
                }
            }
        }
    }
}
