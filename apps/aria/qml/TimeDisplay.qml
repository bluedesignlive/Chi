import QtQuick
import Chi 1.0

// Shows elapsed / total time in a compact row
Row {
    property int   currentMs: 0
    property int   totalMs: 0
    property color textColor: ChiTheme.colors.onSurface
    property color dimColor: ChiTheme.colors.onSurfaceVariant

    spacing: 6

    Text {
        text: _fmt(currentMs)
        font.family: ChiTheme.fontFamily; font.pixelSize: 14
        font.weight: Font.Medium; color: textColor
    }
    Text {
        text: "/"; font.family: ChiTheme.fontFamily; font.pixelSize: 14; color: dimColor
    }
    Text {
        text: _fmt(totalMs)
        font.family: ChiTheme.fontFamily; font.pixelSize: 14; color: dimColor
    }

    function _fmt(ms) {
        var s = Math.floor(ms / 1000), m = Math.floor(s / 60)
        s = s % 60
        return m + ":" + (s < 10 ? "0" : "") + s
    }
}
