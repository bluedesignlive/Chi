# TopAppBarAction

An action item placed in a TopAppBar's actions area. Displays an icon with optional tooltip.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| icon | string | "" | Raw icon source path (SVG, PNG, or qrc path) |
| iconName | string | "" | Named Material Symbol (e.g. "search", "more_vert"). Preferred over raw icon path. |
| tooltip | string | "" | Tooltip text shown on hover |
| enabled | bool | true | Whether the action is clickable |

## Signals

**clicked()** — Emitted when the action is clicked.

## Usage Example

```qml
TopAppBar {
    title: "My App"
    TopAppBarAction { iconName: "search"; onClicked: console.log("search") }
    TopAppBarAction { iconName: "settings"; onClicked: console.log("settings") }
}
```
