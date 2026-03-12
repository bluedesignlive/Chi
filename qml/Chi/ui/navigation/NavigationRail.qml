// // // import QtQuick
// // // import QtQuick.Layouts
// // // import QtQuick.Controls.Basic
// // // import Qt5Compat.GraphicalEffects
// // // import "../theme" as Theme

// // // Item {
// // //     id: navigationRail

// // //     property string variant: "rail"
// // //     property string alignment: "top"
    
// // //     // Feature: Allow custom icon font (e.g., Nerd Fonts)
// // //     property string iconFont: ""

// // //     property bool showMenuButton: true
// // //     property string menuIcon: "menu"
    
// // //     property bool showFab: true
// // //     property string fabIcon: "+"
// // //     property string fabText: "New"

// // //     property int selectedIndex: 0
// // //     property bool enabled: true

// // //     property ListModel items: ListModel {}
// // //     property ListModel sections: ListModel {}

// // //     signal itemClicked(int index)
// // //     signal fabClicked()
// // //     signal menuClicked()

// // //     opacity: enabled ? 1.0 : 0.38
// // //     readonly property int railWidth: 80
// // //     readonly property int expandedWidth: 256
// // //     property var colors: Theme.ChiTheme.colors

// // //     implicitWidth: variant === "rail" ? railWidth : expandedWidth
// // //     implicitHeight: parent ? parent.height : 800

// // //     Behavior on implicitWidth {
// // //         NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
// // //     }

// // //     Rectangle {
// // //         anchors.fill: parent
// // //         color: colors.surface
// // //         Behavior on color { ColorAnimation { duration: 200 } }
// // //     }

// // //     // HEADER
// // //     Column {
// // //         id: headerSection
// // //         anchors.top: parent.top
// // //         anchors.topMargin: 12
// // //         anchors.left: parent.left
// // //         anchors.right: parent.right
// // //         spacing: 4
// // //         z: 10

// // //         Item {
// // //             visible: showMenuButton
// // //             width: parent.width
// // //             height: 56
            
// // //             RailIconButton {
// // //                 anchors.centerIn: variant === "rail" ? parent : undefined
// // //                 anchors.left: variant === "expanded" ? parent.left : undefined
// // //                 anchors.leftMargin: variant === "expanded" ? 16 : 0
// // //                 anchors.verticalCenter: parent.verticalCenter
// // //                 icon: menuIcon
// // //                 onClicked: navigationRail.menuClicked()
// // //             }
// // //         }

// // //         Item {
// // //             visible: showFab
// // //             width: parent.width
// // //             height: 56
            
// // //             RailFAB {
// // //                 visible: variant === "rail"
// // //                 anchors.centerIn: parent
// // //                 icon: fabIcon
// // //                 onClicked: navigationRail.fabClicked()
// // //             }
            
// // //             ExtendedFAB {
// // //                 visible: variant === "expanded"
// // //                 anchors.left: parent.left
// // //                 anchors.leftMargin: 12
// // //                 anchors.verticalCenter: parent.verticalCenter
// // //                 icon: fabIcon
// // //                 text: fabText
// // //                 onClicked: navigationRail.fabClicked()
// // //             }
// // //         }
// // //     }

// // //     // BODY
// // //     Item {
// // //         id: navContainer
// // //         anchors.left: parent.left
// // //         anchors.right: parent.right
// // //         anchors.top: headerSection.bottom
// // //         anchors.topMargin: 12
// // //         anchors.bottom: parent.bottom
// // //         anchors.bottomMargin: 12

// // //         Column {
// // //             id: navColumn
// // //             width: parent.width
// // //             spacing: variant === "rail" ? 0 : 2

// // //             states: [
// // //                 State {
// // //                     name: "top"
// // //                     when: alignment === "top"
// // //                     AnchorChanges { target: navColumn; anchors.top: navContainer.top; anchors.verticalCenter: undefined; anchors.bottom: undefined }
// // //                 },
// // //                 State {
// // //                     name: "middle"
// // //                     when: alignment === "middle"
// // //                     AnchorChanges { target: navColumn; anchors.top: undefined; anchors.verticalCenter: navContainer.verticalCenter; anchors.bottom: undefined }
// // //                 },
// // //                 State {
// // //                     name: "bottom"
// // //                     when: alignment === "bottom"
// // //                     AnchorChanges { target: navColumn; anchors.top: undefined; anchors.verticalCenter: undefined; anchors.bottom: navContainer.bottom }
// // //                 }
// // //             ]
// // //             transitions: Transition { AnchorAnimation { duration: 200; easing.type: Easing.OutCubic } }

// // //             Repeater {
// // //                 model: sections.count === 0 ? navigationRail.items : null
// // //                 delegate: Loader {
// // //                     width: navColumn.width
// // //                     sourceComponent: variant === "rail" ? railItemComponent : expandedItemComponent
// // //                     property int itemIndex: index
// // //                     property string itemIcon: model.icon || ""
// // //                     property string itemActiveIcon: model.activeIcon || model.icon || ""
// // //                     property string itemLabel: model.label || ""
// // //                     property bool itemSelected: navigationRail.selectedIndex === index
// // //                 }
// // //             }
// // //         }
// // //     }

// // //     // INTERNAL COMPONENTS
// // //     Component {
// // //         id: railItemComponent
// // //         Item {
// // //             width: parent ? parent.width : railWidth
// // //             height: 56
// // //             property string displayIcon: itemSelected && itemActiveIcon !== "" ? itemActiveIcon : itemIcon

// // //             Column {
// // //                 anchors.centerIn: parent
// // //                 spacing: 4
                
// // //                 Item {
// // //                     width: 56
// // //                     height: 32
// // //                     anchors.horizontalCenter: parent.horizontalCenter
                    
// // //                     Rectangle {
// // //                         anchors.centerIn: parent
// // //                         width: itemSelected ? 56 : 0
// // //                         height: 32
// // //                         radius: 16
// // //                         color: colors.secondaryContainer
// // //                         Behavior on width { NumberAnimation { duration: 200 } }
// // //                     }
                    
// // //                     Rectangle {
// // //                         anchors.centerIn: parent
// // //                         width: 56
// // //                         height: 32
// // //                         radius: 16
// // //                         color: itemSelected ? colors.onSecondaryContainer : colors.onSurface
// // //                         opacity: railItemMouse.pressed ? 0.12 : railItemMouse.containsMouse ? 0.08 : 0
// // //                     }
                    
// // //                     Item {
// // //                         anchors.centerIn: parent
// // //                         width: 24
// // //                         height: 24
// // //                         Loader {
// // //                             anchors.fill: parent
// // //                             sourceComponent: isImagePath(displayIcon) ? imageIconComp : textIconComp
// // //                             property string iconSrc: displayIcon
// // //                             property color iconClr: itemSelected ? colors.onSecondaryContainer : colors.onSurfaceVariant
// // //                         }
// // //                     }
// // //                 }
                
// // //                 Text {
// // //                     anchors.horizontalCenter: parent.horizontalCenter
// // //                     text: itemLabel
// // //                     font.family: "Roboto"
// // //                     font.pixelSize: 12
// // //                     font.weight: itemSelected ? Font.Medium : Font.Normal
// // //                     color: itemSelected ? colors.onSurface : colors.onSurfaceVariant
// // //                 }
// // //             }
// // //             MouseArea {
// // //                 id: railItemMouse
// // //                 anchors.fill: parent
// // //                 hoverEnabled: true
// // //                 cursorShape: Qt.PointingHandCursor
// // //                 onClicked: { navigationRail.selectedIndex = itemIndex; navigationRail.itemClicked(itemIndex) }
// // //             }
// // //         }
// // //     }

// // //     Component {
// // //         id: expandedItemComponent
// // //         Item {
// // //             width: parent ? parent.width : expandedWidth
// // //             height: 56
// // //             property string displayIcon: itemSelected && itemActiveIcon !== "" ? itemActiveIcon : itemIcon
            
// // //             Rectangle {
// // //                 anchors.fill: parent
// // //                 anchors.leftMargin: 12
// // //                 anchors.rightMargin: 12
// // //                 radius: 28
// // //                 color: itemSelected ? colors.secondaryContainer : "transparent"
                
// // //                 Rectangle {
// // //                     anchors.fill: parent
// // //                     radius: parent.radius
// // //                     color: itemSelected ? colors.onSecondaryContainer : colors.onSurface
// // //                     opacity: expItemMouse.pressed ? 0.12 : expItemMouse.containsMouse ? 0.08 : 0
// // //                 }
                
// // //                 Row {
// // //                     anchors.left: parent.left
// // //                     anchors.leftMargin: 16
// // //                     anchors.verticalCenter: parent.verticalCenter
// // //                     spacing: 12
                    
// // //                     Item {
// // //                         width: 24
// // //                         height: 24
// // //                         Loader {
// // //                             anchors.fill: parent
// // //                             sourceComponent: isImagePath(displayIcon) ? imageIconComp : textIconComp
// // //                             property string iconSrc: displayIcon
// // //                             property color iconClr: itemSelected ? colors.onSecondaryContainer : colors.onSurfaceVariant
// // //                         }
// // //                     }
                    
// // //                     Text {
// // //                         text: itemLabel
// // //                         font.family: "Roboto"
// // //                         font.pixelSize: 14
// // //                         font.weight: itemSelected ? Font.Medium : Font.Normal
// // //                         color: itemSelected ? colors.onSecondaryContainer : colors.onSurfaceVariant
// // //                         anchors.verticalCenter: parent.verticalCenter
// // //                     }
// // //                 }
// // //                 MouseArea {
// // //                     id: expItemMouse
// // //                     anchors.fill: parent
// // //                     hoverEnabled: true
// // //                     cursorShape: Qt.PointingHandCursor
// // //                     onClicked: { navigationRail.selectedIndex = itemIndex; navigationRail.itemClicked(itemIndex) }
// // //                 }
// // //             }
// // //         }
// // //     }

// // //     function isImagePath(icon) {
// // //         if (!icon || icon === "") return false
// // //         var s = icon.toLowerCase()
// // //         return s.indexOf("/") !== -1 || s.indexOf(".") !== -1 || s.indexOf("qrc:") !== -1
// // //     }

// // //     Component {
// // //         id: textIconComp
// // //         Text {
// // //             text: iconSrc
// // //             // Use custom font if set, otherwise default to Material Icons
// // //             font.family: navigationRail.iconFont !== "" ? navigationRail.iconFont : "Material Icons"
// // //             font.pixelSize: 22
// // //             color: iconClr
// // //             horizontalAlignment: Text.AlignHCenter
// // //             verticalAlignment: Text.AlignVCenter
// // //             Behavior on color { ColorAnimation { duration: 150 } }
// // //         }
// // //     }

// // //     Component {
// // //         id: imageIconComp
// // //         Image {
// // //             source: iconSrc
// // //             sourceSize: Qt.size(24, 24)
// // //             fillMode: Image.PreserveAspectFit
// // //             smooth: true
// // //             mipmap: true
// // //         }
// // //     }

// // //     component RailIconButton: Item {
// // //         property string icon: ""
// // //         signal clicked()
// // //         width: 48
// // //         height: 48
        
// // //         Rectangle {
// // //             anchors.centerIn: parent
// // //             width: 40
// // //             height: 40
// // //             radius: 20
// // //             color: colors.onSurfaceVariant
// // //             opacity: btnMouse.pressed ? 0.12 : btnMouse.containsMouse ? 0.08 : 0
// // //         }
        
// // //         Item {
// // //             anchors.centerIn: parent
// // //             width: 24
// // //             height: 24
// // //             Loader {
// // //                 anchors.fill: parent
// // //                 sourceComponent: isImagePath(icon) ? imageIconComp : textIconComp
// // //                 property string iconSrc: icon
// // //                 property color iconClr: colors.onSurfaceVariant
// // //             }
// // //         }
// // //         MouseArea {
// // //             id: btnMouse
// // //             anchors.fill: parent
// // //             hoverEnabled: true
// // //             cursorShape: Qt.PointingHandCursor
// // //             onClicked: parent.clicked()
// // //         }
// // //     }

// // //     component RailFAB: Item {
// // //         property string icon: ""
// // //         signal clicked()
// // //         width: 56
// // //         height: 56
        
// // //         Rectangle {
// // //             anchors.fill: parent
// // //             radius: 16
// // //             color: colors.primaryContainer
// // //             layer.enabled: true
// // //             layer.effect: DropShadow {
// // //                 transparentBorder: true
// // //                 verticalOffset: 1
// // //                 radius: 3
// // //                 color: Qt.rgba(0,0,0,0.2)
// // //             }
            
// // //             Item {
// // //                 anchors.centerIn: parent
// // //                 width: 24
// // //                 height: 24
// // //                 Loader {
// // //                     anchors.fill: parent
// // //                     sourceComponent: isImagePath(icon) ? imageIconComp : textIconComp
// // //                     property string iconSrc: icon
// // //                     property color iconClr: colors.onPrimaryContainer
// // //                 }
// // //             }
// // //         }
// // //         MouseArea {
// // //             anchors.fill: parent
// // //             onClicked: parent.clicked()
// // //             cursorShape: Qt.PointingHandCursor
// // //         }
// // //     }

// // //     component ExtendedFAB: Item {
// // //         property string icon: ""
// // //         property string text: ""
// // //         signal clicked()
// // //         implicitWidth: extRow.implicitWidth + 32
// // //         implicitHeight: 56
        
// // //         Rectangle {
// // //             anchors.fill: parent
// // //             radius: 16
// // //             color: colors.primaryContainer
// // //             layer.enabled: true
// // //             layer.effect: DropShadow {
// // //                 transparentBorder: true
// // //                 verticalOffset: 1
// // //                 radius: 3
// // //                 color: Qt.rgba(0,0,0,0.2)
// // //             }
            
// // //             Row {
// // //                 id: extRow
// // //                 anchors.centerIn: parent
// // //                 spacing: 12
// // //                 Item {
// // //                     width: 24
// // //                     height: 24
// // //                     Loader {
// // //                         anchors.fill: parent
// // //                         sourceComponent: isImagePath(icon) ? imageIconComp : textIconComp
// // //                         property string iconSrc: icon
// // //                         property color iconClr: colors.onPrimaryContainer
// // //                     }
// // //                 }
// // //                 Text {
// // //                     text: parent.parent.parent.text
// // //                     font.family: "Roboto"
// // //                     font.pixelSize: 14
// // //                     font.weight: Font.Medium
// // //                     color: colors.onPrimaryContainer
// // //                     anchors.verticalCenter: parent.verticalCenter
// // //                 }
// // //             }
// // //         }
// // //         MouseArea {
// // //             anchors.fill: parent
// // //             onClicked: parent.clicked()
// // //             cursorShape: Qt.PointingHandCursor
// // //         }
// // //     }
// // // }



// // import QtQuick
// // import QtQuick.Layouts
// // import QtQuick.Controls.Basic
// // import Qt5Compat.GraphicalEffects
// // import "../theme" as Theme
// // import "../common" // Imports your Icon.qml

// // Item {
// //     id: navigationRail

// //     // --- Properties ---
// //     property string variant: "rail" // "rail" or "expanded"
// //     property string alignment: "top" // "top", "middle", "bottom"

// //     // Note: iconFont is kept for API compatibility, but rendering
// //     // is now delegated to Icon.qml.
// //     property string iconFont: "Material Icons"

// //     property bool showMenuButton: true
// //     property string menuIcon: "menu"

// //     property bool showFab: true
// //     property string fabIcon: "add"
// //     property string fabText: "New"

// //     property int selectedIndex: 0
// //     property bool enabled: true

// //     property ListModel items: ListModel {}

// //     // Signals
// //     signal itemClicked(int index)
// //     signal fabClicked()
// //     signal menuClicked()

// //     // --- Dimensions (M3 Expressive Specs) ---
// //     // Expressive rail is wider (96dp) compared to standard M3 (80dp)
// //     readonly property int railWidth: 96
// //     readonly property int expandedWidth: 280

// //     // Colors
// //     property var colors: Theme.ChiTheme.colors

// //     // --- Root Sizing ---
// //     implicitWidth: variant === "rail" ? railWidth : expandedWidth
// //     implicitHeight: parent ? parent.height : 800
// //     opacity: enabled ? 1.0 : 0.38

// //     // Smooth width transition
// //     Behavior on implicitWidth {
// //         NumberAnimation { duration: 300; easing.type: Easing.OutEmphasized }
// //     }

// //     // --- Background ---
// //     Rectangle {
// //         anchors.fill: parent
// //         color: colors.surface
// //         Behavior on color { ColorAnimation { duration: 200 } }
// //     }

// //     // --- Accessibility Focus Scope ---
// //     FocusScope {
// //         anchors.fill: parent
// //         focus: true

// //         // --- Header (Menu + FAB) ---
// //         Column {
// //             id: headerSection
// //             anchors.top: parent.top
// //             anchors.left: parent.left
// //             anchors.right: parent.right
// //             anchors.topMargin: 12
// //             spacing: 12
// //             z: 10

// //             // Menu Button
// //             Item {
// //                 visible: showMenuButton
// //                 width: parent.width
// //                 height: 48

// //                 RailIconButton {
// //                     // Center in Rail, Left-align + margin in Expanded
// //                     anchors.centerIn: variant === "rail" ? parent : undefined
// //                     anchors.left: variant === "expanded" ? parent.left : undefined
// //                     anchors.leftMargin: variant === "expanded" ? 24 : 0
// //                     anchors.verticalCenter: parent.verticalCenter

// //                     icon: menuIcon

// //                     // Accessibility
// //                     Accessible.name: "Navigation Menu"
// //                     Accessible.role: Accessible.Button

// //                     onClicked: navigationRail.menuClicked()
// //                 }
// //             }

// //             // FAB
// //             Item {
// //                 visible: showFab
// //                 width: parent.width
// //                 height: 56

// //                 RailFAB {
// //                     visible: variant === "rail"
// //                     anchors.centerIn: parent
// //                     icon: fabIcon

// //                     Accessible.name: fabText
// //                     onClicked: navigationRail.fabClicked()
// //                 }

// //                 ExtendedFAB {
// //                     visible: variant === "expanded"
// //                     anchors.left: parent.left
// //                     anchors.leftMargin: 16
// //                     anchors.verticalCenter: parent.verticalCenter

// //                     icon: fabIcon
// //                     text: fabText

// //                     Accessible.name: fabText
// //                     onClicked: navigationRail.fabClicked()
// //                 }
// //             }
// //         }

// //         // --- Body (Scrollable Navigation Items) ---
// //         ScrollView {
// //             id: contentScroll
// //             anchors.top: headerSection.bottom
// //             anchors.topMargin: 24
// //             anchors.bottom: parent.bottom
// //             anchors.left: parent.left
// //             anchors.right: parent.right
// //             anchors.bottomMargin: 12

// //             ScrollBar.vertical.policy: ScrollBar.AsNeeded
// //             clip: true

// //             ColumnLayout {
// //                 id: navColumn
// //                 width: parent.width
// //                 spacing: 4

// //                 Item {
// //                     visible: alignment === "middle" || alignment === "bottom"
// //                     Layout.fillHeight: true
// //                 }

// //                 Repeater {
// //                     model: navigationRail.items
// //                     delegate: Loader {
// //                         Layout.fillWidth: true
// //                         Layout.preferredHeight: 64 // M3 Expressive Item Height

// //                         sourceComponent: variant === "rail" ? railItemComponent : expandedItemComponent

// //                         property int itemIndex: index
// //                         property string itemIcon: model.icon || ""
// //                         property string itemActiveIcon: model.activeIcon || model.icon || ""
// //                         property string itemLabel: model.label || ""
// //                         property bool itemSelected: navigationRail.selectedIndex === index
// //                     }
// //                 }

// //                 Item {
// //                     visible: alignment === "middle" || alignment === "top"
// //                     Layout.fillHeight: true
// //                 }
// //             }
// //         }
// //     }

// //     // --- COMPONENT: Collapsed Rail Item ---
// //     Component {
// //         id: railItemComponent
// //         Item {
// //             id: rItem

// //             // Interaction Props
// //             property string displayIcon: itemSelected && itemActiveIcon !== "" ? itemActiveIcon : itemIcon

// //             // Container
// //             Item {
// //                 width: railWidth
// //                 height: 64
// //                 anchors.centerIn: parent

// //                 Column {
// //                     anchors.centerIn: parent
// //                     spacing: 4

// //                     // Icon Container + Active Indicator
// //                     Item {
// //                         width: 56
// //                         height: 32
// //                         anchors.horizontalCenter: parent.horizontalCenter

// //                         // Active Indicator (Pill)
// //                         Rectangle {
// //                             anchors.centerIn: parent
// //                             width: itemSelected ? 56 : 0
// //                             height: 32
// //                             radius: 16
// //                             color: colors.secondaryContainer

// //                             Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
// //                         }

// //                         // State Layer (Hover/Focus)
// //                         Rectangle {
// //                             anchors.centerIn: parent
// //                             width: 56
// //                             height: 32
// //                             radius: 16
// //                             color: itemSelected ? colors.onSecondaryContainer : colors.onSurface
// //                             opacity: {
// //                                 if (railItemMouse.pressed) return 0.12
// //                                 if (railItemMouse.containsMouse || rItem.activeFocus) return 0.08
// //                                 return 0
// //                             }
// //                         }

// //                         // Icon Component
// //                         Icon {
// //                             anchors.centerIn: parent
// //                             source: displayIcon
// //                             size: 24
// //                             color: itemSelected ? colors.onSecondaryContainer : colors.onSurfaceVariant
// //                         }
// //                     }

// //                     // Label
// //                     Text {
// //                         anchors.horizontalCenter: parent.horizontalCenter
// //                         text: itemLabel
// //                         font.family: "Roboto"
// //                         font.pixelSize: 12
// //                         font.weight: itemSelected ? Font.Medium : Font.Normal
// //                         color: itemSelected ? colors.onSurface : colors.onSurfaceVariant
// //                         elide: Text.ElideRight
// //                         width: railWidth - 8
// //                         horizontalAlignment: Text.AlignHCenter
// //                     }
// //                 }
// //             }

// //             // Focus Ring
// //             Rectangle {
// //                 anchors.fill: parent
// //                 anchors.margins: 4
// //                 radius: 12
// //                 color: "transparent"
// //                 border.width: 2
// //                 border.color: colors.primary
// //                 visible: rItem.activeFocus
// //             }

// //             // Accessibility
// //             activeFocusOnTab: true
// //             Accessible.role: Accessible.Button
// //             Accessible.name: itemLabel
// //             Keys.onEnterPressed: trigger()
// //             Keys.onReturnPressed: trigger()
// //             function trigger() {
// //                  navigationRail.selectedIndex = itemIndex; navigationRail.itemClicked(itemIndex)
// //             }

// //             MouseArea {
// //                 id: railItemMouse
// //                 anchors.fill: parent
// //                 hoverEnabled: true
// //                 cursorShape: Qt.PointingHandCursor
// //                 onClicked: parent.trigger()
// //             }
// //         }
// //     }

// //     // --- COMPONENT: Expanded Rail Item ---
// //     Component {
// //         id: expandedItemComponent
// //         Item {
// //             id: eItem
// //             property string displayIcon: itemSelected && itemActiveIcon !== "" ? itemActiveIcon : itemIcon

// //             // Accessibility
// //             activeFocusOnTab: true
// //             Accessible.role: Accessible.Button
// //             Accessible.name: itemLabel
// //             Keys.onEnterPressed: trigger()
// //             Keys.onReturnPressed: trigger()
// //             function trigger() {
// //                  navigationRail.selectedIndex = itemIndex; navigationRail.itemClicked(itemIndex)
// //             }

// //             MouseArea {
// //                 id: expItemMouse
// //                 anchors.fill: parent
// //                 hoverEnabled: true
// //                 cursorShape: Qt.PointingHandCursor
// //                 onClicked: parent.trigger()
// //             }

// //             // Active Pill (Hugs content)
// //             Rectangle {
// //                 id: activePill
// //                 height: 56
// //                 width: contentRow.width + 32 // 16px padding on sides
// //                 radius: 28

// //                 anchors.left: parent.left
// //                 anchors.leftMargin: 12
// //                 anchors.verticalCenter: parent.verticalCenter

// //                 color: itemSelected ? colors.secondaryContainer : "transparent"

// //                 // State Layer
// //                 Rectangle {
// //                     anchors.fill: parent
// //                     radius: 28
// //                     color: itemSelected ? colors.onSecondaryContainer : colors.onSurface
// //                     opacity: {
// //                         if (expItemMouse.pressed) return 0.12
// //                         if (expItemMouse.containsMouse || eItem.activeFocus) return 0.08
// //                         return 0
// //                     }
// //                 }

// //                 Row {
// //                     id: contentRow
// //                     anchors.centerIn: parent
// //                     spacing: 12

// //                     Icon {
// //                         source: displayIcon
// //                         size: 24
// //                         anchors.verticalCenter: parent.verticalCenter
// //                         color: itemSelected ? colors.onSecondaryContainer : colors.onSurfaceVariant
// //                     }

// //                     Text {
// //                         text: itemLabel
// //                         font.family: "Roboto"
// //                         font.pixelSize: 14
// //                         font.weight: itemSelected ? Font.Medium : Font.Normal
// //                         color: itemSelected ? colors.onSecondaryContainer : colors.onSurfaceVariant
// //                         anchors.verticalCenter: parent.verticalCenter
// //                     }
// //                 }
// //             }

// //             // Focus Ring
// //             Rectangle {
// //                 anchors.fill: activePill
// //                 anchors.margins: -2
// //                 radius: 30
// //                 color: "transparent"
// //                 border.width: 2
// //                 border.color: colors.primary
// //                 visible: eItem.activeFocus
// //             }
// //         }
// //     }

// //     // --- HELPER COMPONENTS ---

// //     component RailIconButton: Item {
// //         property string icon: ""
// //         signal clicked()

// //         width: 48
// //         height: 48
// //         activeFocusOnTab: true

// //         Rectangle {
// //             anchors.centerIn: parent
// //             width: 40
// //             height: 40
// //             radius: 20
// //             color: colors.onSurfaceVariant
// //             opacity: {
// //                 if (btnMouse.pressed) return 0.12
// //                 if (btnMouse.containsMouse || parent.activeFocus) return 0.08
// //                 return 0
// //             }
// //         }

// //         Icon {
// //             anchors.centerIn: parent
// //             source: icon
// //             size: 24
// //             color: colors.onSurfaceVariant
// //         }

// //         Rectangle {
// //             anchors.fill: parent
// //             radius: 24
// //             color: "transparent"
// //             border.width: 2
// //             border.color: colors.primary
// //             visible: parent.activeFocus
// //         }

// //         Keys.onEnterPressed: parent.clicked()
// //         Keys.onReturnPressed: parent.clicked()

// //         MouseArea {
// //             id: btnMouse
// //             anchors.fill: parent
// //             hoverEnabled: true
// //             cursorShape: Qt.PointingHandCursor
// //             onClicked: parent.clicked()
// //         }
// //     }

// //     component RailFAB: Item {
// //         property string icon: ""
// //         signal clicked()

// //         width: 56
// //         height: 56
// //         activeFocusOnTab: true

// //         Rectangle {
// //             anchors.fill: parent
// //             radius: 16
// //             color: colors.primaryContainer

// //             layer.enabled: true
// //             layer.effect: DropShadow {
// //                 transparentBorder: true
// //                 verticalOffset: 2
// //                 radius: 4
// //                 color: Qt.rgba(0,0,0,0.2)
// //             }

// //             Rectangle {
// //                 anchors.fill: parent
// //                 radius: 16
// //                 color: colors.onPrimaryContainer
// //                 opacity: {
// //                     if (fabMouse.pressed) return 0.12
// //                     if (fabMouse.containsMouse || parent.parent.activeFocus) return 0.08
// //                     return 0
// //                 }
// //             }

// //             Icon {
// //                 anchors.centerIn: parent
// //                 source: icon
// //                 size: 24
// //                 color: colors.onPrimaryContainer
// //             }
// //         }

// //         // Fixed: Removed 'border.outsideStroke'
// //         Rectangle {
// //             anchors.fill: parent
// //             radius: 16
// //             color: "transparent"
// //             border.width: 2
// //             border.color: colors.primary
// //             visible: parent.activeFocus
// //             // For outside look, we can manipulate margins if needed,
// //             // but filling parent is standard accessible ring.
// //         }

// //         Keys.onEnterPressed: parent.clicked()
// //         Keys.onReturnPressed: parent.clicked()

// //         MouseArea {
// //             id: fabMouse
// //             anchors.fill: parent
// //             hoverEnabled: true
// //             onClicked: parent.clicked()
// //             cursorShape: Qt.PointingHandCursor
// //         }
// //     }

// //     component ExtendedFAB: Item {
// //         property string icon: ""
// //         property string text: ""
// //         signal clicked()

// //         implicitWidth: extRow.implicitWidth + 48
// //         implicitHeight: 56
// //         activeFocusOnTab: true

// //         Rectangle {
// //             anchors.fill: parent
// //             radius: 16
// //             color: colors.primaryContainer
// //             layer.enabled: true
// //             layer.effect: DropShadow {
// //                 transparentBorder: true
// //                 verticalOffset: 2
// //                 radius: 4
// //                 color: Qt.rgba(0,0,0,0.2)
// //             }

// //             Rectangle {
// //                 anchors.fill: parent
// //                 radius: 16
// //                 color: colors.onPrimaryContainer
// //                 opacity: {
// //                     if (extFabMouse.pressed) return 0.12
// //                     if (extFabMouse.containsMouse || parent.parent.activeFocus) return 0.08
// //                     return 0
// //                 }
// //             }

// //             Row {
// //                 id: extRow
// //                 anchors.centerIn: parent
// //                 spacing: 12
// //                 Icon {
// //                     source: icon
// //                     size: 24
// //                     anchors.verticalCenter: parent.verticalCenter
// //                     color: colors.onPrimaryContainer
// //                 }
// //                 Text {
// //                     text: parent.parent.parent.text
// //                     font.family: "Roboto"
// //                     font.pixelSize: 14
// //                     font.weight: Font.Medium
// //                     color: colors.onPrimaryContainer
// //                     anchors.verticalCenter: parent.verticalCenter
// //                 }
// //             }
// //         }

// //         Rectangle {
// //             anchors.fill: parent
// //             radius: 16
// //             color: "transparent"
// //             border.width: 2
// //             border.color: colors.primary
// //             visible: parent.activeFocus
// //         }

// //         Keys.onEnterPressed: parent.clicked()
// //         Keys.onReturnPressed: parent.clicked()

// //         MouseArea {
// //             id: extFabMouse
// //             anchors.fill: parent
// //             hoverEnabled: true
// //             onClicked: parent.clicked()
// //             cursorShape: Qt.PointingHandCursor
// //         }
// //     }
// // }



// ////////////////////


// import QtQuick
// import QtQuick.Layouts
// import QtQuick.Controls.Basic
// import Qt5Compat.GraphicalEffects
// import "../theme" as Theme
// import "../common"

// Item {
//     id: navigationRail

//     // --- Properties ---
//     property string variant: "rail" // "rail" or "expanded"
//     property string alignment: "top" // "top", "middle", "bottom"

//     // Rendering delegated to Icon.qml
//     property string iconFont: "Material Icons"

//     property bool showMenuButton: true
//     property string menuIcon: "menu"

//     property bool showFab: true
//     property string fabIcon: "add"
//     property string fabText: "New"

//     property int selectedIndex: 0
//     property bool enabled: true

//     property ListModel items: ListModel {}

//     // Signals
//     signal itemClicked(int index)
//     signal fabClicked()
//     signal menuClicked()

//     // --- Dimensions & Calculations ---
//     readonly property int railWidth: 96 // Fixed width for collapsed rail
//     property int minExpandedWidth: 200  // Minimum container width
//     property int calculatedExpandedWidth: minExpandedWidth

//     // Colors
//     property var colors: Theme.ChiTheme.colors

//     // --- Dynamic Width Logic (For the Rail Container) ---
//     // The Rail needs to be wide enough to hold the longest item,
//     // even though individual buttons hug their content.
//     TextMetrics {
//         id: textMeasurer
//         font.family: "Roboto"
//         font.pixelSize: 14
//         font.weight: Font.Medium
//     }

//     function recalculateWidth() {
//         let maxW = 0
//         for (let i = 0; i < items.count; i++) {
//             let label = items.get(i).label || ""
//             textMeasurer.text = label
//             if (textMeasurer.width > maxW) maxW = textMeasurer.width
//         }

//         // Max Text + Icon(24) + Gap(12) + PaddingLeft(16) + PaddingRight(16) + RailMargin(12) + Safety(12)
//         let contentWidth = maxW + 24 + 12 + 32
//         let totalW = contentWidth + 24

//         // Check FAB width too
//         if (showFab && fabText !== "") {
//             textMeasurer.text = fabText
//             let fabW = textMeasurer.width + 24 + 12 + 48
//             if (fabW > totalW) totalW = fabW
//         }

//         calculatedExpandedWidth = Math.max(minExpandedWidth, totalW)
//     }

//     onItemsChanged: recalculateWidth()
//     Component.onCompleted: recalculateWidth()

//     // --- Root Sizing ---
//     implicitWidth: variant === "rail" ? railWidth : calculatedExpandedWidth
//     implicitHeight: parent ? parent.height : 800
//     opacity: enabled ? 1.0 : 0.38

//     Behavior on implicitWidth {
//         NumberAnimation { duration: 300; easing.type: Easing.OutEmphasized }
//     }

//     // --- Background ---
//     Rectangle {
//         anchors.fill: parent
//         color: colors.surface
//         Behavior on color { ColorAnimation { duration: 200 } }
//     }

//     // --- Accessibility Focus Scope ---
//     FocusScope {
//         anchors.fill: parent
//         focus: true

//         // --- Header (Menu + FAB) ---
//         Column {
//             id: headerSection
//             anchors.top: parent.top
//             anchors.left: parent.left
//             anchors.right: parent.right
//             anchors.topMargin: 12
//             spacing: 12
//             z: 10

//             // Menu Button
//             Item {
//                 visible: showMenuButton
//                 width: parent.width
//                 height: 48

//                 RailIconButton {
//                     anchors.centerIn: variant === "rail" ? parent : undefined
//                     anchors.left: variant === "expanded" ? parent.left : undefined
//                     anchors.leftMargin: variant === "expanded" ? 12 : 0
//                     anchors.verticalCenter: parent.verticalCenter

//                     icon: menuIcon

//                     Accessible.name: "Navigation Menu"
//                     Accessible.role: Accessible.Button
//                     onClicked: navigationRail.menuClicked()
//                 }
//             }

//             // FAB
//             Item {
//                 visible: showFab
//                 width: parent.width
//                 height: 56

//                 RailFAB {
//                     visible: variant === "rail"
//                     anchors.centerIn: parent
//                     icon: fabIcon
//                     Accessible.name: fabText
//                     onClicked: navigationRail.fabClicked()
//                 }

//                 ExtendedFAB {
//                     visible: variant === "expanded"
//                     anchors.left: parent.left
//                     anchors.leftMargin: 16
//                     anchors.verticalCenter: parent.verticalCenter
//                     icon: fabIcon
//                     text: fabText
//                     Accessible.name: fabText
//                     onClicked: navigationRail.fabClicked()
//                 }
//             }
//         }

//         // --- Body (Scrollable Navigation Items) ---
//         ScrollView {
//             id: contentScroll
//             anchors.top: headerSection.bottom
//             anchors.topMargin: 24
//             anchors.bottom: parent.bottom
//             anchors.left: parent.left
//             anchors.right: parent.right
//             anchors.bottomMargin: 12

//             contentWidth: availableWidth
//             clip: true
//             ScrollBar.vertical.policy: ScrollBar.AsNeeded

//             ColumnLayout {
//                 id: navColumn
//                 width: parent.width

//                 // Collapsed: 4px gap. Expanded: 0px gap (dense list).
//                 spacing: variant === "rail" ? 4 : 0
//                 Behavior on spacing { NumberAnimation { duration: 200 } }

//                 Item {
//                     visible: alignment === "middle" || alignment === "bottom"
//                     Layout.fillHeight: true
//                 }

//                 Repeater {
//                     model: navigationRail.items
//                     delegate: Loader {
//                         Layout.fillWidth: true
//                         Layout.preferredHeight: variant === "rail" ? 64 : 56

//                         sourceComponent: variant === "rail" ? railItemComponent : expandedItemComponent

//                         property int itemIndex: index
//                         property string itemIcon: model.icon || ""
//                         property string itemActiveIcon: model.activeIcon || model.icon || ""
//                         property string itemLabel: model.label || ""
//                         property bool itemSelected: navigationRail.selectedIndex === index
//                     }
//                 }

//                 Item {
//                     visible: alignment === "middle" || alignment === "top"
//                     Layout.fillHeight: true
//                 }
//             }
//         }
//     }

//     // --- COMPONENT: Collapsed Rail Item ---
//     Component {
//         id: railItemComponent
//         Item {
//             id: rItem
//             property string displayIcon: itemSelected && itemActiveIcon !== "" ? itemActiveIcon : itemIcon

//             Item {
//                 width: railWidth
//                 height: 64
//                 anchors.centerIn: parent

//                 Column {
//                     anchors.centerIn: parent
//                     spacing: 4

//                     Item {
//                         width: 56
//                         height: 32
//                         anchors.horizontalCenter: parent.horizontalCenter

//                         Rectangle {
//                             anchors.centerIn: parent
//                             width: itemSelected ? 56 : 0
//                             height: 32
//                             radius: 16
//                             color: colors.secondaryContainer
//                             Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
//                         }

//                         Rectangle {
//                             anchors.centerIn: parent
//                             width: 56
//                             height: 32
//                             radius: 16
//                             color: itemSelected ? colors.onSecondaryContainer : colors.onSurface
//                             opacity: {
//                                 if (railItemMouse.pressed) return 0.12
//                                 if (railItemMouse.containsMouse || rItem.activeFocus) return 0.08
//                                 return 0
//                             }
//                         }

//                         Icon {
//                             anchors.centerIn: parent
//                             source: displayIcon
//                             size: 24
//                             color: itemSelected ? colors.onSecondaryContainer : colors.onSurfaceVariant
//                         }
//                     }

//                     Text {
//                         anchors.horizontalCenter: parent.horizontalCenter
//                         text: itemLabel
//                         font.family: "Roboto"
//                         font.pixelSize: 12
//                         font.weight: itemSelected ? Font.Medium : Font.Normal
//                         color: itemSelected ? colors.onSurface : colors.onSurfaceVariant
//                         elide: Text.ElideRight
//                         width: railWidth - 8
//                         horizontalAlignment: Text.AlignHCenter
//                     }
//                 }
//             }

//             Rectangle {
//                 anchors.fill: parent
//                 anchors.margins: 4
//                 radius: 12
//                 color: "transparent"
//                 border.width: 2
//                 border.color: colors.primary
//                 visible: rItem.activeFocus
//             }

//             activeFocusOnTab: true
//             Accessible.role: Accessible.Button
//             Accessible.name: itemLabel
//             Keys.onEnterPressed: trigger()
//             Keys.onReturnPressed: trigger()
//             function trigger() { navigationRail.selectedIndex = itemIndex; navigationRail.itemClicked(itemIndex) }

//             MouseArea {
//                 id: railItemMouse
//                 anchors.fill: parent
//                 hoverEnabled: true
//                 cursorShape: Qt.PointingHandCursor
//                 onClicked: parent.trigger()
//             }
//         }
//     }

//     // --- COMPONENT: Expanded Rail Item (Hugs Content) ---
//     Component {
//         id: expandedItemComponent
//         Item {
//             id: eItem
//             property string displayIcon: itemSelected && itemActiveIcon !== "" ? itemActiveIcon : itemIcon

//             activeFocusOnTab: true
//             Accessible.role: Accessible.Button
//             Accessible.name: itemLabel
//             Keys.onEnterPressed: trigger()
//             Keys.onReturnPressed: trigger()
//             function trigger() { navigationRail.selectedIndex = itemIndex; navigationRail.itemClicked(itemIndex) }

//             // MouseArea fills the entire row (M3 Spec: "Target area should always span the full width")
//             // This ensures user doesn't have to aim precisely at the text, but the visual style is "Hug".
//             MouseArea {
//                 id: expItemMouse
//                 anchors.fill: parent
//                 hoverEnabled: true
//                 cursorShape: Qt.PointingHandCursor
//                 onClicked: parent.trigger()
//             }

//             // The Visual Pill - Explicitly calculated width to HUG content
//             Rectangle {
//                 id: activePill
//                 height: 56

//                 // Width = Icon(24) + Gap(12) + TextWidth + Padding(16*2)
//                 width: contentRow.implicitWidth + 32

//                 radius: 28

//                 anchors.left: parent.left
//                 anchors.leftMargin: 12
//                 anchors.verticalCenter: parent.verticalCenter

//                 color: itemSelected ? colors.secondaryContainer : "transparent"

//                 // State Layer
//                 Rectangle {
//                     anchors.fill: parent
//                     radius: 28
//                     color: itemSelected ? colors.onSecondaryContainer : colors.onSurface
//                     opacity: {
//                         if (expItemMouse.pressed) return 0.12
//                         if (expItemMouse.containsMouse || eItem.activeFocus) return 0.08
//                         return 0
//                     }
//                 }

//                 // Content
//                 Row {
//                     id: contentRow
//                     anchors.centerIn: parent
//                     spacing: 12

//                     Icon {
//                         source: displayIcon
//                         size: 24
//                         anchors.verticalCenter: parent.verticalCenter
//                         color: itemSelected ? colors.onSecondaryContainer : colors.onSurfaceVariant
//                     }

//                     Text {
//                         text: itemLabel
//                         font.family: "Roboto"
//                         font.pixelSize: 14
//                         font.weight: itemSelected ? Font.Medium : Font.Normal
//                         color: itemSelected ? colors.onSecondaryContainer : colors.onSurfaceVariant
//                         anchors.verticalCenter: parent.verticalCenter
//                     }
//                 }
//             }

//             // Focus Ring (Around the pill)
//             Rectangle {
//                 anchors.fill: activePill
//                 anchors.margins: -2
//                 radius: 30
//                 color: "transparent"
//                 border.width: 2
//                 border.color: colors.primary
//                 visible: eItem.activeFocus
//             }
//         }
//     }

//     // --- HELPER COMPONENTS ---

//     component RailIconButton: Item {
//         property string icon: ""
//         signal clicked()
//         width: 48; height: 48
//         activeFocusOnTab: true

//         Rectangle {
//             anchors.centerIn: parent; width: 40; height: 40; radius: 20
//             color: colors.onSurfaceVariant
//             opacity: {
//                 if (btnMouse.pressed) return 0.12
//                 if (btnMouse.containsMouse || parent.activeFocus) return 0.08
//                 return 0
//             }
//         }
//         Icon { anchors.centerIn: parent; source: icon; size: 24; color: colors.onSurfaceVariant }
//         Rectangle { anchors.fill: parent; radius: 24; color: "transparent"; border.width: 2; border.color: colors.primary; visible: parent.activeFocus }
//         Keys.onEnterPressed: parent.clicked(); Keys.onReturnPressed: parent.clicked()
//         MouseArea { id: btnMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: parent.clicked() }
//     }

//     component RailFAB: Item {
//         property string icon: ""
//         signal clicked()
//         width: 56; height: 56
//         activeFocusOnTab: true

//         Rectangle {
//             anchors.fill: parent; radius: 16; color: colors.primaryContainer
//             layer.enabled: true; layer.effect: DropShadow { transparentBorder: true; verticalOffset: 2; radius: 4; color: Qt.rgba(0,0,0,0.2) }
//             Rectangle { anchors.fill: parent; radius: 16; color: colors.onPrimaryContainer
//                 opacity: { if (fabMouse.pressed) return 0.12; if (fabMouse.containsMouse || parent.parent.activeFocus) return 0.08; return 0 }
//             }
//             Icon { anchors.centerIn: parent; source: icon; size: 24; color: colors.onPrimaryContainer }
//         }
//         Rectangle { anchors.fill: parent; radius: 16; color: "transparent"; border.width: 2; border.color: colors.primary; visible: parent.activeFocus }
//         Keys.onEnterPressed: parent.clicked(); Keys.onReturnPressed: parent.clicked()
//         MouseArea { id: fabMouse; anchors.fill: parent; hoverEnabled: true; onClicked: parent.clicked(); cursorShape: Qt.PointingHandCursor }
//     }

//     component ExtendedFAB: Item {
//         property string icon: ""
//         property string text: ""
//         signal clicked()

//         // HUG CONTENT Logic: 24px padding left + Icon(24) + Gap(12) + Text + 24px padding right
//         implicitWidth: extRow.implicitWidth + 48
//         implicitHeight: 56
//         activeFocusOnTab: true

//         Rectangle {
//             anchors.fill: parent; radius: 16; color: colors.primaryContainer
//             layer.enabled: true; layer.effect: DropShadow { transparentBorder: true; verticalOffset: 2; radius: 4; color: Qt.rgba(0,0,0,0.2) }
//             Rectangle { anchors.fill: parent; radius: 16; color: colors.onPrimaryContainer
//                 opacity: { if (extFabMouse.pressed) return 0.12; if (extFabMouse.containsMouse || parent.parent.activeFocus) return 0.08; return 0 }
//             }
//             Row {
//                 id: extRow
//                 anchors.centerIn: parent; spacing: 12
//                 Icon { source: icon; size: 24; anchors.verticalCenter: parent.verticalCenter; color: colors.onPrimaryContainer }
//                 Text { text: parent.parent.parent.text; font.family: "Roboto"; font.pixelSize: 14; font.weight: Font.Medium; color: colors.onPrimaryContainer; anchors.verticalCenter: parent.verticalCenter }
//             }
//         }
//         Rectangle { anchors.fill: parent; radius: 16; color: "transparent"; border.width: 2; border.color: colors.primary; visible: parent.activeFocus }
//         Keys.onEnterPressed: parent.clicked(); Keys.onReturnPressed: parent.clicked()
//         MouseArea { id: extFabMouse; anchors.fill: parent; hoverEnabled: true; onClicked: parent.clicked(); cursorShape: Qt.PointingHandCursor }
//     }
// }



/////////////////// last


import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import "../theme" as Theme
import "../common"

Item {
    id: navigationRail

    // --- Properties ---
    property string variant: "rail" // "rail" or "expanded"
    property string alignment: "top" // "top", "middle", "bottom"

    property string iconFont: "Material Icons"

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
    property int calculatedExpandedWidth: 0 // Dynamically calculated
    property var colors: Theme.ChiTheme.colors

    // --- Dynamic Width Calculation (Restored) ---
    TextMetrics {
        id: textMeasurer
        font.family: "Roboto"
        font.pixelSize: 14
        font.weight: Font.Medium
    }

    TextMetrics {
        id: fabMeasurer
        font.family: "Roboto"
        font.pixelSize: 16 // Title Medium
        font.weight: Font.Medium
    }

    function recalculateWidth() {
        // 1. Calculate Max Nav Item Width
        // Structure: RailPad(12) + Pill[Pad(16) + Icon(24) + Gap(12) + Text + Pad(16)] + RailPad(12)
        let maxTextW = 0
        for (let i = 0; i < items.count; i++) {
            let label = items.get(i).label || ""
            textMeasurer.text = label
            if (textMeasurer.width > maxTextW) maxTextW = textMeasurer.width
        }

        // Exact pixel math: 12 + (16 + 24 + 12 + Text + 16) + 12
        let totalItemWidth = 12 + 16 + 24 + 12 + maxTextW + 16 + 12

        // 2. Calculate Extended FAB Width
        // Structure: RailPad(16) + Fab[Pad(16) + Icon(24) + Gap(8) + Text + Pad(16)] + RailPad(16)
        let totalFabWidth = 0
        if (showFab && fabText !== "") {
            fabMeasurer.text = fabText
            totalFabWidth = 16 + 16 + 24 + 8 + fabMeasurer.width + 16 + 16
        }

        // 3. Set Width (Tightest possible fit)
        calculatedExpandedWidth = Math.max(totalItemWidth, totalFabWidth)
    }

    onItemsChanged: recalculateWidth()
    Component.onCompleted: recalculateWidth()

    // --- Root Sizing ---
    implicitWidth: variant === "rail" ? railWidth : calculatedExpandedWidth
    implicitHeight: parent ? parent.height : 800
    opacity: enabled ? 1.0 : 0.38

    // Ensure Layouts treat this width as strict
    Layout.preferredWidth: implicitWidth
    Layout.minimumWidth: implicitWidth

    Behavior on implicitWidth {
        NumberAnimation { duration: 300; easing.type: Easing.OutEmphasized }
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
            z: 20 // Fixed above items

            // 1. Menu Button
            Item {
                visible: showMenuButton
                width: parent.width
                height: 48

                RailIconButton {
                    // Rail: Center | Expanded: Left aligned (12px margin)
                    anchors.centerIn: variant === "rail" ? parent : undefined
                    anchors.left: variant === "expanded" ? parent.left : undefined
                    anchors.leftMargin: variant === "expanded" ? 12 : 0
                    anchors.verticalCenter: parent.verticalCenter

                    icon: menuIcon
                    Accessible.name: "Navigation Menu"
                    Accessible.role: Accessible.Button
                    onClicked: navigationRail.menuClicked()
                }
            }

            // 2. FAB (Fixed)
            Item {
                visible: showFab
                width: parent.width
                height: 56

                RailFAB {
                    visible: variant === "rail"
                    anchors.centerIn: parent
                    icon: fabIcon
                    Accessible.name: fabText
                    onClicked: navigationRail.fabClicked()
                }

                ExtendedFAB {
                    visible: variant === "expanded"
                    // CSS: Align left, margin 16px
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    icon: fabIcon
                    text: fabText
                    Accessible.name: fabText
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

                // Top Spacer
                Item { visible: alignment === "middle" || alignment === "bottom"; Layout.fillHeight: true }

                Repeater {
                    model: navigationRail.items
                    delegate: Loader {
                        Layout.fillWidth: true
                        Layout.preferredHeight: variant === "rail" ? 64 : 56

                        sourceComponent: variant === "rail" ? railItemComponent : expandedItemComponent

                        property int itemIndex: index
                        property string itemIcon: model.icon || ""
                        property string itemActiveIcon: model.activeIcon || model.icon || ""
                        property string itemLabel: model.label || ""
                        property bool itemSelected: navigationRail.selectedIndex === index
                    }
                }

                // Bottom Spacer
                Item { visible: alignment === "middle" || alignment === "top"; Layout.fillHeight: true }
            }
        }
    }

    // --- ACCESSIBILITY AUTO-SCROLL ---
    function ensureVisible(item) {
        var p = item.mapToItem(contentScroll.contentItem, 0, 0)
        var itemY = p.y
        var itemH = item.height

        if (itemY < contentScroll.contentY) {
            contentScroll.contentY = itemY
        } else if (itemY + itemH > contentScroll.contentY + contentScroll.height) {
            contentScroll.contentY = (itemY + itemH) - contentScroll.height
        }
    }

    // --- COMPONENT: Collapsed Rail Item ---
    Component {
        id: railItemComponent
        Item {
            id: rItem
            property string displayIcon: itemSelected && itemActiveIcon !== "" ? itemActiveIcon : itemIcon

            Item {
                width: railWidth
                height: 64
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
                        font.family: "Roboto"; font.pixelSize: 12; font.weight: itemSelected ? Font.Medium : Font.Normal
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
            onActiveFocusChanged: if(activeFocus) navigationRail.ensureVisible(rItem)
        }
    }

    // --- COMPONENT: Expanded Rail Item ---
    Component {
        id: expandedItemComponent
        Item {
            id: eItem
            property string displayIcon: itemSelected && itemActiveIcon !== "" ? itemActiveIcon : itemIcon

            // PILL: Hugs Content strictly
            Rectangle {
                id: activePill
                height: 56
                radius: 28

                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter

                // Width = Pad(16) + Icon(24) + Gap(12) + Text + Pad(16)
                width: contentRow.implicitWidth + 32

                color: itemSelected ? colors.secondaryContainer : "transparent"

                // State Layer
                Rectangle {
                    anchors.fill: parent; radius: 28; color: itemSelected ? colors.onSecondaryContainer : colors.onSurface
                    opacity: { if (expItemMouse.pressed) return 0.12; if (expItemMouse.containsMouse || eItem.activeFocus) return 0.08; return 0 }
                }

                Row {
                    id: contentRow
                    anchors.centerIn: parent
                    spacing: 12 // Gap

                    Icon {
                        source: displayIcon
                        size: 24
                        anchors.verticalCenter: parent.verticalCenter
                        color: itemSelected ? colors.onSecondaryContainer : colors.onSurfaceVariant
                    }

                    Text {
                        text: itemLabel
                        font.family: "Roboto"; font.pixelSize: 14; font.weight: itemSelected ? Font.Medium : Font.Normal
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
            onActiveFocusChanged: if(activeFocus) navigationRail.ensureVisible(eItem)
        }
    }

    // --- BUTTON COMPONENTS ---

    component RailIconButton: Item {
        property string icon: ""
        signal clicked()
        width: 48; height: 48; activeFocusOnTab: true
        Rectangle { anchors.centerIn: parent; width: 40; height: 40; radius: 20; color: colors.onSurfaceVariant; opacity: { if (btnMouse.pressed) return 0.12; if (btnMouse.containsMouse || parent.activeFocus) return 0.08; return 0 } }
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
            layer.enabled: true; layer.effect: DropShadow { transparentBorder: true; verticalOffset: 2; radius: 4; color: Qt.rgba(0,0,0,0.2) }
            Rectangle { anchors.fill: parent; radius: 16; color: colors.onPrimaryContainer; opacity: { if (fabMouse.pressed) return 0.12; if (fabMouse.containsMouse || parent.parent.activeFocus) return 0.08; return 0 } }
            // Perfectly Centered
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

        // Hug Content
        implicitWidth: extRow.implicitWidth + 32
        implicitHeight: 56
        activeFocusOnTab: true

        Rectangle {
            anchors.fill: parent; radius: 16; color: colors.primaryContainer
            layer.enabled: true; layer.effect: DropShadow { transparentBorder: true; verticalOffset: 2; radius: 4; color: Qt.rgba(0,0,0,0.2) }
            Rectangle { anchors.fill: parent; radius: 16; color: colors.onPrimaryContainer; opacity: { if (extFabMouse.pressed) return 0.12; if (extFabMouse.containsMouse || parent.parent.activeFocus) return 0.08; return 0 } }

            Row {
                id: extRow
                anchors.centerIn: parent
                spacing: 8 // CSS Gap
                Icon { source: icon; size: 24; anchors.verticalCenter: parent.verticalCenter; color: colors.onPrimaryContainer }
                Text {
                    text: parent.parent.parent.text
                    font.family: "Roboto"; font.pixelSize: 16; font.weight: Font.Medium
                    color: colors.onPrimaryContainer; anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
        Rectangle { anchors.fill: parent; radius: 16; color: "transparent"; border.width: 2; border.color: colors.primary; visible: parent.activeFocus }
        Keys.onEnterPressed: parent.clicked(); Keys.onReturnPressed: parent.clicked()
        MouseArea { id: extFabMouse; anchors.fill: parent; hoverEnabled: true; onClicked: parent.clicked(); cursorShape: Qt.PointingHandCursor }
    }
}
