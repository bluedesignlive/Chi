import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import QtQuick.Effects
import "../../theme" as Theme
import "../common" as Common

Item {
    id: navigationRail
    property string variant: "rail"
    property string alignment: "top"
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
    signal fabClicked
    signal menuClicked

    readonly property int railWidth: 96
    property int calculatedExpandedWidth: 0
    property var colors: Theme.ChiTheme.colors
    readonly property var _typo: Theme.ChiTheme.typography
    readonly property bool _isRail: variant === "rail"

    TextMetrics { id: textMeasurer; font.family: Theme.ChiTheme.fontFamily; font.pixelSize: _typo.labelLarge.size; font.weight: Font.Medium }
    TextMetrics { id: fabMeasurer; font.family: Theme.ChiTheme.fontFamily; font.pixelSize: _typo.titleMedium.size; font.weight: Font.Medium }

    function recalculateWidth() {
        var maxTextW = 0;
        for (var i = 0; i < items.count; i++) {
            textMeasurer.text = items.get(i).label || "";
            if (textMeasurer.width > maxTextW) maxTextW = textMeasurer.width;
        }
        var totalItemWidth = 12 + 16 + 24 + 12 + maxTextW + 16 + 12;
        var totalFabWidth = 0;
        if (showFab && fabText !== "") { fabMeasurer.text = fabText; totalFabWidth = 16 + 16 + 24 + 8 + fabMeasurer.width + 16 + 16; }
        calculatedExpandedWidth = Math.max(totalItemWidth, totalFabWidth);
    }
    onItemsChanged: recalculateWidth()
    Component.onCompleted: recalculateWidth()

    implicitWidth: _isRail ? railWidth : calculatedExpandedWidth
    implicitHeight: parent ? parent.height : 800
    opacity: enabled ? 1.0 : 0.38
    Layout.preferredWidth: implicitWidth
    Layout.minimumWidth: implicitWidth
    Behavior on implicitWidth { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

    Rectangle { anchors.fill: parent; color: colors.surface; Behavior on color { ColorAnimation { duration: 200 } } }

    FocusScope {
        anchors.fill: parent
        focus: true

        Column {
            id: headerSection
            anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right
            anchors.topMargin: 12; spacing: 12; z: 20

            Item {
                visible: navigationRail.showMenuButton; width: parent.width; height: 48
                RailIconButton { anchors.centerIn: navigationRail._isRail ? parent : undefined; anchors.left: !navigationRail._isRail ? parent.left : undefined; anchors.leftMargin: !navigationRail._isRail ? 12 : 0; anchors.verticalCenter: parent.verticalCenter; icon: navigationRail.menuIcon; Accessible.name: "Navigation Menu"; Accessible.role: Accessible.Button; onClicked: navigationRail.menuClicked() }
            }
            Item {
                visible: navigationRail.showFab; width: parent.width; height: 56
                RailFAB { visible: navigationRail._isRail; anchors.centerIn: parent; icon: navigationRail.fabIcon; Accessible.name: navigationRail.fabText; onClicked: navigationRail.fabClicked() }
                ExtendedFAB { visible: !navigationRail._isRail; anchors.left: parent.left; anchors.leftMargin: 16; icon: navigationRail.fabIcon; text: navigationRail.fabText; Accessible.name: navigationRail.fabText; onClicked: navigationRail.fabClicked() }
            }
        }

        ScrollView {
            id: contentScroll
            anchors.top: headerSection.bottom; anchors.topMargin: 24; anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; anchors.bottomMargin: 12
            clip: true; contentWidth: availableWidth; ScrollBar.vertical.policy: ScrollBar.AsNeeded

            ColumnLayout {
                id: navColumn
                width: parent.width; spacing: 0
                Item { visible: alignment === "middle" || alignment === "bottom"; Layout.fillHeight: true }
                Repeater {
                    model: navigationRail.items
                    delegate: Loader {
                        Layout.fillWidth: true; Layout.preferredHeight: navigationRail._isRail ? 64 : 56
                        sourceComponent: navigationRail._isRail ? railItemComponent : expandedItemComponent
                        property int itemIndex: index; property string itemIcon: model.icon || ""; property string itemActiveIcon: model.activeIcon || model.icon || ""; property string itemLabel: model.label || ""; property bool itemSelected: navigationRail.selectedIndex === index
                    }
                }
                Item { visible: alignment === "middle" || alignment === "top"; Layout.fillHeight: true }
            }
        }
    }

    function ensureVisible(item) {
        var p = item.mapToItem(contentScroll.contentItem, 0, 0);
        if (p.y < contentScroll.contentY) contentScroll.contentY = p.y;
        else if (p.y + item.height > contentScroll.contentY + contentScroll.height) contentScroll.contentY = (p.y + item.height) - contentScroll.height;
    }

    Component {
        id: railItemComponent
        Item {
            id: rItem
            property string displayIcon: itemSelected && itemActiveIcon !== "" ? itemActiveIcon : itemIcon
            readonly property color _tint: itemSelected ? colors.onSecondaryContainer : colors.onSurfaceVariant

            Item {
                width: railWidth
                height: 64
                anchors.centerIn: parent

                Column {
                    anchors.centerIn: parent
                    spacing: 4
                    Item {
                        width: 56
                        height: 32
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        // 1. Hover Layer (Only handles hover, ignores clicks so it doesn't flash)
                        Common.StateLayer { anchors.fill: parent; layerColor: rItem._tint; containerRadius: 16; pressed: false; hovered: rItemMouse.containsMouse }
                        
                        // 2. The Growing Pill (Physically expands from 0 to 56)
                        Rectangle {
                            id: rItemBg
                            anchors.centerIn: parent
                            width: itemSelected ? 56 : 0
                            height: 32
                            radius: 16
                            color: colors.secondaryContainer
                            // Emphasized bouncing physics so the movement is highly visible
                            Behavior on width { NumberAnimation { duration: 350; easing.type: Easing.OutBack; easing.overshoot: 1.5 } }
                        }
                        
                        // 3. The Ripple (Handles the click visually)
                        Common.Ripple { id: rItemRipple; anchors.fill: parent; color: rItem._tint; radius: 16 }

                        // 4. The Icon
                        Common.Icon { anchors.centerIn: parent; source: displayIcon; size: 24; color: rItem._tint }
                    }
                    Text { anchors.horizontalCenter: parent.horizontalCenter; text: itemLabel; font.family: Theme.ChiTheme.fontFamily; font.pixelSize: navigationRail._typo.bodySmall.size; font.weight: itemSelected ? Font.Medium : Font.Normal; color: itemSelected ? colors.onSurface : colors.onSurfaceVariant; elide: Text.ElideRight; width: railWidth - 8; horizontalAlignment: Text.AlignHCenter }
                }
            }

            Rectangle { anchors.fill: parent; anchors.margins: 4; radius: 12; color: "transparent"; border.width: 2; border.color: colors.primary; visible: rItem.activeFocus }
            activeFocusOnTab: true
            Accessible.role: Accessible.Button
            Accessible.name: itemLabel
            Keys.onEnterPressed: trigger()
            Keys.onReturnPressed: trigger()
            function trigger() { navigationRail.selectedIndex = itemIndex; navigationRail.itemClicked(itemIndex); }
            
            MouseArea {
                id: rItemMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onPressed: (mouse) => { var m = rItemMouse.mapToItem(rItemRipple, mouse.x, mouse.y); rItemRipple.addRipple(m.x, m.y); }
                onReleased: rItemRipple.removeRipple()
                onCanceled: rItemRipple.removeRipple()
                onClicked: parent.trigger()
            }
            onActiveFocusChanged: if (activeFocus) navigationRail.ensureVisible(rItem)
        }
    }

    Component {
        id: expandedItemComponent
        Item {
            id: eItem
            property string displayIcon: itemSelected && itemActiveIcon !== "" ? itemActiveIcon : itemIcon
            readonly property color _tint: itemSelected ? colors.onSecondaryContainer : colors.onSurfaceVariant

            Rectangle {
                id: activePill
                height: 56
                radius: 28
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                width: contentRow.implicitWidth + 32
                color: itemSelected ? colors.secondaryContainer : "transparent"
                Behavior on color { ColorAnimation { duration: 250 } }

                Common.StateLayer { anchors.fill: parent; layerColor: eItem._tint; containerRadius: 28; pressed: false; hovered: expItemMouse.containsMouse }
                Common.Ripple { id: expItemRipple; anchors.fill: parent; color: eItem._tint; radius: 28 }

                Row {
                    id: contentRow
                    anchors.centerIn: parent
                    spacing: 12
                    Common.Icon { source: displayIcon; size: 24; anchors.verticalCenter: parent.verticalCenter; color: eItem._tint }
                    Text { text: itemLabel; font.family: Theme.ChiTheme.fontFamily; font.pixelSize: navigationRail._typo.labelLarge.size; font.weight: itemSelected ? Font.Medium : Font.Normal; color: eItem._tint; anchors.verticalCenter: parent.verticalCenter }
                }
            }

            Rectangle { anchors.fill: activePill; anchors.margins: -2; radius: 30; color: "transparent"; border.width: 2; border.color: colors.primary; visible: eItem.activeFocus }
            activeFocusOnTab: true
            Accessible.role: Accessible.Button
            Accessible.name: itemLabel
            Keys.onEnterPressed: trigger()
            Keys.onReturnPressed: trigger()
            function trigger() { navigationRail.selectedIndex = itemIndex; navigationRail.itemClicked(itemIndex); }
            MouseArea {
                id: expItemMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onPressed: (mouse) => { var m = expItemMouse.mapToItem(expItemRipple, mouse.x, mouse.y); expItemRipple.addRipple(m.x, m.y); }
                onReleased: expItemRipple.removeRipple()
                onCanceled: expItemRipple.removeRipple()
                onClicked: parent.trigger()
            }
            onActiveFocusChanged: if (activeFocus) navigationRail.ensureVisible(eItem)
        }
    }

    component RailIconButton: Item {
        property string icon: ""
        signal clicked
        width: 48
        height: 48
        activeFocusOnTab: true
        Rectangle {
            id: rBtnBg
            anchors.centerIn: parent
            width: 40
            height: 40
            radius: 20
            color: "transparent"
            Common.StateLayer { anchors.fill: parent; layerColor: colors.onSurfaceVariant; containerRadius: 20; pressed: false; hovered: btnMouse.containsMouse }
            Common.Ripple { id: rBtnRipple; anchors.fill: parent; color: colors.onSurfaceVariant; radius: 20 }
            Common.Icon { anchors.centerIn: parent; source: icon; size: 24; color: colors.onSurfaceVariant }
        }
        Rectangle { anchors.fill: parent; radius: 24; color: "transparent"; border.width: 2; border.color: colors.primary; visible: parent.activeFocus }
        Keys.onEnterPressed: parent.clicked()
        Keys.onReturnPressed: parent.clicked()
        MouseArea {
            id: btnMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onPressed: (mouse) => { var m = btnMouse.mapToItem(rBtnRipple, mouse.x, mouse.y); rBtnRipple.addRipple(m.x, m.y); }
            onReleased: rBtnRipple.removeRipple()
            onCanceled: rBtnRipple.removeRipple()
            onClicked: parent.clicked()
        }
    }

    component RailFAB: Item {
        property string icon: ""
        signal clicked
        width: 56
        height: 56
        activeFocusOnTab: true
        Rectangle {
            id: fabBg
            anchors.fill: parent
            radius: 16
            color: colors.primaryContainer
            layer.enabled: true
            layer.effect: MultiEffect { shadowEnabled: true; shadowColor: Qt.rgba(0, 0, 0, 0.2); shadowVerticalOffset: 2; shadowBlur: 0.2 }
            Common.StateLayer { anchors.fill: parent; layerColor: colors.onPrimaryContainer; containerRadius: 16; pressed: false; hovered: fabMouse.containsMouse }
            Common.Ripple { id: fabRipple; anchors.fill: parent; color: colors.onPrimaryContainer; radius: 16 }
            Common.Icon { anchors.centerIn: parent; source: icon; size: 24; color: colors.onPrimaryContainer }
        }
        Rectangle { anchors.fill: parent; radius: 16; color: "transparent"; border.width: 2; border.color: colors.primary; visible: parent.activeFocus }
        Keys.onEnterPressed: parent.clicked()
        Keys.onReturnPressed: parent.clicked()
        MouseArea {
            id: fabMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onPressed: (mouse) => { var m = fabMouse.mapToItem(fabRipple, mouse.x, mouse.y); fabRipple.addRipple(m.x, m.y); }
            onReleased: fabRipple.removeRipple()
            onCanceled: fabRipple.removeRipple()
            onClicked: parent.clicked()
        }
    }

    component ExtendedFAB: Item {
        property string icon: ""
        property string text: ""
        signal clicked
        implicitWidth: extRow.implicitWidth + 32
        implicitHeight: 56
        activeFocusOnTab: true

        Rectangle {
            id: extFabBg
            anchors.fill: parent
            radius: 16
            color: colors.primaryContainer
            layer.enabled: true
            layer.effect: MultiEffect { shadowEnabled: true; shadowColor: Qt.rgba(0, 0, 0, 0.2); shadowVerticalOffset: 2; shadowBlur: 0.2 }
            Common.StateLayer { anchors.fill: parent; layerColor: colors.onPrimaryContainer; containerRadius: 16; pressed: false; hovered: extFabMouse.containsMouse }
            Common.Ripple { id: extFabRipple; anchors.fill: parent; color: colors.onPrimaryContainer; radius: 16 }
            Row {
                id: extRow
                anchors.centerIn: parent
                spacing: 8
                Common.Icon { source: icon; size: 24; anchors.verticalCenter: parent.verticalCenter; color: colors.onPrimaryContainer }
                Text { text: parent.parent.parent.text; font.family: Theme.ChiTheme.fontFamily; font.pixelSize: navigationRail._typo.titleMedium.size; font.weight: Font.Medium; color: colors.onPrimaryContainer; anchors.verticalCenter: parent.verticalCenter }
            }
        }
        Rectangle { anchors.fill: parent; radius: 16; color: "transparent"; border.width: 2; border.color: colors.primary; visible: parent.activeFocus }
        Keys.onEnterPressed: parent.clicked()
        Keys.onReturnPressed: parent.clicked()
        MouseArea {
            id: extFabMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onPressed: (mouse) => { var m = extFabMouse.mapToItem(extFabRipple, mouse.x, mouse.y); extFabRipple.addRipple(m.x, m.y); }
            onReleased: extFabRipple.removeRipple()
            onCanceled: extFabRipple.removeRipple()
            onClicked: parent.clicked()
        }
    }
}
