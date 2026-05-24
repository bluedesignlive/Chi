# ConfirmDialog

## Component Overview

ConfirmDialog extends Dialog to provide a confirmation-style dialog with confirm and dismiss buttons. The message property is wired to the inherited Dialog's supportingText, so the confirmation message is displayed in the dialog body. When the destructive property is true, the confirm button is styled to indicate a destructive action (such as delete). This component is intended for confirm/cancel workflows.

Inherits all properties, signals, and methods from Dialog.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| message | string | | The confirmation message displayed in the dialog body (wired to Dialog's supportingText) |
| confirmButtonText | string | "Confirm" | Label text for the confirm action button |
| dismissButtonText | string | "Cancel" | Label text for the dismiss/cancel action button |
| destructive | bool | false | Whether the confirm action is destructive; styles the confirm button accordingly |

### Inherited Properties

ConfirmDialog inherits all properties from Dialog, including: title, icon, open, modal, closeOnOverlayClick, closeOnEscape, type, size, position, confirmText, showCloseButton, and content.

## Signals

| Signal | Description |
|---|---|
| confirmed() | Emitted when the confirm button is clicked |
| dismissed() | Emitted when the dismiss/cancel button is clicked |

### Inherited Signals

ConfirmDialog inherits all signals from Dialog: opened(), closed(), accepted(), rejected().

## Methods

ConfirmDialog inherits all methods from Dialog: show(), close(), accept(), reject().

## Usage Example

```qml
import Chi 0.1

ConfirmDialog {
    id: deleteConfirm
    title: "Delete Item"
    message: "Are you sure you want to delete this item? This action cannot be undone."
    confirmButtonText: "Delete"
    dismissButtonText: "Cancel"
    destructive: true

    onConfirmed: {
        console.log("Item deleted")
    }

    onDismissed: {
        console.log("Deletion cancelled")
    }
}
```
