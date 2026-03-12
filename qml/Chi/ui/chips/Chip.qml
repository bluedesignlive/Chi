import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../theme" as Theme

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

    readonly property var sizeSpecs: ({
        small: { height: 28, fontSize: 12, iconSize: 16, padding: 8, gap: 6 },
        medium: { height: 32, fontSize: 14, iconSize: 18, padding: 12, gap: 8 },
        large: { height: 40, fontSize: 16, iconSize: 20, padding: 16, gap: 10 }
    })
    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.medium

    implicitWidth: contentRow.implicitWidth + currentSize.padding * 2
    implicitHeight: currentSize.height
    opacity: enabled ? 1.0 : 0.38
    property var colors: Theme.ChiTheme.colors

    Rectangle {
        id: container
        anchors.fill: parent
        radius: 8
        color: {
            if (variant === "filter" && selected) return colors.secondaryContainer
            if (elevated) return colors.surfaceContainerLow
            return "transparent"
        }
        border.width: (elevated || (variant === "filter" && selected)) ? 0 : 1
        border.color: selected ? "transparent" : colors.outline
        
        Behavior on color { ColorAnimation { duration: 150 } }

        Rectangle {
            anchors.fill: parent; radius: parent.radius
            color: colors.onSurface
            opacity: mouseArea.pressed ? 0.12 : (mouseArea.containsMouse ? 0.08 : 0)
            Behavior on opacity { NumberAnimation { duration: 100 } }
        }

        RowLayout {
            id: contentRow; anchors.centerIn: parent; spacing: currentSize.gap
            
            Text {
                visible: hasLeadingIcon || (variant === "filter" && selected)
                text: (variant === "filter" && selected && !hasLeadingIcon) ? "✓" : leadingIcon
                font.family: "Material Icons"
                font.pixelSize: currentSize.iconSize
                color: (variant === "filter" && selected) ? colors.onSecondaryContainer : colors.primary
            }

            Text {
                text: root.text
                font.family: "Roboto"; font.pixelSize: currentSize.fontSize
                font.weight: Font.Medium
                color: (variant === "filter" && selected) ? colors.onSecondaryContainer : colors.onSurface
            }

            Text {
                visible: hasTrailingIcon
                text: trailingIcon
                font.family: "Material Icons"
                font.pixelSize: currentSize.iconSize
                color: colors.onSurfaceVariant
                
                MouseArea {
                    anchors.fill: parent; anchors.margins: -4
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.trailingIconClicked()
                }
            }
        }
    }

    MouseArea {
        id: mouseArea; anchors.fill: parent; enabled: root.enabled; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (variant === "filter") selected = !selected
            root.clicked()
        }
    }
}
