import QtQuick
import QtQuick.Layouts
import "../theme" as Theme

Item {
    id: root

    property var model: []
    property int indentSize: 20
    property var selectedItem: null
    property int selectedIndex: -1
    property bool enabled: true
    property bool multiSelect: false
    property var selectedIndices: []

    signal itemClicked(var item, int index, var path)
    signal itemDoubleClicked(var item, int index)
    signal itemToggled(var item, bool expanded)

    implicitWidth: 250
    implicitHeight: 300

    property var colors: Theme.ChiTheme.colors

    Flickable {
        anchors.fill: parent
        contentHeight: treeColumn.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: treeColumn
            width: parent.width

            Repeater {
                model: root.model
                delegate: treeDelegate
            }
        }
    }

    Component {
        id: treeDelegate

        Column {
            id: nodeColumn
            width: parent ? parent.width : root.width

            property var nodeData: modelData
            property int nodeDepth: 0
            property var nodePath: [index]
            property bool isSelected: selectedIndices.indexOf(index) !== -1 || selectedIndex === index

            Rectangle {
                width: parent.width
                height: 36

                color: isSelected ? colors.primaryContainer : "transparent"

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }

                Rectangle {
                    anchors.fill: parent
                    color: colors.onSurface
                    opacity: nodeMouse.containsMouse && !isSelected ? 0.08 : 0
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12 + nodeColumn.nodeDepth * indentSize
                    anchors.rightMargin: 12
                    spacing: 8

                    // Expand/collapse
                    Item {
                        Layout.preferredWidth: 20
                        Layout.preferredHeight: 20
                        visible: nodeColumn.nodeData.children && nodeColumn.nodeData.children.length > 0

                        Text {
                            anchors.centerIn: parent
                            text: nodeColumn.nodeData.expanded ? "▼" : "▶"
                            font.pixelSize: 10
                            color: colors.onSurfaceVariant

                            rotation: nodeColumn.nodeData.expanded ? 0 : 0

                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: -4
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                nodeColumn.nodeData.expanded = !nodeColumn.nodeData.expanded
                                itemToggled(nodeColumn.nodeData, nodeColumn.nodeData.expanded)
                                root.modelChanged()
                            }
                        }
                    }

                    // Spacer when no children
                    Item {
                        Layout.preferredWidth: 20
                        visible: !nodeColumn.nodeData.children || nodeColumn.nodeData.children.length === 0
                    }

                    // Icon
                    Text {
                        visible: nodeColumn.nodeData.icon && nodeColumn.nodeData.icon !== ""
                        text: nodeColumn.nodeData.icon
                        font.pixelSize: 18
                        color: colors.onSurfaceVariant
                        Layout.alignment: Qt.AlignVCenter
                    }

                    // Label
                    Text {
                        text: nodeColumn.nodeData.label || nodeColumn.nodeData.text || ""
                        font.family: "Roboto"
                        font.pixelSize: 14
                        color: colors.onSurface
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                    }

                    // Badge/count
                    Rectangle {
                        visible: nodeColumn.nodeData.badge !== undefined
                        Layout.preferredWidth: Math.max(20, badgeText.implicitWidth + 8)
                        Layout.preferredHeight: 20
                        radius: 10
                        color: colors.secondaryContainer

                        Text {
                            id: badgeText
                            anchors.centerIn: parent
                            text: nodeColumn.nodeData.badge
                            font.family: "Roboto"
                            font.pixelSize: 11
                            color: colors.onSecondaryContainer
                        }
                    }
                }

                MouseArea {
                    id: nodeMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    enabled: root.enabled

                    onClicked: {
                        if (multiSelect) {
                            var indices = selectedIndices.slice()
                            var idx = indices.indexOf(index)
                            if (idx !== -1) {
                                indices.splice(idx, 1)
                            } else {
                                indices.push(index)
                            }
                            selectedIndices = indices
                        } else {
                            selectedIndex = index
                            selectedItem = nodeColumn.nodeData
                        }
                        itemClicked(nodeColumn.nodeData, index, nodeColumn.nodePath)
                    }

                    onDoubleClicked: {
                        itemDoubleClicked(nodeColumn.nodeData, index)
                    }
                }
            }

            // Children
            Column {
                visible: nodeColumn.nodeData.expanded && nodeColumn.nodeData.children
                width: parent.width

                Repeater {
                    model: nodeColumn.nodeData.children || []

                    delegate: Loader {
                        width: parent ? parent.width : 0
                        sourceComponent: treeDelegate

                        onLoaded: {
                            item.nodeData = modelData
                            item.nodeDepth = nodeColumn.nodeDepth + 1
                            item.nodePath = nodeColumn.nodePath.concat([index])
                        }
                    }
                }
            }
        }
    }

    function expandAll() {
        function expand(items) {
            for (var i = 0; i < items.length; i++) {
                if (items[i].children) {
                    items[i].expanded = true
                    expand(items[i].children)
                }
            }
        }
        expand(model)
        modelChanged()
    }

    function collapseAll() {
        function collapse(items) {
            for (var i = 0; i < items.length; i++) {
                if (items[i].children) {
                    items[i].expanded = false
                    collapse(items[i].children)
                }
            }
        }
        collapse(model)
        modelChanged()
    }

    Accessible.role: Accessible.Tree
    Accessible.name: "Tree view"
}
