import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme

Row {
    id: root

    property var keys: []                    // ["Ctrl", "Shift", "P"]
    property string separator: "+"
    property string size: "medium"           // "small", "medium", "large"

    readonly property var sizeSpecs: ({
        small: { height: 20, fontSize: 11, padding: 4, radius: 3 },
        medium: { height: 24, fontSize: 12, padding: 6, radius: 4 },
        large: { height: 28, fontSize: 14, padding: 8, radius: 5 }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.medium

    spacing: 4

    property var colors: Theme.ChiTheme.colors

    Repeater {
        model: keys

        Row {
            spacing: 4

            Rectangle {
                width: keyLabel.implicitWidth + currentSize.padding * 2
                height: currentSize.height
                radius: currentSize.radius
                color: colors.surfaceContainerHighest
                border.width: 1
                border.color: colors.outlineVariant

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }

                Text {
                    id: keyLabel
                    anchors.centerIn: parent
                    text: modelData
                    font.family: "Roboto"
                    font.pixelSize: currentSize.fontSize
                    font.weight: Font.Medium
                    color: colors.onSurface

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }
            }

            Text {
                visible: index < keys.length - 1
                text: separator
                font.family: "Roboto"
                font.pixelSize: currentSize.fontSize
                color: colors.onSurfaceVariant
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
