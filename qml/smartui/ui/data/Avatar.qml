import QtQuick
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Item {
    id: root

    property string source: ""
    property string text: ""
    property string icon: ""
    property string size: "medium"           // "xsmall", "small", "medium", "large", "xlarge"
    property bool showBadge: false
    property string badgeIcon: ""
    property bool online: false

    readonly property var sizeSpecs: ({
        xsmall: { diameter: 24, fontSize: 10, iconSize: 14, badgeSize: 8 },
        small: { diameter: 32, fontSize: 12, iconSize: 18, badgeSize: 10 },
        medium: { diameter: 40, fontSize: 14, iconSize: 20, badgeSize: 12 },
        large: { diameter: 56, fontSize: 20, iconSize: 28, badgeSize: 14 },
        xlarge: { diameter: 96, fontSize: 36, iconSize: 48, badgeSize: 20 }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.medium
    readonly property bool hasImage: source !== ""
    readonly property bool hasIcon: icon !== ""
    readonly property string displayText: text.length > 0 ? text.substring(0, 2).toUpperCase() : ""

    implicitWidth: currentSize.diameter
    implicitHeight: currentSize.diameter

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        id: avatarContainer
        anchors.fill: parent
        radius: width / 2
        color: colors.primaryContainer

        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        // Text fallback
        Text {
            visible: !hasImage && !hasIcon
            anchors.centerIn: parent
            text: displayText
            font.family: "Roboto"
            font.pixelSize: currentSize.fontSize
            font.weight: Font.Medium
            color: colors.onPrimaryContainer

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }

        // Icon fallback
        Text {
            visible: !hasImage && hasIcon
            anchors.centerIn: parent
            text: icon
            font.family: "Material Icons"
            font.pixelSize: currentSize.iconSize
            color: colors.onPrimaryContainer

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }

        // Image
        Image {
            id: avatarImage
            visible: hasImage
            anchors.fill: parent
            source: root.source
            fillMode: Image.PreserveAspectCrop
            smooth: true

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: avatarContainer.width
                    height: avatarContainer.height
                    radius: avatarContainer.radius
                }
            }
        }
    }

    // Badge
    Rectangle {
        visible: showBadge || online
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: size === "xsmall" ? -2 : 0
        anchors.bottomMargin: size === "xsmall" ? -2 : 0
        width: currentSize.badgeSize
        height: currentSize.badgeSize
        radius: width / 2
        color: online ? "#4CAF50" : colors.error
        border.width: 2
        border.color: colors.surface

        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        Text {
            visible: badgeIcon !== ""
            anchors.centerIn: parent
            text: badgeIcon
            font.pixelSize: currentSize.badgeSize - 4
            color: colors.onError
        }
    }

    Accessible.role: Accessible.Graphic
    Accessible.name: text || "Avatar"
}
