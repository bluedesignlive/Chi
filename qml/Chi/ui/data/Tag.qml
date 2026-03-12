import QtQuick
import "../theme" as Theme

Item {
    id: root

    property string text: ""
    property string icon: ""
    property color backgroundColor: colors.secondaryContainer
    property color textColor: colors.onSecondaryContainer
    property string size: "medium"           // "small", "medium", "large"
    property bool removable: false
    property bool enabled: true

    signal clicked()
    signal removed()

    readonly property var sizeSpecs: ({
        small: { height: 20, fontSize: 11, iconSize: 12, padding: 6 },
        medium: { height: 24, fontSize: 12, iconSize: 14, padding: 8 },
        large: { height: 32, fontSize: 14, iconSize: 18, padding: 12 }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.medium

    implicitWidth: tagContent.implicitWidth + currentSize.padding * 2
    implicitHeight: currentSize.height

    opacity: enabled ? 1.0 : 0.6

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: backgroundColor

        Behavior on color {
            ColorAnimation { duration: 150 }
        }

        Row {
            id: tagContent
            anchors.centerIn: parent
            spacing: 4

            Text {
                visible: icon !== ""
                text: icon
                font.pixelSize: currentSize.iconSize
                color: textColor
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: root.text
                font.family: "Roboto"
                font.pixelSize: currentSize.fontSize
                font.weight: Font.Medium
                color: textColor
                anchors.verticalCenter: parent.verticalCenter

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            // Remove button
            Item {
                visible: removable
                width: currentSize.iconSize
                height: currentSize.iconSize
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    anchors.centerIn: parent
                    text: "✕"
                    font.pixelSize: currentSize.iconSize - 4
                    color: textColor
                    opacity: removeMouse.containsMouse ? 1 : 0.7
                }

                MouseArea {
                    id: removeMouse
                    anchors.fill: parent
                    anchors.margins: -4
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: removed()
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            enabled: root.enabled && !removable

            onClicked: root.clicked()
        }
    }

    Accessible.role: Accessible.StaticText
    Accessible.name: text
}
