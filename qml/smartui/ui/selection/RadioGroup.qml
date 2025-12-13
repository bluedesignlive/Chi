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
    
    // Track our radio buttons separately
    property var radioButtons: []

    // Group label
    Text {
        id: labelText
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

    // When children change, update our button list
    onChildrenChanged: {
        updateRadioButtons()
    }

    Component.onCompleted: {
        updateRadioButtons()
        if (selectedIndex >= 0) {
            updateSelection()
        }
    }

    onSelectedIndexChanged: {
        updateSelection()
    }

    function updateRadioButtons() {
        // Find all RadioButton children (excluding the label)
        radioButtons = []
        for (var i = 0; i < children.length; i++) {
            var child = children[i]
            if (child !== labelText && child.hasOwnProperty("checked") && child.hasOwnProperty("toggled")) {
                radioButtons.push(child)
                
                // Set properties
                child.size = size
                child.enabled = Qt.binding(function() { return root.enabled })
                
                // Connect to toggled signal
                connectButton(child, radioButtons.length - 1)
            }
        }
    }

    function connectButton(button, index) {
        // Disconnect any existing connections
        try { button.toggled.disconnect(handleToggle) } catch(e) {}
        
        // Connect with the proper index
        button.toggled.connect(function() {
            handleToggle(index)
        })
    }

    function handleToggle(index) {
        console.log("RadioGroup: Button", index, "toggled")
        
        // Update selected index
        selectedIndex = index
        
        // Manually update all buttons
        for (var i = 0; i < radioButtons.length; i++) {
            radioButtons[i].checked = (i === index)
            console.log("  - Button", i, "checked =", radioButtons[i].checked)
        }
        
        // Emit signal
        selectionChanged(index)
    }

    function updateSelection() {
        console.log("RadioGroup: Updating selection to index", selectedIndex)
        for (var i = 0; i < radioButtons.length; i++) {
            var shouldBeChecked = (i === selectedIndex)
            radioButtons[i].checked = shouldBeChecked
            console.log("  - Button", i, "set to", shouldBeChecked)
        }
    }
}
