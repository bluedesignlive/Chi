import QtQuick
import QtQuick.Layouts

Item {
    id: root

    // Public API
    property string size: "small"          // xsmall, small, medium, large, xlarge
    property string selectionMode: "none"  // none, single, multi, required
    property bool enabled: true

    // Spacing from M3 standard group specs
    readonly property var spacingForSize: ({
        xsmall: 18,
        small: 12,
        medium: 8,
        large: 8,
        xlarge: 8
    })

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    Row {
        id: row
        spacing: spacingForSize[root.size] || 8
    }

    // Any child declared inside ButtonGroup { ... } goes into row
    default property alias buttons: row.data

    Component.onCompleted: setupOnce()

    function setupOnce() {
        const children = row.children
        var toggles = []

        for (var i = 0; i < children.length; ++i) {
            var child = children[i]
            if (!child)
                continue

            // Pass size if supported
            if (child.hasOwnProperty("size"))
                child.size = root.size

            // Pass enabled if supported
            if (child.hasOwnProperty("enabled"))
                child.enabled = Qt.binding(function() { return root.enabled })

            // Toggle-capable if has selected + toggled(bool)
            if (child.hasOwnProperty("selected") && child.hasOwnProperty("toggled")) {
                toggles.push(child)

                // Connect toggled(bool) with closure capturing 'child'
                child.toggled.connect(
                    (function(c) {
                        return function(selected) {
                            root.handleChildToggled(c, selected)
                        }
                    })(child)
                )
            }
        }

        // Normalize initial selection for single/required
        if (selectionMode === "single" || selectionMode === "required") {
            var firstSelected = null

            for (var j = 0; j < toggles.length; ++j) {
                var t = toggles[j]
                if (t.selected) {
                    if (!firstSelected)
                        firstSelected = t
                    else
                        t.selected = false // keep only the first one
                }
            }

            if (!firstSelected && selectionMode === "required" && toggles.length > 0) {
                toggles[0].selected = true
            }
        }
    }

    function handleChildToggled(child, isSelected) {
        if (selectionMode === "none")
            return

        // Rebuild current toggle list each time (handles dynamic content)
        var toggles = []
        for (var i = 0; i < row.children.length; ++i) {
            var c = row.children[i]
            if (c && c.hasOwnProperty("selected") && c.hasOwnProperty("toggled"))
                toggles.push(c)
        }

        if (selectionMode === "single") {
            if (isSelected) {
                // Deselect all others
                for (var j = 0; j < toggles.length; ++j) {
                    var t = toggles[j]
                    if (t !== child && t.selected)
                        t.selected = false
                }
            }
            // If user unselects the only selected, we allow no selection
        } else if (selectionMode === "required") {
            if (isSelected) {
                // Deselect all others
                for (var k = 0; k < toggles.length; ++k) {
                    var t2 = toggles[k]
                    if (t2 !== child && t2.selected)
                        t2.selected = false
                }
            } else {
                // Prevent zero selected
                var anyOther = false
                for (var m = 0; m < toggles.length; ++m) {
                    var t3 = toggles[m]
                    if (t3 !== child && t3.selected) {
                        anyOther = true
                        break
                    }
                }
                if (!anyOther) {
                    // Re-select this one to enforce required
                    child.selected = true
                }
            }
        } else if (selectionMode === "multi") {
            // Do nothing special; each toggle manages its own selected state
        }
    }
}
