# IconButton

## Component Overview

IconButton is a compact clickable button that displays an icon without a text label. It supports Material Design 3 icon button variants, five sizes from extra-small to extra-large, three width modes, round or square shapes, a selected/toggle state, and an optional tooltip. The iconName property accepts a named Material Symbol for convenient icon selection.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| icon | string | | Icon source (URL or path) to display in the button |
| iconName | string | | Named Material Symbol to display (preferred over icon when using Material Symbols) |
| variant | string | "standard" | Visual style variant. Accepted values: "filled", "tonal", "outlined", "standard" |
| size | string | "medium" | Size of the icon button. Accepted values: "xsmall", "small", "medium", "large", "xlarge" |
| widthMode | string | "default" | Width mode of the button. Accepted values: "narrow", "default", "wide" |
| shape | string | "round" | Shape of the button. Accepted values: "round", "square" |
| enabled | bool | true | Whether the button is interactive |
| selected | bool | false | Whether the button is in a selected/toggled state |
| tooltip | string | | Tooltip text shown on hover |

## Signals

| Signal | Description |
|---|---|
| clicked() | Emitted when the icon button is clicked |

## Methods

| Method | Description |
|---|---|
| activate() | Programmatically activates the icon button as if it were clicked |

## Usage Example

```qml
import Chi 0.1

IconButton {
    iconName: "favorite"
    variant: "tonal"
    size: "medium"
    shape: "round"
    selected: false
    tooltip: "Add to favorites"

    onClicked: {
        selected = !selected
    }
}
```
