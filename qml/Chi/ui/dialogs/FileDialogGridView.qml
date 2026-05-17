import QtQuick.Controls.Basic
import QtQuick
import Chi 1.0
import "../../theme" as Theme
import "../common"

GridView {
    id: grid

    property int iconSize: 72
    property bool showThumbnails: true
    property var colors: Theme.ChiTheme.colors
    property var typo: Theme.ChiTheme.typography
    property string selectMode: "open"
    property var selectedSet: ({})

    signal fileClicked(url fileUrl, bool isDir, string fileName)
    signal fileDoubleClicked(url fileUrl, bool isDir)
    signal contextMenuRequested(url fileUrl, string fileName, bool isDir, real mx, real my, Item area)

    readonly property int cols: Math.max(1, Math.floor(width / (iconSize + 56)))
    cellWidth: width / cols
    cellHeight: iconSize + 56
    clip: true
    boundsBehavior: Flickable.StopAtBounds
    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AsNeeded
    }

    delegate: Item {
        width: grid.cellWidth
        height: grid.cellHeight
        readonly property bool _sel: selectedSet[model.fileUrl.toString()] === true || (grid.model && grid.parent && grid.parent.parent && typeof _isSelected === "function" && _isSelected(model.fileUrl))

        Rectangle {
            anchors.fill: parent
            anchors.margins: 4
            radius: 12
            color: _sel ? colors.primaryContainer : gM.containsMouse ? colors.surfaceContainerHighest : "transparent"

            Rectangle {
                visible: selectMode === "openMultiple" && !model.fileIsDir && (_sel || gM.containsMouse)
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 8
                anchors.rightMargin: 8
                width: 22
                height: 22
                radius: 6
                z: 10
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

            Column {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 6
                Item {
                    width: iconSize
                    height: iconSize
                    anchors.horizontalCenter: parent.horizontalCenter
                    FileDialogThumbnail {
                        anchors.fill: parent
                        filePath: model.filePath
                        fileMimeType: model.fileMimeType
                        fileIcon: model.fileIcon
                        isDir: model.fileIsDir
                        thumbnailSize: iconSize
                        showThumbnails: grid.showThumbnails
                        colors: grid.colors
                    }
                }
                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: model.fileName
                    font.family: typo.bodySmall.family
                    font.pixelSize: typo.bodySmall.size
                    font.weight: _sel ? Font.Medium : Font.Normal
                    color: _sel ? colors.onPrimaryContainer : colors.onSurface
                    elide: Text.ElideMiddle
                    maximumLineCount: 2
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }
            }

            MouseArea {
                id: gM
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                cursorShape: Qt.PointingHandCursor
                onClicked: function (mouse) {
                    if (mouse.button === Qt.RightButton)
                        grid.contextMenuRequested(model.fileUrl, model.fileName, model.fileIsDir, mouse.x, mouse.y, gM);
                    else
                        grid.fileClicked(model.fileUrl, model.fileIsDir, model.fileName);
                }
                onDoubleClicked: grid.fileDoubleClicked(model.fileUrl, model.fileIsDir)
            }
        }
    }
}
