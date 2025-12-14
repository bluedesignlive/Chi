import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme
import "../common" as Common

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
    property string size: "medium"

    signal valueModified()

    readonly property var sizeSpecs: ({
        small: { height: 32, width: 100, fontSize: 13, buttonSize: 28, iconSize: 16 },
        medium: { height: 40, width: 120, fontSize: 14, buttonSize: 36, iconSize: 20 },
        large: { height: 48, width: 140, fontSize: 16, buttonSize: 44, iconSize: 24 }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.medium

    implicitWidth: currentSize.width
    implicitHeight: currentSize.height

    opacity: enabled ? 1.0 : 0.38

    property var colors: Theme.ChiTheme.colors
    property var motion: Theme.ChiTheme.motion

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

            Item {
                Layout.preferredWidth: currentSize.buttonSize
                Layout.preferredHeight: currentSize.buttonSize
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: 2

                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: colors.onSurface
                    opacity: decMouse.containsMouse && root.enabled && (root.value > root.from || root.wrap) ? 0.08 : 0

                    Behavior on opacity {
                        NumberAnimation { duration: 100 }
                    }
                }

                Common.Icon {
                    anchors.centerIn: parent
                    source: "remove"
                    size: currentSize.iconSize
                    color: root.value <= root.from && !root.wrap ? colors.onSurfaceVariant : colors.onSurface
                    opacity: root.value <= root.from && !root.wrap ? 0.5 : 1

                    Behavior on opacity {
                        NumberAnimation { duration: 150 }
                    }
                }

                MouseArea {
                    id: decMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: root.enabled && (root.value > root.from || root.wrap) ? Qt.PointingHandCursor : Qt.ArrowCursor
                    enabled: root.enabled && (root.value > root.from || root.wrap)

                    onClicked: root.decrease()
                    onPressAndHold: decreaseTimer.start()
                    onReleased: decreaseTimer.stop()
                }

                Timer {
                    id: decreaseTimer
                    interval: 100
                    repeat: true
                    onTriggered: root.decrease()
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                TextInput {
                    id: valueInput
                    anchors.centerIn: parent
                    width: parent.width - 8
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Roboto"
                    font.pixelSize: currentSize.fontSize
                    font.weight: Font.Medium
                    color: colors.onSurface
                    selectionColor: colors.primaryContainer
                    selectedTextColor: colors.onPrimaryContainer
                    readOnly: !root.editable
                    enabled: root.enabled
                    selectByMouse: true

                    text: root.value.toFixed(root.decimals)

                    validator: DoubleValidator {
                        bottom: root.from
                        top: root.to
                        decimals: root.decimals
                    }

                    onEditingFinished: {
                        var newVal = parseFloat(text)
                        if (!isNaN(newVal)) {
                            root.value = Math.max(root.from, Math.min(root.to, newVal))
                            root.valueModified()
                        }
                        text = Qt.binding(function() { return root.value.toFixed(root.decimals) })
                    }

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }
            }

            Item {
                Layout.preferredWidth: currentSize.buttonSize
                Layout.preferredHeight: currentSize.buttonSize
                Layout.alignment: Qt.AlignVCenter
                Layout.rightMargin: 2

                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: colors.onSurface
                    opacity: incMouse.containsMouse && root.enabled && (root.value < root.to || root.wrap) ? 0.08 : 0

                    Behavior on opacity {
                        NumberAnimation { duration: 100 }
                    }
                }

                Common.Icon {
                    anchors.centerIn: parent
                    source: "add"
                    size: currentSize.iconSize
                    color: root.value >= root.to && !root.wrap ? colors.onSurfaceVariant : colors.onSurface
                    opacity: root.value >= root.to && !root.wrap ? 0.5 : 1

                    Behavior on opacity {
                        NumberAnimation { duration: 150 }
                    }
                }

                MouseArea {
                    id: incMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: root.enabled && (root.value < root.to || root.wrap) ? Qt.PointingHandCursor : Qt.ArrowCursor
                    enabled: root.enabled && (root.value < root.to || root.wrap)

                    onClicked: root.increase()
                    onPressAndHold: increaseTimer.start()
                    onReleased: increaseTimer.stop()
                }

                Timer {
                    id: increaseTimer
                    interval: 100
                    repeat: true
                    onTriggered: root.increase()
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
    Accessible.description: "Value: " + value.toString()
}
