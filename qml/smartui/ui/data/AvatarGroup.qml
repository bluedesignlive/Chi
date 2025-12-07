import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme

Item {
    id: root

    property var avatars: []                 // [{source: "", text: ""}]
    property int maxDisplay: 4
    property string size: "medium"
    property real overlap: 0.25

    readonly property int displayCount: Math.min(avatars.length, maxDisplay)
    readonly property int extraCount: avatars.length - maxDisplay
    readonly property var sizeSpecs: ({
        xsmall: 24, small: 32, medium: 40, large: 56, xlarge: 96
    })
    readonly property real avatarSize: sizeSpecs[size] || 40

    implicitWidth: avatarSize + (displayCount - 1) * avatarSize * (1 - overlap) + (extraCount > 0 ? avatarSize * (1 - overlap) : 0)
    implicitHeight: avatarSize

    property var colors: Theme.ChiTheme.colors

    Row {
        anchors.fill: parent
        spacing: -avatarSize * overlap

        Repeater {
            model: displayCount

            Item {
                width: avatarSize
                height: avatarSize
                z: displayCount - index

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: -2
                    radius: width / 2
                    color: colors.surface

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                Avatar {
                    anchors.fill: parent
                    source: avatars[index].source || ""
                    text: avatars[index].text || ""
                    size: root.size
                }
            }
        }

        // Extra count indicator
        Item {
            visible: extraCount > 0
            width: avatarSize
            height: avatarSize
            z: 0

            Rectangle {
                anchors.fill: parent
                anchors.margins: -2
                radius: width / 2
                color: colors.surface
            }

            Rectangle {
                anchors.fill: parent
                radius: width / 2
                color: colors.surfaceContainerHighest

                Text {
                    anchors.centerIn: parent
                    text: "+" + extraCount
                    font.family: "Roboto"
                    font.pixelSize: avatarSize * 0.35
                    font.weight: Font.Medium
                    color: colors.onSurfaceVariant

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }
            }
        }
    }
}
