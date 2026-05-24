# TextField

## Component Overview

TextField is a text input component following Material Design 3 guidelines. It supports filled and outlined variants, three sizes, leading and trailing icons, password mode with toggle, character count, error state with custom error text, and read-only mode. The text property is an alias to the internal TextInput's text, and the inputField alias provides direct access to the underlying TextInput element.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| text | alias | | Alias to textInput.text; the current text content of the field |
| placeholderText | string | | Placeholder text shown when the field is empty |
| label | string | | Floating label text displayed above or inside the field |
| supportingText | string | | Helper text displayed below the field |
| errorText | string | | Error message text displayed below the field when error is true |
| leadingIcon | string | | Icon source for the leading (left) icon |
| trailingIcon | string | | Icon source for the trailing (right) icon |
| variant | string | "filled" | Visual style variant. Accepted values: "filled", "outlined" |
| size | string | "medium" | Size of the text field. Accepted values: "small", "medium", "large" |
| shape | string | "default" | Corner shape of the text field. Accepted values: "default", "rounded" |
| enabled | bool | true | Whether the text field is interactive |
| error | bool | false | Whether the field is in an error state |
| readOnly | bool | false | Whether the field is read-only |
| password | bool | false | Whether the field masks input for password entry |
| showCharacterCount | bool | false | Whether to display a character count below the field |
| showPasswordToggle | bool | false | Whether to show a toggle button to reveal/hide the password |
| maxLength | int | -1 | Maximum allowed character count; -1 means no limit |

### Aliases

| Alias | Description |
|---|---|
| inputField | Direct access to the internal TextInput element |

## Signals

| Signal | Description |
|---|---|
| accepted() | Emitted when the Return/Enter key is pressed |
| editingFinished() | Emitted when the text field loses focus or Return/Enter is pressed |
| trailingIconClicked() | Emitted when the trailing icon is clicked |
| leadingIconClicked() | Emitted when the leading icon is clicked |

## Methods

| Method | Description |
|---|---|
| clear() | Clears the text content of the field |
| selectAll() | Selects all text in the field |
| forceActiveFocus() | Forces active focus to the text field |
| deselect() | Removes any text selection |
| select(int start, int end) | Selects text from start position to end position |
| positionAt(real x, real y) | Returns the cursor position at the given x, y coordinates |

## Usage Example

```qml
import Chi 0.1

TextField {
    id: emailField
    label: "Email"
    placeholderText: "Enter your email"
    variant: "outlined"
    size: "medium"
    leadingIcon: "icons/email.svg"
    error: false
    errorText: "Please enter a valid email"
    showCharacterCount: false

    onAccepted: {
        console.log("Email entered:", text)
    }

    onLeadingIconClicked: {
        console.log("Leading icon clicked")
    }
}
```
