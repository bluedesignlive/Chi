# ChiTheme

Singleton that provides all theme tokens: colors, typography, and icons. Shared by every component in Chi. All components read from this singleton — never instantiated directly.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| seed | readonly color | "#673AB7" | The primary color seed used for theme generation |
| fontFamily | readonly string | "Roboto" | Font family for all text |
| iconFamily | readonly string | MaterialSymbols | Icon font family |
| isDarkMode | bool | true | Whether dark mode is active |
| primaryColor | color | seed | The primary brand color, user-configurable |
| colors | readonly var | theme-based | All Material 3 color tokens: primary, onPrimary, secondary, onSecondary, surface, onSurface, surfaceVariant, onSurfaceVariant, etc. |
| typography | readonly var | theme-based | All font size/weight/line-height tokens |
| motion | readonly var | ChiMotion | Motion/animation tokens (read from ChiMotion) |

## Methods

**setDarkMode(bool dark)** — Toggle between dark and light mode.

**setPrimaryColor(color c)** — Change the primary brand color.

**toggleDarkMode()** — Toggle current dark/light mode.

## Usage

All components automatically read from `ChiTheme`. Access in your own QML:

```qml
readonly property var colors: ChiTheme.colors
readonly property string fontFamily: ChiTheme.fontFamily
```
