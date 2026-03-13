import QtQuick
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
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
                    property int idx: index
                    
                    // Logic states
                    property bool isSelected: root.selectedIndices.indexOf(index) !== -1
                    property bool isFirst: index === 0
                    property bool isLast: index === root.items.length - 1
                    property bool isHovered: ma.containsMouse
                    property bool isPressed: ma.pressed

                    // Dimensions
                    width: Math.max(cs.minWidth, content.implicitWidth + (cs.padding * 2))
                    height: cs.height - 4 // 2px margin from container top/bottom

                    // Data extraction
                    property string label: (typeof modelData === "string") ? modelData : (modelData.text || "")
                    property string iconCode: (typeof modelData === "object" && modelData.icon) ? modelData.icon : ""

                    Rectangle {
                        id: bg
                        anchors.fill: parent
                        
                        // --- Shape Logic ---
                        property real fullR: shape === "round" ? cs.radius : cs.innerRadius
                        property real smallR: cs.innerRadius
                        
                        // If selected -> Fully rounded
                        // If unselected -> Sharp inside, Rounded outside
                        property real tl: isSelected ? fullR : (isFirst ? fullR : smallR)
                        property real bl: isSelected ? fullR : (isFirst ? fullR : smallR)
                        property real tr: isSelected ? fullR : (isLast ? fullR : smallR)
                        property real br: isSelected ? fullR : (isLast ? fullR : smallR)

                        topLeftRadius: tl
                        bottomLeftRadius: bl
                        topRightRadius: tr
                        bottomRightRadius: br

                        // Smooth Morphing
                        Behavior on topLeftRadius { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                        Behavior on bottomLeftRadius { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                        Behavior on topRightRadius { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                        Behavior on bottomRightRadius { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

                        color: isSelected ? colors.secondary : colors.secondaryContainer
                        Behavior on color { ColorAnimation { duration: 200 } }

                        // State Layer (Hover/Press) - Radius MUST match parent
                        Rectangle {
                            anchors.fill: parent
                            radius: parent.radius
                            topLeftRadius: parent.topLeftRadius
                            topRightRadius: parent.topRightRadius
                            bottomLeftRadius: parent.bottomLeftRadius
                            bottomRightRadius: parent.bottomRightRadius
                            
                            color: isSelected ? colors.onSecondary : colors.onSecondaryContainer
                            opacity: isPressed ? 0.12 : (isHovered ? 0.08 : 0)
                            
                            Behavior on opacity { NumberAnimation { duration: 100 } }
                        }
                        
                        // Content
                        Row {
                            id: content
                            anchors.centerIn: parent
                            spacing: cs.gap

                            Text {
                                visible: isSelected && selectionMode === "multi"
                                text: "\ue876" // check
                                font.family: "Material Icons"
                                font.pixelSize: cs.iconSize
                                color: colors.onSecondary
                            }

                            Text {
                                visible: wrapper.iconCode !== "" && !(isSelected && selectionMode === "multi")
                                text: wrapper.iconCode
                                font.family: "Material Icons"
                                font.pixelSize: cs.iconSize
                                color: isSelected ? colors.onSecondary : colors.onSecondaryContainer
                            }

                            Text {
                                visible: wrapper.label !== ""
                                text: wrapper.label
                                font.family: "Roboto"
                                font.pixelSize: cs.fontSize
                                font.weight: Font.Medium
                                color: isSelected ? colors.onSecondary : colors.onSecondaryContainer
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
        } else if (selectionMode === "multi") {
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
