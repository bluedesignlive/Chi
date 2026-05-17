import QtQuick
import QtQuick.Effects
import "../../theme" as Theme

Item {
    id: root

    property string text: ""
    property Item target: null
    property string position: "bottom"
    property int delay: 500
    property int showDuration: 0
    property bool rich: false
    property bool showCaret: true
    property bool ready: false
    property Item positionTarget: null

    readonly property bool isVisible: state === "visible"

    signal shown

    visible: false
    z: 2000

    implicitWidth: _container.width
    implicitHeight: _container.height

    property var colors: Theme.ChiTheme.colors

    readonly property var _plainTypo: Theme.ChiTheme.typography.bodySmall
    readonly property var _richTypo: Theme.ChiTheme.typography.bodyMedium

    readonly property int _caretSize: 8

    state: "hidden"

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: _container
                opacity: 0
                scale: 0.92
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
                NumberAnimation {
                    duration: Theme.ChiMotion.entry.duration
                    properties: "opacity,scale"
                    easing.type: Easing.Bezier
                    easing.bezierCurve: Theme.ChiMotion.entry.curve
                }
            }
        },
        Transition {
            from: "visible"
            to: "hidden"
            enabled: Theme.ChiMotion.animationsEnabled
            SequentialAnimation {
                NumberAnimation {
                    duration: Theme.ChiMotion.exit.duration
                    properties: "opacity,scale"
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

    Rectangle {
        id: _container
        width: rich ? _richLabel.implicitWidth + 24 : _plainLabel.implicitWidth + 16
        height: rich ? _richLabel.implicitHeight + 16 : 24
        radius: rich ? 12 : 4
        color: rich ? colors.surfaceContainer : colors.inverseSurface

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.15)
            shadowVerticalOffset: 1
            shadowBlur: 0.2
        }

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

        Rectangle {
            id: _caret
            visible: root.showCaret
            x: (_container.width - _caretSize) / 2
            y: {
                if (root.position === "top")
                    return parent.height - _caretSize / 2;
                if (root.position === "bottom")
                    return -_caretSize / 2;
                return (parent.height - _caretSize) / 2;
            }
            width: _caretSize
            height: _caretSize
            color: parent.color
            transform: Rotation {
                origin.x: _caretSize / 2
                origin.y: _caretSize / 2
                angle: 45
            }

            Behavior on x {
                enabled: Theme.ChiMotion.animationsEnabled
                NumberAnimation {
                    duration: Theme.ChiMotion.spring.fast.effects.duration
                    easing.type: Easing.Bezier
                    easing.bezierCurve: Theme.ChiMotion.spring.fast.spatial.curve
                }
            }
        }
    }

    Timer {
        id: _showTimer
        interval: root.delay
        onTriggered: {
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
        if (root.ready && root.target && root.target.containsMouse && root.text !== "") {
            _showTimer.stop();
            _positionTooltip();
            root.state = "visible";
            if (root.showDuration > 0)
                _hideTimer.start();
        }
    }

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

        // Clamp to parent bounds
        if (parent) {
            x = Math.max(m, Math.min(x, parent.width - width - m));
            y = Math.max(m, Math.min(y, parent.height - height - m));
        }

        _positionCaret();
    }

    function _positionCaret() {
        if (!root.showCaret)
            return;
        var tgt = root.positionTarget || root.target;
        if (tgt) {
            var tc = tgt.mapToItem(_container, tgt.width / 2, 0);
            _caret.x = Math.max(4, Math.min(tc.x - _caretSize / 2, _container.width - _caretSize - 4));
        } else {
            _caret.x = (_container.width - _caretSize) / 2;
        }
    }

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
            _showTimer.start();
        }
    }

    function hide() {
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
