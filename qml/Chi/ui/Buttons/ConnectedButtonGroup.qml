// ConnectedButtonGroup.qml - Segmented M3 Group

import QtQuick
import QtQuick.Effects
import "../../theme" as Theme
import "../common" as Common

Item {
    id: root

    property var items: []
    property string size: "medium"
    property string shape: "round"
    property string selectionMode: "single"
    property var selectedIndices: []
    property int selectedIndex: -1
    property bool enabled: true

    signal itemClicked(int index)
    signal selectionChanged(var indices)

    readonly property bool _isMulti: selectionMode === "multi"
    readonly property var spec: Theme.SizeSpecs.getSpec(Theme.SizeSpecs.connectedButtonGroup, size)
    readonly property var colors: Theme.ChiTheme.colors
    readonly property var motion: Theme.ChiTheme.motion

    implicitWidth: container.width
    implicitHeight: spec.height

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity { enabled: motion.animationsEnabled; NumberAnimation { duration: motion.durationMedium } }

    function _isItemSelected(idx) { return selectedIndices.indexOf(idx) !== -1 }

    function _toggleItem(idx) {
        var sel = _isItemSelected(idx)
        var newIndices = selectedIndices.slice()

        if (selectionMode === "single") {
            newIndices = [idx]
        } else if (selectionMode === "required") {
            if (sel && newIndices.length === 1) return
            var iReq = newIndices.indexOf(idx)
            if (iReq !== -1) newIndices.splice(iReq, 1)
            else newIndices = [idx]
        } else {
            var iMulti = newIndices.indexOf(idx)
            if (iMulti !== -1) newIndices.splice(iMulti, 1)
            else newIndices.push(idx)
        }

        selectedIndices = newIndices
        selectedIndex = newIndices.length > 0 ? newIndices[0] : -1
        itemClicked(idx)
        selectionChanged(selectedIndices)
    }

    Rectangle {
        id: container
        color: colors.surfaceContainerLow
        radius: shape === "round" ? spec.radius : spec.innerRadius
        width: segmentRow.implicitWidth + spec.innerPadding * 2
        height: spec.height
        border.width: 1
        border.color: colors.outlineVariant

        Row {
            id: segmentRow
            anchors.centerIn: parent
            spacing: spec.betweenSpace

            Repeater {
                model: root.items
                delegate: Item {
                    id: wrapper
                    property bool isFirst: index === 0
                    property bool isLast: index === root.items.length - 1
                    property bool isSelected: root._isItemSelected(index)
                    property string _label: (typeof modelData === "string") ? modelData : (modelData.text || "")
                    property string _iconCode: (typeof modelData === "object" && modelData.icon) ? modelData.icon : ""

                    width: Math.max(spec.minWidth, content.implicitWidth + spec.padding * 2)
                    height: spec.height - (spec.innerPadding * 2)

                    Rectangle {
                        id: bgRect
                        anchors.fill: parent
                        color: isSelected ? colors.secondaryContainer : "transparent"
                        
                        property real _fullR: shape === "round" ? spec.radius : spec.innerRadius
                        
                        topLeftRadius: isFirst ? _fullR : (isSelected ? _fullR : spec.innerRadius)
                        bottomLeftRadius: isFirst ? _fullR : (isSelected ? _fullR : spec.innerRadius)
                        topRightRadius: isLast ? _fullR : (isSelected ? _fullR : spec.innerRadius)
                        bottomRightRadius: isLast ? _fullR : (isSelected ? _fullR : spec.innerRadius)

                        Behavior on topLeftRadius { enabled: motion.animationsEnabled; NumberAnimation { duration: motion.durationFast; easing.type: Easing.OutCubic } }
                        Behavior on bottomLeftRadius { enabled: motion.animationsEnabled; NumberAnimation { duration: motion.durationFast; easing.type: Easing.OutCubic } }
                        Behavior on topRightRadius { enabled: motion.animationsEnabled; NumberAnimation { duration: motion.durationFast; easing.type: Easing.OutCubic } }
                        Behavior on bottomRightRadius { enabled: motion.animationsEnabled; NumberAnimation { duration: motion.durationFast; easing.type: Easing.OutCubic } }
                        Behavior on color { enabled: motion.animationsEnabled; ColorAnimation { duration: motion.durationFast } }

                        Common.StateLayer {
                            layerColor: colors.onSecondaryContainer
                            containerRadius: bgRect.topLeftRadius
                            pressed: wrapperMouse.pressed
                            hovered: wrapperMouse.containsMouse
                            enabled: root.enabled
                        }
                        Common.Ripple {
                            color: colors.onSecondaryContainer
                            radius: bgRect.topLeftRadius
                            enabled: root.enabled
                        }

                        Row {
                            id: content
                            anchors.centerIn: parent
                            spacing: spec.gap

                            Common.Icon {
                                visible: isSelected && root._isMulti
                                source: "check"
                                size: spec.iconSize
                                color: colors.onSecondaryContainer
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Common.Icon {
                                visible: _iconCode !== "" && !(isSelected && root._isMulti)
                                source: _iconCode
                                size: spec.iconSize
                                color: colors.onSecondaryContainer
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Text {
                                visible: _label !== ""
                                text: _label
                                font.family: Theme.ChiTheme.typography[spec.typo] ? Theme.ChiTheme.typography[spec.typo].family : Theme.ChiTheme.fontFamily
                                font.pixelSize: spec.fontSize
                                color: colors.onSecondaryContainer
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }

                    MouseArea {
                        id: wrapperMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: root.enabled
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root._toggleItem(index)
                    }
                }
            }
        }
    }
}
