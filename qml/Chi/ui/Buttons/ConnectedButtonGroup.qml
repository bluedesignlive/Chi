import QtQuick
import "../../theme" as Theme

Item {
    id: root

    property string size: "small"
    property string shape: "round"      // "round" or "square"
    property string selectionMode: "single" // "single", "multi", "required"
    property bool enabled: true

    property int selectedIndex: -1
    property var selectedIndices: []
    property var items: []

    signal selectionChanged(var indices)
    signal itemClicked(int index)

    // M3 Expressive Specs
    readonly property var sizeSpecs: ({
        xsmall: { height: 32, iconSize: 20, fontSize: 14, minWidth: 48, padding: 12, gap: 4, radius: 16, innerRadius: 4 },
        small:  { height: 40, iconSize: 20, fontSize: 14, minWidth: 48, padding: 16, gap: 8, radius: 20, innerRadius: 8 },
        medium: { height: 56, iconSize: 24, fontSize: 16, minWidth: 56, padding: 24, gap: 8, radius: 28, innerRadius: 8 },
        large:  { height: 96, iconSize: 32, fontSize: 24, minWidth: 96, padding: 48, gap: 12, radius: 48, innerRadius: 16 },
        xlarge: { height: 136, iconSize: 40, fontSize: 32, minWidth: 136, padding: 64, gap: 16, radius: 68, innerRadius: 20 }
    })

    readonly property var cs: sizeSpecs[size] || sizeSpecs.small
    readonly property bool _isMulti: selectionMode === "multi"
    property var colors: Theme.ChiTheme.colors

    implicitWidth: container.implicitWidth
    implicitHeight: cs.height

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity { NumberAnimation { duration: 200 } }

    Rectangle {
        id: container
        color: colors.surfaceContainerLow
        radius: shape === "round" ? cs.radius : cs.innerRadius
        width: segmentRow.implicitWidth + 4
        height: cs.height

        // 2px padding for the row inside
        Row {
            id: segmentRow
            anchors.centerIn: parent
            spacing: 2

            Repeater {
                model: root.items

                delegate: Item {
                    id: wrapper

                    // Logic states
                    property bool isSelected: root.selectedIndices.indexOf(index) !== -1
                    property bool isFirst: index === 0
                    property bool isLast: index === root.items.length - 1

                    // Dimensions
                    width: Math.max(cs.minWidth, content.implicitWidth + cs.padding * 2)
                    height: cs.height - 4 // 2px margin from container top/bottom

                    // Data extraction
                    property string label: (typeof modelData === "string") ? modelData : (modelData.text || "")
                    property string iconCode: (typeof modelData === "object" && modelData.icon) ? modelData.icon : ""

                    // Cached delegate color
                    readonly property color _segColor: isSelected ? colors.onSecondary : colors.onSecondaryContainer

                    Rectangle {
                        id: bg
                        anchors.fill: parent

                        // --- Shape Logic ---
                        property real fullR: shape === "round" ? cs.radius : cs.innerRadius
                        property real smallR: cs.innerRadius

                        // Selected → fully rounded; Unselected → sharp inside, rounded outside
                        topLeftRadius: isSelected ? fullR : (isFirst ? fullR : smallR)
                        bottomLeftRadius: isSelected ? fullR : (isFirst ? fullR : smallR)
                        topRightRadius: isSelected ? fullR : (isLast ? fullR : smallR)
                        bottomRightRadius: isSelected ? fullR : (isLast ? fullR : smallR)

                        // Smooth morphing
                        Behavior on topLeftRadius { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                        Behavior on bottomLeftRadius { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                        Behavior on topRightRadius { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                        Behavior on bottomRightRadius { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

                        color: isSelected ? colors.secondary : colors.secondaryContainer
                        Behavior on color { ColorAnimation { duration: 200 } }

                        // State layer (hover/press) — radii must match parent for proper corners
                        Rectangle {
                            anchors.fill: parent
                            topLeftRadius: parent.topLeftRadius
                            topRightRadius: parent.topRightRadius
                            bottomLeftRadius: parent.bottomLeftRadius
                            bottomRightRadius: parent.bottomRightRadius
                            color: wrapper._segColor
                            opacity: ma.pressed ? 0.12 : (ma.containsMouse ? 0.08 : 0)
                            Behavior on opacity { NumberAnimation { duration: 100 } }
                        }

                        // Content
                        Row {
                            id: content
                            anchors.centerIn: parent
                            spacing: cs.gap

                            // Check mark for multi-select
                            Text {
                                visible: isSelected && root._isMulti
                                text: "\ue876"
                                font.family: Theme.ChiTheme.iconFamily
                                font.pixelSize: cs.iconSize
                                color: colors.onSecondary
                            }

                            // Leading icon
                            Text {
                                visible: wrapper.iconCode !== "" && !(isSelected && root._isMulti)
                                text: wrapper.iconCode
                                font.family: Theme.ChiTheme.iconFamily
                                font.pixelSize: cs.iconSize
                                color: wrapper._segColor
                            }

                            // Label text
                            Text {
                                visible: wrapper.label !== ""
                                text: wrapper.label
                                font.family: Theme.ChiTheme.fontFamily
                                font.pixelSize: cs.fontSize
                                font.weight: Font.Medium
                                color: wrapper._segColor
                            }
                        }
                    }

                    MouseArea {
                        id: ma
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: root.handleClick(index)
                    }
                }
            }
        }
    }

    function handleClick(idx) {
        itemClicked(idx)
        var newIndices = selectedIndices.slice()

        if (selectionMode === "single") {
            newIndices = [idx]
        } else if (_isMulti) {
            var i = newIndices.indexOf(idx)
            if (i !== -1) newIndices.splice(i, 1)
            else newIndices.push(idx)
        } else if (selectionMode === "required") {
            var i2 = newIndices.indexOf(idx)
            if (i2 !== -1) {
                if (newIndices.length > 1) newIndices.splice(i2, 1)
            } else {
                newIndices = [idx]
            }
        }

        selectedIndices = newIndices
        selectedIndex = newIndices.length > 0 ? newIndices[0] : -1
        selectionChanged(newIndices)
    }

    Component.onCompleted: {
        if (selectionMode === "required" && selectedIndices.length === 0 && items.length > 0) {
            selectedIndices = [0]
            selectedIndex = 0
        }
    }
}
