import QtQuick
import QtQuick.Layouts
import "../theme" as Theme

Flow {
    id: root

    property bool singleSelection: false
    property int selectedIndex: -1
    property var selectedIndices: []
    property string size: "medium"
    property real chipSpacing: 8

    signal selectionChanged()

    spacing: chipSpacing

    property var colors: Theme.ChiTheme.colors

    onChildrenChanged: {
        for (var i = 0; i < children.length; i++) {
            var chip = children[i]
            if (chip.hasOwnProperty("clicked")) {
                setupChip(chip, i)
            }
        }
    }

    function setupChip(chip, index) {
        chip.size = Qt.binding(function() { return root.size })

        chip.clicked.connect(function() {
            if (singleSelection) {
                // Deselect all others
                for (var j = 0; j < children.length; j++) {
                    if (j !== index && children[j].hasOwnProperty("selected")) {
                        children[j].selected = false
                    }
                }
                selectedIndex = chip.selected ? index : -1
            }
            updateSelectedIndices()
            selectionChanged()
        })
    }

    function updateSelectedIndices() {
        var indices = []
        for (var i = 0; i < children.length; i++) {
            if (children[i].hasOwnProperty("selected") && children[i].selected) {
                indices.push(i)
            }
        }
        selectedIndices = indices
    }

    function clearSelection() {
        for (var i = 0; i < children.length; i++) {
            if (children[i].hasOwnProperty("selected")) {
                children[i].selected = false
            }
        }
        selectedIndex = -1
        selectedIndices = []
        selectionChanged()
    }
}
