// // // // import QtQuick
// // // // import QtQuick.Layouts
// // // // import "../theme" as Theme

// // // // pragma ComponentBehavior: Bound

// // // // Rectangle {
// // // //     id: root

// // // //     property int currentIndex: 0
// // // //     property bool scrollable: false
// // // //     property bool enabled: true

// // // //     default property list<Item> tabs: []

// // // //     signal tabClicked(int index)

// // // //     implicitWidth: scrollable ? tabsRow.implicitWidth : width
// // // //     implicitHeight: 64

// // // //     property var colors: Theme.ChiTheme.colors

// // // //     color: colors.surface

// // // //     Behavior on color {
// // // //         ColorAnimation { duration: 200 }
// // // //     }

// // // //     Item {
// // // //         id: tabsContainer
// // // //     }

// // // //     Flickable {
// // // //         id: flickable
// // // //         anchors.fill: parent
// // // //         contentWidth: scrollable ? tabsRow.implicitWidth + (scrollable ? 52 : 0) : width
// // // //         contentHeight: height
// // // //         clip: scrollable
// // // //         boundsBehavior: Flickable.StopAtBounds
// // // //         flickableDirection: Flickable.HorizontalFlick

// // // //         contentX: scrollable ? 0 : 0

// // // //         Row {
// // // //             id: tabsRow
// // // //             height: parent.height
// // // //             leftPadding: scrollable ? 52 : 0

// // // //             children: root.tabs

// // // //             onChildrenChanged: {
// // // //                 updateTabs();
// // // //             }

// // // //             Component.onCompleted: {
// // // //                 updateTabs();
// // // //             }

// // // //             function updateTabs() {
// // // //                 for (var i = 0; i < children.length; i++) {
// // // //                     var tab = children[i];
// // // //                     if (tab && typeof tab.checked !== "undefined") {
// // // //                         tab.index = i;

// // // //                         var checkedBinding = Qt.binding(function() {
// // // //                             return root.currentIndex === i;
// // // //                         });

// // // //                         if (tab.checked !== undefined) {
// // // //                             tab.checked = checkedBinding;
// // // //                         }
// // // //                     }
// // // //                 }
// // // //             }
// // // //         }
// // // //     }

// // // //     Rectangle {
// // // //         id: activeIndicator
// // // //         height: 3
// // // //         radius: 3
// // // //         color: colors.primary
// // // //         anchors.bottom: parent.bottom

// // // //         x: {
// // // //             if (currentTab) {
// // // //                 var xPos = currentTab.x;
// // // //                 if (scrollable) {
// // // //                     xPos += 52;
// // // //                 }
// // // //                 return xPos + 2;
// // // //             }
// // // //             return 2;
// // // //         }

// // // //         width: {
// // // //             if (currentTab) {
// // // //                 var tabWidth = currentTab.width;
// // // //                 return Math.max(24, tabWidth - 4);
// // // //             }
// // // //             return 24;
// // // //         }

// // // //         property Item currentTab: {
// // // //             if (root.tabs.length > 0 && root.currentIndex >= 0 && root.currentIndex < root.tabs.length) {
// // // //                 return root.tabs[root.currentIndex];
// // // //             }
// // // //             return null;
// // // //         }

// // // //         Behavior on x {
// // // //             NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
// // // //         }
// // // //         Behavior on width {
// // // //             NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
// // // //         }
// // // //         Behavior on color {
// // // //             ColorAnimation { duration: 200 }
// // // //         }
// // // //     }

// // // //     Rectangle {
// // // //         anchors.left: parent.left
// // // //         anchors.right: parent.right
// // // //         anchors.bottom: parent.bottom
// // // //         height: 1
// // // //         color: colors.outlineVariant
// // // //         z: -1

// // // //         Behavior on color {
// // // //             ColorAnimation { duration: 200 }
// // // //         }
// // // //     }

// // // //     Connections {
// // // //         target: root
// // // //         function onTabClicked(index) {
// // // //             root.currentIndex = index;
// // // //         }
// // // //     }

// // // //     Component.onCompleted: {
// // // //         for (var i = 0; i < tabs.length; i++) {
// // // //             tabs[i].clicked.connect(function(tabIndex) {
// // // //                 return function() {
// // // //                     root.currentIndex = tabIndex;
// // // //                     root.tabClicked(tabIndex);
// // // //                 }
// // // //             }(i));
// // // //         }
// // // //     }
// // // // }



// // // import QtQuick
// // // import QtQuick.Layouts
// // // import "../theme" as Theme

// // // pragma ComponentBehavior: Bound

// // // Rectangle {
// // //     id: root

// // //     // --- Props ---
// // //     property int currentIndex: 0
// // //     property bool scrollable: false

// // //     default property list<Item> tabs

// // //     signal tabClicked(int index)

// // //     implicitHeight: 64
// // //     implicitWidth: parent ? parent.width : 400

// // //     property var colors: Theme.ChiTheme.colors
// // //     color: colors.surface

// // //     Behavior on color { ColorAnimation { duration: 200 } }

// // //     // --- Bottom Divider (M3) ---
// // //     Rectangle {
// // //         anchors.left: parent.left
// // //         anchors.right: parent.right
// // //         anchors.bottom: parent.bottom
// // //         height: 1
// // //         color: root.colors.outlineVariant
// // //         z: 0
// // //     }

// // //     // --- Content ---
// // //     Flickable {
// // //         id: flickable
// // //         anchors.fill: parent

// // //         contentWidth: contentContainer.width
// // //         contentHeight: height

// // //         clip: true
// // //         boundsBehavior: Flickable.StopAtBounds
// // //         flickableDirection: Flickable.HorizontalFlick

// // //         // Container holding Row + Indicator
// // //         Item {
// // //             id: contentContainer
// // //             height: parent.height
// // //             width: Math.max(flickable.width, tabsRow.implicitWidth)

// // //             Row {
// // //                 id: tabsRow
// // //                 height: parent.height
// // //                 spacing: 0
// // //                 children: root.tabs
// // //             }

// // //             // --- Active Indicator ---
// // //             Rectangle {
// // //                 id: activeIndicator
// // //                 height: 3
// // //                 radius: 3
// // //                 color: root.colors.primary
// // //                 anchors.bottom: parent.bottom
// // //                 z: 2

// // //                 property real targetX: 0
// // //                 property real targetWidth: 0

// // //                 x: targetX
// // //                 width: targetWidth

// // //                 Behavior on x {
// // //                     NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
// // //                 }
// // //                 Behavior on width {
// // //                     NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
// // //                 }
// // //             }
// // //         }
// // //     }

// // //     // --- Logic ---

// // //     Component.onCompleted: updateTabs()
// // //     onTabsChanged: updateTabs()
// // //     onCurrentIndexChanged: updateIndicator()

// // //     function updateTabs() {
// // //         for (var i = 0; i < tabsRow.children.length; i++) {
// // //             var tab = tabsRow.children[i];

// // //             if (tab && typeof tab.text !== "undefined") {
// // //                 tab.index = i;

// // //                 // Bind Selection
// // //                 tab.selected = Qt.binding(function() { return root.currentIndex === this.index }.bind(tab));

// // //                 // Click Handling
// // //                 if (tab.clicked) {
// // //                     tab.clicked.disconnect(handleTabClick)
// // //                     tab.clicked.connect(handleTabClick.bind(tab, i))
// // //                 }

// // //                 // Keyboard Navigation
// // //                 tab.Keys.onRightPressed.connect(function() { focusNextTab(i + 1) }.bind(tab))
// // //                 tab.Keys.onLeftPressed.connect(function() { focusNextTab(i - 1) }.bind(tab))
// // //             }
// // //         }
// // //         updateIndicator()
// // //     }

// // //     function handleTabClick(index) {
// // //         root.currentIndex = index;
// // //         root.tabClicked(index);
// // //         updateIndicator();
// // //     }

// // //     function focusNextTab(nextIndex) {
// // //         if (nextIndex >= 0 && nextIndex < root.tabs.length) {
// // //             var nextTab = root.tabs[nextIndex];
// // //             if (nextTab) nextTab.forceActiveFocus();
// // //         }
// // //     }

// // //     function updateIndicator() {
// // //         if (root.tabs.length === 0) return;
// // //         if (currentIndex < 0 || currentIndex >= root.tabs.length) return;

// // //         var currentTab = root.tabs[currentIndex];

// // //         if (currentTab) {
// // //             // Calculate Indicator Size
// // //             // M3: Indicator matches content width, not full tab width
// // //             var contentW = currentTab.contentWidth || (currentTab.width - 32);
// // //             // Fallback (width - 32) assumes 16dp padding if contentWidth isn't available

// // //             // Ensure min width 24dp (M3 Spec)
// // //             var indicatorW = Math.max(24, contentW);

// // //             // Center relative to Tab
// // //             var centerX = currentTab.x + (currentTab.width / 2);
// // //             var finalX = centerX - (indicatorW / 2);

// // //             activeIndicator.targetX = finalX;
// // //             activeIndicator.targetWidth = indicatorW;

// // //             ensureVisible(currentTab);
// // //         }
// // //     }

// // //     function ensureVisible(item) {
// // //         if (!scrollable) return;

// // //         var itemLeft = item.x;
// // //         var itemRight = item.x + item.width;

// // //         if (itemLeft < flickable.contentX) {
// // //             flickable.contentX = itemLeft;
// // //         } else if (itemRight > flickable.contentX + flickable.width) {
// // //             flickable.contentX = itemRight - flickable.width;
// // //         }
// // //     }
// // // }



// // import QtQuick
// // import QtQuick.Layouts
// // import "../theme" as Theme

// // pragma ComponentBehavior: Bound

// // Rectangle {
// //     id: root

// //     property int currentIndex: 0
// //     property bool scrollable: false
// //     default property list<Item> tabs

// //     signal tabClicked(int index)

// //     // implicitHeight adapts, but usually 48 or 64.
// //     // We let the largest child dictate height + 1 for divider?
// //     // Or just fixed minimum.
// //     implicitHeight: 48
// //     implicitWidth: parent ? parent.width : 400

// //     property var colors: Theme.ChiTheme.colors
// //     color: colors.surface
// //     Behavior on color { ColorAnimation { duration: 200 } }

// //     // Bottom Divider
// //     Rectangle {
// //         anchors.left: parent.left
// //         anchors.right: parent.right
// //         anchors.bottom: parent.bottom
// //         height: 1
// //         color: root.colors.outlineVariant
// //         z: 0
// //     }

// //     Flickable {
// //         id: flickable
// //         anchors.fill: parent
// //         contentWidth: contentContainer.width
// //         contentHeight: height
// //         clip: true
// //         boundsBehavior: Flickable.StopAtBounds
// //         flickableDirection: Flickable.HorizontalFlick

// //         Item {
// //             id: contentContainer
// //             height: parent.height
// //             width: Math.max(flickable.width, tabsRow.implicitWidth)

// //             Row {
// //                 id: tabsRow
// //                 height: parent.height
// //                 // If scrollable, standard M3 padding is sometimes used, otherwise centered or spread
// //                 anchors.horizontalCenter: (!root.scrollable) ? parent.horizontalCenter : undefined
// //                 spacing: 0
// //                 children: root.tabs
// //             }

// //             // Active Indicator
// //             Rectangle {
// //                 id: activeIndicator
// //                 height: 3
// //                 radius: 3
// //                 color: root.colors.primary
// //                 anchors.bottom: parent.bottom
// //                 z: 2

// //                 property real targetX: 0
// //                 property real targetWidth: 0

// //                 x: targetX
// //                 width: targetWidth

// //                 Behavior on x { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
// //                 Behavior on width { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
// //             }
// //         }
// //     }

// //     Component.onCompleted: updateTabs()
// //     onTabsChanged: updateTabs()
// //     onCurrentIndexChanged: updateIndicator()

// //     function updateTabs() {
// //         for (var i = 0; i < tabsRow.children.length; i++) {
// //             var tab = tabsRow.children[i];
// //             if (tab && typeof tab.text !== "undefined") {
// //                 tab.index = i;
// //                 tab.selected = Qt.binding(function() { return root.currentIndex === this.index }.bind(tab));

// //                 if (tab.clicked) {
// //                     tab.clicked.disconnect(handleTabClick)
// //                     tab.clicked.connect(handleTabClick.bind(tab, i))
// //                 }

// //                 // Keyboard Nav
// //                 tab.Keys.onRightPressed.connect(function() { focusNextTab(i + 1) }.bind(tab))
// //                 tab.Keys.onLeftPressed.connect(function() { focusNextTab(i - 1) }.bind(tab))

// //                 // If implicitHeight of tabs changes (e.g. Primary vs Secondary), root should adapt
// //                 if (tab.implicitHeight > root.implicitHeight) root.implicitHeight = tab.implicitHeight
// //             }
// //         }
// //         updateIndicator()
// //     }

// //     function handleTabClick(index) {
// //         root.currentIndex = index;
// //         root.tabClicked(index);
// //         updateIndicator();
// //     }

// //     function focusNextTab(nextIndex) {
// //         if (nextIndex >= 0 && nextIndex < root.tabs.length) {
// //             root.tabs[nextIndex].forceActiveFocus();
// //         }
// //     }

// //     function updateIndicator() {
// //         if (root.tabs.length === 0 || currentIndex < 0 || currentIndex >= root.tabs.length) return;

// //         var currentTab = root.tabs[currentIndex];
// //         if (currentTab) {
// //             // Get content width from Tab property or fallback
// //             var contentW = (currentTab.contentWidth) ? currentTab.contentWidth : (currentTab.width - 32);
// //             var indicatorW = Math.max(24, contentW);

// //             // Calculate global X relative to contentContainer
// //             // Note: tabsRow might be centered, so we need tabsRow.x + tab.x
// //             var rowX = tabsRow.x;
// //             var tabCenterX = currentTab.x + (currentTab.width / 2);
// //             var finalX = rowX + tabCenterX - (indicatorW / 2);

// //             activeIndicator.targetX = finalX;
// //             activeIndicator.targetWidth = indicatorW;

// //             ensureVisible(currentTab);
// //         }
// //     }

// //     function ensureVisible(item) {
// //         if (!scrollable) return;
// //         var itemLeft = tabsRow.x + item.x;
// //         var itemRight = itemLeft + item.width;
// //         if (itemLeft < flickable.contentX) flickable.contentX = itemLeft;
// //         else if (itemRight > flickable.contentX + flickable.width) flickable.contentX = itemRight - flickable.width;
// //     }
// // }


// // /////////////////// version 2


// import QtQuick
// import QtQuick.Layouts
// import "../theme" as Theme

// pragma ComponentBehavior: Bound

// Rectangle {
//     id: root

//     property int currentIndex: 0
//     property bool scrollable: false
//     default property list<Item> tabs

//     signal tabClicked(int index)

//     implicitHeight: 48
//     implicitWidth: parent ? parent.width : 400

//     property var colors: Theme.ChiTheme.colors
//     color: colors.surface
//     Behavior on color { ColorAnimation { duration: 200 } }

//     Rectangle {
//         anchors.left: parent.left
//         anchors.right: parent.right
//         anchors.bottom: parent.bottom
//         height: 1
//         color: root.colors.outlineVariant
//         z: 0
//     }

//     Flickable {
//         id: flickable
//         anchors.fill: parent
//         contentWidth: contentContainer.width
//         contentHeight: height
//         clip: true
//         boundsBehavior: Flickable.StopAtBounds
//         flickableDirection: Flickable.HorizontalFlick

//         Item {
//             id: contentContainer
//             height: parent.height
//             width: Math.max(flickable.width, tabsRow.implicitWidth)

//             Row {
//                 id: tabsRow
//                 height: parent.height
//                 // Center if not scrollable, otherwise left align (standard M3 behavior)
//                 anchors.horizontalCenter: (!root.scrollable) ? parent.horizontalCenter : undefined
//                 spacing: 0
//                 children: root.tabs

//                 // When layout changes (e.g. centering happens), update indicator
//                 onXChanged: updateIndicator()
//                 onWidthChanged: updateIndicator()
//             }

//             Rectangle {
//                 id: activeIndicator
//                 height: 3
//                 radius: 3
//                 color: root.colors.primary
//                 anchors.bottom: parent.bottom
//                 z: 2

//                 property real targetX: 0
//                 property real targetWidth: 0

//                 // Bindings to animate to target values
//                 x: targetX
//                 width: targetWidth

//                 Behavior on x {
//                     enabled: activeIndicator.width > 0 // Disable animation on first load
//                     NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
//                 }
//                 Behavior on width {
//                     enabled: activeIndicator.width > 0
//                     NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
//                 }
//             }
//         }
//     }

//     Component.onCompleted: {
//         updateTabs()
//         // Force immediate update after a frame to ensure layout is ready
//         Qt.callLater(updateIndicator)
//     }

//     onTabsChanged: updateTabs()
//     onCurrentIndexChanged: updateIndicator()
//     onWidthChanged: updateIndicator()

//     function updateTabs() {
//         for (var i = 0; i < tabsRow.children.length; i++) {
//             var tab = tabsRow.children[i];
//             if (tab && typeof tab.text !== "undefined") {
//                 tab.index = i;
//                 tab.selected = Qt.binding(function() { return root.currentIndex === this.index }.bind(tab));

//                 if (tab.clicked) {
//                     tab.clicked.disconnect(handleTabClick)
//                     tab.clicked.connect(handleTabClick.bind(tab, i))
//                 }

//                 tab.Keys.onRightPressed.connect(function() { focusNextTab(i + 1) }.bind(tab))
//                 tab.Keys.onLeftPressed.connect(function() { focusNextTab(i - 1) }.bind(tab))

//                 if (tab.implicitHeight > root.implicitHeight) root.implicitHeight = tab.implicitHeight
//             }
//         }
//         // Force update after setup
//         updateIndicator()
//     }

//     function handleTabClick(index) {
//         root.currentIndex = index;
//         root.tabClicked(index);
//         updateIndicator();
//     }

//     function focusNextTab(nextIndex) {
//         if (nextIndex >= 0 && nextIndex < root.tabs.length) {
//             root.tabs[nextIndex].forceActiveFocus();
//         }
//     }

//     function updateIndicator() {
//         if (root.tabs.length === 0 || currentIndex < 0 || currentIndex >= root.tabs.length) return;

//         var currentTab = root.tabs[currentIndex];

//         if (currentTab && currentTab.width > 0) {
//             // Logic: Line width = Content Width (Text + Icon)
//             // Fallback: Tab Width - 32 (standard padding)
//             var contentW = (currentTab.contentWidth > 0) ? currentTab.contentWidth : (currentTab.width - 32);
//             var indicatorW = Math.max(24, contentW);

//             // Calculate Position
//             // tabsRow.x handles the centering offset
//             // currentTab.x is relative to Row
//             // We want the center of the tab
//             var rowX = tabsRow.x;
//             var tabCenterX = currentTab.x + (currentTab.width / 2);
//             var finalX = rowX + tabCenterX - (indicatorW / 2);

//             // FIX: "Lost Context" / "Starting from black place"
//             // If this is the first calculation (width is 0), jump immediately without animation
//             if (activeIndicator.width === 0) {
//                 activeIndicator.x = finalX;
//                 activeIndicator.width = indicatorW;
//             }

//             activeIndicator.targetX = finalX;
//             activeIndicator.targetWidth = indicatorW;

//             ensureVisible(currentTab);
//         } else {
//             // If layout isn't ready, try again next tick
//             Qt.callLater(updateIndicator)
//         }
//     }

//     function ensureVisible(item) {
//         if (!scrollable) return;
//         var itemLeft = tabsRow.x + item.x;
//         var itemRight = itemLeft + item.width;
//         if (itemLeft < flickable.contentX) flickable.contentX = itemLeft;
//         else if (itemRight > flickable.contentX + flickable.width) flickable.contentX = itemRight - flickable.width;
//     }
// }



// ///////////////////////////////// version 3 -fix accesability

import QtQuick
import QtQuick.Layouts
import "../theme" as Theme

pragma ComponentBehavior: Bound

Rectangle {
    id: root

    property int currentIndex: 0
    property bool scrollable: false
    default property list<Item> tabs

    signal tabClicked(int index)

    // Default height, will expand if children are larger
    implicitHeight: 48
    implicitWidth: parent ? parent.width : 400

    property var colors: Theme.ChiTheme.colors
    color: colors.surface
    Behavior on color { ColorAnimation { duration: 200 } }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: root.colors.outlineVariant
        z: 0
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: contentContainer.width
        contentHeight: height
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.HorizontalFlick

        Item {
            id: contentContainer
            height: parent.height
            width: Math.max(flickable.width, tabsRow.implicitWidth)

            Row {
                id: tabsRow
                height: parent.height
                anchors.horizontalCenter: (!root.scrollable) ? parent.horizontalCenter : undefined
                spacing: 0
                children: root.tabs

                onXChanged: updateIndicator()
                onWidthChanged: updateIndicator()
            }

            Rectangle {
                id: activeIndicator
                height: 3
                radius: 3
                color: root.colors.primary
                anchors.bottom: parent.bottom
                z: 2

                property real targetX: 0
                property real targetWidth: 0

                x: targetX
                width: targetWidth

                Behavior on x {
                    enabled: activeIndicator.width > 0
                    NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
                }
                Behavior on width {
                    enabled: activeIndicator.width > 0
                    NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
                }
            }
        }
    }

    // --- Logic ---

    Component.onCompleted: {
        updateTabs()
        Qt.callLater(updateIndicator)
    }

    onTabsChanged: updateTabs()
    onCurrentIndexChanged: updateIndicator()

    // Auto-scroll when keyboard focus changes
    property Item activeFocusItem: Window.activeFocusItem
    onActiveFocusItemChanged: {
        if (activeFocusItem && activeFocusItem.parent === tabsRow) {
            ensureVisible(activeFocusItem)
        }
    }

    function updateTabs() {
        var maxH = 48;

        // 1. Calculate Max Height
        for (var i = 0; i < tabsRow.children.length; i++) {
            var child = tabsRow.children[i];
            if (child.implicitHeight > maxH) maxH = child.implicitHeight;
        }
        root.implicitHeight = maxH; // Set root height to fit tallest tab

        // 2. Configure Tabs
        for (var j = 0; j < tabsRow.children.length; j++) {
            var tab = tabsRow.children[j];
            if (tab && typeof tab.text !== "undefined") {
                tab.index = j;

                // STRETCH HEIGHT FIX: Bind tab height to row height
                // This ensures touch target & indicator logic works for mixed sizes
                tab.height = Qt.binding(function() { return tabsRow.height });

                // Selection Binding
                tab.selected = Qt.binding(function() { return root.currentIndex === this.index }.bind(tab));

                // Click Binding
                if (tab.clicked) {
                    tab.clicked.disconnect(handleTabClick)
                    tab.clicked.connect(handleTabClick.bind(tab, j))
                }

                // KEYBOARD NAV FIX: Use KeyNavigation properties
                if (j < tabsRow.children.length - 1) {
                    tab.KeyNavigation.right = tabsRow.children[j + 1];
                } else {
                    tab.KeyNavigation.right = null; // Stop at end
                }

                if (j > 0) {
                    tab.KeyNavigation.left = tabsRow.children[j - 1];
                } else {
                    tab.KeyNavigation.left = null; // Stop at start
                }
            }
        }
        updateIndicator()
    }

    function handleTabClick(index) {
        root.currentIndex = index;
        root.tabClicked(index);
        updateIndicator();
    }

    function updateIndicator() {
        if (root.tabs.length === 0 || currentIndex < 0 || currentIndex >= root.tabs.length) return;

        var currentTab = root.tabs[currentIndex];

        if (currentTab && currentTab.width > 0) {
            // Context Aware Width
            var contentW = (currentTab.contentWidth > 0) ? currentTab.contentWidth : (currentTab.width - 32);
            var indicatorW = Math.max(24, contentW);

            // Context Aware Position
            var rowX = tabsRow.x;
            var tabCenterX = currentTab.x + (currentTab.width / 2);
            var finalX = rowX + tabCenterX - (indicatorW / 2);

            if (activeIndicator.width === 0) {
                activeIndicator.x = finalX;
                activeIndicator.width = indicatorW;
            }

            activeIndicator.targetX = finalX;
            activeIndicator.targetWidth = indicatorW;

            ensureVisible(currentTab);
        } else {
            Qt.callLater(updateIndicator)
        }
    }

    function ensureVisible(item) {
        if (!scrollable) return;

        var itemLeft = tabsRow.x + item.x;
        var itemRight = itemLeft + item.width;

        // Add some padding to scroll logic so active item isn't glued to edge
        var padding = 20;

        if (itemLeft < flickable.contentX + padding) {
            flickable.contentX = Math.max(0, itemLeft - padding);
        } else if (itemRight > flickable.contentX + flickable.width - padding) {
            flickable.contentX = Math.min(flickable.contentWidth - flickable.width, itemRight - flickable.width + padding);
        }
    }
}
