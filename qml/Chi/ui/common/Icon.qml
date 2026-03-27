import QtQuick
import QtQuick.Effects
import "../../theme" as Theme

Item {
    id: root

    // ═══════════════════════════════════════════════════════════
    // PUBLIC API
    // ═══════════════════════════════════════════════════════════

    property string source: ""
    property real size: 24
    property color color: Theme.ChiTheme.colors.onSurface
    property bool filled: false
    property int weight: 400          // 100–700 (Thin→Bold)
    property real grade: 0            // -25 to 200
    property string fallback: ""      // fallback icon if image fails

    // ═══════════════════════════════════════════════════════════
    // SIZING
    // ═══════════════════════════════════════════════════════════

    implicitWidth: size
    implicitHeight: size
    visible: source !== ""

    // ═══════════════════════════════════════════════════════════
    // TYPE DETECTION
    //
    //   0 = none (empty)
    //   1 = image (file path, URL, qrc, data URI)
    //   2 = material symbol ligature (e.g. "play_arrow")
    //   3 = unicode (emoji, symbols, CJK, etc.)
    //
    // Material Symbols use lowercase + underscores + digits.
    // Minimum 2 chars — single letters are ambiguous and not
    // valid Material Symbol names.
    // ═══════════════════════════════════════════════════════════

    readonly property int _type: {
        var s = source
        if (s === "") return 0

        // Image: file extension check
        var dot = s.lastIndexOf('.')
        if (dot >= 0) {
            var ext = s.substring(dot + 1).toLowerCase()
            if (ext === "png" || ext === "svg" || ext === "jpg" ||
                ext === "jpeg" || ext === "webp" || ext === "gif" ||
                ext === "bmp" || ext === "ico") return 1
        }

        // Image: URL/resource prefix check
        if (s.startsWith("file://") || s.startsWith("qrc:") ||
            s.startsWith(":/") ||
            s.startsWith("http://") || s.startsWith("https://") ||
            s.startsWith("image://") || s.startsWith("data:")) return 1

        // Material Symbol: 2+ lowercase chars with underscores/digits
        // Covers: "play_arrow", "volume_up", "chevron_right", "3d_rotation"
        if (/^[a-z0-9][a-z0-9_]*$/.test(s) && s.length >= 2) return 2

        // Everything else: unicode emoji, symbols, single chars
        return 3
    }

    readonly property bool isImageSource:  _type === 1
    readonly property bool isMaterialIcon: _type === 2
    readonly property bool isUnicodeIcon:  _type === 3

    // ═══════════════════════════════════════════════════════════
    // IMAGE RENDERER
    // ═══════════════════════════════════════════════════════════

    Image {
        id: _image
        visible: root._type === 1
        anchors.centerIn: parent
        width: root.size
        height: root.size
        source: visible ? root.source : ""
        fillMode: Image.PreserveAspectFit
        smooth: true
        mipmap: true
        asynchronous: true
        cache: true
        sourceSize.width: root.size * 2
        sourceSize.height: root.size * 2

        layer.enabled: status === Image.Ready
        layer.effect: MultiEffect {
            colorization: 1.0
            colorizationColor: root.color
        }

        onStatusChanged: {
            if (status === Image.Error && root.fallback !== "") {
                root.source = root.fallback
                root.fallback = ""
            }
        }
    }

    // ═══════════════════════════════════════════════════════════
    // TEXT RENDERER (Material Symbols + Unicode)
    //
    // Material Symbols Rounded is a variable font with 4 axes:
    //   FILL  — 0 (outlined) or 1 (filled)
    //   wght  — 100 to 700
    //   GRAD  — -25 to 200
    //   opsz  — 20 to 48 (optical size, auto-matched to size)
    //
    // MUST use Text.QtRendering — NativeRendering breaks
    // ligature resolution on Wayland and some X11 compositors.
    // ═══════════════════════════════════════════════════════════

    Text {
        id: _text
        visible: root._type >= 2
        anchors.centerIn: parent
        text: root.source
        font.family: root._type === 2 ? Theme.IconFont.family : ""
        font.pixelSize: root.size
        font.variableAxes: root._type === 2 ? {
            "FILL": root.filled ? 1 : 0,
            "wght": root.weight,
            "GRAD": root.grade,
            "opsz": root.size
        } : ({})
        color: root.color
        renderType: Text.QtRendering

        Accessible.ignored: true
    }

    // ═══════════════════════════════════════════════════════════
    // ACCESSIBILITY
    // ═══════════════════════════════════════════════════════════

    Accessible.role: Accessible.Graphic
    Accessible.name: source
    Accessible.ignored: source === ""
}
