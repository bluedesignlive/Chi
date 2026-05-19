// ConnectedIconButtonGroup.qml — Icon-only Connected Button Group
// All animation tokens from ChiMotion — no hardcoded values

import QtQuick
import QtQuick.Effects
import "../../theme" as Theme

Item {
    id: iconGroup

    property string size: "small"
    property string shape: "round"
    property string selectionMode: "single"
    property bool enabled: true
    property bool elevated: false
    property string iconFont: Theme.ChiTheme.iconFamily
    property var icons: []

    property int selectedIndex: -1
    property var selectedIndices: []

    signal selectionChanged(var indices)
    signal itemClicked(int index)

    readonly property var sizeSpecs: Theme.SizeSpecs.getSpec(Theme.SizeSpecs.connectedButtonGroup, size)
    readonly property var cs: sizeSpecs

    readonly property bool _isRound: shape === "round"
    readonly property var colors: Theme.ChiTheme.colors

    readonly property int _dur: Theme.ChiMotion.duration.medium2
    readonly property int _stateLayerShow: Theme.ChiMotion.spring.fast.effects.duration
    readonly property int _stateLayerHover: Theme.ChiMotion.duration.medium2
    readonly property int _rippleFadeIn: Theme.ChiMotion.spring.fast.effects.duration
    readonly property int _rippleFadeOut: Theme.ChiMotion.duration.long2

    implicitWidth: container.implicitWidth
    implicitHeight: cs.height

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity {
        enabled: Theme.ChiMotion.animationsEnabled
        NumberAnimation {
            duration: _dur
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Theme.ChiMotion.easing.standard
        }
    }

    Rectangle {
        id: container
        anchors.fill: parent
        radius: iconGroup._isRound ? cs.outerRadius : cs.squareRadius
        color: colors.surfaceContainerLow
        clip: true

        implicitWidth: iconRow.implicitWidth + cs.innerPadding * 2
        implicitHeight: cs.height

        // Elevation shadow — token-based
        layer.enabled: iconGroup.elevated && iconGroup.enabled
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Theme.ChiElevation.shadowColor(Theme.ChiElevation.level1)
            shadowOpacity: Theme.ChiElevation.shadowOpacity(Theme.ChiElevation.level1)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: Theme.ChiElevation.verticalOffset(Theme.ChiElevation.level1)
            shadowBlur: Theme.ChiElevation.blurRadius(Theme.ChiElevation.level1)
        }

        Row {
            id: iconRow
            anchors.centerIn: parent
            spacing: cs.innerPadding

            Repeater {
                model: iconGroup.icons

                Rectangle {
                    property bool isFirst: index === 0
                    property bool isLast: index === iconGroup.icons.length - 1
                    property bool isSelected: iconGroup.selectedIndices.indexOf(index) !== -1
                    property bool isPressed: iconMouse.pressed
                    property bool isHovered: iconMouse.containsMouse

                    readonly property color _stateColor: isSelected ? colors.onSecondaryContainer : colors.onSurfaceVariant

                    width: Math.max(cs.minWidth, cs.width)
                    height: cs.height - cs.innerPadding * 2

                    property real baseLeft: isFirst ? (iconGroup._isRound ? cs.outerRadius - cs.innerPadding : cs.squareRadius) : cs.innerRadius
                    property real baseRight: isLast ? (iconGroup._isRound ? cs.outerRadius - cs.innerPadding : cs.squareRadius) : cs.innerRadius

                    topLeftRadius: (isSelected || isPressed) ? cs.innerRadius : baseLeft
                    bottomLeftRadius: (isSelected || isPressed) ? cs.innerRadius : baseLeft
                    topRightRadius: (isSelected || isPressed) ? cs.innerRadius : baseRight
                    bottomRightRadius: (isSelected || isPressed) ? cs.innerRadius : baseRight

                    Behavior on topLeftRadius {
                        enabled: Theme.ChiMotion.animationsEnabled
                        NumberAnimation {
                            duration: _dur
                            easing.type: Theme.ChiMotion.easing.emphasized
                            easing.bezierCurve: Theme.ChiMotion.easing.emphasizedInControlPoints
                        }
                    }
                    Behavior on bottomLeftRadius {
                        enabled: Theme.ChiMotion.animationsEnabled
                        NumberAnimation {
                            duration: _dur
                            easing.type: Theme.ChiMotion.easing.emphasized
                            easing.bezierCurve: Theme.ChiMotion.easing.emphasizedInControlPoints
                        }
                    }
                    Behavior on topRightRadius {
                        enabled: Theme.ChiMotion.animationsEnabled
                        NumberAnimation {
                            duration: _dur
                            easing.type: Theme.ChiMotion.easing.emphasized
                            easing.bezierCurve: Theme.ChiMotion.easing.emphasizedInControlPoints
                        }
                    }
                    Behavior on bottomRightRadius {
                        enabled: Theme.ChiMotion.animationsEnabled
                        NumberAnimation {
                            duration: _dur
                            easing.type: Theme.ChiMotion.easing.emphasized
                            easing.bezierCurve: Theme.ChiMotion.easing.emphasizedInControlPoints
                        }
                    }

                    color: isSelected ? colors.secondaryContainer : colors.surfaceContainerLow
                    Behavior on color {
                        enabled: Theme.ChiMotion.animationsEnabled
                        ColorAnimation {
                            duration: _dur
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Theme.ChiMotion.easing.standard
                        }
                    }
                    clip: true

                    // Ripple — using Common.Ripple
                    Rectangle {
                        anchors.fill: parent
                        topLeftRadius: parent.topLeftRadius
                        bottomLeftRadius: parent.bottomLeftRadius
                        topRightRadius: parent.topRightRadius
                        bottomRightRadius: parent.bottomRightRadius
                        color: parent._stateColor
                        opacity: 0

                        SequentialAnimation on opacity {
                            id: iconRipple
                            running: false
                            NumberAnimation {
                                from: 0
                                to: 0.16
                                duration: _rippleFadeIn
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Theme.ChiMotion.easing.standard
                            }
                            NumberAnimation {
                                to: 0
                                duration: _rippleFadeOut
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Theme.ChiMotion.easing.standard
                            }
                        }
                    }

                    // State layer
                    Rectangle {
                        anchors.fill: parent
                        topLeftRadius: parent.topLeftRadius
                        bottomLeftRadius: parent.bottomLeftRadius
                        topRightRadius: parent.topRightRadius
                        bottomRightRadius: parent.bottomRightRadius
                        color: parent._stateColor
                        opacity: isPressed ? Theme.ChiMotion.stateLayer.pressed : (isHovered ? Theme.ChiMotion.stateLayer.hover : 0)
                        Behavior on opacity {
                            enabled: Theme.ChiMotion.animationsEnabled
                            NumberAnimation {
                                duration: isPressed ? _stateLayerShow : _stateLayerHover
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Theme.ChiMotion.easing.standard
                            }
                        }
                    }

                    // Icon
                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        font.family: iconGroup.iconFont
                        font.pixelSize: cs.iconSize
                        color: parent._stateColor
                        Behavior on color {
                            enabled: Theme.ChiMotion.animationsEnabled
                            ColorAnimation {
                                duration: _dur
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Theme.ChiMotion.easing.standard
                            }
                        }
                    }

                    MouseArea {
                        id: iconMouse
                        anchors.fill: parent
                        enabled: iconGroup.enabled
                        hoverEnabled: true
                        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onPressed: iconRipple.restart()
                        onClicked: iconGroup.handleClick(index)
                    }
                }
            }
        }
    }

    function handleClick(index) {
        itemClicked(index);
        var newIndices = selectedIndices.slice();

        if (selectionMode === "single") {
            newIndices = [index];
            selectedIndex = index;
        } else if (selectionMode === "multi") {
            var idx = newIndices.indexOf(index);
            if (idx !== -1)
                newIndices.splice(idx, 1);
            else {
                newIndices.push(index);
                newIndices.sort();
            }
        } else if (selectionMode === "required") {
            var idx2 = newIndices.indexOf(index);
            if (idx2 !== -1 && newIndices.length > 1)
                newIndices.splice(idx2, 1);
            else if (idx2 === -1)
                newIndices = [index];
            selectedIndex = newIndices[0] !== undefined ? newIndices[0] : -1;
        }

        selectedIndices = newIndices;
        selectionChanged(selectedIndices);
    }

    Component.onCompleted: {
        if (selectionMode === "required" && selectedIndices.length === 0 && icons.length > 0) {
            selectedIndex = 0;
            selectedIndices = [0];
        }
    }
}
