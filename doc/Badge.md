# Badge

A small indicator that can display a number, show a dot, or wrap content. Follows Material 3 badge specifications.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| text | string | "" | Text or number to display. Empty string shows a dot only. |
| showBadge | bool | true | Whether the badge is visible |
| size | string | "small" | Badge size. Values: "small" (dot only), "medium", "large" |
| maxCount | int | 999 | Maximum number before truncating to "999+" |

## Readonly Properties

| Property | Type | Description |
|---|---|---|
| hasText | bool | True when text is non-empty |
| isNumber | bool | True when text is a valid number |
| displayText | string | Truncated display value (e.g. "999+" if exceeding maxCount) |
| isDot | bool | True when showing a dot instead of text |

## Default Property

**content** — The badge wraps children content.

## Usage Example

```qml
Badge {
    text: "3"
    size: "small"

    IconButton {
        iconName: "notifications"
    }
}
```
