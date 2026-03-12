// qml/smartui/ui/inputs/TextField.qml
import QtQuick
import QtQuick.Layouts
import "../theme" as Theme
import "../common" as Common
import "../menus" as Menus

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
    property string shape: "default"         // "default" or "rounded"
    property bool enabled: true
    property bool error: false
    property bool readOnly: false
    property bool password: false
    property bool showCharacterCount: false
    property bool showPasswordToggle: false
    property int maxLength: -1
    property int inputMethodHints: Qt.ImhNone

    // Context menu options
    property bool enableContextMenu: true
    property bool showCut: true
    property bool showCopy: true
    property bool showPaste: true
    property bool showSelectAll: true

    property alias inputField: textInput

    signal accepted()
    signal editingFinished()
    signal trailingIconClicked()
    signal leadingIconClicked()

    readonly property bool hasLeadingIcon: leadingIcon !== ""
    readonly property bool hasTrailingIcon: trailingIcon !== "" || showPasswordToggle
    readonly property bool hasLabel: label !== ""
    readonly property bool hasSupportingText: supportingText !== "" || (error && errorText !== "")
    readonly property bool isFocused: textInput.activeFocus
    readonly property bool hasText: textInput.text.length > 0
    readonly property bool labelFloated: isFocused || hasText
    readonly property bool hasSelection: textInput.selectedText.length > 0
    readonly property bool isRounded: shape === "rounded"

    // Stored selection for clipboard operations
    property string _storedSelectedText: ""
    property int _storedSelectionStart: 0
    property int _storedSelectionEnd: 0
    property bool _passwordVisible: false

    function _storeSelection() {
        _storedSelectedText = textInput.selectedText
        _storedSelectionStart = textInput.selectionStart
        _storedSelectionEnd = textInput.selectionEnd
    }

    function _restoreSelection() {
        if (_storedSelectionStart !== _storedSelectionEnd) {
            textInput.select(_storedSelectionStart, _storedSelectionEnd)
        }
    }

    readonly property var sizeSpecs: ({
        small: {
            height: 48,
            fontSize: 14,
            labelFontSize: 11,
            iconSize: 20,
            horizontalPadding: 12,
            roundedHorizontalPadding: 16,
            iconPadding: 8,
            labelTopPadding: 6,
            inputTopPadding: 20
        },
        medium: {
            height: 56,
            fontSize: 16,
            labelFontSize: 12,
            iconSize: 24,
            horizontalPadding: 16,
            roundedHorizontalPadding: 20,
            iconPadding: 12,
            labelTopPadding: 8,
            inputTopPadding: 24
        },
        large: {
            height: 64,
            fontSize: 18,
            labelFontSize: 12,
            iconSize: 28,
            horizontalPadding: 20,
            roundedHorizontalPadding: 24,
            iconPadding: 16,
            labelTopPadding: 10,
            inputTopPadding: 28
        }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.medium
    readonly property real effectivePadding: isRounded ? currentSize.roundedHorizontalPadding : currentSize.horizontalPadding
    readonly property real containerRadius: {
        if (isRounded) return currentSize.height / 2
        return 4
    }

    implicitWidth: 280
    implicitHeight: currentSize.height + (hasSupportingText ? 20 : 0)

    opacity: enabled ? 1.0 : 0.38

    Behavior on opacity {
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
    }

    property var colors: Theme.ChiTheme.colors
    property var motion: Theme.ChiTheme.motion

    // ═══════════════════════════════════════════════════════════════════
    // CLIPBOARD HELPER
    // ═══════════════════════════════════════════════════════════════════
    TextInput {
        id: _clipboardHelper
        visible: false
        width: 0
        height: 0
    }

    function _performCut() {
        if (_storedSelectedText.length > 0) {
            _clipboardHelper.text = _storedSelectedText
            _clipboardHelper.selectAll()
            _clipboardHelper.cut()

            var before = root.text.substring(0, _storedSelectionStart)
            var after = root.text.substring(_storedSelectionEnd)
            root.text = before + after
            textInput.text = root.text

            textInput.forceActiveFocus()
            textInput.cursorPosition = _storedSelectionStart
        }
    }

    function _performCopy() {
        if (_storedSelectedText.length > 0) {
            _clipboardHelper.text = _storedSelectedText
            _clipboardHelper.selectAll()
            _clipboardHelper.copy()

            textInput.forceActiveFocus()
            _restoreSelection()
        }
    }

    // ═══════════════════════════════════════════════════════════════════
    // CONTEXT MENU
    // ═══════════════════════════════════════════════════════════════════
    Menus.ContextMenu {
        id: contextMenu

        onOpenChanged: {
            if (!open && _storedSelectionStart !== _storedSelectionEnd) {
                Qt.callLater(function() {
                    textInput.forceActiveFocus()
                    root._restoreSelection()
                })
            }
        }

        Menus.MenuItem {
            visible: root.showCut && !root.readOnly
            text: "Cut"
            leadingIcon: "content_cut"
            trailingText: "Ctrl+X"
            enabled: root._storedSelectedText.length > 0 && root.enabled
            onClicked: root._performCut()
        }

        Menus.MenuItem {
            visible: root.showCopy
            text: "Copy"
            leadingIcon: "content_copy"
            trailingText: "Ctrl+C"
            enabled: root._storedSelectedText.length > 0
            onClicked: root._performCopy()
        }

        Menus.MenuItem {
            visible: root.showPaste && !root.readOnly
            text: "Paste"
            leadingIcon: "content_paste"
            trailingText: "Ctrl+V"
            enabled: textInput.canPaste && root.enabled
            onClicked: {
                textInput.forceActiveFocus()
                root._restoreSelection()
                textInput.paste()
            }
        }

        Menus.MenuDivider {
            visible: (root.showCut || root.showCopy || root.showPaste) && root.showSelectAll
        }

        Menus.MenuItem {
            visible: root.showSelectAll
            text: "Select All"
            leadingIcon: "select_all"
            trailingText: "Ctrl+A"
            enabled: root.text.length > 0
            onClicked: {
                textInput.forceActiveFocus()
                textInput.selectAll()
            }
        }
    }

    Column {
        anchors.fill: parent
        spacing: 4

        // ═══════════════════════════════════════════════════════════════
        // MAIN CONTAINER
        // ═══════════════════════════════════════════════════════════════
        Rectangle {
            id: container
            width: parent.width
            height: currentSize.height
            radius: containerRadius

            color: {
                if (variant === "outlined") return "transparent"
                if (!enabled) return Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.04)
                if (error) return Qt.rgba(colors.errorContainer.r, colors.errorContainer.g, colors.errorContainer.b, 0.15)
                return colors.surfaceContainerHighest
            }

            Behavior on color {
                ColorAnimation { duration: 150 }
            }

            Behavior on radius {
                NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
            }

            // Bottom border for filled variant (not shown when rounded)
            Rectangle {
                visible: variant === "filled" && !isRounded
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

            // Outline border (for outlined variant OR rounded filled)
            Rectangle {
                visible: variant === "outlined" || isRounded
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

            // Hover state layer
            Rectangle {
                id: hoverLayer
                anchors.fill: parent
                radius: parent.radius
                color: colors.onSurface
                opacity: 0
                z: 0

                Behavior on opacity {
                    NumberAnimation { duration: 150 }
                }
            }

            // ═══════════════════════════════════════════════════════════
            // FLOATING LABEL (hidden when rounded)
            // ═══════════════════════════════════════════════════════════
            Text {
                id: floatingLabel
                visible: hasLabel && !isRounded
                text: label
                z: 3

                font.family: "Roboto"
                font.pixelSize: labelFloated ? currentSize.labelFontSize : currentSize.fontSize
                font.weight: Font.Normal

                color: {
                    if (!enabled) return colors.onSurface
                    if (error) return colors.error
                    if (isFocused) return colors.primary
                    return colors.onSurfaceVariant
                }

                x: {
                    var base = effectivePadding
                    if (hasLeadingIcon) base += currentSize.iconSize + currentSize.iconPadding
                    return base
                }

                y: {
                    if (labelFloated) {
                        return variant === "filled" ? currentSize.labelTopPadding : -height / 2
                    }
                    return (container.height - height) / 2
                }

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
                    visible: variant === "outlined" && labelFloated && !isRounded
                    anchors.fill: parent
                    anchors.leftMargin: -4
                    anchors.rightMargin: -4
                    color: colors.surface
                    z: -1

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }
            }

            // ═══════════════════════════════════════════════════════════
            // LEADING ICON
            // ═══════════════════════════════════════════════════════════
            Item {
                id: leadingIconContainer
                visible: hasLeadingIcon
                width: currentSize.iconSize
                height: currentSize.iconSize
                x: effectivePadding
                anchors.verticalCenter: parent.verticalCenter
                z: 2

                Common.Icon {
                    anchors.centerIn: parent
                    source: leadingIcon
                    size: currentSize.iconSize
                    color: error ? colors.error : colors.onSurfaceVariant

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -8
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.leadingIconClicked()
                }
            }

            // ═══════════════════════════════════════════════════════════
            // TEXT INPUT AREA
            // ═══════════════════════════════════════════════════════════
            Item {
                id: inputContainer
                z: 1

                anchors {
                    left: hasLeadingIcon ? leadingIconContainer.right : parent.left
                    right: hasTrailingIcon ? trailingIconContainer.left : parent.right
                    top: parent.top
                    bottom: parent.bottom
                    leftMargin: hasLeadingIcon ? currentSize.iconPadding : effectivePadding
                    rightMargin: hasTrailingIcon ? currentSize.iconPadding : effectivePadding
                    topMargin: hasLabel && variant === "filled" && !isRounded ? currentSize.inputTopPadding : 0
                }

                // Background hover detector
                MouseArea {
                    id: hoverArea
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.NoButton
                    propagateComposedEvents: true
                    z: -1

                    onContainsMouseChanged: {
                        if (enabled && !isFocused) {
                            hoverLayer.opacity = containsMouse ? 0.08 : 0
                        }
                    }
                }

                TextInput {
                    id: textInput
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter

                    text: root.text
                    font.family: "Roboto"
                    font.pixelSize: currentSize.fontSize
                    color: enabled ? colors.onSurface : colors.onSurface
                    selectionColor: colors.primaryContainer
                    selectedTextColor: colors.onPrimaryContainer

                    enabled: root.enabled && !root.readOnly
                    readOnly: root.readOnly
                    echoMode: {
                        if (!password) return TextInput.Normal
                        return _passwordVisible ? TextInput.Normal : TextInput.Password
                    }
                    maximumLength: maxLength > 0 ? maxLength : 32767
                    inputMethodHints: root.inputMethodHints
                    selectByMouse: true
                    persistentSelection: true
                    clip: true
                    cursorVisible: activeFocus

                    onTextChanged: root.text = text
                    onAccepted: root.accepted()
                    onEditingFinished: root.editingFinished()

                    onActiveFocusChanged: {
                        if (activeFocus) {
                            hoverLayer.opacity = 0
                        }
                    }

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }

                    // Placeholder (always shown when rounded OR when no label)
                    Text {
                        visible: (!hasLabel || isRounded) && !textInput.text
                        anchors.fill: parent
                        text: isRounded && hasLabel ? label : placeholderText
                        font: textInput.font
                        color: colors.onSurfaceVariant
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                    }
                }

                // Right-click context menu
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    cursorShape: Qt.IBeamCursor

                    onClicked: function(mouse) {
                        if (mouse.button === Qt.RightButton && root.enableContextMenu) {
                            root._storeSelection()
                            contextMenu.popup(mouse.x, mouse.y)
                        }
                    }
                }
            }

            // ═══════════════════════════════════════════════════════════
            // TRAILING ICON
            // ═══════════════════════════════════════════════════════════
            Item {
                id: trailingIconContainer
                visible: hasTrailingIcon
                width: currentSize.iconSize
                height: currentSize.iconSize
                anchors.right: parent.right
                anchors.rightMargin: effectivePadding
                anchors.verticalCenter: parent.verticalCenter
                z: 2

                Rectangle {
                    id: trailingHover
                    anchors.centerIn: parent
                    width: parent.width + 8
                    height: parent.height + 8
                    radius: width / 2
                    color: colors.onSurface
                    opacity: 0
                    z: -1

                    Behavior on opacity {
                        NumberAnimation { duration: 100 }
                    }
                }

                Common.Icon {
                    anchors.centerIn: parent
                    source: {
                        if (showPasswordToggle && password) {
                            return _passwordVisible ? "visibility_off" : "visibility"
                        }
                        return trailingIcon
                    }
                    size: currentSize.iconSize
                    color: error ? colors.error : colors.onSurfaceVariant

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -8
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onContainsMouseChanged: trailingHover.opacity = containsMouse ? 0.08 : 0
                    onPressed: trailingHover.opacity = 0.12
                    onReleased: trailingHover.opacity = containsMouse ? 0.08 : 0

                    onClicked: {
                        if (showPasswordToggle && password) {
                            _passwordVisible = !_passwordVisible
                        } else {
                            root.trailingIconClicked()
                        }
                    }
                }
            }

            // Click area for focusing
            MouseArea {
                anchors.fill: parent
                z: 0
                propagateComposedEvents: true
                hoverEnabled: true

                onContainsMouseChanged: {
                    if (enabled && !isFocused) {
                        hoverLayer.opacity = containsMouse ? 0.08 : 0
                    }
                }

                onClicked: function(mouse) {
                    textInput.forceActiveFocus()
                    var pos = textInput.mapFromItem(this, mouse.x, mouse.y)
                    textInput.cursorPosition = textInput.positionAt(pos.x, pos.y)
                    mouse.accepted = false
                }

                onPressed: function(mouse) { mouse.accepted = false }
                onReleased: function(mouse) { mouse.accepted = false }
            }
        }

        // ═══════════════════════════════════════════════════════════════
        // SUPPORTING/ERROR TEXT ROW
        // ═══════════════════════════════════════════════════════════════
        RowLayout {
            visible: hasSupportingText || showCharacterCount
            width: parent.width
            spacing: 8

            Text {
                visible: hasSupportingText
                Layout.fillWidth: true
                Layout.leftMargin: effectivePadding
                text: error && errorText !== "" ? errorText : supportingText
                font.family: "Roboto"
                font.pixelSize: 12
                color: error ? colors.error : colors.onSurfaceVariant
                wrapMode: Text.WordWrap

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            Item {
                Layout.fillWidth: true
                visible: !hasSupportingText && showCharacterCount
            }

            Text {
                id: charCount
                visible: showCharacterCount && maxLength > 0
                Layout.rightMargin: effectivePadding
                text: textInput.text.length + "/" + maxLength
                font.family: "Roboto"
                font.pixelSize: 12
                color: {
                    if (error) return colors.error
                    if (maxLength > 0 && textInput.text.length >= maxLength) return colors.error
                    return colors.onSurfaceVariant
                }
                horizontalAlignment: Text.AlignRight

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════════
    // KEYBOARD SHORTCUTS
    // ═══════════════════════════════════════════════════════════════════
    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_A && (event.modifiers & Qt.ControlModifier)) {
            textInput.selectAll()
            event.accepted = true
        } else if (event.key === Qt.Key_C && (event.modifiers & Qt.ControlModifier)) {
            if (textInput.selectedText.length > 0) {
                _storedSelectedText = textInput.selectedText
                _storedSelectionStart = textInput.selectionStart
                _storedSelectionEnd = textInput.selectionEnd
                _performCopy()
                event.accepted = true
            }
        } else if (event.key === Qt.Key_X && (event.modifiers & Qt.ControlModifier)) {
            if (textInput.selectedText.length > 0 && !readOnly) {
                _storedSelectedText = textInput.selectedText
                _storedSelectionStart = textInput.selectionStart
                _storedSelectionEnd = textInput.selectionEnd
                _performCut()
                event.accepted = true
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════════
    // PUBLIC FUNCTIONS
    // ═══════════════════════════════════════════════════════════════════
    function clear() {
        textInput.clear()
        root.text = ""
    }

    function selectAll() {
        textInput.selectAll()
    }

    function forceActiveFocus() {
        textInput.forceActiveFocus()
    }

    function deselect() {
        textInput.deselect()
    }

    function select(start, end) {
        textInput.select(start, end)
    }

    function positionAt(x, y) {
        return textInput.positionAt(x, y)
    }

    // ═══════════════════════════════════════════════════════════════════
    // ACCESSIBILITY
    // ═══════════════════════════════════════════════════════════════════
    Accessible.role: Accessible.EditableText
    Accessible.name: label || placeholderText
    Accessible.description: supportingText
    Accessible.focusable: true
}
