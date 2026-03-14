// NavigationRail — M3 navigation rail with collapsed/expanded variants
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import QtQuick.Effects
import "../../theme" as Theme
import "../common"

Item {
    id: navigationRail

    // --- Properties ---
    property string variant: "rail" // "rail" or "expanded"
    property string alignment: "top" // "top", "middle", "bottom"

    property string iconFont: Theme.ChiTheme.iconFamily

    property bool showMenuButton: true
    property string menuIcon: "menu"

    property bool showFab: true
    property string fabIcon: "add"
    property string fabText: "New"

    property int selectedIndex: 0
    property bool enabled: true

    property ListModel items: ListModel {}

    signal itemClicked(int index)
    signal fabClicked()
    signal menuClicked()

    // --- Dimensions ---
    readonly property int railWidth: 96
    property int calculatedExpandedWidth: 0
    property var colors: Theme.ChiTheme.colors
    readonly property var _typo: Theme.ChiTheme.typography
    readonly property bool _isRail: variant === "rail"

    // --- Dynamic Width Calculation ---
    TextMetrics {
        id: textMeasurer
        font.family: Theme.ChiTheme.fontFamily
        font.pixelSize: _typo.labelLarge.size
        font.weight: Font.Medium
    }

    TextMetrics {
        id: fabMeasurer
        font.family: Theme.ChiTheme.fontFamily
        font.pixelSize: _typo.titleMedium.size
        font.weight: Font.Medium
    }

    function recalculateWidth() {
        var maxTextW = 0
        for (var i = 0; i < items.count; i++) {
            textMeasurer.text = items.get(i).label || ""
            if (textMeasurer.width > maxTextW) maxTextW = textMeasurer.width
        }
        var totalItemWidth = 12 + 16 + 24 + 12 + maxTextW + 16 + 12
        var totalFabWidth = 0
        if (showFab && fabText !== "") {
            fabMeasurer.text = fabText
            totalFabWidth = 16 + 16 + 24 + 8 + fabMeasurer.width + 16 + 16
        }
        calculatedExpandedWidth = Math.max(totalItemWidth, totalFabWidth)
    }

    onItemsChanged: recalculateWidth()
    Component.onCompleted: recalculateWidth()

    // --- Root Sizing ---
    implicitWidth: _isRail ? railWidth : calculatedExpandedWidth
    implicitHeight: parent ? parent.height : 800
    opacity: enabled ? 1.0 : 0.38

    Layout.preferredWidth: implicitWidth
    Layout.minimumWidth: implicitWidth

    Behavior on implicitWidth {
        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
    }

    // --- Background ---
    Rectangle {
        anchors.fill: parent
        color: colors.surface
        Behavior on color { ColorAnimation { duration: 200 } }
    }

    // --- Accessibility Focus Scope ---
    FocusScope {
        anchors.fill: parent
        focus: true

        // --- FIXED HEADER (Menu + FAB) ---
        Column {
            id: headerSection
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 12
            spacing: 12
            z: 20

            // Menu Button
            Item {
                visible: navigationRail.showMenuButton
                width: parent.width
                height: 48

                RailIconButton {
                    anchors.centerIn: navigationRail._isRail ? parent : undefined
                    anchors.left: !navigationRail._isRail ? parent.left : undefined
                    anchors.leftMargin: !navigationRail._isRail ? 12 : 0
                    anchors.verticalCenter: parent.verticalCenter
                    icon: navigationRail.menuIcon
                    Accessible.name: "Navigation Menu"
                    Accessible.role: Accessible.Button
                    onClicked: navigationRail.menuClicked()
                }
            }

            // FAB
            Item {
                visible: navigationRail.showFab
                width: parent.width
                height: 56

                RailFAB {
                    visible: navigationRail._isRail
                    anchors.centerIn: parent
                    icon: navigationRail.fabIcon
                    Accessible.name: navigationRail.fabText
                    onClicked: navigationRail.fabClicked()
                }

                ExtendedFAB {
                    visible: !navigationRail._isRail
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    icon: navigationRail.fabIcon
                    text: navigationRail.fabText
                    Accessible.name: navigationRail.fabText
                    onClicked: navigationRail.fabClicked()
                }
            }
        }

        // --- SCROLLABLE BODY (Items Only) ---
        ScrollView {
            id: contentScroll
            anchors.top: headerSection.bottom
            anchors.topMargin: 24
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottomMargin: 12
            clip: true
            contentWidth: availableWidth
            ScrollBar.vertical.policy: ScrollBar.AsNeeded

            ColumnLayout {
                id: navColumn
                width: parent.width
                spacing: 0

                Item { visible: alignment === "middle" || alignment === "bottom"; Layout.fillHeight: true }

                Repeater {
                    model: navigationRail.items
                    delegate: Loader {
                        Layout.fillWidth: true
                        Layout.preferredHeight: navigationRail._isRail ? 64 : 56
                        sourceComponent: navigationRail._isRail ? railItemComponent : expandedItemComponent

                        property int itemIndex: index
                        property string itemIcon: model.icon || ""
                        property string itemActiveIcon: model.activeIcon || model.icon || ""
                        property string itemLabel: model.label || ""
                        property bool itemSelected: navigationRail.selectedIndex === index
                    }
                }

                Item { visible: alignment === "middle" || alignment === "top"; Layout.fillHeight: true }
            }
        }
    }

    // --- ACCESSIBILITY AUTO-SCROLL ---
    function ensureVisible(item) {
        var p = item.mapToItem(contentScroll.contentItem, 0, 0)
        if (p.y < contentScroll.contentY)
            contentScroll.contentY = p.y
        else if (p.y + item.height > contentScroll.contentY + contentScroll.height)
            contentScroll.contentY = (p.y + item.height) - contentScroll.height
    }

    // --- COMPONENT: Collapsed Rail Item ---
    Component {
        id: railItemComponent
        Item {
            id: rItem
            property string displayIcon: itemSelected && itemActiveIcon !== "" ? itemActiveIcon : itemIcon

            Item {
                width: railWidth; height: 64
                anchors.centerIn: parent

                Column {
                    anchors.centerIn: parent
                    spacing: 4
                    Item {
                        width: 56; height: 32; anchors.horizontalCenter: parent.horizontalCenter
                        Rectangle { anchors.centerIn: parent; width: itemSelected ? 56 : 0; height: 32; radius: 16; color: colors.secondaryContainer; Behavior on width { NumberAnimation { duration: 200 } } }
                        Icon { anchors.centerIn: parent; source: displayIcon; size: 24; color: itemSelected ? colors.onSecondaryContainer : colors.onSurfaceVariant }
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: itemLabel
                        font.family: Theme.ChiTheme.fontFamily; font.pixelSize: navigationRail._typo.bodySmall.size
                        font.weight: itemSelected ? Font.Medium : Font.Normal
                        color: itemSelected ? colors.onSurface : colors.onSurfaceVariant
                        elide: Text.ElideRight; width: railWidth - 8; horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            Rectangle { anchors.fill: parent; anchors.margins: 4; radius: 12; color: "transparent"; border.width: 2; border.color: colors.primary; visible: rItem.activeFocus }
            activeFocusOnTab: true
            Accessible.role: Accessible.Button; Accessible.name: itemLabel
            Keys.onEnterPressed: trigger(); Keys.onReturnPressed: trigger()
            function trigger() { navigationRail.selectedIndex = itemIndex; navigationRail.itemClicked(itemIndex) }
            MouseArea { anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: parent.trigger() }
            onActiveFocusChanged: if (activeFocus) navigationRail.ensureVisible(rItem)
        }
    }

    // --- COMPONENT: Expanded Rail Item ---
    Component {
        id: expandedItemComponent
        Item {
            id: eItem
            property string displayIcon: itemSelected && itemActiveIcon !== "" ? itemActiveIcon : itemIcon

            Rectangle {
                id: activePill
                height: 56; radius: 28
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                width: contentRow.implicitWidth + 32
                color: itemSelected ? colors.secondaryContainer : "transparent"

                Rectangle {
                    anchors.fill: parent; radius: 28
                    color: itemSelected ? colors.onSecondaryContainer : colors.onSurface
                    opacity: expItemMouse.pressed ? 0.12 : ((expItemMouse.containsMouse || eItem.activeFocus) ? 0.08 : 0)
                }

                Row {
                    id: contentRow
                    anchors.centerIn: parent
                    spacing: 12
                    Icon { source: displayIcon; size: 24; anchors.verticalCenter: parent.verticalCenter; color: itemSelected ? colors.onSecondaryContainer : colors.onSurfaceVariant }
                    Text {
                        text: itemLabel
                        font.family: Theme.ChiTheme.fontFamily; font.pixelSize: navigationRail._typo.labelLarge.size
                        font.weight: itemSelected ? Font.Medium : Font.Normal
                        color: itemSelected ? colors.onSecondaryContainer : colors.onSurfaceVariant
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            Rectangle { anchors.fill: activePill; anchors.margins: -2; radius: 30; color: "transparent"; border.width: 2; border.color: colors.primary; visible: eItem.activeFocus }
            activeFocusOnTab: true
            Accessible.role: Accessible.Button; Accessible.name: itemLabel
            Keys.onEnterPressed: trigger(); Keys.onReturnPressed: trigger()
            function trigger() { navigationRail.selectedIndex = itemIndex; navigationRail.itemClicked(itemIndex) }
            MouseArea { id: expItemMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: parent.trigger() }
            onActiveFocusChanged: if (activeFocus) navigationRail.ensureVisible(eItem)
        }
    }

    // --- BUTTON COMPONENTS ---

    component RailIconButton: Item {
        property string icon: ""
        signal clicked()
        width: 48; height: 48; activeFocusOnTab: true
        Rectangle { anchors.centerIn: parent; width: 40; height: 40; radius: 20; color: colors.onSurfaceVariant; opacity: btnMouse.pressed ? 0.12 : ((btnMouse.containsMouse || parent.activeFocus) ? 0.08 : 0) }
        Icon { anchors.centerIn: parent; source: icon; size: 24; color: colors.onSurfaceVariant }
        Rectangle { anchors.fill: parent; radius: 24; color: "transparent"; border.width: 2; border.color: colors.primary; visible: parent.activeFocus }
        Keys.onEnterPressed: parent.clicked(); Keys.onReturnPressed: parent.clicked()
        MouseArea { id: btnMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: parent.clicked() }
    }

    component RailFAB: Item {
        property string icon: ""
        signal clicked()
        width: 56; height: 56; activeFocusOnTab: true
        Rectangle {
            anchors.fill: parent; radius: 16; color: colors.primaryContainer
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: Qt.rgba(0, 0, 0, 0.2)
                shadowVerticalOffset: 2
                shadowBlur: 0.2
            }
            Rectangle { anchors.fill: parent; radius: 16; color: colors.onPrimaryContainer; opacity: fabMouse.pressed ? 0.12 : ((fabMouse.containsMouse || parent.parent.activeFocus) ? 0.08 : 0) }
            Icon { anchors.centerIn: parent; source: icon; size: 24; color: colors.onPrimaryContainer }
        }
        Rectangle { anchors.fill: parent; radius: 16; color: "transparent"; border.width: 2; border.color: colors.primary; visible: parent.activeFocus }
        Keys.onEnterPressed: parent.clicked(); Keys.onReturnPressed: parent.clicked()
        MouseArea { id: fabMouse; anchors.fill: parent; hoverEnabled: true; onClicked: parent.clicked(); cursorShape: Qt.PointingHandCursor }
    }

    component ExtendedFAB: Item {
        property string icon: ""
        property string text: ""
        signal clicked()
        implicitWidth: extRow.implicitWidth + 32
        implicitHeight: 56
        activeFocusOnTab: true

        Rectangle {
            anchors.fill: parent; radius: 16; color: colors.primaryContainer
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: Qt.rgba(0, 0, 0, 0.2)
                shadowVerticalOffset: 2
                shadowBlur: 0.2
            }
            Rectangle { anchors.fill: parent; radius: 16; color: colors.onPrimaryContainer; opacity: extFabMouse.pressed ? 0.12 : ((extFabMouse.containsMouse || parent.parent.activeFocus) ? 0.08 : 0) }
            Row {
                id: extRow
                anchors.centerIn: parent
                spacing: 8
                Icon { source: icon; size: 24; anchors.verticalCenter: parent.verticalCenter; color: colors.onPrimaryContainer }
                Text {
                    text: parent.parent.parent.text
                    font.family: Theme.ChiTheme.fontFamily; font.pixelSize: navigationRail._typo.titleMedium.size; font.weight: Font.Medium
                    color: colors.onPrimaryContainer; anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
        Rectangle { anchors.fill: parent; radius: 16; color: "transparent"; border.width: 2; border.color: colors.primary; visible: parent.activeFocus }
        Keys.onEnterPressed: parent.clicked(); Keys.onReturnPressed: parent.clicked()
        MouseArea { id: extFabMouse; anchors.fill: parent; hoverEnabled: true; onClicked: parent.clicked(); cursorShape: Qt.PointingHandCursor }
    }
}
