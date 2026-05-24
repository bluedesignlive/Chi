# Checkbox

## Component Overview

Checkbox is a selection control component following Material Design 3 guidelines. It supports checked, unchecked, and indeterminate (mixed) states, an optional label, and three sizes. The indeterminate state is useful for representing partial selections, such as when a subset of child items are selected.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| checked | bool | false | Whether the checkbox is checked |
| indeterminate | bool | false | Whether the checkbox is in an indeterminate (mixed) state |
| label | string | | Optional label text displayed next to the checkbox |
| enabled | bool | true | Whether the checkbox is interactive |
| size | string | "medium" | Size of the checkbox. Accepted values: "small", "medium", "large" |

## Signals

| Signal | Description |
|---|---|
| toggled() | Emitted when the checkbox checked state changes |

## Methods

This component has no additional methods beyond standard QML Item behavior.

## Usage Example

```qml
import Chi 0.1

Checkbox {
    id: acceptTerms
    label: "I agree to the terms and conditions"
    checked: false
    size: "medium"

    onToggled: {
        console.log("Terms accepted:", checked)
    }
}
```
