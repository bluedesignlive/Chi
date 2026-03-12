// theme/ChiTheme.qml
pragma Singleton
import QtQuick

QtObject {
    id: root

    // ── C++ Backend (registered as Chi.ThemeBackend) ────────
    // When used inside the module itself, we access it relatively.
    // The plugin registers ThemeBackend; we grab it at component completion.

    property bool  isDark:       ThemeBackend.isDarkMode
    property string primarySeed: ThemeBackend.primaryColor
    property int   _rev:         ThemeBackend.revision    // forces full rebind

    // ── Font Families ───────────────────────────────────────
    readonly property string fontFamily: "Inter"
    readonly property string iconFamily: "Material Symbols Outlined"

    // ── Motion Tokens ───────────────────────────────────────
    readonly property QtObject motion: QtObject {
        readonly property int durationFast:       100
        readonly property int durationMedium:     200
        readonly property int durationSlow:       350
        readonly property int durationEmphasis:   500
        readonly property int easeStandard:       Easing.OutCubic
        readonly property int easeDecelerate:     Easing.OutQuart
        readonly property int easeAccelerate:     Easing.InCubic
    }

    // ── Typography Tokens ───────────────────────────────────
    readonly property var typography: ({
        displayLarge:  { size: 57, weight: Font.Normal,  spacing: -0.25 },
        displayMedium: { size: 45, weight: Font.Normal,  spacing: 0 },
        displaySmall:  { size: 36, weight: Font.Normal,  spacing: 0 },
        headlineLarge: { size: 32, weight: Font.Normal,  spacing: 0 },
        headlineMedium:{ size: 28, weight: Font.Normal,  spacing: 0 },
        headlineSmall: { size: 24, weight: Font.Normal,  spacing: 0 },
        titleLarge:    { size: 22, weight: Font.Normal,  spacing: 0 },
        titleMedium:   { size: 16, weight: Font.Medium,  spacing: 0.15 },
        titleSmall:    { size: 14, weight: Font.Medium,  spacing: 0.1 },
        labelLarge:    { size: 14, weight: Font.Medium,  spacing: 0.1 },
        labelMedium:   { size: 12, weight: Font.Medium,  spacing: 0.5 },
        labelSmall:    { size: 11, weight: Font.Medium,  spacing: 0.5 },
        bodyLarge:     { size: 16, weight: Font.Normal,  spacing: 0.5 },
        bodyMedium:    { size: 14, weight: Font.Normal,  spacing: 0.25 },
        bodySmall:     { size: 12, weight: Font.Normal,  spacing: 0.4 }
    })

    // ── Color Palette ───────────────────────────────────────
    // KEY FIX: `colors` is a BINDING that depends on `_rev`.
    // Every time ThemeBackend emits themeChanged(), `_rev` changes,
    // which forces `colors` to be fully re-evaluated, and every
    // downstream QML binding that reads `ChiTheme.colors.xxx`
    // will also re-evaluate.

    readonly property var colors: {
        // Touch _rev to create a binding dependency
        void(_rev);
        return isDark ? darkPalette() : lightPalette();
    }

    // ── Palette Generators (pure functions) ─────────────────
    function lightPalette() {
        var p = primarySeed;
        return {
            // Primary
            primary:                 p,
            onPrimary:               "#ffffff",
            primaryContainer:        Qt.lighter(p, 1.75),
            onPrimaryContainer:      Qt.darker(p, 2.0),

            // Secondary (desaturated primary)
            secondary:               Qt.hsla(Qt.hsla(p).hslHue, 0.3, 0.40, 1.0).toString(),
            onSecondary:             "#ffffff",
            secondaryContainer:      Qt.hsla(Qt.hsla(p).hslHue, 0.25, 0.88, 1.0).toString(),
            onSecondaryContainer:    Qt.hsla(Qt.hsla(p).hslHue, 0.3, 0.15, 1.0).toString(),

            // Tertiary (complementary hue)
            tertiary:                Qt.hsla((Qt.hsla(p).hslHue + 0.17) % 1.0, 0.45, 0.42, 1.0).toString(),
            onTertiary:              "#ffffff",
            tertiaryContainer:       Qt.hsla((Qt.hsla(p).hslHue + 0.17) % 1.0, 0.5, 0.88, 1.0).toString(),
            onTertiaryContainer:     Qt.hsla((Qt.hsla(p).hslHue + 0.17) % 1.0, 0.4, 0.15, 1.0).toString(),

            // Error
            error:                   "#ba1a1a",
            onError:                 "#ffffff",
            errorContainer:          "#ffdad6",
            onErrorContainer:        "#410002",

            // Surfaces
            surface:                 "#fdf8fd",
            onSurface:               "#1c1b1f",
            surfaceVariant:          "#e7e0ec",
            onSurfaceVariant:        "#49454e",
            surfaceContainerLowest:  "#ffffff",
            surfaceContainerLow:     "#f7f2f7",
            surfaceContainer:        "#f1ecf1",
            surfaceContainerHigh:    "#ebe6eb",
            surfaceContainerHighest: "#e6e1e5",
            surfaceDim:              "#ddd8dd",
            surfaceBright:           "#fdf8fd",

            // Outline
            outline:                 "#79747e",
            outlineVariant:          "#c9c5d0",

            // Inverse
            inverseSurface:          "#313033",
            inverseOnSurface:        "#f4eff4",
            inversePrimary:          Qt.lighter(p, 1.55),

            // Misc
            shadow:                  "#000000",
            scrim:                   "#000000",
            background:              "#fdf8fd",
            onBackground:            "#1c1b1f"
        };
    }

    function darkPalette() {
        var p = primarySeed;
        return {
            // Primary
            primary:                 Qt.lighter(p, 1.55),
            onPrimary:               Qt.darker(p, 1.8),
            primaryContainer:        Qt.darker(p, 1.2),
            onPrimaryContainer:      Qt.lighter(p, 1.75),

            // Secondary
            secondary:               Qt.hsla(Qt.hsla(p).hslHue, 0.25, 0.70, 1.0).toString(),
            onSecondary:             Qt.hsla(Qt.hsla(p).hslHue, 0.3, 0.18, 1.0).toString(),
            secondaryContainer:      Qt.hsla(Qt.hsla(p).hslHue, 0.25, 0.28, 1.0).toString(),
            onSecondaryContainer:    Qt.hsla(Qt.hsla(p).hslHue, 0.25, 0.88, 1.0).toString(),

            // Tertiary
            tertiary:                Qt.hsla((Qt.hsla(p).hslHue + 0.17) % 1.0, 0.40, 0.70, 1.0).toString(),
            onTertiary:              Qt.hsla((Qt.hsla(p).hslHue + 0.17) % 1.0, 0.4, 0.18, 1.0).toString(),
            tertiaryContainer:       Qt.hsla((Qt.hsla(p).hslHue + 0.17) % 1.0, 0.35, 0.30, 1.0).toString(),
            onTertiaryContainer:     Qt.hsla((Qt.hsla(p).hslHue + 0.17) % 1.0, 0.5, 0.88, 1.0).toString(),

            // Error
            error:                   "#ffb4ab",
            onError:                 "#690005",
            errorContainer:          "#93000a",
            onErrorContainer:        "#ffdad6",

            // Surfaces
            surface:                 "#141218",
            onSurface:               "#e6e1e5",
            surfaceVariant:          "#49454e",
            onSurfaceVariant:        "#c9c5d0",
            surfaceContainerLowest:  "#0f0d13",
            surfaceContainerLow:     "#1c1b1f",
            surfaceContainer:        "#201f24",
            surfaceContainerHigh:    "#2b292f",
            surfaceContainerHighest: "#36343a",
            surfaceDim:              "#141218",
            surfaceBright:           "#3b383e",

            // Outline
            outline:                 "#938f99",
            outlineVariant:          "#49454e",

            // Inverse
            inverseSurface:          "#e6e1e5",
            inverseOnSurface:        "#313033",
            inversePrimary:          p,

            // Misc
            shadow:                  "#000000",
            scrim:                   "#000000",
            background:              "#141218",
            onBackground:            "#e6e1e5"
        };
    }

    // ── Convenience: change theme from QML ──────────────────
    function setDarkMode(dark)        { ThemeBackend.isDarkMode = dark; }
    function setPrimaryColor(color)   { ThemeBackend.primaryColor = color; }
    function toggleDarkMode()         { ThemeBackend.isDarkMode = !ThemeBackend.isDarkMode; }
}
