import QtQuick
import Qt5Compat.GraphicalEffects
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

    readonly property bool isImageSource: {
        if (source === "") return false
        var s = source.toLowerCase()
        return s.endsWith(".png") || s.endsWith(".svg") ||
               s.endsWith(".jpg") || s.endsWith(".jpeg") ||
               s.endsWith(".webp") || s.startsWith("file://") ||
               s.startsWith("qrc:") || s.startsWith("http://") ||
               s.startsWith("https://") || s.startsWith("image://")
    }

    readonly property bool isMaterialIcon: {
        if (source === "" || isImageSource) return false
        return /^[a-z][a-z0-9_]*$/.test(source)
    }

    readonly property bool isUnicodeIcon: source !== "" && !isImageSource && !isMaterialIcon

    Image {
        id: imageIcon
        visible: isImageSource
        anchors.centerIn: parent
        width: root.size
        height: root.size
        source: isImageSource ? root.source : ""
        fillMode: Image.PreserveAspectFit
        smooth: true
        mipmap: true
        antialiasing: true
        asynchronous: true
        sourceSize: Qt.size(root.size * 2, root.size * 2)
    }

    ColorOverlay {
        visible: isImageSource && imageIcon.status === Image.Ready
        anchors.fill: imageIcon
        source: imageIcon
        color: root.color
        cached: true
    }

    Text {
        id: materialIcon
        visible: isMaterialIcon
        anchors.centerIn: parent
        text: source
        font.family: "Material Icons"
        font.pixelSize: root.size
        color: root.color
        Behavior on color { ColorAnimation { duration: 150 } }
    }

    Text {
        id: unicodeIcon
        visible: isUnicodeIcon
        anchors.centerIn: parent
        text: source
        font.pixelSize: root.size
        color: root.color
        Behavior on color { ColorAnimation { duration: 150 } }
    }
}
