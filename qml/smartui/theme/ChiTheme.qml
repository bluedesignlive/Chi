// // library/theme/ChiTheme.qml - ADD missing colors
// pragma Singleton
// import QtQuick

// Item {
//     readonly property color seed: "#673AB7"

//     readonly property var light: ({
//         primary: "#68548E",
//         onPrimary: "#FFFFFF",
//         primaryContainer: "#EBDDFF",
//         onPrimaryContainer: "#4F3D74",

//         secondary: "#635B70",
//         onSecondary: "#FFFFFF",
//         secondaryContainer: "#E9DEF8",
//         onSecondaryContainer: "#4B4358",

//         tertiary: "#7E525D",
//         onTertiary: "#FFFFFF",
//         tertiaryContainer: "#FFD9E1",
//         onTertiaryContainer: "#643B46",

//         error: "#BA1A1A",
//         onError: "#FFFFFF",
//         errorContainer: "#FFDAD6",
//         onErrorContainer: "#93000A",

//         background: "#FEF7FF",
//         onBackground: "#1D1B20",
//         surface: "#FEF7FF",
//         onSurface: "#1D1B20",
//         surfaceVariant: "#E7E0EB",
//         onSurfaceVariant: "#49454E",
//         surfaceContainerLow: "#F7F2FA",
//         surfaceContainer: "#F3EDF7",
//         surfaceContainerHighest: "#E6E0E9", //new

//         outline: "#7A757F",
//         outlineVariant: "#CAC4D0",
//         shadow: "#000000",
//         scrim: "#000000",
//         surfaceTint: "#68548E",

//         inverseSurface: "#322F35",
//         inverseOnSurface: "#F5EFF7",
//         inversePrimary: "#D3BCFD"
//     })

//     readonly property var dark: ({
//         primary: "#D3BCFD",
//         onPrimary: "#38265C",
//         primaryContainer: "#4F3D74",
//         onPrimaryContainer: "#EBDDFF",

//         secondary: "#CDC2DB",
//         onSecondary: "#342D40",
//         secondaryContainer: "#4B4358",
//         onSecondaryContainer: "#E9DEF8",

//         tertiary: "#F0B7C5",
//         onTertiary: "#4A2530",
//         tertiaryContainer: "#643B46",
//         onTertiaryContainer: "#FFD9E1",

//         error: "#FFB4AB",
//         onError: "#690005",
//         errorContainer: "#93000A",
//         onErrorContainer: "#FFDAD6",

//         background: "#151218",
//         onBackground: "#E7E0E8",
//         surface: "#151218",
//         onSurface: "#E7E0E8",
//         surfaceVariant: "#49454E",
//         onSurfaceVariant: "#CBC4CF",
//         surfaceContainerLow: "#1E1A20",
//         surfaceContainer: "#1D1B1E",
//         surfaceContainerHighest: "#36343B", //new

//         outline: "#948F99",
//         outlineVariant: "#49454E",
//         shadow: "#000000",
//         scrim: "#000000",
//         surfaceTint: "#D3BCFD",

//         inverseSurface: "#E7E0E8",
//         inverseOnSurface: "#322F35",
//         inversePrimary: "#68548E"
//     })

//     property bool isDarkMode: false
//     readonly property var colors: isDarkMode ? dark : light

//     readonly property QtObject motion: QtObject {
//         readonly property int durationFast: 100
//         readonly property int durationMedium: 250
//         readonly property int durationSlow: 350
//         readonly property int durationExpressive: 600

//         readonly property int easeStandard: Easing.OutCubic
//         readonly property int easeEmphasized: Easing.OutQuart
//         readonly property int easeBounce: Easing.OutBounce
//         readonly property int easeElastic: Easing.OutElastic
//         readonly property int easeBack: Easing.OutBack
//     }
// }


////////////// MONOCROME BLACK & WHITE

// // library/theme/ChiTheme.qml
// pragma Singleton
// import QtQuick

// Item {
//     // Seed is technically Black for monochrome
//     readonly property color seed: "#000000"

//     readonly property var light: ({
//         // Primary: Pure Black for maximum contrast
//         primary: "#000000",
//         onPrimary: "#FFFFFF",
//         primaryContainer: "#3b3b3b",
//         onPrimaryContainer: "#FFFFFF",

//         // Secondary: Dark Gray
//         secondary: "#5e5e5e",
//         onSecondary: "#FFFFFF",
//         secondaryContainer: "#e6e6e6",
//         onSecondaryContainer: "#1b1b1b",

//         // Tertiary: Mid Gray (Distinct from Secondary)
//         tertiary: "#303030",
//         onTertiary: "#FFFFFF",
//         tertiaryContainer: "#d1d1d1",
//         onTertiaryContainer: "#000000",

//         // Error: Kept Red for semantic safety (Standard M3 practice)
//         error: "#ba1a1a",
//         onError: "#FFFFFF",
//         errorContainer: "#ffdad6",
//         onErrorContainer: "#410002",

//         // Backgrounds: Pure Whites and very light grays
//         background: "#f9f9f9",
//         onBackground: "#1c1b1f",
//         surface: "#f9f9f9",
//         onSurface: "#1c1b1f",

//         surfaceVariant: "#e1e2ec",
//         onSurfaceVariant: "#44474f",

//         // Surface Containers (The "Paper" layers)
//         surfaceContainerLow: "#ffffff",
//         surfaceContainer: "#f3f3f3",
//         surfaceContainerHighest: "#e6e6e6",

//         outline: "#74777f",
//         outlineVariant: "#c4c7d0",
//         shadow: "#000000",
//         scrim: "#000000",
//         surfaceTint: "#000000", // Tint matches primary

//         inverseSurface: "#313033",
//         inverseOnSurface: "#f4f3f7",
//         inversePrimary: "#c6c6c6"
//     })

//     readonly property var dark: ({
//         // Primary: Pure White for Dark Mode
//         primary: "#FFFFFF",
//         onPrimary: "#000000",
//         primaryContainer: "#d4d4d4",
//         onPrimaryContainer: "#000000",

//         // Secondary: Light Gray
//         secondary: "#c6c6c6",
//         onSecondary: "#303030",
//         secondaryContainer: "#474747",
//         onSecondaryContainer: "#e6e6e6",

//         // Tertiary: Distinct Silver
//         tertiary: "#e0e0e0",
//         onTertiary: "#000000",
//         tertiaryContainer: "#525252",
//         onTertiaryContainer: "#ffffff",

//         // Error
//         error: "#ffb4ab",
//         onError: "#690005",
//         errorContainer: "#93000a",
//         onErrorContainer: "#ffdad6",

//         // Backgrounds: Near Black (not pure #000000 to prevent OLED smearing)
//         background: "#121212",
//         onBackground: "#e3e2e6",
//         surface: "#121212",
//         onSurface: "#e3e2e6",

//         surfaceVariant: "#44474f",
//         onSurfaceVariant: "#c4c7d0",

//         // Surface Containers (Layers getting lighter as they go up)
//         surfaceContainerLow: "#1c1b1f",
//         surfaceContainer: "#201f23",
//         surfaceContainerHighest: "#2b2930",

//         outline: "#8e9099",
//         outlineVariant: "#44474f",
//         shadow: "#000000",
//         scrim: "#000000",
//         surfaceTint: "#FFFFFF",

//         inverseSurface: "#e3e2e6",
//         inverseOnSurface: "#313033",
//         inversePrimary: "#000000"
//     })

//     property bool isDarkMode: false
//     readonly property var colors: isDarkMode ? dark : light

//     readonly property QtObject motion: QtObject {
//         readonly property int durationFast: 100
//         readonly property int durationMedium: 250
//         readonly property int durationSlow: 350
//         readonly property int durationExpressive: 600

//         readonly property int easeStandard: Easing.OutCubic
//         readonly property int easeEmphasized: Easing.OutQuart
//         readonly property int easeBounce: Easing.OutBounce
//         readonly property int easeElastic: Easing.OutElastic
//         readonly property int easeBack: Easing.OutBack
//     }
// }





//// Grey theme

// // library/theme/ChiTheme.qml
// pragma Singleton
// import QtQuick

// Item {
//     // A soft Slate/Charcoal seed creates that premium "Neutral" look
//     readonly property color seed: "#5d5e66"

//     readonly property var light: ({
//         // Primary is a soft, deep charcoal (not pure black)
//         primary: "#5d5e66",
//         onPrimary: "#ffffff",

//         // This gives you that "Pastel" feel back - a very light silvery lavender
//         primaryContainer: "#e2e2eb",
//         onPrimaryContainer: "#1a1b22",

//         // Secondary is slightly lighter, softer grey
//         secondary: "#5e5e62",
//         onSecondary: "#ffffff",
//         secondaryContainer: "#e3e2e6",
//         onSecondaryContainer: "#1b1b1f",

//         // Tertiary adds a tiny hint of warmth (brown-grey) to break the monotony
//         tertiary: "#605d66",
//         onTertiary: "#ffffff",
//         tertiaryContainer: "#e6e0eb",
//         onTertiaryContainer: "#1c1b22",

//         error: "#ba1a1a",
//         onError: "#ffffff",
//         errorContainer: "#ffdad6",
//         onErrorContainer: "#410002",

//         // Background is OFF-WHITE (Mist), not super white
//         background: "#fbf8fd",
//         onBackground: "#1b1b1f",
//         surface: "#fbf8fd",
//         onSurface: "#1b1b1f",

//         // Surface Variant is a soft stone color
//         surfaceVariant: "#e4e2e7",
//         onSurfaceVariant: "#46464b",

//         surfaceContainerLow: "#f5f2f7",
//         surfaceContainer: "#efedf1",
//         surfaceContainerHighest: "#e9e7ec",

//         outline: "#77777b",
//         outlineVariant: "#c7c6cb",
//         shadow: "#000000",
//         scrim: "#000000",
//         surfaceTint: "#5d5e66",

//         inverseSurface: "#303034",
//         inverseOnSurface: "#f3f0f4",
//         inversePrimary: "#c6c6cf"
//     })

//     readonly property var dark: ({
//         // Primary is a pastel "Moonlight" silver
//         primary: "#c6c6cf",
//         onPrimary: "#2f3037",
//         primaryContainer: "#45464e",
//         onPrimaryContainer: "#e2e2eb",

//         // Secondary is a soft pewter
//         secondary: "#c7c6ca",
//         onSecondary: "#303034",
//         secondaryContainer: "#46474b",
//         onSecondaryContainer: "#e3e2e6",

//         tertiary: "#cac3ce",
//         onTertiary: "#312f37",
//         tertiaryContainer: "#48464e",
//         onTertiaryContainer: "#e6e0eb",

//         error: "#ffb4ab",
//         onError: "#690005",
//         errorContainer: "#93000a",
//         onErrorContainer: "#ffdad6",

//         // Background is Dark Gunmetal, not Pitch Black
//         background: "#131316",
//         onBackground: "#e4e2e6",
//         surface: "#131316",
//         onSurface: "#e4e2e6",

//         surfaceVariant: "#46464b",
//         onSurfaceVariant: "#c7c6cb",

//         surfaceContainerLow: "#1b1b1f",
//         surfaceContainer: "#1f1f23",
//         surfaceContainerHighest: "#2a2a2e",

//         outline: "#919095",
//         outlineVariant: "#46464b",
//         shadow: "#000000",
//         scrim: "#000000",
//         surfaceTint: "#c6c6cf",

//         inverseSurface: "#e4e2e6",
//         inverseOnSurface: "#303034",
//         inversePrimary: "#5d5e66"
//     })

//     property bool isDarkMode: false
//     readonly property var colors: isDarkMode ? dark : light

//     readonly property QtObject motion: QtObject {
//         readonly property int durationFast: 100
//         readonly property int durationMedium: 250
//         readonly property int durationSlow: 350
//         readonly property int durationExpressive: 600

//         readonly property int easeStandard: Easing.OutCubic
//         readonly property int easeEmphasized: Easing.OutQuart
//         readonly property int easeBounce: Easing.OutBounce
//         readonly property int easeElastic: Easing.OutElastic
//         readonly property int easeBack: Easing.OutBack
//     }
// }




//////////////// Forest ChiTheme

// library/theme/ChiTheme.qml
pragma Singleton
import QtQuick

Item {
    // Seed: A natural, leafy Forest Green
    readonly property color seed: "#386a20"

    readonly property var light: ({
        // Primary: Deep Leaf Green
        primary: "#386a20",
        onPrimary: "#ffffff",

        // This is the "Pastel" highlight you want (Soft Mint/Lime)
        primaryContainer: "#b7f397",
        onPrimaryContainer: "#042100",

        // Secondary: Olive-Grey (Earthy)
        secondary: "#55624c",
        onSecondary: "#ffffff",
        secondaryContainer: "#d9e7cb",
        onSecondaryContainer: "#131f0d",

        // Tertiary: A cool Teal/Turquoise to balance the warm greens
        tertiary: "#386666",
        onTertiary: "#ffffff",
        tertiaryContainer: "#bbebeb",
        onTertiaryContainer: "#002020",

        // Error: Standard Red
        error: "#ba1a1a",
        onError: "#ffffff",
        errorContainer: "#ffdad6",
        onErrorContainer: "#410002",

        // Background: Very faint Cream/Green tint (Not stark white)
        background: "#fdfdf5",
        onBackground: "#1a1c18",
        surface: "#fdfdf5",
        onSurface: "#1a1c18",

        // Surface Variant: Soft Mossy Grey
        surfaceVariant: "#e0e5d6",
        onSurfaceVariant: "#44483e",

        surfaceContainerLow: "#f7f9f1",
        surfaceContainer: "#f1f4ec",
        surfaceContainerHighest: "#ebefe7",

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
        // Primary: Luminous Sage Green
        primary: "#9cd67d",
        onPrimary: "#0c3800",
        primaryContainer: "#20510b",
        onPrimaryContainer: "#b7f397",

        // Secondary: Muted light green
        secondary: "#bdcba0",
        onSecondary: "#283420",
        secondaryContainer: "#3e4a36",
        onSecondaryContainer: "#d9e7cb",

        // Tertiary: Soft Aqua
        tertiary: "#a0cfcf",
        onTertiary: "#003738",
        tertiaryContainer: "#1e4e4e",
        onTertiaryContainer: "#bbebeb",

        error: "#ffb4ab",
        onError: "#690005",
        errorContainer: "#93000a",
        onErrorContainer: "#ffdad6",

        // Background: Deep Pine/Charcoal (Not black)
        background: "#1a1c18",
        onBackground: "#e3e3dc",
        surface: "#1a1c18",
        onSurface: "#e3e3dc",

        surfaceVariant: "#44483e",
        onSurfaceVariant: "#c4c8ba",

        surfaceContainerLow: "#1d1f1b",
        surfaceContainer: "#21231f",
        surfaceContainerHighest: "#2c2e29",

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
