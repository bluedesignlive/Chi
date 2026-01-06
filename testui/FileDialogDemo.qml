import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import SmartUIBeta

SmartApplicationWindow {
    id: window
    width: 1000
    height: 700
    title: "SmartFileDialog Demo"

    // State
    property url selectedFile: ""
    property var selectedFiles: []
    property url selectedFolder: ""
    property url saveLocation: ""

    // Toolbar actions
    toolbarActions: [
        QtObject {
            property string icon: "folder_open"
            function triggered() { openFileDialog.open() }
        },
        QtObject {
            property string icon: "photo_library"
            function triggered() { openMultipleDialog.open() }
        },
        QtObject {
            property string icon: "create_new_folder"
            function triggered() { selectFolderDialog.open() }
        },
        QtObject {
            property string icon: "save"
            function triggered() { saveFileDialog.open() }
        },
        QtObject {
            property string icon: ChiTheme.isDarkMode ? "light_mode" : "dark_mode"
            function triggered() { ChiTheme.isDarkMode = !ChiTheme.isDarkMode }
        }
    ]

    // ═══════════════════════════════════════════════════════════════
    // FILE DIALOGS
    // ═══════════════════════════════════════════════════════════════

    // Open single file
    SmartFileDialog {
        id: openFileDialog
        mode: "open"
        title: "Open File"
        nameFilters: [
            "Images (*.png *.jpg *.jpeg *.gif *.bmp *.svg *.webp)",
            "Documents (*.pdf *.doc *.docx *.txt *.md)",
            "All Files (*)"
        ]

        onAccepted: {
            window.selectedFile = selectedFile
            console.log("Opened:", selectedFile)
        }
    }

    // Open multiple files
    SmartFileDialog {
        id: openMultipleDialog
        mode: "openMultiple"
        title: "Select Multiple Files"
        nameFilters: [
            "Images (*.png *.jpg *.jpeg *.gif *.webp)",
            "All Files (*)"
        ]

        onAccepted: {
            window.selectedFiles = selectedFiles
            console.log("Selected", selectedFiles.length, "files")
        }
    }

    // Select folder
    SmartFileDialog {
        id: selectFolderDialog
        mode: "folder"
        title: "Select Folder"

        onAccepted: {
            window.selectedFolder = selectedFile
            console.log("Folder:", selectedFile)
        }
    }

    // Save file
    SmartFileDialog {
        id: saveFileDialog
        mode: "save"
        title: "Save File"
        fileName: "untitled.txt"
        nameFilters: [
            "Text Files (*.txt)",
            "Markdown (*.md)",
            "All Files (*)"
        ]

        onAccepted: {
            window.saveLocation = selectedFile
            console.log("Save to:", selectedFile)
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // CONTENT
    // ═══════════════════════════════════════════════════════════════

    Rectangle {
        anchors.fill: parent
        color: ChiTheme.colors.surface

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 24

            // Header
            Text {
                text: "SmartFileDialog Demo"
                font.family: "Roboto"
                font.pixelSize: 28
                font.weight: Font.Medium
                color: ChiTheme.colors.onSurface
            }

            Text {
                text: "Click the toolbar icons or buttons below to open different dialog modes"
                font.family: "Roboto"
                font.pixelSize: 14
                color: ChiTheme.colors.onSurfaceVariant
            }

            // Action buttons
            Row {
                spacing: 12

                ActionButton {
                    icon: "folder_open"
                    text: "Open File"
                    onClicked: openFileDialog.open()
                }

                ActionButton {
                    icon: "photo_library"
                    text: "Select Multiple"
                    onClicked: openMultipleDialog.open()
                }

                ActionButton {
                    icon: "create_new_folder"
                    text: "Select Folder"
                    onClicked: selectFolderDialog.open()
                }

                ActionButton {
                    icon: "save"
                    text: "Save File"
                    onClicked: saveFileDialog.open()
                }
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: ChiTheme.colors.outlineVariant
            }

            // Results
            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: 24
                rowSpacing: 16

                // Single file result
                ResultCard {
                    Layout.fillWidth: true
                    title: "Selected File"
                    icon: "insert_drive_file"
                    content: window.selectedFile.toString() ? 
                             window.selectedFile.toString().replace("file://", "") : 
                             "No file selected"
                    hasValue: window.selectedFile.toString() !== ""
                }

                // Save location result
                ResultCard {
                    Layout.fillWidth: true
                    title: "Save Location"
                    icon: "save"
                    content: window.saveLocation.toString() ? 
                             window.saveLocation.toString().replace("file://", "") : 
                             "No save location"
                    hasValue: window.saveLocation.toString() !== ""
                }

                // Selected folder result
                ResultCard {
                    Layout.fillWidth: true
                    title: "Selected Folder"
                    icon: "folder"
                    content: window.selectedFolder.toString() ? 
                             window.selectedFolder.toString().replace("file://", "") : 
                             "No folder selected"
                    hasValue: window.selectedFolder.toString() !== ""
                }

                // Multiple files result
                ResultCard {
                    Layout.fillWidth: true
                    title: "Multiple Files (" + window.selectedFiles.length + ")"
                    icon: "photo_library"
                    content: window.selectedFiles.length > 0 ? 
                             window.selectedFiles.map(f => f.toString().split('/').pop()).join(", ") : 
                             "No files selected"
                    hasValue: window.selectedFiles.length > 0
                }
            }

            // Image preview if image selected
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 16
                color: ChiTheme.colors.surfaceContainerLow
                visible: _isImage(window.selectedFile)

                Image {
                    anchors.fill: parent
                    anchors.margins: 16
                    source: window.selectedFile
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true

                    BusyIndicator {
                        anchors.centerIn: parent
                        running: parent.status === Image.Loading
                    }
                }

                // Clear button
                Rectangle {
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.margins: 8
                    width: 32
                    height: 32
                    radius: 16
                    color: ChiTheme.colors.errorContainer

                    Icon {
                        anchors.centerIn: parent
                        source: "close"
                        size: 16
                        color: ChiTheme.colors.onErrorContainer
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: window.selectedFile = ""
                    }
                }
            }

            // Empty state when no image
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 16
                color: ChiTheme.colors.surfaceContainerLow
                visible: !_isImage(window.selectedFile)

                Column {
                    anchors.centerIn: parent
                    spacing: 12

                    Icon {
                        source: "image"
                        size: 64
                        color: ChiTheme.colors.onSurfaceVariant
                        opacity: 0.3
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: "Select an image to preview"
                        font.family: "Roboto"
                        font.pixelSize: 14
                        color: ChiTheme.colors.onSurfaceVariant
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // COMPONENTS
    // ═══════════════════════════════════════════════════════════════

    component ActionButton: Rectangle {
        property string icon: ""
        property string text: ""
        signal clicked()

        width: row.implicitWidth + 24
        height: 44
        radius: 22
        color: buttonMouse.containsMouse ? 
               Qt.rgba(ChiTheme.colors.primary.r, ChiTheme.colors.primary.g, ChiTheme.colors.primary.b, 0.15) :
               ChiTheme.colors.primaryContainer

        Row {
            id: row
            anchors.centerIn: parent
            spacing: 8

            Icon {
                source: parent.parent.icon
                size: 20
                color: ChiTheme.colors.onPrimaryContainer
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: parent.parent.text
                font.family: "Roboto"
                font.pixelSize: 14
                font.weight: Font.Medium
                color: ChiTheme.colors.onPrimaryContainer
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        MouseArea {
            id: buttonMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: parent.clicked()
        }
    }

    component ResultCard: Rectangle {
        property string title: ""
        property string icon: ""
        property string content: ""
        property bool hasValue: false

        height: 80
        radius: 12
        color: ChiTheme.colors.surfaceContainer

        RowLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 16

            Rectangle {
                width: 48
                height: 48
                radius: 12
                color: hasValue ? ChiTheme.colors.primaryContainer : ChiTheme.colors.surfaceContainerHighest

                Icon {
                    anchors.centerIn: parent
                    source: parent.parent.parent.icon
                    size: 24
                    color: hasValue ? ChiTheme.colors.onPrimaryContainer : ChiTheme.colors.onSurfaceVariant
                }
            }

            Column {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: title
                    font.family: "Roboto"
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    color: ChiTheme.colors.primary
                }

                Text {
                    width: parent.width
                    text: content
                    font.family: "Roboto"
                    font.pixelSize: 13
                    color: hasValue ? ChiTheme.colors.onSurface : ChiTheme.colors.onSurfaceVariant
                    elide: Text.ElideMiddle
                }
            }
        }
    }

    // Helper function
    function _isImage(url) {
        if (!url || url.toString() === "") return false
        let ext = url.toString().split('.').pop().toLowerCase()
        return ["png", "jpg", "jpeg", "gif", "bmp", "svg", "webp"].includes(ext)
    }
}
