// qml/smartui/ui/selection/Slider.qml
import QtQuick
import "../../theme" as Theme

Item {
    id: root

    property real value: 0.5
    property real from: 0.0
    property real to: 1.0
    property real stepSize: 0.0
    property bool enabled: true
    property string size: "medium"           // "small", "medium", "large"
    property bool showValue: false
    property bool discrete: false            // Show tick marks
    property int tickCount: 5

    signal moved()
    signal pressedChanged(bool pressed)

    readonly property real position: (value - from) / (to - from)
    readonly property bool isPressed: handleMouse.pressed

    readonly property var sizeSpecs: ({
        small: { trackHeight: 4, handleSize: 16, activeTrackHeight: 4 },
        medium: { trackHeight: 4, handleSize: 20, activeTrackHeight: 6 },
        large: { trackHeight: 6, handleSize: 24, activeTrackHeight: 8 }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.medium

    implicitWidth: 200
    implicitHeight: Math.max(currentSize.handleSize + 16, 48)

    opacity: enabled ? 1.0 : 0.38

    Behavior on opacity {
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
    }

    property var colors: Theme.ChiTheme.colors

    // Track container
    Item {
        id: trackContainer
        anchors.centerIn: parent
        width: parent.width - currentSize.handleSize
        height: parent.height

        // Inactive track
        Rectangle {
            anchors.centerIn: parent
            width: parent.width
            height: currentSize.trackHeight
            radius: height / 2
            color: colors.secondaryContainer

            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }

        // Active track
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            width: parent.width * position
            height: isPressed ? currentSize.activeTrackHeight : currentSize.trackHeight
            radius: height / 2
            color: colors.primary

            Behavior on height {
                NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
            }
            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }

        // Tick marks (for discrete mode)
        Row {
            visible: discrete && tickCount > 1
            anchors.centerIn: parent
            width: parent.width
            spacing: (parent.width - (tickCount * 4)) / (tickCount - 1)

            Repeater {
                model: discrete ? tickCount : 0

                Rectangle {
                    width: 4
                    height: 4
                    radius: 2
                    color: {
                        var tickPosition = index / (tickCount - 1)
                        return tickPosition <= position ? colors.onPrimary : colors.onSurfaceVariant
                    }
                    anchors.verticalCenter: parent.verticalCenter

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }
            }
        }

        // Handle
        Item {
            id: handle
            x: (parent.width * position) - currentSize.handleSize / 2
            anchors.verticalCenter: parent.verticalCenter
            width: currentSize.handleSize
            height: currentSize.handleSize

            // State layer
            Rectangle {
                anchors.centerIn: parent
                width: 40
                height: 40
                radius: 20
                color: colors.primary
                opacity: {
                    if (!enabled) return 0
                    if (handleMouse.pressed) return 0.12
                    if (handleMouse.containsMouse) return 0.08
                    if (root.activeFocus) return 0.12
                    return 0
                }

                Behavior on opacity {
                    NumberAnimation { duration: 100 }
                }
            }

            // Handle circle
            Rectangle {
                anchors.centerIn: parent
                width: isPressed ? currentSize.handleSize + 4 : currentSize.handleSize
                height: width
                radius: width / 2
                color: colors.primary

                Behavior on width {
                    NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
                }
                Behavior on color {
                    ColorAnimation { duration: 150 }
                }

                // Handle shadow
                layer.enabled: true
                layer.effect: Item {
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -2
                        radius: width / 2
                        color: "transparent"
                        border.width: 0

                        Rectangle {
                            anchors.centerIn: parent
                            width: parent.width
                            height: parent.height
                            radius: width / 2
                            color: Qt.rgba(0, 0, 0, 0.15)
                            y: 2
                            z: -1
                        }
                    }
                }
            }

            // Value label (shows on press)
            Rectangle {
                visible: showValue && isPressed
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.top
                anchors.bottomMargin: 4
                width: valueLabel.width + 16
                height: 28
                radius: 14
                color: colors.primary

                Text {
                    id: valueLabel
                    anchors.centerIn: parent
                    text: stepSize >= 1 ? Math.round(value) : value.toFixed(1)
                    font.family: "Roboto"
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    color: colors.onPrimary
                }

                // Pointer
                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.bottom
                    anchors.topMargin: -4
                    width: 8
                    height: 8
                    rotation: 45
                    color: parent.color
                }
            }

            MouseArea {
                id: handleMouse
                anchors.fill: parent
                anchors.margins: -12
                enabled: root.enabled
                hoverEnabled: true
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                preventStealing: true

                drag.target: dragTarget
                drag.axis: Drag.XAxis
                drag.minimumX: 0
                drag.maximumX: trackContainer.width

                onPressed: root.pressedChanged(true)
                onReleased: root.pressedChanged(false)
            }
        }

        // Invisible drag target
        Item {
            id: dragTarget
            x: parent.width * position
            onXChanged: {
                if (handleMouse.pressed) {
                    var newPosition = x / trackContainer.width
                    newPosition = Math.max(0, Math.min(1, newPosition))

                    var newValue = from + newPosition * (to - from)

                    if (stepSize > 0) {
                        newValue = Math.round(newValue / stepSize) * stepSize
                    }

                    newValue = Math.max(from, Math.min(to, newValue))

                    if (newValue !== value) {
                        value = newValue
                        root.moved()
                    }
                }
            }
        }

        // Track click area
        MouseArea {
            anchors.fill: parent
            anchors.margins: -8
            enabled: root.enabled
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

            onClicked: (mouse) => {
                var newPosition = mouse.x / width
                newPosition = Math.max(0, Math.min(1, newPosition))

                var newValue = from + newPosition * (to - from)

                if (stepSize > 0) {
                    newValue = Math.round(newValue / stepSize) * stepSize
                }

                value = Math.max(from, Math.min(to, newValue))
                root.moved()
            }
        }
    }

    // Keyboard navigation
    Keys.onLeftPressed: if (enabled) decreaseValue()
    Keys.onRightPressed: if (enabled) increaseValue()

    function increaseValue() {
        var step = stepSize > 0 ? stepSize : (to - from) / 10
        value = Math.min(to, value + step)
        moved()
    }

    function decreaseValue() {
        var step = stepSize > 0 ? stepSize : (to - from) / 10
        value = Math.max(from, value - step)
        moved()
    }

    Accessible.role: Accessible.Slider
    Accessible.name: "Slider"
    Accessible.value: value.toString()
}
