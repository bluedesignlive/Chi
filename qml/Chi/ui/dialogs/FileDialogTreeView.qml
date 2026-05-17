import QtQuick.Controls.Basic
import QtQuick
import QtQuick.Layouts
import Chi 1.0
import "../../theme" as Theme
import "../common"

ListView {
    id: tree

    property var colors: Theme.ChiTheme.colors
    property var typo: Theme.ChiTheme.typography

    signal fileClicked(url fileUrl, bool isDir, string fileName)
    signal fileDoubleClicked(url fileUrl, bool isDir)
    signal contextMenuRequested(url fileUrl, string fileName, bool isDir, real mx, real my, Item area)
    signal navigateTo(url folderUrl)

    clip: true
    spacing: 2
    boundsBehavior: Flickable.StopAtBounds
    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AsNeeded
    }

    delegate: Rectangle {
        width: tree.width
        height: 40
        radius: 10
        readonly property bool _sel: false  // tree selection handled by parent
        color: tM.containsMouse ? colors.surfaceContainerHighest : "transparent"

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 12
            spacing: 0

            Item {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    visible: model.fileIsDir
                    color: chevM.containsMouse ? colors.surfaceContainerHighest : "transparent"
                    Icon {
                        anchors.centerIn: parent
                        source: "chevron_right"
                        size: 22
                        color: colors.onSurfaceVariant
                    }
                    MouseArea {
                        id: chevM
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: tree.navigateTo(model.fileUrl)
                        z: 10
                    }
                }
            }

            Icon {
                source: model.fileIsDir ? "folder" : model.fileIcon
                size: 22
                color: model.fileIsDir ? colors.primary : colors.onSurfaceVariant
            }
            Text {
                Layout.fillWidth: true
                Layout.leftMargin: 10
                text: model.fileName
                font.family: typo.bodyMedium.family
                font.pixelSize: typo.bodyMedium.size
                color: colors.onSurface
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
            id: tM
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            cursorShape: Qt.PointingHandCursor
            onClicked: function (mouse) {
                if (mouse.button === Qt.RightButton)
                    tree.contextMenuRequested(model.fileUrl, model.fileName, model.fileIsDir, mouse.x, mouse.y, tM);
                else
                    tree.fileClicked(model.fileUrl, model.fileIsDir, model.fileName);
            }
            onDoubleClicked: tree.fileDoubleClicked(model.fileUrl, model.fileIsDir)
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
