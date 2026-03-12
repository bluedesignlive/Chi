import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtCore
import "../theme" as Theme
import "../common" as Common

Item {
    id: root

    property color  selectedColor: "#FF0000"
    property color  initialColor:  "#FF0000"
    property bool   showAlpha:     true
    property bool   showInputs:    true
    property bool   showHistory:   true
    property bool   showActions:   true
    property bool   showEyedropper: true
    property string format:        "hex"
    property string pickerMode:    "box"

    signal colorSelected(color c)
    signal cancelled()
    signal eyedropperRequested()

    readonly property real hue:        _d.h
    readonly property real saturation: _d.s
    readonly property real brightness: _d.v
    readonly property real alpha:      _d.a

    implicitWidth: 328
    implicitHeight: _bg.height

    readonly property var    _c:  Theme.ChiTheme.colors
    readonly property var    _t:  Theme.ChiTheme.typography
    readonly property var    _m:  Theme.ChiTheme.motion
    readonly property string _ff: Theme.ChiTheme.fontFamily

    // ─── Persistent history ───────────────────────────────
    Loader {
        id: _settingsLoader
        active: Qt.application.organization !== ""
        sourceComponent: Component {
            Settings {
                category: "SmartUI_ColorPicker"
                property string recentJson: "[]"
            }
        }
    }

    QtObject {
        id: _history
        property var list: []

        Component.onCompleted: _load()

        function _load() {
            if (!_settingsLoader.item) return
            try {
                var parsed = JSON.parse(_settingsLoader.item.recentJson)
                if (Array.isArray(parsed)) list = parsed
            } catch (e) { list = [] }
        }

        function _save() {
            if (!_settingsLoader.item) return
            try { _settingsLoader.item.recentJson = JSON.stringify(list) }
            catch (e) { /* silent */ }
        }

        function add(c) {
            var hex = c.toString().toUpperCase()
            var arr = list.filter(function(v) { return v !== hex })
            arr.unshift(hex)
            if (arr.length > 28) arr.length = 28
            list = arr
            _save()
        }
    }

    Connections {
        target: _settingsLoader
        function onLoaded() { _history._load() }
    }

    // ─── HSV state ────────────────────────────────────────
    QtObject {
        id: _d
        property real h: 0
        property real s: 1
        property real v: 1
        property real a: 1

        function hsvToRgb(hh, ss, vv) {
            var i = Math.floor(hh * 6)
            var f = hh * 6 - i
            var p = vv * (1 - ss)
            var q = vv * (1 - f * ss)
            var t = vv * (1 - (1 - f) * ss)
            switch (i % 6) {
            case 0: return { r: vv, g: t,  b: p  }
            case 1: return { r: q,  g: vv, b: p  }
            case 2: return { r: p,  g: vv, b: t  }
            case 3: return { r: p,  g: q,  b: vv }
            case 4: return { r: t,  g: p,  b: vv }
            case 5: return { r: vv, g: p,  b: q  }
            }
            return { r: vv, g: t, b: p }
        }

        function rgbToHsv(r, g, b) {
            var mx = Math.max(r, g, b)
            var mn = Math.min(r, g, b)
            var d = mx - mn
            var hh = 0
            var ss = mx === 0 ? 0 : d / mx
            if (d !== 0) {
                if (mx === r)      hh = ((g - b) / d + (g < b ? 6 : 0)) / 6
                else if (mx === g) hh = ((b - r) / d + 2) / 6
                else               hh = ((r - g) / d + 4) / 6
            }
            return { h: hh, s: ss, v: mx }
        }

        function rgbToHsl(r, g, b) {
            var mx = Math.max(r, g, b)
            var mn = Math.min(r, g, b)
            var l = (mx + mn) / 2
            var ss = 0
            var hh = 0
            if (mx !== mn) {
                var d = mx - mn
                ss = l > 0.5 ? d / (2 - mx - mn) : d / (mx + mn)
                if (mx === r)      hh = ((g - b) / d + (g < b ? 6 : 0)) / 6
                else if (mx === g) hh = ((b - r) / d + 2) / 6
                else               hh = ((r - g) / d + 4) / 6
            }
            return { h: hh, s: ss, l: l }
        }

        function fromColor(c) {
            if (c === undefined || c === null) return
            var res = rgbToHsv(c.r, c.g, c.b)
            h = isNaN(res.h) ? 0 : res.h
            s = isNaN(res.s) ? 0 : res.s
            v = isNaN(res.v) ? 1 : res.v
            a = (c.a !== undefined && !isNaN(c.a)) ? c.a : 1.0
        }

        function sync() {
            var rgb = hsvToRgb(h, s, v)
            root.selectedColor = Qt.rgba(rgb.r, rgb.g, rgb.b, a)
        }

        Component.onCompleted: { fromColor(root.initialColor); sync() }
    }

    // ─── Clipboard ────────────────────────────────────────
    TextEdit {
        id: _clip
        visible: false
        function copyVal(val) { text = val; selectAll(); copy(); _toast.show() }
    }

    QtObject {
        id: _toast
        property bool visible: false
        function show() { visible = true; _toastTimer.restart() }
    }

    Timer {
        id: _toastTimer
        interval: 1400
        onTriggered: _toast.visible = false
    }

    // ─── Inline components ────────────────────────────────
    component SliderThumb: Rectangle {
        width: 22
        height: 22
        radius: 11
        border.width: 2.5
        border.color: "#FFFFFF"
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowVerticalOffset: 1
            shadowBlur: 0.25
            shadowColor: Qt.rgba(0, 0, 0, 0.45)
        }
    }

    component ValueField: Rectangle {
        id: _vf
        property string label: ""
        property alias value: _vfInput
        radius: 8
        color: root._c.surfaceContainerHighest
        border.width: 1
        border.color: _vfInput.activeFocus ? root._c.primary : root._c.outlineVariant
        Layout.fillWidth: true
        Layout.preferredHeight: 34

        TextInput {
            id: _vfInput
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: root._ff
            font.pixelSize: root._t.bodySmall.size
            font.weight: Font.Medium
            color: root._c.onSurface
            selectionColor: root._c.primary
            selectedTextColor: root._c.onPrimary
            maximumLength: 3
        }
    }

    component HueStrip: Item {
        Layout.fillWidth: true
        Layout.preferredHeight: 20

        Rectangle {
            anchors.fill: parent
            radius: 10
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.000; color: "#FF0000" }
                GradientStop { position: 0.167; color: "#FFFF00" }
                GradientStop { position: 0.333; color: "#00FF00" }
                GradientStop { position: 0.500; color: "#00FFFF" }
                GradientStop { position: 0.667; color: "#0000FF" }
                GradientStop { position: 0.833; color: "#FF00FF" }
                GradientStop { position: 1.000; color: "#FF0000" }
            }
        }

        SliderThumb {
            x: _d.h * (parent.width - width)
            y: -1
            color: Qt.hsla(_d.h, 1, 0.5, 1)
        }

        MouseArea {
            anchors.fill: parent
            preventStealing: true
            function update(mx) { _d.h = Math.max(0, Math.min(1, mx / width)); _d.sync() }
            onPressed: function(e) { update(e.x) }
            onPositionChanged: function(e) { if (pressed) update(e.x) }
        }
    }

    component SvArea: Item {
        property real areaRadius: 12

        Rectangle {
            anchors.fill: parent
            radius: parent.areaRadius
            color: "transparent"
            layer.enabled: true

            Rectangle { anchors.fill: parent; color: Qt.hsla(_d.h, 1, 0.5, 1) }

            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0; color: "#FFFFFF" }
                    GradientStop { position: 1; color: "transparent" }
                }
            }

            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0; color: "transparent" }
                    GradientStop { position: 1; color: "#000000" }
                }
            }
        }

        Rectangle {
            width: 20
            height: 20
            radius: 10
            border.width: 2.5
            border.color: "#FFFFFF"
            color: "transparent"
            x: _d.s * (parent.width - width)
            y: (1 - _d.v) * (parent.height - height)

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowVerticalOffset: 1
                shadowBlur: 0.3
                shadowColor: Qt.rgba(0, 0, 0, 0.5)
            }

            Rectangle {
                anchors.centerIn: parent
                width: 10
                height: 10
                radius: 5
                color: root.selectedColor
            }
        }

        MouseArea {
            anchors.fill: parent
            preventStealing: true
            function update(mx, my) {
                _d.s = Math.max(0, Math.min(1, mx / width))
                _d.v = Math.max(0, Math.min(1, 1 - my / height))
                _d.sync()
            }
            onPressed: function(e) { update(e.x, e.y) }
            onPositionChanged: function(e) { if (pressed) update(e.x, e.y) }
        }
    }

    component HueRing: Item {
        id: _ring
        property real ringWidth: 22
        readonly property real outerR: Math.min(width, height) / 2 - 1
        readonly property real innerR: outerR - ringWidth
        readonly property real midR: (outerR + innerR) / 2

        Canvas {
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d")
                var cx = width / 2
                var cy = height / 2
                ctx.reset()
                for (var deg = 0; deg < 360; deg++) {
                    var s0 = (deg - 0.5) * Math.PI / 180
                    var s1 = (deg + 1.5) * Math.PI / 180
                    ctx.beginPath()
                    ctx.arc(cx, cy, _ring.outerR, s0, s1)
                    ctx.arc(cx, cy, _ring.innerR, s1, s0, true)
                    ctx.closePath()
                    ctx.fillStyle = Qt.hsla(deg / 360, 1, 0.5, 1).toString()
                    ctx.fill()
                }
            }
        }

        Rectangle {
            width: 24
            height: 24
            radius: 12
            border.width: 2.5
            border.color: "#FFFFFF"
            color: Qt.hsla(_d.h, 1, 0.5, 1)
            property real angle: _d.h * 2 * Math.PI
            x: _ring.width / 2 + _ring.midR * Math.cos(angle) - 12
            y: _ring.height / 2 + _ring.midR * Math.sin(angle) - 12

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowVerticalOffset: 1
                shadowBlur: 0.25
                shadowColor: Qt.rgba(0, 0, 0, 0.45)
            }
        }

        MouseArea {
            anchors.fill: parent
            preventStealing: true
            function update(mx, my) {
                var dx = mx - width / 2
                var dy = my - height / 2
                var dist = Math.sqrt(dx * dx + dy * dy)
                if (dist >= _ring.innerR - 6 && dist <= _ring.outerR + 6) {
                    var angle = Math.atan2(dy, dx)
                    if (angle < 0) angle += 2 * Math.PI
                    _d.h = angle / (2 * Math.PI)
                    _d.sync()
                }
            }
            onPressed: function(e) { update(e.x, e.y) }
            onPositionChanged: function(e) { if (pressed) update(e.x, e.y) }
        }
    }

    // ═══════════════════════════════════════════════════════
    // BACKGROUND
    // ═══════════════════════════════════════════════════════
    Rectangle {
        id: _bg
        width: root.width
        height: _mainCol.implicitHeight + 12
        radius: 28
        color: _c.surfaceContainerHigh

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowVerticalOffset: 6
            shadowBlur: 0.4
            shadowColor: Qt.rgba(0, 0, 0, 0.18)
        }

        MouseArea {
            anchors.fill: parent
            onPressed: function(e) { e.accepted = true }
        }

        ColumnLayout {
            id: _mainCol
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 0

            // ── Header ────────────────────────────────────
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: _headerInner.implicitHeight + 36

                ColumnLayout {
                    id: _headerInner
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.leftMargin: 24
                    anchors.rightMargin: 24
                    anchors.topMargin: 16
                    spacing: 10

                    Text {
                        text: "Select color"
                        font.family: _ff
                        font.pixelSize: _t.labelMedium.size
                        font.weight: _t.labelMedium.weight
                        color: _c.onSurfaceVariant
                    }

                    // Color preview: new | original
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        spacing: 0

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: root.selectedColor
                            radius: 12

                            Rectangle {
                                anchors.right: parent.right
                                width: 8
                                height: parent.height
                                color: parent.color
                            }

                            Text {
                                anchors.centerIn: parent
                                text: "New"
                                font.family: _ff
                                font.pixelSize: _t.labelMedium.size
                                font.weight: Font.Medium
                                color: root.selectedColor.hslLightness > 0.55 ? _c.scrim : "#FFFFFF"
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: root.initialColor
                            radius: 12

                            Rectangle {
                                anchors.left: parent.left
                                width: 8
                                height: parent.height
                                color: parent.color
                            }

                            Text {
                                anchors.centerIn: parent
                                text: "Original"
                                font.family: _ff
                                font.pixelSize: _t.labelMedium.size
                                font.weight: Font.Medium
                                color: root.initialColor.hslLightness > 0.55 ? _c.scrim : "#FFFFFF"
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: { _d.fromColor(root.initialColor); _d.sync() }
                            }
                        }
                    }
                }

                // Divider
                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 1
                    color: _c.outlineVariant
                }
            }

            // ── Mode nav bar ──────────────────────────────
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                Layout.leftMargin: 12
                Layout.rightMargin: 12
                spacing: 0

                // Mode selector pill
                Rectangle {
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: _modeRow.implicitWidth + 8
                    radius: 16
                    color: _c.surfaceContainerHighest
                    border.width: 1
                    border.color: _c.outlineVariant

                    Row {
                        id: _modeRow
                        anchors.centerIn: parent
                        spacing: 0

                        Repeater {
                            model: [
                                { mode: "box",      icon: "gradient" },
                                { mode: "wheel",    icon: "donut_large" },
                                { mode: "triangle", icon: "change_history" },
                                { mode: "slider",   icon: "tune" }
                            ]

                            Rectangle {
                                width: 32
                                height: 28
                                radius: 14
                                color: root.pickerMode === modelData.mode
                                       ? _c.primary
                                       : (_modeItemMA.containsMouse
                                          ? Qt.rgba(_c.onSurface.r, _c.onSurface.g, _c.onSurface.b, 0.08)
                                          : "transparent")

                                Common.Icon {
                                    anchors.centerIn: parent
                                    source: modelData.icon
                                    size: 16
                                    color: root.pickerMode === modelData.mode
                                           ? _c.onPrimary
                                           : _c.onSurfaceVariant
                                }

                                MouseArea {
                                    id: _modeItemMA
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.pickerMode = modelData.mode
                                }
                            }
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                // Eyedropper
                Rectangle {
                    visible: root.showEyedropper
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                    radius: 16
                    color: _eyedropMA.containsMouse
                           ? Qt.rgba(_c.onSurface.r, _c.onSurface.g, _c.onSurface.b, 0.08)
                           : "transparent"

                    Common.Icon {
                        anchors.centerIn: parent
                        source: "colorize"
                        size: 18
                        color: _c.onSurfaceVariant
                    }

                    MouseArea {
                        id: _eyedropMA
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.eyedropperRequested()
                    }
                }
            }

            // ══════════════════════════════════════════════
            // PICKER BODY
            // ══════════════════════════════════════════════
            Item {
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20

                // Dynamic height from active mode
                Layout.preferredHeight: {
                    if (root.pickerMode === "box") return 178
                    if (root.pickerMode === "slider") return 160
                    // wheel + triangle: square
                    return width - 40
                }

                ColumnLayout {
                    visible: root.pickerMode === "box"
                    anchors.fill: parent
                    spacing: 10

                    SvArea {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        areaRadius: 12
                    }

                    HueStrip {}
                }

                Item {
                    visible: root.pickerMode === "wheel"
                    anchors.fill: parent

                    HueRing { anchors.fill: parent }

                    SvArea {
                        property real innerR: (Math.min(parent.width, parent.height) / 2) - 28
                        property real side: innerR * 1.28
                        width: side
                        height: side
                        anchors.centerIn: parent
                        areaRadius: 8
                    }
                }

                Item {
                    visible: root.pickerMode === "triangle"
                    anchors.fill: parent

                    HueRing { anchors.fill: parent }

                    Canvas {
                        id: _triCanvas
                        property real triR: (Math.min(parent.width, parent.height) / 2) - 28
                        width: triR * 2
                        height: triR * 2
                        anchors.centerIn: parent

                        Connections {
                            target: _d
                            function onHChanged() { _triCanvas.requestPaint() }
                        }

                        onPaint: {
                            var ctx = getContext("2d")
                            var w = width
                            var h = height
                            if (w <= 0 || h <= 0) return

                            var cx = w / 2
                            var cy = h / 2
                            var r = triR - 2

                            var ax = cx,              ay = cy - r
                            var bx = cx - r * 0.866,  by = cy + r * 0.5
                            var ccx = cx + r * 0.866, ccy = cy + r * 0.5

                            ctx.clearRect(0, 0, w, h)
                            ctx.save()

                            ctx.beginPath()
                            ctx.moveTo(ax, ay)
                            ctx.lineTo(bx, by)
                            ctx.lineTo(ccx, ccy)
                            ctx.closePath()
                            ctx.clip()

                            ctx.fillStyle = Qt.hsla(_d.h, 1, 0.5, 1).toString()
                            ctx.fillRect(0, 0, w, h)

                            var midAC_x = (ax + ccx) / 2
                            var midAC_y = (ay + ccy) / 2
                            var wGrad = ctx.createLinearGradient(bx, by, midAC_x, midAC_y)
                            wGrad.addColorStop(0, "rgba(255,255,255,1)")
                            wGrad.addColorStop(1, "rgba(255,255,255,0)")
                            ctx.fillStyle = wGrad
                            ctx.fillRect(0, 0, w, h)

                            var midAB_x = (ax + bx) / 2
                            var midAB_y = (ay + by) / 2
                            var bGrad = ctx.createLinearGradient(ccx, ccy, midAB_x, midAB_y)
                            bGrad.addColorStop(0, "rgba(0,0,0,1)")
                            bGrad.addColorStop(1, "rgba(0,0,0,0)")
                            ctx.fillStyle = bGrad
                            ctx.fillRect(0, 0, w, h)

                            ctx.restore()
                        }
                    }

                    Rectangle {
                        id: _triCursor
                        width: 18
                        height: 18
                        radius: 9
                        border.width: 2
                        border.color: "#FFFFFF"
                        color: "transparent"

                        property real triR: _triCanvas.triR - 2
                        property real tcx: _triCanvas.x + _triCanvas.width / 2
                        property real tcy: _triCanvas.y + _triCanvas.height / 2

                        property real ax: tcx
                        property real ay: tcy - triR
                        property real bx: tcx - triR * 0.866
                        property real by: tcy + triR * 0.5
                        property real ccx: tcx + triR * 0.866
                        property real ccy: tcy + triR * 0.5

                        property real u: _d.s * _d.v
                        property real vv: (1 - _d.s) * _d.v
                        property real w: 1 - _d.v

                        x: u * ax + vv * bx + w * ccx - width / 2
                        y: u * ay + vv * by + w * ccy - height / 2

                        layer.enabled: true
                        layer.effect: MultiEffect {
                            shadowEnabled: true
                            shadowVerticalOffset: 1
                            shadowBlur: 0.25
                            shadowColor: Qt.rgba(0, 0, 0, 0.5)
                        }

                        Rectangle {
                            anchors.centerIn: parent
                            width: 8
                            height: 8
                            radius: 4
                            color: root.selectedColor
                        }
                    }

                    MouseArea {
                        x: _triCanvas.x
                        y: _triCanvas.y
                        width: _triCanvas.width
                        height: _triCanvas.height
                        preventStealing: true

                        property real triR: _triCanvas.triR - 2
                        property real tcx: width / 2
                        property real tcy: height / 2

                        function update(mx, my) {
                            var ax = tcx, ay = tcy - triR
                            var bx = tcx - triR * 0.866, by = tcy + triR * 0.5
                            var ccx = tcx + triR * 0.866, ccy = tcy + triR * 0.5

                            var denom = (by - ccy) * (ax - ccx) + (ccx - bx) * (ay - ccy)
                            if (Math.abs(denom) < 0.001) return

                            var u = ((by - ccy) * (mx - ccx) + (ccx - bx) * (my - ccy)) / denom
                            var vv = ((ccy - ay) * (mx - ccx) + (ax - ccx) * (my - ccy)) / denom
                            var w = 1 - u - vv

                            u = Math.max(0, u); vv = Math.max(0, vv); w = Math.max(0, w)
                            var sum = u + vv + w
                            u /= sum; vv /= sum; w /= sum

                            var val = u + vv
                            _d.s = Math.max(0, Math.min(1, val > 0.001 ? u / val : 0))
                            _d.v = Math.max(0, Math.min(1, val))
                            _d.sync()
                        }

                        onPressed: function(e) { update(e.x, e.y) }
                        onPositionChanged: function(e) { if (pressed) update(e.x, e.y) }
                    }
                }

                ColumnLayout {
                    visible: root.pickerMode === "slider"
                    anchors.fill: parent
                    spacing: 12

                    Repeater {
                        model: [
                            { ch: "h", label: "H", unit: "°", max: 360 },
                            { ch: "s", label: "S", unit: "%", max: 100 },
                            { ch: "v", label: "V", unit: "%", max: 100 }
                        ]

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4

                            Text {
                                text: modelData.label + "  "
                                    + Math.round(_d[modelData.ch] * modelData.max) + modelData.unit
                                font.family: _ff
                                font.pixelSize: _t.labelSmall.size
                                font.weight: _t.labelSmall.weight
                                color: _c.onSurfaceVariant
                            }

                            Item {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 20

                                Rectangle {
                                    anchors.fill: parent
                                    radius: 10
                                    gradient: modelData.ch === "h" ? null : undefined
                                    color: modelData.ch === "h" ? "transparent" : "transparent"

                                    // Each channel gets its own gradient
                                    Loader {
                                        anchors.fill: parent
                                        sourceComponent: {
                                            if (modelData.ch === "h") return _hueGradComp
                                            if (modelData.ch === "s") return _satGradComp
                                            return _valGradComp
                                        }
                                    }
                                }

                                SliderThumb {
                                    x: _d[modelData.ch] * (parent.width - width)
                                    y: -1
                                    color: {
                                        if (modelData.ch === "h") return Qt.hsla(_d.h, 1, 0.5, 1)
                                        return Qt.hsva(_d.h, _d.s, _d.v, 1)
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    preventStealing: true
                                    function doUpdate(mx) {
                                        _d[modelData.ch] = Math.max(0, Math.min(1, mx / width))
                                        _d.sync()
                                    }
                                    onPressed: function(e) { doUpdate(e.x) }
                                    onPositionChanged: function(e) { if (pressed) doUpdate(e.x) }
                                }
                            }
                        }
                    }
                }
            }

            // ── Alpha strip ───────────────────────────────
            ColumnLayout {
                visible: root.showAlpha
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                Layout.topMargin: 10
                spacing: 4

                Text {
                    text: "A  " + Math.round(_d.a * 100) + "%"
                    font.family: _ff
                    font.pixelSize: _t.labelSmall.size
                    font.weight: _t.labelSmall.weight
                    color: _c.onSurfaceVariant
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 20

                    Rectangle {
                        anchors.fill: parent
                        radius: 10
                        color: "#FFFFFF"

                        Canvas {
                            anchors.fill: parent
                            anchors.margins: 0
                            onPaint: {
                                var ctx = getContext("2d")
                                var sz = 5
                                ctx.clearRect(0, 0, width, height)
                                for (var yy = 0; yy < height; yy += sz)
                                    for (var xx = 0; xx < width; xx += sz) {
                                        ctx.fillStyle = ((xx / sz + yy / sz) & 1) ? "#CCCCCC" : "#FFFFFF"
                                        ctx.fillRect(xx, yy, sz, sz)
                                    }
                            }
                        }

                        Rectangle {
                            anchors.fill: parent
                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop { position: 0; color: Qt.rgba(root.selectedColor.r, root.selectedColor.g, root.selectedColor.b, 0) }
                                GradientStop { position: 1; color: Qt.rgba(root.selectedColor.r, root.selectedColor.g, root.selectedColor.b, 1) }
                            }
                        }

                        layer.enabled: true
                    }

                    SliderThumb {
                        x: _d.a * (parent.width - width)
                        y: -1
                        color: root.selectedColor
                    }

                    MouseArea {
                        anchors.fill: parent
                        preventStealing: true
                        function update(mx) { _d.a = Math.max(0, Math.min(1, mx / width)); _d.sync() }
                        onPressed: function(e) { update(e.x) }
                        onPositionChanged: function(e) { if (pressed) update(e.x) }
                    }
                }
            }

            // ── Input fields ──────────────────────────────
            RowLayout {
                visible: root.showInputs
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                Layout.topMargin: 10
                spacing: 6

                // Format cycle pill
                Rectangle {
                    Layout.preferredWidth: 50
                    Layout.preferredHeight: 34
                    radius: 8
                    color: _c.surfaceContainerHighest
                    border.width: 1
                    border.color: _c.outlineVariant

                    Text {
                        anchors.centerIn: parent
                        text: root.format.toUpperCase()
                        font.family: _ff
                        font.pixelSize: _t.labelMedium.size
                        font.weight: _t.labelMedium.weight
                        color: _c.onSurface
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (root.format === "hex") root.format = "rgb"
                            else if (root.format === "rgb") root.format = "hsl"
                            else root.format = "hex"
                        }
                    }
                }

                // HEX
                Rectangle {
                    visible: root.format === "hex"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 34
                    radius: 8
                    color: _c.surfaceContainerHighest
                    border.width: 1
                    border.color: _hexIn.activeFocus ? _c.primary : _c.outlineVariant

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 4
                        spacing: 2

                        Text {
                            text: "#"
                            font.family: _ff
                            font.pixelSize: _t.bodyMedium.size
                            color: _c.onSurfaceVariant
                        }

                        TextInput {
                            id: _hexIn
                            Layout.fillWidth: true
                            clip: true
                            font.family: _ff
                            font.pixelSize: _t.bodyMedium.size
                            color: _c.onSurface
                            selectionColor: _c.primary
                            selectedTextColor: _c.onPrimary
                            maximumLength: root.showAlpha ? 8 : 6
                            validator: RegularExpressionValidator { regularExpression: /[0-9A-Fa-f]*/ }

                            text: {
                                var hex = root.selectedColor.toString().substring(1)
                                if (!root.showAlpha && hex.length > 6)
                                    hex = hex.substring(hex.length - 6)
                                return hex.toUpperCase()
                            }

                            onEditingFinished: {
                                var h = text
                                if (h.length === 6) {
                                    _d.fromColor(Qt.rgba(
                                        parseInt(h.substring(0, 2), 16) / 255,
                                        parseInt(h.substring(2, 4), 16) / 255,
                                        parseInt(h.substring(4, 6), 16) / 255, _d.a))
                                } else if (h.length === 8) {
                                    _d.fromColor(Qt.rgba(
                                        parseInt(h.substring(2, 4), 16) / 255,
                                        parseInt(h.substring(4, 6), 16) / 255,
                                        parseInt(h.substring(6, 8), 16) / 255,
                                        parseInt(h.substring(0, 2), 16) / 255))
                                }
                                _d.sync()
                            }
                        }
                    }
                }

                // RGB
                RowLayout {
                    visible: root.format === "rgb"
                    Layout.fillWidth: true
                    spacing: 4

                    Repeater {
                        model: ["R", "G", "B"]
                        ValueField {
                            label: modelData
                            value.validator: IntValidator { bottom: 0; top: 255 }
                            value.text: Math.round(
                                modelData === "R" ? root.selectedColor.r * 255 :
                                modelData === "G" ? root.selectedColor.g * 255 :
                                                    root.selectedColor.b * 255)
                            value.onEditingFinished: {
                                var r = modelData === "R" ? parseInt(value.text) / 255 : root.selectedColor.r
                                var g = modelData === "G" ? parseInt(value.text) / 255 : root.selectedColor.g
                                var b = modelData === "B" ? parseInt(value.text) / 255 : root.selectedColor.b
                                _d.fromColor(Qt.rgba(r, g, b, _d.a)); _d.sync()
                            }
                        }
                    }

                    ValueField {
                        visible: root.showAlpha
                        label: "A"
                        value.validator: IntValidator { bottom: 0; top: 100 }
                        value.text: Math.round(_d.a * 100)
                        value.onEditingFinished: { _d.a = parseInt(value.text) / 100; _d.sync() }
                    }
                }

                // HSL
                RowLayout {
                    visible: root.format === "hsl"
                    Layout.fillWidth: true
                    spacing: 4

                    Repeater {
                        model: ["H", "S", "L"]
                        ValueField {
                            label: modelData
                            value.validator: IntValidator { bottom: 0; top: modelData === "H" ? 360 : 100 }
                            value.text: {
                                var hsl = _d.rgbToHsl(root.selectedColor.r, root.selectedColor.g, root.selectedColor.b)
                                if (modelData === "H") return Math.round(hsl.h * 360)
                                if (modelData === "S") return Math.round(hsl.s * 100)
                                return Math.round(hsl.l * 100)
                            }
                            value.onEditingFinished: {
                                var hsl = _d.rgbToHsl(root.selectedColor.r, root.selectedColor.g, root.selectedColor.b)
                                if (modelData === "H") hsl.h = parseInt(value.text) / 360
                                else if (modelData === "S") hsl.s = parseInt(value.text) / 100
                                else hsl.l = parseInt(value.text) / 100
                                _d.fromColor(Qt.hsla(hsl.h, hsl.s, hsl.l, _d.a)); _d.sync()
                            }
                        }
                    }

                    ValueField {
                        visible: root.showAlpha
                        label: "A"
                        value.validator: IntValidator { bottom: 0; top: 100 }
                        value.text: Math.round(_d.a * 100)
                        value.onEditingFinished: { _d.a = parseInt(value.text) / 100; _d.sync() }
                    }
                }
            }

            // ── Recent colors ─────────────────────────────
            Column {
                visible: root.showHistory && _history.list.length > 0
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                Layout.topMargin: 10
                spacing: 6

                Text {
                    text: "Recent"
                    font.family: _ff
                    font.pixelSize: _t.labelMedium.size
                    font.weight: _t.labelMedium.weight
                    color: _c.onSurfaceVariant
                }

                Flow {
                    width: parent.width
                    spacing: 6

                    Repeater {
                        model: _history.list

                        Rectangle {
                            required property string modelData
                            width: 24
                            height: 24
                            radius: 6
                            color: modelData
                            border.width: root.selectedColor.toString().toUpperCase() === modelData ? 2 : 0
                            border.color: _c.primary

                            Rectangle {
                                visible: parent.modelData.toUpperCase() === "#FFFFFF"
                                anchors.fill: parent
                                anchors.margins: 1
                                radius: 5
                                color: "transparent"
                                border.width: 1
                                border.color: root._c.outlineVariant
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: { _d.fromColor(parent.modelData); _d.sync() }
                            }
                        }
                    }
                }
            }

            // ── Bottom bar: copy + toast + actions ────────
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                Layout.leftMargin: 12
                Layout.rightMargin: 12
                Layout.topMargin: 4
                spacing: 4

                // Copy button (like keyboard icon in TimePicker)
                Rectangle {
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    radius: 20
                    color: _copyMA.containsMouse
                           ? Qt.rgba(_c.onSurface.r, _c.onSurface.g, _c.onSurface.b, 0.08)
                           : "transparent"

                    Common.Icon {
                        anchors.centerIn: parent
                        source: "content_copy"
                        size: 20
                        color: _c.onSurfaceVariant
                    }

                    MouseArea {
                        id: _copyMA
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            var val = ""
                            if (root.format === "hex") {
                                val = root.selectedColor.toString()
                            } else if (root.format === "rgb") {
                                val = "rgb(" + Math.round(root.selectedColor.r * 255)
                                    + ", " + Math.round(root.selectedColor.g * 255)
                                    + ", " + Math.round(root.selectedColor.b * 255)
                                if (root.showAlpha) val += ", " + _d.a.toFixed(2)
                                val += ")"
                            } else {
                                var hsl = _d.rgbToHsl(root.selectedColor.r, root.selectedColor.g, root.selectedColor.b)
                                val = "hsl(" + Math.round(hsl.h * 360)
                                    + ", " + Math.round(hsl.s * 100) + "%"
                                    + ", " + Math.round(hsl.l * 100) + "%"
                                if (root.showAlpha) val += ", " + _d.a.toFixed(2)
                                val += ")"
                            }
                            _clip.copyVal(val)
                        }
                    }
                }

                // Copied toast
                Rectangle {
                    visible: _toast.visible
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: _copiedLbl.implicitWidth + 16
                    radius: 14
                    color: _c.primaryContainer

                    Text {
                        id: _copiedLbl
                        anchors.centerIn: parent
                        text: "Copied!"
                        font.family: _ff
                        font.pixelSize: _t.labelMedium.size
                        font.weight: Font.Medium
                        color: _c.onPrimaryContainer
                    }
                }

                Item { Layout.fillWidth: true }

                // Actions
                Rectangle {
                    visible: root.showActions
                    Layout.preferredWidth: _cancelTxt.implicitWidth + 24
                    Layout.preferredHeight: 40
                    radius: 20
                    color: _cancelMA.containsMouse
                           ? Qt.rgba(_c.primary.r, _c.primary.g, _c.primary.b, 0.08)
                           : "transparent"

                    Text {
                        id: _cancelTxt
                        anchors.centerIn: parent
                        text: "Cancel"
                        font.family: _ff
                        font.pixelSize: _t.labelLarge.size
                        font.weight: _t.labelLarge.weight
                        color: _c.primary
                    }

                    MouseArea {
                        id: _cancelMA
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.cancelled()
                    }
                }

                Rectangle {
                    visible: root.showActions
                    Layout.preferredWidth: _selectTxt.implicitWidth + 32
                    Layout.preferredHeight: 40
                    radius: 20
                    color: _c.primary

                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        color: _c.onPrimary
                        opacity: _selectMA.containsMouse ? 0.12 : 0
                    }

                    Text {
                        id: _selectTxt
                        anchors.centerIn: parent
                        text: "Select"
                        font.family: _ff
                        font.pixelSize: _t.labelLarge.size
                        font.weight: _t.labelLarge.weight
                        color: _c.onPrimary
                    }

                    MouseArea {
                        id: _selectMA
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            _history.add(root.selectedColor)
                            root.colorSelected(root.selectedColor)
                        }
                    }
                }
            }
        }
    }

    // ─── Slider gradient components ───────────────────────
    Component {
        id: _hueGradComp
        Rectangle {
            radius: 10
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.000; color: "#FF0000" }
                GradientStop { position: 0.167; color: "#FFFF00" }
                GradientStop { position: 0.333; color: "#00FF00" }
                GradientStop { position: 0.500; color: "#00FFFF" }
                GradientStop { position: 0.667; color: "#0000FF" }
                GradientStop { position: 0.833; color: "#FF00FF" }
                GradientStop { position: 1.000; color: "#FF0000" }
            }
        }
    }

    Component {
        id: _satGradComp
        Rectangle {
            radius: 10
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0; color: Qt.hsva(_d.h, 0, _d.v, 1) }
                GradientStop { position: 1; color: Qt.hsva(_d.h, 1, _d.v, 1) }
            }
        }
    }

    Component {
        id: _valGradComp
        Rectangle {
            radius: 10
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0; color: Qt.hsva(_d.h, _d.s, 0, 1) }
                GradientStop { position: 1; color: Qt.hsva(_d.h, _d.s, 1, 1) }
            }
        }
    }

    // ─── Public helpers ───────────────────────────────────
    function getHex() { return root.selectedColor.toString() }
    function getRgb() {
        return {
            r: Math.round(root.selectedColor.r * 255),
            g: Math.round(root.selectedColor.g * 255),
            b: Math.round(root.selectedColor.b * 255),
            a: Math.round(_d.a * 255)
        }
    }
    function getHsl() {
        var h = _d.rgbToHsl(root.selectedColor.r, root.selectedColor.g, root.selectedColor.b)
        return { h: Math.round(h.h * 360), s: Math.round(h.s * 100), l: Math.round(h.l * 100), a: Math.round(_d.a * 100) }
    }
    function setColor(c) { _d.fromColor(c); _d.sync() }
    function reset() { _d.fromColor(root.initialColor); _d.sync() }

    Accessible.role: Accessible.Dialog
    Accessible.name: "Color picker"
}
