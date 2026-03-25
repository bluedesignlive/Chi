// qml/smartui/ui/selection/Checkbox.qml
import QtQuick
import "../../theme" as Theme

Item {
    id: root

    property bool checked: false
    property bool indeterminate: false
    property string label: ""
    property bool enabled: true
    property string size: "medium"           // "small", "medium", "large"

    signal toggled()

    readonly property var sizeSpecs: ({
        small: { boxSize: 16, iconSize: 14, fontSize: 13, gap: 8 },
        medium: { boxSize: 20, iconSize: 18, fontSize: 14, gap: 12 },
        large: { boxSize: 24, iconSize: 22, fontSize: 16, gap: 16 }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.medium
    readonly property bool hasLabel: label !== ""

    implicitWidth: currentSize.boxSize + (hasLabel ? currentSize.gap + labelText.implicitWidth : 0)
    implicitHeight: Math.max(currentSize.boxSize + 16, hasLabel ? labelText.implicitHeight : 0)

    opacity: enabled ? 1.0 : 0.38

    Behavior on opacity {
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
    }

    property var colors: Theme.ChiTheme.colors
    readonly property string fontFamily: Theme.ChiTheme.fontFamily

    Row {
        anchors.verticalCenter: parent.verticalCenter
        spacing: currentSize.gap

        // Checkbox container (with touch target)
        Item {
            width: currentSize.boxSize + 16
            height: currentSize.boxSize + 16

            // State layer (ripple background)
            Rectangle {
                anchors.centerIn: parent
                width: 40
                height: 40
                radius: 20
                color: {
                    if (checked || indeterminate) return colors.primary
                    return colors.onSurface
                }
                opacity: {
                    if (!enabled) return 0
                    if (mouseArea.pressed) return 0.12
                    if (mouseArea.containsMouse) return 0.08
                    if (root.activeFocus) return 0.12
                    return 0
                }

                Behavior on opacity {
                    NumberAnimation { duration: 100 }
                }
                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            // Checkbox box
            Rectangle {
                id: box
                anchors.centerIn: parent
                width: currentSize.boxSize
                height: currentSize.boxSize
                radius: 2

                color: {
                    if (!enabled) {
                        return (checked || indeterminate) ? colors.onSurface : "transparent"
                    }
                    return (checked || indeterminate) ? colors.primary : "transparent"
                }

                border.width: (checked || indeterminate) ? 0 : 2
                border.color: {
                    if (!enabled) return colors.onSurface
                    if (root.activeFocus) return colors.primary
                    return colors.onSurfaceVariant
                }

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
                Behavior on border.color {
                    ColorAnimation { duration: 150 }
                }
                Behavior on border.width {
                    NumberAnimation { duration: 100 }
                }

                // Check mark
                Text {
                    anchors.centerIn: parent
                    text: indeterminate ? "─" : "✓"
                    font.family: fontFamily
                    font.pixelSize: currentSize.iconSize
                    font.weight: Font.Bold
                    color: colors.onPrimary
                    visible: checked || indeterminate
                    opacity: (checked || indeterminate) ? 1 : 0

                    Behavior on opacity {
                        NumberAnimation { duration: 100 }
                    }
                }

                // Scale animation on toggle
                scale: mouseArea.pressed ? 0.9 : 1.0

                Behavior on scale {
                    NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                enabled: root.enabled
                hoverEnabled: true
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

                onClicked: {
                    if (indeterminate) {
                        indeterminate = false
                        checked = true
                    } else {
                        checked = !checked
                    }
                    root.toggled()
                }
            }
        }

        // Label
        Text {
            id: labelText
            visible: hasLabel
            text: label
            font.family: fontFamily
            font.pixelSize: currentSize.fontSize
            color: enabled ? colors.onSurface : colors.onSurface
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color {
                ColorAnimation { duration: 150 }
            }

            MouseArea {
                anchors.fill: parent
                enabled: root.enabled
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: {
                    if (indeterminate) {
                        indeterminate = false
                        checked = true
                    } else {
                        checked = !checked
                    }
                    root.toggled()
                }
            }
        }
    }

    Keys.onSpacePressed: if (enabled) { checked = !checked; toggled() }
    Keys.onReturnPressed: if (enabled) { checked = !checked; toggled() }

    Accessible.role: Accessible.CheckBox
    Accessible.name: label
    Accessible.checked: checked
    Accessible.checkable: true
}
