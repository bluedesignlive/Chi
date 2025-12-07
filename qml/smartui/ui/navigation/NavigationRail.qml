import QtQuick
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme
import "../FAB" as Fab

Item {
    id: navigationRail

    property string variant: "rail"      // "rail" or "expanded"
    property string alignment: "top"     // "top" or "middle"
    property bool showMenuButton: true
    property bool showFab: true
    property string fabIcon: "add"
    property string fabText: "New"
    property string menuIcon: "menu"
    property int selectedIndex: 0
    property bool enabled: true

    // Consumers fill these
    property ListModel items: ListModel { }
    property ListModel sections: ListModel { }

    signal itemClicked(int index)
    signal fabClicked()
    signal menuClicked()

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    readonly property int railWidth: 96
    readonly property int expandedWidth: 220
    readonly property int contentMargin: 16

    property var colors: Theme.ChiTheme.colors

    implicitWidth: variant === "rail" ? railWidth : expandedWidth
    implicitHeight: parent ? parent.height : 800

    Rectangle {
        id: bg
        anchors.fill: parent
        color: colors.surface

        // Main content area inside the rail, with top/bottom paddings
        Item {
            id: contentArea
            anchors {
                fill: parent
                topMargin: 44
                bottomMargin: variant === "rail" ? 56 : 20
            }

            // Menu + FAB section pinned to top of contentArea
            Item {
                id: menuFabSection
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                height: 116

                // Menu button
                IconButton {
                    id: menuButton
                    visible: showMenuButton
                    icon: menuIcon
                    anchors {
                        left: parent.left
                        leftMargin: contentMargin
                        top: parent.top
                    }
                    onClicked: navigationRail.menuClicked()
                }

                // FAB in rail mode — centered horizontally
                Item {
                    id: fabRail
                    visible: showFab && variant === "rail"
                    anchors {
                        bottom: parent.bottom
                        horizontalCenter: parent.horizontalCenter
                    }

                    Fab.FAB {
                        icon: fabIcon
                        variant: "primary"
                        onClicked: navigationRail.fabClicked()
                    }
                }

                // Extended FAB in expanded mode — left aligned
                Item {
                    id: fabExpanded
                    visible: showFab && variant === "expanded"
                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                        leftMargin: contentMargin
                    }

                    ExtendedFAB {
                        icon: fabIcon
                        text: fabText
                        onClicked: navigationRail.fabClicked()
                    }
                }
            }

            // Navigation area: all space below menuFabSection
            Item {
                id: navArea
                anchors {
                    left: parent.left
                    right: parent.right
                    top: menuFabSection.bottom
                    bottom: parent.bottom
                }

                // Column of items inside navArea
                Column {
                    id: itemsColumn
                    anchors {
                        left: parent.left
                        right: parent.right
                        leftMargin: contentMargin
                        rightMargin: contentMargin

                        // Vertical alignment logic:
                        // - "top": pin to top
                        // - "middle": center in navArea
                        top: alignment === "top" ? parent.top : undefined
                        verticalCenter: alignment === "middle" ? parent.verticalCenter : undefined
                    }
                    spacing: variant === "rail" ? 4 : 0

                    // Flat list of items (no sections)
                    Repeater {
                        model: sections.count === 0 ? navigationRail.items : 0

                        delegate: NavItem {
                            variant: navigationRail.variant
                            icon: model.icon
                            activeIcon: model.activeIcon || model.icon
                            label: model.label
                            selected: navigationRail.selectedIndex === index
                            badge: model.badge || "none"
                            badgeText: model.badgeText || ""
                            enabled: navigationRail.enabled

                            onClicked: {
                                navigationRail.selectedIndex = index
                                navigationRail.itemClicked(index)
                            }
                        }
                    }

                    // Sectioned items (expanded only)
                    Repeater {
                        model: sections.count > 0 ? sections : 0

                        delegate: Column {
                            width: parent.width
                            spacing: 0

                            Item {
                                visible: model.title !== ""
                                width: parent.width
                                height: 36

                                Text {
                                    anchors {
                                        left: parent.left
                                        verticalCenter: parent.verticalCenter
                                    }
                                    text: model.title || ""
                                    font.family: "Roboto"
                                    font.weight: Font.Medium
                                    font.pixelSize: 14
                                    font.letterSpacing: 0.1
                                    lineHeight: 20
                                    lineHeightMode: Text.FixedHeight
                                    color: colors.onSurfaceVariant
                                }
                            }

                            Repeater {
                                model: model.items
                                delegate: NavItem {
                                    variant: navigationRail.variant
                                    icon: modelData.icon
                                    activeIcon: modelData.activeIcon || modelData.icon
                                    label: modelData.label
                                    selected: modelData.id === navigationRail.selectedIndex
                                    badge: modelData.badge || "none"
                                    badgeText: modelData.badgeText || ""
                                    enabled: navigationRail.enabled

                                    onClicked: {
                                        navigationRail.selectedIndex = modelData.id
                                        navigationRail.itemClicked(modelData.id)
                                    }
                                }
                            }

                            Item {
                                width: 1
                                height: index < sections.count - 1 ? 12 : 0
                            }
                        }
                    }
                }
            }
        }
    }

    // ===== Local IconButton (menu) =====
    component IconButton: Item {
        id: iconBtn
        property string icon: ""
        signal clicked()

        width: 56
        height: 56

        Rectangle {
            anchors.fill: parent
            radius: 16
            color: "transparent"
            clip: true

            Rectangle {
                id: iconRipple
                anchors.fill: parent
                radius: parent.radius
                color: colors.onSurfaceVariant
                opacity: 0

                SequentialAnimation on opacity {
                    id: iconRippleAnimation
                    running: false
                    NumberAnimation { from: 0; to: 0.12; duration: 90;  easing.type: Easing.OutCubic }
                    NumberAnimation { to: 0;              duration: 210; easing.type: Easing.OutCubic }
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: colors.onSurfaceVariant
                opacity: iconMouseArea.pressed ? 0.12 : iconMouseArea.containsMouse ? 0.08 : 0
                Behavior on opacity {
                    NumberAnimation { duration: iconMouseArea.pressed ? 50 : 150; easing.type: Easing.OutCubic }
                }
            }

            readonly property bool isImageIcon: icon.indexOf(".") !== -1 || icon.indexOf("/") !== -1

            Image {
                id: iconImage
                anchors.centerIn: parent
                width: 24
                height: 24
                visible: isImageIcon
                source: isImageIcon ? icon : ""
                fillMode: Image.PreserveAspectFit
            }

            Text {
                anchors.centerIn: parent
                visible: !iconImage.visible
                text: icon
                font.family: "Material Icons"
                font.pixelSize: 24
                color: colors.onSurfaceVariant
            }
        }

        MouseArea {
            id: iconMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onPressed: iconRippleAnimation.restart()
            onClicked: iconBtn.clicked()
        }
    }

    // ===== Extended FAB (local) =====
    component ExtendedFAB: Item {
        property string icon: ""
        property string text: ""
        signal clicked()

        width: 144
        height: 56

        Rectangle {
            anchors.fill: parent
            radius: 16
            color: colors.primaryContainer
            clip: true

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: fabMouseArea.containsMouse ? 2 : 1
                radius: fabMouseArea.containsMouse ? 8 : 4
                samples: 17
                color: Qt.rgba(0, 0, 0, 0.3)
            }

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: colors.onPrimaryContainer
                opacity: fabMouseArea.pressed ? 0.12 : fabMouseArea.containsMouse ? 0.08 : 0
                Behavior on opacity {
                    NumberAnimation { duration: fabMouseArea.pressed ? 50 : 150; easing.type: Easing.OutCubic }
                }
            }

            Row {
                anchors.centerIn: parent
                spacing: 8

                readonly property bool isImageIcon: icon.indexOf(".") !== -1 || icon.indexOf("/") !== -1

                Image {
                    id: extIconImage
                    width: 24
                    height: 24
                    visible: isImageIcon
                    source: isImageIcon ? icon : ""
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    visible: !extIconImage.visible
                    text: icon
                    font.family: "Material Icons"
                    font.pixelSize: 24
                    color: colors.onPrimaryContainer
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: ExtendedFAB.text
                    font.family: "Roboto"
                    font.weight: Font.Medium
                    font.pixelSize: 16
                    font.letterSpacing: 0.15
                    lineHeight: 24
                    lineHeightMode: Text.FixedHeight
                    color: colors.onPrimaryContainer
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        MouseArea {
            id: fabMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: parent.clicked()
        }
    }

    // ===== Navigation Item =====
    component NavItem: Item {
        id: navItem

        property string variant: "rail"
        property string icon: ""
        property string activeIcon: ""
        property string label: ""
        property bool selected: false
        property string badge: "none"   // "none", "small", "large"
        property string badgeText: ""
        property bool enabled: true

        signal clicked()

        width: parent ? parent.width : (variant === "rail" ? railWidth : expandedWidth)
        height: variant === "rail" ? 64 : 56

        states: [
            State { name: "disabled"; when: !enabled },
            State { name: "pressed";  when: itemMouseArea.pressed && enabled },
            State { name: "focused";  when: navItem.activeFocus && enabled && !itemMouseArea.pressed },
            State { name: "hovered";  when: itemMouseArea.containsMouse && enabled && !itemMouseArea.pressed },
            State { name: "enabled";  when: enabled && !itemMouseArea.containsMouse && !itemMouseArea.pressed && !navItem.activeFocus }
        ]

        // Rail layout
        Column {
            visible: variant === "rail"
            anchors.centerIn: parent
            spacing: 4

            Item {
                width: 56
                height: 32
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    anchors.fill: parent
                    radius: 16
                    color: selected ? colors.secondaryContainer : "transparent"
                    clip: true

                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        color: selected ? colors.onSecondaryContainer : colors.onSurface
                        opacity: {
                            if (!enabled) return 0
                            switch (navItem.state) {
                            case "pressed": return 0.12
                            case "focused": return 0.12
                            case "hovered": return 0.08
                            default:        return 0
                            }
                        }
                        Behavior on opacity {
                            NumberAnimation { duration: navItem.state === "pressed" ? 50 : 150; easing.type: Easing.OutCubic }
                        }
                    }

                    readonly property string effectiveIcon: selected && activeIcon !== "" ? activeIcon : icon
                    readonly property bool isImageIcon: effectiveIcon.indexOf(".") !== -1 || effectiveIcon.indexOf("/") !== -1

                    Image {
                        id: railIconImage
                        anchors.centerIn: parent
                        width: 24
                        height: 24
                        visible: isImageIcon
                        source: isImageIcon ? effectiveIcon : ""
                        fillMode: Image.PreserveAspectFit
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: !railIconImage.visible
                        text: effectiveIcon
                        font.family: "Material Icons"
                        font.pixelSize: 24
                        color: selected ? colors.onSecondaryContainer : colors.onSurfaceVariant
                    }
                }

                Badge {
                    anchors {
                        right: parent.right
                        rightMargin: badge === "small" ? 16 : 14
                        top: parent.top
                        topMargin: 4
                    }
                    type: badge
                    text: badgeText
                }
            }

            Text {
                width: railWidth
                text: label
                font.family: "Roboto"
                font.weight: Font.Medium
                font.pixelSize: 12
                font.letterSpacing: 0.5
                lineHeight: 16
                lineHeightMode: Text.FixedHeight
                horizontalAlignment: Text.AlignHCenter
                color: selected ? colors.secondary : colors.onSurfaceVariant
            }
        }

        // Expanded layout
        Rectangle {
            id: expandedBg
            visible: variant === "expanded"
            anchors.fill: parent
            radius: 100
            color: selected ? colors.secondaryContainer : "transparent"
            clip: true

            Rectangle {
                id: expandedRipple
                anchors.fill: parent
                radius: parent.radius
                color: selected ? colors.onSecondaryContainer : colors.primary
                opacity: 0

                SequentialAnimation on opacity {
                    id: expandedRippleAnimation
                    running: false
                    NumberAnimation { from: 0; to: 0.12; duration: 90;  easing.type: Easing.OutCubic }
                    NumberAnimation { to: 0;              duration: 210; easing.type: Easing.OutCubic }
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: selected ? colors.onSecondaryContainer : colors.onSurface
                opacity: {
                    if (!enabled) return 0
                    switch (navItem.state) {
                    case "pressed": return 0.12
                    case "focused": return 0.12
                    case "hovered": return 0.08
                    default:        return 0
                    }
                }
                Behavior on opacity {
                    NumberAnimation { duration: navItem.state === "pressed" ? 50 : 150; easing.type: Easing.OutCubic }
                }
            }

            Row {
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: 16
                    rightMargin: 16
                    verticalCenter: parent.verticalCenter
                }
                spacing: 8

                readonly property string effectiveIcon: selected && activeIcon !== "" ? activeIcon : icon
                readonly property bool isImageIcon: effectiveIcon.indexOf(".") !== -1 || effectiveIcon.indexOf("/") !== -1

                Image {
                    id: expIconImage
                    width: 24
                    height: 24
                    visible: isImageIcon
                    source: isImageIcon ? effectiveIcon : ""
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    visible: !expIconImage.visible
                    text: effectiveIcon
                    font.family: "Material Icons"
                    font.pixelSize: 24
                    color: selected ? colors.onSecondaryContainer : colors.onSurfaceVariant
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: label
                    font.family: "Roboto"
                    font.weight: Font.Medium
                    font.pixelSize: 14
                    font.letterSpacing: 0.1
                    lineHeight: 20
                    lineHeightMode: Text.FixedHeight
                    color: selected ? colors.onSecondaryContainer : colors.onSurfaceVariant
                    anchors.verticalCenter: parent.verticalCenter
                }

                Badge {
                    visible: badge !== "none"
                    type: badge
                    text: badgeText
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // Focus ring
        Rectangle {
            visible: navItem.state === "focused"
            anchors.fill: parent
            anchors.margins: variant === "rail" ? 8 : 4
            radius: variant === "rail" ? 24 : 100
            color: "transparent"
            border.width: 3
            border.color: colors.secondary
        }

        MouseArea {
            id: itemMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onPressed: if (variant === "expanded") expandedRippleAnimation.restart()
            onClicked: navItem.clicked()
        }
    }

    // ===== Badge =====
    component Badge: Item {
        property string type: "none"
        property string text: ""

        visible: type !== "none"
        width: type === "small" ? 6 : Math.max(16, badgeLabel.width + 8)
        height: type === "small" ? 6 : 16

        Rectangle {
            anchors.fill: parent
            radius: 100
            color: colors.error

            Text {
                id: badgeLabel
                visible: type === "large" && text !== ""
                anchors.centerIn: parent
                text: parent.parent.text
                font.family: "Roboto"
                font.weight: Font.Medium
                font.pixelSize: 11
                font.letterSpacing: 0.5
                lineHeight: 16
                lineHeightMode: Text.FixedHeight
                color: colors.onError
            }
        }
    }
}
