import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme

Item {
    id: root

    property real value: 0
    property real from: 0
    property real to: 100
    property real stepSize: 1
    property int decimals: 0
    property bool editable: true
    property bool enabled: true
    property bool wrap: false
    property string size: "medium"           // "small", "medium", "large"

    signal valueModified()

    readonly property var sizeSpecs: ({
        small: { height: 32, width: 100, fontSize: 13, buttonSize: 28 },
        medium: { height: 40, width: 120, fontSize: 14, buttonSize: 36 },
        large: { height: 48, width: 140, fontSize: 16, buttonSize: 44 }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.medium

    implicitWidth: currentSize.width
    implicitHeight: currentSize.height

    opacity: enabled ? 1.0 : 0.38

    property var colors: Theme.ChiTheme.colors
    readonly property string fontFamily: Theme.ChiTheme.fontFamily

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: colors.surfaceContainerHighest
        border.width: 1
        border.color: colors.outline

        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        RowLayout {
            anchors.fill: parent
            spacing: 0

            // Decrease button
            Item {
                Layout.preferredWidth: currentSize.buttonSize
                Layout.preferredHeight: currentSize.buttonSize
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: 2

                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: colors.onSurface
                    opacity: decMouse.containsMouse && enabled ? 0.08 : 0
                }

                Text {
                    anchors.centerIn: parent
                    text: "−"
                    font.pixelSize: 18
                    font.weight: Font.Medium
                    color: value <= from && !wrap ? colors.onSurfaceVariant : colors.onSurface
                    opacity: value <= from && !wrap ? 0.5 : 1
                }

                MouseArea {
                    id: decMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                    enabled: root.enabled && (value > from || wrap)

                    onClicked: decrease()

                    onPressAndHold: decreaseTimer.start()
                    onReleased: decreaseTimer.stop()
                }

                Timer {
                    id: decreaseTimer
                    interval: 100
                    repeat: true
                    onTriggered: decrease()
                }
            }

            // Value display/input
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                TextInput {
                    anchors.centerIn: parent
                    width: parent.width - 8
                    horizontalAlignment: Text.AlignHCenter
                    font.family: fontFamily
                    font.pixelSize: currentSize.fontSize
                    font.weight: Font.Medium
                    color: colors.onSurface
                    readOnly: !editable
                    enabled: root.enabled

                    text: value.toFixed(decimals)

                    validator: DoubleValidator {
                        bottom: from
                        top: to
                        decimals: root.decimals
                    }

                    onEditingFinished: {
                        var newVal = parseFloat(text)
                        if (!isNaN(newVal)) {
                            value = Math.max(from, Math.min(to, newVal))
                            valueModified()
                        }
                        text = Qt.binding(function() { return value.toFixed(decimals) })
                    }

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }
            }

            // Increase button
            Item {
                Layout.preferredWidth: currentSize.buttonSize
                Layout.preferredHeight: currentSize.buttonSize
                Layout.alignment: Qt.AlignVCenter
                Layout.rightMargin: 2

                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: colors.onSurface
                    opacity: incMouse.containsMouse && enabled ? 0.08 : 0
                }

                Text {
                    anchors.centerIn: parent
                    text: "+"
                    font.pixelSize: 18
                    font.weight: Font.Medium
                    color: value >= to && !wrap ? colors.onSurfaceVariant : colors.onSurface
                    opacity: value >= to && !wrap ? 0.5 : 1
                }

                MouseArea {
                    id: incMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                    enabled: root.enabled && (value < to || wrap)

                    onClicked: increase()

                    onPressAndHold: increaseTimer.start()
                    onReleased: increaseTimer.stop()
                }

                Timer {
                    id: increaseTimer
                    interval: 100
                    repeat: true
                    onTriggered: increase()
                }
            }
        }
    }

    function increase() {
        if (value + stepSize > to) {
            if (wrap) value = from
        } else {
            value += stepSize
        }
        valueModified()
    }

    function decrease() {
        if (value - stepSize < from) {
            if (wrap) value = to
        } else {
            value -= stepSize
        }
        valueModified()
    }

    Keys.onUpPressed: if (enabled) increase()
    Keys.onDownPressed: if (enabled) decrease()

    Accessible.role: Accessible.SpinBox
    Accessible.name: "Number input"
    Accessible.description: "Current value: " + value.toString()
}
