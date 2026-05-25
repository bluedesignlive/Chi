# AGENTS.md

Chi UI Library — AI agent context.

## Project

Chi (`Chi-last-broke`) is a Qt6/QML Material 3 component library for Unix desktop applications. It ships as a set of reusable QML components with a shared theme/motion/elevation singleton system.

## Architecture

    qml/Chi/ui/             # All components
      applicationwindow/      # ChiApplicationWindow
      Buttons/                # Button, IconButton
      inputs/                 # TextField, Slider
      selection/              # Checkbox, Switch
      dialogs/                # Dialog, AlertDialog, ConfirmDialog
      lists/                  # ListItem
      containers/             # Card, Divider
      navigation/             # TopAppBar, TopAppBarAction, Tabs, Tab
      feedback/               # Snackbar, Badge
      progress/               # LinearProgressIndicator, CircularProgressIndicator
      menus/                  # Tooltip
    qml/Chi/theme/            # Theme singletons
      ChiTheme.qml            # Colors, typography, icons
      ChiMotion.qml           # Animation tokens
      ChiElevation.qml        # Shadow tokens
      IconFont.qml            # Material Symbols
    qml/Chi/ui/common/        # Shared internals
      Icon.qml, Ripple.qml, StateLayer.qml

All components read from the `ChiTheme` singleton (colors, typography). Motion tokens from `ChiMotion`. Shadows from `ChiElevation`.

## Import Path

    import Chi              # Components
    import ChiTheme         # Theme tokens (used internally by all components)

## Component Philosophy

- **Behavioral contracts first.** If it clicks, it clicks. Visual polish is post-MVP.
- **No user control.** Chi is a design system, not a walled garden.
- **Material 3 Expressive.** Components follow M3 specs with expressive motion.
- **Freedom-first.** Open source, honest, no dark patterns.

## Critical Conventions

- Use `iconName` (Material Symbol name) over raw `icon` path for IconButton and TopAppBarAction.
- Dialog variants (AlertDialog, ConfirmDialog) extend Dialog. Use `open` property to show (`myDialog.open = true` not `myDialog.open()`).
- Chi components use `enabled` not `activeFocusOnTab` for disable states. See Slider.md for counter-example (did not implement for that release).
- Theme toggling: `ChiTheme.toggleDarkMode()` changes `isDarkMode` which drives all component colors reactively.
- Every component reads `readonly property var colors: ChiTheme.colors` — do not cache color values.

## Platform Detection

ChiApplicationWindow exposes a `context` object:

    context.isMacOS      context.isWindows    context.isLinux
    context.isMobile     context.isDesktop    context.isWeb
    context.breakpoint     // "compact" | "medium" | "expanded" | "large" | "xlarge"

## Builder's Orders (do not change without discussing)

This project is the source of truth for the "Chi" UI library. The user is building their own operating system, not a distro. Chi components are baked directly into the OS image. Any component change must preserve behavioral contracts — the user ships this to end users.

## Current Status

MVP components: 20/20 pass behavioral contracts after 8 recent fixes (IconButton, ListItem, ConfirmDialog, Dialog, Tooltip, Slider, Card, TopAppBar). See MVP-COMPONENTS.md for full spec. Components are shippable.

Doc: `doc/` directory contains per-component API reference with properties, signals, methods, and usage examples.

## Website (GitHub Pages)

    https://bluedesignlive.github.io/Chi/

Single-page HTML with 4 routes: `/` (framework), `/apps`, `/theme`, `/docs`. Source in `docs/index.html`. Uses hash-based SPA routing, live theme playground with CSS variable injection from seed color, interactive component gallery, dark/light mode persistence, and copy buttons on all code blocks. Deploys from `main` branch, `/docs` folder.
