pragma Singleton
import QtQuick

Item {
    id: themeRoot

    readonly property color seed: "#673AB7"

    readonly property string fontFamily: "Roboto"
    readonly property string iconFamily: IconFont.family

    readonly property var typography: ({
        displayLarge:   { family: "Roboto", size: 57, weight: 400, spacing: -0.25, lineHeight: 64 },
        displayMedium:  { family: "Roboto", size: 45, weight: 400, spacing: 0,     lineHeight: 52 },
        displaySmall:   { family: "Roboto", size: 36, weight: 400, spacing: 0,     lineHeight: 44 },
        headlineLarge:  { family: "Roboto", size: 32, weight: 400, spacing: 0,     lineHeight: 40 },
        headlineMedium: { family: "Roboto", size: 28, weight: 400, spacing: 0,     lineHeight: 36 },
        headlineSmall:  { family: "Roboto", size: 24, weight: 400, spacing: 0,     lineHeight: 32 },
        titleLarge:     { family: "Roboto", size: 22, weight: 400, spacing: 0,     lineHeight: 28 },
        titleMedium:    { family: "Roboto", size: 16, weight: 500, spacing: 0.15,  lineHeight: 24 },
        titleSmall:     { family: "Roboto", size: 14, weight: 500, spacing: 0.1,   lineHeight: 20 },
        bodyLarge:      { family: "Roboto", size: 16, weight: 400, spacing: 0.5,   lineHeight: 24 },
        bodyMedium:     { family: "Roboto", size: 14, weight: 400, spacing: 0.25,  lineHeight: 20 },
        bodySmall:      { family: "Roboto", size: 12, weight: 400, spacing: 0.4,   lineHeight: 16 },
        labelLarge:     { family: "Roboto", size: 14, weight: 500, spacing: 0.1,   lineHeight: 20 },
        labelMedium:    { family: "Roboto", size: 12, weight: 500, spacing: 0.5,   lineHeight: 16 },
        labelSmall:     { family: "Roboto", size: 11, weight: 500, spacing: 0.5,   lineHeight: 16 }
    })

    readonly property var _seedDark: ({
        primary: "#D3BCFD", onPrimary: "#38265C",
        primaryContainer: "#4F3D74", onPrimaryContainer: "#EBDDFF",
        secondary: "#CDC2DB", onSecondary: "#342D40",
        secondaryContainer: "#4B4358", onSecondaryContainer: "#E9DEF8",
        tertiary: "#F0B7C5", onTertiary: "#4A2530",
        tertiaryContainer: "#643B46", onTertiaryContainer: "#FFD9E1",
        error: "#FFB4AB", onError: "#690005",
        errorContainer: "#93000A", onErrorContainer: "#FFDAD6",
        background: "#151218", onBackground: "#E7E0E8",
        surface: "#151218", onSurface: "#E7E0E8",
        surfaceDim: "#151218", surfaceBright: "#3B383E",
        surfaceVariant: "#49454E", onSurfaceVariant: "#CBC4CF",
        surfaceContainerLowest: "#0D0B0F", surfaceContainerLow: "#1D1B20",
        surfaceContainer: "#211F24", surfaceContainerHigh: "#2C292F",
        surfaceContainerHighest: "#36343B",
        outline: "#948F99", outlineVariant: "#49454E",
        shadow: "#000000", scrim: "#000000", surfaceTint: "#D3BCFD",
        inverseSurface: "#E7E0E8", inverseOnSurface: "#322F35", inversePrimary: "#68548E"
    })

    readonly property var _seedLight: ({
        primary: "#68548E", onPrimary: "#FFFFFF",
        primaryContainer: "#EBDDFF", onPrimaryContainer: "#230F46",
        secondary: "#635B70", onSecondary: "#FFFFFF",
        secondaryContainer: "#E9DEF8", onSecondaryContainer: "#1F182B",
        tertiary: "#7E525D", onTertiary: "#FFFFFF",
        tertiaryContainer: "#FFD9E1", onTertiaryContainer: "#31101B",
        error: "#BA1A1A", onError: "#FFFFFF",
        errorContainer: "#FFDAD6", onErrorContainer: "#410002",
        background: "#FEF7FF", onBackground: "#1D1B20",
        surface: "#FEF7FF", onSurface: "#1D1B20",
        surfaceDim: "#DED8E0", surfaceBright: "#FEF7FF",
        surfaceVariant: "#E7E0EB", onSurfaceVariant: "#49454E",
        surfaceContainerLowest: "#FFFFFF", surfaceContainerLow: "#F7F2FA",
        surfaceContainer: "#F3EDF7", surfaceContainerHigh: "#ECE6F0",
        surfaceContainerHighest: "#E6E0E9",
        outline: "#7A757F", outlineVariant: "#CAC4D0",
        shadow: "#000000", scrim: "#000000", surfaceTint: "#68548E",
        inverseSurface: "#322F35", inverseOnSurface: "#F5EFF7", inversePrimary: "#D3BCFD"
    })

    property bool isDarkMode: true
    property color primaryColor: seed

    readonly property var colors: {
        var p = primaryColor
        if (_isSeedColor(p))
            return isDarkMode ? _seedDark : _seedLight
        return isDarkMode ? _genDark(p) : _genLight(p)
    }

    function _isSeedColor(c) {
        return Math.abs(c.r - seed.r) < 0.02
            && Math.abs(c.g - seed.g) < 0.02
            && Math.abs(c.b - seed.b) < 0.02
    }

    // ═══════════════════════════════════════════════════════
    // C++ BACKEND SYNC (automatic, no app-side code needed)
    // _chiBackend is set by the plugin via initializeEngine
    // ═══════════════════════════════════════════════════════

    Connections {
        target: _chiBackend
        function onThemeChanged() {
            themeRoot.isDarkMode   = _chiBackend.isDarkMode
            themeRoot.primaryColor = _chiBackend.primaryColor
        }
    }

    Component.onCompleted: {
        if (_chiBackend) {
            isDarkMode   = _chiBackend.isDarkMode
            primaryColor = _chiBackend.primaryColor
        }
    }

    function setDarkMode(dark)  { _chiBackend.isDarkMode = dark }
    function setPrimaryColor(c) { _chiBackend.primaryColor = c.toString() }
    function toggleDarkMode()   { _chiBackend.isDarkMode = !_chiBackend.isDarkMode }

    // ═══════════════════════════════════════════════════════
    // ALGORITHMIC PALETTES
    // ═══════════════════════════════════════════════════════

    function _genLight(p) {
        var h = p.hslHue >= 0 ? p.hslHue : 0
        var th = (h + 0.17) % 1.0
        return {
            primary: p.toString(), onPrimary: "#FFFFFF",
            primaryContainer: Qt.lighter(p, 1.85).toString(),
            onPrimaryContainer: Qt.darker(p, 2.5).toString(),
            secondary: Qt.hsla(h, 0.20, 0.42, 1.0).toString(), onSecondary: "#FFFFFF",
            secondaryContainer: Qt.hsla(h, 0.14, 0.90, 1.0).toString(),
            onSecondaryContainer: Qt.hsla(h, 0.20, 0.15, 1.0).toString(),
            tertiary: Qt.hsla(th, 0.32, 0.42, 1.0).toString(), onTertiary: "#FFFFFF",
            tertiaryContainer: Qt.hsla(th, 0.38, 0.90, 1.0).toString(),
            onTertiaryContainer: Qt.hsla(th, 0.30, 0.15, 1.0).toString(),
            error: "#BA1A1A", onError: "#FFFFFF",
            errorContainer: "#FFDAD6", onErrorContainer: "#410002",
            background: "#FEF7FF", onBackground: "#1D1B20",
            surface: "#FEF7FF", onSurface: "#1D1B20",
            surfaceDim: "#DED8E0", surfaceBright: "#FEF7FF",
            surfaceVariant: "#E7E0EB", onSurfaceVariant: "#49454E",
            surfaceContainerLowest: "#FFFFFF", surfaceContainerLow: "#F7F2FA",
            surfaceContainer: "#F3EDF7", surfaceContainerHigh: "#ECE6F0",
            surfaceContainerHighest: "#E6E0E9",
            outline: "#7A757F", outlineVariant: "#CAC4D0",
            shadow: "#000000", scrim: "#000000", surfaceTint: p.toString(),
            inverseSurface: "#322F35", inverseOnSurface: "#F5EFF7",
            inversePrimary: Qt.lighter(p, 1.6).toString()
        }
    }

    function _genDark(p) {
        var h = p.hslHue >= 0 ? p.hslHue : 0
        var th = (h + 0.17) % 1.0
        var lt = Qt.lighter(p, 1.55)
        return {
            primary: lt.toString(), onPrimary: Qt.darker(p, 1.8).toString(),
            primaryContainer: Qt.darker(p, 1.15).toString(),
            onPrimaryContainer: Qt.lighter(p, 1.85).toString(),
            secondary: Qt.hsla(h, 0.18, 0.72, 1.0).toString(),
            onSecondary: Qt.hsla(h, 0.20, 0.20, 1.0).toString(),
            secondaryContainer: Qt.hsla(h, 0.18, 0.30, 1.0).toString(),
            onSecondaryContainer: Qt.hsla(h, 0.15, 0.90, 1.0).toString(),
            tertiary: Qt.hsla(th, 0.30, 0.72, 1.0).toString(),
            onTertiary: Qt.hsla(th, 0.30, 0.20, 1.0).toString(),
            tertiaryContainer: Qt.hsla(th, 0.28, 0.30, 1.0).toString(),
            onTertiaryContainer: Qt.hsla(th, 0.35, 0.90, 1.0).toString(),
            error: "#FFB4AB", onError: "#690005",
            errorContainer: "#93000A", onErrorContainer: "#FFDAD6",
            background: "#151218", onBackground: "#E7E0E8",
            surface: "#151218", onSurface: "#E7E0E8",
            surfaceDim: "#151218", surfaceBright: "#3B383E",
            surfaceVariant: "#49454E", onSurfaceVariant: "#CBC4CF",
            surfaceContainerLowest: "#0D0B0F", surfaceContainerLow: "#1D1B20",
            surfaceContainer: "#211F24", surfaceContainerHigh: "#2C292F",
            surfaceContainerHighest: "#36343B",
            outline: "#948F99", outlineVariant: "#49454E",
            shadow: "#000000", scrim: "#000000", surfaceTint: lt.toString(),
            inverseSurface: "#E7E0E8", inverseOnSurface: "#322F35",
            inversePrimary: p.toString()
        }
    }

    readonly property QtObject motion: QtObject {
        readonly property int durationFast: 100
        readonly property int durationMedium: 250
        readonly property int durationSlow: 350
        readonly property int durationExpressive: 600
        readonly property int easeStandard: Easing.OutCubic
        readonly property int easeEmphasized: Easing.OutQuart
        readonly property int easeBounce: Easing.OutBounce
        readonly property int easeElastic: Easing.OutElastic
        readonly property int easeBack: Easing.OutBack
        readonly property int pageExitDuration: 120
        readonly property int pageEnterDuration: 180
        readonly property int pageExitEasing: Easing.InQuart
        readonly property int pageEnterEasing: Easing.OutQuart
        readonly property real pageSlideDistance: 30
        readonly property real pageScaleOut: 0.96
    }
}
