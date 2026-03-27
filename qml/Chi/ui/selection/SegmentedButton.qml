// SegmentedButton.qml — Material 3 Segmented Button
//
// Spec-exact implementation:
//  • Each segment has its own 1px outline border
//  • Segments overlap by 1px (stacking via z/x offset) so borders merge
//  • First segment: topLeft/bottomLeft radius = 20px, right side = 0
//  • Middle segments: all radii = 0
//  • Last segment: topRight/bottomRight radius = 20px, left side = 0
//  • Container height = 40px (inner), touch target = 48px (4px vertical pad)
//  • Selected fill = secondaryContainer, no fill when unselected
//  • Divider between segments hides when either neighbour is selected
//  • Check icon (18×18) animates in on selection, pushes label right
//  • State layer: onSecondaryContainer@0.08 hover / @0.10 press (selected)
//                onSurface@0.08 hover / @0.10 press (unselected)
//  • Focus ring: 3px outline border on the container rect
//  • Disabled: entire group @ 0.38 opacity
//
// Performance:
//  • Zero JS in render loop — all geometry is pure property bindings
//  • No Loader / dynamic creation
//  • Behaviors only on state transitions (color, opacity, width)
//  • Per-corner radius via native Qt 6.7+ Rectangle properties (no Shape)
//  • Single MouseArea per segment

import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme
import "../common" as Common

Item {
    id: root

    // ═══════════════════════════════════════════════════════
    //  PUBLIC API
    // ═══════════════════════════════════════════════════════

    // Single-select mode
    property int selectedIndex: 0

    // Multi-select mode
    property bool multiSelect: false
    property var  selectedIndices: [0]

    // Segment descriptors: [{text: "", icon: ""}]
    // icon is a Material Icons codepoint string e.g. "\uE405"
    property var segments: []

    property bool   enabled: true
    property string size: "medium"   // small | medium | large

    signal selectionChanged(var indices)

    // ═══════════════════════════════════════════════════════
    //  THEME
    // ═══════════════════════════════════════════════════════

    readonly property var    colors:     Theme.ChiTheme.colors
    readonly property var    motion:     Theme.ChiTheme.motion
    readonly property string fontFamily: Theme.ChiTheme.fontFamily
    readonly property string iconFamily: Theme.ChiTheme.iconFamily

    // ═══════════════════════════════════════════════════════
    //  SIZE TOKENS  (from Figma spec + M3 spec)
    //
    //  Container height:  40dp  (inner visual)
    //  Touch target:      48dp  (4dp top + 4dp bottom padding)
    //  Border radius:     20dp  (full pill on outer corners)
    //  Border width:       1dp
    //  Horizontal padding: 12dp (state-layer / content)
    //  Icon size:          18dp
    //  Check icon size:    18dp
    //  Icon-label gap:      8dp
    //  Font:               labelLarge (14sp, weight 500, spacing 0.1)
    // ═══════════════════════════════════════════════════════

    readonly property real _containerH:  size === "small" ? 32 : (size === "large" ? 48 : 40)
    readonly property real _touchH:      _containerH + 8   // 4dp pad each side
    readonly property real _outerR:      _containerH / 2   // full pill
    readonly property real _hPad:        12
    readonly property real _iconSz:      18
    readonly property real _checkSz:     18
    readonly property real _iconGap:     8
    readonly property real _borderW:     1
    readonly property real _fontSize:    size === "small" ? 12 : (size === "large" ? 16 : 14)

    // ═══════════════════════════════════════════════════════
    //  ROOT GEOMETRY
    // ═══════════════════════════════════════════════════════

    implicitHeight: _touchH
    implicitWidth:  _row.implicitWidth

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity {
        NumberAnimation { duration: motion.durationMedium; easing.type: Easing.OutCubic }
    }

    // ═══════════════════════════════════════════════════════
    //  SELECTION HELPERS
    // ═══════════════════════════════════════════════════════

    function _isSelected(idx) {
        return multiSelect
               ? selectedIndices.indexOf(idx) !== -1
               : selectedIndex === idx
    }

    function _activate(idx) {
        if (!enabled) return
        if (multiSelect) {
            var arr = selectedIndices.slice()
            var pos = arr.indexOf(idx)
            if (pos !== -1) {
                if (arr.length > 1) arr.splice(pos, 1)   // keep at least 1
            } else {
                arr.push(idx)
                arr.sort(function(a,b){ return a - b })
            }
            selectedIndices = arr
        } else {
            selectedIndex = idx
            selectedIndices = [idx]
        }
        selectionChanged(selectedIndices)
    }

    // ═══════════════════════════════════════════════════════
    //  SEGMENT ROW
    // ═══════════════════════════════════════════════════════

    Row {
        id: _row
        anchors.centerIn: parent
        spacing: 0      // segments touch; border overlap handled by x offset

        Repeater {
            model: segments

            // ─── Per-segment delegate ──────────────────────
            Item {
                id: seg
                required property var  modelData
                required property int  index

                // Derived state — all pure bindings, no JS in hot path
                readonly property bool isFirst:    index === 0
                readonly property bool isLast:     index === segments.length - 1
                readonly property bool isMiddle:   !isFirst && !isLast
                readonly property bool isSel:      root._isSelected(index)
                readonly property bool prevSel:    index > 0 && root._isSelected(index - 1)
                readonly property bool hasIcon:    modelData.icon !== undefined
                                                   && modelData.icon !== ""
                readonly property bool hasText:    modelData.text !== undefined
                                                   && modelData.text !== ""

                // Content width: hPad + [check] + [gap] + [icon] + [gap] + [label] + hPad
                readonly property real _checkW:   isSel ? _checkSz : 0
                readonly property real _checkGap: (isSel && (hasIcon || hasText)) ? _iconGap : 0
                readonly property real _iconW:    hasIcon ? _iconSz : 0
                readonly property real _iconGapW: (hasIcon && hasText) ? _iconGap : 0

                implicitWidth:  _hPad + _checkW + _checkGap + _iconW + _iconGapW
                                + _labelText.implicitWidth + _hPad
                height: _touchH

                // Segments overlap by 1px to merge borders cleanly:
                //   first segment natural position
                //   every subsequent segment shifts left 1px
                x: isFirst ? 0 : -_borderW * index

                // Bring selected / hovered segment to front so its border
                // paints over the neighbour's border
                z: isSel ? 2 : (segMa.containsMouse ? 1 : 0)

                // ── CONTAINER RECTANGLE ─────────────────────
                Rectangle {
                    id: _container
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter:   parent.verticalCenter
                    width:  parent.width
                    height: _containerH

                    // Per-corner radius: pill on outer corners only
                    topLeftRadius:     isFirst  ? _outerR : 0
                    bottomLeftRadius:  isFirst  ? _outerR : 0
                    topRightRadius:    isLast   ? _outerR : 0
                    bottomRightRadius: isLast   ? _outerR : 0

                    // Fill
                    color: seg.isSel ? colors.secondaryContainer : "transparent"
                    Behavior on color {
                        ColorAnimation {
                            duration: motion.durationFast
                            easing.type: Easing.OutCubic
                        }
                    }

                    // Border — every segment owns its own full border
                    border.width: _borderW
                    border.color: colors.outline
                    Behavior on border.color {
                        ColorAnimation { duration: motion.durationMedium }
                    }

                    // ── STATE LAYER ──────────────────────────
                    Rectangle {
                        anchors.fill: parent
                        topLeftRadius:     isFirst ? _outerR : 0
                        bottomLeftRadius:  isFirst ? _outerR : 0
                        topRightRadius:    isLast  ? _outerR : 0
                        bottomRightRadius: isLast  ? _outerR : 0

                        // Spec color tokens:
                        //   selected:   onSecondaryContainer
                        //   unselected: onSurface
                        color: seg.isSel
                               ? Qt.rgba(colors.onSecondaryContainer.r,
                                         colors.onSecondaryContainer.g,
                                         colors.onSecondaryContainer.b, 1)
                               : Qt.rgba(colors.onSurface.r,
                                         colors.onSurface.g,
                                         colors.onSurface.b, 1)

                        opacity: !root.enabled ? 0
                                 : segMa.pressed ? 0.10
                                 : (seg.activeFocus ? 0.10
                                 : (segMa.containsMouse ? 0.08 : 0))

                        Behavior on opacity {
                            NumberAnimation {
                                duration: segMa.pressed
                                          ? motion.durationFast
                                          : motion.durationMedium
                                easing.type: Easing.OutCubic
                            }
                        }

                        Behavior on color {
                            ColorAnimation { duration: motion.durationFast }
                        }
                    }

                    // ── FOCUS RING ───────────────────────────
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -3
                        topLeftRadius:     isFirst ? _outerR + 3 : 0
                        bottomLeftRadius:  isFirst ? _outerR + 3 : 0
                        topRightRadius:    isLast  ? _outerR + 3 : 0
                        bottomRightRadius: isLast  ? _outerR + 3 : 0
                        color: "transparent"
                        border.width: 3
                        border.color: colors.secondary
                        visible: seg.activeFocus && !segMa.pressed
                        z: 10
                    }

                    // ── CONTENT ROW ──────────────────────────
                    Row {
                        anchors.centerIn: parent
                        spacing: 0      // gaps managed by Behavior widths below

                        // Check icon (animates in on selection)
                        Item {
                            width: seg.isSel ? _checkSz : 0
                            height: _containerH
                            clip: true

                            Behavior on width {
                                NumberAnimation {
                                    duration: motion.durationMedium
                                    easing.type: Easing.OutCubic
                                }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: "\uE876"   // check
                                font.family: iconFamily
                                font.pixelSize: _checkSz
                                color: colors.onSecondaryContainer

                                Behavior on color {
                                    ColorAnimation { duration: motion.durationFast }
                                }
                            }
                        }

                        // Gap between check and icon/label
                        Item {
                            width: (seg.isSel && (seg.hasIcon || seg.hasText))
                                   ? _iconGap : 0
                            height: 1

                            Behavior on width {
                                NumberAnimation {
                                    duration: motion.durationMedium
                                    easing.type: Easing.OutCubic
                                }
                            }
                        }

                        // Icon (optional)
                        Text {
                            visible: seg.hasIcon
                            text:    seg.hasIcon ? modelData.icon : ""
                            font.family: iconFamily
                            font.pixelSize: _iconSz
                            height: _containerH
                            verticalAlignment: Text.AlignVCenter
                            color: seg.isSel ? colors.onSecondaryContainer
                                             : colors.onSurface

                            Behavior on color {
                                ColorAnimation { duration: motion.durationFast }
                            }
                        }

                        // Gap between icon and label
                        Item {
                            visible: seg.hasIcon && seg.hasText
                            width: _iconGap
                            height: 1
                        }

                        // Label
                        Text {
                            id: _labelText
                            visible: seg.hasText
                            text:    seg.hasText ? modelData.text : ""
                            font.family:        fontFamily
                            font.pixelSize:     _fontSize
                            font.weight:        Font.Medium
                            font.letterSpacing: 0.1
                            height: _containerH
                            verticalAlignment: Text.AlignVCenter
                            color: seg.isSel ? colors.onSecondaryContainer
                                             : colors.onSurface

                            Behavior on color {
                                ColorAnimation { duration: motion.durationFast }
                            }
                        }
                    }
                }

                // ── DIVIDER ───────────────────────────────────
                // Spec: divider hidden when this segment OR its left
                // neighbour is selected. It lives on the left edge of
                // every non-first segment, inset 8dp top/bottom.
                Rectangle {
                    visible: !seg.isFirst
                    x: 0
                    anchors.verticalCenter: parent.verticalCenter
                    width: _borderW
                    height: _containerH - 16    // 8dp inset each side
                    color: colors.outline

                    // Hide when this or left neighbour is selected
                    opacity: (seg.isSel || seg.prevSel) ? 0 : 1
                    Behavior on opacity {
                        NumberAnimation {
                            duration: motion.durationFast
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                // ── INPUT ─────────────────────────────────────
                MouseArea {
                    id: segMa
                    anchors.fill: parent
                    enabled:      root.enabled
                    hoverEnabled: true
                    cursorShape:  root.enabled ? Qt.PointingHandCursor
                                              : Qt.ArrowCursor
                    onClicked:    root._activate(index)
                }

                // ── KEYBOARD ──────────────────────────────────
                Keys.onSpacePressed:  root._activate(index)
                Keys.onReturnPressed: root._activate(index)
                Keys.onEnterPressed:  root._activate(index)

                focusPolicy: Qt.TabFocus
                activeFocusOnTab: true

                Accessible.role:        Accessible.Button
                Accessible.name:        seg.hasText ? modelData.text : ""
                Accessible.checkable:   true
                Accessible.checked:     seg.isSel
                Accessible.onPressAction: root._activate(index)
            }
        }
    }

    Accessible.role: Accessible.ButtonGroup
    Accessible.name: "Segmented button group"
}
