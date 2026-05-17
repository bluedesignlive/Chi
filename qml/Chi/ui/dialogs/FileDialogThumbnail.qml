import QtQuick
import "../../theme" as Theme
import "../common"

Item {
    id: root

    property string filePath: ""
    property string fileMimeType: ""
    property string fileIcon: "insert_drive_file"
    property bool isDir: false
    property int thumbnailSize: 72
    property bool showThumbnails: true
    property var colors: Theme.ChiTheme.colors

    readonly property string _mime: fileMimeType || ""
    readonly property bool _isMedia: _mime.indexOf("image/") === 0
                                  || _mime.indexOf("video/") === 0
                                  || _mime.indexOf("audio/") === 0
    readonly property real _radius: Math.max(4, thumbnailSize * 0.11)

    // ── Icon: always visible as base layer ───────────────────

    Icon {
        anchors.centerIn: parent; z: 0
        source: isDir ? "folder" : fileIcon
        size: thumbnailSize * 0.55
        color: isDir ? colors.primary : colors.onSurfaceVariant
    }

    // ── Thumbnail: disk-cached via C++ provider ──────────────

    Rectangle {
        anchors.fill: parent
        radius: _radius; clip: true
        color: "transparent"; z: 1
        visible: showThumbnails && _isMedia && thumbImg.status === Image.Ready

        Image {
            id: thumbImg
            anchors.fill: parent
            source: showThumbnails && _isMedia ? "image://thumb/" + filePath : ""
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: false
            mipmap: true
            smooth: true
            sourceSize: Qt.size(thumbnailSize * 2, thumbnailSize * 2)
        }
    }
}
