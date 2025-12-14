// pragma Singleton
// import QtQuick

// Item {
//     readonly property color seed: "#386a20"

//     readonly property var light: ({
//         primary: "#386a20",
//         onPrimary: "#ffffff",
//         primaryContainer: "#b7f397",
//         onPrimaryContainer: "#042100",
//         secondary: "#55624c",
//         onSecondary: "#ffffff",
//         secondaryContainer: "#d9e7cb",
//         onSecondaryContainer: "#131f0d",
//         tertiary: "#386666",
//         onTertiary: "#ffffff",
//         tertiaryContainer: "#bbebeb",
//         onTertiaryContainer: "#002020",
//         error: "#ba1a1a",
//         onError: "#ffffff",
//         errorContainer: "#ffdad6",
//         onErrorContainer: "#410002",
//         background: "#fdfdf5",
//         onBackground: "#1a1c18",
//         surface: "#fdfdf5",
//         onSurface: "#1a1c18",
//         surfaceVariant: "#e0e5d6",
//         onSurfaceVariant: "#44483e",
//         surfaceContainerLowest: "#ffffff",
//         surfaceContainerLow: "#f7f9f1",
//         surfaceContainer: "#f1f4ec",
//         surfaceContainerHigh: "#ebefe7",
//         surfaceContainerHighest: "#e5e9e1",
//         outline: "#74796d",
//         outlineVariant: "#c4c8ba",
//         shadow: "#000000",
//         scrim: "#000000",
//         surfaceTint: "#386a20",
//         inverseSurface: "#2f312c",
//         inverseOnSurface: "#f1f1ea",
//         inversePrimary: "#9cd67d"
//     })

//     readonly property var dark: ({
//         primary: "#9cd67d",
//         onPrimary: "#0c3800",
//         primaryContainer: "#20510b",
//         onPrimaryContainer: "#b7f397",
//         secondary: "#bdcba0",
//         onSecondary: "#283420",
//         secondaryContainer: "#3e4a36",
//         onSecondaryContainer: "#d9e7cb",
//         tertiary: "#a0cfcf",
//         onTertiary: "#003738",
//         tertiaryContainer: "#1e4e4e",
//         onTertiaryContainer: "#bbebeb",
//         error: "#ffb4ab",
//         onError: "#690005",
//         errorContainer: "#93000a",
//         onErrorContainer: "#ffdad6",
//         background: "#1a1c18",
//         onBackground: "#e3e3dc",
//         surface: "#1a1c18",
//         onSurface: "#e3e3dc",
//         surfaceVariant: "#44483e",
//         onSurfaceVariant: "#c4c8ba",
//         surfaceContainerLowest: "#0f110d",
//         surfaceContainerLow: "#1a1c18",
//         surfaceContainer: "#1e201c",
//         surfaceContainerHigh: "#282a26",
//         surfaceContainerHighest: "#333530",
//         outline: "#8d9286",
//         outlineVariant: "#44483e",
//         shadow: "#000000",
//         scrim: "#000000",
//         surfaceTint: "#9cd67d",
//         inverseSurface: "#e3e3dc",
//         inverseOnSurface: "#2f312c",
//         inversePrimary: "#386a20"
//     })

//     property bool isDarkMode: false
//     readonly property var colors: isDarkMode ? dark : light
// }


// library/theme/ChiTheme.qml - ADD missing colors
pragma Singleton
import QtQuick

Item {
    readonly property color seed: "#673AB7"

    readonly property var light: ({
        primary: "#68548E",
        onPrimary: "#FFFFFF",
        primaryContainer: "#EBDDFF",
        onPrimaryContainer: "#4F3D74",

        secondary: "#635B70",
        onSecondary: "#FFFFFF",
        secondaryContainer: "#E9DEF8",
        onSecondaryContainer: "#4B4358",

        tertiary: "#7E525D",
        onTertiary: "#FFFFFF",
        tertiaryContainer: "#FFD9E1",
        onTertiaryContainer: "#643B46",

        error: "#BA1A1A",
        onError: "#FFFFFF",
        errorContainer: "#FFDAD6",
        onErrorContainer: "#93000A",

        background: "#FEF7FF",
        onBackground: "#1D1B20",
        surface: "#FEF7FF",
        onSurface: "#1D1B20",
        surfaceVariant: "#E7E0EB",
        onSurfaceVariant: "#49454E",
        surfaceContainerLow: "#F7F2FA",
        surfaceContainer: "#F3EDF7",
        surfaceContainerHighest: "#E6E0E9", //new

        outline: "#7A757F",
        outlineVariant: "#CAC4D0",
        shadow: "#000000",
        scrim: "#000000",
        surfaceTint: "#68548E",

        inverseSurface: "#322F35",
        inverseOnSurface: "#F5EFF7",
        inversePrimary: "#D3BCFD"
    })

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
        surfaceVariant: "#49454E",
        onSurfaceVariant: "#CBC4CF",
        surfaceContainerLow: "#1E1A20",
        surfaceContainer: "#1D1B1E",
        surfaceContainerHighest: "#36343B", //new

        outline: "#948F99",
        outlineVariant: "#49454E",
        shadow: "#000000",
        scrim: "#000000",
        surfaceTint: "#D3BCFD",

        inverseSurface: "#E7E0E8",
        inverseOnSurface: "#322F35",
        inversePrimary: "#68548E"
    })

    property bool isDarkMode: false
    readonly property var colors: isDarkMode ? dark : light

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
    }
}
