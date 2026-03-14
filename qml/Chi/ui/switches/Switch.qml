// Switch — Material 3 toggle switch with size variants
import QtQuick
import "../../theme" as Theme

Item {
    id: root

    property bool checked: false
    property bool enabled: true
    property bool showIcon: false
    property string icon: "✓"  // Default checkmark

    // Size variants: small=compact, medium=comfortable, large=expressive
    property string size: "medium"

    // Scale factor applied to all geometry
    readonly property real s: size === "small" ? 0.7 : (size === "large" ? 1.0 : 0.85)

    signal toggled()

    implicitWidth: 52 * s
    implicitHeight: 32 * s

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

    property var colors: Theme.ChiTheme.colors

    // Track
    Rectangle {
        id: track
        anchors.fill: parent
        radius: 1000

        border.width: root.checked ? 0 : 2
        border.color: !root.enabled ?
            Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.12) : colors.outline

        color: {
            if (!root.enabled) {
                var c = root.checked ? colors.onSurface : colors.surfaceVariant
                return Qt.rgba(c.r, c.g, c.b, 0.12)
            }
            return root.checked ? colors.primary : colors.surfaceContainerHighest
        }

        Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.OutCubic } }
        Behavior on border.color { ColorAnimation { duration: 200; easing.type: Easing.OutCubic } }

        // Handle container
        Item {
            anchors.fill: parent
            anchors.leftMargin:   root.checked ? 4 * s : (root.showIcon ? 4 * s : 8 * s)
            anchors.rightMargin:  root.checked ? 4 * s : (root.showIcon ? 4 * s : 8 * s)
            anchors.topMargin:    root.checked ? 2 * s : (root.showIcon ? 4 * s : 2 * s)
            anchors.bottomMargin: root.checked ? 2 * s : (root.showIcon ? 4 * s : 2 * s)

            // Touch target
            Item {
                width: 48 * s; height: 48 * s
                anchors.verticalCenter: parent.verticalCenter
                x: root.checked
                   ? parent.width - width + 12 * s
                   : (root.showIcon ? -12 * s : -16 * s)

                Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

                // State layer
                Rectangle {
                    anchors.centerIn: parent
                    width: 40 * s; height: 40 * s; radius: 20 * s
                    color: root.checked ? colors.primary : colors.onSurface
                    opacity: !root.enabled ? 0 :
                             (mouseArea.pressed ? 0.12 :
                             (root.activeFocus ? 0.12 :
                             (mouseArea.containsMouse ? 0.08 : 0)))
                    Behavior on opacity {
                        NumberAnimation { duration: mouseArea.pressed ? 50 : 150; easing.type: Easing.OutCubic }
                    }
                    Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.OutCubic } }
                }

                // Handle
                Rectangle {
                    anchors.centerIn: parent
                    width: {
                        var baseW = root.showIcon || root.checked ? 24 : 16
                        if (root.enabled && mouseArea.pressed) baseW = 28
                        return baseW * s
                    }
                    height: width
                    radius: width * 0.5

                    color: {
                        if (!root.enabled)
                            return root.checked ? colors.surface : colors.onSurface
                        if (root.checked)
                            return (mouseArea.pressed || mouseArea.containsMouse || root.activeFocus) ? colors.primaryContainer : colors.onPrimary
                        return (mouseArea.pressed || mouseArea.containsMouse || root.activeFocus) ? colors.onSurfaceVariant : colors.outline
                    }

                    Behavior on width { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
                    Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.OutCubic } }

                    // Icon in handle
                    Text {
                        visible: root.showIcon && root.icon !== ""
                        anchors.centerIn: parent
                        text: root.icon
                        font.family: Theme.ChiTheme.iconFamily
                        font.pixelSize: 16 * s
                        color: root.checked ? colors.onPrimaryContainer : colors.surfaceContainerHighest
                        Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.OutCubic } }
                    }
                }
            }
        }

        // Focus ring
        Rectangle {
            anchors.fill: parent
            anchors.margins: -2 * s
            radius: 1000
            color: "transparent"
            border.width: 3
            border.color: colors.secondary
            visible: root.activeFocus && !mouseArea.pressed
        }
    }

    // Mouse interaction
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        anchors.margins: -8 * s
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: { root.checked = !root.checked; root.toggled() }
    }

    // Keyboard
    Keys.onSpacePressed:  if (enabled) _activate()
    Keys.onEnterPressed:  if (enabled) _activate()
    Keys.onReturnPressed: if (enabled) _activate()

    function _activate() { checked = !checked; toggled() }

    focusPolicy: Qt.StrongFocus
}
