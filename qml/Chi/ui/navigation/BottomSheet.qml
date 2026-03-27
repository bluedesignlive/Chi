import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../../theme" as Theme

Item {
    id: root

    property bool open: false
    property string variant: "standard"
    property bool showDragHandle: true
    property real minHeight: 200
    property real maxHeight: parent ? parent.height * 0.9 : 600
    property bool expandable: true
    property bool dismissible: true

    default property alias content: contentContainer.data

    signal closed()
    signal expanded()
    signal collapsed()

    readonly property bool _modal: variant === "modal"
    readonly property bool isExpanded: _state === 2
    readonly property real sheetHeight: sheet.height

    // 0=hidden, 1=peek, 2=expanded, 3=closing
    property int _state: 0
    property real _dragStartH: 0
    property real _dragStartY: 0
    property real _vel: 0
    property real _prevY: 0
    property real _prevT: 0

    anchors.fill: parent
    z: _modal ? 1000 : 0
    visible: _state !== 0

    property var colors: Theme.ChiTheme.colors

    // ── Only respond to external open=true when hidden ───
    onOpenChanged: {
        if (open && _state === 0) {
            _state = 1
            _animTo(minHeight)
        }
        // Never auto-close from here — close() handles it
    }

    // ═══════════════════════════════════════════════════════
    // SCRIM
    // ═══════════════════════════════════════════════════════

    Rectangle {
        id: scrim
        anchors.fill: parent
        color: colors.scrim
        visible: opacity > 0.001
        opacity: root._modal && root._state > 0 && root._state < 3
                 ? Math.min(sheet.height / Math.max(root.minHeight, 1) * 0.32, 0.32)
                 : 0

        Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
        Behavior on color { ColorAnimation { duration: 200 } }

        TapHandler {
            enabled: root._state === 1 || root._state === 2
            onTapped: { if (root.dismissible) root.close() }
        }
    }

    // ═══════════════════════════════════════════════════════
    // SHEET
    // ═══════════════════════════════════════════════════════

    Rectangle {
        id: sheet
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        height: 0
        color: root._modal ? colors.surfaceContainerLow : colors.surfaceContainer
        radius: 28
        Behavior on color { ColorAnimation { duration: 200 } }

        Rectangle {
            anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
            height: parent.radius; color: parent.color
            Behavior on color { ColorAnimation { duration: 200 } }
        }

        NumberAnimation {
            id: anim
            target: sheet; property: "height"
            duration: 300; easing.type: Easing.OutCubic
            onFinished: {
                if (sheet.height <= 1 && root._state === 3) {
                    root._state = 0
                    root.open = false
                    root.closed()
                }
            }
        }

        layer.enabled: sheet.height > 0
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.18)
            shadowHorizontalOffset: 0; shadowVerticalOffset: -3; shadowBlur: 0.5
        }

        ColumnLayout {
            anchors.fill: parent; spacing: 0

            // ── Drag handle ──────────────────────────────
            Item {
                visible: root.showDragHandle
                Layout.fillWidth: true; Layout.preferredHeight: 36

                Rectangle {
                    anchors.centerIn: parent
                    width: 32; height: 4; radius: 2
                    color: colors.onSurfaceVariant; opacity: 0.4
                }

                HoverHandler { cursorShape: Qt.SizeVerCursor }

                DragHandler {
                    target: null
                    yAxis.enabled: true; xAxis.enabled: false
                    grabPermissions: PointerHandler.CanTakeOverFromAnything

                    onActiveChanged: {
                        if (active) {
                            root._dragStartH = sheet.height
                            root._dragStartY = centroid.position.y
                            root._prevY = centroid.position.y
                            root._vel = 0; root._prevT = Date.now()
                            anim.stop()
                        } else {
                            _snapAfterDrag()
                        }
                    }
                    onCentroidChanged: {
                        if (!active) return
                        var dy = centroid.position.y - root._dragStartY
                        sheet.height = Math.max(0, Math.min(root.maxHeight, root._dragStartH - dy))
                        var now = Date.now(), dt = now - root._prevT
                        if (dt > 0) root._vel = (centroid.position.y - root._prevY) / dt * 1000
                        root._prevY = centroid.position.y; root._prevT = now
                    }
                }
            }

            // ── Content ──────────────────────────────────
            Flickable {
                Layout.fillWidth: true; Layout.fillHeight: true
                Layout.leftMargin: 16; Layout.rightMargin: 16; Layout.bottomMargin: 16
                contentHeight: contentContainer.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                interactive: contentContainer.implicitHeight > height

                ColumnLayout { id: contentContainer; width: parent.width; spacing: 16 }
            }
        }
    }

    // ═══════════════════════════════════════════════════════
    // SNAP LOGIC
    // ═══════════════════════════════════════════════════════

    function _snapAfterDrag() {
        var h = sheet.height, v = _vel

        if (v > 800 && dismissible) { close(); return }
        if (v < -800 && expandable) { _state = 2; _animTo(maxHeight); expanded(); return }

        var anchors = [minHeight]
        if (expandable) anchors.push(maxHeight)
        if (dismissible) anchors.unshift(0)

        var best = minHeight, bd = 99999
        for (var i = 0; i < anchors.length; i++) {
            var d = Math.abs(h - anchors[i])
            if (d < bd) { bd = d; best = anchors[i] }
        }

        if (best <= 0 && dismissible) { close() }
        else if (best >= maxHeight && expandable) { _state = 2; _animTo(maxHeight); expanded() }
        else { _state = 1; _animTo(minHeight); collapsed() }
    }

    function _animTo(target) {
        anim.stop()
        anim.from = sheet.height; anim.to = target
        anim.duration = Math.max(120, Math.min(350, Math.abs(sheet.height - target) / Math.max(maxHeight, 1) * 350))
        anim.easing.type = target > sheet.height ? Easing.OutCubic : Easing.InOutCubic
        anim.start()
    }

    // ═══════════════════════════════════════════════════════
    // PUBLIC API
    // ═══════════════════════════════════════════════════════

    function show() { open = true }

    function close() {
        if (_state === 3 || _state === 0) return  // already closing or hidden
        _state = 3
        anim.stop()
        anim.from = sheet.height; anim.to = 0
        anim.duration = Math.max(100, Math.min(220, sheet.height / Math.max(maxHeight, 1) * 220))
        anim.easing.type = Easing.InCubic
        anim.start()
    }

    function expand() {
        if (!open) open = true
        _state = 2; _animTo(maxHeight); expanded()
    }

    function collapse() {
        if (_state === 0) return
        _state = 1; _animTo(minHeight); collapsed()
    }

    Keys.onEscapePressed: { if (_state > 0 && _state < 3 && dismissible) close() }

    Accessible.role: Accessible.Dialog
    Accessible.name: "Bottom sheet"
}
