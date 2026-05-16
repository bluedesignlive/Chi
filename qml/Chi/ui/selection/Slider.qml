// Slider.qml — Material 3 Expressive Standard Slider
// Supports: continuous / discrete, 5 size variants (xs–xl),
//           horizontal / vertical, value indicator, inset icon
import QtQuick
import "../../theme" as Theme

Item {
    id: root

    // ═════════════════════════════════════════════════════════
    //  PUBLIC API
    // ═════════════════════════════════════════════════════════

    property real  value: 0
    property real  from:  0
    property real  to:    100
    property real  stepSize: 0
    property bool  enabled: true

    // "xs" | "small" | "medium" | "large" | "xl"
    property string size: "xs"

    // "horizontal" | "vertical"
    property string orientation: "horizontal"

    // "never" | "onDrag" | "always"
    property string showValueIndicator: "never"

    // Discrete stops (auto-shown when stepSize > 0, or force)
    property bool showStops: stepSize > 0

    // Material-icon codepoint for inset icon (medium / large / xl only)
    property string icon: ""

    // Custom label formatter — return a string.  Default: round(value).
    property var labelFormatter: null

    signal moved()

    // ═════════════════════════════════════════════════════════
    //  THEME
    // ═════════════════════════════════════════════════════════

    readonly property var colors: Theme.ChiTheme.colors

    // ═════════════════════════════════════════════════════════
    //  ORIENTATION
    // ═════════════════════════════════════════════════════════

    readonly property bool _isHoriz: orientation !== "vertical"

    implicitWidth:  _isHoriz ? 354 : _handleH
    implicitHeight: _isHoriz ? _handleH : 354

    // ═════════════════════════════════════════════════════════
    //  NORMALISED VALUE  [0 … 1]
    // ═════════════════════════════════════════════════════════

    readonly property real _range: to - from
    readonly property real _norm: {
        if (_range <= 0) return 0
        var n = (value - from) / _range
        return n < 0 ? 0 : (n > 1 ? 1 : n)
    }

    // ═════════════════════════════════════════════════════════
    //  SIZE TABLE  (all values in dp — one switch per metric)
    // ═════════════════════════════════════════════════════════

    readonly property real _trackH: {
        switch (size) {
        case "small":  return 24
        case "medium": return 40
        case "large":  return 56
        case "xl":     return 96
        default:       return 16            // xs
        }
    }
    readonly property real _handleH: {
        switch (size) {
        case "medium": return 52
        case "large":  return 68
        case "xl":     return 108
        default:       return 44            // xs, small
        }
    }
    readonly property real _outerR: {
        switch (size) {
        case "small":  return 8
        case "medium": return 12
        case "large":  return 16
        case "xl":     return 28
        default:       return 16            // xs
        }
    }
    readonly property real _iconSz: {
        switch (size) {
        case "medium": return 24
        case "large":  return 24
        case "xl":     return 32
        default:       return 0             // xs, small — no icon
        }
    }

    readonly property real _innerR:     2
    readonly property real _gap:        6
    readonly property real _endPad:     4
    readonly property real _stopDotSz:  4

    // Handle width: 4 dp normally, 2 dp while pressed
    readonly property real _handleW: _pressed ? 2 : 4
    readonly property bool _pressed: mouseArea.pressed && enabled

    // ═════════════════════════════════════════════════════════
    //  LAYOUT GEOMETRY  (pure bindings — no JS functions)
    //
    //  General case (0 < norm < 1):
    //    [activeW] [6 gap] [handle] [6 gap] [inactiveW]
    //
    //  At min (norm == 0):
    //    [4 pad] [handle] [6 gap] [inactiveW]
    //
    //  At max (norm == 1):
    //    [activeW] [6 gap] [handle] [4 pad]
    // ═════════════════════════════════════════════════════════

    readonly property real _railW: _isHoriz ? width : height

    readonly property bool _atMin: _norm <= 0
    readonly property bool _atMax: _norm >= 1

    readonly property real _leftPad:  _atMin ? _endPad : 0
    readonly property real _rightPad: _atMax ? _endPad : 0
    readonly property real _leftGap:  _atMin ? 0 : _gap
    readonly property real _rightGap: _atMax ? 0 : _gap

    readonly property real _trackSpace:
        _railW - _leftPad - _rightPad - _leftGap - _rightGap - _handleW

    readonly property real _activeW:
        _atMin ? 0 : (_atMax ? _trackSpace : _trackSpace * _norm)

    readonly property real _inactiveW:
        _atMax ? 0 : (_atMin ? _trackSpace : _trackSpace * (1 - _norm))

    readonly property real _handleX:
        _leftPad + _activeW + _leftGap

    // ── Drag-mapping anchors (stable, independent of press) ─
    readonly property real _dragMin:   _endPad + 2      // half normal handle
    readonly property real _dragMax:   _railW - _endPad - 2
    readonly property real _dragRange: _dragMax - _dragMin

    // ── Stop helpers ────────────────────────────────────────
    readonly property int _stopCount:
        (stepSize > 0 && _range > 0)
            ? Math.round(_range / stepSize) + 1
            : 0

    // ═════════════════════════════════════════════════════════
    //  ROTATOR  (content is always horizontal; rotated for vert)
    // ═════════════════════════════════════════════════════════

    Item {
        id: content
        width:  _isHoriz ? root.width  : root.height
        height: _isHoriz ? root.height : root.width
        anchors.centerIn: parent
        rotation: _isHoriz ? 0 : -90

        // ─────────────────────────────────────────────────────
        //  ACTIVE TRACK
        // ─────────────────────────────────────────────────────

        Rectangle {
            id: activeTrack
            x:      _leftPad
            width:  _activeW
            height: _trackH
            anchors.verticalCenter: parent.verticalCenter
            visible: !_atMin

            topLeftRadius:     _outerR
            topRightRadius:    _innerR
            bottomRightRadius: _innerR
            bottomLeftRadius:  _outerR

            color:   root.enabled ? colors.primary : colors.onSurface
            opacity: root.enabled ? 1 : 0.38

            Behavior on color {
                ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
            }

            // ── Optional inset icon ─────────────────────────
            Text {
                visible: root.icon !== "" && _iconSz > 0
                         && activeTrack.width > (_iconSz + 16)
                anchors.verticalCenter: parent.verticalCenter
                x: 8
                text: root.icon
                font.family: Theme.ChiTheme.iconFamily
                font.pixelSize: _iconSz
                color: colors.onPrimary
                opacity: root.enabled ? 1 : 0.38
                Behavior on color {
                    ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
                }
            }
        }

        // ─────────────────────────────────────────────────────
        //  HANDLE
        // ─────────────────────────────────────────────────────

        Rectangle {
            id: handle
            x:      _handleX
            width:  _handleW
            height: _handleH
            anchors.verticalCenter: parent.verticalCenter
            radius: 2

            color:   root.enabled ? colors.primary : colors.onSurface
            opacity: root.enabled ? 1 : 0.38

            Behavior on width {
                NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
            }
            Behavior on color {
                ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
            }

            // ── State layer (fills handle rect) ─────────────
            Rectangle {
                anchors.fill: parent
                radius: 4
                visible: opacity > 0
                color: Qt.rgba(1, 1, 1, 1)

                opacity: {
                    if (!root.enabled)       return 0
                    if (mouseArea.pressed)   return 0.10
                    if (root.activeFocus)    return 0.12
                    if (mouseArea.containsMouse) return 0.08
                    return 0
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: mouseArea.pressed ? 50 : 150
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }

        // ─────────────────────────────────────────────────────
        //  INACTIVE TRACK
        // ─────────────────────────────────────────────────────

        Rectangle {
            id: inactiveTrack
            x:      _handleX + _handleW + _rightGap
            width:  _inactiveW
            height: _trackH
            anchors.verticalCenter: parent.verticalCenter
            visible: !_atMax

            topLeftRadius:     _innerR
            topRightRadius:    _outerR
            bottomRightRadius: _outerR
            bottomLeftRadius:  _innerR

            color: root.enabled
                   ? colors.secondaryContainer
                   : Qt.rgba(colors.onSurface.r,
                             colors.onSurface.g,
                             colors.onSurface.b, 0.12)

            Behavior on color {
                ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
            }

            // ── End-stop dot (right edge, 4 dp inset) ───────
            Rectangle {
                width:  _stopDotSz
                height: _stopDotSz
                radius: _stopDotSz * 0.5
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 4
                visible: inactiveTrack.width >= 12

                color:   root.enabled
                         ? colors.onSecondaryContainer
                         : colors.onSurface
                opacity: root.enabled ? 1 : 0.38
            }
        }

        // ─────────────────────────────────────────────────────
        //  START-STOP DOT (left edge of active track)
        // ─────────────────────────────────────────────────────

        Rectangle {
            width:  _stopDotSz
            height: _stopDotSz
            radius: _stopDotSz * 0.5
            anchors.verticalCenter: parent.verticalCenter
            x: _leftPad + 4
            visible: !_atMin && activeTrack.width >= 12

            color:   root.enabled
                     ? colors.onPrimary
                     : colors.onSurface
            opacity: root.enabled ? 1 : 0.38
        }

        // ─────────────────────────────────────────────────────
        //  DISCRETE STOPS OVERLAY
        // ─────────────────────────────────────────────────────

        Item {
            id: stopsOverlay
            visible: root.showStops && _stopCount > 2
            anchors.verticalCenter: parent.verticalCenter
            x: 0; width: content.width; height: _stopDotSz

            Repeater {
                model: stopsOverlay.visible ? _stopCount : 0

                Rectangle {
                    id: stopDot
                    required property int index

                    readonly property real _stopNorm:
                        _stopCount > 1 ? index / (_stopCount - 1) : 0

                    readonly property bool _inActive: _stopNorm <= _norm

                    x: _dragMin + _stopNorm * _dragRange - _stopDotSz * 0.5

                    width:  _stopDotSz
                    height: _stopDotSz
                    radius: _stopDotSz * 0.5
                    anchors.verticalCenter: parent.verticalCenter

                    color: _inActive
                           ? colors.surfaceContainerHighest
                           : colors.primary

                    opacity: root.enabled ? 1 : 0.38

                    visible: {
                        var cx = x + _stopDotSz * 0.5
                        var hx = handle.x + handle.width * 0.5
                        return Math.abs(cx - hx) > (handle.width * 0.5 + 6)
                    }
                }
            }
        }

        // ─────────────────────────────────────────────────────
        //  VALUE INDICATOR
        // ─────────────────────────────────────────────────────

        Item {
            id: indicatorAnchor
            width: 0; height: 0
            x: handle.x + handle.width * 0.5
            y: -4

            Rectangle {
                id: valueIndicator
                readonly property bool _show:
                    root.enabled && (
                        showValueIndicator === "always"
                        || (showValueIndicator === "onDrag" && mouseArea.pressed)
                    )

                width:  Math.max(48, indicatorLabel.implicitWidth + 32)
                height: 44
                radius: 1000
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.top

                color: colors.inverseSurface

                scale:   _show ? 1.0 : 0.6
                opacity: _show ? 1.0 : 0.0
                visible: opacity > 0
                transformOrigin: Item.Bottom

                Behavior on scale {
                    NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                }
                Behavior on opacity {
                    NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                }

                Text {
                    id: indicatorLabel
                    anchors.centerIn: parent
                    text: root.labelFormatter
                          ? root.labelFormatter(root.value)
                          : Math.round(root.value).toString()
                    font.family:        Theme.ChiTheme.fontFamily
                    font.pixelSize:     14
                    font.weight:        Font.Medium
                    font.letterSpacing: 0.1
                    color: colors.inverseOnSurface
                }
            }
        }

        // ─────────────────────────────────────────────────────
        //  MOUSE / TOUCH INPUT
        // ─────────────────────────────────────────────────────

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            anchors.topMargin:    Math.min(0, -(48 - parent.height) * 0.5)
            anchors.bottomMargin: Math.min(0, -(48 - parent.height) * 0.5)
            enabled:      root.enabled
            hoverEnabled: true
            cursorShape:  root.enabled ? Qt.PointingHandCursor
                                       : Qt.ArrowCursor

            onPressed:         function(mouse) { _update(mouse.x) }
            onPositionChanged: function(mouse) { if (pressed) _update(mouse.x) }

            function _update(mx) {
                if (_dragRange <= 0) return
                var n = (mx - _dragMin) / _dragRange
                n = n < 0 ? 0 : (n > 1 ? 1 : n)

                var raw = from + n * _range
                if (stepSize > 0)
                    raw = Math.round((raw - from) / stepSize) * stepSize + from
                raw = raw < from ? from : (raw > to ? to : raw)

                if (root.value !== raw) {
                    root.value = raw
                    root.moved()
                }
            }
        }
    }

    // ═════════════════════════════════════════════════════════
    //  KEYBOARD
    // ═════════════════════════════════════════════════════════

    activeFocusOnTab: true
    focusPolicy:      Qt.StrongFocus

    Keys.onLeftPressed:   if (enabled) _step(-1)
    Keys.onRightPressed:  if (enabled) _step( 1)
    Keys.onDownPressed:   if (enabled) _step(-1)
    Keys.onUpPressed:     if (enabled) _step( 1)

    Keys.onPressed: function(event) {
        if (!enabled) return
        if (event.key === Qt.Key_Home) {
            value = from
            moved()
            event.accepted = true
        } else if (event.key === Qt.Key_End) {
            value = to
            moved()
            event.accepted = true
        }
    }

    function _step(dir) {
        var s = stepSize > 0 ? stepSize : _range / 20
        var raw = value + dir * s
        raw = raw < from ? from : (raw > to ? to : raw)
        if (value !== raw) { value = raw; moved() }
    }

    // ═════════════════════════════════════════════════════════
    //  ACCESSIBILITY
    // ═════════════════════════════════════════════════════════

    Accessible.role: Accessible.Slider
    Accessible.name: "Slider"
    Accessible.description: Math.round(value) + " of " + Math.round(to)
}
