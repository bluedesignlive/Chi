import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme

Item {
    id: root

    property string icon: ""
    property string text: ""
    property string size: "medium"           // "small", "medium", "large"
    property string layout: "horizontal"     // "horizontal", "vertical"
    property string iconPosition: "leading"  // "leading", "trailing"
    property int spacing: 8
    property color iconColor: colors.onSurfaceVariant
    property color textColor: colors.onSurface
    property int fontWeight: Font.Normal

    readonly property var sizeSpecs: ({
        small: { iconSize: 16, fontSize: 12 },
        medium: { iconSize: 20, fontSize: 14 },
        large: { iconSize: 24, fontSize: 16 }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.medium

    implicitWidth: layout === "horizontal" ? contentRow.implicitWidth : contentColumn.implicitWidth
    implicitHeight: layout === "horizontal" ? contentRow.implicitHeight : contentColumn.implicitHeight

    property var colors: Theme.ChiTheme.colors

    // Horizontal layout
    Row {
        id: contentRow
        visible: layout === "horizontal"
        spacing: root.spacing
        layoutDirection: iconPosition === "trailing" ? Qt.RightToLeft : Qt.LeftToRight

        Text {
            visible: icon !== ""
            text: icon
            font.pixelSize: currentSize.iconSize
            color: iconColor
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }

        Text {
            visible: text !== ""
            text: root.text
            font.family: "Roboto"
            font.pixelSize: currentSize.fontSize
            font.weight: fontWeight
            color: textColor
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }
    }

    // Vertical layout
    Column {
        id: contentColumn
        visible: layout === "vertical"
        spacing: root.spacing / 2

        Text {
            visible: icon !== "" && iconPosition === "leading"
            text: icon
            font.pixelSize: currentSize.iconSize
            color: iconColor
            anchors.horizontalCenter: parent.horizontalCenter

            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }

        Text {
            visible: text !== ""
            text: root.text
            font.family: "Roboto"
            font.pixelSize: currentSize.fontSize
            font.weight: fontWeight
            color: textColor
            anchors.horizontalCenter: parent.horizontalCenter

            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }

        Text {
            visible: icon !== "" && iconPosition === "trailing"
            text: icon
            font.pixelSize: currentSize.iconSize
            color: iconColor
            anchors.horizontalCenter: parent.horizontalCenter

            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }
    }
}
