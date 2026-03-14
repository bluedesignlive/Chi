import QtQuick
import QtQuick.Effects
import "../../theme" as Theme

Item {
    id: root

    property string variant: "elevated"
    property bool enabled: true
    property bool clickable: false
    property real contentPadding: 16
    property real cornerRadius: 12

    default property alias content: contentContainer.data

    signal clicked()
    signal pressAndHold()

    implicitWidth: 320
    implicitHeight: contentContainer.implicitHeight + contentPadding * 2

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity {
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
    }

    property var colors: Theme.ChiTheme.colors

    readonly property bool _elevated: variant === "elevated"

    Rectangle {
        id: container
        anchors.fill: parent
        radius: cornerRadius
        color: root._elevated ? colors.surfaceContainerLow :
               variant === "filled" ? colors.surfaceContainerHighest : colors.surface
        border.width: variant === "outlined" ? 1 : 0
        border.color: colors.outlineVariant

        Behavior on color { ColorAnimation { duration: 200 } }
        Behavior on border.color { ColorAnimation { duration: 200 } }

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: colors.onSurface
            opacity: !root.clickable || !root.enabled ? 0 :
                     (mouseArea.pressed ? 0.12 : (mouseArea.containsMouse ? 0.08 : 0))
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }

        Item {
            id: contentContainer
            anchors.fill: parent
            anchors.margins: contentPadding
        }

        layer.enabled: root._elevated && root.enabled
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.2)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: mouseArea.containsMouse && root.clickable ? 2 : 1
            shadowBlur: mouseArea.containsMouse && root.clickable ? 0.4 : 0.2
            Behavior on shadowVerticalOffset { NumberAnimation { duration: 150 } }
            Behavior on shadowBlur { NumberAnimation { duration: 150 } }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.enabled && root.clickable
        hoverEnabled: true
        cursorShape: root.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.clicked()
        onPressAndHold: root.pressAndHold()
    }

    Accessible.role: clickable ? Accessible.Button : Accessible.Pane
    Accessible.name: "Card"
}
