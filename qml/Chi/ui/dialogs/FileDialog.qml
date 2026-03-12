import QtQuick
import QtQuick.Window
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Effects
import Qt.labs.folderlistmodel
import QtCore
import "../theme" as Theme
import "../common"
import "../menus" as Menus
import "../Buttons" as Buttons
import "../navigation" as Nav

Window {
    id: root

    // ═══════════════════════════════════════════════════════════════
    // PUBLIC API
    // ═══════════════════════════════════════════════════════════════

    property string mode: "open"
    property string title: mode === "save" ? "Save File" : mode === "folder" ? "Select Folder" : mode === "openMultiple" ? "Select Files" : "Open File"

    property url currentFolder: StandardPaths.writableLocation(StandardPaths.HomeLocation)
    property url selectedFile: ""
    property var selectedFiles: []
    property string fileName: ""
    property var nameFilters: []
    property int currentFilter: 0
    property bool showHidden: false

    property string viewMode: "grid"
    property int gridIconSize: 72
    property bool showThumbnails: true
    property bool sidebarExpanded: false
    property string sortBy: "name"
    property bool sortAscending: true

    signal accepted()
    signal rejected()

    // ═══════════════════════════════════════════════════════════════
    // WINDOW CONFIG
    // ═══════════════════════════════════════════════════════════════

    visible: false
    color: "transparent"
    flags: Qt.Window | Qt.FramelessWindowHint
    width: 1000; height: 650
    minimumWidth: 700; minimumHeight: 450

    // ═══════════════════════════════════════════════════════════════
    // THEME & STATE
    // ═══════════════════════════════════════════════════════════════

    property var colors: Theme.ChiTheme.colors
    readonly property var _t: Theme.ChiTheme.typography

    readonly property bool isMaximized: visibility === Window.Maximized
    readonly property real windowRadius: isMaximized ? 0 : 16

    property var _navigationHistory: []
    property int _historyIndex: -1
    property string _searchQuery: ""

    // ═══════════════════════════════════════════════════════════════
    // QUICK ACCESS LOCATIONS
    // ═══════════════════════════════════════════════════════════════

    readonly property url _homePath: StandardPaths.writableLocation(StandardPaths.HomeLocation)
    readonly property url _documentsPath: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
    readonly property url _downloadsPath: StandardPaths.writableLocation(StandardPaths.DownloadLocation)
    readonly property url _picturesPath: StandardPaths.writableLocation(StandardPaths.PicturesLocation)
    readonly property url _musicPath: StandardPaths.writableLocation(StandardPaths.MusicLocation)
    readonly property url _moviesPath: StandardPaths.writableLocation(StandardPaths.MoviesLocation)
    readonly property url _desktopPath: StandardPaths.writableLocation(StandardPaths.DesktopLocation)

    readonly property var _quickAccess: [
        { name: "Home", icon: "home", path: _homePath },
        { name: "Desktop", icon: "desktop_windows", path: _desktopPath },
        { name: "Documents", icon: "description", path: _documentsPath },
        { name: "Downloads", icon: "download", path: _downloadsPath },
        { name: "Pictures", icon: "image", path: _picturesPath },
        { name: "Music", icon: "music_note", path: _musicPath },
        { name: "Videos", icon: "movie", path: _moviesPath }
    ]

    // ═══════════════════════════════════════════════════════════════
    // LIVE SEARCH
    // ═══════════════════════════════════════════════════════════════

    readonly property var _fileIconMap: ({
        png: "image", jpg: "image", jpeg: "image", gif: "image", bmp: "image", webp: "image", svg: "image",
        pdf: "picture_as_pdf",
        doc: "description", docx: "description", txt: "description", rtf: "description", md: "description",
        xls: "table_chart", xlsx: "table_chart", csv: "table_chart",
        zip: "folder_zip", tar: "folder_zip", gz: "folder_zip", "7z": "folder_zip", rar: "folder_zip",
        mp3: "music_note", wav: "music_note", flac: "music_note", m4a: "music_note", ogg: "music_note",
        mp4: "movie", mkv: "movie", avi: "movie", mov: "movie", webm: "movie",
        js: "code", ts: "code", py: "code", cpp: "code", h: "code", c: "code", java: "code", qml: "code",
        html: "html", css: "css", json: "data_object"
    })

    // Track search text changes for live filtering
    Connections {
        target: pathBar
        function onCurrentTextChanged() {
            if (pathBar.searching) root._searchQuery = pathBar.currentText
        }
    }

    readonly property var _computedFilters: {
        var base = ["*"]
        if (nameFilters.length > 0) {
            var f = nameFilters[currentFilter] || ""
            var m = f.match(/\(([^)]+)\)/)
            if (m) base = m[1].split(" ")
        }
        if (_searchQuery.length > 0) {
            var q = _searchQuery
            return base.map(function(pattern) {
                if (pattern === "*") return "*" + q + "*"
                var dotIdx = pattern.lastIndexOf(".")
                if (dotIdx >= 0) return "*" + q + "*" + pattern.substring(dotIdx)
                return "*" + q + "*"
            })
        }
        return base
    }

    // ═══════════════════════════════════════════════════════════════
    // CORNER MASK
    // ═══════════════════════════════════════════════════════════════

    Rectangle {
        id: cornerMask
        anchors.fill: parent
        radius: windowRadius
        color: "#FFFFFF"
        visible: false
        layer.enabled: windowRadius > 0
    }

    Item {
        id: windowSurface
        anchors.fill: parent

        layer.enabled: windowRadius > 0
        layer.smooth: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: cornerMask
            maskThresholdMin: 0.5
            maskSpreadAtMin: 0.5
        }

        Rectangle { anchors.fill: parent; color: colors.surface }

        // ───────────────────────────────────────────────────────
        // HEADER
        // ───────────────────────────────────────────────────────

        Rectangle {
            id: header
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 52
            color: colors.surfaceContainer

            MouseArea {
                anchors.fill: parent; z: -1
                onPressed: root.startSystemMove()
                onDoubleClicked: root.isMaximized ? root.showNormal() : root.showMaximized()
            }

            // Left section
            Row {
                id: headerLeft
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                Row {
                    spacing: 8; anchors.verticalCenter: parent.verticalCenter
                    Repeater {
                        model: [
                            { c: "#FF5F57", a: function() { root.rejected(); root.close() } },
                            { c: "#FFBD2E", a: function() { root.showMinimized() } },
                            { c: "#28C840", a: function() { root.isMaximized ? root.showNormal() : root.showMaximized() } }
                        ]
                        Rectangle {
                            width: 14; height: 14; radius: 7
                            color: wcM.pressed ? Qt.darker(modelData.c, 1.2) : wcM.containsMouse ? Qt.lighter(modelData.c, 1.1) : modelData.c
                            border.width: 0.5; border.color: Qt.darker(modelData.c, 1.3)
                            MouseArea { id: wcM; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: modelData.a() }
                        }
                    }
                }

                Item { width: 4; height: 1 }

                Row {
                    spacing: 2; anchors.verticalCenter: parent.verticalCenter
                    Repeater {
                        model: [
                            { icon: "chevron_left", enabled: root._historyIndex > 0, action: function() { _goBack() }, tip: "Back" },
                            { icon: "chevron_right", enabled: root._historyIndex < root._navigationHistory.length - 1, action: function() { _goForward() }, tip: "Forward" },
                            { icon: "expand_less", enabled: root.currentFolder.toString() !== "file:///", action: function() { _goUp() }, tip: "Up" }
                        ]
                        Rectangle {
                            width: 36; height: 36; radius: 8
                            opacity: modelData.enabled ? 1.0 : 0.4
                            color: navM.pressed ? Qt.rgba(colors.primary.r, colors.primary.g, colors.primary.b, 0.15) :
                                   navM.containsMouse ? Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.08) : "transparent"
                            Icon { anchors.centerIn: parent; source: modelData.icon; size: 24; color: colors.onSurfaceVariant }
                            MouseArea { id: navM; anchors.fill: parent; hoverEnabled: true; cursorShape: modelData.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor; onClicked: if (modelData.enabled) modelData.action() }
                            ToolTip { visible: navM.containsMouse; text: modelData.tip; delay: 500 }
                        }
                    }
                }
            }

            // Center: PathSearchBar
            Nav.PathSearchBar {
                id: pathBar
                anchors.left: headerLeft.right
                anchors.leftMargin: 12
                anchors.right: headerRight.left
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                height: 36
                path: _getDisplayPath(root.currentFolder)
                onPathAccepted: function(p) { _navigateTo(p.startsWith("file://") ? p : "file://" + p) }
                onSearchToggled: function(active) {
                    pathBar.searching = active
                    if (!active) root._searchQuery = ""
                }
            }

            // Right section
            Row {
                id: headerRight
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Repeater {
                    model: [
                        { icon: "grid_view", checked: root.viewMode === "grid", action: function() { root.viewMode = "grid" } },
                        { icon: "view_list", checked: root.viewMode === "list", action: function() { root.viewMode = "list" } },
                        { icon: "account_tree", checked: root.viewMode === "tree", action: function() { root.viewMode = "tree" } }
                    ]
                    Rectangle {
                        width: 36; height: 36; radius: 8
                        color: modelData.checked ? colors.secondaryContainer :
                               viewM.containsMouse ? Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.08) : "transparent"
                        Icon { anchors.centerIn: parent; source: modelData.icon; size: 22; color: modelData.checked ? colors.onSecondaryContainer : colors.onSurfaceVariant }
                        MouseArea { id: viewM; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: modelData.action() }
                    }
                }

                Item { width: 8; height: 1 }

                Rectangle {
                    width: 36; height: 36; radius: 8
                    color: root.showHidden ? colors.secondaryContainer :
                           hiddenM.containsMouse ? Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.08) : "transparent"
                    Icon { anchors.centerIn: parent; source: root.showHidden ? "visibility" : "visibility_off"; size: 22; color: root.showHidden ? colors.onSecondaryContainer : colors.onSurfaceVariant }
                    MouseArea { id: hiddenM; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.showHidden = !root.showHidden }
                }

                Rectangle {
                    visible: root.mode === "save" || root.mode === "folder"
                    width: 36; height: 36; radius: 8
                    color: nfBtnM.containsMouse ? Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.08) : "transparent"
                    Icon { anchors.centerIn: parent; source: "create_new_folder"; size: 22; color: colors.onSurfaceVariant }
                    MouseArea { id: nfBtnM; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: newFolderPopup.open() }
                }
            }
        }

        // ───────────────────────────────────────────────────────
        // BODY
        // ───────────────────────────────────────────────────────

        Item {
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: footer.top

            Row {
                anchors.fill: parent

                // Navigation Rail
                Rectangle {
                    id: navRail
                    width: root.sidebarExpanded ? 0 : 56
                    height: parent.height; color: colors.surfaceContainer; visible: width > 0

                    Column {
                        anchors.fill: parent; anchors.topMargin: 8; spacing: 4
                        Buttons.IconButton { anchors.horizontalCenter: parent.horizontalCenter; icon: "menu"; size: "xsmall"; variant: "standard"; onClicked: root.sidebarExpanded = true }
                        Item { width: 1; height: 8 }
                        Repeater {
                            model: root._quickAccess
                            Item {
                                width: navRail.width; height: 48
                                Rectangle {
                                    anchors.centerIn: parent; width: 40; height: 40; radius: 12
                                    readonly property bool active: root.currentFolder.toString() === modelData.path.toString()
                                    color: active ? colors.secondaryContainer : railM.containsMouse ? colors.surfaceContainerHighest : "transparent"
                                    Icon { anchors.centerIn: parent; source: modelData.icon; size: 22; color: parent.active ? colors.onSecondaryContainer : colors.onSurfaceVariant }
                                    MouseArea { id: railM; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: _navigateTo(modelData.path) }
                                    ToolTip { visible: railM.containsMouse; text: modelData.name; delay: 500 }
                                }
                            }
                        }
                    }
                }

                // Expanded Sidebar
                Rectangle {
                    id: sidebarPanel
                    width: root.sidebarExpanded ? 200 : 0
                    height: parent.height; color: colors.surfaceContainer; visible: width > 0; clip: true
                    Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

                    Column {
                        anchors.fill: parent; anchors.topMargin: 8; spacing: 4
                        Rectangle {
                            width: parent.width - 16; x: 8; height: 40; radius: 12
                            color: collapseM.containsMouse ? colors.surfaceContainerHighest : "transparent"
                            Row { anchors.left: parent.left; anchors.leftMargin: 14; anchors.verticalCenter: parent.verticalCenter; spacing: 12
                                Icon { source: "menu_open"; size: 22; color: colors.onSurfaceVariant }
                                Text { text: "Collapse"; font.family: _t.bodyMedium.family; font.pixelSize: _t.bodyMedium.size; color: colors.onSurface }
                            }
                            MouseArea { id: collapseM; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.sidebarExpanded = false }
                        }
                        Item { width: 1; height: 8 }
                        Text { text: "PLACES"; font.family: _t.labelSmall.family; font.pixelSize: _t.labelSmall.size; font.weight: Font.Bold; font.letterSpacing: 0.5; color: colors.onSurfaceVariant; leftPadding: 16 }
                        Item { width: 1; height: 4 }
                        Repeater {
                            model: root._quickAccess
                            Rectangle {
                                width: sidebarPanel.width - 16; x: 8; height: 40; radius: 12
                                readonly property bool active: root.currentFolder.toString() === modelData.path.toString()
                                color: active ? colors.secondaryContainer : sideM.containsMouse ? colors.surfaceContainerHighest : "transparent"
                                Row { anchors.left: parent.left; anchors.leftMargin: 14; anchors.verticalCenter: parent.verticalCenter; spacing: 12
                                    Icon { source: modelData.icon; size: 22; color: parent.parent.active ? colors.onSecondaryContainer : colors.onSurfaceVariant }
                                    Text { text: modelData.name; font.family: _t.bodyMedium.family; font.pixelSize: _t.bodyMedium.size; font.weight: parent.parent.active ? Font.Medium : Font.Normal; color: parent.parent.active ? colors.onSecondaryContainer : colors.onSurface }
                                }
                                MouseArea { id: sideM; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: _navigateTo(modelData.path) }
                            }
                        }
                    }
                }

                // Content
                Item {
                    id: contentArea
                    width: parent.width - (root.sidebarExpanded ? sidebarPanel.width : navRail.width)
                    height: parent.height

                    FolderListModel {
                        id: folderModel
                        folder: root.currentFolder
                        showDirs: true
                        showFiles: root.mode !== "folder"
                        showHidden: root.showHidden
                        showDirsFirst: true
                        sortField: root.sortBy === "size" ? FolderListModel.Size : root.sortBy === "date" ? FolderListModel.Time : FolderListModel.Name
                        sortReversed: !root.sortAscending
                        nameFilters: root._computedFilters
                    }

                    Rectangle {
                        id: colHeaders; width: parent.width
                        height: root.viewMode !== "grid" ? 36 : 0
                        color: colors.surfaceContainerLow; visible: height > 0
                        RowLayout {
                            anchors.fill: parent; anchors.leftMargin: root.viewMode === "tree" ? 56 : 16; anchors.rightMargin: 16; spacing: 0
                            HeaderCell { text: "Name"; Layout.fillWidth: true; sortKey: "name" }
                            HeaderCell { text: "Size"; Layout.preferredWidth: 80; sortKey: "size" }
                            HeaderCell { text: "Modified"; Layout.preferredWidth: 140; sortKey: "date" }
                            HeaderCell { text: "Type"; Layout.preferredWidth: 100; sortKey: "type" }
                        }
                    }

                    Loader {
                        id: viewLoader
                        anchors.top: colHeaders.bottom; anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
                        anchors.margins: root.viewMode === "grid" ? 12 : 8
                        sourceComponent: root.viewMode === "grid" ? gridComp : root.viewMode === "list" ? listComp : treeComp
                    }

                    MouseArea {
                        anchors.fill: parent; acceptedButtons: Qt.RightButton; z: -1
                        onClicked: function(mouse) { bgCtxMenu.popup(mouse.x, mouse.y) }
                    }

                    Column {
                        anchors.centerIn: parent; spacing: 12; visible: folderModel.count === 0
                        Icon { source: "folder_off"; size: 64; color: colors.onSurfaceVariant; opacity: 0.5; anchors.horizontalCenter: parent.horizontalCenter }
                        Text { text: _searchQuery.length > 0 ? "No results for \"" + _searchQuery + "\"" : "This folder is empty"; font.family: _t.bodyLarge.family; font.pixelSize: _t.bodyLarge.size; color: colors.onSurfaceVariant; anchors.horizontalCenter: parent.horizontalCenter }
                    }

                    Rectangle {
                        visible: _searchQuery.length > 0 && folderModel.count > 0
                        anchors.bottom: parent.bottom; anchors.right: parent.right; anchors.margins: 16
                        width: srText.implicitWidth + 16; height: 24; radius: 12; color: colors.secondaryContainer
                        Text { id: srText; anchors.centerIn: parent; text: folderModel.count + " result" + (folderModel.count !== 1 ? "s" : ""); font.family: _t.labelSmall.family; font.pixelSize: _t.labelSmall.size; color: colors.onSecondaryContainer }
                    }
                }
            }
        }

        // ───────────────────────────────────────────────────────
        // FOOTER
        // ───────────────────────────────────────────────────────

        Rectangle {
            id: footer
            anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right
            height: root.mode === "save" ? 108 : 64; color: colors.surfaceContainer

            ColumnLayout {
                anchors.fill: parent; anchors.margins: 16; spacing: 12

                RowLayout {
                    visible: root.mode === "save"; Layout.fillWidth: true; spacing: 12
                    Text { text: "Save as:"; font.family: _t.labelLarge.family; font.pixelSize: _t.labelLarge.size; font.weight: Font.Medium; color: colors.onSurfaceVariant }
                    Rectangle {
                        Layout.fillWidth: true; height: 40; radius: 20; color: colors.surfaceContainerHighest
                        TextInput {
                            id: fileNameInput; anchors.fill: parent; anchors.leftMargin: 16; anchors.rightMargin: 16
                            verticalAlignment: Text.AlignVCenter; font.family: _t.bodyMedium.family; font.pixelSize: _t.bodyMedium.size
                            color: colors.onSurface; selectionColor: colors.primaryContainer; selectedTextColor: colors.onPrimaryContainer
                            selectByMouse: true; text: root.fileName; onTextChanged: root.fileName = text
                            onAccepted: if (_canAccept()) _accept()
                            Text { visible: !fileNameInput.text; text: "Enter file name"; font: fileNameInput.font; color: colors.onSurfaceVariant }
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true; spacing: 12
                    Rectangle {
                        visible: root.nameFilters.length > 0 && root.mode !== "folder"
                        width: 200; height: 36; radius: 18; color: colors.surfaceContainerHighest
                        Row { anchors.fill: parent; anchors.leftMargin: 14; anchors.rightMargin: 10
                            Text { width: parent.width - 28; anchors.verticalCenter: parent.verticalCenter; text: root.nameFilters[root.currentFilter] || "All Files"; font.family: _t.bodySmall.family; font.pixelSize: _t.bodySmall.size; color: colors.onSurface; elide: Text.ElideRight }
                            Icon { anchors.verticalCenter: parent.verticalCenter; source: "expand_more"; size: 18; color: colors.onSurfaceVariant }
                        }
                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: filterPopup.open() }
                    }
                    Text {
                        Layout.fillWidth: true
                        text: root.mode === "openMultiple" && root.selectedFiles.length > 0 ? root.selectedFiles.length + " selected" : root.selectedFile.toString() !== "" ? root.selectedFile.toString().split("/").pop() : ""
                        font.family: _t.bodySmall.family; font.pixelSize: _t.bodySmall.size; color: colors.onSurfaceVariant; elide: Text.ElideMiddle
                    }
                    Buttons.Button { text: "Cancel"; variant: "outlined"; onClicked: { root.rejected(); root.close() } }
                    Buttons.Button { text: root.mode === "save" ? "Save" : root.mode === "folder" ? "Select" : "Open"; variant: "filled"; enabled: _canAccept(); onClicked: if (_canAccept()) _accept() }
                }
            }
        }
    }

    // Window border
    Rectangle { anchors.fill: parent; radius: windowRadius; color: "transparent"; border.width: 1; border.color: Qt.rgba(colors.shadow.r, colors.shadow.g, colors.shadow.b, 0.15); visible: !root.isMaximized; z: 1000 }

    // ═══════════════════════════════════════════════════════════════
    // RESIZE HANDLES
    // ═══════════════════════════════════════════════════════════════

    Loader {
        active: !root.isMaximized; anchors.fill: parent; z: 1010
        sourceComponent: Item {
            property int edge: 6; property int corner: 16
            MouseArea { anchors { top: parent.top; left: parent.left; right: parent.right } height: edge; cursorShape: Qt.SizeVerCursor; onPressed: root.startSystemResize(Qt.TopEdge) }
            MouseArea { anchors { bottom: parent.bottom; left: parent.left; right: parent.right } height: edge; cursorShape: Qt.SizeVerCursor; onPressed: root.startSystemResize(Qt.BottomEdge) }
            MouseArea { anchors { left: parent.left; top: parent.top; bottom: parent.bottom } width: edge; cursorShape: Qt.SizeHorCursor; onPressed: root.startSystemResize(Qt.LeftEdge) }
            MouseArea { anchors { right: parent.right; top: parent.top; bottom: parent.bottom } width: edge; cursorShape: Qt.SizeHorCursor; onPressed: root.startSystemResize(Qt.RightEdge) }
            MouseArea { anchors { top: parent.top; left: parent.left } width: corner; height: corner; cursorShape: Qt.SizeFDiagCursor; onPressed: root.startSystemResize(Qt.TopEdge | Qt.LeftEdge) }
            MouseArea { anchors { top: parent.top; right: parent.right } width: corner; height: corner; cursorShape: Qt.SizeBDiagCursor; onPressed: root.startSystemResize(Qt.TopEdge | Qt.RightEdge) }
            MouseArea { anchors { bottom: parent.bottom; left: parent.left } width: corner; height: corner; cursorShape: Qt.SizeBDiagCursor; onPressed: root.startSystemResize(Qt.BottomEdge | Qt.LeftEdge) }
            MouseArea { anchors { bottom: parent.bottom; right: parent.right } width: corner; height: corner; cursorShape: Qt.SizeFDiagCursor; onPressed: root.startSystemResize(Qt.BottomEdge | Qt.RightEdge) }
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // VIEW COMPONENTS
    // ═══════════════════════════════════════════════════════════════

    Component {
        id: gridComp
        GridView {
            readonly property int cols: Math.max(1, Math.floor(width / (root.gridIconSize + 56)))
            cellWidth: width / cols; cellHeight: root.gridIconSize + 56
            clip: true; model: folderModel; boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

            delegate: Item {
                width: GridView.view.cellWidth; height: GridView.view.cellHeight
                readonly property bool selected: _isSelected(model.fileUrl)

                Rectangle {
                    anchors.fill: parent; anchors.margins: 4; radius: 12
                    color: selected ? colors.primaryContainer : gM.containsMouse ? colors.surfaceContainerHighest : "transparent"

                    // Multi-select checkbox
                    Rectangle {
                        visible: root.mode === "openMultiple" && !model.fileIsDir && (selected || gM.containsMouse)
                        anchors.top: parent.top; anchors.right: parent.right; anchors.topMargin: 8; anchors.rightMargin: 8
                        width: 22; height: 22; radius: 6; z: 10
                        color: _isInMultiSelection(model.fileUrl) ? colors.primary : "transparent"
                        border.width: _isInMultiSelection(model.fileUrl) ? 0 : 1.5
                        border.color: colors.outlineVariant
                        Icon { visible: _isInMultiSelection(model.fileUrl); anchors.centerIn: parent; source: "check"; size: 16; color: colors.onPrimary }
                    }

                    Column {
                        anchors.fill: parent; anchors.margins: 10; spacing: 6
                        Item {
                            width: root.gridIconSize; height: root.gridIconSize; anchors.horizontalCenter: parent.horizontalCenter
                            Rectangle { id: gThumb; anchors.fill: parent; radius: 8; clip: true; color: "transparent"; visible: root.showThumbnails && _isImageFile(model.fileName) && !model.fileIsDir
                                Image { anchors.fill: parent; source: gThumb.visible ? model.fileUrl : ""; fillMode: Image.PreserveAspectCrop; asynchronous: true; cache: true; sourceSize: Qt.size(root.gridIconSize * 2, root.gridIconSize * 2) }
                            }
                            Icon { anchors.centerIn: parent; visible: !gThumb.visible; source: model.fileIsDir ? "folder" : _getFileIcon(model.fileName); size: root.gridIconSize * 0.55; color: model.fileIsDir ? colors.primary : colors.onSurfaceVariant }
                        }
                        Text {
                            width: parent.width; horizontalAlignment: Text.AlignHCenter
                            text: model.fileName; font.family: _t.bodySmall.family; font.pixelSize: _t.bodySmall.size
                            font.weight: selected ? Font.Medium : Font.Normal
                            color: selected ? colors.onPrimaryContainer : colors.onSurface
                            elide: Text.ElideMiddle; maximumLineCount: 2; wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        }
                    }

                    MouseArea {
                        id: gM; anchors.fill: parent; hoverEnabled: true
                        acceptedButtons: Qt.LeftButton | Qt.RightButton; cursorShape: Qt.PointingHandCursor
                        onClicked: function(mouse) {
                            if (mouse.button === Qt.RightButton) { _showCtxAt(model.fileUrl, model.fileName, model.fileIsDir, mouse, gM) }
                            else _handleClick(model.fileUrl, model.fileIsDir, model.fileName)
                        }
                        onDoubleClicked: _handleDoubleClick(model.fileUrl, model.fileIsDir)
                    }
                }
            }
        }
    }

    Component {
        id: listComp
        ListView {
            clip: true; model: folderModel; spacing: 2; boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

            delegate: Rectangle {
                width: ListView.view.width; height: 42; radius: 10
                readonly property bool selected: _isSelected(model.fileUrl)
                color: selected ? colors.primaryContainer : lM.containsMouse ? colors.surfaceContainerHighest : "transparent"

                RowLayout {
                    anchors.fill: parent; anchors.leftMargin: 8; anchors.rightMargin: 12; spacing: 0

                    // Checkbox for multi-select
                    Item {
                        Layout.preferredWidth: root.mode === "openMultiple" && !model.fileIsDir ? 32 : 0; Layout.preferredHeight: 32
                        visible: root.mode === "openMultiple" && !model.fileIsDir
                        Rectangle {
                            anchors.centerIn: parent; width: 22; height: 22; radius: 6
                            visible: _isInMultiSelection(model.fileUrl) || lM.containsMouse
                            color: _isInMultiSelection(model.fileUrl) ? colors.primary : "transparent"
                            border.width: _isInMultiSelection(model.fileUrl) ? 0 : 1.5; border.color: colors.outlineVariant
                            Icon { visible: _isInMultiSelection(model.fileUrl); anchors.centerIn: parent; source: "check"; size: 16; color: colors.onPrimary }
                        }
                    }

                    Item {
                        Layout.preferredWidth: 32; Layout.preferredHeight: 32; Layout.leftMargin: root.mode === "openMultiple" && !model.fileIsDir ? 0 : 4
                        Rectangle { id: lThumb; anchors.fill: parent; radius: 6; clip: true; color: "transparent"; visible: root.showThumbnails && _isImageFile(model.fileName) && !model.fileIsDir
                            Image { anchors.fill: parent; source: lThumb.visible ? model.fileUrl : ""; fillMode: Image.PreserveAspectCrop; asynchronous: true; cache: true; sourceSize: Qt.size(64, 64) }
                        }
                        Icon { anchors.centerIn: parent; visible: !lThumb.visible; source: model.fileIsDir ? "folder" : _getFileIcon(model.fileName); size: 22; color: model.fileIsDir ? colors.primary : colors.onSurfaceVariant }
                    }

                    Text { Layout.fillWidth: true; Layout.leftMargin: 12; text: model.fileName; font.family: _t.bodyMedium.family; font.pixelSize: _t.bodyMedium.size; color: selected ? colors.onPrimaryContainer : colors.onSurface; elide: Text.ElideMiddle }
                    Text { Layout.preferredWidth: 80; text: model.fileIsDir ? "--" : _formatSize(model.fileSize); font.family: _t.bodySmall.family; font.pixelSize: _t.bodySmall.size; color: colors.onSurfaceVariant; horizontalAlignment: Text.AlignRight }
                    Text { Layout.preferredWidth: 140; Layout.leftMargin: 16; text: Qt.formatDateTime(model.fileModified, "MMM d, yyyy"); font.family: _t.bodySmall.family; font.pixelSize: _t.bodySmall.size; color: colors.onSurfaceVariant }
                    Text { Layout.preferredWidth: 100; Layout.leftMargin: 16; text: model.fileIsDir ? "Folder" : _getFileType(model.fileName); font.family: _t.bodySmall.family; font.pixelSize: _t.bodySmall.size; color: colors.onSurfaceVariant; elide: Text.ElideRight }
                }

                MouseArea {
                    id: lM; anchors.fill: parent; hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton; cursorShape: Qt.PointingHandCursor
                    onClicked: function(mouse) {
                        if (mouse.button === Qt.RightButton) _showCtxAt(model.fileUrl, model.fileName, model.fileIsDir, mouse, lM)
                        else _handleClick(model.fileUrl, model.fileIsDir, model.fileName)
                    }
                    onDoubleClicked: _handleDoubleClick(model.fileUrl, model.fileIsDir)
                }
            }
        }
    }

    Component {
        id: treeComp
        ListView {
            clip: true; model: folderModel; spacing: 2; boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

            delegate: Rectangle {
                width: ListView.view.width; height: 40; radius: 10
                readonly property bool selected: _isSelected(model.fileUrl)
                color: selected ? colors.primaryContainer : tM.containsMouse ? colors.surfaceContainerHighest : "transparent"

                RowLayout {
                    anchors.fill: parent; anchors.leftMargin: 8; anchors.rightMargin: 12; spacing: 0

                    Item {
                        Layout.preferredWidth: 32; Layout.preferredHeight: 32
                        Rectangle {
                            anchors.fill: parent; radius: 6; visible: model.fileIsDir
                            color: chevM.containsMouse ? colors.surfaceContainerHighest : "transparent"
                            Icon { anchors.centerIn: parent; source: "chevron_right"; size: 22; color: colors.onSurfaceVariant }
                            MouseArea { id: chevM; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: _navigateTo(model.fileUrl); z: 10 }
                        }
                    }

                    Icon { source: model.fileIsDir ? "folder" : _getFileIcon(model.fileName); size: 22; color: model.fileIsDir ? colors.primary : colors.onSurfaceVariant }
                    Text { Layout.fillWidth: true; Layout.leftMargin: 10; text: model.fileName; font.family: _t.bodyMedium.family; font.pixelSize: _t.bodyMedium.size; color: selected ? colors.onPrimaryContainer : colors.onSurface; elide: Text.ElideMiddle }
                    Text { Layout.preferredWidth: 80; text: model.fileIsDir ? "--" : _formatSize(model.fileSize); font.family: _t.bodySmall.family; font.pixelSize: _t.bodySmall.size; color: colors.onSurfaceVariant; horizontalAlignment: Text.AlignRight }
                    Text { Layout.preferredWidth: 140; Layout.leftMargin: 16; text: Qt.formatDateTime(model.fileModified, "MMM d, yyyy"); font.family: _t.bodySmall.family; font.pixelSize: _t.bodySmall.size; color: colors.onSurfaceVariant }
                    Text { Layout.preferredWidth: 100; Layout.leftMargin: 16; text: model.fileIsDir ? "Folder" : _getFileType(model.fileName); font.family: _t.bodySmall.family; font.pixelSize: _t.bodySmall.size; color: colors.onSurfaceVariant; elide: Text.ElideRight }
                }

                MouseArea {
                    id: tM; anchors.fill: parent; hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton; cursorShape: Qt.PointingHandCursor
                    onClicked: function(mouse) {
                        if (mouse.button === Qt.RightButton) _showCtxAt(model.fileUrl, model.fileName, model.fileIsDir, mouse, tM)
                        else _handleClick(model.fileUrl, model.fileIsDir, model.fileName)
                    }
                    onDoubleClicked: _handleDoubleClick(model.fileUrl, model.fileIsDir)
                }
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // INLINE COMPONENTS
    // ═══════════════════════════════════════════════════════════════

    component HeaderCell: Item {
        property string text; property string sortKey; height: 36
        Row { anchors.fill: parent; anchors.leftMargin: 8; spacing: 4
            Text { anchors.verticalCenter: parent.verticalCenter; text: parent.parent.text; font.family: _t.labelSmall.family; font.pixelSize: _t.labelSmall.size; font.weight: Font.Bold; color: colors.onSurfaceVariant }
            Icon { anchors.verticalCenter: parent.verticalCenter; visible: root.sortBy === sortKey; source: root.sortAscending ? "expand_less" : "expand_more"; size: 14; color: colors.primary }
        }
        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: { if (root.sortBy === sortKey) root.sortAscending = !root.sortAscending; else { root.sortBy = sortKey; root.sortAscending = true } } }
    }

    // ═══════════════════════════════════════════════════════════════
    // CONTEXT MENUS
    // ═══════════════════════════════════════════════════════════════

    // Stored target for context menu (avoids binding issues)
    property url _ctxFile: ""
    property string _ctxName: ""
    property bool _ctxIsDir: false

    Menus.ContextMenu {
        id: fileCtxMenu

        Menus.MenuItem { text: root._ctxIsDir ? "Open Folder" : "Open"; leadingIcon: root._ctxIsDir ? "folder_open" : "open_in_new"; onClicked: root._ctxIsDir ? _navigateTo(root._ctxFile) : (function() { root.selectedFile = root._ctxFile; _accept() })() }
        Menus.MenuDivider {}
        Menus.MenuItem { text: "New Folder"; leadingIcon: "create_new_folder"; onClicked: newFolderPopup.open() }
        Menus.MenuDivider {}
        Menus.MenuItem {
            visible: root.mode === "openMultiple" && !root._ctxIsDir
            text: _isInMultiSelection(root._ctxFile) ? "Deselect" : "Select"
            leadingIcon: _isInMultiSelection(root._ctxFile) ? "deselect" : "check_circle"
            onClicked: _handleClick(root._ctxFile, false, root._ctxName)
        }
        Menus.MenuItem {
            visible: root.mode === "openMultiple"
            text: "Select All"; leadingIcon: "select_all"
            onClicked: _selectAll()
        }
        Menus.MenuItem {
            visible: root.mode === "openMultiple" && root.selectedFiles.length > 0
            text: "Deselect All"; leadingIcon: "deselect"
            onClicked: { root.selectedFiles = [] }
        }
        Menus.MenuDivider {}
        Menus.MenuItem { text: "Copy Name"; leadingIcon: "badge"; onClicked: _copyToClipboard(root._ctxName) }
        Menus.MenuItem { text: "Copy Path"; leadingIcon: "content_copy"; onClicked: _copyToClipboard(root._ctxFile.toString().replace("file://", "")) }
    }

    Menus.ContextMenu {
        id: bgCtxMenu

        Menus.MenuItem { text: "New Folder"; leadingIcon: "create_new_folder"; onClicked: newFolderPopup.open() }
        Menus.MenuDivider {}
        Menus.MenuItem { visible: root.mode === "openMultiple"; text: "Select All"; leadingIcon: "select_all"; onClicked: _selectAll() }
        Menus.MenuItem { visible: root.mode === "openMultiple" && root.selectedFiles.length > 0; text: "Deselect All (" + root.selectedFiles.length + ")"; leadingIcon: "deselect"; onClicked: { root.selectedFiles = [] } }
        Menus.MenuDivider { visible: root.mode === "openMultiple" }
        Menus.MenuItem { text: root.showHidden ? "Hide Hidden Files" : "Show Hidden Files"; leadingIcon: root.showHidden ? "visibility_off" : "visibility"; onClicked: root.showHidden = !root.showHidden }
        Menus.MenuDivider {}
        Menus.MenuItem { text: "Sort by Name"; leadingIcon: root.sortBy === "name" ? "check" : ""; onClicked: root.sortBy = "name" }
        Menus.MenuItem { text: "Sort by Size"; leadingIcon: root.sortBy === "size" ? "check" : ""; onClicked: root.sortBy = "size" }
        Menus.MenuItem { text: "Sort by Date"; leadingIcon: root.sortBy === "date" ? "check" : ""; onClicked: root.sortBy = "date" }
        Menus.MenuItem { text: "Sort by Type"; leadingIcon: root.sortBy === "type" ? "check" : ""; onClicked: root.sortBy = "type" }
        Menus.MenuDivider {}
        Menus.MenuItem { text: root.sortAscending ? "Sort Descending" : "Sort Ascending"; leadingIcon: root.sortAscending ? "arrow_downward" : "arrow_upward"; onClicked: root.sortAscending = !root.sortAscending }
        Menus.MenuDivider {}
        Menus.MenuItem { text: "Refresh"; leadingIcon: "refresh"; onClicked: { var f = root.currentFolder; root.currentFolder = ""; root.currentFolder = f } }
    }

    TextInput { id: clipHelper; visible: false }

    // ═══════════════════════════════════════════════════════════════
    // POPUPS
    // ═══════════════════════════════════════════════════════════════

    Popup {
        id: filterPopup; y: footer.y - height - 4; x: 16; width: 200; padding: 6
        background: Rectangle { color: colors.surfaceContainerHigh; radius: 12; border.width: 1; border.color: colors.outlineVariant }
        contentItem: Column { spacing: 2
            Repeater { model: root.nameFilters
                Rectangle { width: 188; height: 36; radius: 8; color: fM.containsMouse ? colors.surfaceContainerHighest : "transparent"
                    Text { anchors.left: parent.left; anchors.leftMargin: 12; anchors.verticalCenter: parent.verticalCenter; text: modelData; font.family: _t.bodyMedium.family; font.pixelSize: _t.bodyMedium.size; color: colors.onSurface }
                    MouseArea { id: fM; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: { root.currentFilter = index; filterPopup.close() } }
                }
            }
        }
    }

    Popup {
        id: newFolderPopup; anchors.centerIn: parent; width: 320; modal: true; padding: 20
        background: Rectangle { color: colors.surfaceContainerHigh; radius: 16 }
        contentItem: Column { spacing: 16
            Text { text: "New Folder"; font.family: _t.titleMedium.family; font.pixelSize: _t.titleMedium.size; font.weight: Font.Medium; color: colors.onSurface }
            Rectangle { width: parent.width; height: 44; radius: 22; color: colors.surfaceContainerHighest
                TextInput { id: nfInput; anchors.fill: parent; anchors.leftMargin: 16; anchors.rightMargin: 16; verticalAlignment: Text.AlignVCenter; font.family: _t.bodyMedium.family; font.pixelSize: _t.bodyMedium.size; color: colors.onSurface; selectionColor: colors.primaryContainer; selectedTextColor: colors.onPrimaryContainer; selectByMouse: true
                    onAccepted: if (text.trim()) { nfInput.text = ""; newFolderPopup.close() }
                    Text { visible: !nfInput.text; text: "Folder name"; font: nfInput.font; color: colors.onSurfaceVariant }
                }
            }
            Row { anchors.right: parent.right; spacing: 8
                Buttons.Button { text: "Cancel"; variant: "outlined"; onClicked: newFolderPopup.close() }
                Buttons.Button { text: "Create"; variant: "filled"; enabled: nfInput.text.trim() !== ""; onClicked: if (nfInput.text.trim()) { nfInput.text = ""; newFolderPopup.close() } }
            }
        }
        onOpened: nfInput.forceActiveFocus()
    }

    // ═══════════════════════════════════════════════════════════════
    // FUNCTIONS
    // ═══════════════════════════════════════════════════════════════

    function _getDisplayPath(url) { return url.toString().replace("file://", "") || "/" }

    function _navigateTo(url) {
        if (_historyIndex < _navigationHistory.length - 1) _navigationHistory = _navigationHistory.slice(0, _historyIndex + 1)
        _navigationHistory.push(url); _historyIndex = _navigationHistory.length - 1
        currentFolder = url; selectedFile = ""; selectedFiles = []
    }

    function _goBack() { if (_historyIndex > 0) { _historyIndex--; currentFolder = _navigationHistory[_historyIndex] } }
    function _goForward() { if (_historyIndex < _navigationHistory.length - 1) { _historyIndex++; currentFolder = _navigationHistory[_historyIndex] } }
    function _goUp() { var p = currentFolder.toString(), l = p.lastIndexOf("/"); _navigateTo(l > 7 ? p.substring(0, l) : "file:///") }

    function _handleClick(url, isDir, name) {
        // Always set highlight
        selectedFile = url

        // In multi-select, toggle the file in/out of selectedFiles array
        if (mode === "openMultiple" && !isDir) {
            var arr = selectedFiles.slice()
            var idx = -1
            for (var i = 0; i < arr.length; i++) {
                if (arr[i].toString() === url.toString()) { idx = i; break }
            }
            if (idx >= 0) arr.splice(idx, 1)
            else arr.push(url)
            selectedFiles = arr
        } else if (mode === "save" && !isDir) {
            fileName = name
        }
    }

    function _handleDoubleClick(url, isDir) {
        if (isDir) _navigateTo(url)
        else if (mode !== "folder") { selectedFile = url; _accept() }
    }

    // Unified selection check — used by all delegates via single `selected` property
    function _isSelected(url) {
        var u = url.toString()
        if (selectedFile.toString() === u) return true
        if (mode === "openMultiple") {
            for (var i = 0; i < selectedFiles.length; i++) {
                if (selectedFiles[i].toString() === u) return true
            }
        }
        return false
    }

    // Check if specifically in the multi-select array (for checkbox state)
    function _isInMultiSelection(url) {
        var u = url.toString()
        for (var i = 0; i < selectedFiles.length; i++) {
            if (selectedFiles[i].toString() === u) return true
        }
        return false
    }

    function _selectAll() {
        var all = []
        for (var i = 0; i < folderModel.count; i++) {
            if (!folderModel.get(i, "fileIsDir")) all.push(folderModel.get(i, "fileUrl"))
        }
        selectedFiles = all
    }

    function _canAccept() {
        if (mode === "save") return fileName.trim() !== ""
        if (mode === "openMultiple") return selectedFiles.length > 0
        if (mode === "folder") return true
        return selectedFile.toString() !== ""
    }

    function _accept() {
        if (mode === "save") { var p = currentFolder.toString(); selectedFile = (p.endsWith("/") ? p : p + "/") + fileName }
        if (mode === "folder" && selectedFile.toString() === "") selectedFile = currentFolder
        accepted(); close()
    }

    function _copyToClipboard(text) { clipHelper.text = text; clipHelper.selectAll(); clipHelper.copy() }

    // Context menu — set properties then use popup(x,y)
    function _showCtxAt(url, name, isDir, mouse, area) {
        root._ctxFile = url
        root._ctxName = name
        root._ctxIsDir = isDir
        fileCtxMenu.popup(mouse.x, mouse.y)
    }

    function _isImageFile(n) { return /\.(png|jpe?g|gif|bmp|webp|ico|tiff?)$/i.test(n) }
    function _getFileIcon(n) { return _fileIconMap[n.split('.').pop().toLowerCase()] || "insert_drive_file" }
    function _getFileType(n) { var e = n.split('.').pop().toLowerCase(); return e === n.toLowerCase() ? "File" : e.toUpperCase() + " File" }
    function _formatSize(b) { if (b < 1024) return b + " B"; if (b < 1048576) return (b/1024).toFixed(1) + " KB"; if (b < 1073741824) return (b/1048576).toFixed(1) + " MB"; return (b/1073741824).toFixed(1) + " GB" }

    function open() { visible = true; raise(); requestActivate() }

    Component.onCompleted: { _navigationHistory = [currentFolder]; _historyIndex = 0 }
}
