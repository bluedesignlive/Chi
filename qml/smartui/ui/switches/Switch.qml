// smartui/ui/switches/Switch.qml
import QtQuick
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Item {
    id: root

    property bool checked: false
    property bool enabled: true
    property bool showIcon: false
    property string icon: "✓"  // Default checkmark

    signal toggled()

    implicitWidth: 52
    implicitHeight: 32

    // Dim entire switch when disabled
    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    // States
    states: [
        State { name: "disabled"; when: !enabled },
        State { name: "pressed";  when: mouseArea.pressed && enabled },
        State { name: "focused";  when: root.activeFocus && enabled && !mouseArea.pressed },
        State { name: "hovered";  when: mouseArea.containsMouse && enabled && !mouseArea.pressed },
        State { name: "enabled";  when: enabled && !mouseArea.containsMouse && !mouseArea.pressed && !root.activeFocus }
    ]

    property var colors: Theme.ChiTheme.colors

    // Track
    Rectangle {
        id: track
        anchors.fill: parent
        radius: 100

        border.width: checked ? 0 : 2
        border.color: {
            if (!enabled) return Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.12)
            return colors.outline
        }

        color: {
            if (!enabled) {
                if (checked)
                    return Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.12)
                return Qt.rgba(colors.surfaceVariant.r, colors.surfaceVariant.g, colors.surfaceVariant.b, 0.12)
            }
            if (checked) return colors.primary
            return colors.surfaceContainerHighest
        }

        Behavior on color {
            ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
        }
        Behavior on border.color {
            ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
        }

        // Handle container
        Item {
            id: handleContainer
            anchors.fill: parent
            anchors.leftMargin:  checked ? 4 : (showIcon ? 4 : 8)
            anchors.rightMargin: checked ? 4 : (showIcon ? 4 : 8)
            anchors.topMargin:   checked ? 2 : (showIcon ? 4 : 2)
            anchors.bottomMargin:checked ? 2 : (showIcon ? 4 : 2)

            // 48x48 touch target
            Item {
                id: target
                width: 48
                height: 48
                anchors.verticalCenter: parent.verticalCenter

                // Position of handle target
                x: checked ? parent.width - width + 12 : (showIcon ? -12 : -16)
                Behavior on x {
                    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                }

                // State layer
                Rectangle {
                    id: stateLayer
                    anchors.centerIn: parent
                    width: 40
                    height: 40
                    radius: 20

                    color: checked ? colors.primary : colors.onSurface

                    opacity: {
                        if (!enabled) return 0
                        switch (root.state) {
                        case "pressed": return 0.12
                        case "focused": return 0.12
                        case "hovered": return 0.08
                        default:        return 0
                        }
                    }

                    Behavior on opacity {
                        NumberAnimation {
                            duration: root.state === "pressed" ? 50 : 150
                            easing.type: Easing.OutCubic
                        }
                    }
                    Behavior on color {
                        ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
                    }
                }

                // Handle
                Rectangle {
                    id: handle
                    anchors.centerIn: parent

                    width: {
                        if (!enabled)
                            return showIcon ? 24 : (checked ? 24 : 16)
                        if (root.state === "pressed")
                            return 28
                        return showIcon ? 24 : (checked ? 24 : 16)
                    }
                    height: width
                    radius: width / 2

                    color: {
                        if (!enabled) {
                            if (checked) return colors.surface
                            return colors.onSurface
                        }

                        if (checked) {
                            if (root.state === "enabled") return colors.onPrimary
                            return colors.primaryContainer
                        } else {
                            if (root.state === "enabled") return colors.outline
                            return colors.onSurfaceVariant
                        }
                    }

                    Behavior on width {
                        NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
                    }
                    Behavior on color {
                        ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
                    }

                    // Icon in handle
                    Text {
                        visible: showIcon && icon !== ""
                        anchors.centerIn: parent
                        text: icon
                        font.family: "Material Icons"
                        font.pixelSize: 16

                        color: {
                            if (!enabled) {
                                if (checked) return colors.onPrimaryContainer
                                return colors.surfaceContainerHighest
                            }
                            if (checked) return colors.onPrimaryContainer
                            return colors.surfaceContainerHighest
                        }

                        Behavior on color {
                            ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
                        }
                    }
                }
            }
        }

        // Focus ring
        Rectangle {
            id: focusIndicator
            anchors.fill: parent
            anchors.margins: -2
            radius: 100
            color: "transparent"
            border.width: 3
            border.color: colors.secondary
            visible: root.state === "focused"
            opacity: visible ? 1 : 0

            Behavior on opacity {
                NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
            }
        }
    }

    // Mouse interaction
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        anchors.margins: -8
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        onClicked: {
            checked = !checked
            toggled()
        }
    }

    // Keyboard
    Keys.onSpacePressed:  if (enabled) handleActivation()
    Keys.onEnterPressed:  if (enabled) handleActivation()
    Keys.onReturnPressed: if (enabled) handleActivation()

    function handleActivation() {
        checked = !checked
        toggled()
    }

    focusPolicy: Qt.StrongFocus
}
