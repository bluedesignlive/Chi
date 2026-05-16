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

    // ── Thumbnail: C++ provider, disk-cached ─────────────────
    //    Only loaded for image/video/audio. Everything else
    //    shows icon instantly (provider would return null anyway).
    //    First load: async decode + disk cache. After: instant.

    Image {
        id: thumb
        anchors.fill: parent
        visible: showThumbnails && _isMedia && status === Image.Ready
        source: visible ? "image://thumb/" + filePath : ""
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: false      // C++ disk cache handles persistence
        mipmap: true
        smooth: true
        sourceSize: Qt.size(thumbnailSize * 2, thumbnailSize * 2)

        // Rounded corners via layer
        layer.enabled: true
        layer.smooth: true
        layer.effect: ShaderEffect {
            property real radius: root._radius / root.width
            fragmentShader: "
                varying highp vec2 qt_TexCoord0;
                uniform sampler2D source;
                uniform lowp float radius;
                uniform lowp float qt_Opacity;
                void main() {
                    lowp vec4 tex = texture2D(source, qt_TexCoord0);
                    lowp vec2 uv = qt_TexCoord0;
                    lowp float d = 0.0;
                    if (uv.x < radius && uv.y < radius)
                        d = distance(uv, vec2(radius));
                    else if (uv.x > 1.0 - radius && uv.y < radius)
                        d = distance(uv, vec2(1.0 - radius));
                    else if (uv.x < radius && uv.y > 1.0 - radius)
                        d = distance(uv, vec2(radius, 1.0 - radius));
                    else if (uv.x > 1.0 - radius && uv.y > 1.0 - radius)
                        d = distance(uv, vec2(1.0 - radius, 1.0 - radius));
                    lowp float a = 1.0 - smoothstep(0.0, 0.003, d - radius + 0.003);
                    gl_FragColor = tex * qt_Opacity * a;
                }
            "
        }
    }
}
