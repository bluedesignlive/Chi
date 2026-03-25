// SizeSpecs.qml - Centralized Material 3 Expressive Size Specifications
// Single source of truth for all component sizes following Dieter Rams principle #7 (Long-lasting)
// Material 3 Expressive uses larger touch targets for better accessibility

pragma Singleton
import QtQuick

QtObject {
    // ═══════════════════════════════════════════════════════════════════════
    // BUTTON SIZES - Material 3 Expressive (Larger Touch Targets)
    // ═══════════════════════════════════════════════════════════════════════
    // Expressive design prioritizes accessibility with generous touch targets
    // Desktop targets: 40px minimum, Mobile: 48px minimum

    readonly property var button: ({
        // xsmall: Inline actions, dense toolbars, chips
        xsmall: {
            height: 28,
            verticalPadding: 6,
            horizontalPadding: 12,
            gap: 4,
            iconSize: 16,
            typo: "labelSmall",
            squareRadius: 8
        },
        // small: Secondary actions, table rows, filters
        small: {
            height: 36,
            verticalPadding: 8,
            horizontalPadding: 16,
            gap: 6,
            iconSize: 18,
            typo: "labelMedium",
            squareRadius: 10
        },
        // medium: The workhorse; 90% of UI
        medium: {
            height: 44,
            verticalPadding: 10,
            horizontalPadding: 20,
            gap: 8,
            iconSize: 20,
            typo: "labelLarge",
            squareRadius: 12
        },
        // large: Primary CTA, dialog confirm/cancel
        large: {
            height: 52,
            verticalPadding: 12,
            horizontalPadding: 24,
            gap: 8,
            iconSize: 22,
            typo: "titleSmall",
            squareRadius: 14
        },
        // xlarge: Hero actions, onboarding, one per view
        xlarge: {
            height: 60,
            verticalPadding: 16,
            horizontalPadding: 32,
            gap: 10,
            iconSize: 24,
            typo: "titleMedium",
            squareRadius: 16
        }
    })

    // ═══════════════════════════════════════════════════════════════════════
    // ICON BUTTON SIZES
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var iconButton: ({
        xsmall: { height: 36, iconSize: 20, squareRadius: 10, narrowWidth: 28, defaultWidth: 36, wideWidth: 48 },
        small:  { height: 44, iconSize: 24, squareRadius: 12, narrowWidth: 36, defaultWidth: 44, wideWidth: 56 },
        medium: { height: 56, iconSize: 24, squareRadius: 14, narrowWidth: 48, defaultWidth: 56, wideWidth: 68 },
        large:  { height: 72, iconSize: 28, squareRadius: 18, narrowWidth: 60, defaultWidth: 72, wideWidth: 96 },
        xlarge: { height: 96, iconSize: 36, squareRadius: 24, narrowWidth: 80, defaultWidth: 96, wideWidth: 128 }
    })

    // ═══════════════════════════════════════════════════════════════════════
    // FAB SIZES
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var fab: ({
        small:  { size: 44, iconSize: 24, radius: 12 },
        medium: { size: 56, iconSize: 24, radius: 16 },
        large:  { size: 96, iconSize: 36, radius: 28 },
        xlarge: { size: 120, iconSize: 44, radius: 32 }
    })

    // ═══════════════════════════════════════════════════════════════════════
    // TEXT FIELD SIZES
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var textField: ({
        small: {
            height: 48,
            fontSize: 14,
            labelFontSize: 11,
            iconSize: 20,
            horizontalPadding: 12,
            roundedHorizontalPadding: 16,
            iconPadding: 8,
            labelTopPadding: 6,
            inputTopPadding: 20
        },
        medium: {
            height: 56,
            fontSize: 16,
            labelFontSize: 12,
            iconSize: 24,
            horizontalPadding: 16,
            roundedHorizontalPadding: 20,
            iconPadding: 12,
            labelTopPadding: 8,
            inputTopPadding: 24
        },
        large: {
            height: 68,
            fontSize: 18,
            labelFontSize: 12,
            iconSize: 28,
            horizontalPadding: 20,
            roundedHorizontalPadding: 24,
            iconPadding: 16,
            labelTopPadding: 10,
            inputTopPadding: 28
        }
    })

    // ═══════════════════════════════════════════════════════════════════════
    // SEGMENTED BUTTON SIZES
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var segmentedButton: ({
        small:  { height: 36, fontSize: 12, iconSize: 18, padding: 12 },
        medium: { height: 44, fontSize: 14, iconSize: 20, padding: 16 },
        large:  { height: 52, fontSize: 16, iconSize: 22, padding: 20 }
    })

    // ═══════════════════════════════════════════════════════════════════════
    // CHIP SIZES
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var chip: ({
        small:  { height: 28, fontSize: 12, iconSize: 16, padding: 8 },
        medium: { height: 32, fontSize: 14, iconSize: 18, padding: 12 },
        large:  { height: 40, fontSize: 14, iconSize: 20, padding: 16 }
    })

    // ═══════════════════════════════════════════════════════════════════════
    // LIST ITEM SIZES
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var listItem: ({
        small:  { height: 48, iconSize: 20, fontSize: 14, padding: 12 },
        medium: { height: 56, iconSize: 24, fontSize: 16, padding: 16 },
        large:  { height: 72, iconSize: 28, fontSize: 16, padding: 16 }
    })

    // ═══════════════════════════════════════════════════════════════════════
    // NAVIGATION SIZES
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var navigation: ({
        rail: {
            width: 80,
            iconSize: 24,
            indicatorWidth: 56,
            indicatorHeight: 32
        },
        bar: {
            height: 80,
            iconSize: 24,
            labelSize: 12
        },
        drawer: {
            width: 320,
            itemHeight: 56,
            iconSize: 24
        }
    })

    // ═══════════════════════════════════════════════════════════════════════
    // CARD SIZES
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var card: ({
        small:  { cornerRadius: 8, padding: 12 },
        medium: { cornerRadius: 12, padding: 16 },
        large:  { cornerRadius: 16, padding: 24 },
        xlarge: { cornerRadius: 24, padding: 32 }
    })

    // ═══════════════════════════════════════════════════════════════════════
    // HELPER FUNCTIONS
    // ═══════════════════════════════════════════════════════════════════════

    function getSpec(specs, size) {
        return specs[size] ?? specs.medium
    }
}
