# Dialog

## Component Overview

Dialog is a modal or modeless dialog component following Material Design 3 guidelines. It displays a title, supporting text, optional icon, and action buttons. The default property is actions, allowing action buttons to be declared directly as children. A custom content component can be provided via the content property. The dialog supports multiple sizes, configurable overlay and escape behavior, and programmatic open/close/accept/reject control.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| title | string | | The title text displayed at the top of the dialog |
| supportingText | string | | Descriptive text displayed below the title |
| icon | string | | Optional icon source displayed in the dialog header |
| open | bool | false | Whether the dialog is currently visible |
| modal | bool | true | Whether the dialog blocks interaction with the parent window |
| closeOnOverlayClick | bool | true | Whether clicking the overlay closes the dialog |
| closeOnEscape | bool | true | Whether pressing Escape closes the dialog |
| type | string | "basic" | The type of dialog layout. Accepted values: "basic" |
| size | string | "medium" | Size of the dialog. Accepted values: "small", "medium", "large" |
| position | string | "center" | Position of the dialog on screen. Accepted values: "center" |
| confirmText | string | "Save" | Label text for the confirm/primary action button |
| showCloseButton | bool | true | Whether to show the close (X) button in the dialog header |
| content | Component | null | A custom Component to render as the dialog body |

### Default Property

| Property | Description |
|---|---|
| actions | Action buttons declared as children are automatically added to the dialog's action area |

## Signals

| Signal | Description |
|---|---|
| opened() | Emitted when the dialog is opened |
| closed() | Emitted when the dialog is closed |
| accepted() | Emitted when the dialog is accepted (confirm button clicked) |
| rejected() | Emitted when the dialog is rejected (cancel/dismiss button clicked) |

## Methods

| Method | Description |
|---|---|
| show() | Opens the dialog |
| close() | Closes the dialog |
| accept() | Accepts the dialog and emits accepted() |
| reject() | Rejects the dialog and emits rejected() |

## Usage Example

```qml
import Chi 0.1

Dialog {
    id: saveDialog
    title: "Save Changes"
    supportingText: "Do you want to save your changes before leaving?"
    icon: "icons/save.svg"
    modal: true
    closeOnOverlayClick: true
    confirmText: "Save"
    size: "medium"

    onAccepted: {
        console.log("Changes saved")
    }

    onRejected: {
        console.log("Changes discarded")
    }

    Button {
        text: "Save"
        onClicked: saveDialog.accept()
    }

    Button {
        text: "Cancel"
        onClicked: saveDialog.reject()
    }
}
```
