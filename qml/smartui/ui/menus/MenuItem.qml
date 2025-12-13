import QtQuick
import QtQuick.Layouts
import "../common" as Common
import "../../theme" as Theme

Item {
    id: root

    property string text: ""
    property string leadingIcon: ""
    property string trailingIcon: ""
    property string trailingText: ""
    property string supportingText: ""
    property bool enabled: true
    property bool selected: false
    property bool destructive: false
    property bool showDivider: false
    property bool closeOnClick: true
    property real iconSize: 24

    property string menuColorStyle: "standard"
    property string menuVariant: "expressive"

    signal clicked()

    readonly property bool hasLeadingIcon: leadingIcon !== ""
    readonly property bool hasTrailingIcon: trailingIcon !== ""
    readonly property bool hasTrailingText: trailingText !== ""
    readonly property bool hasSupportingText: supportingText !== ""

    implicitWidth: parent ? parent.width : 200
    implicitHeight: (hasSupportingText ? 64 : 48) + (showDivider ? 9 : 0)

    opacity: enabled ? 1.0 : 0.38

    property var colors: Theme.ChiTheme.colors

    readonly property bool isVibrant: menuColorStyle === "vibrant"

    readonly property color textColor: {
        if (destructive) return colors.error
        if (selected) return isVibrant ? colors.onTertiary : colors.onTertiaryContainer
        return isVibrant ? colors.onTertiaryContainer : colors.onSurface
    }

    readonly property color iconColor: {
        if (destructive) return colors.error
        if (selected) return isVibrant ? colors.onTertiary : colors.onTertiaryContainer
        return isVibrant ? colors.onTertiaryContainer : colors.onSurfaceVariant
    }

    readonly property color selectedBgColor: isVibrant ? colors.tertiary : colors.tertiaryContainer
    readonly property color stateLayerColor: isVibrant ? colors.onTertiaryContainer : colors.onSurface
    readonly property real itemRadius: menuVariant === "expressive" ? 12 : 0

    Column {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            width: parent.width
            height: root.implicitHeight - (showDivider ? 9 : 0)
            radius: itemRadius

            color: {
                if (selected) return selectedBgColor
                if (mouseArea.containsMouse && enabled) return Qt.alpha(stateLayerColor, 0.08)
                return "transparent"
            }

            Behavior on color { ColorAnimation { duration: 150 } }

            Rectangle {
                anchors.fill: parent
                radius: itemRadius
                color: destructive ? colors.error : stateLayerColor
                opacity: mouseArea.pressed && enabled ? 0.12 : 0
                Behavior on opacity { NumberAnimation { duration: 100 } }
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 12

                Common.Icon {
                    visible: hasLeadingIcon
                    source: leadingIcon
                    size: iconSize
                    color: iconColor
                    Layout.alignment: Qt.AlignVCenter
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 2

                    Text {
                        text: root.text
                        font.family: "Roboto"
                        font.pixelSize: 14
                        font.weight: selected ? Font.Medium : Font.Normal
                        color: textColor
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }

                    Text {
                        visible: hasSupportingText
                        text: supportingText
                        font.family: "Roboto"
                        font.pixelSize: 12
                        color: isVibrant ? colors.onTertiaryContainer : colors.onSurfaceVariant
                        opacity: 0.8
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                }

                Text {
                    visible: hasTrailingText
                    text: trailingText
                    font.family: "Roboto"
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    color: isVibrant ? colors.onTertiaryContainer : colors.onSurfaceVariant
                    opacity: 0.7
                    Layout.alignment: Qt.AlignVCenter
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                Common.Icon {
                    visible: hasTrailingIcon
                    source: trailingIcon
                    size: iconSize
                    color: iconColor
                    Layout.alignment: Qt.AlignVCenter
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
        }

        Item {
            visible: showDivider
            width: parent.width
            height: 9

            Rectangle {
                anchors.centerIn: parent
                width: parent.width - 24
                height: 1
                color: colors.outlineVariant
            }
        }
    }

    Accessible.role: Accessible.MenuItem
    Accessible.name: text
}
