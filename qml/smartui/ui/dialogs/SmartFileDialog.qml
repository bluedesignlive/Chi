import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Qt5Compat.GraphicalEffects
import QtCore
import "../../theme" as Theme
import "../common"

Popup {
    id: root

    // ═══════════════════════════════════════════════════════════════
    // PUBLIC API
    // ═══════════════════════════════════════════════════════════════

    property string mode: "open"  // open | openMultiple | save | folder
    property string title: {
        if (mode === "save") return "Save File"
        if (mode === "folder") return "Select Folder"
        if (mode === "openMultiple") return "Select Files"
        return "Open File"
    }

    property url currentFolder: _homePath
    property url selectedFile: ""
    property var selectedFiles: []
    property string fileName: ""
    property var nameFilters: []
    property int currentFilter: 0
    property bool showHidden: false

    // ═══════════════════════════════════════════════════════════════
    // SIGNALS
    // ═══════════════════════════════════════════════════════════════

    signal accepted()
    signal rejected()

    // ═══════════════════════════════════════════════════════════════
    // INTERNAL
    // ═══════════════════════════════════════════════════════════════

    property var colors: Theme.ChiTheme.colors
    
    // Use StandardPaths from QtCore
    readonly property url _homePath: StandardPaths.writableLocation(StandardPaths.HomeLocation)
    readonly property url _documentsPath: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
    readonly property url _downloadsPath: StandardPaths.writableLocation(StandardPaths.DownloadLocation)
    readonly property url _picturesPath: StandardPaths.writableLocation(StandardPaths.PicturesLocation)
    readonly property url _musicPath: StandardPaths.writableLocation(StandardPaths.MusicLocation)
    readonly property url _moviesPath: StandardPaths.writableLocation(StandardPaths.MoviesLocation)
    readonly property url _desktopPath: StandardPaths.writableLocation(StandardPaths.DesktopLocation)

    property var _selectedIndexes: []
    property var _navigationHistory: []
    property int _historyIndex: -1

    modal: true
    anchors.centerIn: parent
    width: Math.min(900, parent.width - 48)
    height: Math.min(600, parent.height - 48)
    padding: 0
    closePolicy: Popup.CloseOnEscape

    background: Rectangle {
        color: colors.surface
        radius: 20

        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 16
            radius: 48
            samples: 97
            color: Qt.rgba(0, 0, 0, 0.3)
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // QUICK ACCESS LOCATIONS
    // ═══════════════════════════════════════════════════════════════

    readonly property var _quickAccess: [
        { name: "Home", icon: "home", path: _homePath },
        { name: "Documents", icon: "description", path: _documentsPath },
        { name: "Downloads", icon: "download", path: _downloadsPath },
        { name: "Pictures", icon: "image", path: _picturesPath },
        { name: "Music", icon: "music_note", path: _musicPath },
        { name: "Videos", icon: "movie", path: _moviesPath },
        { name: "Desktop", icon: "desktop_windows", path: _desktopPath }
    ]

    contentItem: Item {
        // ═══════════════════════════════════════════════════════════
        // HEADER
        // ═══════════════════════════════════════════════════════════

        Rectangle {
            id: header
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 56
            color: colors.surfaceContainer
            radius: 20

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 20
                color: parent.color
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                spacing: 12

                // Traffic Light Close Button
                TrafficLightButton {
                    baseColor: "#FF5F57"
                    icon: "close"
                    onClicked: {
                        root.rejected()
                        root.close()
                    }
                }

                Item { width: 8 }

                // Navigation buttons
                NavButton {
                    icon: "arrow_back"
                    enabled: root._historyIndex > 0
                    onClicked: _goBack()
                }

                NavButton {
                    icon: "arrow_forward"
                    enabled: root._historyIndex < root._navigationHistory.length - 1
                    onClicked: _goForward()
                }

                NavButton {
                    icon: "arrow_upward"
                    enabled: root.currentFolder.toString() !== "file:///"
                    onClicked: _goUp()
                }

                // Path bar
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 36
                    radius: 10
                    color: colors.surfaceContainerHighest

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        spacing: 4

                        Icon {
                            source: "folder"
                            size: 18
                            color: colors.onSurfaceVariant
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: _getDisplayPath(root.currentFolder)
                            font.family: "Roboto"
                            font.pixelSize: 13
                            color: colors.onSurface
                            elide: Text.ElideMiddle
                            width: parent.width - 30
                        }
                    }
                }

                // View toggle
                NavButton {
                    icon: gridView.visible ? "view_list" : "grid_view"
                    onClicked: gridView.visible = !gridView.visible
                }

                // Hidden files toggle
                NavButton {
                    icon: root.showHidden ? "visibility" : "visibility_off"
                    checked: root.showHidden
                    onClicked: root.showHidden = !root.showHidden
                }

                // New folder
                NavButton {
                    icon: "create_new_folder"
                    visible: root.mode === "save" || root.mode === "folder"
                    onClicked: newFolderDialog.open()
                }
            }
        }

        // ═══════════════════════════════════════════════════════════
        // MAIN CONTENT
        // ═══════════════════════════════════════════════════════════

        Row {
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: footer.top

            // ─────────────────────────────────────────────────────
            // SIDEBAR
            // ─────────────────────────────────────────────────────

            Rectangle {
                id: sidebar
                width: 180
                height: parent.height
                color: colors.surfaceContainer

                Column {
                    anchors.fill: parent
                    anchors.topMargin: 12
                    spacing: 4

                    Text {
                        text: "Quick Access"
                        font.family: "Roboto"
                        font.pixelSize: 11
                        font.weight: Font.Bold
                        color: colors.onSurfaceVariant
                        leftPadding: 16
                        bottomPadding: 8
                    }

                    Repeater {
                        model: root._quickAccess

                        delegate: SidebarItem {
                            width: sidebar.width - 16
                            x: 8
                            itemText: modelData.name
                            itemIcon: modelData.icon
                            selected: root.currentFolder.toString() === modelData.path.toString()
                            onClicked: _navigateTo(modelData.path)
                        }
                    }
                }
            }

            // Separator
            Rectangle {
                width: 1
                height: parent.height
                color: colors.outlineVariant
            }

            // ─────────────────────────────────────────────────────
            // FILE LIST
            // ─────────────────────────────────────────────────────

            Item {
                width: parent.width - sidebar.width - 1
                height: parent.height

                FolderListModel {
                    id: folderModel
                    folder: root.currentFolder
                    showDirs: true
                    showFiles: root.mode !== "folder"
                    showHidden: root.showHidden
                    showDirsFirst: true
                    sortField: FolderListModel.Name
                    nameFilters: _getActiveFilters()
                }

                // Grid View
                GridView {
                    id: gridView
                    anchors.fill: parent
                    anchors.margins: 12
                    visible: true
                    cellWidth: 100
                    cellHeight: 100
                    clip: true
                    model: folderModel

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                    }

                    delegate: FileGridItem {
                        width: gridView.cellWidth - 8
                        height: gridView.cellHeight - 8
                        itemFileName: model.fileName
                        isFolder: model.fileIsDir
                        filePath: model.fileUrl
                        isSelected: _isSelected(model.fileUrl)

                        onClicked: _handleItemClick(model.fileUrl, model.fileIsDir, model.fileName)
                        onDoubleClicked: _handleItemDoubleClick(model.fileUrl, model.fileIsDir)
                    }
                }

                // List View
                ListView {
                    id: listView
                    anchors.fill: parent
                    anchors.margins: 8
                    visible: !gridView.visible
                    clip: true
                    model: folderModel
                    spacing: 2

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                    }

                    delegate: FileListItem {
                        width: listView.width
                        itemFileName: model.fileName
                        fileSize: model.fileSize
                        fileModified: model.fileModified
                        isFolder: model.fileIsDir
                        filePath: model.fileUrl
                        isSelected: _isSelected(model.fileUrl)

                        onClicked: _handleItemClick(model.fileUrl, model.fileIsDir, model.fileName)
                        onDoubleClicked: _handleItemDoubleClick(model.fileUrl, model.fileIsDir)
                    }
                }

                // Empty state
                Column {
                    anchors.centerIn: parent
                    spacing: 12
                    visible: folderModel.count === 0

                    Icon {
                        source: "folder_off"
                        size: 48
                        color: colors.onSurfaceVariant
                        opacity: 0.5
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: "This folder is empty"
                        font.family: "Roboto"
                        font.pixelSize: 14
                        color: colors.onSurfaceVariant
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }

        // ═══════════════════════════════════════════════════════════
        // FOOTER
        // ═══════════════════════════════════════════════════════════

        Rectangle {
            id: footer
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: root.mode === "save" ? 110 : 64
            color: colors.surfaceContainer
            radius: 20

            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 20
                color: parent.color
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                // File name input (save mode)
                RowLayout {
                    visible: root.mode === "save"
                    Layout.fillWidth: true
                    spacing: 12

                    Text {
                        text: "File name:"
                        font.family: "Roboto"
                        font.pixelSize: 13
                        color: colors.onSurfaceVariant
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 40
                        radius: 10
                        color: colors.surfaceContainerHighest

                        TextInput {
                            id: fileNameInput
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            verticalAlignment: Text.AlignVCenter
                            font.family: "Roboto"
                            font.pixelSize: 14
                            color: colors.onSurface
                            selectByMouse: true
                            text: root.fileName

                            onTextChanged: root.fileName = text
                        }
                    }
                }

                // Filter + Buttons
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    // File filter dropdown
                    Rectangle {
                        visible: root.nameFilters.length > 0 && root.mode !== "folder"
                        width: 200
                        height: 36
                        radius: 8
                        color: colors.surfaceContainerHighest

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 8
                            spacing: 8

                            Text {
                                width: parent.width - 30
                                anchors.verticalCenter: parent.verticalCenter
                                text: root.nameFilters[root.currentFilter] || "All Files"
                                font.family: "Roboto"
                                font.pixelSize: 12
                                color: colors.onSurface
                                elide: Text.ElideRight
                            }

                            Icon {
                                source: "expand_more"
                                size: 18
                                color: colors.onSurfaceVariant
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: filterMenu.open()
                        }

                        Popup {
                            id: filterMenu
                            y: -height - 4
                            width: parent.width
                            padding: 4

                            background: Rectangle {
                                color: colors.surfaceContainerHigh
                                radius: 8
                                border.width: 1
                                border.color: colors.outlineVariant
                            }

                            contentItem: Column {
                                spacing: 2

                                Repeater {
                                    model: root.nameFilters

                                    delegate: Rectangle {
                                        width: 192
                                        height: 32
                                        radius: 6
                                        color: filterItemMouse.containsMouse ? Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.08) : "transparent"

                                        Text {
                                            anchors.left: parent.left
                                            anchors.leftMargin: 8
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: modelData
                                            font.family: "Roboto"
                                            font.pixelSize: 12
                                            color: colors.onSurface
                                        }

                                        MouseArea {
                                            id: filterItemMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                root.currentFilter = index
                                                filterMenu.close()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Item { Layout.fillWidth: true }

                    // Cancel button
                    FooterButton {
                        buttonText: "Cancel"
                        onClicked: {
                            root.rejected()
                            root.close()
                        }
                    }

                    // Accept button
                    FooterButton {
                        buttonText: root.mode === "save" ? "Save" : root.mode === "folder" ? "Select" : "Open"
                        primary: true
                        enabled: _canAccept()
                        onClicked: _accept()
                    }
                }
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // NEW FOLDER DIALOG
    // ═══════════════════════════════════════════════════════════════

    Popup {
        id: newFolderDialog
        anchors.centerIn: parent
        width: 320
        height: 160
        modal: true
        padding: 20

        background: Rectangle {
            color: colors.surfaceContainerHigh
            radius: 16
        }

        contentItem: ColumnLayout {
            spacing: 16

            Text {
                text: "New Folder"
                font.family: "Roboto"
                font.pixelSize: 18
                font.weight: Font.Medium
                color: colors.onSurface
            }

            Rectangle {
                Layout.fillWidth: true
                height: 44
                radius: 10
                color: colors.surfaceContainerHighest

                TextInput {
                    id: newFolderInput
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: colors.onSurface
                    selectByMouse: true
                    
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Folder name"
                        font.family: "Roboto"
                        font.pixelSize: 14
                        color: colors.onSurfaceVariant
                        visible: !parent.text && !parent.activeFocus
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Item { Layout.fillWidth: true }

                FooterButton {
                    buttonText: "Cancel"
                    onClicked: newFolderDialog.close()
                }

                FooterButton {
                    buttonText: "Create"
                    primary: true
                    enabled: newFolderInput.text.trim() !== ""
                    onClicked: {
                        _createFolder(newFolderInput.text.trim())
                        newFolderInput.text = ""
                        newFolderDialog.close()
                    }
                }
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // COMPONENTS
    // ═══════════════════════════════════════════════════════════════

    component TrafficLightButton: Item {
        property color baseColor: "#888"
        property string icon: ""
        signal clicked()

        width: 14
        height: 14

        Rectangle {
            anchors.fill: parent
            radius: 7
            color: tlMouse.pressed ? Qt.darker(baseColor, 1.2) :
                   tlMouse.containsMouse ? Qt.lighter(baseColor, 1.1) : baseColor
            border.width: 0.5
            border.color: Qt.darker(baseColor, 1.3)

            Icon {
                anchors.centerIn: parent
                source: parent.parent.icon
                size: 8
                color: Qt.rgba(0, 0, 0, 0.6)
                visible: tlMouse.containsMouse
            }
        }

        MouseArea {
            id: tlMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: parent.clicked()
        }
    }

    component NavButton: Item {
        property string icon: ""
        property bool checked: false
        signal clicked()

        width: 32
        height: 32
        opacity: enabled ? 1.0 : 0.38

        Rectangle {
            anchors.fill: parent
            radius: 8
            color: {
                if (checked) return colors.secondaryContainer
                if (navMouse.pressed) return Qt.rgba(colors.primary.r, colors.primary.g, colors.primary.b, 0.15)
                if (navMouse.containsMouse) return Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.08)
                return "transparent"
            }
        }

        Icon {
            anchors.centerIn: parent
            source: parent.icon
            size: 18
            color: checked ? colors.onSecondaryContainer : colors.onSurfaceVariant
        }

        MouseArea {
            id: navMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: if (enabled) parent.clicked()
        }
    }

    component SidebarItem: Item {
        property string itemText: ""
        property string itemIcon: ""
        property bool selected: false
        signal clicked()

        height: 36

        Rectangle {
            anchors.fill: parent
            radius: 10
            color: {
                if (selected) return colors.secondaryContainer
                if (sidebarMouse.containsMouse) return Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.08)
                return "transparent"
            }
        }

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Icon {
                source: itemIcon
                size: 18
                color: selected ? colors.onSecondaryContainer : colors.onSurfaceVariant
            }

            Text {
                text: itemText
                font.family: "Roboto"
                font.pixelSize: 13
                color: selected ? colors.onSecondaryContainer : colors.onSurface
            }
        }

        MouseArea {
            id: sidebarMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: parent.clicked()
        }
    }

    component FileGridItem: Item {
        property string itemFileName: ""
        property bool isFolder: false
        property url filePath: ""
        property bool isSelected: false
        signal clicked()
        signal doubleClicked()

        Rectangle {
            anchors.fill: parent
            anchors.margins: 4
            radius: 12
            color: {
                if (isSelected) return colors.primaryContainer
                if (gridItemMouse.containsMouse) return Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.08)
                return "transparent"
            }

            Column {
                anchors.centerIn: parent
                spacing: 6

                Icon {
                    source: isFolder ? "folder" : _getFileIcon(itemFileName)
                    size: 36
                    color: isFolder ? colors.primary : colors.onSurfaceVariant
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    width: parent.parent.width - 16
                    text: itemFileName
                    font.family: "Roboto"
                    font.pixelSize: 11
                    color: isSelected ? colors.onPrimaryContainer : colors.onSurface
                    elide: Text.ElideMiddle
                    horizontalAlignment: Text.AlignHCenter
                    maximumLineCount: 2
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }
            }
        }

        MouseArea {
            id: gridItemMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: parent.clicked()
            onDoubleClicked: parent.doubleClicked()
        }
    }

    component FileListItem: Item {
        property string itemFileName: ""
        property var fileSize: 0
        property var fileModified: new Date()
        property bool isFolder: false
        property url filePath: ""
        property bool isSelected: false
        signal clicked()
        signal doubleClicked()

        height: 40

        Rectangle {
            anchors.fill: parent
            anchors.margins: 2
            radius: 10
            color: {
                if (isSelected) return colors.primaryContainer
                if (listItemMouse.containsMouse) return Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.08)
                return "transparent"
            }

            Row {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 12

                Icon {
                    source: isFolder ? "folder" : _getFileIcon(itemFileName)
                    size: 20
                    color: isFolder ? colors.primary : colors.onSurfaceVariant
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    width: parent.width - 200
                    anchors.verticalCenter: parent.verticalCenter
                    text: itemFileName
                    font.family: "Roboto"
                    font.pixelSize: 13
                    color: isSelected ? colors.onPrimaryContainer : colors.onSurface
                    elide: Text.ElideMiddle
                }

                Text {
                    visible: !isFolder
                    anchors.verticalCenter: parent.verticalCenter
                    text: _formatFileSize(fileSize)
                    font.family: "Roboto"
                    font.pixelSize: 12
                    color: colors.onSurfaceVariant
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: Qt.formatDateTime(fileModified, "MMM d, yyyy")
                    font.family: "Roboto"
                    font.pixelSize: 12
                    color: colors.onSurfaceVariant
                }
            }
        }

        MouseArea {
            id: listItemMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: parent.clicked()
            onDoubleClicked: parent.doubleClicked()
        }
    }

    component FooterButton: Item {
        property string buttonText: ""
        property bool primary: false
        signal clicked()

        width: btnLabel.implicitWidth + 32
        height: 36
        opacity: enabled ? 1.0 : 0.5

        Rectangle {
            anchors.fill: parent
            radius: 18
            color: primary ? colors.primary : "transparent"
            border.width: primary ? 0 : 1
            border.color: colors.outline
        }

        Text {
            id: btnLabel
            anchors.centerIn: parent
            text: buttonText
            font.family: "Roboto"
            font.pixelSize: 13
            font.weight: Font.Medium
            color: primary ? colors.onPrimary : colors.onSurface
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: if (enabled) parent.clicked()
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // HELPER FUNCTIONS
    // ═══════════════════════════════════════════════════════════════

    function _getDisplayPath(url) {
        let pathStr = url.toString().replace("file://", "")
        if (pathStr === "") return "/"
        return pathStr
    }

    function _navigateTo(url) {
        if (_historyIndex < _navigationHistory.length - 1) {
            _navigationHistory = _navigationHistory.slice(0, _historyIndex + 1)
        }
        _navigationHistory.push(url)
        _historyIndex = _navigationHistory.length - 1
        currentFolder = url
        _selectedIndexes = []
        selectedFile = ""
        selectedFiles = []
    }

    function _goBack() {
        if (_historyIndex > 0) {
            _historyIndex--
            currentFolder = _navigationHistory[_historyIndex]
            _selectedIndexes = []
        }
    }

    function _goForward() {
        if (_historyIndex < _navigationHistory.length - 1) {
            _historyIndex++
            currentFolder = _navigationHistory[_historyIndex]
            _selectedIndexes = []
        }
    }

    function _goUp() {
        let pathStr = currentFolder.toString()
        let lastSlash = pathStr.lastIndexOf("/")
        if (lastSlash > 7) {
            _navigateTo(pathStr.substring(0, lastSlash))
        } else {
            _navigateTo("file:///")
        }
    }

    function _handleItemClick(url, isDir, name) {
        if (mode === "openMultiple" && !isDir) {
            let idx = selectedFiles.findIndex(f => f.toString() === url.toString())
            if (idx >= 0) {
                selectedFiles.splice(idx, 1)
            } else {
                selectedFiles.push(url)
            }
            selectedFiles = selectedFiles.slice()
        } else if (mode === "folder" && isDir) {
            selectedFile = url
        } else if (!isDir) {
            selectedFile = url
            if (mode === "save") {
                fileName = name
            }
        }
    }

    function _handleItemDoubleClick(url, isDir) {
        if (isDir) {
            _navigateTo(url)
        } else if (mode !== "folder") {
            selectedFile = url
            _accept()
        }
    }

    function _isSelected(url) {
        if (mode === "openMultiple") {
            return selectedFiles.some(f => f.toString() === url.toString())
        }
        return selectedFile.toString() === url.toString()
    }

    function _canAccept() {
        if (mode === "save") {
            return fileName.trim() !== ""
        }
        if (mode === "openMultiple") {
            return selectedFiles.length > 0
        }
        if (mode === "folder") {
            return true
        }
        return selectedFile.toString() !== ""
    }

    function _accept() {
        if (mode === "save") {
            let savePath = currentFolder.toString()
            if (!savePath.endsWith("/")) savePath += "/"
            selectedFile = savePath + fileName
        }
        if (mode === "folder" && selectedFile.toString() === "") {
            selectedFile = currentFolder
        }
        accepted()
        close()
    }

    function _getActiveFilters() {
        if (nameFilters.length === 0) return ["*"]
        let filter = nameFilters[currentFilter] || ""
        let match = filter.match(/\(([^)]+)\)/)
        if (match) {
            return match[1].split(" ")
        }
        return ["*"]
    }

    function _getFileIcon(name) {
        let ext = name.split('.').pop().toLowerCase()
        let imageExts = ["png", "jpg", "jpeg", "gif", "bmp", "svg", "webp"]
        let docExts = ["pdf", "doc", "docx", "txt", "rtf", "odt"]
        let codeExts = ["js", "qml", "cpp", "h", "py", "html", "css", "json"]
        let audioExts = ["mp3", "wav", "flac", "m4a", "ogg"]
        let videoExts = ["mp4", "mkv", "avi", "mov", "webm"]

        if (imageExts.includes(ext)) return "image"
        if (docExts.includes(ext)) return "description"
        if (codeExts.includes(ext)) return "code"
        if (audioExts.includes(ext)) return "music_note"
        if (videoExts.includes(ext)) return "movie"
        return "insert_drive_file"
    }

    function _formatFileSize(bytes) {
        if (bytes < 1024) return bytes + " B"
        if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + " KB"
        if (bytes < 1024 * 1024 * 1024) return (bytes / 1024 / 1024).toFixed(1) + " MB"
        return (bytes / 1024 / 1024 / 1024).toFixed(1) + " GB"
    }

    function _createFolder(name) {
        console.log("Create folder:", currentFolder + "/" + name)
    }

    // Initialize history
    Component.onCompleted: {
        _navigationHistory = [currentFolder]
        _historyIndex = 0
    }
}
