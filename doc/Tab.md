# Tab

A single tab item inside a Tabs container. Displays text and optional icon with badge.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| text | string | "" | Tab label text |
| icon | string | "" | Icon source |
| showBadge | bool | false | Show a badge indicator on the tab |
| badgeText | string | "" | Text inside the badge |
| variant | string | "primary" | Tab style. Values: "primary" (with indicator), "secondary" |
| selected | bool | false | Visual selected state (managed by parent Tabs) |
| index | int | 0 | Position index in the parent Tabs |

## Readonly Properties

| Property | Type | Description |
|---|---|---|
| contentWidth | real | The implicit width of the tab content |

## Signals

**clicked()** — Emitted when this tab is clicked.

## Usage Example

```qml
Tabs {
    Tab { text: "Inbox"; showBadge: true; badgeText: "3" }
    Tab { text: "Sent" }
    Tab { text: "Drafts" }
}
```
