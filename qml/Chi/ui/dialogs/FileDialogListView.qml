import QtQuick.Controls.Basic
import QtQuick
import QtQuick.Layouts
import Chi 1.0
import "../../theme" as Theme
import "../common"

ListView {
    id: list

    property bool showThumbnails: true
    property var colors: Theme.ChiTheme.colors
    property var typo: Theme.ChiTheme.typography
    property string selectMode: "open"
    property var selectedSet: ({})

    signal fileClicked(url fileUrl, bool isDir, string fileName)
    signal fileDoubleClicked(url fileUrl, bool isDir)
    signal contextMenuRequested(url fileUrl, string fileName, bool isDir, real mx, real my, Item area)

    clip: true
    spacing: 2
    boundsBehavior: Flickable.StopAtBounds
    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AsNeeded
    }

    delegate: Rectangle {
        width: list.width
        height: 42
        radius: 10
        readonly property bool _sel: selectedSet[model.fileUrl.toString()] === true
        color: _sel ? colors.primaryContainer : lM.containsMouse ? colors.surfaceContainerHighest : "transparent"

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 12
            spacing: 0

            Item {
                Layout.preferredWidth: selectMode === "openMultiple" && !model.fileIsDir ? 32 : 0
                Layout.preferredHeight: 32
                visible: selectMode === "openMultiple" && !model.fileIsDir
                Rectangle {
                    anchors.centerIn: parent
                    width: 22
                    height: 22
                    radius: 6
                    visible: selectedSet[model.fileUrl.toString()] === true || lM.containsMouse
                    color: selectedSet[model.fileUrl.toString()] === true ? colors.primary : "transparent"
                    border.width: selectedSet[model.fileUrl.toString()] === true ? 0 : 1.5
                    border.color: colors.outlineVariant
                    Icon {
                        visible: selectedSet[model.fileUrl.toString()] === true
                        anchors.centerIn: parent
                        source: "check"
                        size: 16
                        color: colors.onPrimary
                    }
                }
            }

            Item {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                Layout.leftMargin: selectMode === "openMultiple" && !model.fileIsDir ? 0 : 4
                FileDialogThumbnail {
                    anchors.fill: parent
                    filePath: model.filePath
                    fileMimeType: model.fileMimeType
                    fileIcon: model.fileIcon
                    isDir: model.fileIsDir
                    thumbnailSize: 32
                    showThumbnails: list.showThumbnails
                    colors: list.colors
                }
            }

            Text {
                Layout.fillWidth: true
                Layout.leftMargin: 12
                text: model.fileName
                font.family: typo.bodyMedium.family
                font.pixelSize: typo.bodyMedium.size
                color: _sel ? colors.onPrimaryContainer : colors.onSurface
                elide: Text.ElideMiddle
            }
            Text {
                Layout.preferredWidth: 80
                text: model.fileIsDir ? "--" : _formatSize(model.fileSize)
                font.family: typo.bodySmall.family
                font.pixelSize: typo.bodySmall.size
                color: colors.onSurfaceVariant
                horizontalAlignment: Text.AlignRight
            }
            Text {
                Layout.preferredWidth: 140
                Layout.leftMargin: 16
                text: Qt.formatDateTime(model.fileModified, "MMM d, yyyy")
                font.family: typo.bodySmall.family
                font.pixelSize: typo.bodySmall.size
                color: colors.onSurfaceVariant
            }
            Text {
                Layout.preferredWidth: 100
                Layout.leftMargin: 16
                text: model.fileIsDir ? "Folder" : model.fileTypeLabel
                font.family: typo.bodySmall.family
                font.pixelSize: typo.bodySmall.size
                color: colors.onSurfaceVariant
                elide: Text.ElideRight
            }
        }

        MouseArea {
            id: lM
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            cursorShape: Qt.PointingHandCursor
            onClicked: function (mouse) {
                if (mouse.button === Qt.RightButton)
                    list.contextMenuRequested(model.fileUrl, model.fileName, model.fileIsDir, mouse.x, mouse.y, lM);
                else
                    list.fileClicked(model.fileUrl, model.fileIsDir, model.fileName);
            }
            onDoubleClicked: list.fileDoubleClicked(model.fileUrl, model.fileIsDir)
        }
    }

    function _formatSize(b) {
        if (b < 1024)
            return b + " B";
        if (b < 1048576)
            return (b / 1024).toFixed(1) + " KB";
        if (b < 1073741824)
            return (b / 1048576).toFixed(1) + " MB";
        return (b / 1073741824).toFixed(1) + " GB";
    }
}
