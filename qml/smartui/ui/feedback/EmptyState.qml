import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme

Item {
    id: root

    property string icon: ""
    property string title: ""
    property string description: ""
    property string actionText: ""
    property string size: "medium"           // "small", "medium", "large"

    signal actionClicked()

    readonly property var sizeSpecs: ({
        small: { iconSize: 48, titleSize: 16, descSize: 13, spacing: 12 },
        medium: { iconSize: 64, titleSize: 20, descSize: 14, spacing: 16 },
        large: { iconSize: 96, titleSize: 24, descSize: 16, spacing: 20 }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.medium

    implicitWidth: 300
    implicitHeight: contentColumn.implicitHeight

    property var colors: Theme.ChiTheme.colors

    ColumnLayout {
        id: contentColumn
        anchors.centerIn: parent
        width: Math.min(parent.width - 48, 320)
        spacing: currentSize.spacing

        // Icon
        Text {
            visible: icon !== ""
            text: icon
            font.pixelSize: currentSize.iconSize
            opacity: 0.6
            Layout.alignment: Qt.AlignHCenter
        }

        // Title
        Text {
            visible: title !== ""
            text: title
            font.family: "Roboto"
            font.pixelSize: currentSize.titleSize
            font.weight: Font.Medium
            color: colors.onSurface
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }

        // Description
        Text {
            visible: description !== ""
            text: description
            font.family: "Roboto"
            font.pixelSize: currentSize.descSize
            color: colors.onSurfaceVariant
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }

        // Action button
        Item {
            visible: actionText !== ""
            Layout.preferredWidth: actionLabel.implicitWidth + 32
            Layout.preferredHeight: 40
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 8

            Rectangle {
                anchors.fill: parent
                radius: 20
                color: colors.primary

                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: colors.onPrimary
                    opacity: actionMouse.containsMouse ? 0.12 : 0
                }
            }

            Text {
                id: actionLabel
                anchors.centerIn: parent
                text: actionText
                font.family: "Roboto"
                font.pixelSize: 14
                font.weight: Font.Medium
                color: colors.onPrimary
            }

            MouseArea {
                id: actionMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: actionClicked()
            }
        }
    }

    Accessible.role: Accessible.StaticText
    Accessible.name: title
    Accessible.description: description
}
