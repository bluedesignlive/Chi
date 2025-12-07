import QtQuick
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Item {
    id: root

    property string text: ""
    property Item target: null
    property string position: "bottom"       // "top", "bottom", "left", "right"
    property int delay: 500
    property int showDuration: 1500          // 0 = show until mouse leaves
    property bool rich: false

    readonly property bool isVisible: state === "visible"

    visible: false
    z: 2000

    implicitWidth: tooltipContainer.width
    implicitHeight: tooltipContainer.height

    state: "hidden"

    states: [
        State {
            name: "hidden"
            PropertyChanges { target: tooltipContainer; opacity: 0; scale: 0.9 }
            PropertyChanges { target: root; visible: false }
        },
        State {
            name: "visible"
            PropertyChanges { target: tooltipContainer; opacity: 1; scale: 1 }
            PropertyChanges { target: root; visible: true }
        }
    ]

    transitions: [
        Transition {
            from: "hidden"; to: "visible"
            SequentialAnimation {
                PropertyAction { property: "visible"; value: true }
                NumberAnimation { properties: "opacity,scale"; duration: 150; easing.type: Easing.OutCubic }
            }
        },
        Transition {
            from: "visible"; to: "hidden"
            SequentialAnimation {
                NumberAnimation { properties: "opacity,scale"; duration: 100; easing.type: Easing.InCubic }
                PropertyAction { property: "visible"; value: false }
            }
        }
    ]

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        id: tooltipContainer
        width: rich ? richLabel.implicitWidth + 24 : plainLabel.implicitWidth + 16
        height: rich ? richLabel.implicitHeight + 16 : 24
        radius: rich ? 12 : 4
        color: rich ? colors.surfaceContainer : colors.inverseSurface

        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        layer.enabled: rich
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 2
            radius: 8
            samples: 17
            color: Qt.rgba(0, 0, 0, 0.2)
        }

        // Plain tooltip text
        Text {
            id: plainLabel
            visible: !rich
            anchors.centerIn: parent
            text: root.text
            font.family: "Roboto"
            font.pixelSize: 12
            color: colors.inverseOnSurface

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }

        // Rich tooltip text
        Text {
            id: richLabel
            visible: rich
            anchors.centerIn: parent
            text: root.text
            font.family: "Roboto"
            font.pixelSize: 14
            color: colors.onSurface
            wrapMode: Text.WordWrap
            maximumLineCount: 4

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }
    }

    Timer {
        id: showTimer
        interval: delay
        onTriggered: {
            positionTooltip()
            root.state = "visible"

            if (showDuration > 0) {
                hideTimer.start()
            }
        }
    }

    Timer {
        id: hideTimer
        interval: showDuration
        onTriggered: root.state = "hidden"
    }

    function positionTooltip() {
        if (!target || !target.parent) return

        var targetPos = target.mapToItem(root.parent, 0, 0)
        var margin = 8

        switch (position) {
        case "top":
            x = targetPos.x + (target.width - width) / 2
            y = targetPos.y - height - margin
            break
        case "bottom":
            x = targetPos.x + (target.width - width) / 2
            y = targetPos.y + target.height + margin
            break
        case "left":
            x = targetPos.x - width - margin
            y = targetPos.y + (target.height - height) / 2
            break
        case "right":
            x = targetPos.x + target.width + margin
            y = targetPos.y + (target.height - height) / 2
            break
        }

        // Keep within parent bounds
        if (parent) {
            if (x < margin) x = margin
            if (x + width > parent.width - margin) x = parent.width - width - margin
            if (y < margin) y = margin
            if (y + height > parent.height - margin) y = parent.height - height - margin
        }
    }

    function show() {
        showTimer.start()
    }

    function hide() {
        showTimer.stop()
        hideTimer.stop()
        state = "hidden"
    }

    // Connect to target hover events
    Connections {
        target: root.target

        function onHoveredChanged() {
            if (root.target.hovered !== undefined) {
                if (root.target.hovered) {
                    root.show()
                } else {
                    root.hide()
                }
            }
        }
    }

    // Alternative: use with MouseArea containsMouse
    Connections {
        target: root.target
        ignoreUnknownSignals: true

        function onContainsMouseChanged() {
            if (root.target.containsMouse) {
                root.show()
            } else {
                root.hide()
            }
        }
    }
}
