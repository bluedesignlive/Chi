# ChiElevation

Singleton that provides elevation and shadow values per Material 3 specifications. Defines level-based shadow offsets, blur radius, opacity, and surface tint color.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| level0 | readonly int | 0 | No elevation |
| level1 | readonly int | 1 | Lowest interactive element |
| level2 | readonly int | 3 | Medium interactive element |
| level3 | readonly int | 6 | Elevated surface |
| level4 | readonly int | 8 | Dialogs, floating elements |
| level5 | readonly int | 12 | Top layers, toolbars |
| surfaceTintColor | readonly color | "#6750A4" | The surface tint color used in shadow calculations |

## Methods

**verticalOffset(int level)** — Get the Y offset in pixels for a given elevation level.

**blurRadius(int level)** — Get the shadow blur radius for a given elevation level.

**shadowOpacity(int level)** — Get the shadow opacity as a decimal (0.0 to 1.0) for a given elevation level.

**shadowColor(int level)** — Get the adjusted shadow color for a given elevation level.

## Usage

Components access ChiElevation through `ChiTheme.elevation`. Do not instantiate directly.
