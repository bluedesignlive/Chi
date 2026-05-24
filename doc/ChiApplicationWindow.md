# ChiApplicationWindow

## Component Overview

ChiApplicationWindow is the main window component for Chi UI applications. It provides a full-featured application shell with a toolbar, optional sidebar toggle, window controls (minimize, maximize, close), theme toggle, and platform-adaptive behavior. The component automatically detects the operating system and adjusts window control placement and style accordingly. A context object exposes platform and window state information to all children.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| title | string | | The title displayed in the application toolbar |
| showControls | bool | true | Whether to show the window control buttons (minimize, maximize, close) |
| showThemeToggle | bool | true | Whether to show the theme toggle button in the toolbar |
| leadingIcon | string | | Icon source for the leading action button in the toolbar |
| showTitle | bool | true | Whether to display the title text in the toolbar |
| centerTitle | bool | true | Whether to center the title text within the toolbar |
| toolbarBehavior | string | "visible" | Toolbar visibility behavior. Accepted values: "visible" (always visible), "autoHide" (hides on scroll/timeout) |
| showSidebarButton | bool | | Whether to show the sidebar toggle button in the toolbar |
| sidebarOpen | bool | | Whether the sidebar is currently open |
| controlsStyle | string | "macOS" | Style of the window controls. Common value: "macOS" (traffic-light style on macOS) |
| colors | var | | Color configuration object for theming the window |
| fontFamily | readonly string | | The font family currently applied to the application window |

### Context Object Properties

The ChiApplicationWindow provides a context object with the following properties accessible from all children:

| Property | Type | Description |
|---|---|---|
| isMacOS | bool | Whether the application is running on macOS |
| isWindows | bool | Whether the application is running on Windows |
| isLinux | bool | Whether the application is running on Linux |
| isMobile | bool | Whether the application is running on a mobile platform |
| isDesktop | bool | Whether the application is running on a desktop platform |
| breakpoint | string | Current responsive breakpoint. Values: "compact", "medium", "expanded", "large", "xlarge" |
| isMaximized | bool | Whether the window is currently maximized |
| isFullScreen | bool | Whether the window is currently in full-screen mode |
| windowRadius | real | The current border radius of the window (varies by platform and window state) |

## Signals

| Signal | Description |
|---|---|
| leadingActionTriggered() | Emitted when the leading icon/button in the toolbar is clicked |
| toolbarActionTriggered(int index) | Emitted when a toolbar action button is clicked, with the button index |
| menuItemTriggered(string menuId, string itemId) | Emitted when a menu item is triggered, providing the menu and item identifiers |
| sidebarButtonClicked() | Emitted when the sidebar toggle button is clicked |

## Methods

| Method | Description |
|---|---|
| showToolbar() | Shows the toolbar |
| hideToolbar() | Hides the toolbar |
| toggleToolbar() | Toggles the toolbar visibility |
| setMenuStyle(string style) | Sets the menu bar style to the given style string |

## Usage Example

```qml
import Chi 0.1

ChiApplicationWindow {
    id: window
    title: "My Application"
    showControls: true
    showThemeToggle: true
    centerTitle: true
    toolbarBehavior: "visible"
    showSidebarButton: true
    sidebarOpen: false
    controlsStyle: "macOS"

    onLeadingActionTriggered: {
        console.log("Leading action triggered")
    }

    onMenuItemTriggered: function(menuId, itemId) {
        console.log("Menu item triggered:", menuId, itemId)
    }

    onSidebarButtonClicked: {
        sidebarOpen = !sidebarOpen
    }
}
```
