// SegmentedButton.qml - Material 3 Segmented Button
// Uses shared components (Icon, StateLayer, SizeSpecs)

import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme
import "../common" as Common

Item {
    id: root

    // ─── Public API ───────────────────────────────────────────
    property int selectedIndex: 0
    property var segments: []                // [{text: "", icon: ""}]
    property bool multiSelect: false
    property var selectedIndices: [0]
    property bool enabled: true
    property string size: "medium"           // small | medium | large

    signal selectionChanged(var indices)

    // ─── Theme Tokens ───────────────────────────────────────────
    readonly property var colors: Theme.ChiTheme.colors
    readonly property var motion: Theme.ChiTheme.motion
    readonly property var typography: Theme.ChiTheme.typography
    readonly property string fontFamily: Theme.ChiTheme.fontFamily
    readonly property var spec: Theme.SizeSpecs.getSpec(Theme.SizeSpecs.segmentedButton, size)

    // ─── Geometry ───────────────────────────────────────────────
    implicitWidth: segmentsRow.implicitWidth
    implicitHeight: spec.height

    opacity: enabled ? 1.0 : 0.38

    // ─── Visual Container ───────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: "transparent"
        border.width: 1
        border.color: colors.outline

        Behavior on border.color {
            ColorAnimation { duration: motion.durationMedium }
        }

        Row {
            id: segmentsRow
            anchors.fill: parent

            Repeater {
                model: segments

                Item {
                    width: segmentContent.implicitWidth + spec.padding * 2
                    height: parent.height

                    property bool isSelected: multiSelect ?
                        selectedIndices.indexOf(index) !== -1 :
                        selectedIndex === index
                    property bool isFirst: index === 0
                    property bool isLast: index === segments.length - 1

                    // Background
                    Rectangle {
                        anchors.fill: parent
                        color: isSelected ? colors.secondaryContainer : "transparent"
                        radius: parent.height / 2

                        // Mask for non-rounded edges
                        Rectangle {
                            visible: !isFirst
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: parent.radius
                            color: parent.color
                        }

                        Rectangle {
                            visible: !isLast
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: parent.radius
                            color: parent.color
                        }

                        Behavior on color {
                            ColorAnimation { duration: motion.durationFast }
                        }
                    }

                    // Divider
                    Rectangle {
                        visible: !isFirst
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.margins: 8
                        width: 1
                        color: colors.outline
                        opacity: isSelected || (index > 0 && (multiSelect ?
                            selectedIndices.indexOf(index - 1) !== -1 :
                            selectedIndex === index - 1)) ? 0 : 1

                        Behavior on opacity {
                            NumberAnimation { duration: motion.durationFast }
                        }
                    }

                    // State layer
                    Rectangle {
                        anchors.fill: parent
                        radius: parent.height / 2
                        color: isSelected ? colors.onSecondaryContainer : colors.onSurface
                        opacity: segmentMouse.containsMouse && enabled ? 0.08 : 0

                        Rectangle {
                            visible: !isFirst
                            anchors.left: parent.left
                            width: parent.radius
                            height: parent.height
                            color: parent.color
                        }

                        Rectangle {
                            visible: !isLast
                            anchors.right: parent.right
                            width: parent.radius
                            height: parent.height
                            color: parent.color
                        }

                        Behavior on opacity {
                            NumberAnimation { duration: motion.durationFast }
                        }
                    }

                    // Content
                    Row {
                        id: segmentContent
                        anchors.centerIn: parent
                        spacing: 8

                        // Checkmark for selected
                        Common.Icon {
                            visible: isSelected
                            source: "check"
                            size: spec.iconSize
                            color: colors.onSecondaryContainer
                            anchors.verticalCenter: parent.verticalCenter

                            Behavior on color {
                                ColorAnimation { duration: motion.durationFast }
                            }
                        }

                        // Icon - using shared Icon component
                        Common.Icon {
                            visible: modelData.icon && modelData.icon !== ""
                            source: modelData.icon || ""
                            size: spec.iconSize
                            color: isSelected ? colors.onSecondaryContainer : colors.onSurface
                            anchors.verticalCenter: parent.verticalCenter

                            Behavior on color {
                                ColorAnimation { duration: motion.durationFast }
                            }
                        }

                        // Label
                        Text {
                            visible: modelData.text && modelData.text !== ""
                            text: modelData.text || ""
                            font.family: fontFamily
                            font.pixelSize: spec.fontSize
                            font.weight: Font.Medium
                            color: isSelected ? colors.onSecondaryContainer : colors.onSurface
                            anchors.verticalCenter: parent.verticalCenter

                            Behavior on color {
                                ColorAnimation { duration: motion.durationFast }
                            }
                        }
                    }

                    // Input
                    MouseArea {
                        id: segmentMouse
                        anchors.fill: parent
                        enabled: root.enabled
                        hoverEnabled: true
                        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

                        onClicked: {
                            if (multiSelect) {
                                var indices = selectedIndices.slice()
                                var idx = indices.indexOf(index)
                                if (idx !== -1) {
                                    if (indices.length > 1) {
                                        indices.splice(idx, 1)
                                    }
                                } else {
                                    indices.push(index)
                                }
                                indices.sort()
                                selectedIndices = indices
                            } else {
                                selectedIndex = index
                                selectedIndices = [index]
                            }
                            selectionChanged(selectedIndices)
                        }
                    }
                }
            }
        }
    }

    Accessible.role: Accessible.ButtonGroup
    Accessible.name: "Segmented button"
}
