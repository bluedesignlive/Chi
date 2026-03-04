// qml/smartui/ui/search/SearchBar.qml
// M3 search bar — full-featured with suggestions dropdown
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
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
    readonly property bool showSuggestions: root.expanded && hasSuggestions
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
        if (_storedSelectionStart !== _storedSelectionEnd)
            searchInput.select(_storedSelectionStart, _storedSelectionEnd)
    }

    // ═══════════════════════════════════════════════════════════════════
    // SIZE-BASED DIMENSIONS (Material 3 Specs)
    // Single lookup replaces repeated switch statements.
    // Typography references the M3 scale from ChiTheme directly.
    // ═══════════════════════════════════════════════════════════════════

    readonly property var _sizeSpecs: ({
        "0": { ch: 36, hp: 10, is: 16, as: 22, isp: 10, sih: 36, typo: "bodySmall",  subTypo: "labelSmall"  },
        "1": { ch: 44, hp: 12, is: 20, as: 26, isp: 12, sih: 40, typo: "bodyMedium", subTypo: "bodySmall"  },
        "2": { ch: 56, hp: 16, is: 24, as: 30, isp: 16, sih: 48, typo: "bodyLarge",  subTypo: "bodyMedium" }
    })
    readonly property var _ss: _sizeSpecs[String(size)] || _sizeSpecs["1"]

    // Resolved typography from the M3 scale
    readonly property var _typo: Theme.ChiTheme.typography[_ss.typo]
    readonly property var _subTypo: Theme.ChiTheme.typography[_ss.subTypo]

    readonly property real containerHeight: _ss.ch
    readonly property real headerHeight: docked ? containerHeight : 72
    readonly property real horizontalPadding: _ss.hp
    readonly property real iconSize: _ss.is
    readonly property real avatarSize: _ss.as
    readonly property real iconSpacing: _ss.isp
    readonly property real cornerRadius: containerHeight / 2
    readonly property real suggestionItemHeight: _ss.sih
    readonly property real minWidth: 360
    readonly property real maxWidth: 720

    readonly property real suggestionsHeight: hasSuggestions
        ? Math.min(suggestions.length * suggestionItemHeight + 8, maxSuggestionHeight) : 0

    readonly property real maxSuggestionHeight: {
        if (!docked && root.parent)
            return root.parent.height - headerHeight
        return root.parent ? Math.min(root.parent.height * 0.66, 400) : 400
    }

    // Single height driver — container Behavior animates this
    readonly property real targetHeight: containerHeight
        + (showSuggestions ? suggestionsHeight : 0)

    implicitWidth: Math.max(minWidth, Math.min(parent ? parent.width : 360, maxWidth))
    implicitHeight: containerHeight

    // Raise above siblings when expanded so dropdown is never occluded
    z: root.expanded ? 1000 : 0

    // ═══════════════════════════════════════════════════════════════════
    // THEME
    // ═══════════════════════════════════════════════════════════════════

    property var colors: Theme.ChiTheme.colors
    property var motion: Theme.ChiTheme.motion

    // ═══════════════════════════════════════════════════════════════════
    // ANIMATION STATE
    // Tracks whether the container height is mid-transition so
    // radius and divider hold their expanded look until it finishes
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
            onClicked: root._performCut()
        }

        Menus.MenuItem {
            visible: root.showCopy
            text: "Copy"
            leadingIcon: "content_copy"
            enabled: root._storedSelectedText.length > 0
            onClicked: root._performCopy()
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
        width: 0; height: 0
    }

    // ═══════════════════════════════════════════════════════════════════
    // AVATAR MASK (shared, rendered once, invisible)
    // Used by MultiEffect to clip avatar image to a circle.
    // ═══════════════════════════════════════════════════════════════════

    Item {
        id: _avatarMaskSource
        visible: false
        layer.enabled: true
        width: root.avatarSize; height: root.avatarSize
        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: "white"
        }
    }

    // ═══════════════════════════════════════════════════════════════════
    // MAIN CONTAINER
    // Only ONE height Behavior — no competing animations.
    // Container clips, so suggestions are revealed/hidden
    // purely by the container growing/shrinking.
    // ═══════════════════════════════════════════════════════════════════

    Rectangle {
        id: container
        width: parent.width
        height: targetHeight
        radius: (showSuggestions || _animating) ? Math.min(22, cornerRadius) : cornerRadius
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
                duration: motion.durationMedium
                easing.type: Easing.OutCubic
                onRunningChanged: root._animating = running
            }
        }

        // Shadow via MultiEffect — single optimised shader pass,
        // replaces deprecated Qt5Compat DropShadow.
        // Properties snap on expand/collapse; the container already
        // re-renders every frame during height animation.
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, root.expanded ? 0.18 : 0.08)
            shadowVerticalOffset: root.expanded ? 6 : 2
            shadowBlur: root.expanded ? 0.45 : 0.15
        }

        Column {
            id: mainColumn
            width: parent.width

            // ═══════════════════════════════════════════════════════
            // SEARCH INPUT ROW
            // ═══════════════════════════════════════════════════════

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
                        Layout.preferredWidth: root.showAvatar ? root.avatarSize : root.iconSize
                        Layout.preferredHeight: root.showAvatar ? root.avatarSize : root.iconSize
                        Layout.alignment: Qt.AlignVCenter

                        // Avatar container
                        Rectangle {
                            id: avatarContainer
                            visible: root.showAvatar
                            anchors.fill: parent
                            radius: width / 2
                            color: colors.primaryContainer

                            // Initials fallback
                            Text {
                                visible: root.avatarSource === "" && root.avatarFallback !== ""
                                anchors.centerIn: parent
                                text: root.avatarFallback.substring(0, 2).toUpperCase()
                                font.family: Theme.ChiTheme.typography.labelMedium.family
                                font.pixelSize: root.avatarSize * 0.4
                                font.weight: Theme.ChiTheme.typography.labelMedium.weight
                                color: colors.onPrimaryContainer
                            }

                            // Person icon fallback
                            Common.Icon {
                                visible: root.avatarSource === "" && root.avatarFallback === ""
                                anchors.centerIn: parent
                                source: "person"
                                size: root.avatarSize * 0.5
                                color: colors.onPrimaryContainer
                            }

                            // Avatar image — circular mask via MultiEffect
                            Image {
                                id: _avatarImage
                                visible: root.avatarSource !== ""
                                anchors.fill: parent
                                source: root.avatarSource
                                fillMode: Image.PreserveAspectCrop
                                layer.enabled: visible
                                layer.effect: MultiEffect {
                                    maskEnabled: true
                                    maskSource: _avatarMaskSource
                                    maskThresholdMin: 0.5
                                    maskSpreadAtMin: 1.0
                                }
                            }
                        }

                        // Search / back icon
                        Common.Icon {
                            id: leadingIconItem
                            visible: !root.showAvatar
                            anchors.centerIn: parent
                            source: root.expanded ? "arrow_back" : root.leadingIcon
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

                        // Hover ring
                        Rectangle {
                            id: leadingHover
                            anchors.centerIn: parent
                            width: parent.width + 8; height: parent.height + 8
                            radius: width / 2
                            color: colors.onSurface
                            opacity: 0; z: -1

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
                                if (root.expanded) root.collapse()
                                else root.leadingIconClicked()
                            }
                        }
                    }

                    // Input field
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: root.containerHeight

                        TextInput {
                            id: searchInput
                            anchors.fill: parent
                            verticalAlignment: TextInput.AlignVCenter

                            text: root.text
                            font.family: root._typo.family
                            font.pixelSize: root._typo.size
                            font.weight: root._typo.weight
                            font.letterSpacing: root._typo.spacing || 0
                            color: colors.onSurface
                            selectionColor: colors.primaryContainer
                            selectedTextColor: colors.onPrimaryContainer
                            clip: true
                            selectByMouse: true
                            enabled: root.enabled
                            persistentSelection: true

                            onTextChanged: root.text = text
                            onAccepted: {
                                if (text.trim().length > 0)
                                    root.search(text)
                            }
                            onActiveFocusChanged: {
                                if (activeFocus) root.expanded = true
                                root.inputFocusChanged(activeFocus)
                            }

                            Behavior on color {
                                ColorAnimation { duration: motion.durationMedium }
                            }

                            // Placeholder
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
                        visible: root.showClearButton && root.hasText
                        Layout.preferredWidth: root.iconSize
                        Layout.preferredHeight: root.iconSize
                        Layout.alignment: Qt.AlignVCenter

                        Rectangle {
                            id: clearHover
                            anchors.centerIn: parent
                            width: parent.width + 12; height: parent.height + 12
                            radius: width / 2
                            color: colors.onSurface
                            opacity: 0; z: -1

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
                        visible: root.showTrailingIcon && !root.hasText
                        Layout.preferredWidth: root.iconSize
                        Layout.preferredHeight: root.iconSize
                        Layout.alignment: Qt.AlignVCenter

                        Rectangle {
                            id: trailingHover
                            anchors.centerIn: parent
                            width: parent.width + 12; height: parent.height + 12
                            radius: width / 2
                            color: colors.onSurface
                            opacity: 0; z: -1

                            Behavior on opacity {
                                NumberAnimation { duration: motion.durationFast }
                            }
                        }

                        Common.Icon {
                            anchors.centerIn: parent
                            source: root.trailingIcon
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

            // ═══════════════════════════════════════════════════════
            // DIVIDER
            // Always height 1. Visibility driven by state,
            // no competing height Behavior.
            // ═══════════════════════════════════════════════════════

            Rectangle {
                id: divider
                width: parent.width - (root.horizontalPadding * 2)
                height: 1
                visible: root.showDivider && (showSuggestions || _animating)
                anchors.horizontalCenter: parent.horizontalCenter
                color: colors.outlineVariant
                opacity: showSuggestions ? 1 : 0

                Behavior on opacity {
                    NumberAnimation { duration: motion.durationMedium; easing.type: Easing.OutCubic }
                }
            }

            // ═══════════════════════════════════════════════════════
            // SUGGESTIONS
            // Always rendered at full height when data exists.
            // Reveal/hide handled entirely by container clip +
            // height animation — no own height Behavior.
            // ═══════════════════════════════════════════════════════

            Item {
                id: suggestionsContainer
                width: parent.width
                height: root.suggestionsHeight
                visible: root.hasSuggestions
                opacity: showSuggestions ? 1 : 0

                Behavior on opacity {
                    NumberAnimation { duration: motion.durationMedium; easing.type: Easing.OutCubic }
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
                                iconSpacing: root.iconSpacing
                                colors: root.colors
                                motion: root.motion
                                _titleTypo: root._typo
                                _subtitleTypo: root._subTypo

                                suggestionData: modelData
                                suggestionIndex: index

                                onClicked: {
                                    var t = modelData.text !== undefined ? modelData.text : modelData
                                    root.text = t
                                    searchInput.text = t
                                    root.suggestionClicked(index, modelData)
                                    if (modelData.autoSearch !== false)
                                        root.search(root.text)
                                }

                                onInsertClicked: {
                                    var t = modelData.text !== undefined ? modelData.text : modelData
                                    root.text = t
                                    searchInput.text = t
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
    // Child of root — extends to cover parent's area via coordinate
    // mapping. Never reparented, so no Layout management warnings.
    // ═══════════════════════════════════════════════════════════════════

    MouseArea {
        id: dismissArea
        visible: root.expanded
        z: -1
        x: root.parent ? -root.x : 0
        y: root.parent ? -root.y : 0
        width: root.parent ? root.parent.width : 0
        height: root.parent ? root.parent.height : 0
        onClicked: root.collapse()
    }

    // ═══════════════════════════════════════════════════════════════════
    // KEYBOARD SHORTCUTS
    // ═══════════════════════════════════════════════════════════════════

    Keys.onEscapePressed: {
        if (root.expanded) collapse()
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

    function focusInput() { searchInput.forceActiveFocus() }
    function clear()      { searchInput.clear(); root.text = ""; cleared() }
    function selectAll()  { searchInput.selectAll() }

    function collapse() {
        root.expanded = false
        searchInput.focus = false
    }

    function expand() {
        root.expanded = true
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
    Accessible.description: hasText
        ? "Search field containing: " + text
        : "Empty search field. " + placeholderText
    Accessible.focusable: true
}
