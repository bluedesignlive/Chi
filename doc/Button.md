# Button

## Component Overview

Button is a versatile clickable button component following Material Design 3 guidelines. It supports multiple variants (filled, elevated, tonal, outlined), three sizes, round or square shapes, optional icon display, and a loading state that disables interaction and shows a spinner.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| text | string | "Button" | The label text displayed on the button |
| variant | string | "filled" | Visual style variant. Accepted values: "filled", "elevated", "tonal", "outlined" |
| size | string | "medium" | Size of the button. Accepted values: "small", "medium", "large" |
| shape | string | "round" | Shape of the button corners. Accepted values: "round", "square" |
| icon | string | | Icon source to display alongside the text |
| showIcon | bool | false | Whether to display the icon on the button |
| enabled | bool | true | Whether the button is interactive |
| loading | bool | false | Whether the button is in a loading state; shows a spinner and disables interaction |

## Signals

| Signal | Description |
|---|---|
| clicked() | Emitted when the button is clicked |

## Methods

| Method | Description |
|---|---|
| activate() | Programmatically activates the button as if it were clicked |

## Usage Example

```qml
import Chi 0.1

Button {
    text: "Submit"
    variant: "filled"
    size: "medium"
    shape: "round"
    icon: "icons/send.svg"
    showIcon: true
    loading: false

    onClicked: {
        console.log("Button clicked")
    }
}
```
