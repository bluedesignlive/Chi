// Tabs.qml - Material 3 Tabs Container
// Clean implementation following Dieter Rams principle #10 (As little design as possible)

import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme

pragma ComponentBehavior: Bound

Rectangle {
    id: root

    // ─── Public API ───────────────────────────────────────────
    property int currentIndex: 0
    property bool scrollable: false
    default property list<Item> tabs

    signal tabClicked(int index)

    // ─── Theme Tokens ───────────────────────────────────────────
    readonly property var colors: Theme.ChiTheme.colors
    readonly property var motion: Theme.ChiTheme.motion

    // ─── Geometry ───────────────────────────────────────────────
    implicitHeight: 48
    implicitWidth: parent ? parent.width : 400

    color: colors.surface
    Behavior on color { ColorAnimation { duration: motion.durationMedium } }

    // Bottom Divider
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: root.colors.outlineVariant
        z: 0
    }

    // ─── Content ───────────────────────────────────────────────
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

            // Active Indicator
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

    // ─── Logic ──────────────────────────────────────────────────
    Component.onCompleted: {
        updateTabs()
        Qt.callLater(updateIndicator)
    }

    onTabsChanged: updateTabs()
    onCurrentIndexChanged: updateIndicator()

    property Item activeFocusItem: Window.activeFocusItem
    onActiveFocusItemChanged: {
        if (activeFocusItem && activeFocusItem.parent === tabsRow) {
            ensureVisible(activeFocusItem)
        }
    }

    function updateTabs() {
        var maxH = 48;

        // Calculate max height
        for (var i = 0; i < tabsRow.children.length; i++) {
            var child = tabsRow.children[i];
            if (child.implicitHeight > maxH) maxH = child.implicitHeight;
        }
        root.implicitHeight = maxH;

        // Configure tabs
        for (var j = 0; j < tabsRow.children.length; j++) {
            var tab = tabsRow.children[j];
            if (tab && typeof tab.text !== "undefined") {
                tab.index = j;
                tab.height = Qt.binding(function() { return tabsRow.height });
                tab.selected = Qt.binding(function() { return root.currentIndex === this.index }.bind(tab));

                if (tab.clicked) {
                    tab.clicked.disconnect(handleTabClick)
                    tab.clicked.connect(handleTabClick.bind(tab, j))
                }

                // Keyboard navigation
                if (j < tabsRow.children.length - 1) {
                    tab.KeyNavigation.right = tabsRow.children[j + 1];
                } else {
                    tab.KeyNavigation.right = null;
                }

                if (j > 0) {
                    tab.KeyNavigation.left = tabsRow.children[j - 1];
                } else {
                    tab.KeyNavigation.left = null;
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
            var contentW = (currentTab.contentWidth > 0) ? currentTab.contentWidth : (currentTab.width - 32);
            var indicatorW = Math.max(24, contentW);

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
        var padding = 20;

        if (itemLeft < flickable.contentX + padding) {
            flickable.contentX = Math.max(0, itemLeft - padding);
        } else if (itemRight > flickable.contentX + flickable.width - padding) {
            flickable.contentX = Math.min(flickable.contentContent - flickable.width, itemRight - flickable.width + padding);
        }
    }
}
