pragma Singleton
import QtQuick

Item {
    id: themeRoot

    readonly property color seed: "#673AB7"

    // ─── Font Configuration ─────────────────────────────────
    readonly property string fontFamily: "Roboto"
    readonly property string iconFamily: "Material Icons"

    // ─── Typography Scale (Material Design 3) ───────────────
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

    // ─── Color Scheme (Dark) ────────────────────────────────
    readonly property var dark: ({
        primary: "#D3BCFD",
        onPrimary: "#38265C",
        primaryContainer: "#4F3D74",
        onPrimaryContainer: "#EBDDFF",

        secondary: "#CDC2DB",
        onSecondary: "#342D40",
        secondaryContainer: "#4B4358",
        onSecondaryContainer: "#E9DEF8",

        tertiary: "#F0B7C5",
        onTertiary: "#4A2530",
        tertiaryContainer: "#643B46",
        onTertiaryContainer: "#FFD9E1",

        error: "#FFB4AB",
        onError: "#690005",
        errorContainer: "#93000A",
        onErrorContainer: "#FFDAD6",

        background: "#151218",
        onBackground: "#E7E0E8",
        surface: "#151218",
        onSurface: "#E7E0E8",
        surfaceDim: "#151218",
        surfaceBright: "#3B383E",
        surfaceVariant: "#49454E",
        onSurfaceVariant: "#CBC4CF",

        surfaceContainerLowest: "#0D0B0F",
        surfaceContainerLow: "#1D1B20",
        surfaceContainer: "#211F24",
        surfaceContainerHigh: "#2C292F",
        surfaceContainerHighest: "#36343B",

        outline: "#948F99",
        outlineVariant: "#49454E",
        shadow: "#000000",
        scrim: "#000000",
        surfaceTint: "#D3BCFD",

        inverseSurface: "#E7E0E8",
        inverseOnSurface: "#322F35",
        inversePrimary: "#68548E"
    })

    // ─── Color Scheme (Light) ───────────────────────────────
    readonly property var light: ({
        primary: "#68548E",
        onPrimary: "#FFFFFF",
        primaryContainer: "#EBDDFF",
        onPrimaryContainer: "#230F46",

        secondary: "#635B70",
        onSecondary: "#FFFFFF",
        secondaryContainer: "#E9DEF8",
        onSecondaryContainer: "#1F182B",

        tertiary: "#7E525D",
        onTertiary: "#FFFFFF",
        tertiaryContainer: "#FFD9E1",
        onTertiaryContainer: "#31101B",

        error: "#BA1A1A",
        onError: "#FFFFFF",
        errorContainer: "#FFDAD6",
        onErrorContainer: "#410002",

        background: "#FEF7FF",
        onBackground: "#1D1B20",
        surface: "#FEF7FF",
        onSurface: "#1D1B20",
        surfaceDim: "#DED8E0",
        surfaceBright: "#FEF7FF",
        surfaceVariant: "#E7E0EB",
        onSurfaceVariant: "#49454E",

        surfaceContainerLowest: "#FFFFFF",
        surfaceContainerLow: "#F7F2FA",
        surfaceContainer: "#F3EDF7",
        surfaceContainerHigh: "#ECE6F0",
        surfaceContainerHighest: "#E6E0E9",

        outline: "#7A757F",
        outlineVariant: "#CAC4D0",
        shadow: "#000000",
        scrim: "#000000",
        surfaceTint: "#68548E",

        inverseSurface: "#322F35",
        inverseOnSurface: "#F5EFF7",
        inversePrimary: "#D3BCFD"
    })

    // ─── Mode & Active Colors ───────────────────────────────
    property bool isDarkMode: false
    readonly property var colors: isDarkMode ? dark : light

    // ─── Motion ─────────────────────────────────────────────
    readonly property QtObject motion: QtObject {
        // ── Duration tokens ─────────────────────────────────
        readonly property int durationFast: 100
        readonly property int durationMedium: 250
        readonly property int durationSlow: 350
        readonly property int durationExpressive: 600

        // ── Easing tokens ───────────────────────────────────
        readonly property int easeStandard: Easing.OutCubic
        readonly property int easeEmphasized: Easing.OutQuart
        readonly property int easeBounce: Easing.OutBounce
        readonly property int easeElastic: Easing.OutElastic
        readonly property int easeBack: Easing.OutBack

        // ── Page Transition (shared-axis Y) ─────────────────
        //  Used by NavigationDrawer and any component that
        //  switches pages. Two-phase asymmetric: fast exit,
        //  graceful entrance with directional Y shift + scale.
        readonly property int pageExitDuration: 120
        readonly property int pageEnterDuration: 180
        readonly property int pageExitEasing: Easing.InQuart
        readonly property int pageEnterEasing: Easing.OutQuart
        readonly property real pageSlideDistance: 30
        readonly property real pageScaleOut: 0.96
    }
}
