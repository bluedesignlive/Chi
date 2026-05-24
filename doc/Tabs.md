# Tabs

A horizontal container for Tab items with an animated selection indicator. Manages currentIndex and indicator positioning per Material 3 specifications.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| currentIndex | int | 0 | Index of the currently selected tab |
| scrollable | bool | false | When true, tabs scroll horizontally instead of fitting to width |

## Aliases

**contentChildren** (readonly) — Access to the tab child items.

## Default Property

**tabs** — Add Tab children directly inside Tabs.

## Signals

**tabClicked(int index)** — Emitted when a tab is clicked, with its index.

## Methods

**updateTabs()** — Recalculate tab layout and indicator position.

**updateIndicator()** — Reposition the selection indicator.

**ensureVisible(item)** — Scroll to make the given tab item visible (scrollable mode).

## Usage Example

```qml
Tabs {
    id: tabs
    currentIndex: 0

    Tab { text: "Home" }
    Tab { text: "Search" }
    Tab { text: "Profile" }

    onTabClicked: (index) => swipeView.currentIndex = index
}
```
