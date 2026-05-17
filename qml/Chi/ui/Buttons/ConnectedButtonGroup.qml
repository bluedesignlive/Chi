// ConnectedButtonGroup.qml - M3 Connected Button Group (Segmented)
// All animation tokens from ChiMotion — no hardcoded values

import QtQuick.Effects
import QtQuick
import "../../theme" as Theme
import "../common" as Common

Item {
    id: root

    property string size: "small"
    property string shape: "round"          // "round" or "square"
    property string selectionMode: "single" // "single", "multi", "required"
    property bool enabled: true

    property int selectedIndex: -1
    property var selectedIndices: []
    property var items: []

    signal selectionChanged(var indices)
    signal itemClicked(int index)

    readonly property var spec: Theme.SizeSpecs.getSpec(Theme.SizeSpecs.connectedButtonGroup, size)
    readonly property var colors: Theme.ChiTheme.colors
    readonly property int animDur: Theme.ChiMotion.spring.fast.effects.duration

    readonly property bool _isMulti: selectionMode === "multi"

    implicitWidth: container.implicitWidth
    implicitHeight: spec.height

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity {
        enabled: Theme.ChiMotion.animationsEnabled
        NumberAnimation {
            duration: Theme.ChiMotion.duration.medium2
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Theme.ChiMotion.easing.standard
        }
    }

    function _isItemSelected(idx) {
        return selectedIndices.indexOf(idx) !== -1;
    }

    function _deselectAll() {
        var old = selectedIndices.slice();
        selectedIndices = [];
        for (var i = 0; i < old.length; i++) {
            if (root["__item" + old[i]]) {
                root["__item" + old[i]]._selected = false;
            }
        }
    }

    function _selectOne(idx) {
        _deselectAll();
        selectedIndices = [idx];
        selectedIndex = idx;
        if (root["__item" + idx]) {
            root["__item" + idx]._selected = true;
        }
        selectionChanged(selectedIndices);
    }

    function _toggleItem(idx) {
        var sel = _isItemSelected(idx);
        if (selectionMode === "single") {
            _selectOne(idx);
        } else if (selectionMode === "required") {
            if (sel && selectedIndices.length === 1)
                // prevent zero
                return;
            _selectOne(idx);
        } else { // multi
            if (sel) {
                selectedIndices = selectedIndices.filter(function (x) {
                    return x !== idx;
                });
            } else {
                selectedIndices.push(idx);
            }
            if (root["__item" + idx]) {
                root["__item" + idx]._selected = !sel;
            }
            selectionChanged(selectedIndices);
        }
    }

    Rectangle {
        id: container
        color: colors.surfaceContainerLow
        radius: shape === "round" ? spec.radius : spec.innerRadius
        width: segmentRow.implicitWidth + spec.innerPadding * 2
        height: spec.height

        // Elevation shadow — token-based
        layer.enabled: enabled
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Theme.ChiElevation.shadowColor(Theme.ChiElevation.level0)
            shadowOpacity: Theme.ChiElevation.shadowOpacity(Theme.ChiElevation.level0)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: Theme.ChiElevation.verticalOffset(Theme.ChiElevation.level0)
            shadowBlur: Theme.ChiElevation.blurRadius(Theme.ChiElevation.level0)
        }

        Row {
            id: segmentRow
            anchors.centerIn: parent
            spacing: 2

            Repeater {
                model: root.items

                delegate: Item {
                    id: wrapper
                    property bool _selected: root._isItemSelected(index)
                    property bool isFirst: index === 0
                    property bool isLast: index === root.items.length - 1

                    width: Math.max(spec.minWidth, content.implicitWidth + spec.padding * 2)
                    height: spec.height - 4

                    property string _label: (typeof modelData === "string") ? modelData : (modelData.text || "")
                    property string _iconCode: (typeof modelData === "object" && modelData.icon) ? modelData.icon : ""

                    readonly property color _segColor: _selected ? colors.onSecondary : colors.onSecondaryContainer

                    Rectangle {
                        id: bg
                        anchors.fill: parent

                        property real _fullR: shape === "round" ? spec.radius : spec.innerRadius

                        topLeftRadius: isFirst ? _fullR : (wrapper._selected ? _fullR : spec.innerRadius)
                        bottomLeftRadius: isFirst ? _fullR : (wrapper._selected ? _fullR : spec.innerRadius)
                        topRightRadius: isLast ? _fullR : (wrapper._selected ? _fullR : spec.innerRadius)
                        bottomRightRadius: isLast ? _fullR : (wrapper._selected ? _fullR : spec.innerRadius)

                        Behavior on topLeftRadius {
                            enabled: Theme.ChiMotion.animationsEnabled
                            NumberAnimation {
                                duration: animDur
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Theme.ChiMotion.easing.emphasizedDecelerate
                            }
                        }
                        Behavior on bottomLeftRadius {
                            enabled: Theme.ChiMotion.animationsEnabled
                            NumberAnimation {
                                duration: animDur
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Theme.ChiMotion.easing.emphasizedDecelerate
                            }
                        }
                        Behavior on topRightRadius {
                            enabled: Theme.ChiMotion.animationsEnabled
                            NumberAnimation {
                                duration: animDur
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Theme.ChiMotion.easing.emphasizedDecelerate
                            }
                        }
                        Behavior on bottomRightRadius {
                            enabled: Theme.ChiMotion.animationsEnabled
                            NumberAnimation {
                                duration: animDur
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Theme.ChiMotion.easing.emphasizedDecelerate
                            }
                        }

                        color: wrapper._selected ? colors.secondary : colors.secondaryContainer
                        Behavior on color {
                            enabled: Theme.ChiMotion.animationsEnabled
                            ColorAnimation {
                                duration: Theme.ChiMotion.duration.medium2
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Theme.ChiMotion.easing.standard
                            }
                        }

                        // State layer
                        Rectangle {
                            anchors.fill: parent
                            topLeftRadius: parent.topLeftRadius
                            topRightRadius: parent.topRightRadius
                            bottomLeftRadius: parent.bottomLeftRadius
                            bottomRightRadius: parent.bottomRightRadius
                            color: wrapper._segColor
                            opacity: wrapperMouse.pressed ? 0.10 : (wrapperMouse.containsMouse ? 0.08 : 0)
                            Behavior on opacity {
                                enabled: Theme.ChiMotion.animationsEnabled
                                NumberAnimation {
                                    duration: Theme.ChiMotion.spring.fast.effects.duration
                                    easing.type: Easing.BezierSpline
                                    easing.bezierCurve: Theme.ChiMotion.easing.standard
                                }
                            }
                        }

                        // Content
                        Row {
                            id: content
                            anchors.centerIn: parent
                            spacing: spec.gap

                            Text {
                                visible: wrapper._selected && root._isMulti
                                text: "\u2713" // checkmark
                                font.family: Theme.ChiTheme.typography.labelMedium.family
                                font.pixelSize: spec.iconSize
                                color: colors.onSecondary
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                visible: _iconCode !== "" && !(wrapper._selected && root._isMulti)
                                text: _iconCode
                                font.family: Theme.ChiTheme.iconFamily
                                font.pixelSize: spec.iconSize
                                color: wrapper._segColor
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                visible: _label !== ""
                                text: _label
                                font.family: Theme.ChiTheme.typography[spec.typo] ? Theme.ChiTheme.typography[spec.typo].family : Theme.ChiTheme.fontFamily
                                font.pixelSize: spec.fontSize
                                color: wrapper._segColor
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }

                    MouseArea {
                        id: wrapperMouse
                        anchors.fill: parent
                        enabled: root.enabled
                        hoverEnabled: true
                        onClicked: root._toggleItem(index)
                    }
                }
            }
        }
    }
}
