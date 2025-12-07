// qml/smartui/ui/inputs/TextField.qml
import QtQuick
import QtQuick.Controls.Basic
import "../../theme" as Theme

Item {
    id: root

    property string text: ""
    property string placeholderText: ""
    property string label: ""
    property string supportingText: ""
    property string errorText: ""
    property string leadingIcon: ""
    property string trailingIcon: ""
    property string variant: "filled"        // "filled" or "outlined"
    property string size: "medium"           // "small", "medium", "large"
    property bool enabled: true
    property bool error: false
    property bool readOnly: false
    property bool password: false
    property bool showCharacterCount: false
    property int maxLength: -1
    property int inputMethodHints: Qt.ImhNone

    signal accepted()
    signal editingFinished()
    signal trailingIconClicked()

    readonly property bool hasLeadingIcon: leadingIcon !== ""
    readonly property bool hasTrailingIcon: trailingIcon !== ""
    readonly property bool hasLabel: label !== ""
    readonly property bool hasSupportingText: supportingText !== "" || (error && errorText !== "")
    readonly property bool isFocused: textInput.activeFocus
    readonly property bool hasText: textInput.text.length > 0
    readonly property bool labelFloated: isFocused || hasText

    readonly property var sizeSpecs: ({
        small: {
            height: 48,
            fontSize: 14,
            labelFontSize: 12,
            iconSize: 20,
            horizontalPadding: 12,
            topPadding: 8,
            bottomPadding: 8
        },
        medium: {
            height: 56,
            fontSize: 16,
            labelFontSize: 12,
            iconSize: 24,
            horizontalPadding: 16,
            topPadding: 8,
            bottomPadding: 8
        },
        large: {
            height: 64,
            fontSize: 18,
            labelFontSize: 14,
            iconSize: 28,
            horizontalPadding: 20,
            topPadding: 12,
            bottomPadding: 12
        }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.medium

    implicitWidth: 280
    implicitHeight: currentSize.height + (hasSupportingText ? 20 : 0)

    opacity: enabled ? 1.0 : 0.38

    Behavior on opacity {
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
    }

    property var colors: Theme.ChiTheme.colors

    Column {
        anchors.fill: parent
        spacing: 4

        // Main container
        Rectangle {
            id: container
            width: parent.width
            height: currentSize.height
            radius: variant === "filled" ? 4 : 4

            color: {
                if (variant === "outlined") return "transparent"
                if (!enabled) return Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.04)
                if (error) return Qt.rgba(colors.errorContainer.r, colors.errorContainer.g, colors.errorContainer.b, 0.3)
                return colors.surfaceContainerHighest
            }

            Behavior on color {
                ColorAnimation { duration: 150 }
            }

            // Bottom border for filled variant
            Rectangle {
                visible: variant === "filled"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: isFocused ? 2 : 1
                color: {
                    if (!enabled) return colors.onSurface
                    if (error) return colors.error
                    if (isFocused) return colors.primary
                    return colors.onSurfaceVariant
                }
                opacity: enabled ? 1 : 0.38

                Behavior on height {
                    NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
                }
                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            // Outline border for outlined variant
            Rectangle {
                visible: variant === "outlined"
                anchors.fill: parent
                radius: parent.radius
                color: "transparent"
                border.width: isFocused ? 2 : 1
                border.color: {
                    if (!enabled) return colors.outline
                    if (error) return colors.error
                    if (isFocused) return colors.primary
                    return colors.outline
                }

                Behavior on border.width {
                    NumberAnimation { duration: 100 }
                }
                Behavior on border.color {
                    ColorAnimation { duration: 150 }
                }
            }

            // Floating label
            Text {
                id: floatingLabel
                visible: hasLabel
                text: label

                font.family: "Roboto"
                font.pixelSize: labelFloated ? currentSize.labelFontSize : currentSize.fontSize
                font.weight: Font.Normal

                color: {
                    if (!enabled) return colors.onSurface
                    if (error) return colors.error
                    if (isFocused) return colors.primary
                    return colors.onSurfaceVariant
                }

                x: hasLeadingIcon ? currentSize.horizontalPadding + currentSize.iconSize + 12 : currentSize.horizontalPadding
                y: labelFloated ? (variant === "filled" ? 8 : -height/2) : (parent.height - height) / 2

                Behavior on x {
                    NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                }
                Behavior on y {
                    NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                }
                Behavior on font.pixelSize {
                    NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                }
                Behavior on color {
                    ColorAnimation { duration: 150 }
                }

                // Background for outlined variant label
                Rectangle {
                    visible: variant === "outlined" && labelFloated
                    anchors.fill: parent
                    anchors.margins: -2
                    color: colors.background
                    z: -1

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }
            }

            // Content row
            Row {
                anchors.fill: parent
                anchors.leftMargin: currentSize.horizontalPadding
                anchors.rightMargin: currentSize.horizontalPadding
                anchors.topMargin: hasLabel && variant === "filled" ? 16 : 0
                spacing: 12

                // Leading icon
                Text {
                    visible: hasLeadingIcon
                    text: leadingIcon
                    font.family: "Material Icons"
                    font.pixelSize: currentSize.iconSize
                    color: error ? colors.error : colors.onSurfaceVariant
                    anchors.verticalCenter: parent.verticalCenter

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }

                // Text input
                TextInput {
                    id: textInput
                    width: parent.width - (hasLeadingIcon ? currentSize.iconSize + 12 : 0) - (hasTrailingIcon ? currentSize.iconSize + 12 : 0)
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter

                    text: root.text
                    font.family: "Roboto"
                    font.pixelSize: currentSize.fontSize
                    color: enabled ? colors.onSurface : colors.onSurface
                    selectionColor: colors.primaryContainer
                    selectedTextColor: colors.onPrimaryContainer
                    verticalAlignment: Text.AlignVCenter

                    enabled: root.enabled && !readOnly
                    echoMode: password ? TextInput.Password : TextInput.Normal
                    maximumLength: maxLength > 0 ? maxLength : 32767
                    inputMethodHints: root.inputMethodHints
                    selectByMouse: true
                    clip: true

                    onTextChanged: root.text = text
                    onAccepted: root.accepted()
                    onEditingFinished: root.editingFinished()

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }

                    // Placeholder
                    Text {
                        visible: !hasLabel && !textInput.text && !isFocused
                        anchors.fill: parent
                        text: placeholderText
                        font: textInput.font
                        color: colors.onSurfaceVariant
                        verticalAlignment: Text.AlignVCenter

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                    }
                }

                // Trailing icon
                Text {
                    visible: hasTrailingIcon
                    text: trailingIcon
                    font.family: "Material Icons"
                    font.pixelSize: currentSize.iconSize
                    color: error ? colors.error : colors.onSurfaceVariant
                    anchors.verticalCenter: parent.verticalCenter

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -8
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.trailingIconClicked()
                    }
                }
            }

            // Hover/Focus state layer
            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: colors.onSurface
                opacity: {
                    if (!enabled) return 0
                    if (isFocused) return 0
                    if (mouseArea.containsMouse) return 0.08
                    return 0
                }

                Behavior on opacity {
                    NumberAnimation { duration: 150 }
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: enabled ? Qt.IBeamCursor : Qt.ArrowCursor
                onClicked: textInput.forceActiveFocus()
            }
        }

        // Supporting/Error text row
        Row {
            visible: hasSupportingText || showCharacterCount
            width: parent.width
            spacing: 16

            Text {
                visible: hasSupportingText
                width: parent.width - (showCharacterCount ? charCount.width + 16 : 0)
                text: error && errorText !== "" ? errorText : supportingText
                font.family: "Roboto"
                font.pixelSize: 12
                color: error ? colors.error : colors.onSurfaceVariant
                wrapMode: Text.WordWrap
                leftPadding: currentSize.horizontalPadding

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            Item { width: parent.width - charCount.width - currentSize.horizontalPadding; height: 1; visible: !hasSupportingText && showCharacterCount }

            Text {
                id: charCount
                visible: showCharacterCount && maxLength > 0
                text: textInput.text.length + "/" + maxLength
                font.family: "Roboto"
                font.pixelSize: 12
                color: error ? colors.error : colors.onSurfaceVariant
                horizontalAlignment: Text.AlignRight
                rightPadding: currentSize.horizontalPadding

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }
        }
    }

    function clear() {
        textInput.clear()
    }

    function selectAll() {
        textInput.selectAll()
    }

    function focus() {
        textInput.forceActiveFocus()
    }

    Accessible.role: Accessible.EditableText
    Accessible.name: label || placeholderText
    Accessible.description: supportingText
}
