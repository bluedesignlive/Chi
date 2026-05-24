# ListItem

A single row in a list, supporting leading icons/avatars, primary/secondary/tertiary text, and trailing controls (checkbox, switch, radio, icon, text). Follows Material 3 list item specifications.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| text | string | "" | Primary text |
| secondaryText | string | "" | Secondary line text |
| tertiaryText | string | "" | Third line text |
| leadingIcon | string | "" | Icon source for leading area |
| trailingIcon | string | "" | Icon source for trailing area |
| trailingText | string | "" | Text shown on the trailing side |
| showAvatar | bool | false | Show a circular avatar in the leading area |
| avatarSource | string | "" | Image URL for avatar |
| avatarText | string | "" | Fallback text initial for avatar |
| showCheckbox | bool | false | Show a checkbox in the leading area |
| checked | bool | false | Checkbox/switch/radio checked state |
| showSwitch | bool | false | Show a switch in the trailing area |
| switchChecked | bool | false | Switch state |
| showRadio | bool | false | Show a radio button in the leading area |
| radioChecked | bool | false | Radio button state |
| enabled | bool | true | When false, all interactive elements are disabled and cursor changes to arrow |
| selected | bool | false | Visual selected state |
| size | string | "medium" | Size variant: "small", "medium", "large" |

## Signals

**clicked()** — Emitted when the list item body is clicked.

**checkboxToggled(bool checked)** — Emitted when the checkbox is toggled.

**switchToggled(bool checked)** — Emitted when the switch is toggled.

**radioToggled()** — Emitted when the radio button is toggled.

**trailingClicked()** — Emitted when the trailing icon area is clicked.

## Usage Example

```qml
ListItem {
    text: "Settings"
    secondaryText: "Customize your experience"
    leadingIcon: "settings"
    showSwitch: true
    switchChecked: settingsEnabled
    onSwitchToggled: (checked) => settingsEnabled = checked
}
```
