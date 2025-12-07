// qml/smartui/ui/selection/RadioGroup.qml
import QtQuick
import "../../theme" as Theme

Column {
    id: root

    property int selectedIndex: -1
    property string label: ""
    property string size: "medium"
    property bool enabled: true

    signal selectionChanged(int index)

    spacing: 8

    property var colors: Theme.ChiTheme.colors

    // Group label
    Text {
        visible: label !== ""
        text: label
        font.family: "Roboto"
        font.pixelSize: 14
        font.weight: Font.Medium
        color: colors.onSurface

        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }

    // RadioButtons are placed as children
    Component.onCompleted: updateSelection()

    onSelectedIndexChanged: updateSelection()

    function updateSelection() {
        for (var i = 0; i < children.length; i++) {
            var child = children[i]
            if (child.hasOwnProperty("checked")) {
                child.checked = (i - (label !== "" ? 1 : 0)) === selectedIndex
                child.size = size
                child.enabled = Qt.binding(function() { return root.enabled })
            }
        }
    }

    onChildrenChanged: {
        for (var i = 0; i < children.length; i++) {
            var child = children[i]
            if (child.hasOwnProperty("toggled")) {
                (function(index) {
                    child.toggled.connect(function() {
                        selectedIndex = index - (label !== "" ? 1 : 0)
                        selectionChanged(selectedIndex)
                    })
                })(i)
            }
        }
        updateSelection()
    }
}
