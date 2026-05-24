# Snackbar

A temporary message bar at the bottom or top of the screen. Supports an optional action button and close icon per Material 3 specifications.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| text | string | "" | Message text |
| actionText | string | "" | Label for the action button. If empty, no action button is shown. |
| showClose | bool | false | Show a close/dismiss icon |
| duration | int | 4000 | Auto-dismiss timeout in milliseconds. Set 0 for infinite. |
| position | string | "bottom" | Position. Values: "bottom", "top" |
| multiLine | bool | false | Allow multi-line message text |
| longerAction | bool | false | Place the action button on a separate line |

## Readonly Properties

| Property | Type | Description |
|---|---|---|
| hasAction | bool | True when actionText is non-empty |
| isShowing | bool | True when the snackbar is currently visible |

## Signals

**actionClicked()** — Emitted when the action button is clicked.

**closed()** — Emitted when the snackbar hides (timer or manual).

## Methods

**show(message, action, closeable)** — Show the snackbar. Parameters: message (string), action label (string), closeable (bool).

**hide()** — Dismiss the snackbar immediately.

## Usage Example

```qml
Snackbar {
    id: snackbar
    onActionClicked: undoLastAction()
}

// Trigger:
snackbar.show("Item deleted", "UNDO", true)
```
