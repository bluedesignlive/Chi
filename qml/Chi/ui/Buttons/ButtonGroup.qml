// ButtonGroup.qml - M3 Standard Button Group

import QtQuick.Layouts
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property string size: "small"
    property string selectionMode: "none"  // none, single, multi, required
    property bool enabled: true

    readonly property var spacingMap: ({
            xsmall: 18,
            small: 12,
            medium: 8,
            large: 8,
            xlarge: 8
        })

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    RowLayout {
        id: row
        spacing: spacingMap[root.size] || 8
    }

    default property alias buttons: row.data

    Component.onCompleted: setupOnce()

    function setupOnce() {
        var children = row.children;
        var toggles = [];

        for (var i = 0; i < children.length; ++i) {
            var child = children[i];
            if (!child)
                continue;
            if (child.hasOwnProperty("size"))
                child.size = Qt.binding(function () {
                    return root.size;
                });
            if (child.hasOwnProperty("enabled"))
                child.enabled = Qt.binding(function () {
                    return root.enabled;
                });

            if (child.hasOwnProperty("selected") && child.hasOwnProperty("toggled")) {
                toggles.push(child);
                child.toggled.connect((function (c) {
                        return function (selected) {
                            root.handleChildToggled(c, selected);
                        };
                    })(child));
            }
        }

        if (selectionMode === "single" || selectionMode === "required") {
            var first = null;
            for (var j = 0; j < toggles.length; ++j) {
                if (toggles[j].selected) {
                    if (!first)
                        first = toggles[j];
                    else
                        toggles[j].selected = false;
                }
            }
            if (!first && selectionMode === "required" && toggles.length > 0) {
                toggles[0].selected = true;
            }
        }
    }

    function handleChildToggled(child, isSelected) {
        if (selectionMode === "none")
            return;
        var toggles = [];
        for (var i = 0; i < row.children.length; ++i) {
            var c = row.children[i];
            if (c && c.hasOwnProperty("selected") && c.hasOwnProperty("toggled"))
                toggles.push(c);
        }

        if (selectionMode === "single") {
            if (isSelected) {
                for (var j = 0; j < toggles.length; ++j) {
                    if (toggles[j] !== child && toggles[j].selected)
                        toggles[j].selected = false;
                }
            }
        } else if (selectionMode === "required") {
            if (isSelected) {
                for (var k = 0; k < toggles.length; ++k) {
                    if (toggles[k] !== child && toggles[k].selected)
                        toggles[k].selected = false;
                }
            } else {
                var anyOther = false;
                for (var m = 0; m < toggles.length; ++m) {
                    if (toggles[m] !== child && toggles[m].selected) {
                        anyOther = true;
                        break;
                    }
                }
                if (!anyOther)
                    child.selected = true;
            }
        }
    // multi: each toggle manages its own state
    }
}
