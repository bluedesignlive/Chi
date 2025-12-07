import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Item {
    id: root

    property string configuration: "floating" // "floating", "docked"
    property string orientation: "horizontal" // "horizontal", "vertical"
    property string type: "standard"          // "standard", "vibrant"
    property bool enabled: true

    default property alias items: itemsContainer.data

    readonly property bool isFloating: configuration === "floating"
    readonly property bool isHorizontal: orientation === "horizontal"
    readonly property bool isVibrant: type === "vibrant"

    // Dynamic sizing based on orientation and configuration
    implicitWidth: isHorizontal ? itemsContainer.implicitWidth + 16 : 64
    implicitHeight: isHorizontal ? 64 : itemsContainer.implicitHeight + 16

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        id: container
        anchors.fill: parent
        
        radius: isFloating ? 32 : 0
        
        color: isVibrant ? colors.primaryContainer : colors.surfaceContainer

        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        // Shadow for floating toolbar
        layer.enabled: isFloating
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 4
            radius: 8
            samples: 17
            color: Qt.rgba(0, 0, 0, 0.15)
        }

        // Items container
        Item {
            id: itemsLayout
            anchors.fill: parent
            anchors.margins: isFloating ? 8 : (isHorizontal ? 12 : 8)
            anchors.leftMargin: isHorizontal ? (isFloating ? 8 : 16) : (isFloating ? 12 : 8)
            anchors.rightMargin: isHorizontal ? (isFloating ? 8 : 16) : (isFloating ? 12 : 8)
            anchors.topMargin: isHorizontal ? 12 : (isFloating ? 8 : 12)
            anchors.bottomMargin: isHorizontal ? 12 : (isFloating ? 8 : 12)

            // Horizontal layout
            Row {
                id: horizontalLayout
                visible: isHorizontal
                anchors.centerIn: parent
                spacing: configuration === "docked" ? 8 : 4

                Item {
                    id: itemsContainer
                    width: childrenRect.width
                    height: 48
                    
                    // Children will be ToolbarItem components
                }
            }

            // Vertical layout
            Column {
                id: verticalLayout
                visible: !isHorizontal
                anchors.centerIn: parent
                spacing: 4

                // Mirror items from horizontal container
                Repeater {
                    model: itemsContainer.children.length
                    
                    delegate: Item {
                        width: 48
                        height: 48
                        visible: itemsContainer.children[index] ? itemsContainer.children[index].visible : false
                        
                        Loader {
                            anchors.fill: parent
                            sourceComponent: itemsContainer.children[index] ? itemsContainer.children[index] : null
                        }
                    }
                }
            }
        }
    }

    // Reconfigure child items when type changes
    onTypeChanged: updateItemColors()
    onEnabledChanged: updateItemColors()

    Component.onCompleted: {
        updateItemColors()
        relayoutItems()
    }

    function updateItemColors() {
        for (var i = 0; i < itemsContainer.children.length; i++) {
            var item = itemsContainer.children[i]
            if (item.hasOwnProperty("toolbarType")) {
                item.toolbarType = type
            }
            if (item.hasOwnProperty("enabled")) {
                item.enabled = Qt.binding(function() { return root.enabled })
            }
        }
    }

    function relayoutItems() {
        // Arrange items in a row/column
        var offset = 0
        for (var i = 0; i < itemsContainer.children.length; i++) {
            var item = itemsContainer.children[i]
            if (item.visible) {
                if (isHorizontal) {
                    item.x = offset
                    item.y = 0
                    offset += item.width + (configuration === "docked" ? 8 : 4)
                } else {
                    item.x = 0
                    item.y = offset
                    offset += item.height + 4
                }
            }
        }
    }

    onItemsChanged: relayoutItems()

    Accessible.role: Accessible.ToolBar
    Accessible.name: "Toolbar"
}
