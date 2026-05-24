# TopAppBar

Top application bar with title, subtitle, navigation icon, and action items. Supports small, medium, large, and center-aligned variants per Material 3. The bar can collapse on scroll using scrollOffset.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| title | string | "" | Primary title text |
| subtitle | string | "" | Secondary title text (large/medium variants only) |
| variant | string | "small" | Bar style. Values: "small", "medium", "large", "center" |
| navigationIcon | string | "back arrow" | Icon for the navigation button |
| showNavigation | bool | true | Show the navigation icon button |
| elevated | bool | false | Show shadow elevation below the bar |
| scrollOffset | real | 0 | Scroll progress (0 = top, advancing = collapsing toward collapsedHeight) |
| expandedHeight | real | variant-dependent | Full height when expanded |
| collapsedHeight | real | 64 | Minimum height when collapsed |

## Aliases

**actions** — Default property. Add TopAppBarAction children here.

## Readonly Properties

| Property | Type | Description |
|---|---|---|
| isExpanded | bool | True when the bar is in expanded state (medium/large variant) |
| scrollProgress | real | 0.0 to 1.0 progress of collapse animation |
| currentHeight | real | Current animated height between expanded and collapsed |

## Signals

**navigationClicked()** — Emitted when the navigation button is clicked.

## Usage Example

```qml
TopAppBar {
    title: "My App"
    variant: "small"
    showNavigation: true
    onNavigationClicked: drawer.open()

    TopAppBarAction { iconName: "search"; onClicked: searchField.forceActiveFocus() }
    TopAppBarAction { iconName: "more_vert"; onClicked: menu.open() }
}
```
