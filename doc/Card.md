# Card

Contained content area following Material 3 card specifications. Supports elevated, filled, and outlined variants.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| variant | string | "elevated" | Visual style. Values: "elevated", "filled", "outlined" |
| enabled | bool | true | Whether the card is interactive |
| clickable | bool | false | When true, the card responds to clicks and shows press feedback |
| contentPadding | real | 16 | Internal padding in pixels |
| cornerRadius | real | 12 | Corner rounding in pixels |

## Signals

**clicked()** — Emitted when the card is clicked. Only fires when `clickable` is true.

**pressAndHold()** — Emitted on long press. Only fires when `clickable` is true.

## Usage Example

```qml
Card {
    variant: "elevated"
    clickable: true
    onClicked: console.log("Card clicked")

    Label {
        text: "Card content goes here"
    }
}
```
