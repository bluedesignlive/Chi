# Chi MVP — Minimal Usable Components

Every component listed here must achieve its behavioral contract before the library ships.
Animations, transitions, motion, elevation, and visual polish are **post-MVP**.
If it clicks, it clicks. If it doesn't, it's broken.

---

## Infrastructure (not user-facing, but required)

These have no standalone behavior to test. They exist because other components depend on them.

| Component | Purpose |
|---|---|
| ChiTheme | Theme token resolution — colors, spacing, typography. Other components read from this. |
| ChiMotion | Motion/animation tokens. Ships as reference but not enforced in MVP. |
| ChiElevation | Elevation/shadow tokens. Same — reference, not enforced. |
| ShapeTokens | Corner radius and shape definitions. |
| SizeSpecs | Sizing and spacing constants. |
| IconFont | Maps icon names to font glyph codes (Material Symbols). |
| Ripple | Press feedback layer. MVP: just needs to visually indicate press. |
| StateLayer | Hover/focus/press overlay. MVP: just needs to visually indicate state. |
| SmoothRectangle | Consistent rounded rectangle primitive. |
| Icon | Renders a named icon from IconFont. Must show the correct glyph. |

---

## MVP Components

### ChiApplicationWindow

| Behavior | Pass/Fail Criteria |
|---|---|
| Creates a renderable window | Window opens and displays content |
| Loads and applies ChiTheme | Content renders with theme colors, not system defaults |
| Responds to dark/light mode toggle | Switching theme changes the color scheme across all child components |
| Contains child content | Items placed inside render within the window bounds |

---

### Button

| Behavior | Pass/Fail Criteria |
|---|---|
| Responds to click | `onClicked` fires when user clicks |
| Responds to hover | Visual state changes on mouse enter/leave |
| Respects `enabled: false` | Disabled button does not fire `onClicked`, visual state indicates disabled |
| Displays text | `text` property renders as the button label |
| Accepts icon | `icon` property renders alongside or instead of text |

---

### IconButton

| Behavior | Pass/Fail Criteria |
|---|---|
| Responds to click | `onClicked` fires |
| Responds to hover | Visual state changes on hover |
| Respects `enabled: false` | Disabled state prevents click, shows disabled appearance |
| Renders named icon | Displays the correct icon from IconFont |

---

### TextField

| Behavior | Pass/Fail Criteria |
|---|---|
| Accepts keyboard input | Typing enters text into the field |
| Displays placeholder text | Shows `placeholderText` when field is empty and unfocused |
| Reports its value | `text` property is readable and bindable |
| Supports `readOnly` | When `readOnly: true`, field displays text but rejects input |
| Supports `enabled: false` | Disabled field is visually distinct and rejects all interaction |
| Supports `echoMode` | Password mode hides characters |

---

### Checkbox

| Behavior | Pass/Fail Criteria |
|---|---|
| Toggles on click | `checked` state flips between true/false on each click |
| Fires `onToggled` | Signal emits when state changes |
| Bindable `checked` property | Parent can read and write the checked state |
| Respects `enabled: false` | Disabled checkbox does not toggle on click |

---

### Switch

| Behavior | Pass/Fail Criteria |
|---|---|
| Toggles on click | `checked` state flips on click |
| Fires `onToggled` | Signal emits on state change |
| Bindable `checked` property | Parent can read and write |
| Respects `enabled: false` | Disabled switch does not toggle |

---

### Dialog

| Behavior | Pass/Fail Criteria |
|---|---|
| Opens on demand | Calling open or setting visible shows the dialog |
| Closes on accept/reject | `accept()` and `reject()` close the dialog |
| Modal overlay | Background interaction is blocked while dialog is open |
| Renders header, content, footer | All three slots display their assigned content |

---

### AlertDialog

| Behavior | Pass/Fail Criteria |
|---|---|
| Displays a message | Body text renders correctly |
| Displays an acknowledge button | Button is visible and clickable |
| Closes on acknowledge | Clicking the button dismisses the dialog |

---

### ConfirmDialog

| Behavior | Pass/Fail Criteria |
|---|---|
| Displays a question/message | Body text renders |
| Offers accept and reject actions | Both buttons are visible and clickable |
| Fires `onAccepted` | Signal emits when user confirms |
| Fires `onRejected` | Signal emits when user declines |
| Closes after either action | Dialog dismisses on accept or reject |

---

### ListItem

| Behavior | Pass/Fail Criteria |
|---|---|
| Responds to click | `onClicked` fires when tapped |
| Displays primary text | `text` or `title` renders as the main label |
| Displays secondary text | `subtitle` or `secondaryText` renders below the primary |
| Supports leading content | Icon or avatar renders on the left side |
| Supports trailing content | Action or indicator renders on the right side |
| Respects `enabled: false` | Disabled item does not respond to clicks |

---

### Card

| Behavior | Pass/Fail Criteria |
|---|---|
| Renders children inside a contained area | Content stays within card bounds |
| Supports clickable variant | When `clickable: true`, responds to click with `onClicked` |
| Responds to hover when clickable | Visual state change on hover (if clickable) |

---

### Divider

| Behavior | Pass/Fail Criteria |
|---|---|
| Renders a horizontal line | Line appears at expected position with theme color |
| Renders a vertical line | When orientation is set, line renders vertically |

---

### TopAppBar

| Behavior | Pass/Fail Criteria |
|---|---|
| Displays title text | Title renders in the bar |
| Hosts action items | `TopAppBarAction` items render in the action area |
| Stays pinned at top | Bar does not scroll with page content |
| Supports navigation icon | Back button or menu icon renders on the left |

---

### TopAppBarAction

| Behavior | Pass/Fail Criteria |
|---|---|
| Renders as an icon button in the app bar | Appears in the action area of TopAppBar |
| Responds to click | `onClicked` fires |

---

### Tabs

| Behavior | Pass/Fail Criteria |
|---|---|
| Renders multiple tab headers | Each `Tab` appears as a selectable header |
| Switches view on tab click | Clicking a tab updates `currentIndex` and swaps visible content |
| Highlights active tab | The selected tab is visually distinct from inactive tabs |
| Bindable `currentIndex` | Parent can read and set the active tab programmatically |

---

### Tab

| Behavior | Pass/Fail Criteria |
|---|---|
| Displays tab label | `text` or `title` renders in the tab header |
| Contains tab content | Children render when this tab is active |

---

### Snackbar

| Behavior | Pass/Fail Criteria |
|---|---|
| Appears when triggered | Shows on demand |
| Auto-dismisses after timeout | Disappears after duration expires |
| Displays message text | Body text renders |
| Optional action button | If action text is provided, button renders and fires `onAction` |
| Does not block background interaction | User can still interact with the app while snackbar is visible |

---

### Badge

| Behavior | Pass/Fail Criteria |
|---|---|
| Displays a numeric count | Number renders inside the badge |
| Displays a dot indicator | When no count, shows a simple dot |
| Anchors to parent | Positions itself relative to its parent element |

---

### LinearProgressIndicator

| Behavior | Pass/Fail Criteria |
|---|---|
| Shows determinate progress | Bar fills proportionally to `value` (0.0 to 1.0) |
| Shows indeterminate state | When no value set, shows ongoing activity indicator |
| Updates when value changes | Bar reflects new value when `value` property changes |

---

### CircularProgressIndicator

| Behavior | Pass/Fail Criteria |
|---|---|
| Shows determinate progress | Arc fills proportionally to `value` (0.0 to 1.0) |
| Shows indeterminate state | When no value set, shows ongoing spinning indicator |
| Updates when value changes | Arc reflects new value when property changes |

---

### NavigationBar

| Behavior | Pass/Fail Criteria |
|---|---|
| Renders navigation items | Each `NavigationBarItem` appears in the bar |
| Switches active item on click | Tapping an item updates `currentIndex` |
| Highlights active item | Selected item is visually distinct |
| Bindable `currentIndex` | Parent can read and set active item |

---

### NavigationBarItem

| Behavior | Pass/Fail Criteria |
|---|---|
| Displays icon and label | Both render in the item |
| Responds to click | Selects this item when tapped |

---

### Slider

| Behavior | Pass/Fail Criteria |
|---|---|
| Responds to drag | User can drag the handle to change value |
| Reports value | `value` property is readable and bindable |
| Respects `from` and `to` range | Value stays within defined bounds |
| Respects `enabled: false` | Disabled slider does not respond to interaction |

---

### Tooltip

| Behavior | Pass/Fail Criteria |
|---|---|
| Appears on hover | Shows text when user hovers over the parent element |
| Disappears when hover ends | Hides when mouse leaves |
| Displays text | Renders the tooltip message |

---

## Excluded from MVP

These components exist in the library but are not required for the initial ship.
They can be added once the core is stable and validated.

| Category | Components | Reason |
|---|---|---|
| Buttons | ButtonGroup, ConnectedButtonGroup, ConnectedIconButtonGroup, IconButtonToggle, SegmentedButton, SplitButton, ToggleButton | Niche variants. Button + IconButton cover the base cases. |
| FAB | FAB, FABMenu, FABMenuItem | Material-specific pattern. Not every app needs a floating action button. |
| Carousel | Carousel, CarouselItem | Specialized layout. Most apps don't need carousels. |
| Chips | Chip, ChipGroup | Filter/tagging pattern. Nice but not essential. |
| Containers | SideSheet, Toolbar, ToolbarItem, ToolbarSeparator, ToolbarToggleItem | SideSheet is niche. Toolbar can be built from TopAppBar. |
| Data | Avatar, AvatarGroup, CodeBlock, ColorSwatch, DataTable, FileTable, IconLabel, Kbd, Tag, TreeView | Specialized display components. Each serves a specific app type. |
| Dialogs | DialogManager, FileDialog, FileDialogGridView, FileDialogListView, FileDialogThumbnail, FileDialogTreeView, FullscreenDialog, StandardPathsHelper | FileDialog is complex and app-specific. FullscreenDialog is niche. |
| Feedback | EmptyState, Skeleton | Polish components. Not function-critical. |
| Inputs | NumberField, Stepper | TextField handles numeric input. Stepper is niche. |
| Lists | SwipeListItem | Swipe gesture is a mobile pattern, not desktop-critical. |
| Menus | ContextMenu, DropdownMenu, Menu, MenuDivider, MenuGap, MenuItem, MenuManager, OverflowMenu | Complex interaction patterns. Can ship later. TopAppBar handles most navigation. |
| Navigation | BottomSheet, Breadcrumb, NavigationDrawer, NavigationDrawerDivider, NavigationDrawerItem, NavigationRail, PathSearchBar | NavigationBar + TopAppBar + Tabs cover the common cases. Drawers and rails are secondary. |
| Pickers | ColorPicker, DatePicker, TimePicker | Heavy, specialized, app-dependent. |
| Search | SearchBar, SearchSuggestionItem | Not every app needs search. TextField covers basic input. |
| Selection | RadioButton, RadioGroup, SegmentedButton | Checkbox covers selection. Radio is common but not day-one critical. |
| Surfaces | SurfaceCard | Redundant with Card. |
| Switches | (Switch is in MVP) | — |
| System | CommandPalette, FileTree, Notification, NotificationCenter, Splitter, Terminal | Power-user components. Cool but not day-one. |

---

## Summary

- **Infrastructure**: 10 components (theme, tokens, primitives)
- **MVP ship list**: 20 components
- **Total files to validate**: ~30 QML files
- **Excluded**: 60+ components for post-MVP

The MVP is complete when a developer can build a functional app that opens a window, shows a list of items, lets the user click/edit/toggle things, navigates between views, shows feedback, and handles confirmations — all without reaching for Qt Quick Controls or any other widget library.
