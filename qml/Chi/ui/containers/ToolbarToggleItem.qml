import QtQuick
import QtQuick.Effects
import "../../theme" as Theme

Item {
    id: root

    property string icon: ""
    property string selectedIcon: ""
    property string label: ""
    property bool selected: false
    property bool enabled: true
    property string toolbarType: "standard"  // Set by parent Toolbar

    signal toggled()

    readonly property bool hasLabel: label !== ""
    readonly property bool isVibrant: toolbarType === "vibrant"
    readonly property string displayIcon: selected && selectedIcon !== "" ? selectedIcon : icon

    // Cached content color — shared by icon and label
    readonly property color _contentColor: !enabled ? colors.onSurface :
        (selected ? colors.onSecondaryContainer :
        (isVibrant ? colors.onPrimaryContainer : colors.onSurfaceVariant))

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

        color: {
            if (root.selected) return colors.secondaryContainer
            if (!root.enabled)
                return Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.1)
            return root.hasLabel ? colors.surfaceContainer : "transparent"
        }

        Behavior on color { ColorAnimation { duration: 150 } }
        Behavior on radius { NumberAnimation { duration: 100 } }

        // State layer
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: root.selected ? colors.onSecondaryContainer :
                   (root.isVibrant ? colors.onPrimaryContainer : colors.onSurfaceVariant)
            opacity: !root.enabled ? 0 :
                     (mouseArea.pressed ? 0.1 :
                     (mouseArea.containsMouse ? 0.08 :
                     (root.activeFocus ? 0.1 : 0)))
            Behavior on opacity { NumberAnimation { duration: 100 } }
        }

        // Elevation on hover
        layer.enabled: mouseArea.containsMouse && root.enabled
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
                visible: root.displayIcon !== ""
                text: root.displayIcon
                font.family: root.displayIcon.length > 2 ? Theme.ChiTheme.iconFamily : undefined
                font.pixelSize: root.hasLabel ? 20 : 24
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
            onClicked: { root.selected = !root.selected; root.toggled() }
        }
    }

    Accessible.role: Accessible.CheckBox
    Accessible.name: label || icon
    Accessible.checked: selected
}
