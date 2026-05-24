# AlertDialog

## Component Overview

AlertDialog extends Dialog to provide an alert-style dialog for displaying important messages or warnings to the user. It features configurable confirm and dismiss button variants (text, filled, etc.) and a destructive flag for styling the confirm button as a dangerous action. The dismiss button text defaults to an empty string, meaning the dismiss button is hidden by default unless dismissButtonText is set.

Inherits all properties, signals, and methods from Dialog.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| confirmButtonText | string | "OK" | Label text for the confirm action button |
| dismissButtonText | string | "" | Label text for the dismiss/cancel action button; empty string hides the dismiss button |
| confirmButtonVariant | string | "text" | Visual variant for the confirm button. Accepted values: "text" and other Button variant values |
| dismissButtonVariant | string | "text" | Visual variant for the dismiss button. Accepted values: "text" and other Button variant values |
| destructive | bool | false | Whether the confirm action is destructive; styles the confirm button accordingly |

### Inherited Properties

AlertDialog inherits all properties from Dialog, including: title, supportingText, icon, open, modal, closeOnOverlayClick, closeOnEscape, type, size, position, confirmText, showCloseButton, and content.

## Signals

AlertDialog inherits all signals from Dialog: opened(), closed(), accepted(), rejected().

## Methods

AlertDialog inherits all methods from Dialog: show(), close(), accept(), reject().

## Usage Example

```qml
import Chi 0.1

AlertDialog {
    id: warningAlert
    title: "Warning"
    supportingText: "Your session will expire in 5 minutes."
    confirmButtonText: "OK"
    confirmButtonVariant: "text"
    destructive: false

    onAccepted: {
        console.log("Alert acknowledged")
    }
}
```
