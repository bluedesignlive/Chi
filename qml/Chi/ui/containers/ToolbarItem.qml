import QtQuick
import QtQuick.Effects
import "../../theme" as Theme

Item {
    id: root

    property string icon: ""
    property string label: ""
    property bool selected: false
    property bool enabled: true
    property string toolbarType: "standard"  // Set by parent Toolbar

    signal clicked()

    readonly property bool hasLabel: label !== ""
    readonly property bool isVibrant: toolbarType === "vibrant"

    // Cached content color — shared by icon and label
    readonly property color _contentColor: selected ? colors.onSecondaryContainer :
        (isVibrant ? colors.onPrimaryContainer : colors.onSurfaceVariant)

    implicitWidth: hasLabel ? contentRow.implicitWidth + 32 : 48
    implicitHeight: 48

    opacity: enabled ? 1.0 : 0.38

    property var colors: Theme.ChiTheme.colors
    readonly property var _typo: Theme.ChiTheme.typography

    Rectangle {
        id: container
        anchors.centerIn: parent
        width: root.hasLabel ? parent.width : 40
        height: 40
        radius: mouseArea.pressed ? 8 : 100

        color: root.selected ? colors.secondaryContainer : "transparent"

        Behavior on color { ColorAnimation { duration: 150 } }
        Behavior on radius { NumberAnimation { duration: 100 } }

        // State layer
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: root._contentColor
            opacity: !root.enabled ? 0 :
                     (mouseArea.pressed ? 0.1 :
                     (mouseArea.containsMouse ? 0.08 :
                     (root.activeFocus ? 0.1 : 0)))
            Behavior on opacity { NumberAnimation { duration: 100 } }
        }

        // Elevation on hover for labeled buttons
        layer.enabled: root.hasLabel && mouseArea.containsMouse && !root.selected
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.2)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 1
            shadowBlur: 0.15
        }

        Row {
            id: contentRow
            anchors.centerIn: parent
            spacing: 8

            // Icon
            Text {
                visible: root.icon !== ""
                text: root.icon
                font.family: root.icon.length > 2 ? Theme.ChiTheme.iconFamily : undefined
                font.pixelSize: 24
                color: root._contentColor
                anchors.verticalCenter: parent.verticalCenter
                Behavior on color { ColorAnimation { duration: 150 } }
            }

            // Label
            Text {
                visible: root.hasLabel
                text: root.label
                font.family: Theme.ChiTheme.fontFamily
                font.pixelSize: _typo.labelLarge.size
                font.weight: Font.Medium
                font.letterSpacing: _typo.labelLarge.spacing
                color: root._contentColor
                anchors.verticalCenter: parent.verticalCenter
                Behavior on color { ColorAnimation { duration: 150 } }
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

    Accessible.role: Accessible.Button
    Accessible.name: label || icon
}
