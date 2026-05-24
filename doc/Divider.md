# Divider

A thin line that separates content sections. Supports horizontal and vertical orientation with inset variants per Material 3 specifications.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| orientation | string | "horizontal" | Direction of the line. Values: "horizontal", "vertical" |
| inset | bool | false | Shorthand: enables default inset values |
| insetStart | real | 16 | Left (or top) inset in pixels |
| insetEnd | real | 16 | Right (or bottom) inset in pixels |
| variant | string | "full" | Style variant. Values: "full" (edge to edge), "inset" (inset from start), "middle" (inset from both sides) |

## Usage Example

```qml
Column {
    ListItem { text: "First item" }
    Divider { variant: "inset" }
    ListItem { text: "Second item" }
}
```
