import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Item {
    id: navigationRail

    property string variant: "rail"
    property string alignment: "top"
    
    // Feature: Allow custom icon font (e.g., Nerd Fonts)
    property string iconFont: ""

    property bool showMenuButton: true
    property string menuIcon: "menu" 
    
    property bool showFab: true
    property string fabIcon: "+"
    property string fabText: "New"

    property int selectedIndex: 0
    property bool enabled: true

    property ListModel items: ListModel {}
    property ListModel sections: ListModel {}

    signal itemClicked(int index)
    signal fabClicked()
    signal menuClicked()

    opacity: enabled ? 1.0 : 0.38
    readonly property int railWidth: 80
    readonly property int expandedWidth: 256
    property var colors: Theme.ChiTheme.colors

    implicitWidth: variant === "rail" ? railWidth : expandedWidth
    implicitHeight: parent ? parent.height : 800

    Behavior on implicitWidth { 
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic } 
    }

    Rectangle {
        anchors.fill: parent
        color: colors.surface
        Behavior on color { ColorAnimation { duration: 200 } }
    }

    // HEADER
    Column {
        id: headerSection
        anchors.top: parent.top
        anchors.topMargin: 12
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 4
        z: 10

        Item {
            visible: showMenuButton
            width: parent.width
            height: 56
            
            RailIconButton {
                anchors.centerIn: variant === "rail" ? parent : undefined
                anchors.left: variant === "expanded" ? parent.left : undefined
                anchors.leftMargin: variant === "expanded" ? 16 : 0
                anchors.verticalCenter: parent.verticalCenter
                icon: menuIcon
                onClicked: navigationRail.menuClicked()
            }
        }

        Item {
            visible: showFab
            width: parent.width
            height: 56
            
            RailFAB {
                visible: variant === "rail"
                anchors.centerIn: parent
                icon: fabIcon
                onClicked: navigationRail.fabClicked()
            }
            
            ExtendedFAB {
                visible: variant === "expanded"
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                icon: fabIcon
                text: fabText
                onClicked: navigationRail.fabClicked()
            }
        }
    }

    // BODY
    Item {
        id: navContainer
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: headerSection.bottom
        anchors.topMargin: 12
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 12

        Column {
            id: navColumn
            width: parent.width
            spacing: variant === "rail" ? 0 : 2

            states: [
                State { 
                    name: "top"
                    when: alignment === "top"
                    AnchorChanges { target: navColumn; anchors.top: navContainer.top; anchors.verticalCenter: undefined; anchors.bottom: undefined } 
                },
                State { 
                    name: "middle"
                    when: alignment === "middle"
                    AnchorChanges { target: navColumn; anchors.top: undefined; anchors.verticalCenter: navContainer.verticalCenter; anchors.bottom: undefined } 
                },
                State { 
                    name: "bottom"
                    when: alignment === "bottom"
                    AnchorChanges { target: navColumn; anchors.top: undefined; anchors.verticalCenter: undefined; anchors.bottom: navContainer.bottom } 
                }
            ]
            transitions: Transition { AnchorAnimation { duration: 200; easing.type: Easing.OutCubic } }

            Repeater {
                model: sections.count === 0 ? navigationRail.items : null
                delegate: Loader {
                    width: navColumn.width
                    sourceComponent: variant === "rail" ? railItemComponent : expandedItemComponent
                    property int itemIndex: index
                    property string itemIcon: model.icon || ""
                    property string itemActiveIcon: model.activeIcon || model.icon || ""
                    property string itemLabel: model.label || ""
                    property bool itemSelected: navigationRail.selectedIndex === index
                }
            }
        }
    }

    // INTERNAL COMPONENTS
    Component {
        id: railItemComponent
        Item {
            width: parent ? parent.width : railWidth
            height: 56
            property string displayIcon: itemSelected && itemActiveIcon !== "" ? itemActiveIcon : itemIcon

            Column {
                anchors.centerIn: parent
                spacing: 4
                
                Item {
                    width: 56
                    height: 32
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Rectangle { 
                        anchors.centerIn: parent
                        width: itemSelected ? 56 : 0
                        height: 32
                        radius: 16
                        color: colors.secondaryContainer
                        Behavior on width { NumberAnimation { duration: 200 } } 
                    }
                    
                    Rectangle { 
                        anchors.centerIn: parent
                        width: 56
                        height: 32
                        radius: 16
                        color: itemSelected ? colors.onSecondaryContainer : colors.onSurface
                        opacity: railItemMouse.pressed ? 0.12 : railItemMouse.containsMouse ? 0.08 : 0 
                    }
                    
                    Item {
                        anchors.centerIn: parent
                        width: 24
                        height: 24
                        Loader {
                            anchors.fill: parent
                            sourceComponent: isImagePath(displayIcon) ? imageIconComp : textIconComp
                            property string iconSrc: displayIcon
                            property color iconClr: itemSelected ? colors.onSecondaryContainer : colors.onSurfaceVariant
                        }
                    }
                }
                
                Text { 
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: itemLabel
                    font.family: "Roboto"
                    font.pixelSize: 12
                    font.weight: itemSelected ? Font.Medium : Font.Normal
                    color: itemSelected ? colors.onSurface : colors.onSurfaceVariant 
                }
            }
            MouseArea { 
                id: railItemMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: { navigationRail.selectedIndex = itemIndex; navigationRail.itemClicked(itemIndex) } 
            }
        }
    }

    Component {
        id: expandedItemComponent
        Item {
            width: parent ? parent.width : expandedWidth
            height: 56
            property string displayIcon: itemSelected && itemActiveIcon !== "" ? itemActiveIcon : itemIcon
            
            Rectangle {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                radius: 28
                color: itemSelected ? colors.secondaryContainer : "transparent"
                
                Rectangle { 
                    anchors.fill: parent
                    radius: parent.radius
                    color: itemSelected ? colors.onSecondaryContainer : colors.onSurface
                    opacity: expItemMouse.pressed ? 0.12 : expItemMouse.containsMouse ? 0.08 : 0 
                }
                
                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 12
                    
                    Item {
                        width: 24
                        height: 24
                        Loader {
                            anchors.fill: parent
                            sourceComponent: isImagePath(displayIcon) ? imageIconComp : textIconComp
                            property string iconSrc: displayIcon
                            property color iconClr: itemSelected ? colors.onSecondaryContainer : colors.onSurfaceVariant
                        }
                    }
                    
                    Text { 
                        text: itemLabel
                        font.family: "Roboto"
                        font.pixelSize: 14
                        font.weight: itemSelected ? Font.Medium : Font.Normal
                        color: itemSelected ? colors.onSecondaryContainer : colors.onSurfaceVariant
                        anchors.verticalCenter: parent.verticalCenter 
                    }
                }
                MouseArea { 
                    id: expItemMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: { navigationRail.selectedIndex = itemIndex; navigationRail.itemClicked(itemIndex) } 
                }
            }
        }
    }

    function isImagePath(icon) {
        if (!icon || icon === "") return false
        var s = icon.toLowerCase()
        return s.indexOf("/") !== -1 || s.indexOf(".") !== -1 || s.indexOf("qrc:") !== -1
    }

    Component {
        id: textIconComp
        Text {
            text: iconSrc
            // Use custom font if set, otherwise default to Material Icons
            font.family: navigationRail.iconFont !== "" ? navigationRail.iconFont : "Material Icons"
            font.pixelSize: 22
            color: iconClr
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Behavior on color { ColorAnimation { duration: 150 } }
        }
    }

    Component {
        id: imageIconComp
        Image { 
            source: iconSrc
            sourceSize: Qt.size(24, 24)
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true 
        }
    }

    component RailIconButton: Item {
        property string icon: ""
        signal clicked()
        width: 48
        height: 48
        
        Rectangle { 
            anchors.centerIn: parent
            width: 40
            height: 40
            radius: 20
            color: colors.onSurfaceVariant
            opacity: btnMouse.pressed ? 0.12 : btnMouse.containsMouse ? 0.08 : 0 
        }
        
        Item {
            anchors.centerIn: parent
            width: 24
            height: 24
            Loader { 
                anchors.fill: parent
                sourceComponent: isImagePath(icon) ? imageIconComp : textIconComp
                property string iconSrc: icon
                property color iconClr: colors.onSurfaceVariant 
            }
        }
        MouseArea { 
            id: btnMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: parent.clicked() 
        }
    }

    component RailFAB: Item {
        property string icon: ""
        signal clicked()
        width: 56
        height: 56
        
        Rectangle {
            anchors.fill: parent
            radius: 16
            color: colors.primaryContainer
            layer.enabled: true
            layer.effect: DropShadow { 
                transparentBorder: true
                verticalOffset: 1
                radius: 3
                color: Qt.rgba(0,0,0,0.2) 
            }
            
            Item {
                anchors.centerIn: parent
                width: 24
                height: 24
                Loader { 
                    anchors.fill: parent
                    sourceComponent: isImagePath(icon) ? imageIconComp : textIconComp
                    property string iconSrc: icon
                    property color iconClr: colors.onPrimaryContainer 
                }
            }
        }
        MouseArea { 
            anchors.fill: parent
            onClicked: parent.clicked()
            cursorShape: Qt.PointingHandCursor 
        }
    }

    component ExtendedFAB: Item {
        property string icon: ""
        property string text: ""
        signal clicked()
        implicitWidth: extRow.implicitWidth + 32
        implicitHeight: 56
        
        Rectangle {
            anchors.fill: parent
            radius: 16
            color: colors.primaryContainer
            layer.enabled: true
            layer.effect: DropShadow { 
                transparentBorder: true
                verticalOffset: 1
                radius: 3
                color: Qt.rgba(0,0,0,0.2) 
            }
            
            Row {
                id: extRow
                anchors.centerIn: parent
                spacing: 12
                Item {
                    width: 24
                    height: 24
                    Loader { 
                        anchors.fill: parent
                        sourceComponent: isImagePath(icon) ? imageIconComp : textIconComp
                        property string iconSrc: icon
                        property color iconClr: colors.onPrimaryContainer 
                    }
                }
                Text { 
                    text: parent.parent.parent.text
                    font.family: "Roboto"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    color: colors.onPrimaryContainer
                    anchors.verticalCenter: parent.verticalCenter 
                }
            }
        }
        MouseArea { 
            anchors.fill: parent
            onClicked: parent.clicked()
            cursorShape: Qt.PointingHandCursor 
        }
    }
}
