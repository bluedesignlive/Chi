// qml/smartui/ui/search/SearchBar.qml
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme
import "../menus" as Menus
import "../common" as Common

Item {
    id: root

    // ═══════════════════════════════════════════════════════════════════
    // SIZE VARIANTS (Material 3 compliant)
    // ═══════════════════════════════════════════════════════════════════
    enum Size {
        Small,
        Medium,
        Large
    }

    property int size: SearchBar.Size.Medium

    // ═══════════════════════════════════════════════════════════════════
    // CORE PROPERTIES
    // ═══════════════════════════════════════════════════════════════════
    property string text: ""
    property string placeholderText: "Search"
    property string leadingIcon: "search"
    property string trailingIcon: "mic"
    property bool showAvatar: false
    property string avatarSource: ""
    property string avatarFallback: ""
    property bool expanded: false
    property bool enabled: true
    property bool showClearButton: true
    property bool showTrailingIcon: true
    property bool showDivider: true
    property bool docked: true
    property bool persistentClear: false

    // Context menu options
    property bool enableContextMenu: true
    property bool showCut: true
    property bool showCopy: true
    property bool showPaste: true
    property bool showSelectAll: true

    property var suggestions: []
    property alias inputField: searchInput

    // ═══════════════════════════════════════════════════════════════════
    // SIGNALS
    // ═══════════════════════════════════════════════════════════════════
    signal search(string query)
    signal cleared()
    signal suggestionClicked(int index, var item)
    signal trailingIconClicked()
    signal leadingIconClicked()
    signal inputFocusChanged(bool hasFocus)
    signal cutRequested()
    signal copyRequested()
    signal pasteRequested()
    signal selectAllRequested()

    // ═══════════════════════════════════════════════════════════════════
    // READONLY PROPERTIES
    // ═══════════════════════════════════════════════════════════════════
    readonly property bool hasText: text.length > 0
    readonly property bool hasSuggestions: suggestions && suggestions.length > 0
    readonly property bool showSuggestions: expanded && hasSuggestions
    readonly property bool hasSelection: searchInput.selectedText.length > 0
    readonly property bool hasFocus: searchInput.activeFocus

    // ═══════════════════════════════════════════════════════════════════
    // STORED SELECTION (for clipboard operations)
    // ═══════════════════════════════════════════════════════════════════
    property string _storedSelectedText: ""
    property int _storedSelectionStart: 0
    property int _storedSelectionEnd: 0

    function _storeSelection() {
        _storedSelectedText = searchInput.selectedText
        _storedSelectionStart = searchInput.selectionStart
        _storedSelectionEnd = searchInput.selectionEnd
    }

    function _restoreSelection() {
        if (_storedSelectionStart !== _storedSelectionEnd) {
            searchInput.select(_storedSelectionStart, _storedSelectionEnd)
        }
    }

    // ═══════════════════════════════════════════════════════════════════
    // SIZE-BASED DIMENSIONS (Material 3 Specs)
    // ═══════════════════════════════════════════════════════════════════
    readonly property real containerHeight: {
        switch (size) {
            case SearchBar.Size.Small: return 40
            case SearchBar.Size.Large: return 64
            default: return 56
        }
    }

    readonly property real headerHeight: docked ? 56 : 72

    readonly property real horizontalPadding: {
        switch (size) {
            case SearchBar.Size.Small: return 12
            case SearchBar.Size.Large: return 20
            default: return 16
        }
    }

    readonly property real iconSize: {
        switch (size) {
            case SearchBar.Size.Small: return 18
            case SearchBar.Size.Large: return 28
            default: return 24
        }
    }

    readonly property real avatarSize: {
        switch (size) {
            case SearchBar.Size.Small: return 24
            case SearchBar.Size.Large: return 36
            default: return 30
        }
    }

    readonly property real fontSize: {
        switch (size) {
            case SearchBar.Size.Small: return 14
            case SearchBar.Size.Large: return 18
            default: return 16
        }
    }

    readonly property real iconSpacing: {
        switch (size) {
            case SearchBar.Size.Small: return 12
            case SearchBar.Size.Large: return 20
            default: return 16
        }
    }

    readonly property real cornerRadius: containerHeight / 2

    readonly property real suggestionItemHeight: {
        switch (size) {
            case SearchBar.Size.Small: return 40
            case SearchBar.Size.Large: return 56
            default: return 48
        }
    }

    readonly property real minWidth: 360
    readonly property real maxWidth: 720

    readonly property real suggestionsHeight: hasSuggestions ? Math.min(suggestions.length * suggestionItemHeight + 8, maxSuggestionHeight) : 0

    readonly property real maxSuggestionHeight: {
        if (!docked && root.parent) {
            return root.parent.height - headerHeight
        }
        return root.parent ? Math.min(root.parent.height * 0.66, 400) : 400
    }

    readonly property real targetHeight: containerHeight + (showSuggestions ? suggestionsHeight : 0)

    implicitWidth: Math.max(minWidth, Math.min(parent ? parent.width : 360, maxWidth))
    implicitHeight: containerHeight

    // ═══════════════════════════════════════════════════════════════════
    // THEME
    // ═══════════════════════════════════════════════════════════════════
    property var colors: Theme.ChiTheme.colors
    property var motion: Theme.ChiTheme.motion

    // ═══════════════════════════════════════════════════════════════════
    // ANIMATION STATE
    // ═══════════════════════════════════════════════════════════════════
    property bool _animating: false

    // ═══════════════════════════════════════════════════════════════════
    // CONTEXT MENU
    // ═══════════════════════════════════════════════════════════════════
    Menus.ContextMenu {
        id: contextMenu

        onOpenChanged: {
            if (!open && _storedSelectionStart !== _storedSelectionEnd) {
                Qt.callLater(function() {
                    searchInput.forceActiveFocus()
                    root._restoreSelection()
                })
            }
        }

        Menus.MenuItem {
            visible: root.showCut
            text: "Cut"
            leadingIcon: "content_cut"
            enabled: root._storedSelectedText.length > 0 && root.enabled
            onClicked: {
                root._performCut()
            }
        }

        Menus.MenuItem {
            visible: root.showCopy
            text: "Copy"
            leadingIcon: "content_copy"
            enabled: root._storedSelectedText.length > 0
            onClicked: {
                root._performCopy()
            }
        }

        Menus.MenuItem {
            visible: root.showPaste
            text: "Paste"
            leadingIcon: "content_paste"
            enabled: searchInput.canPaste && root.enabled
            onClicked: {
                searchInput.forceActiveFocus()
                root._restoreSelection()
                searchInput.paste()
                root.pasteRequested()
            }
        }

        Menus.MenuDivider {
            visible: (root.showCut || root.showCopy || root.showPaste) && root.showSelectAll
        }

        Menus.MenuItem {
            visible: root.showSelectAll
            text: "Select All"
            leadingIcon: "select_all"
            enabled: root.text.length > 0
            trailingText: "Ctrl+A"
            onClicked: {
                searchInput.forceActiveFocus()
                searchInput.selectAll()
                root.selectAllRequested()
            }
        }

        Menus.MenuItem {
            text: "Clear"
            leadingIcon: "clear"
            enabled: root.hasText && root.enabled
            onClicked: root.clear()
        }
    }

    // ═══════════════════════════════════════════════════════════════════
    // CLIPBOARD FUNCTIONS
    // ═══════════════════════════════════════════════════════════════════
    function _performCut() {
        if (_storedSelectedText.length > 0) {
            _clipboardHelper.text = _storedSelectedText
            _clipboardHelper.selectAll()
            _clipboardHelper.cut()

            var before = root.text.substring(0, _storedSelectionStart)
            var after = root.text.substring(_storedSelectionEnd)
            root.text = before + after
            searchInput.text = root.text

            searchInput.forceActiveFocus()
            searchInput.cursorPosition = _storedSelectionStart

            root.cutRequested()
        }
    }

    function _performCopy() {
        if (_storedSelectedText.length > 0) {
            _clipboardHelper.text = _storedSelectedText
            _clipboardHelper.selectAll()
            _clipboardHelper.copy()

            searchInput.forceActiveFocus()
            root._restoreSelection()

            root.copyRequested()
        }
    }

    // Hidden TextInput for clipboard operations
    TextInput {
        id: _clipboardHelper
        visible: false
        width: 0
        height: 0
    }

    // ═══════════════════════════════════════════════════════════════════
    // MAIN CONTAINER
    // ═══════════════════════════════════════════════════════════════════
    Rectangle {
        id: container
        width: parent.width
        height: targetHeight
        radius: showSuggestions || _animating ? 28 : cornerRadius
        color: colors.surfaceContainer
        clip: true

        Behavior on color {
            ColorAnimation { duration: motion.durationMedium; easing.type: Easing.OutCubic }
        }

        Behavior on radius {
            NumberAnimation { duration: motion.durationMedium; easing.type: Easing.OutCubic }
        }

        Behavior on height {
            NumberAnimation {
                id: heightAnimation
                duration: motion.durationMedium
                easing.type: Easing.OutCubic

                onRunningChanged: {
                    if (running) {
                        root._animating = true
                    } else {
                        root._animating = false
                    }
                }
            }
        }

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: expanded ? 6 : 2
            radius: expanded ? 16 : 6
            samples: 25
            color: Qt.rgba(0, 0, 0, expanded ? 0.18 : 0.08)

            Behavior on verticalOffset {
                NumberAnimation { duration: motion.durationMedium; easing.type: Easing.OutCubic }
            }
            Behavior on radius {
                NumberAnimation { duration: motion.durationMedium; easing.type: Easing.OutCubic }
            }
            Behavior on color {
                ColorAnimation { duration: motion.durationMedium }
            }
        }

        Column {
            id: mainColumn
            width: parent.width

            // ═══════════════════════════════════════════════════════════
            // SEARCH INPUT ROW
            // ═══════════════════════════════════════════════════════════
            Item {
                id: searchRow
                width: parent.width
                height: root.containerHeight

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: root.horizontalPadding
                    anchors.rightMargin: root.horizontalPadding
                    spacing: root.iconSpacing

                    // Leading icon or avatar
                    Item {
                        id: leadingItem
                        Layout.preferredWidth: showAvatar ? root.avatarSize : root.iconSize
                        Layout.preferredHeight: showAvatar ? root.avatarSize : root.iconSize
                        Layout.alignment: Qt.AlignVCenter

                        // Avatar container
                        Rectangle {
                            id: avatarContainer
                            visible: showAvatar
                            anchors.fill: parent
                            radius: width / 2
                            color: colors.primaryContainer

                            Text {
                                visible: avatarSource === "" && avatarFallback !== ""
                                anchors.centerIn: parent
                                text: avatarFallback.substring(0, 2).toUpperCase()
                                font.pixelSize: root.avatarSize * 0.4
                                font.weight: Font.Medium
                                color: colors.onPrimaryContainer
                            }

                            Common.Icon {
                                visible: avatarSource === "" && avatarFallback === ""
                                anchors.centerIn: parent
                                source: "person"
                                size: root.avatarSize * 0.5
                                color: colors.onPrimaryContainer
                            }

                            Image {
                                visible: avatarSource !== ""
                                anchors.fill: parent
                                source: avatarSource
                                fillMode: Image.PreserveAspectCrop
                                layer.enabled: true
                                layer.effect: OpacityMask {
                                    maskSource: Rectangle {
                                        width: root.avatarSize
                                        height: root.avatarSize
                                        radius: root.avatarSize / 2
                                    }
                                }
                            }
                        }

                        // Search/Back icon
                        Common.Icon {
                            id: leadingIconItem
                            visible: !showAvatar
                            anchors.centerIn: parent
                            source: expanded ? "arrow_back" : leadingIcon
                            size: root.iconSize
                            color: colors.onSurfaceVariant

                            Behavior on source {
                                SequentialAnimation {
                                    NumberAnimation { target: leadingIconItem; property: "opacity"; to: 0; duration: 100 }
                                    PropertyAction { target: leadingIconItem; property: "source" }
                                    NumberAnimation { target: leadingIconItem; property: "opacity"; to: 1; duration: 100 }
                                }
                            }
                        }

                        // Hover effect
                        Rectangle {
                            id: leadingHover
                            anchors.centerIn: parent
                            width: parent.width + 8
                            height: parent.height + 8
                            radius: width / 2
                            color: colors.onSurface
                            opacity: 0
                            z: -1

                            Behavior on opacity {
                                NumberAnimation { duration: motion.durationFast }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: -4
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true

                            onContainsMouseChanged: leadingHover.opacity = containsMouse ? 0.08 : 0
                            onPressed: leadingHover.opacity = 0.12
                            onReleased: leadingHover.opacity = containsMouse ? 0.08 : 0

                            onClicked: {
                                if (expanded) {
                                    root.collapse()
                                } else {
                                    root.leadingIconClicked()
                                }
                            }
                        }
                    }

                    // Input field container
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: root.containerHeight

                        TextInput {
                            id: searchInput
                            anchors.fill: parent
                            verticalAlignment: TextInput.AlignVCenter

                            text: root.text
                            font.family: "Roboto"
                            font.pixelSize: root.fontSize
                            font.weight: Font.Normal
                            color: colors.onSurface
                            selectionColor: colors.primaryContainer
                            selectedTextColor: colors.onPrimaryContainer
                            clip: true
                            selectByMouse: true
                            enabled: root.enabled
                            persistentSelection: true

                            onTextChanged: root.text = text
                            onAccepted: {
                                if (text.trim().length > 0) {
                                    root.search(text)
                                }
                            }
                            onActiveFocusChanged: {
                                if (activeFocus) {
                                    expanded = true
                                }
                                root.inputFocusChanged(activeFocus)
                            }

                            Behavior on color {
                                ColorAnimation { duration: motion.durationMedium }
                            }

                            // Placeholder text
                            Text {
                                visible: !searchInput.text && !searchInput.preeditText
                                anchors.fill: parent
                                verticalAlignment: Text.AlignVCenter
                                text: root.placeholderText
                                font: searchInput.font
                                color: colors.onSurfaceVariant
                                elide: Text.ElideRight

                                Behavior on color {
                                    ColorAnimation { duration: motion.durationMedium }
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

                    // Clear button
                    Item {
                        id: clearButton
                        visible: showClearButton && hasText
                        Layout.preferredWidth: root.iconSize
                        Layout.preferredHeight: root.iconSize
                        Layout.alignment: Qt.AlignVCenter

                        Rectangle {
                            id: clearHover
                            anchors.centerIn: parent
                            width: parent.width + 12
                            height: parent.height + 12
                            radius: width / 2
                            color: colors.onSurface
                            opacity: 0
                            z: -1

                            Behavior on opacity {
                                NumberAnimation { duration: motion.durationFast }
                            }
                        }

                        Common.Icon {
                            anchors.centerIn: parent
                            source: "close"
                            size: root.iconSize * 0.8
                            color: colors.onSurfaceVariant
                        }

                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: -6
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onContainsMouseChanged: clearHover.opacity = containsMouse ? 0.08 : 0
                            onPressed: clearHover.opacity = 0.12
                            onReleased: clearHover.opacity = containsMouse ? 0.08 : 0

                            onClicked: {
                                searchInput.clear()
                                root.cleared()
                                searchInput.forceActiveFocus()
                            }
                        }
                    }

                    // Trailing icon
                    Item {
                        id: trailingButton
                        visible: showTrailingIcon && !hasText
                        Layout.preferredWidth: root.iconSize
                        Layout.preferredHeight: root.iconSize
                        Layout.alignment: Qt.AlignVCenter

                        Rectangle {
                            id: trailingHover
                            anchors.centerIn: parent
                            width: parent.width + 12
                            height: parent.height + 12
                            radius: width / 2
                            color: colors.onSurface
                            opacity: 0
                            z: -1

                            Behavior on opacity {
                                NumberAnimation { duration: motion.durationFast }
                            }
                        }

                        Common.Icon {
                            anchors.centerIn: parent
                            source: trailingIcon
                            size: root.iconSize
                            color: colors.onSurfaceVariant
                        }

                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: -6
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onContainsMouseChanged: trailingHover.opacity = containsMouse ? 0.08 : 0
                            onPressed: trailingHover.opacity = 0.12
                            onReleased: trailingHover.opacity = containsMouse ? 0.08 : 0

                            onClicked: root.trailingIconClicked()
                        }
                    }
                }
            }

            // ═══════════════════════════════════════════════════════════
            // DIVIDER
            // ═══════════════════════════════════════════════════════════
            Rectangle {
                id: divider
                width: parent.width - (root.horizontalPadding * 2)
                height: (showSuggestions || _animating) && showDivider ? 1 : 0
                anchors.horizontalCenter: parent.horizontalCenter
                color: colors.outlineVariant
                opacity: showSuggestions ? 1 : 0

                Behavior on opacity {
                    NumberAnimation { duration: motion.durationMedium; easing.type: Easing.OutCubic }
                }

                Behavior on height {
                    NumberAnimation { duration: motion.durationMedium; easing.type: Easing.OutCubic }
                }
            }

            // ═══════════════════════════════════════════════════════════
            // SUGGESTIONS CONTAINER
            // ═══════════════════════════════════════════════════════════
            Item {
                id: suggestionsContainer
                width: parent.width
                height: showSuggestions ? root.suggestionsHeight : 0
                clip: true
                opacity: showSuggestions ? 1 : 0

                Behavior on height {
                    NumberAnimation {
                        duration: motion.durationMedium
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: motion.durationMedium
                        easing.type: Easing.OutCubic
                    }
                }

                Flickable {
                    anchors.fill: parent
                    anchors.topMargin: 4
                    anchors.bottomMargin: 4
                    contentHeight: suggestionsColumn.height
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    interactive: contentHeight > height

                    Column {
                        id: suggestionsColumn
                        width: parent.width
                        spacing: 0

                        Repeater {
                            id: suggestionsRepeater
                            model: root.suggestions

                            delegate: SearchSuggestionItem {
                                width: suggestionsColumn.width
                                height: root.suggestionItemHeight
                                horizontalPadding: root.horizontalPadding
                                iconSize: root.iconSize
                                fontSize: root.fontSize
                                iconSpacing: root.iconSpacing
                                colors: root.colors
                                motion: root.motion

                                suggestionData: modelData
                                suggestionIndex: index

                                onClicked: {
                                    var suggestionText = modelData.text !== undefined ? modelData.text : modelData
                                    root.text = suggestionText
                                    root.suggestionClicked(index, modelData)

                                    if (modelData.autoSearch !== false) {
                                        root.search(root.text)
                                    }
                                }

                                onInsertClicked: {
                                    var suggestionText = modelData.text !== undefined ? modelData.text : modelData
                                    root.text = suggestionText
                                    searchInput.forceActiveFocus()
                                    searchInput.cursorPosition = searchInput.text.length
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════════
    // CLICK OUTSIDE TO COLLAPSE
    // ═══════════════════════════════════════════════════════════════════
    Item {
        id: dismissOverlay
        parent: root.parent
        anchors.fill: parent
        visible: expanded
        z: root.z - 1

        MouseArea {
            anchors.fill: parent
            onClicked: root.collapse()
        }
    }

    // ═══════════════════════════════════════════════════════════════════
    // KEYBOARD SHORTCUTS
    // ═══════════════════════════════════════════════════════════════════
    Keys.onEscapePressed: {
        if (expanded) collapse()
    }

    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_A && (event.modifiers & Qt.ControlModifier)) {
            searchInput.selectAll()
            event.accepted = true
        } else if (event.key === Qt.Key_C && (event.modifiers & Qt.ControlModifier)) {
            if (searchInput.selectedText.length > 0) {
                _storedSelectedText = searchInput.selectedText
                _storedSelectionStart = searchInput.selectionStart
                _storedSelectionEnd = searchInput.selectionEnd
                _performCopy()
                event.accepted = true
            }
        } else if (event.key === Qt.Key_X && (event.modifiers & Qt.ControlModifier)) {
            if (searchInput.selectedText.length > 0) {
                _storedSelectedText = searchInput.selectedText
                _storedSelectionStart = searchInput.selectionStart
                _storedSelectionEnd = searchInput.selectionEnd
                _performCut()
                event.accepted = true
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════════
    // PUBLIC FUNCTIONS
    // ═══════════════════════════════════════════════════════════════════
    function focusInput() {
        searchInput.forceActiveFocus()
    }

    function clear() {
        searchInput.clear()
        root.text = ""
        cleared()
    }

    function selectAll() {
        searchInput.selectAll()
    }

    function collapse() {
        expanded = false
        searchInput.focus = false
    }

    function expand() {
        expanded = true
        searchInput.forceActiveFocus()
    }

    function setText(newText) {
        root.text = newText
        searchInput.text = newText
    }

    function getSelectedText() {
        return searchInput.selectedText
    }

    // ═══════════════════════════════════════════════════════════════════
    // ACCESSIBILITY
    // ═══════════════════════════════════════════════════════════════════
    Accessible.role: Accessible.EditableText
    Accessible.name: placeholderText
    Accessible.description: hasText ? "Search field containing: " + text : "Empty search field. " + placeholderText
    Accessible.focusable: true
}
