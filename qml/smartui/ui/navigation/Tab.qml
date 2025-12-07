import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme

Item {
    id: root

    property string text: ""
    property string icon: ""
    property bool selected: false
    property bool enabled: true
    property string variant: "primary"       // "primary", "secondary"
    property bool showBadge: false
    property string badgeText: ""

    property int tabIndex: 0

    signal clicked()

    readonly property bool hasIcon: icon !== ""
    readonly property bool isPrimary: variant === "primary"

    implicitWidth: Math.max(isPrimary ? 48 : 48, contentColumn.implicitWidth + 32)
    implicitHeight: parent ? parent.height : 48

    opacity: enabled ? 1.0 : 0.38

    property var colors: Theme.ChiTheme.colors

    // State layer
    Rectangle {
        anchors.fill: parent
        color: colors.primary
        opacity: {
            if (!enabled) return 0
            if (mouseArea.pressed) return 0.12
            if (mouseArea.containsMouse) return 0.08
            return 0
        }

        Behavior on opacity {
            NumberAnimation { duration: 100 }
        }
    }

    Column {
        id: contentColumn
        anchors.centerIn: parent
        spacing: isPrimary && hasIcon ? 2 : 0

        // Icon (for primary with icon)
        Item {
            visible: hasIcon
            width: 24
            height: 24
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                anchors.centerIn: parent
                text: icon
                font.family: "Material Icons"
                font.pixelSize: 24
                color: selected ? colors.primary : colors.onSurfaceVariant

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            // Badge
            Rectangle {
                visible: showBadge
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: -2
                anchors.rightMargin: -4

                width: badgeText === "" ? 6 : Math.max(16, badgeLabelIcon.implicitWidth + 8)
                height: badgeText === "" ? 6 : 16
                radius: height / 2
                color: colors.error

                scale: showBadge ? 1 : 0

                Behavior on scale {
                    NumberAnimation { duration: 150; easing.type: Easing.OutBack }
                }

                Text {
                    id: badgeLabelIcon
                    visible: badgeText !== ""
                    anchors.centerIn: parent
                    text: badgeText
                    font.family: "Roboto"
                    font.pixelSize: 11
                    font.weight: Font.Medium
                    color: colors.onError
                }
            }
        }

        // Label row
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8

            Text {
                text: root.text
                font.family: "Roboto"
                font.pixelSize: 14
                font.weight: Font.Medium
                font.letterSpacing: 0.1
                color: selected ? colors.primary : colors.onSurfaceVariant

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            // Badge (text only, no icon)
            Rectangle {
                visible: showBadge && !hasIcon
                anchors.verticalCenter: parent.verticalCenter

                width: badgeText === "" ? 6 : Math.max(16, badgeLabelText.implicitWidth + 8)
                height: badgeText === "" ? 6 : 16
                radius: height / 2
                color: colors.error

                scale: showBadge ? 1 : 0

                Behavior on scale {
                    NumberAnimation { duration: 150; easing.type: Easing.OutBack }
                }

                Text {
                    id: badgeLabelText
                    visible: badgeText !== ""
                    anchors.centerIn: parent
                    text: badgeText
                    font.family: "Roboto"
                    font.pixelSize: 11
                    font.weight: Font.Medium
                    color: colors.onError
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        onClicked: root.clicked()
    }

    Accessible.role: Accessible.PageTab
    Accessible.name: text
    Accessible.selected: selected
}
