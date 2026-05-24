# Tooltip

A floating label that appears near a target element on hover or focus. Follows Material 3 tooltip specifications. Supports rich tooltips, caret arrow, and configurable position.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| text | string | "" | Tooltip content |
| target | Item | null | The item this tooltip is attached to |
| position | string | "bottom" | Position relative to target. Values: "top", "bottom", "left", "right" |
| delay | int | 300 | Delay in ms before showing (M3 spec: 300ms) |
| showDuration | int | 0 | How long to stay visible (0 = until mouse leaves) |
| rich | bool | false | True for rich text rendering |
| showCaret | bool | false | Show the directional caret arrow (false = plain M3 style) |
| ready | bool | false | When true, skip the delay (useful for grouped hot tooltips) |

## Readonly Properties

| Property | Type | Description |
|---|---|---|
| isVisible | bool | True when the tooltip is currently shown |

## Signals

**shown()** — Emitted when the tooltip becomes visible.

## Methods

**show()** — Manually show the tooltip.

**hide()** — Manually hide the tooltip.

## Usage Example

```qml
Button {
    id: saveBtn
    text: "Save"

    Tooltip {
        text: "Save the current document (Ctrl+S)"
        target: saveBtn
        position: "bottom"
    }
}
```
