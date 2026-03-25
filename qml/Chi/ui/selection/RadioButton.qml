// qml/smartui/ui/selection/RadioButton.qml
import QtQuick
import "../../theme" as Theme

Item {
    id: root

    property bool checked: false
    property string label: ""
    property bool enabled: true
    property string size: "medium"

    signal toggled()

    readonly property var sizeSpecs: ({
        small: { outerSize: 16, innerSize: 8, fontSize: 13, gap: 8 },
        medium: { outerSize: 20, innerSize: 10, fontSize: 14, gap: 12 },
        large: { outerSize: 24, innerSize: 12, fontSize: 16, gap: 16 }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.medium
    readonly property bool hasLabel: label !== ""

    implicitWidth: currentSize.outerSize + (hasLabel ? currentSize.gap + labelText.implicitWidth : 0)
    implicitHeight: Math.max(currentSize.outerSize + 16, hasLabel ? labelText.implicitHeight : 0)

    opacity: enabled ? 1.0 : 0.38

    Behavior on opacity {
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
    }

    property var colors: Theme.ChiTheme.colors
    readonly property string fontFamily: Theme.ChiTheme.fontFamily

    Row {
        anchors.verticalCenter: parent.verticalCenter
        spacing: currentSize.gap

        // Radio container
        Item {
            width: currentSize.outerSize + 16
            height: currentSize.outerSize + 16

            // State layer
            Rectangle {
                anchors.centerIn: parent
                width: 40
                height: 40
                radius: 20
                color: root.checked ? colors.primary : colors.onSurface
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

            // Outer ring
            Rectangle {
                id: outerRing
                anchors.centerIn: parent
                width: currentSize.outerSize
                height: currentSize.outerSize
                radius: width / 2
                color: "transparent"
                border.width: 2
                border.color: {
                    if (!enabled) return colors.onSurface
                    if (root.checked) return colors.primary
                    return colors.onSurfaceVariant
                }

                Behavior on border.color {
                    ColorAnimation { duration: 150 }
                }

                // Inner dot
                Rectangle {
                    anchors.centerIn: parent
                    width: root.checked ? currentSize.innerSize : 0
                    height: width
                    radius: width / 2
                    color: {
                        if (!enabled) return colors.onSurface
                        return colors.primary
                    }

                    Behavior on width {
                        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                    }
                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }

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
                    // Only trigger toggled if not already checked
                    // The group will handle setting checked state
                    if (!root.checked) {
                        root.toggled()
                    }
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
            color: colors.onSurface
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color {
                ColorAnimation { duration: 150 }
            }

            MouseArea {
                anchors.fill: parent
                enabled: root.enabled
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: {
                    if (!root.checked) {
                        root.toggled()
                    }
                }
            }
        }
    }

    Keys.onSpacePressed: if (enabled && !root.checked) { root.toggled() }
    Keys.onReturnPressed: if (enabled && !root.checked) { root.toggled() }

    Accessible.role: Accessible.RadioButton
    Accessible.name: label
    Accessible.checked: checked
}
