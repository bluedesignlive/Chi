import QtQuick
import QtQuick.Effects
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
        small:  { diameter: 32, fontSize: 12, iconSize: 18, badgeSize: 10 },
        medium: { diameter: 40, fontSize: 14, iconSize: 20, badgeSize: 12 },
        large:  { diameter: 56, fontSize: 20, iconSize: 28, badgeSize: 14 },
        xlarge: { diameter: 96, fontSize: 36, iconSize: 48, badgeSize: 20 }
    })

    readonly property var cs: sizeSpecs[size] || sizeSpecs.medium
    readonly property bool _hasImage: source !== ""
    readonly property bool _hasIcon: icon !== ""
    readonly property string _initials: text.length > 0 ? text.substring(0, 2).toUpperCase() : ""
    readonly property bool _isXSmall: size === "xsmall"

    implicitWidth: cs.diameter
    implicitHeight: cs.diameter

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        id: avatarContainer
        anchors.fill: parent
        radius: width * 0.5
        color: colors.primaryContainer
        Behavior on color { ColorAnimation { duration: 200 } }

        // Text fallback
        Text {
            visible: !root._hasImage && !root._hasIcon
            anchors.centerIn: parent
            text: root._initials
            font.family: Theme.ChiTheme.fontFamily
            font.pixelSize: cs.fontSize
            font.weight: Font.Medium
            color: colors.onPrimaryContainer
            Behavior on color { ColorAnimation { duration: 200 } }
        }

        // Icon fallback
        Text {
            visible: !root._hasImage && root._hasIcon
            anchors.centerIn: parent
            text: root.icon
            font.family: Theme.ChiTheme.iconFamily
            font.pixelSize: cs.iconSize
            color: colors.onPrimaryContainer
            Behavior on color { ColorAnimation { duration: 200 } }
        }

        // Image — circular clip via MultiEffect maskSource
        Image {
            id: avatarImage
            visible: root._hasImage
            anchors.fill: parent
            source: root._hasImage ? root.source : ""
            fillMode: Image.PreserveAspectCrop
            smooth: true
            asynchronous: true

            layer.enabled: visible && status === Image.Ready
            layer.effect: MultiEffect {
                maskEnabled: true
                maskSource: Rectangle {
                    width: avatarContainer.width
                    height: avatarContainer.height
                    radius: avatarContainer.radius
                    visible: false  // mask source must be invisible
                }
            }
        }
    }

    // Badge
    Rectangle {
        visible: root.showBadge || root.online
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: root._isXSmall ? -2 : 0
        anchors.bottomMargin: root._isXSmall ? -2 : 0
        width: cs.badgeSize
        height: cs.badgeSize
        radius: cs.badgeSize * 0.5
        color: root.online ? "#4CAF50" : colors.error
        border.width: 2
        border.color: colors.surface
        Behavior on color { ColorAnimation { duration: 200 } }

        Text {
            visible: root.badgeIcon !== ""
            anchors.centerIn: parent
            text: root.badgeIcon
            font.pixelSize: cs.badgeSize - 4
            color: colors.onError
        }
    }

    Accessible.role: Accessible.Graphic
    Accessible.name: text || "Avatar"
}
