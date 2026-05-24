# NavigationBarItem

An individual item used in bottom navigation. Displays an icon, textual label, and optional badge. Follows Material 3 bottom navigation specifications.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| icon | string | "" | Icon path for the inactive state |
| activeIcon | string | "" | Icon path for the active state. Falls back to `icon` if empty. |
| label | string | "" | Display label |
| selected | bool | false | Active/selected state |
| showLabel | bool | true | Whether the label is shown (false = icon only) |
| showBadge | bool | false | Show a badge indicator |
| badgeText | string | "" | Text inside the badge |
| enabled | bool | true | Whether the item is clickable |
| navIndex | int | 0 | Position index in the navigation bar |

## Signals

**clicked()** — Emitted when the item is clicked.

## Usage Example

```qml
NavigationBarItem {
    icon: "qrc:/icons/home.svg"
    activeIcon: "qrc:/icons/home_filled.svg"
    label: "Home"
    selected: currentTab === 0
    onClicked: currentTab = 0
}
```
