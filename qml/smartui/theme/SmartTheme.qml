pragma Singleton
import QtQuick

QtObject {
    id: root

    // ── Mode — bound to ChiTheme so toggling either one syncs both ──
    property bool isDarkMode: ChiTheme.isDarkMode

    readonly property color seed: "#673AB7"

    // ── Colors (direct properties — no .colors. indirection) ─
    readonly property color primary:              isDarkMode ? "#D3BCFD" : "#68548E"
    readonly property color onPrimary:            isDarkMode ? "#38265C" : "#FFFFFF"
    readonly property color primaryContainer:     isDarkMode ? "#4F3D74" : "#EBDDFF"
    readonly property color onPrimaryContainer:   isDarkMode ? "#EBDDFF" : "#230F46"

    readonly property color secondary:            isDarkMode ? "#CDC2DB" : "#635B70"
    readonly property color onSecondary:          isDarkMode ? "#342D40" : "#FFFFFF"
    readonly property color secondaryContainer:   isDarkMode ? "#4B4358" : "#E9DEF8"
    readonly property color onSecondaryContainer: isDarkMode ? "#E9DEF8" : "#1F182B"

    readonly property color tertiary:             isDarkMode ? "#F0B7C5" : "#7E525D"
    readonly property color onTertiary:           isDarkMode ? "#4A2530" : "#FFFFFF"
    readonly property color tertiaryContainer:    isDarkMode ? "#643B46" : "#FFD9E1"
    readonly property color onTertiaryContainer:  isDarkMode ? "#FFD9E1" : "#31101B"

    readonly property color error:                isDarkMode ? "#FFB4AB" : "#BA1A1A"
    readonly property color onError:              isDarkMode ? "#690005" : "#FFFFFF"
    readonly property color errorContainer:       isDarkMode ? "#93000A" : "#FFDAD6"
    readonly property color onErrorContainer:     isDarkMode ? "#FFDAD6" : "#410002"

    readonly property color background:           isDarkMode ? "#151218" : "#FEF7FF"
    readonly property color onBackground:         isDarkMode ? "#E7E0E8" : "#1D1B20"
    readonly property color surface:              isDarkMode ? "#151218" : "#FEF7FF"
    readonly property color onSurface:            isDarkMode ? "#E7E0E8" : "#1D1B20"
    readonly property color surfaceDim:           isDarkMode ? "#151218" : "#DED8E0"
    readonly property color surfaceBright:        isDarkMode ? "#3B383E" : "#FEF7FF"
    readonly property color surfaceVariant:       isDarkMode ? "#49454E" : "#E7E0EB"
    readonly property color onSurfaceVariant:     isDarkMode ? "#CBC4CF" : "#49454E"

    readonly property color surfaceContainerLowest:  isDarkMode ? "#0D0B0F" : "#FFFFFF"
    readonly property color surfaceContainerLow:     isDarkMode ? "#1D1B20" : "#F7F2FA"
    readonly property color surfaceContainer:        isDarkMode ? "#211F24" : "#F3EDF7"
    readonly property color surfaceContainerHigh:    isDarkMode ? "#2C292F" : "#ECE6F0"
    readonly property color surfaceContainerHighest: isDarkMode ? "#36343B" : "#E6E0E9"

    readonly property color outline:              isDarkMode ? "#948F99" : "#7A757F"
    readonly property color outlineVariant:       isDarkMode ? "#49454E" : "#CAC4D0"
    readonly property color shadow:               "#000000"
    readonly property color scrim:                "#000000"
    readonly property color surfaceTint:          isDarkMode ? "#D3BCFD" : "#68548E"

    readonly property color inverseSurface:       isDarkMode ? "#E7E0E8" : "#322F35"
    readonly property color inverseOnSurface:     isDarkMode ? "#322F35" : "#F5EFF7"
    readonly property color inversePrimary:       isDarkMode ? "#68548E" : "#D3BCFD"

    // ── Typography ──────────────────────────────────────────
    readonly property string fontFamily: "Inter"

    readonly property QtObject typography: QtObject {
        readonly property font displayLarge:  Qt.font({family: root.fontFamily, pixelSize: 57, weight: Font.Normal, letterSpacing: -0.25})
        readonly property font displayMedium: Qt.font({family: root.fontFamily, pixelSize: 45, weight: Font.Normal})
        readonly property font displaySmall:  Qt.font({family: root.fontFamily, pixelSize: 36, weight: Font.Normal})

        readonly property font headlineLarge:  Qt.font({family: root.fontFamily, pixelSize: 32, weight: Font.Normal})
        readonly property font headlineMedium: Qt.font({family: root.fontFamily, pixelSize: 28, weight: Font.Normal})
        readonly property font headlineSmall:  Qt.font({family: root.fontFamily, pixelSize: 24, weight: Font.Normal})

        readonly property font titleLarge:  Qt.font({family: root.fontFamily, pixelSize: 22, weight: Font.Medium})
        readonly property font titleMedium: Qt.font({family: root.fontFamily, pixelSize: 16, weight: Font.Medium, letterSpacing: 0.15})
        readonly property font titleSmall:  Qt.font({family: root.fontFamily, pixelSize: 14, weight: Font.Medium, letterSpacing: 0.1})

        readonly property font bodyLarge:  Qt.font({family: root.fontFamily, pixelSize: 16, weight: Font.Normal, letterSpacing: 0.5})
        readonly property font bodyMedium: Qt.font({family: root.fontFamily, pixelSize: 14, weight: Font.Normal, letterSpacing: 0.25})
        readonly property font bodySmall:  Qt.font({family: root.fontFamily, pixelSize: 12, weight: Font.Normal, letterSpacing: 0.4})

        readonly property font labelLarge:  Qt.font({family: root.fontFamily, pixelSize: 14, weight: Font.Medium, letterSpacing: 0.1})
        readonly property font labelMedium: Qt.font({family: root.fontFamily, pixelSize: 12, weight: Font.Medium, letterSpacing: 0.5})
        readonly property font labelSmall:  Qt.font({family: root.fontFamily, pixelSize: 11, weight: Font.Medium, letterSpacing: 0.5})
    }

    // ── Shape ───────────────────────────────────────────────
    readonly property QtObject shape: QtObject {
        readonly property int none:       0
        readonly property int extraSmall: 4
        readonly property int small:      8
        readonly property int medium:     12
        readonly property int large:      16
        readonly property int extraLarge: 28
        readonly property int full:       9999
    }

    // ── Elevation ───────────────────────────────────────────
    readonly property QtObject elevation: QtObject {
        readonly property int level0: 0
        readonly property int level1: 1
        readonly property int level2: 3
        readonly property int level3: 6
        readonly property int level4: 8
        readonly property int level5: 12
    }

    // ── State Layer Opacity ─────────────────────────────────
    readonly property QtObject stateLayer: QtObject {
        readonly property real hover:   0.08
        readonly property real focus:   0.10
        readonly property real pressed: 0.10
        readonly property real dragged: 0.16
    }

    // ── Spacing ─────────────────────────────────────────────
    readonly property QtObject spacing: QtObject {
        readonly property int xs:  4
        readonly property int sm:  8
        readonly property int md:  12
        readonly property int lg:  16
        readonly property int xl:  24
        readonly property int xxl: 32
    }

    // ── Motion ──────────────────────────────────────────────
    readonly property QtObject motion: QtObject {
        readonly property int durationShort1:  50
        readonly property int durationShort2:  100
        readonly property int durationShort3:  150
        readonly property int durationShort4:  200
        readonly property int durationMedium1: 250
        readonly property int durationMedium2: 300
        readonly property int durationMedium3: 350
        readonly property int durationMedium4: 400
        readonly property int durationLong1:   450
        readonly property int durationLong2:   500

        readonly property int easeStandardDecelerate: Easing.OutCubic
        readonly property int easeStandardAccelerate: Easing.InCubic
        readonly property int easeEmphasized:         Easing.OutQuart
        readonly property int easeEmphasizedDecelerate: Easing.OutCubic

        // Legacy aliases (ChiTheme compat)
        readonly property int durationFast:       100
        readonly property int durationMedium:     250
        readonly property int durationSlow:       350
        readonly property int durationExpressive: 600
        readonly property int easeStandard:       Easing.OutCubic
        readonly property int easeBounce:         Easing.OutBounce
        readonly property int easeElastic:        Easing.OutElastic
        readonly property int easeBack:           Easing.OutBack
    }
}
