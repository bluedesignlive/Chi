pragma Singleton
import QtQuick

Item {
    readonly property color seed: "#386a20"

    readonly property var light: ({
        primary: "#386a20",
        onPrimary: "#ffffff",
        primaryContainer: "#b7f397",
        onPrimaryContainer: "#042100",
        secondary: "#55624c",
        onSecondary: "#ffffff",
        secondaryContainer: "#d9e7cb",
        onSecondaryContainer: "#131f0d",
        tertiary: "#386666",
        onTertiary: "#ffffff",
        tertiaryContainer: "#bbebeb",
        onTertiaryContainer: "#002020",
        error: "#ba1a1a",
        onError: "#ffffff",
        errorContainer: "#ffdad6",
        onErrorContainer: "#410002",
        background: "#fdfdf5",
        onBackground: "#1a1c18",
        surface: "#fdfdf5",
        onSurface: "#1a1c18",
        surfaceVariant: "#e0e5d6",
        onSurfaceVariant: "#44483e",
        surfaceContainerLowest: "#ffffff",
        surfaceContainerLow: "#f7f9f1",
        surfaceContainer: "#f1f4ec",
        surfaceContainerHigh: "#ebefe7",
        surfaceContainerHighest: "#e5e9e1",
        outline: "#74796d",
        outlineVariant: "#c4c8ba",
        shadow: "#000000",
        scrim: "#000000",
        surfaceTint: "#386a20",
        inverseSurface: "#2f312c",
        inverseOnSurface: "#f1f1ea",
        inversePrimary: "#9cd67d"
    })

    readonly property var dark: ({
        primary: "#9cd67d",
        onPrimary: "#0c3800",
        primaryContainer: "#20510b",
        onPrimaryContainer: "#b7f397",
        secondary: "#bdcba0",
        onSecondary: "#283420",
        secondaryContainer: "#3e4a36",
        onSecondaryContainer: "#d9e7cb",
        tertiary: "#a0cfcf",
        onTertiary: "#003738",
        tertiaryContainer: "#1e4e4e",
        onTertiaryContainer: "#bbebeb",
        error: "#ffb4ab",
        onError: "#690005",
        errorContainer: "#93000a",
        onErrorContainer: "#ffdad6",
        background: "#1a1c18",
        onBackground: "#e3e3dc",
        surface: "#1a1c18",
        onSurface: "#e3e3dc",
        surfaceVariant: "#44483e",
        onSurfaceVariant: "#c4c8ba",
        surfaceContainerLowest: "#0f110d",
        surfaceContainerLow: "#1a1c18",
        surfaceContainer: "#1e201c",
        surfaceContainerHigh: "#282a26",
        surfaceContainerHighest: "#333530",
        outline: "#8d9286",
        outlineVariant: "#44483e",
        shadow: "#000000",
        scrim: "#000000",
        surfaceTint: "#9cd67d",
        inverseSurface: "#e3e3dc",
        inverseOnSurface: "#2f312c",
        inversePrimary: "#386a20"
    })

    property bool isDarkMode: false
    readonly property var colors: isDarkMode ? dark : light
}
