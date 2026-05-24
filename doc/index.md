# Chi UI Library -- API Reference

Chi is a Material 3 expressive UI toolkit for Qt6/QML. Build desktop applications with modern, themeable components.

## Quick Start

    import QtQuick
    import Chi

    ChiApplicationWindow {
        title: "My App"
        showThemeToggle: true

        Button {
            text: "Hello"
            onClicked: console.log("clicked")
        }
    }

## Import

All Chi components are available under the `Chi` module:

    import Chi

Theme tokens are accessed via the `ChiTheme` singleton:

    readonly property var colors: ChiTheme.colors
    readonly property string fontFamily: ChiTheme.fontFamily

## Components

### Infrastructure

These are not instantiated directly -- other components read from them.

| Component | Purpose |
|---|---|
| [ChiTheme](ChiTheme.md) | Theme tokens: colors, typography, dark/light mode |
| [ChiMotion](ChiMotion.md) | Motion/animation tokens |
| [ChiElevation](ChiElevation.md) | Elevation/shadow tokens |
| [IconFont](IconFont.md) | Material Symbols font loader |
| [Icon](Icon.md) | Icon renderer (Material Symbols, SVG, PNG) |
| [Ripple](Ripple.md) | Press feedback layer |
| [StateLayer](StateLayer.md) | Hover/focus/press overlay |

### Application Shell

| Component | Purpose |
|---|---|
| [ChiApplicationWindow](ChiApplicationWindow.md) | Main window with toolbar, menus, sidebar |

### Buttons

| Component | Purpose |
|---|---|
| [Button](Button.md) | Text + icon button (filled, outlined, tonal, elevated) |
| [IconButton](IconButton.md) | Icon-only button |

### Inputs

| Component | Purpose |
|---|---|
| [TextField](TextField.md) | Text input field |
| [Slider](Slider.md) | Continuous/discrete value slider |
| [Checkbox](Checkbox.md) | Toggle checkbox |
| [Switch](Switch.md) | Toggle switch |

### Navigation

| Component | Purpose |
|---|---|
| [TopAppBar](TopAppBar.md) | Top app bar with title and actions |
| [TopAppBarAction](TopAppBarAction.md) | Action item for TopAppBar |
| [Tabs](Tabs.md) | Tab header container |
| [Tab](Tab.md) | Individual tab item |
| [NavigationBarItem](NavigationBarItem.md) | Bottom navigation item |

### Surfaces & Containers

| Component | Purpose |
|---|---|
| [Card](Card.md) | Contained content area |
| [ListItem](ListItem.md) | List row with leading/trailing content |
| [Divider](Divider.md) | Horizontal/vertical divider line |

### Dialogs

| Component | Purpose |
|---|---|
| [Dialog](Dialog.md) | Base modal dialog |
| [AlertDialog](AlertDialog.md) | Single-action dialog |
| [ConfirmDialog](ConfirmDialog.md) | Confirm/cancel dialog |

### Feedback

| Component | Purpose |
|---|---|
| [Snackbar](Snackbar.md) | Temporary message bar |
| [Badge](Badge.md) | Numeric or dot indicator |
| [Tooltip](Tooltip.md) | Hover tooltip |
| [LinearProgressIndicator](LinearProgressIndicator.md) | Linear progress bar |
| [CircularProgressIndicator](CircularProgressIndicator.md) | Circular progress spinner |

## Theme

Chi uses a singleton theme system. All components read from `ChiTheme`:

    ChiTheme.isDarkMode        // bool -- current mode
    ChiTheme.colors            // object -- all M3 color tokens
    ChiTheme.colors.primary    // color -- primary brand color
    ChiTheme.colors.onSurface  // color -- text on surface
    ChiTheme.fontFamily        // string -- "Roboto"
    ChiTheme.iconFamily        // string -- Material Symbols family
    ChiTheme.typography        // object -- font size/weight tokens

Toggle dark/light mode:

    ChiTheme.toggleDarkMode()
    ChiTheme.setDarkMode(true)
    ChiTheme.setPrimaryColor("#6750A4")

## Design Principles

1. **Behavioral contracts first.** If it clicks, it clicks. Visual polish is post-MVP.
2. **No user control.** Chi is a design system, not a walled garden.
3. **Material 3 Expressive.** Components follow M3 specs with expressive motion.
4. **Freedom-first.** Open source, honest, no dark patterns.
