import QtQuick
import QtQuick.Window
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Effects
import QtCore
import Chi 1.0
import "../../theme" as Theme
import "../common"
import "../menus" as Menus
import "../Buttons" as Buttons
import "../navigation" as Nav

Window {
    id: root

    // ═══ PUBLIC API ═══════════════════════════════════════════

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

    signal accepted
    signal rejected

    // ═══ WINDOW ═══════════════════════════════════════════════

    visible: false
    color: "transparent"
    flags: Qt.Window | Qt.FramelessWindowHint
    width: 1000
    height: 650
    minimumWidth: 700
    minimumHeight: 450

    property var colors: Theme.ChiTheme.colors
    readonly property var _t: Theme.ChiTheme.typography
    readonly property bool isMaximized: visibility === Window.Maximized
    readonly property real windowRadius: isMaximized ? 0 : 16

    property var _navigationHistory: []
    property int _historyIndex: -1
    property string _searchQuery: ""
    property var _selectedSet: ({})

    // ═══ TYPE-AHEAD ═══════════════════════════════════════════

    property string _typeAheadBuffer: ""
    Timer {
        id: typeAheadTimer
        interval: 800
        onTriggered: root._typeAheadBuffer = ""
    }

    function _jumpToFile(ch) {
        _typeAheadBuffer += ch.toLowerCase();
        typeAheadTimer.restart();
        for (var i = 0; i < folderModel.count; i++) {
            var name = folderModel.get(i, "fileName");
            if (name && ("" + name).toLowerCase().indexOf(_typeAheadBuffer) === 0) {
                selectedFile = folderModel.get(i, "fileUrl");
                if (viewLoader.item && viewLoader.item.positionViewAtIndex)
                    viewLoader.item.positionViewAtIndex(i, ListView.Contain);
                break;
            }
        }
    }

    // ═══ NEW FOLDER STATE ═════════════════════════════════════

    readonly property bool _newFolderExists: {
        var name = nfInput.text.trim();
        if (name === "" || name.indexOf("/") >= 0 || name.indexOf("\\") >= 0)
            return false;
        var base = root.currentFolder.toString();
        if (base.startsWith("file://"))
            base = base.substring(7);
        return folderModel.fileExists(base + "/" + name);
    }

    // ═══ C++ MODEL ════════════════════════════════════════════

    ChiFileDialogModel {
        id: folderModel
        folder: root.currentFolder
        showDirs: true
        showFiles: root.mode !== "folder"
        showHidden: root.showHidden
        showDirsFirst: true
        sortField: root.sortBy === "size" ? ChiFileDialogModel.SortBySize : root.sortBy === "date" ? ChiFileDialogModel.SortByDate : root.sortBy === "type" ? ChiFileDialogModel.SortByType : ChiFileDialogModel.SortByName
        sortReversed: !root.sortAscending
        nameFilters: root._computedFilters
        searchQuery: root._searchQuery
    }

    // ═══ QUICK ACCESS ═════════════════════════════════════════

    readonly property url _homePath: StandardPaths.writableLocation(StandardPaths.HomeLocation)
    readonly property url _documentsPath: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
    readonly property url _downloadsPath: StandardPaths.writableLocation(StandardPaths.DownloadLocation)
    readonly property url _picturesPath: StandardPaths.writableLocation(StandardPaths.PicturesLocation)
    readonly property url _musicPath: StandardPaths.writableLocation(StandardPaths.MusicLocation)
    readonly property url _moviesPath: StandardPaths.writableLocation(StandardPaths.MoviesLocation)
    readonly property url _desktopPath: StandardPaths.writableLocation(StandardPaths.DesktopLocation)

    readonly property var _quickAccess: [
        {
            name: "Home",
            icon: "home",
            path: _homePath
        },
        {
            name: "Desktop",
            icon: "desktop_windows",
            path: _desktopPath
        },
        {
            name: "Documents",
            icon: "description",
            path: _documentsPath
        },
        {
            name: "Downloads",
            icon: "download",
            path: _downloadsPath
        },
        {
            name: "Pictures",
            icon: "image",
            path: _picturesPath
        },
        {
            name: "Music",
            icon: "music_note",
            path: _musicPath
        },
        {
            name: "Videos",
            icon: "movie",
            path: _moviesPath
        }
    ]

    readonly property var _computedFilters: {
        var base = ["*"];
        if (nameFilters.length > 0) {
            var f = nameFilters[currentFilter] || "";
            var m = f.match(/\(([^)]+)\)/);
            if (m)
                base = m[1].split(" ");
        }
        return base;
    }

    // ═══ CORNER MASK ══════════════════════════════════════════

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

        Rectangle {
            anchors.fill: parent
            color: colors.surface
        }

        Keys.onPressed: function (event) {
            if (event.key === Qt.Key_Escape) {
                root.rejected();
                root.close();
                return;
            }
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                if (_canAccept())
                    _accept();
                return;
            }
            if (event.key === Qt.Key_A && (event.modifiers & Qt.ControlModifier)) {
                _selectAll();
                return;
            }
            if (event.key === Qt.Key_H && (event.modifiers & Qt.ControlModifier)) {
                root.showHidden = !root.showHidden;
                return;
            }
            if (event.key === Qt.Key_Backspace) {
                _goUp();
                return;
            }
            if (event.text.length === 1 && /[a-zA-Z0-9]/.test(event.text) && event.modifiers === 0)
                _jumpToFile(event.text);
        }

        // ── HEADER ──────────────────────────────────────────

        Rectangle {
            id: header
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 52
            color: colors.surfaceContainer

            MouseArea {
                anchors.fill: parent
                z: -1
                onPressed: root.startSystemMove()
                onDoubleClicked: root.isMaximized ? root.showNormal() : root.showMaximized()
            }

            Row {
                id: headerLeft
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8
                Row {
                    spacing: 8
                    anchors.verticalCenter: parent.verticalCenter
                    Repeater {
                        model: [
                            {
                                c: "#FF5F57",
                                a: function () {
                                    root.rejected();
                                    root.close();
                                }
                            },
                            {
                                c: "#FFBD2E",
                                a: function () {
                                    root.showMinimized();
                                }
                            },
                            {
                                c: "#28C840",
                                a: function () {
                                    root.isMaximized ? root.showNormal() : root.showMaximized();
                                }
                            }
                        ]
                        Rectangle {
                            width: 14
                            height: 14
                            radius: 7
                            color: wcM.pressed ? Qt.darker(modelData.c, 1.2) : wcM.containsMouse ? Qt.lighter(modelData.c, 1.1) : modelData.c
                            border.width: 0.5
                            border.color: Qt.darker(modelData.c, 1.3)
                            MouseArea {
                                id: wcM
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: modelData.a()
                            }
                        }
                    }
                }
                Item {
                    width: 4
                    height: 1
                }
                Row {
                    spacing: 2
                    anchors.verticalCenter: parent.verticalCenter
                    Repeater {
                        model: [
                            {
                                icon: "chevron_left",
                                enabled: root._historyIndex > 0,
                                action: function () {
                                    _goBack();
                                },
                                tip: "Back"
                            },
                            {
                                icon: "chevron_right",
                                enabled: root._historyIndex < root._navigationHistory.length - 1,
                                action: function () {
                                    _goForward();
                                },
                                tip: "Forward"
                            },
                            {
                                icon: "expand_less",
                                enabled: root.currentFolder.toString() !== "file:///",
                                action: function () {
                                    _goUp();
                                },
                                tip: "Up"
                            }
                        ]
                        Rectangle {
                            width: 36
                            height: 36
                            radius: 8
                            opacity: modelData.enabled ? 1.0 : 0.4
                            color: navM.pressed ? Qt.rgba(colors.primary.r, colors.primary.g, colors.primary.b, 0.15) : navM.containsMouse ? Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.08) : "transparent"
                            Icon {
                                anchors.centerIn: parent
                                source: modelData.icon
                                size: 24
                                color: colors.onSurfaceVariant
                            }
                            MouseArea {
                                id: navM
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: modelData.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                onClicked: if (modelData.enabled)
                                    modelData.action()
                            }
                            ToolTip {
                                visible: navM.containsMouse
                                text: modelData.tip
                                delay: 500
                            }
                        }
                    }
                }
            }

            Nav.PathSearchBar {
                id: pathBar
                anchors.left: headerLeft.right
                anchors.leftMargin: 12
                anchors.right: headerRight.left
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                height: 36
                path: _getDisplayPath(root.currentFolder)
                onPathAccepted: function (p) {
                    _navigateTo(p.startsWith("file://") ? p : "file://" + p);
                }
                onSearchToggled: function (active) {
                    pathBar.searching = active;
                    if (!active)
                        root._searchQuery = "";
                }
            }
            Connections {
                target: pathBar
                function onCurrentTextChanged() {
                    if (pathBar.searching)
                        root._searchQuery = pathBar.currentText;
                }
            }

            Row {
                id: headerRight
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2
                Repeater {
                    model: [
                        {
                            icon: "grid_view",
                            checked: root.viewMode === "grid",
                            action: function () {
                                root.viewMode = "grid";
                            }
                        },
                        {
                            icon: "view_list",
                            checked: root.viewMode === "list",
                            action: function () {
                                root.viewMode = "list";
                            }
                        },
                        {
                            icon: "account_tree",
                            checked: root.viewMode === "tree",
                            action: function () {
                                root.viewMode = "tree";
                            }
                        }
                    ]
                    Rectangle {
                        width: 36
                        height: 36
                        radius: 8
                        color: modelData.checked ? colors.secondaryContainer : viewM.containsMouse ? Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.08) : "transparent"
                        Icon {
                            anchors.centerIn: parent
                            source: modelData.icon
                            size: 22
                            color: modelData.checked ? colors.onSecondaryContainer : colors.onSurfaceVariant
                        }
                        MouseArea {
                            id: viewM
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: modelData.action()
                        }
                    }
                }
                Item {
                    width: 8
                    height: 1
                }
                Rectangle {
                    width: 36
                    height: 36
                    radius: 8
                    color: root.showHidden ? colors.secondaryContainer : hiddenM.containsMouse ? Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.08) : "transparent"
                    Icon {
                        anchors.centerIn: parent
                        source: root.showHidden ? "visibility" : "visibility_off"
                        size: 22
                        color: root.showHidden ? colors.onSecondaryContainer : colors.onSurfaceVariant
                    }
                    MouseArea {
                        id: hiddenM
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.showHidden = !root.showHidden
                    }
                }
                Rectangle {
                    visible: root.mode === "save" || root.mode === "folder"
                    width: 36
                    height: 36
                    radius: 8
                    color: nfBtnM.containsMouse ? Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.08) : "transparent"
                    Icon {
                        anchors.centerIn: parent
                        source: "create_new_folder"
                        size: 22
                        color: colors.onSurfaceVariant
                    }
                    MouseArea {
                        id: nfBtnM
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: newFolderPopup.open()
                    }
                }
            }
        }

        // ── BODY ────────────────────────────────────────────

        Item {
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: footer.top

            Row {
                anchors.fill: parent

                // Sidebar rail
                Rectangle {
                    id: navRail
                    width: root.sidebarExpanded ? 0 : 56
                    height: parent.height
                    color: colors.surfaceContainer
                    visible: width > 0
                    Column {
                        anchors.fill: parent
                        anchors.topMargin: 8
                        spacing: 4
                        Buttons.IconButton {
                            anchors.horizontalCenter: parent.horizontalCenter
                            icon: "menu"
                            size: "xsmall"
                            variant: "standard"
                            onClicked: root.sidebarExpanded = true
                        }
                        Item {
                            width: 1
                            height: 8
                        }
                        Repeater {
                            model: root._quickAccess
                            Item {
                                width: navRail.width
                                height: 48
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 40
                                    height: 40
                                    radius: 12
                                    readonly property bool active: root.currentFolder.toString() === modelData.path.toString()
                                    color: active ? colors.secondaryContainer : railM.containsMouse ? colors.surfaceContainerHighest : "transparent"
                                    Icon {
                                        anchors.centerIn: parent
                                        source: modelData.icon
                                        size: 22
                                        color: parent.active ? colors.onSecondaryContainer : colors.onSurfaceVariant
                                    }
                                    MouseArea {
                                        id: railM
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: _navigateTo(modelData.path)
                                    }
                                    ToolTip {
                                        visible: railM.containsMouse
                                        text: modelData.name
                                        delay: 500
                                    }
                                }
                            }
                        }
                    }
                }

                // Sidebar expanded
                Rectangle {
                    id: sidebarPanel
                    width: root.sidebarExpanded ? 200 : 0
                    height: parent.height
                    color: colors.surfaceContainer
                    visible: width > 0
                    clip: true
                    Behavior on width {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                    }
                    Column {
                        anchors.fill: parent
                        anchors.topMargin: 8
                        spacing: 4
                        Rectangle {
                            width: parent.width - 16
                            x: 8
                            height: 40
                            radius: 12
                            color: collapseM.containsMouse ? colors.surfaceContainerHighest : "transparent"
                            Row {
                                anchors.left: parent.left
                                anchors.leftMargin: 14
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 12
                                Icon {
                                    source: "menu_open"
                                    size: 22
                                    color: colors.onSurfaceVariant
                                }
                                Text {
                                    text: "Collapse"
                                    font.family: _t.bodyMedium.family
                                    font.pixelSize: _t.bodyMedium.size
                                    color: colors.onSurface
                                }
                            }
                            MouseArea {
                                id: collapseM
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.sidebarExpanded = false
                            }
                        }
                        Item {
                            width: 1
                            height: 8
                        }
                        Text {
                            text: "PLACES"
                            font.family: _t.labelSmall.family
                            font.pixelSize: _t.labelSmall.size
                            font.weight: Font.Bold
                            font.letterSpacing: 0.5
                            color: colors.onSurfaceVariant
                            leftPadding: 16
                        }
                        Item {
                            width: 1
                            height: 4
                        }
                        Repeater {
                            model: root._quickAccess
                            Rectangle {
                                width: sidebarPanel.width - 16
                                x: 8
                                height: 40
                                radius: 12
                                readonly property bool active: root.currentFolder.toString() === modelData.path.toString()
                                color: active ? colors.secondaryContainer : sideM.containsMouse ? colors.surfaceContainerHighest : "transparent"
                                Row {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 14
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 12
                                    Icon {
                                        source: modelData.icon
                                        size: 22
                                        color: parent.parent.active ? colors.onSecondaryContainer : colors.onSurfaceVariant
                                    }
                                    Text {
                                        text: modelData.name
                                        font.family: _t.bodyMedium.family
                                        font.pixelSize: _t.bodyMedium.size
                                        font.weight: parent.parent.active ? Font.Medium : Font.Normal
                                        color: parent.parent.active ? colors.onSecondaryContainer : colors.onSurface
                                    }
                                }
                                MouseArea {
                                    id: sideM
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: _navigateTo(modelData.path)
                                }
                            }
                        }
                    }
                }

                // Content
                Item {
                    id: contentArea
                    width: parent.width - (root.sidebarExpanded ? sidebarPanel.width : navRail.width)
                    height: parent.height

                    // Column headers (list/tree only)
                    Rectangle {
                        id: colHeaders
                        width: parent.width
                        height: root.viewMode !== "grid" ? 36 : 0
                        color: colors.surfaceContainerLow
                        visible: height > 0
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            spacing: 0
                            HeaderCell {
                                text: "Name"
                                Layout.fillWidth: true
                                sortKey: "name"
                            }
                            HeaderCell {
                                text: "Size"
                                Layout.preferredWidth: 80
                                sortKey: "size"
                            }
                            HeaderCell {
                                text: "Modified"
                                Layout.preferredWidth: 140
                                sortKey: "date"
                            }
                            HeaderCell {
                                text: "Type"
                                Layout.preferredWidth: 100
                                sortKey: "type"
                            }
                        }
                    }

                    // Loading
                    Rectangle {
                        anchors.centerIn: parent
                        visible: folderModel.loading
                        width: loadCol.implicitWidth + 32
                        height: loadCol.implicitHeight + 32
                        radius: 16
                        color: colors.surfaceContainerHigh
                        z: 5
                        Column {
                            id: loadCol
                            anchors.centerIn: parent
                            spacing: 8
                            CircularProgressIndicator {
                                anchors.horizontalCenter: parent.horizontalCenter
                                indeterminate: true
                            }
                            Text {
                                text: "Loading..."
                                font.family: _t.bodySmall.family
                                font.pixelSize: _t.bodySmall.size
                                color: colors.onSurfaceVariant
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }

                    // ── View Loader ──────────────────────────

                    Component {
                        id: gridComp
                        FileDialogGridView {
                            anchors.fill: parent
                            model: folderModel
                            iconSize: root.gridIconSize
                            showThumbnails: root.showThumbnails
                            colors: root.colors
                            selectMode: root.mode
                            selectedSet: root._selectedSet
                            onFileClicked: function (u, d, n) {
                                root._handleClick(u, d, n);
                            }
                            onFileDoubleClicked: function (u, d) {
                                root._handleDoubleClick(u, d);
                            }
                            onContextMenuRequested: function (u, n, d, mx, my, a) {
                                root._showCtxAt(u, n, d, mx, my, a);
                            }
                        }
                    }

                    Component {
                        id: listComp
                        FileDialogListView {
                            anchors.fill: parent
                            model: folderModel
                            showThumbnails: root.showThumbnails
                            colors: root.colors
                            selectMode: root.mode
                            selectedSet: root._selectedSet
                            onFileClicked: function (u, d, n) {
                                root._handleClick(u, d, n);
                            }
                            onFileDoubleClicked: function (u, d) {
                                root._handleDoubleClick(u, d);
                            }
                            onContextMenuRequested: function (u, n, d, mx, my, a) {
                                root._showCtxAt(u, n, d, mx, my, a);
                            }
                        }
                    }

                    Component {
                        id: treeComp
                        FileDialogTreeView {
                            anchors.fill: parent
                            model: folderModel
                            colors: root.colors
                            onFileClicked: function (u, d, n) {
                                root._handleClick(u, d, n);
                            }
                            onFileDoubleClicked: function (u, d) {
                                root._handleDoubleClick(u, d);
                            }
                            onContextMenuRequested: function (u, n, d, mx, my, a) {
                                root._showCtxAt(u, n, d, mx, my, a);
                            }
                            onNavigateTo: function (u) {
                                root._navigateTo(u);
                            }
                        }
                    }

                    Loader {
                        id: viewLoader
                        anchors.top: colHeaders.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.margins: root.viewMode === "grid" ? 12 : 8
                        sourceComponent: root.viewMode === "grid" ? gridComp : root.viewMode === "list" ? listComp : treeComp
                    }

                    // Empty state
                    Column {
                        anchors.centerIn: parent
                        spacing: 12
                        visible: folderModel.count === 0 && !folderModel.loading
                        Icon {
                            source: "folder_off"
                            size: 64
                            color: colors.onSurfaceVariant
                            opacity: 0.5
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Text {
                            text: root._searchQuery.length > 0 ? "No results for \"" + root._searchQuery + "\"" : "This folder is empty"
                            font.family: _t.bodyLarge.family
                            font.pixelSize: _t.bodyLarge.size
                            color: colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    // Search result count
                    Rectangle {
                        visible: root._searchQuery.length > 0 && folderModel.count > 0
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        anchors.margins: 16
                        width: srText.implicitWidth + 16
                        height: 24
                        radius: 12
                        color: colors.secondaryContainer
                        Text {
                            id: srText
                            anchors.centerIn: parent
                            text: folderModel.count + " result" + (folderModel.count !== 1 ? "s" : "")
                            font.family: _t.labelSmall.family
                            font.pixelSize: _t.labelSmall.size
                            color: colors.onSecondaryContainer
                        }
                    }

                    // Background context menu
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.RightButton
                        z: -1
                        onClicked: function (m) {
                            bgCtxMenu.popup(m.x, m.y);
                        }
                    }
                }
            }
        }

        // ── FOOTER ──────────────────────────────────────────

        Rectangle {
            id: footer
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            color: colors.surfaceContainer
            implicitHeight: footerCol.implicitHeight + 32

            ColumnLayout {
                id: footerCol
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                anchors.topMargin: 16
                anchors.bottomMargin: 16
                spacing: 12
                RowLayout {
                    visible: root.mode === "save"
                    Layout.fillWidth: true
                    spacing: 12
                    Text {
                        text: "Save as:"
                        font.family: _t.labelLarge.family
                        font.pixelSize: _t.labelLarge.size
                        font.weight: Font.Medium
                        color: colors.onSurfaceVariant
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        height: 40
                        radius: 20
                        color: colors.surfaceContainerHighest
                        TextInput {
                            id: fileNameInput
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            verticalAlignment: Text.AlignVCenter
                            font.family: _t.bodyMedium.family
                            font.pixelSize: _t.bodyMedium.size
                            color: colors.onSurface
                            selectionColor: colors.primaryContainer
                            selectedTextColor: colors.onPrimaryContainer
                            selectByMouse: true
                            text: root.fileName
                            onTextChanged: root.fileName = text
                            onAccepted: if (_canAccept())
                                _accept()
                            Text {
                                visible: !fileNameInput.text
                                text: "Enter file name"
                                font: fileNameInput.font
                                color: colors.onSurfaceVariant
                            }
                        }
                    }
                }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    Rectangle {
                        visible: root.nameFilters.length > 0 && root.mode !== "folder"
                        width: 200
                        height: 36
                        radius: 18
                        color: colors.surfaceContainerHighest
                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            anchors.rightMargin: 10
                            Text {
                                width: parent.width - 28
                                anchors.verticalCenter: parent.verticalCenter
                                text: root.nameFilters[root.currentFilter] || "All Files"
                                font.family: _t.bodySmall.family
                                font.pixelSize: _t.bodySmall.size
                                color: colors.onSurface
                                elide: Text.ElideRight
                            }
                            Icon {
                                anchors.verticalCenter: parent.verticalCenter
                                source: "expand_more"
                                size: 18
                                color: colors.onSurfaceVariant
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: filterPopup.open()
                        }
                    }
                    Text {
                        Layout.fillWidth: true
                        text: root.mode === "openMultiple" && root.selectedFiles.length > 0 ? root.selectedFiles.length + " selected" : root.selectedFile.toString() !== "" ? root.selectedFile.toString().split("/").pop() : ""
                        font.family: _t.bodySmall.family
                        font.pixelSize: _t.bodySmall.size
                        color: colors.onSurfaceVariant
                        elide: Text.ElideMiddle
                    }
                    Buttons.Button {
                        text: "Cancel"
                        variant: "outlined"
                        onClicked: {
                            root.rejected();
                            root.close();
                        }
                    }
                    Buttons.Button {
                        text: root.mode === "save" ? "Save" : root.mode === "folder" ? "Select" : "Open"
                        variant: "filled"
                        enabled: _canAccept()
                        onClicked: if (_canAccept())
                            _accept()
                    }
                }
            }
        }
    }

    // ── Window chrome ───────────────────────────────────────

    Rectangle {
        anchors.fill: parent
        radius: windowRadius
        color: "transparent"
        border.width: 1
        border.color: Qt.rgba(colors.shadow.r, colors.shadow.g, colors.shadow.b, 0.15)
        visible: !root.isMaximized
        z: 1000
    }

    Loader {
        active: !root.isMaximized
        anchors.fill: parent
        z: 1010
        sourceComponent: Item {
            property int edge: 6
            property int corner: 16
            MouseArea {
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                height: edge
                cursorShape: Qt.SizeVerCursor
                onPressed: root.startSystemResize(Qt.TopEdge)
            }
            MouseArea {
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
                height: edge
                cursorShape: Qt.SizeVerCursor
                onPressed: root.startSystemResize(Qt.BottomEdge)
            }
            MouseArea {
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }
                width: edge
                cursorShape: Qt.SizeHorCursor
                onPressed: root.startSystemResize(Qt.LeftEdge)
            }
            MouseArea {
                anchors {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }
                width: edge
                cursorShape: Qt.SizeHorCursor
                onPressed: root.startSystemResize(Qt.RightEdge)
            }
            MouseArea {
                anchors {
                    top: parent.top
                    left: parent.left
                }
                width: corner
                height: corner
                cursorShape: Qt.SizeFDiagCursor
                onPressed: root.startSystemResize(Qt.TopEdge | Qt.LeftEdge)
            }
            MouseArea {
                anchors {
                    top: parent.top
                    right: parent.right
                }
                width: corner
                height: corner
                cursorShape: Qt.SizeBDiagCursor
                onPressed: root.startSystemResize(Qt.TopEdge | Qt.RightEdge)
            }
            MouseArea {
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                }
                width: corner
                height: corner
                cursorShape: Qt.SizeBDiagCursor
                onPressed: root.startSystemResize(Qt.BottomEdge | Qt.LeftEdge)
            }
            MouseArea {
                anchors {
                    bottom: parent.bottom
                    right: parent.right
                }
                width: corner
                height: corner
                cursorShape: Qt.SizeFDiagCursor
                onPressed: root.startSystemResize(Qt.BottomEdge | Qt.RightEdge)
            }
        }
    }

    // ── Inline components ───────────────────────────────────

    component HeaderCell: Item {
        property string text
        property string sortKey
        height: 36
        Row {
            anchors.fill: parent
            anchors.leftMargin: 8
            spacing: 4
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: parent.parent.text
                font.family: _t.labelSmall.family
                font.pixelSize: _t.labelSmall.size
                font.weight: Font.Bold
                color: colors.onSurfaceVariant
            }
            Icon {
                anchors.verticalCenter: parent.verticalCenter
                visible: root.sortBy === sortKey
                source: root.sortAscending ? "expand_less" : "expand_more"
                size: 14
                color: colors.primary
            }
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (root.sortBy === sortKey)
                    root.sortAscending = !root.sortAscending;
                else {
                    root.sortBy = sortKey;
                    root.sortAscending = true;
                }
            }
        }
    }

    // ── Context menus ───────────────────────────────────────

    QtObject {
        id: ctxState
        property url file: ""
        property string name: ""
        property bool isDir: false
    }

    Menus.ContextMenu {
        id: fileCtxMenu
        Menus.MenuItem {
            text: ctxState.isDir ? "Open Folder" : "Open"
            leadingIcon: ctxState.isDir ? "folder_open" : "open_in_new"
            onClicked: ctxState.isDir ? _navigateTo(ctxState.file) : (function () {
                    root.selectedFile = ctxState.file;
                    _accept();
                })()
        }
        Menus.MenuDivider {}
        Menus.MenuItem {
            text: "New Folder"
            leadingIcon: "create_new_folder"
            onClicked: newFolderPopup.open()
        }
        Menus.MenuDivider {}
        Menus.MenuItem {
            visible: root.mode === "openMultiple" && !ctxState.isDir
            text: _isInMultiSelection(ctxState.file) ? "Deselect" : "Select"
            leadingIcon: _isInMultiSelection(ctxState.file) ? "deselect" : "check_circle"
            onClicked: _handleClick(ctxState.file, false, ctxState.name)
        }
        Menus.MenuItem {
            visible: root.mode === "openMultiple"
            text: "Select All"
            leadingIcon: "select_all"
            onClicked: _selectAll()
        }
        Menus.MenuItem {
            visible: root.mode === "openMultiple" && root.selectedFiles.length > 0
            text: "Deselect All"
            leadingIcon: "deselect"
            onClicked: {
                root.selectedFiles = [];
                root._selectedSet = ({});
            }
        }
        Menus.MenuDivider {}
        Menus.MenuItem {
            text: "Copy Name"
            leadingIcon: "badge"
            onClicked: _copyToClipboard(ctxState.name)
        }
        Menus.MenuItem {
            text: "Copy Path"
            leadingIcon: "content_copy"
            onClicked: _copyToClipboard(ctxState.file.toString().replace("file://", ""))
        }
    }

    Menus.ContextMenu {
        id: bgCtxMenu
        Menus.MenuItem {
            text: "New Folder"
            leadingIcon: "create_new_folder"
            onClicked: newFolderPopup.open()
        }
        Menus.MenuDivider {}
        Menus.MenuItem {
            visible: root.mode === "openMultiple"
            text: "Select All"
            leadingIcon: "select_all"
            onClicked: _selectAll()
        }
        Menus.MenuItem {
            visible: root.mode === "openMultiple" && root.selectedFiles.length > 0
            text: "Deselect All (" + root.selectedFiles.length + ")"
            leadingIcon: "deselect"
            onClicked: {
                root.selectedFiles = [];
                root._selectedSet = ({});
            }
        }
        Menus.MenuDivider {
            visible: root.mode === "openMultiple"
        }
        Menus.MenuItem {
            text: root.showHidden ? "Hide Hidden Files" : "Show Hidden Files"
            leadingIcon: root.showHidden ? "visibility_off" : "visibility"
            onClicked: root.showHidden = !root.showHidden
        }
        Menus.MenuDivider {}
        Menus.MenuItem {
            text: "Sort by Name"
            leadingIcon: root.sortBy === "name" ? "check" : ""
            onClicked: root.sortBy = "name"
        }
        Menus.MenuItem {
            text: "Sort by Size"
            leadingIcon: root.sortBy === "size" ? "check" : ""
            onClicked: root.sortBy = "size"
        }
        Menus.MenuItem {
            text: "Sort by Date"
            leadingIcon: root.sortBy === "date" ? "check" : ""
            onClicked: root.sortBy = "date"
        }
        Menus.MenuItem {
            text: "Sort by Type"
            leadingIcon: root.sortBy === "type" ? "check" : ""
            onClicked: root.sortBy = "type"
        }
        Menus.MenuDivider {}
        Menus.MenuItem {
            text: root.sortAscending ? "Sort Descending" : "Sort Ascending"
            leadingIcon: root.sortAscending ? "arrow_downward" : "arrow_upward"
            onClicked: root.sortAscending = !root.sortAscending
        }
        Menus.MenuDivider {}
        Menus.MenuItem {
            text: "Refresh"
            leadingIcon: "refresh"
            onClicked: folderModel.refresh()
        }
    }

    TextInput {
        id: clipHelper
        visible: false
    }

    // ── Popups ──────────────────────────────────────────────

    Popup {
        id: filterPopup
        y: footer.y - height - 4
        x: 16
        width: 200
        padding: 6
        background: Rectangle {
            color: colors.surfaceContainerHigh
            radius: 12
            border.width: 1
            border.color: colors.outlineVariant
        }
        contentItem: Column {
            spacing: 2
            Repeater {
                model: root.nameFilters
                Rectangle {
                    width: 188
                    height: 36
                    radius: 8
                    color: fM.containsMouse ? colors.surfaceContainerHighest : "transparent"
                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData
                        font.family: _t.bodyMedium.family
                        font.pixelSize: _t.bodyMedium.size
                        color: colors.onSurface
                    }
                    MouseArea {
                        id: fM
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.currentFilter = index;
                            filterPopup.close();
                        }
                    }
                }
            }
        }
    }

    Popup {
        id: newFolderPopup
        anchors.centerIn: parent
        width: 340
        modal: true
        padding: 20
        background: Rectangle {
            color: colors.surfaceContainerHigh
            radius: 16
        }
        onOpened: {
            nfInput.text = "";
            nfInput.forceActiveFocus();
        }
        contentItem: Column {
            spacing: 12
            Text {
                text: "New Folder"
                font.family: _t.titleMedium.family
                font.pixelSize: _t.titleMedium.size
                font.weight: Font.Medium
                color: colors.onSurface
            }
            Rectangle {
                width: parent.width
                height: 44
                radius: 22
                color: colors.surfaceContainerHighest
                border.width: nfInput.text.trim() !== "" && root._newFolderExists ? 2 : 0
                border.color: colors.error
                TextInput {
                    id: nfInput
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    verticalAlignment: Text.AlignVCenter
                    font.family: _t.bodyMedium.family
                    font.pixelSize: _t.bodyMedium.size
                    color: colors.onSurface
                    selectionColor: colors.primaryContainer
                    selectedTextColor: colors.onPrimaryContainer
                    selectByMouse: true
                    onAccepted: if (text.trim() && !root._newFolderExists) {
                        folderModel.createFolder(text.trim());
                        text = "";
                        newFolderPopup.close();
                    }
                    Text {
                        visible: !nfInput.text
                        text: "Folder name"
                        font: nfInput.font
                        color: colors.onSurfaceVariant
                    }
                }
            }
            Row {
                visible: nfInput.text.trim() !== "" && root._newFolderExists
                spacing: 6
                width: parent.width
                Icon {
                    source: "error"
                    size: 16
                    color: colors.error
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    text: "Folder already exists"
                    font.family: _t.bodySmall.family
                    font.pixelSize: _t.bodySmall.size
                    color: colors.error
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            Row {
                anchors.right: parent.right
                spacing: 8
                Buttons.Button {
                    text: "Cancel"
                    variant: "outlined"
                    onClicked: newFolderPopup.close()
                }
                Buttons.Button {
                    text: "Create"
                    variant: "filled"
                    enabled: nfInput.text.trim() !== "" && !root._newFolderExists
                    onClicked: if (nfInput.text.trim() && !root._newFolderExists) {
                        folderModel.createFolder(nfInput.text.trim());
                        nfInput.text = "";
                        newFolderPopup.close();
                    }
                }
            }
        }
    }

    Popup {
        id: overwritePopup
        anchors.centerIn: parent
        width: 360
        modal: true
        padding: 24
        background: Rectangle {
            color: colors.surfaceContainerHigh
            radius: 16
        }
        contentItem: Column {
            spacing: 16
            Text {
                text: "File Already Exists"
                font.family: _t.titleMedium.family
                font.pixelSize: _t.titleMedium.size
                font.weight: Font.Medium
                color: colors.onSurface
            }
            Text {
                width: parent.width
                wrapMode: Text.WordWrap
                text: "\"" + root.fileName + "\" already exists. Replace it?"
                font.family: _t.bodyMedium.family
                font.pixelSize: _t.bodyMedium.size
                color: colors.onSurfaceVariant
            }
            Row {
                anchors.right: parent.right
                spacing: 8
                Buttons.Button {
                    text: "Cancel"
                    variant: "outlined"
                    onClicked: overwritePopup.close()
                }
                Buttons.Button {
                    text: "Replace"
                    variant: "filled"
                    onClicked: {
                        overwritePopup.close();
                        _forceAccept();
                    }
                }
            }
        }
    }

    // ── Functions ───────────────────────────────────────────

    function _getDisplayPath(url) {
        return url.toString().replace("file://", "") || "/";
    }

    function _navigateTo(url) {
        if (_historyIndex < _navigationHistory.length - 1)
            _navigationHistory = _navigationHistory.slice(0, _historyIndex + 1);
        _navigationHistory.push(url);
        _historyIndex = _navigationHistory.length - 1;
        currentFolder = url;
        selectedFile = "";
        selectedFiles = [];
        _selectedSet = ({});
        _typeAheadBuffer = "";
        Qt.callLater(function () {
            windowSurface.forceActiveFocus();
        });
    }

    function _goBack() {
        if (_historyIndex > 0) {
            _historyIndex--;
            currentFolder = _navigationHistory[_historyIndex];
            Qt.callLater(function () {
                windowSurface.forceActiveFocus();
            });
        }
    }
    function _goForward() {
        if (_historyIndex < _navigationHistory.length - 1) {
            _historyIndex++;
            currentFolder = _navigationHistory[_historyIndex];
            Qt.callLater(function () {
                windowSurface.forceActiveFocus();
            });
        }
    }
    function _goUp() {
        var p = currentFolder.toString(), l = p.lastIndexOf("/");
        _navigateTo(l > 7 ? p.substring(0, l) : "file:///");
    }

    function _handleClick(url, isDir, name) {
        selectedFile = url;
        if (mode === "openMultiple" && !isDir) {
            var s = Object.assign({}, _selectedSet);
            var key = url.toString();
            if (s[key])
                delete s[key];
            else
                s[key] = true;
            _selectedSet = s;
            selectedFiles = Object.keys(s);
        } else if (mode === "save" && !isDir) {
            fileName = name;
        }
    }

    function _handleDoubleClick(url, isDir) {
        if (isDir)
            _navigateTo(url);
        else if (mode !== "folder") {
            selectedFile = url;
            _accept();
        }
    }

    function _isSelected(url) {
        var u = url.toString();
        if (selectedFile.toString() === u)
            return true;
        if (mode === "openMultiple")
            return _selectedSet[u] === true;
        return false;
    }

    function _isInMultiSelection(url) {
        return _selectedSet[url.toString()] === true;
    }

    function _selectAll() {
        var s = {};
        var arr = [];
        for (var i = 0; i < folderModel.count; i++) {
            if (!folderModel.get(i, "fileIsDir")) {
                var u = folderModel.get(i, "fileUrl").toString();
                s[u] = true;
                arr.push(u);
            }
        }
        _selectedSet = s;
        selectedFiles = arr;
    }

    function _canAccept() {
        if (mode === "save")
            return fileName.trim() !== "";
        if (mode === "openMultiple")
            return selectedFiles.length > 0;
        if (mode === "folder")
            return true;
        return selectedFile.toString() !== "";
    }

    function _accept() {
        if (mode === "save") {
            var p = currentFolder.toString();
            var target = (p.endsWith("/") ? p : p + "/") + fileName;
            if (folderModel.fileExists(target)) {
                overwritePopup.open();
                return;
            }
            selectedFile = target;
        }
        if (mode === "folder" && selectedFile.toString() === "")
            selectedFile = currentFolder;
        accepted();
        close();
    }

    function _forceAccept() {
        if (mode === "save") {
            var p = currentFolder.toString();
            selectedFile = (p.endsWith("/") ? p : p + "/") + fileName;
        }
        if (mode === "folder" && selectedFile.toString() === "")
            selectedFile = currentFolder;
        accepted();
        close();
    }

    function _copyToClipboard(text) {
        clipHelper.text = text;
        clipHelper.selectAll();
        clipHelper.copy();
    }

    function _showCtxAt(url, name, isDir, mx, my, area) {
        ctxState.file = url;
        ctxState.name = name;
        ctxState.isDir = isDir;
        var p = area.mapToItem(windowSurface, mx, my);
        fileCtxMenu.menuX = p.x;
        fileCtxMenu.menuY = p.y;
        Menus.MenuManager.closeAllExcept(fileCtxMenu);
        if (fileCtxMenu.open) {
            fileCtxMenu.open = false;
            Qt.callLater(function () {
                fileCtxMenu.open = true;
            });
        } else
            fileCtxMenu.open = true;
    }

    function open() {
        visible = true;
        raise();
        requestActivate();
        Qt.callLater(function () {
            windowSurface.forceActiveFocus();
        });
    }

    onVisibleChanged: {
        if (!visible) {
            _searchQuery = "";
            _selectedSet = ({});
            selectedFiles = [];
            selectedFile = "";
            fileName = "";
            _navigationHistory = [currentFolder];
            _historyIndex = 0;
            _typeAheadBuffer = "";
        }
    }

    Component.onCompleted: {
        _navigationHistory = [currentFolder];
        _historyIndex = 0;
    }
}
