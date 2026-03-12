import QtQuick
import QtQuick.Layouts
import "../theme" as Theme

Rectangle {
    id: root

    property int currentIndex: 0
    property bool showLabels: true
    property bool enabled: true

    default property alias items: itemsRow.data

    signal itemClicked(int index)

    implicitWidth: parent ? parent.width : 400
    implicitHeight: 80

    property var colors: Theme.ChiTheme.colors

    color: colors.surfaceContainer

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    RowLayout {
        id: itemsRow
        anchors.fill: parent
        anchors.topMargin: 12
        anchors.bottomMargin: 16
        spacing: 0

        onChildrenChanged: {
            updateItems()
        }
    }

    function updateItems() {
        for (var i = 0; i < itemsRow.children.length; i++) {
            var item = itemsRow.children[i]
            if (item.hasOwnProperty("navIndex")) {
                item.navIndex = i
                item.selected = Qt.binding(function() {
                    return this.navIndex === currentIndex
                }.bind(item))
                item.showLabel = Qt.binding(function() { return showLabels })
                item.enabled = Qt.binding(function() { return root.enabled })

                item.clicked.connect(function(idx) {
                    currentIndex = idx
                    itemClicked(idx)
                }.bind(null, i))
            }
        }
    }

    Component.onCompleted: updateItems()

    Accessible.role: Accessible.PageTabList
    Accessible.name: "Navigation bar"
}
