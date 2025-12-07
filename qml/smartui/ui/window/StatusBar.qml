import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme

Rectangle {
    id: root

    property string status: ""
    property bool showProgress: false
    property real progress: 0
    property bool indeterminate: false

    default property alias items: itemsRow.data

    implicitWidth: parent ? parent.width : 600
    implicitHeight: 24

    property var colors: Theme.ChiTheme.colors

    color: colors.surfaceContainerLow

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    // Top border
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 1
        color: colors.outlineVariant
        opacity: 0.5
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 16

        // Status text
        Text {
            visible: status !== ""
            text: status
            font.family: "Roboto"
            font.pixelSize: 12
            color: colors.onSurfaceVariant
            elide: Text.ElideRight
            Layout.fillWidth: itemsRow.children.length === 0

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }

        // Progress indicator
        Item {
            visible: showProgress
            Layout.preferredWidth: 100
            Layout.preferredHeight: 4
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                anchors.fill: parent
                radius: 2
                color: colors.surfaceContainerHighest
            }

            Rectangle {
                visible: !indeterminate
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * progress
                radius: 2
                color: colors.primary

                Behavior on width {
                    NumberAnimation { duration: 100 }
                }
            }

            Rectangle {
                id: indeterminateBar
                visible: indeterminate
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * 0.3
                radius: 2
                color: colors.primary

                SequentialAnimation on x {
                    running: indeterminate
                    loops: Animation.Infinite

                    NumberAnimation {
                        from: -indeterminateBar.width
                        to: indeterminateBar.parent.width
                        duration: 1000
                        easing.type: Easing.InOutCubic
                    }
                }
            }
        }

        // Custom items
        RowLayout {
            id: itemsRow
            Layout.fillWidth: true
            spacing: 16
        }
    }

    Accessible.role: Accessible.StatusBar
    Accessible.name: status
}
