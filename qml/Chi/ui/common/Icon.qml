import QtQuick
import QtQuick.Effects
import "../../theme" as Theme

Item {
    id: root

    property string source: ""
    property real size: 24
    property color color: Theme.ChiTheme.colors.onSurface
    property bool filled: false

    implicitWidth: size
    implicitHeight: size
    visible: source !== ""

    // 0=none  1=image  2=material  3=unicode
    readonly property int _type: {
        var s = source
        if (s === "") return 0
        var dot = s.lastIndexOf('.')
        if (dot >= 0) {
            var ext = s.substring(dot + 1).toLowerCase()
            if (ext === "png" || ext === "svg" || ext === "jpg" ||
                ext === "jpeg" || ext === "webp") return 1
        }
        if (s.startsWith("file://") || s.startsWith("qrc:") ||
            s.startsWith("http://") || s.startsWith("https://") ||
            s.startsWith("image://")) return 1
        if (/^[a-z][a-z0-9_]*$/.test(s) || s.length === 1) return 2
        return 3
    }

    readonly property bool isImageSource:  _type === 1
    readonly property bool isMaterialIcon: _type === 2
    readonly property bool isUnicodeIcon:  _type === 3

    Image {
        visible: root._type === 1
        anchors.centerIn: parent
        width: root.size
        height: root.size
        source: visible ? root.source : ""
        fillMode: Image.PreserveAspectFit
        smooth: true
        mipmap: true
        asynchronous: true
        sourceSize.width: root.size * 2
        sourceSize.height: root.size * 2

        layer.enabled: status === Image.Ready
        layer.effect: MultiEffect {
            colorization: 1.0
            colorizationColor: root.color
        }
    }

    Text {
        visible: root._type >= 2
        anchors.centerIn: parent
        text: root.source
        font.family: root._type === 2 ? Theme.IconFont.family : ""
        font.pixelSize: root.size
        color: root.color
        renderType: root._type === 2 ? Text.NativeRendering : Text.QtRendering
       // Behavior on color { ColorAnimation { duration: 150 } }
    }
}
