import QtQuick
import QtQuick.Effects
import "../../theme" as Theme

Item {
    id: root

    property string configuration: "floating"
    property string orientation: "horizontal"
    property string type: "standard"
    property bool enabled: true

    default property alias items: itemsContainer.data

    readonly property bool isFloating: configuration === "floating"
    readonly property bool isHorizontal: orientation === "horizontal"
    readonly property bool isVibrant: type === "vibrant"
    readonly property int _spacing: isFloating ? 4 : 8

    implicitWidth: isHorizontal ? itemsContainer.implicitWidth + 16 : 64
    implicitHeight: isHorizontal ? 64 : itemsContainer.implicitHeight + 16

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        id: container
        anchors.fill: parent
        radius: root.isFloating ? 32 : 0
        color: root.isVibrant ? colors.primaryContainer : colors.surfaceContainer

        Behavior on color { ColorAnimation { duration: 200 } }

        layer.enabled: root.isFloating
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.15)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 4
            shadowBlur: 0.4
        }

        Item {
            anchors.fill: parent
            anchors.leftMargin: root.isHorizontal ? (root.isFloating ? 8 : 16) : (root.isFloating ? 12 : 8)
            anchors.rightMargin: root.isHorizontal ? (root.isFloating ? 8 : 16) : (root.isFloating ? 12 : 8)
            anchors.topMargin: root.isHorizontal ? 12 : (root.isFloating ? 8 : 12)
            anchors.bottomMargin: root.isHorizontal ? 12 : (root.isFloating ? 8 : 12)

            Row {
                visible: root.isHorizontal
                anchors.centerIn: parent
                spacing: root._spacing

                Item {
                    id: itemsContainer
                    width: childrenRect.width
                    height: 48
                }
            }

            Column {
                visible: !root.isHorizontal
                anchors.centerIn: parent
                spacing: 4

                Repeater {
                    model: itemsContainer.children.length
                    delegate: Item {
                        width: 48
                        height: 48
                        visible: {
                            var c = itemsContainer.children[index]
                            return c ? c.visible : false
                        }
                        Loader {
                            anchors.fill: parent
                            sourceComponent: itemsContainer.children[index] || null
                        }
                    }
                }
            }
        }
    }

    onTypeChanged: _updateItems()
    onEnabledChanged: _updateItems()
    Component.onCompleted: { _updateItems(); _relayout() }
    onItemsChanged: _relayout()

    function _updateItems() {
        var c = itemsContainer.children
        var n = c.length
        var t = type
        var e = root.enabled
        for (var i = 0; i < n; ++i) {
            var item = c[i]
            if (item.hasOwnProperty("toolbarType"))
                item.toolbarType = t
            if (item.hasOwnProperty("enabled"))
                item.enabled = Qt.binding(function() { return root.enabled })
        }
    }

    function _relayout() {
        var c = itemsContainer.children
        var n = c.length
        var horiz = isHorizontal
        var sp = horiz ? _spacing : 4
        var offset = 0
        for (var i = 0; i < n; ++i) {
            var item = c[i]
            if (item.visible) {
                if (horiz) {
                    item.x = offset; item.y = 0
                    offset += item.width + sp
                } else {
                    item.x = 0; item.y = offset
                    offset += item.height + sp
                }
            }
        }
    }

    Accessible.role: Accessible.ToolBar
    Accessible.name: "Toolbar"
}
