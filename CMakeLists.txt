cmake_minimum_required(VERSION 3.16)

project(smartui VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Qml)

add_library(smartui STATIC
    smartui.cpp
    smartui.h

    qml/smartui/theme/ChiTheme.qml

    # Buttons
    qml/smartui/ui/Buttons/Button.qml
    qml/smartui/ui/Buttons/IconButton.qml
    qml/smartui/ui/Buttons/SplitButton.qml
    qml/smartui/ui/Buttons/ToggleButton.qml
    qml/smartui/ui/Buttons/IconButtonToggle.qml

    # FAB
    qml/smartui/ui/FAB/FAB.qml
    qml/smartui/ui/FAB/FABMenu.qml
    qml/smartui/ui/FAB/FABMenuItem.qml

    # Switches
    qml/smartui/ui/switches/Switch.qml

    # Progress
    qml/smartui/ui/progress/LinearProgressIndicator.qml
    qml/smartui/ui/progress/CircularProgressIndicator.qml

    # Navigation
    qml/smartui/ui/navigation/NavigationRail.qml
    qml/smartui/ui/navigation/NavigationBar.qml
    qml/smartui/ui/navigation/NavigationBarItem.qml
    qml/smartui/ui/navigation/Tabs.qml
    qml/smartui/ui/navigation/Tab.qml
    qml/smartui/ui/navigation/TopAppBar.qml
    qml/smartui/ui/navigation/TopAppBarAction.qml
    qml/smartui/ui/navigation/NavigationDrawer.qml
    qml/smartui/ui/navigation/NavigationDrawerItem.qml
    qml/smartui/ui/navigation/NavigationDrawerDivider.qml
    qml/smartui/ui/navigation/BottomSheet.qml
    qml/smartui/ui/navigation/Breadcrumb.qml

    # Inputs
    qml/smartui/ui/inputs/TextField.qml
    qml/smartui/ui/inputs/Stepper.qml

    # Selection
    qml/smartui/ui/selection/Checkbox.qml
    qml/smartui/ui/selection/RadioButton.qml
    qml/smartui/ui/selection/RadioGroup.qml
    qml/smartui/ui/selection/Slider.qml
    qml/smartui/ui/selection/SegmentedButton.qml

    # Containers
    qml/smartui/ui/containers/Card.qml
    qml/smartui/ui/containers/Dialog.qml
    qml/smartui/ui/containers/Divider.qml
    qml/smartui/ui/containers/SideSheet.qml
    qml/smartui/ui/containers/Toolbar.qml
    qml/smartui/ui/containers/ToolbarItem.qml
    qml/smartui/ui/containers/ToolbarToggleItem.qml
    qml/smartui/ui/containers/ToolbarSeparator.qml

    # Feedback
    qml/smartui/ui/feedback/Snackbar.qml
    qml/smartui/ui/feedback/Badge.qml
    qml/smartui/ui/feedback/Skeleton.qml
    qml/smartui/ui/feedback/EmptyState.qml

    # Chips
    qml/smartui/ui/chips/Chip.qml
    qml/smartui/ui/chips/ChipGroup.qml

    # Menus
    qml/smartui/ui/menus/Menu.qml
    qml/smartui/ui/menus/MenuItem.qml
    qml/smartui/ui/menus/MenuDivider.qml
    qml/smartui/ui/menus/ContextMenu.qml
    qml/smartui/ui/menus/Tooltip.qml

    # Pickers
    qml/smartui/ui/pickers/DatePicker.qml
    qml/smartui/ui/pickers/TimePicker.qml
    qml/smartui/ui/pickers/ColorPicker.qml

    # Search
    qml/smartui/ui/search/SearchBar.qml

    # Lists
    qml/smartui/ui/lists/ListItem.qml

    # Data Display
    qml/smartui/ui/data/Avatar.qml
    qml/smartui/ui/data/AvatarGroup.qml
    qml/smartui/ui/data/DataTable.qml
    qml/smartui/ui/data/Kbd.qml
    qml/smartui/ui/data/TreeView.qml
    qml/smartui/ui/data/CodeBlock.qml
    qml/smartui/ui/data/ColorSwatch.qml
    qml/smartui/ui/data/IconLabel.qml
    qml/smartui/ui/data/Tag.qml

    # Layout
    qml/smartui/ui/system/Splitter.qml

    # Window
    qml/smartui/ui/window/WindowControls.qml
    qml/smartui/ui/window/TitleBar.qml
    qml/smartui/ui/window/ApplicationWindow.qml
    qml/smartui/ui/window/StatusBar.qml
)

target_link_libraries(smartui
    PRIVATE Qt6::Quick Qt6::Qml
)

target_include_directories(smartui
    PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}
)

add_subdirectory(testui)
