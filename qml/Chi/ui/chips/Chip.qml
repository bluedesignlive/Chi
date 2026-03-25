import QtQuick
import "../../theme" as Theme

Item {
    id: root

    property string text: "Chip"
    property string variant: "assist"
    property string size: "medium"
    property string leadingIcon: ""
    property string trailingIcon: ""
    property bool selected: false
    property bool enabled: true
    property bool elevated: false

    signal clicked()
    signal trailingIconClicked()

    readonly property bool hasLeadingIcon: leadingIcon !== ""
    readonly property bool hasTrailingIcon: trailingIcon !== ""

    readonly property bool _fs: variant === "filter" && selected

    readonly property int _h: size === "small" ? 28 : size === "large" ? 40 : 32
    readonly property int _fontSize: size === "small" ? 12 : size === "large" ? 16 : 14
    readonly property int _iconSize: size === "small" ? 16 : size === "large" ? 20 : 18
    readonly property int _pad: size === "small" ? 8 : size === "large" ? 16 : 12
    readonly property int _gap: size === "small" ? 6 : size === "large" ? 10 : 8

    implicitWidth: contentRow.implicitWidth + _pad * 2
    implicitHeight: _h
    opacity: enabled ? 1.0 : 0.38

    property var colors: Theme.ChiTheme.colors
    readonly property string fontFamily: Theme.ChiTheme.fontFamily
    readonly property string iconFamily: Theme.ChiTheme.iconFamily

    Rectangle {
        id: container
        anchors.fill: parent
        radius: 8
        color: root._fs ? colors.secondaryContainer :
               root.elevated ? colors.surfaceContainerLow : "transparent"
        border.width: (root.elevated || root._fs) ? 0 : 1
        border.color: root.selected ? "transparent" : colors.outline

        Behavior on color { ColorAnimation { duration: 150 } }

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: colors.onSurface
            opacity: mouseArea.pressed ? 0.12 : (mouseArea.containsMouse ? 0.08 : 0)
            Behavior on opacity { NumberAnimation { duration: 100 } }
        }

        Row {
            id: contentRow
            anchors.centerIn: parent
            spacing: root._gap

            Text {
                visible: root.hasLeadingIcon || root._fs
                text: (root._fs && !root.hasLeadingIcon) ? "✓" : root.leadingIcon
                font.family: iconFamily
                font.pixelSize: root._iconSize
                color: root._fs ? colors.onSecondaryContainer : colors.primary
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: root.text
                font.family: fontFamily
                font.pixelSize: root._fontSize
                font.weight: Font.Medium
                color: root._fs ? colors.onSecondaryContainer : colors.onSurface
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                visible: root.hasTrailingIcon
                text: root.trailingIcon
                font.family: iconFamily
                font.pixelSize: root._iconSize
                color: colors.onSurfaceVariant
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -4
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.trailingIconClicked()
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (root.variant === "filter") root.selected = !root.selected
            root.clicked()
        }
    }
}
