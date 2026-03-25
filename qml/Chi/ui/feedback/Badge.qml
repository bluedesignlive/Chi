import QtQuick
import "../../theme" as Theme

Item {
    id: root

    property string text: ""
    property bool showBadge: true
    property string size: "small"            // "small" (dot), "medium", "large"
    property int maxCount: 999

    default property alias content: contentContainer.data

    readonly property bool hasText: text !== ""
    readonly property bool isNumber: !isNaN(parseInt(text))
    readonly property string displayText: {
        if (!hasText) return ""
        if (isNumber) {
            var num = parseInt(text)
            return num > maxCount ? maxCount + "+" : text
        }
        return text
    }

    readonly property var sizeSpecs: ({
        small: { diameter: 6, fontSize: 0, minWidth: 6, height: 6, padding: 0 },
        medium: { diameter: 16, fontSize: 11, minWidth: 16, height: 16, padding: 4 },
        large: { diameter: 20, fontSize: 12, minWidth: 20, height: 20, padding: 6 }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.small
    readonly property bool isDot: size === "small" || !hasText

    implicitWidth: contentContainer.implicitWidth
    implicitHeight: contentContainer.implicitHeight

    property var colors: Theme.ChiTheme.colors
    readonly property string fontFamily: Theme.ChiTheme.fontFamily

    Item {
        id: contentContainer
        anchors.fill: parent
    }

    Rectangle {
        id: badge
        visible: showBadge

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: isDot ? 0 : -currentSize.height / 3
        anchors.rightMargin: isDot ? 0 : -badgeWidth / 3

        property real badgeWidth: isDot ? currentSize.diameter :
            Math.max(currentSize.minWidth, badgeLabel.implicitWidth + currentSize.padding * 2)

        width: badgeWidth
        height: currentSize.height
        radius: height / 2
        color: colors.error

        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        scale: showBadge ? 1 : 0

        Behavior on scale {
            NumberAnimation { duration: 150; easing.type: Easing.OutBack }
        }

        Text {
            id: badgeLabel
            visible: !isDot && hasText
            anchors.centerIn: parent
            text: displayText
            font.family: fontFamily
            font.pixelSize: currentSize.fontSize
            font.weight: Font.Medium
            color: colors.onError

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }
    }
}
