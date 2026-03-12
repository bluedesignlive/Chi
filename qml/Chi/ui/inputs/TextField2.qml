import QtQuick
import QtQuick.Controls.Basic as T
import "../theme" as Theme

Item {
    id: root

    property alias text: control.text
    property alias placeholderText: control.placeholderText
    property alias echoMode: control.echoMode
    property alias inputMethodHints: control.inputMethodHints
    property alias readOnly: control.readOnly
    property alias length: control.length
    property alias acceptableInput: control.acceptableInput

    property string label: ""
    property string supportingText: ""
    property string errorText: ""
    property bool error: errorText.length > 0
    property string variant: "filled" // "filled" or "outlined"

    // Icons
    property string leadingIcon: ""
    property string trailingIcon: ""

    // Size specs (MD3)
    implicitWidth: 210
    implicitHeight: supportingText !== "" || errorText !== "" ? 76 : 56

    property bool focused: control.activeFocus
    property bool hasContent: control.text.length > 0

    // Internal access to colors
    property var colors: Theme.ChiTheme.colors

    T.TextField {
        id: control
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 56

        verticalAlignment: Text.AlignBottom
        topPadding: root.variant === "filled" ? 24 : 16
        bottomPadding: root.variant === "filled" ? 8 : 16
        leftPadding: root.leadingIcon !== "" ? 48 : 16
        rightPadding: root.trailingIcon !== "" ? 48 : 16

        font.family: "Roboto"
        font.pixelSize: 16
        color: enabled ? colors.onSurface : colors.onSurfaceVariant
        selectionColor: colors.primary
        selectedTextColor: colors.onPrimary

        background: Rectangle {
            id: bg
            color: {
                if (root.variant === "outlined") return "transparent"
                return root.enabled ? colors.surfaceContainerHighest : Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.04)
            }

            // Radii: MD3 Filled has top corners rounded, Outlined has all.
            radius: root.variant === "outlined" ? 4 : 4
            // If strictly following MD3 filled: radius only on top-left/top-right usually

            border.width: root.variant === "outlined" ? (root.focused || root.error ? 2 : 1) : 0
            border.color: {
                if (root.variant !== "outlined") return "transparent"
                if (root.error) return colors.error
                if (root.focused) return colors.primary
                return colors.outline
            }

            // Bottom Indicator for Filled Variant
            Rectangle {
                visible: root.variant === "filled"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: root.focused || root.error ? 2 : 1
                color: {
                    if (root.error) return colors.error
                    if (root.focused) return colors.primary
                    return colors.onSurfaceVariant
                }
            }
        }
    }

    // Floating Label
    Text {
        id: labelText
        text: root.label

        // Logic for floating state
        property bool isFloating: root.focused || root.hasContent

        x: root.leadingIcon !== "" ? 48 : 16
        y: isFloating ? 8 : 18 // Animated position

        font.family: "Roboto"
        font.pixelSize: isFloating ? 12 : 16
        font.letterSpacing: 0.4

        color: {
            if (!root.enabled) return colors.onSurfaceVariant // Opacity handled via parent
            if (root.error) return colors.error
            if (root.focused) return root.variant === "filled" ? colors.primary : colors.primary
            return colors.onSurfaceVariant
        }

        Behavior on y { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
        Behavior on font.pixelSize { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
        Behavior on color { ColorAnimation { duration: 150 } }
    }

    // Supporting Text / Error Text
    Text {
        visible: root.supportingText !== "" || root.errorText !== ""
        text: root.error ? root.errorText : root.supportingText
        anchors.top: control.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 4
        anchors.leftMargin: 16

        font.family: "Roboto"
        font.pixelSize: 12
        color: root.error ? colors.error : colors.onSurfaceVariant
    }

    // Leading Icon
    Text {
        visible: root.leadingIcon !== ""
        text: root.leadingIcon
        font.family: "Material Icons"
        font.pixelSize: 24
        color: colors.onSurfaceVariant
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.top: parent.top
        anchors.topMargin: 16
    }
}
