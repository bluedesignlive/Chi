import QtQuick
import Qt5Compat.GraphicalEffects
import "../theme" as Theme

Item {
    id: root

    property string source: ""
    property real size: 24
    property color color: Theme.ChiTheme.colors.onSurface
    property bool filled: false

    implicitWidth: size
    implicitHeight: size
    visible: source !== ""

    // ═══════════════════════════════════════════════════════════════
    // ICON TYPE DETECTION
    // ═══════════════════════════════════════════════════════════════

    readonly property bool isImageSource: {
        if (source === "") return false
        var s = source.toLowerCase()
        return s.endsWith(".png") || s.endsWith(".svg") ||
               s.endsWith(".jpg") || s.endsWith(".jpeg") ||
               s.endsWith(".webp") || s.startsWith("file://") ||
               s.startsWith("qrc:") || s.startsWith("http://") ||
               s.startsWith("https://") || s.startsWith("image://")
    }

    // Material icon: lowercase with underscores OR unicode codepoint (single char)
    readonly property bool isMaterialIcon: {
        if (source === "" || isImageSource) return false
        // Ligature names: dark_mode, light_mode, settings, etc.
        if (/^[a-z][a-z0-9_]*$/.test(source)) return true
        // Unicode codepoints: single character with code > 0xE000 (Private Use Area)
        if (source.length === 1 && source.charCodeAt(0) >= 0xE000) return true
        // Escaped unicode like "\uE518"
        if (source.length === 1) return true
        return false
    }

    readonly property bool isUnicodeIcon: source !== "" && !isImageSource && !isMaterialIcon

    // ═══════════════════════════════════════════════════════════════
    // IMAGE ICON
    // ═══════════════════════════════════════════════════════════════

    Image {
        id: imageIcon
        visible: root.isImageSource
        anchors.centerIn: parent
        width: root.size
        height: root.size
        source: root.isImageSource ? root.source : ""
        fillMode: Image.PreserveAspectFit
        smooth: true
        mipmap: true
        antialiasing: true
        asynchronous: true
        sourceSize: Qt.size(root.size * 2, root.size * 2)
    }

    ColorOverlay {
        visible: root.isImageSource && imageIcon.status === Image.Ready
        anchors.fill: imageIcon
        source: imageIcon
        color: root.color
        cached: true
    }

    // ═══════════════════════════════════════════════════════════════
    // MATERIAL ICON (Using embedded font)
    // ═══════════════════════════════════════════════════════════════

    Text {
        id: materialIcon
        visible: root.isMaterialIcon
        anchors.centerIn: parent
        text: root.source
        font.family: Theme.IconFont.family
        font.pixelSize: root.size
        color: root.color
        renderType: Text.NativeRendering
        
        Behavior on color { ColorAnimation { duration: 150 } }
    }

    // ═══════════════════════════════════════════════════════════════
    // UNICODE/EMOJI ICON
    // ═══════════════════════════════════════════════════════════════

    Text {
        id: unicodeIcon
        visible: root.isUnicodeIcon
        anchors.centerIn: parent
        text: root.source
        font.pixelSize: root.size
        color: root.color
        
        Behavior on color { ColorAnimation { duration: 150 } }
    }
}
