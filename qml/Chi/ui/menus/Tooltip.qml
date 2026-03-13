// qml/smartui/ui/menus/Tooltip.qml
// M3 tooltip — plain (inverse surface) and rich (surface container)
import QtQuick
import QtQuick.Effects
import "../../theme" as Theme

Item {
    id: root

    property string text: ""
    property Item target: null
    property string position: "bottom"
    property int delay: 500
    property int showDuration: 1500
    property bool rich: false

    readonly property bool isVisible: state === "visible"

    visible: false
    z: 2000

    implicitWidth: _container.width
    implicitHeight: _container.height

    // ═══════════════════════════════════════════════════════════════════
    // THEME
    // ═══════════════════════════════════════════════════════════════════

    property var colors: Theme.ChiTheme.colors

    readonly property var _plainTypo: Theme.ChiTheme.typography.bodySmall
    readonly property var _richTypo:  Theme.ChiTheme.typography.bodyMedium

    // ═══════════════════════════════════════════════════════════════════
    // STATES
    // ═══════════════════════════════════════════════════════════════════

    state: "hidden"

    states: [
        State {
            name: "hidden"
            PropertyChanges { target: _container; opacity: 0; scale: 0.92 }
            PropertyChanges { target: root; visible: false }
        },
        State {
            name: "visible"
            PropertyChanges { target: _container; opacity: 1; scale: 1 }
            PropertyChanges { target: root; visible: true }
        }
    ]

    transitions: [
        Transition {
            from: "hidden"; to: "visible"
            SequentialAnimation {
                PropertyAction { property: "visible"; value: true }
                NumberAnimation { properties: "opacity,scale"; duration: 120; easing.type: Easing.OutCubic }
            }
        },
        Transition {
            from: "visible"; to: "hidden"
            SequentialAnimation {
                NumberAnimation { properties: "opacity,scale"; duration: 80; easing.type: Easing.InCubic }
                PropertyAction { property: "visible"; value: false }
            }
        }
    ]

    // ═══════════════════════════════════════════════════════════════════
    // VISUAL
    // ═══════════════════════════════════════════════════════════════════

    Rectangle {
        id: _container
        width: rich ? _richLabel.implicitWidth + 24 : _plainLabel.implicitWidth + 16
        height: rich ? _richLabel.implicitHeight + 16 : 24
        radius: rich ? 12 : 4
        color: rich ? colors.surfaceContainer : colors.inverseSurface

        // Shadow only for rich tooltips — single pass
        layer.enabled: rich
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.18)
            shadowVerticalOffset: 2
            shadowBlur: 0.25
        }

        // Plain label
        Text {
            id: _plainLabel
            visible: !rich
            anchors.centerIn: parent
            text: root.text
            font.family: root._plainTypo.family
            font.pixelSize: root._plainTypo.size
            font.weight: root._plainTypo.weight
            font.letterSpacing: root._plainTypo.spacing || 0
            color: colors.inverseOnSurface
        }

        // Rich label
        Text {
            id: _richLabel
            visible: rich
            anchors.centerIn: parent
            text: root.text
            font.family: root._richTypo.family
            font.pixelSize: root._richTypo.size
            font.weight: root._richTypo.weight
            font.letterSpacing: root._richTypo.spacing || 0
            color: colors.onSurface
            wrapMode: Text.WordWrap
            maximumLineCount: 4
        }
    }

    // ═══════════════════════════════════════════════════════════════════
    // TIMERS
    // ═══════════════════════════════════════════════════════════════════

    Timer {
        id: _showTimer
        interval: root.delay
        onTriggered: {
            _positionTooltip()
            root.state = "visible"
            if (root.showDuration > 0) _hideTimer.start()
        }
    }

    Timer {
        id: _hideTimer
        interval: root.showDuration
        onTriggered: root.state = "hidden"
    }

    // ═══════════════════════════════════════════════════════════════════
    // POSITIONING
    // ═══════════════════════════════════════════════════════════════════

    function _positionTooltip() {
        if (!target || !target.parent) return

        var tp = target.mapToItem(root.parent, 0, 0)
        var m = 8

        switch (position) {
        case "top":
            x = tp.x + (target.width - width) / 2
            y = tp.y - height - m; break
        case "bottom":
            x = tp.x + (target.width - width) / 2
            y = tp.y + target.height + m; break
        case "left":
            x = tp.x - width - m
            y = tp.y + (target.height - height) / 2; break
        case "right":
            x = tp.x + target.width + m
            y = tp.y + (target.height - height) / 2; break
        }

        // Clamp to parent bounds
        if (parent) {
            x = Math.max(m, Math.min(x, parent.width - width - m))
            y = Math.max(m, Math.min(y, parent.height - height - m))
        }
    }

    // ═══════════════════════════════════════════════════════════════════
    // PUBLIC FUNCTIONS
    // ═══════════════════════════════════════════════════════════════════

    function show() { _showTimer.start() }

    function hide() {
        _showTimer.stop()
        _hideTimer.stop()
        state = "hidden"
    }

    // ═══════════════════════════════════════════════════════════════════
    // TARGET CONNECTIONS
    // ═══════════════════════════════════════════════════════════════════

    Connections {
        target: root.target
        ignoreUnknownSignals: true
        function onHoveredChanged()       { root.target.hovered ? root.show() : root.hide() }
        function onContainsMouseChanged() { root.target.containsMouse ? root.show() : root.hide() }
    }
}
