// SegmentedButton.qml - Material 3 Segmented Button
// Built strictly to M3 specs: 40dp height, 1dp outline, checkmark replacement

import QtQuick
import QtQuick.Effects
import "../../theme" as Theme
import "../common" as Common

Item {
    id: root

    // ─── Public API (Matches your ChiExtract app) ─────────────
    property var segments: []
    property string size: "medium"
    property string selectionMode: "single" // "single", "multi"
    property var selectedIndices: []
    property int selectedIndex: -1
    property bool enabled: true

    signal selectionChanged(var indices)

    // ─── Tokens ───────────────────────────────────────────────
    readonly property bool _isMulti: selectionMode === "multi"
    readonly property var spec: Theme.SizeSpecs.getSpec(Theme.SizeSpecs.segmentedButton, size)
    readonly property var colors: Theme.ChiTheme.colors
    readonly property var motion: Theme.ChiTheme.motion
    readonly property var typo: Theme.ChiTheme.typography

    implicitWidth: container.width
    implicitHeight: spec.height

    // ─── Logic ────────────────────────────────────────────────
    onSelectedIndexChanged: {
        if (!_isMulti && selectedIndices.indexOf(selectedIndex) === -1 && selectedIndex !== -1) {
            selectedIndices = [selectedIndex]
        }
    }

    function _isItemSelected(idx) { return selectedIndices.indexOf(idx) !== -1 }

    function _toggleItem(idx) {
        var sel = _isItemSelected(idx)
        var newIndices = selectedIndices.slice()

        if (!_isMulti) {
            newIndices = [idx]
            selectedIndex = idx
        } else {
            var iMulti = newIndices.indexOf(idx)
            if (iMulti !== -1) newIndices.splice(iMulti, 1)
            else newIndices.push(idx)
        }

        selectedIndices = newIndices
        selectionChanged(selectedIndices)
    }

    // ─── Visual Container ─────────────────────────────────────
    Rectangle {
        id: container
        height: spec.height
        width: segmentRow.implicitWidth
        radius: height / 2
        color: "transparent"
        border.width: spec.outlineWidth
        border.color: colors.outline

        Row {
            id: segmentRow
            anchors.fill: parent

            Repeater {
                model: root.segments
                delegate: Item {
                    id: wrapper
                    property bool isFirst: index === 0
                    property bool isLast: index === root.segments.length - 1
                    property bool isSelected: root._isItemSelected(index)

                    property string _label: (typeof modelData === "string") ? modelData : (modelData.text || "")
                    property string _iconCode: (typeof modelData === "object" && modelData.icon) ? modelData.icon : ""

                    // M3 Spec: "When using both icons and label text... icon is replaced by checkmark"
                    // If no text is present (icon-only), we DO NOT swap to checkmark, we just highlight background.
                    property bool hasText: _label !== ""
                    property bool showCheck: isSelected && hasText
                    property string activeIcon: showCheck ? "check" : _iconCode
                    property bool showIcon: activeIcon !== ""

                    width: contentRow.implicitWidth + (spec.padding * 2)
                    height: spec.height

                    Rectangle {
                        id: bgRect
                        anchors.fill: parent
                        color: isSelected ? colors.secondaryContainer : "transparent"

                        topLeftRadius: isFirst ? container.radius : 0
                        bottomLeftRadius: isFirst ? container.radius : 0
                        topRightRadius: isLast ? container.radius : 0
                        bottomRightRadius: isLast ? container.radius : 0

                        Behavior on color { enabled: motion.animationsEnabled; ColorAnimation { duration: motion.durationFast } }

                        Common.StateLayer {
                            layerColor: isSelected ? colors.onSecondaryContainer : colors.onSurface
                            containerRadius: bgRect.topLeftRadius
                            pressed: wrapperMouse.pressed
                            hovered: wrapperMouse.containsMouse
                            enabled: root.enabled
                        }

                        Common.Ripple {
                            color: isSelected ? colors.onSecondaryContainer : colors.onSurface
                            radius: bgRect.topLeftRadius
                            enabled: root.enabled
                        }

                        Row {
                            id: contentRow
                            anchors.centerIn: parent
                            spacing: spec.gap

                            Common.Icon {
                                visible: showIcon
                                source: activeIcon
                                size: spec.iconSize
                                color: isSelected ? colors.onSecondaryContainer : colors.onSurface
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Text {
                                visible: hasText
                                text: _label
                                font.family: typo.labelLarge.family
                                font.weight: typo.labelLarge.weight
                                font.pixelSize: typo.labelLarge.size
                                color: isSelected ? colors.onSecondaryContainer : colors.onSurface
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }

                    // M3: 1dp outline divider between segments
                    Rectangle {
                        width: spec.outlineWidth
                        height: parent.height
                        anchors.right: parent.right
                        color: colors.outline
                        visible: !isLast
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
