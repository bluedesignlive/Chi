# Switch

## Component Overview

Switch is a toggle control component following Material Design 3 guidelines. It represents a binary on/off choice with an optional icon displayed on the thumb. The switch supports three sizes and an icon that is shown when showIcon is true.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| checked | bool | false | Whether the switch is in the on (checked) position |
| enabled | bool | true | Whether the switch is interactive |
| showIcon | bool | false | Whether to display an icon on the switch thumb |
| icon | string | "checkmark" | The icon to display on the thumb when showIcon is true |
| size | string | "medium" | Size of the switch. Accepted values: "small", "medium", "large" |

## Signals

| Signal | Description |
|---|---|
| toggled() | Emitted when the switch checked state changes |

## Methods

This component has no additional methods beyond standard QML Item behavior.

## Usage Example

```qml
import Chi 0.1

Switch {
    id: darkModeSwitch
    checked: false
    showIcon: true
    icon: "checkmark"
    size: "medium"

    onToggled: {
        console.log("Dark mode:", checked)
    }
}
```
