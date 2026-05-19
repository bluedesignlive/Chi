// Tooltip.qml — Material 3 Plain & Rich Tooltip
//
// Plain (rich:false):  rounded rect, inverseSurface, no caret
// Rich  (rich:true):   rounded rect with canvas caret, surfaceContainer
//
// M3 Timings (WYSIWYG):
//   Hover delay  → 300ms initial, 0ms hot state (ready:true)
//   Entry        → 150ms emphasizedDecelerate, scale 0.8→1, opacity 0→1
//   Exit         → 100ms emphasizedAccelerate, opacity 1→0 (no scale)
//
// Caret:
//   Canvas triangle, overlaps body by 3px for seamless join.
//   Both body + caret are children of the same animated container.
//   transformOrigin targets the edge nearest the trigger so the
//   tooltip appears to grow FROM the trigger element.

import QtQuick
import QtQuick.Effects
import "../../theme" as Theme

Item {
    id: root

    // ═══════════════════════════════════════════════════════════
    //  PUBLIC API
    // ═══════════════════════════════════════════════════════════

    property string text: ""
    property Item target: null
    property string position: "bottom"           // top | bottom | left | right
    property int delay: 300                       // M3 spec: 300ms
    property int showDuration: 0
    property bool rich: false
    property bool showCaret: false                // M3 plain = no caret
    property bool ready: false                    // true → skip delay (group hot)
    property Item positionTarget: null

    readonly property bool isVisible: state === "visible"
    signal shown

    // ═══════════════════════════════════════════════════════════
    //  THEME
    // ═══════════════════════════════════════════════════════════

    property var colors: Theme.ChiTheme.colors
    readonly property var _plainTypo: Theme.ChiTheme.typography.bodySmall
    readonly property var _richTypo:  Theme.ChiTheme.typography.bodyMedium

    // ═══════════════════════════════════════════════════════════
    //  CARET GEOMETRY
    // ═══════════════════════════════════════════════════════════
    //
    //  The caret is a Canvas triangle that OVERLAPS the body by
    //  _caretOverlap pixels. This hides the seam — the body draws
    //  on top of the overlap region, so only the triangular tip
    //  extending beyond the body is visible.
    //
    //  _caretH (7) total:  3px overlap (hidden) + 4px visible tip
    //  _caretW (12):       base width of the triangle
    // ═══════════════════════════════════════════════════════════

    readonly property int _caretW: 12
    readonly property int _caretH: 7
    readonly property int _caretOverlap: 3
    readonly property bool _caretHori: position === "left" || position === "right"
    readonly property real _caretExt: showCaret ? (_caretH - _caretOverlap) : 0

    // Implicit size = body only (backward compatible with callers
    // that set root.x/root.y based on width/height)
    implicitWidth: _body.width
    implicitHeight: _body.height

    visible: false
    z: 2000

    // ═══════════════════════════════════════════════════════════
    //  STATE MACHINE
    // ═══════════════════════════════════════════════════════════

    onTextChanged: {
        if (text === "" && state === "visible")
            _cancelAndHide();
    }

    state: "hidden"

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: _container
                opacity: 0
                scale: 0.8
            }
            PropertyChanges {
                target: root
                visible: false
            }
        },
        State {
            name: "visible"
            PropertyChanges {
                target: _container
                opacity: 1
                scale: 1
            }
            PropertyChanges {
                target: root
                visible: true
            }
        }
    ]

    onStateChanged: {
        if (state === "visible")
            shown();
    }

    // ═══════════════════════════════════════════════════════════
    //  TRANSITIONS
    //
    //  Entry: 150ms, scale 0.8→1 + opacity 0→1 (parallel)
    //  Exit:  100ms, opacity 1→0 only (no scale on exit per M3)
    //
    //  Both body and caret animate together because they are
    //  children of _container which owns the scale/opacity.
    // ═══════════════════════════════════════════════════════════

    transitions: [
        Transition {
            from: "hidden"
            to: "visible"
            enabled: Theme.ChiMotion.animationsEnabled
            SequentialAnimation {
                PropertyAction {
                    property: "visible"
                    value: true
                }
                ParallelAnimation {
                    NumberAnimation {
                        target: _container
                        property: "opacity"
                        duration: Theme.ChiMotion.entry.duration    // 150ms
                        easing.type: Easing.Bezier
                        easing.bezierCurve: Theme.ChiMotion.entry.curve
                    }
                    NumberAnimation {
                        target: _container
                        property: "scale"
                        duration: Theme.ChiMotion.entry.duration
                        easing.type: Easing.Bezier
                        easing.bezierCurve: Theme.ChiMotion.entry.curve
                    }
                }
            }
        },
        Transition {
            from: "visible"
            to: "hidden"
            enabled: Theme.ChiMotion.animationsEnabled
            SequentialAnimation {
                NumberAnimation {
                    target: _container
                    property: "opacity"
                    duration: Theme.ChiMotion.exit.duration         // 100ms
                    easing.type: Easing.Bezier
                    easing.bezierCurve: Theme.ChiMotion.exit.curve
                }
                PropertyAction {
                    property: "visible"
                    value: false
                }
            }
        }
    ]

    // ═══════════════════════════════════════════════════════════
    //  VISUAL TREE
    //
    //  _container is offset so the body stays at the root origin.
    //  The caret extends beyond the root bounds (visible because
    //  clip defaults to false).
    //
    //  transformOrigin is set to the edge closest to the trigger:
    //    "bottom" → Top    (tooltip grows downward from trigger)
    //    "top"    → Bottom (tooltip grows upward from trigger)
    //    "left"   → Right
    //    "right"  → Left
    //  This keeps the caret tip stable during the scale-in.
    // ═══════════════════════════════════════════════════════════

    Item {
        id: _container

        // Offset: caret extends beyond root bounds
        x: (root.showCaret && root.position === "right") ? -root._caretExt : 0
        y: (root.showCaret && root.position === "bottom") ? -root._caretExt : 0

        width:  root._caretHori ? _body.width  + (root.showCaret ? root._caretExt : 0) : _body.width
        height: root._caretHori ? _body.height : _body.height + (root.showCaret ? root._caretExt : 0)

        transformOrigin: {
            if (!root.showCaret) return Item.Center;
            switch (root.position) {
            case "bottom": return Item.Top;
            case "top":    return Item.Bottom;
            case "left":   return Item.Right;
            case "right":  return Item.Left;
            }
            return Item.Center;
        }

        // ── Caret (Canvas, drawn BEHIND body) ──
        //
        //  Canvas draws a proper triangle — no rotated-square
        //  artifacts, no sharp side corners, no border seams.
        //  The body overlaps the bottom 3px (for "bottom" pos)
        //  so the join is invisible.

        Canvas {
            id: _caret
            visible: root.showCaret
            width:  root._caretHori ? root._caretH : root._caretW
            height: root._caretHori ? root._caretW : root._caretH
            antialiasing: true
            smooth: true

            property color fillColor: root.rich
                ? root.colors.surfaceContainer
                : root.colors.inverseSurface

            onFillColorChanged: requestPaint()
            Component.onCompleted: requestPaint()

            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.fillStyle = fillColor;
                ctx.beginPath();

                switch (root.position) {
                case "bottom":
                    // △  Points UP toward trigger
                    ctx.moveTo(width / 2, 0);
                    ctx.lineTo(0, height);
                    ctx.lineTo(width, height);
                    break;
                case "top":
                    // ▽  Points DOWN toward trigger
                    ctx.moveTo(0, 0);
                    ctx.lineTo(width, 0);
                    ctx.lineTo(width / 2, height);
                    break;
                case "left":
                    // ▷  Points RIGHT toward trigger
                    ctx.moveTo(0, 0);
                    ctx.lineTo(width, height / 2);
                    ctx.lineTo(0, height);
                    break;
                case "right":
                    // ◁  Points LEFT toward trigger
                    ctx.moveTo(width, 0);
                    ctx.lineTo(0, height / 2);
                    ctx.lineTo(width, height);
                    break;
                }

                ctx.closePath();
                ctx.fill();
            }

            // Smooth slide when caret repositions between elements
            // (e.g., moving between traffic light buttons)
            Behavior on x {
                enabled: Theme.ChiMotion.animationsEnabled
                NumberAnimation {
                    duration: Theme.ChiMotion.spring.fast.effects.duration
                    easing.type: Easing.Bezier
                    easing.bezierCurve: Theme.ChiMotion.spring.fast.effects.curve
                }
            }
            Behavior on y {
                enabled: Theme.ChiMotion.animationsEnabled
                NumberAnimation {
                    duration: Theme.ChiMotion.spring.fast.effects.duration
                    easing.type: Easing.Bezier
                    easing.bezierCurve: Theme.ChiMotion.spring.fast.effects.curve
                }
            }
        }

        // ── Body (drawn ON TOP of caret to hide overlap) ──

        Rectangle {
            id: _body
            x: (root.showCaret && root.position === "right")  ? root._caretExt : 0
            y: (root.showCaret && root.position === "bottom") ? root._caretExt : 0
            width: root.rich
                ? _richLabel.implicitWidth + 24
                : _plainLabel.implicitWidth + 16
            height: root.rich
                ? _richLabel.implicitHeight + 16
                : 24
            radius: root.rich ? 12 : 4
            color: root.rich
                ? root.colors.surfaceContainer
                : root.colors.inverseSurface

            Text {
                id: _plainLabel
                visible: !root.rich
                anchors.centerIn: parent
                text: root.text
                font.family: root._plainTypo.family
                font.pixelSize: root._plainTypo.size
                font.weight: root._plainTypo.weight
                font.letterSpacing: root._plainTypo.spacing || 0
                color: root.colors.inverseOnSurface
            }

            Text {
                id: _richLabel
                visible: root.rich
                anchors.centerIn: parent
                text: root.text
                font.family: root._richTypo.family
                font.pixelSize: root._richTypo.size
                font.weight: root._richTypo.weight
                font.letterSpacing: root._richTypo.spacing || 0
                color: root.colors.onSurface
                wrapMode: Text.WordWrap
                maximumLineCount: 4
            }
        }
    }

    // ═══════════════════════════════════════════════════════════
    //  TIMERS
    // ═══════════════════════════════════════════════════════════

    Timer {
        id: _showTimer
        interval: root.delay
        onTriggered: {
            // Re-check: text may have emptied during delay
            // (e.g., menuOpen flipped to true)
            if (root.text === "")
                return;
            _positionTooltip();
            root.state = "visible";
            if (root.showDuration > 0)
                _hideTimer.start();
        }
    }

    Timer {
        id: _hideTimer
        interval: root.showDuration
        onTriggered: root.state = "hidden"
    }

    onReadyChanged: {
        if (root.ready && root.target
                && root.target.containsMouse
                && root.text !== "") {
            _showTimer.stop();
            _positionTooltip();
            root.state = "visible";
            if (root.showDuration > 0)
                _hideTimer.start();
        }
    }

    // ═══════════════════════════════════════════════════════════
    //  POSITIONING
    // ═══════════════════════════════════════════════════════════

    function _positionTooltip() {
        if (!target || !target.parent)
            return;

        var tp = target.mapToItem(root.parent, 0, 0);
        var m = 8;

        switch (position) {
        case "top":
            x = tp.x + (target.width - width) / 2;
            y = tp.y - height - m;
            break;
        case "bottom":
            x = tp.x + (target.width - width) / 2;
            y = tp.y + target.height + m;
            break;
        case "left":
            x = tp.x - width - m;
            y = tp.y + (target.height - height) / 2;
            break;
        case "right":
            x = tp.x + target.width + m;
            y = tp.y + (target.height - height) / 2;
            break;
        }

        if (parent) {
            x = Math.max(m, Math.min(x, parent.width  - width  - m));
            y = Math.max(m, Math.min(y, parent.height - height - m));
        }

        _positionCaret();
    }

    function _positionCaret() {
        if (!root.showCaret)
            return;

        var tgt = root.positionTarget || root.target;
        var cx = _body.width  / 2;
        var cy = _body.height / 2;

        if (tgt && _container) {
            try {
                var pt = tgt.mapToItem(
                    _container,
                    tgt.width  / 2,
                    tgt.height / 2
                );
                cx = pt.x;
                cy = pt.y;
            } catch (e) {
                // Not yet in scene — fall back to center
            }
        }

        switch (root.position) {
        case "bottom":
            _caret.y = _body.y - _caret.height + root._caretOverlap;
            _caret.x = Math.max(4,
                Math.min(cx - _caret.width / 2,
                    _body.x + _body.width - _caret.width - 4));
            break;
        case "top":
            _caret.y = _body.y + _body.height - root._caretOverlap;
            _caret.x = Math.max(4,
                Math.min(cx - _caret.width / 2,
                    _body.x + _body.width - _caret.width - 4));
            break;
        case "left":
            _caret.x = _body.x + _body.width - root._caretOverlap;
            _caret.y = Math.max(4,
                Math.min(cy - _caret.height / 2,
                    _body.y + _body.height - _caret.height - 4));
            break;
        case "right":
            _caret.x = _body.x - _caret.width + root._caretOverlap;
            _caret.y = Math.max(4,
                Math.min(cy - _caret.height / 2,
                    _body.y + _body.height - _caret.height - 4));
            break;
        }

        _caret.requestPaint();
    }

    // ═══════════════════════════════════════════════════════════
    //  PUBLIC FUNCTIONS
    // ═══════════════════════════════════════════════════════════

    function show() {
        if (root.text === "")
            return;
        if (root.ready) {
            _showTimer.stop();
            _positionTooltip();
            root.state = "visible";
            if (root.showDuration > 0)
                _hideTimer.start();
        } else {
            _showTimer.restart();  // restart, not start — resets timer
        }
    }

    function hide() {
        _showTimer.stop();
        _hideTimer.stop();
        if (state === "visible")
            state = "hidden";
    }

    function _cancelAndHide() {
        _showTimer.stop();
        _hideTimer.stop();
        state = "hidden";
    }

    Connections {
        target: root.target
        ignoreUnknownSignals: true
        function onHoveredChanged() {
            root.target.hovered ? root.show() : root.hide();
        }
        function onContainsMouseChanged() {
            root.target.containsMouse ? root.show() : root.hide();
        }
    }
}
