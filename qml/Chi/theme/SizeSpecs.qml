// SizeSpecs.qml - Material 3 Expressive Size Specifications
// Single source of truth for all component dimensions
// All values match M3 Expressive specification exactly

pragma Singleton
import QtQuick

QtObject {

    // ═══════════════════════════════════════════════════════════════════════
    // BUTTON SIZES (with icon)
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var button: ({
            xsmall: {
                height: 32,
                verticalPadding: 6,
                horizontalPadding: 12,
                gap: 4,
                iconSize: 20,
                typo: "labelSmall",
                leadingSpace: 12,
                trailingSpace: 12,
                squareRadius: 8,
                outlineWidth: 1,
                pressedRadius: 8,
                fontWeight: Font.Medium,
                fontLetterSpacing: 0.1
            },
            small: {
                height: 40,
                verticalPadding: 10,
                horizontalPadding: 16,
                gap: 6,
                iconSize: 20,
                typo: "labelMedium",
                leadingSpace: 16,
                trailingSpace: 16,
                squareRadius: 10,
                outlineWidth: 1,
                pressedRadius: 4,
                fontWeight: Font.Medium,
                fontLetterSpacing: 0.1
            },
            medium: {
                height: 56,
                verticalPadding: 10,
                horizontalPadding: 24,
                gap: 8,
                iconSize: 24,
                typo: "labelLarge",
                leadingSpace: 24,
                trailingSpace: 24,
                squareRadius: 12,
                outlineWidth: 1,
                pressedRadius: 4,
                fontWeight: Font.Medium,
                fontLetterSpacing: 0
            },
            large: {
                height: 96,
                verticalPadding: 28,
                horizontalPadding: 48,
                gap: 12,
                iconSize: 32,
                typo: "titleMedium",
                leadingSpace: 48,
                trailingSpace: 48,
                squareRadius: 16,
                outlineWidth: 2,
                pressedRadius: 4,
                fontWeight: Font.Normal,
                fontLetterSpacing: 0
            },
            xlarge: {
                height: 136,
                verticalPadding: 36,
                horizontalPadding: 64,
                gap: 16,
                iconSize: 40,
                typo: "headlineSmall",
                leadingSpace: 64,
                trailingSpace: 64,
                squareRadius: 20,
                outlineWidth: 3,
                pressedRadius: 4,
                fontWeight: Font.Normal,
                fontLetterSpacing: 0
            }
        })

    // ═══════════════════════════════════════════════════════════════════════
    // ICON BUTTON SIZES
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var iconButton: ({
            xsmall: {
                height: 32,
                iconSize: 20,
                squareRadius: 8,
                narrowWidth: 24,
                defaultWidth: 32,
                wideWidth: 40,
                narrowLeading: 4,
                narrowTrailing: 4,
                defaultLeading: 6,
                defaultTrailing: 6,
                wideLeading: 10,
                wideTrailing: 10
            },
            small: {
                height: 40,
                iconSize: 20,
                squareRadius: 10,
                narrowWidth: 32,
                defaultWidth: 40,
                wideWidth: 56,
                narrowLeading: 4,
                narrowTrailing: 4,
                defaultLeading: 8,
                defaultTrailing: 8,
                wideLeading: 14,
                wideTrailing: 14
            },
            medium: {
                height: 56,
                iconSize: 24,
                squareRadius: 14,
                narrowWidth: 48,
                defaultWidth: 56,
                wideWidth: 72,
                narrowLeading: 12,
                narrowTrailing: 12,
                defaultLeading: 16,
                defaultTrailing: 16,
                wideLeading: 24,
                wideTrailing: 24
            },
            large: {
                height: 72,
                iconSize: 28,
                squareRadius: 18,
                narrowWidth: 60,
                defaultWidth: 72,
                wideWidth: 96,
                narrowLeading: 16,
                narrowTrailing: 16,
                defaultLeading: 32,
                defaultTrailing: 32,
                wideLeading: 48,
                wideTrailing: 48
            },
            xlarge: {
                height: 96,
                iconSize: 36,
                squareRadius: 24,
                narrowWidth: 80,
                defaultWidth: 96,
                wideWidth: 128,
                narrowLeading: 32,
                narrowTrailing: 32,
                defaultLeading: 48,
                defaultTrailing: 48,
                wideLeading: 72,
                wideTrailing: 72
            }
        })

    // ═══════════════════════════════════════════════════════════════════════
    // FAB SIZES
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var fab: ({
            small: {
                size: 44,
                iconSize: 24,
                radius: 12
            },
            medium: {
                size: 56,
                iconSize: 24,
                radius: 16
            },
            large: {
                size: 96,
                iconSize: 36,
                radius: 28
            }
        })

    // ═══════════════════════════════════════════════════════════════════════
    // EXTENDED FAB SIZES
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var extendedFab: ({
            small: {
                height: 44,
                iconSize: 24,
                leadingSpace: 12,
                trailingSpace: 16,
                radius: 12
            },
            medium: {
                height: 56,
                iconSize: 24,
                leadingSpace: 16,
                trailingSpace: 20,
                radius: 16
            },
            large: {
                height: 96,
                iconSize: 36,
                leadingSpace: 30,
                trailingSpace: 24,
                radius: 28
            }
        })

    // ═══════════════════════════════════════════════════════════════════════
    // SPLIT BUTTON SIZES
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var splitButton: ({
            xsmall: {
                height: 32,
                betweenSpace: 2,
                gap: 4,
                iconSize: 20,
                typo: "labelSmall",
                fontWeight: Font.Medium,
                fontLetterSpacing: 0.1,
                padding: 6,
                leadingLeading: 12,
                leadingTrailing: 10,
                trailingIconSize: 22,
                trailingLeading: 13,
                trailingTrailing: 13,
                outerRadius: 100,
                innerCorner: 4,
                innerCornerPressed: 4,
                outlineWidth: 1,
                squareRadius: 4
            },
            small: {
                height: 40,
                betweenSpace: 2,
                gap: 6,
                iconSize: 20,
                typo: "labelMedium",
                fontWeight: Font.Medium,
                fontLetterSpacing: 0.1,
                padding: 10,
                leadingLeading: 16,
                leadingTrailing: 12,
                trailingIconSize: 22,
                trailingLeading: 13,
                trailingTrailing: 13,
                outerRadius: 100,
                innerCorner: 4,
                innerCornerPressed: 4,
                outlineWidth: 1,
                squareRadius: 4
            },
            medium: {
                height: 56,
                betweenSpace: 2,
                gap: 8,
                iconSize: 24,
                typo: "labelLarge",
                fontWeight: Font.Medium,
                fontLetterSpacing: 0,
                padding: 10,
                leadingLeading: 24,
                leadingTrailing: 24,
                trailingIconSize: 26,
                trailingLeading: 15,
                trailingTrailing: 15,
                outerRadius: 100,
                innerCorner: 4,
                innerCornerPressed: 4,
                outlineWidth: 1,
                squareRadius: 4
            },
            large: {
                height: 96,
                betweenSpace: 2,
                gap: 12,
                iconSize: 32,
                typo: "titleMedium",
                fontWeight: Font.Normal,
                fontLetterSpacing: 0,
                padding: 28,
                leadingLeading: 48,
                leadingTrailing: 48,
                trailingIconSize: 38,
                trailingLeading: 29,
                trailingTrailing: 29,
                outerRadius: 100,
                innerCorner: 8,
                innerCornerPressed: 8,
                outlineWidth: 2,
                squareRadius: 4
            },
            xlarge: {
                height: 136,
                betweenSpace: 2,
                gap: 16,
                iconSize: 40,
                typo: "headlineSmall",
                fontWeight: Font.Normal,
                fontLetterSpacing: 0,
                padding: 36,
                leadingLeading: 64,
                leadingTrailing: 64,
                trailingIconSize: 50,
                trailingLeading: 43,
                trailingTrailing: 43,
                outerRadius: 100,
                innerCorner: 12,
                innerCornerPressed: 12,
                outlineWidth: 3,
                squareRadius: 4
            }
        })

    // ═══════════════════════════════════════════════════════════════════════
    // BUTTON GROUP SIZES
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var buttonGroup: ({
            xsmall: {
                height: 32,
                betweenSpace: 18
            },
            small: {
                height: 40,
                betweenSpace: 12
            },
            medium: {
                height: 56,
                betweenSpace: 8
            },
            large: {
                height: 96,
                betweenSpace: 8
            },
            xlarge: {
                height: 80,
                betweenSpace: 18
            }
        })

    readonly property var connectedButtonGroup: ({
            xsmall: {
                height: 32,
                betweenSpace: 2,
                radius: 100,
                innerRadius: 8,
                iconSize: 18,
                fontSize: 12,
                padding: 12,
                gap: 4,
                minWidth: 36,
                typo: "labelSmall",
                innerPadding: 2,
                outerRadius: 100,
                squareRadius: 8,
                width: 32
            },
            small: {
                height: 40,
                betweenSpace: 2,
                radius: 100,
                innerRadius: 20,
                iconSize: 20,
                fontSize: 14,
                padding: 16,
                gap: 6,
                minWidth: 48,
                typo: "labelMedium",
                innerPadding: 2,
                outerRadius: 100,
                squareRadius: 10,
                width: 40
            },
            medium: {
                height: 56,
                betweenSpace: 2,
                radius: 100,
                innerRadius: 20,
                iconSize: 20,
                fontSize: 16,
                padding: 24,
                gap: 8,
                minWidth: 56,
                typo: "labelLarge",
                innerPadding: 2,
                outerRadius: 100,
                squareRadius: 14,
                width: 56
            },
            large: {
                height: 96,
                betweenSpace: 2,
                radius: 100,
                innerRadius: 16,
                iconSize: 30,
                fontSize: 22,
                padding: 48,
                gap: 12,
                minWidth: 80,
                typo: "titleMedium",
                innerPadding: 2,
                outerRadius: 100,
                squareRadius: 18,
                width: 72
            },
            xlarge: {
                height: 136,
                betweenSpace: 2,
                radius: 100,
                innerRadius: 20,
                iconSize: 40,
                fontSize: 28,
                padding: 64,
                gap: 16,
                minWidth: 100,
                typo: "headlineSmall",
                innerPadding: 2,
                outerRadius: 100,
                squareRadius: 24,
                width: 96
            }
        })

    // ═══════════════════════════════════════════════════════════════════════
    // NAVIGATION BAR
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var navigationBar: ({
            height: 80,
            activeIndicatorHeight: 32,
            activeIndicatorWidth: 64,
            activeIndicatorShape: 100  // pill
            ,
            iconSize: 24,
            labelSize: 12,
            badgeSize: 6,
            largeBadgeSize: 16,
            itemHeight: 64,
            betweenSpace: 0
        })

    // ═══════════════════════════════════════════════════════════════════════
    // NAVIGATION RAIL
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var navigationRail: ({
            collapsedWidth: 80,
            expandedMinWidth: 220,
            expandedMaxWidth: 360,
            itemHeight: 64,
            shortItemHeight: 56,
            iconSize: 24,
            activeIndicatorH: 32,
            activeIndicatorW: 56,
            activeIndicatorShape: 100,
            badgeSize: 6,
            largeBadgeSize: 16,
            betweenItemSpace: 0,
            topSpace: 44
        })

    // ═══════════════════════════════════════════════════════════════════════
    // TOP APP BAR
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var topAppBar: ({
            small: {
                height: 64,
                iconSize: 24
            },
            medium: {
                height: 112,
                iconSize: 24
            },
            large: {
                height: 152,
                iconSize: 24
            }
        })

    // ═══════════════════════════════════════════════════════════════════════
    // APP BAR (bottom)
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var appBar: ({
            height: 64,
            iconSize: 24,
            avatarSize: 32
        })

    // ═══════════════════════════════════════════════════════════════════════
    // TEXT FIELD SIZES
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var textField: ({
            small: {
                height: 48,
                fontSize: 14,
                labelFontSize: 11,
                supportingFontSize: 12,
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
                supportingFontSize: 12,
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
                supportingFontSize: 12,
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
            small: {
                height: 36,
                fontSize: 12,
                iconSize: 18,
                padding: 12
            },
            medium: {
                height: 44,
                fontSize: 14,
                iconSize: 20,
                padding: 16
            },
            large: {
                height: 52,
                fontSize: 16,
                iconSize: 22,
                padding: 20
            }
        })

    // ═══════════════════════════════════════════════════════════════════════
    // CHIP SIZES
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var chip: ({
            small: {
                height: 28,
                fontSize: 12,
                iconSize: 16,
                padding: 8
            },
            medium: {
                height: 32,
                fontSize: 14,
                iconSize: 18,
                padding: 12
            },
            large: {
                height: 40,
                fontSize: 14,
                iconSize: 20,
                padding: 16
            }
        })

    // ═══════════════════════════════════════════════════════════════════════
    // LIST ITEM SIZES
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var listItem: ({
            small: {
                height: 48,
                iconSize: 20,
                fontSize: 14,
                padding: 12
            },
            medium: {
                height: 56,
                iconSize: 24,
                fontSize: 16,
                padding: 16
            },
            large: {
                height: 72,
                iconSize: 28,
                fontSize: 16,
                padding: 16
            }
        })

    // ═══════════════════════════════════════════════════════════════════════
    // NAVIGATION DRAWER
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var navigationDrawer: ({
            width: 320,
            standardItemHeight: 56,
            denseItemHeight: 48,
            iconSize: 24
        })

    // ═══════════════════════════════════════════════════════════════════════
    // BADGE
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var badge: ({
            smallSize: 6,
            mediumSize: 16,
            largeSize: 24
        })

    // ═══════════════════════════════════════════════════════════════════════
    // AVATAR
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var avatar: ({
            xsmall: {
                diameter: 24,
                fontSize: 10,
                iconSize: 14,
                badgeSize: 8
            },
            small: {
                diameter: 32,
                fontSize: 12,
                iconSize: 18,
                badgeSize: 10
            },
            medium: {
                diameter: 40,
                fontSize: 14,
                iconSize: 20,
                badgeSize: 12
            },
            large: {
                diameter: 56,
                fontSize: 20,
                iconSize: 28,
                badgeSize: 14
            },
            xlarge: {
                diameter: 96,
                fontSize: 36,
                iconSize: 48,
                badgeSize: 20
            }
        })

    // ═══════════════════════════════════════════════════════════════════════
    // TREE VIEW
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var treeView: ({
            indentSize: 20,
            rowHeight: 40,
            expandIconSize: 16,
            iconSize: 20,
            fontSize: 14,
            badgeFontSize: 11,
            badgeRadius: 10,
            badgeHeight: 20
        })

    // ═══════════════════════════════════════════════════════════════════════
    // DATA TABLE
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var dataTable: ({
            headerHeight: 56,
            rowHeight: 52,
            checkboxSize: 20,
            checkboxRadius: 2,
            iconSize: 20,
            checkIconSize: 16,
            fontSize: 14,
            columnFontSize: 14,
            sortIconSize: 10,
            supportingFontSize: 12,
            dividerHeight: 1
        })

    // ═══════════════════════════════════════════════════════════════════════
    // ICON LABEL
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var iconLabel: ({
            small: {
                iconSize: 16,
                fontSize: 12
            },
            medium: {
                iconSize: 20,
                fontSize: 14
            },
            large: {
                iconSize: 24,
                fontSize: 16
            }
        })

    // ═══════════════════════════════════════════════════════════════════════
    // TAG
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var tag: ({
            small: {
                height: 20,
                fontSize: 11,
                iconSize: 12,
                padding: 6,
                closeIconOffset: 4
            },
            medium: {
                height: 24,
                fontSize: 12,
                iconSize: 14,
                padding: 8,
                closeIconOffset: 4
            },
            large: {
                height: 32,
                fontSize: 14,
                iconSize: 18,
                padding: 12,
                closeIconOffset: 4
            }
        })

    // ═══════════════════════════════════════════════════════════════════════
    // NUMBER FIELD
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var numberField: ({
            small: {
                height: 32,
                width: 96,
                fontSize: 13,
                buttonSize: 28,
                iconSize: 16
            },
            medium: {
                height: 40,
                width: 120,
                fontSize: 14,
                buttonSize: 36,
                iconSize: 20
            },
            large: {
                height: 48,
                width: 152,
                fontSize: 16,
                buttonSize: 44,
                iconSize: 24
            }
        })

    // ═══════════════════════════════════════════════════════════════════════
    // STEPPER
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var stepper: ({
            small: {
                height: 32,
                width: 96,
                fontSize: 13,
                buttonSize: 28,
                iconSize: 16
            },
            medium: {
                height: 40,
                width: 120,
                fontSize: 14,
                buttonSize: 36,
                iconSize: 20
            },
            large: {
                height: 48,
                width: 152,
                fontSize: 16,
                buttonSize: 44,
                iconSize: 24
            }
        })

    // ═══════════════════════════════════════════════════════════════════════
    // SLIDER
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var slider: ({
            xs: {
                trackH: 16,
                handleH: 44,
                outerR: 16,
                iconSz: 0,
                innerR: 2,
                gap: 6,
                endPad: 4,
                stopDotSz: 4
            },
            small: {
                trackH: 24,
                handleH: 44,
                outerR: 8,
                iconSz: 0,
                innerR: 2,
                gap: 6,
                endPad: 4,
                stopDotSz: 4
            },
            medium: {
                trackH: 40,
                handleH: 52,
                outerR: 12,
                iconSz: 24,
                innerR: 2,
                gap: 6,
                endPad: 4,
                stopDotSz: 4
            },
            large: {
                trackH: 56,
                handleH: 68,
                outerR: 16,
                iconSz: 24,
                innerR: 2,
                gap: 6,
                endPad: 4,
                stopDotSz: 4
            },
            xl: {
                trackH: 96,
                handleH: 108,
                outerR: 28,
                iconSz: 32,
                innerR: 2,
                gap: 6,
                endPad: 4,
                stopDotSz: 4
            }
        })

    // ═══════════════════════════════════════════════════════════════════════
    // CHECKBOX
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var checkbox: ({
            small: {
                boxSize: 16,
                iconSize: 14,
                fontSize: 13,
                gap: 8,
                touchTarget: 40
            },
            medium: {
                boxSize: 20,
                iconSize: 18,
                fontSize: 14,
                gap: 12,
                touchTarget: 40
            },
            large: {
                boxSize: 24,
                iconSize: 22,
                fontSize: 16,
                gap: 16,
                touchTarget: 40
            }
        })

    // ═══════════════════════════════════════════════════════════════════════
    // RADIO BUTTON
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var radioButton: ({
            small: {
                outerSize: 16,
                innerSize: 8,
                fontSize: 13,
                gap: 8,
                touchTarget: 40
            },
            medium: {
                outerSize: 20,
                innerSize: 10,
                fontSize: 14,
                gap: 12,
                touchTarget: 40
            },
            large: {
                outerSize: 24,
                innerSize: 12,
                fontSize: 16,
                gap: 16,
                touchTarget: 40
            }
        })

    // ═══════════════════════════════════════════════════════════════════════
    // SWITCH
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var switch_: ({
            small: {
                trackH: 20,
                trackW: 44,
                handleSize: 16,
                iconSize: 12,
                handleRadius: 100,
                touchTarget: 40
            },
            medium: {
                trackH: 28,
                trackW: 52,
                handleSize: 20,
                iconSize: 14,
                handleRadius: 100,
                touchTarget: 40
            },
            large: {
                trackH: 36,
                trackW: 60,
                handleSize: 28,
                iconSize: 16,
                handleRadius: 100,
                touchTarget: 48
            }
        })

    // ═══════════════════════════════════════════════════════════════════════
    // BREADCRUMB
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var breadcrumb: ({
            height: 32,
            homeIconSize: 16,
            fontSize: 14,
            hoverRadius: 4,
            collapseIconSize: 20,
            betweenSpace: 8
        })

    // ═══════════════════════════════════════════════════════════════════════
    // SEARCH BAR
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var searchBar: ({
            small: {
                height: 44,
                ch: 44,
                fontSize: 14,
                iconSize: 20,
                is: 20,
                leadingPad: 12,
                horizPad: 12,
                hp: 12,
                as: 32,
                isp: 8,
                sih: 44,
                typo: "labelMedium",
                subTypo: "bodySmall"
            },
            medium: {
                height: 56,
                ch: 56,
                fontSize: 16,
                iconSize: 24,
                is: 24,
                leadingPad: 16,
                horizPad: 16,
                hp: 16,
                as: 40,
                isp: 12,
                sih: 52,
                typo: "labelLarge",
                subTypo: "bodyMedium"
            },
            large: {
                height: 64,
                ch: 64,
                fontSize: 18,
                iconSize: 28,
                is: 28,
                leadingPad: 20,
                horizPad: 20,
                hp: 20,
                as: 48,
                isp: 16,
                sih: 60,
                typo: "titleSmall",
                subTypo: "bodyMedium"
            }
        })

    // ═══════════════════════════════════════════════════════════════════════
    // MENU
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var menu: ({
            minWidth: 112,
            maxWidth: 264,
            maxHeight: 400,
            cornerRadius: 12,
            iconSize: 24
        })

    // ═══════════════════════════════════════════════════════════════════════
    // MENU ITEM
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var menuItem: ({
            small: {
                height: 36,
                iconSize: 20,
                chevronSize: 16,
                leadingSpace: 12,
                trailingSpace: 12,
                supportHeight: 0,
                radius: 8,
                dividerMargin: 9
            },
            medium: {
                height: 48,
                iconSize: 24,
                chevronSize: 20,
                leadingSpace: 16,
                trailingSpace: 16,
                supportHeight: 52,
                radius: 12,
                dividerMargin: 9
            },
            large: {
                height: 56,
                iconSize: 24,
                chevronSize: 20,
                leadingSpace: 16,
                trailingSpace: 16,
                supportHeight: 64,
                radius: 12,
                dividerMargin: 9
            }
        })

    // ═══════════════════════════════════════════════════════════════════════
    // DROPDOWN MENU
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var dropdownMenu: ({
            radius: 12,
            borderWidth: 1,
            itemHeight: 40,
            iconSize: 24,
            fontSize: 14,
            dividerHeight: 1,
            horizontalPadding: 16,
            spacing: 10,
            width: 200
        })

    // ═══════════════════════════════════════════════════════════════════════
    // TOOLTIP
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var tooltip: ({
            small: {
                height: 24,
                fontSize: 11,
                iconSize: 16,
                cornerRadius: 4,
                horizPad: 8,
                vertPad: 4
            },
            medium: {
                height: 32,
                fontSize: 12,
                iconSize: 18,
                cornerRadius: 8,
                horizPad: 12,
                vertPad: 6
            },
            large: {
                height: 40,
                fontSize: 14,
                iconSize: 20,
                cornerRadius: 12,
                horizPad: 16,
                vertPad: 8
            }
        })

    // ═══════════════════════════════════════════════════════════════════════
    // TOOLBAR
    // ═══════════════════════════════════════════════════════════════════════

    readonly property var toolbar: ({
            dockedHeight: 64,
            topPad: 8,
            bottomPad: 8,
            iconSize: 24,
            betweenSpace: 8
        })

    // ═══════════════════════════════════════════════════════════════════════
    // HELPER FUNCTIONS
    // ═══════════════════════════════════════════════════════════════════════

    function getSpec(specs, size) {
        return specs[size] ?? specs.medium;
    }
}
