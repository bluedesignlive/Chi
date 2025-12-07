import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme

Item {
    id: root

    property string icon: ""
    property string activeIcon: ""
    property string label: ""
    property bool selected: false
    property bool showLabel: true
    property bool showBadge: false
    property string badgeText: ""
    property bool enabled: true

    property int navIndex: 0

    signal clicked()

    readonly property string displayIcon: selected && activeIcon !== "" ? activeIcon : icon

    Layout.fillWidth: true
    Layout.fillHeight: true

    opacity: enabled ? 1.0 : 0.38

    property var colors: Theme.ChiTheme.colors

    Column {
        anchors.centerIn: parent
        spacing: 4

        // Icon container with indicator
        Item {
            width: 64
            height: 32
            anchors.horizontalCenter: parent.horizontalCenter

            // Active indicator pill
            Rectangle {
                id: indicator
                anchors.centerIn: parent
                width: selected ? 64 : 0
                height: 32
                radius: 16
                color: colors.secondaryContainer
                opacity: selected ? 1 : 0

                Behavior on width {
                    NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                }
                Behavior on opacity {
                    NumberAnimation { duration: 100 }
                }
                Behavior on color {
                    ColorAnimation { duration: 200 }
                }
            }

            // State layer
            Rectangle {
                anchors.centerIn: parent
                width: 64
                height: 32
                radius: 16
                color: selected ? colors.onSecondaryContainer : colors.onSurface
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

            // Icon
            Text {
                anchors.centerIn: parent
                text: displayIcon
                font.family: "Material Icons"
                font.pixelSize: 24
                color: selected ? colors.onSecondaryContainer : colors.onSurfaceVariant

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            // Badge
            Rectangle {
                visible: showBadge
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: 12
                anchors.topMargin: 2

                width: badgeText === "" ? 6 : Math.max(16, badgeLabel.implicitWidth + 8)
                height: badgeText === "" ? 6 : 16
                radius: height / 2
                color: colors.error

                scale: showBadge ? 1 : 0

                Behavior on scale {
                    NumberAnimation { duration: 150; easing.type: Easing.OutBack }
                }
                Behavior on color {
                    ColorAnimation { duration: 200 }
                }

                Text {
                    id: badgeLabel
                    visible: badgeText !== ""
                    anchors.centerIn: parent
                    text: badgeText
                    font.family: "Roboto"
                    font.pixelSize: 11
                    font.weight: Font.Medium
                    color: colors.onError

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }
            }
        }

        // Label
        Text {
            visible: showLabel
            text: label
            font.family: "Roboto"
            font.pixelSize: 12
            font.weight: selected ? Font.Medium : Font.Normal
            color: selected ? colors.onSurface : colors.onSurfaceVariant
            anchors.horizontalCenter: parent.horizontalCenter

            Behavior on color {
                ColorAnimation { duration: 150 }
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
    Accessible.name: label
    Accessible.selected: selected
}
