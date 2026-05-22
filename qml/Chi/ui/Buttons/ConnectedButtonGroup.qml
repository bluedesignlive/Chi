// ConnectedButtonGroup.qml - Production Quality Segmented Group
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

    implicitWidth: container.width
    implicitHeight: spec.height

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity { NumberAnimation { duration: 200 } }

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
        radius: shape === "round" ? height / 2 : spec.innerRadius
        width: segmentRow.implicitWidth + spec.innerPadding * 2
        height: spec.height
        border.width: 1
        border.color: colors.outlineVariant

        Row {
            id: segmentRow
            anchors.centerIn: parent
            spacing: spec.betweenSpace > 0 ? spec.betweenSpace : 6 

            Repeater {
                model: root.items
                delegate: Item {
                    id: delegateItem
                    property bool isSelected: root._isItemSelected(index)
                    property string _label: (typeof modelData === "string") ? modelData : (modelData.text || "")
                    property string _iconCode: (typeof modelData === "object" && modelData.icon) ? modelData.icon : ""
                    
                    // Strict theme binding for production
                    readonly property color _contentColor: isSelected ? colors.onSecondaryContainer : colors.onSurface

                    width: Math.max(spec.minWidth, content.implicitWidth + spec.padding * 2)
                    height: spec.height - (spec.innerPadding * 2)

                    scale: wrapperMouse.pressed ? 0.94 : 1.0
                    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack; easing.overshoot: 2.0 } }

                    Rectangle {
                        id: bgRect
                        anchors.fill: parent
                        radius: shape === "round" ? height / 2 : spec.innerRadius
                        color: isSelected ? colors.secondaryContainer : "transparent"
                        Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.InOutQuad } }

                        Common.Ripple { color: delegateItem._contentColor; radius: bgRect.radius; enabled: root.enabled }
                        Common.StateLayer { layerColor: delegateItem._contentColor; containerRadius: bgRect.radius; pressed: wrapperMouse.pressed; hovered: wrapperMouse.containsMouse; enabled: root.enabled }

                        Row {
                            id: content
                            anchors.centerIn: parent
                            spacing: 0 // Spacing is dynamically handled by iconSlot to ensure smooth push

                            Item {
                                id: iconSlot
                                readonly property bool showCheck: root._isMulti && delegateItem.isSelected
                                readonly property bool showIcon: delegateItem._iconCode !== "" && !showCheck
                                readonly property bool hasAnyIcon: showCheck || showIcon
                                
                                // Expand width to IconSize + dynamic padding (min 4px) to push text over
                                width: hasAnyIcon ? (spec.iconSize + (delegateItem._label !== "" ? Math.max(4, spec.gap) : 0)) : 0
                                height: spec.iconSize
                                anchors.verticalCenter: parent.verticalCenter
                                clip: true

                                Behavior on width { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }

                                Common.Icon {
                                    source: "check"
                                    size: spec.iconSize
                                    color: delegateItem._contentColor
                                    opacity: iconSlot.showCheck ? 1.0 : 0.0
                                    scale: iconSlot.showCheck ? 1.0 : 0.5
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Behavior on opacity { NumberAnimation { duration: 150 } }
                                    Behavior on scale { NumberAnimation { duration: 250; easing.type: Easing.OutBack } }
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }

                                Common.Icon {
                                    source: delegateItem._iconCode
                                    size: spec.iconSize
                                    color: delegateItem._contentColor
                                    opacity: iconSlot.showIcon ? 1.0 : 0.0
                                    scale: iconSlot.showIcon ? 1.0 : 0.5
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Behavior on opacity { NumberAnimation { duration: 150 } }
                                    Behavior on scale { NumberAnimation { duration: 250; easing.type: Easing.OutBack } }
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                }
                            }

                            Text {
                                text: delegateItem._label
                                visible: delegateItem._label !== ""
                                color: delegateItem._contentColor
                                font.family: Theme.ChiTheme.typography[spec.typo] ? Theme.ChiTheme.typography[spec.typo].family : Theme.ChiTheme.fontFamily
                                font.pixelSize: spec.fontSize
                                anchors.verticalCenter: parent.verticalCenter
                                Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.InOutQuad } }
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
