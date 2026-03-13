import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme

Item {
    id: root

    property var model: []
    property int indentSize: 20
    property bool showIcons: true
    property bool showHidden: false
    property var selectedItem: null
    property string selectedPath: ""
    property bool enabled: true

    signal itemClicked(var item, string path)
    signal itemDoubleClicked(var item, string path)
    signal itemExpanded(var item, string path)
    signal itemCollapsed(var item, string path)
    signal contextMenuRequested(var item, string path, real x, real y)

    implicitWidth: 300
    implicitHeight: 400

    property var colors: Theme.ChiTheme.colors

    property var fileIcons: ({
        folder: "📁",
        folderOpen: "📂",
        file: "📄",
        image: "🖼️",
        video: "🎬",
        audio: "🎵",
        pdf: "📕",
        code: "💻",
        text: "📝",
        archive: "📦",
        executable: "⚙️",
        link: "🔗",
        unknown: "📄"
    })

    function getFileIcon(item) {
        if (item.type === "folder") {
            return item.expanded ? fileIcons.folderOpen : fileIcons.folder
        }

        var ext = item.name.split(".").pop().toLowerCase()

        var imageExts = ["png", "jpg", "jpeg", "gif", "bmp", "svg", "webp", "ico"]
        var videoExts = ["mp4", "avi", "mkv", "mov", "wmv", "flv", "webm"]
        var audioExts = ["mp3", "wav", "flac", "ogg", "m4a", "aac"]
        var codeExts = ["js", "ts", "py", "c", "cpp", "h", "java", "rs", "go", "qml", "html", "css", "json", "xml", "sh", "bash"]
        var archiveExts = ["zip", "tar", "gz", "bz2", "xz", "7z", "rar"]

        if (imageExts.indexOf(ext) !== -1) return fileIcons.image
        if (videoExts.indexOf(ext) !== -1) return fileIcons.video
        if (audioExts.indexOf(ext) !== -1) return fileIcons.audio
        if (ext === "pdf") return fileIcons.pdf
        if (codeExts.indexOf(ext) !== -1) return fileIcons.code
        if (["txt", "md", "rst", "log"].indexOf(ext) !== -1) return fileIcons.text
        if (archiveExts.indexOf(ext) !== -1) return fileIcons.archive

        return fileIcons.file
    }

    Flickable {
        anchors.fill: parent
        contentHeight: treeColumn.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: treeColumn
            width: parent.width

            Repeater {
                model: root.model

                delegate: treeItemDelegate
            }
        }
    }

    Component {
        id: treeItemDelegate

        Column {
            id: delegateColumn
            width: parent ? parent.width : root.width

            property var itemData: modelData
            property int depth: 0
            property string itemPath: modelData.name
            property bool isHidden: modelData.name.startsWith(".")

            visible: !isHidden || showHidden

            Rectangle {
                width: parent.width
                height: 32

                property bool isSelected: selectedPath === delegateColumn.itemPath

                color: isSelected ? colors.primaryContainer : "transparent"

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }

                Rectangle {
                    anchors.fill: parent
                    color: colors.onSurface
                    opacity: itemMouse.containsMouse && !parent.isSelected ? 0.08 : 0

                    Behavior on opacity {
                        NumberAnimation { duration: 100 }
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8 + delegateColumn.depth * indentSize
                    anchors.rightMargin: 8
                    spacing: 8

                    Item {
                        Layout.preferredWidth: 16
                        Layout.preferredHeight: 16
                        visible: delegateColumn.itemData.type === "folder"

                        Text {
                            anchors.centerIn: parent
                            text: delegateColumn.itemData.expanded ? "▼" : "▶"
                            font.pixelSize: 10
                            color: colors.onSurfaceVariant

                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: -4
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                delegateColumn.itemData.expanded = !delegateColumn.itemData.expanded
                                if (delegateColumn.itemData.expanded) {
                                    itemExpanded(delegateColumn.itemData, delegateColumn.itemPath)
                                } else {
                                    itemCollapsed(delegateColumn.itemData, delegateColumn.itemPath)
                                }
                                root.modelChanged()
                            }
                        }
                    }

                    Item {
                        Layout.preferredWidth: 16
                        visible: delegateColumn.itemData.type !== "folder"
                    }

                    Text {
                        visible: showIcons
                        text: getFileIcon(delegateColumn.itemData)
                        font.pixelSize: 16
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Text {
                        text: delegateColumn.itemData.name
                        font.family: "Roboto"
                        font.pixelSize: 14
                        color: delegateColumn.isHidden ? colors.onSurfaceVariant : colors.onSurface
                        elide: Text.ElideMiddle
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                    }
                }

                MouseArea {
                    id: itemMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    cursorShape: Qt.PointingHandCursor

                    onClicked: function(mouse) {
                        if (mouse.button === Qt.RightButton) {
                            contextMenuRequested(delegateColumn.itemData, delegateColumn.itemPath, mouse.x, mouse.y)
                        } else {
                            selectedPath = delegateColumn.itemPath
                            selectedItem = delegateColumn.itemData
                            itemClicked(delegateColumn.itemData, delegateColumn.itemPath)
                        }
                    }

                    onDoubleClicked: {
                        if (delegateColumn.itemData.type === "folder") {
                            delegateColumn.itemData.expanded = !delegateColumn.itemData.expanded
                            root.modelChanged()
                        }
                        itemDoubleClicked(delegateColumn.itemData, delegateColumn.itemPath)
                    }
                }
            }

            Column {
                visible: delegateColumn.itemData.type === "folder" && delegateColumn.itemData.expanded && delegateColumn.itemData.children
                width: parent.width

                Repeater {
                    model: delegateColumn.itemData.children || []

                    delegate: Loader {
                        width: parent ? parent.width : 0
                        sourceComponent: treeItemDelegate

                        onLoaded: {
                            item.itemData = modelData
                            item.depth = delegateColumn.depth + 1
                            item.itemPath = delegateColumn.itemPath + "/" + modelData.name
                        }
                    }
                }
            }
        }
    }

    function expandAll() {
        function expand(items) {
            for (var i = 0; i < items.length; i++) {
                if (items[i].type === "folder") {
                    items[i].expanded = true
                    if (items[i].children) expand(items[i].children)
                }
            }
        }
        expand(model)
        modelChanged()
    }

    function collapseAll() {
        function collapse(items) {
            for (var i = 0; i < items.length; i++) {
                if (items[i].type === "folder") {
                    items[i].expanded = false
                    if (items[i].children) collapse(items[i].children)
                }
            }
        }
        collapse(model)
        modelChanged()
    }

    Accessible.role: Accessible.Tree
    Accessible.name: "File tree"
}
