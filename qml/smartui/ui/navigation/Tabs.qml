import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme

Rectangle {
    id: root

    property int currentIndex: 0
    property string variant: "primary"       // "primary", "secondary"
    property bool scrollable: false
    property bool enabled: true

    default property alias tabs: tabsContainer.data

    signal tabClicked(int index)

    implicitWidth: scrollable ? 400 : tabsRow.implicitWidth
    implicitHeight: variant === "primary" ? 48 : 48

    property var colors: Theme.ChiTheme.colors

    color: colors.surface

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    // Scrollable container
    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: scrollable ? tabsRow.implicitWidth : width
        contentHeight: height
        clip: scrollable
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.HorizontalFlick

        Row {
            id: tabsRow
            height: parent.height

            Item {
                id: tabsContainer
                width: childrenRect.width
                height: parent.height

                onChildrenChanged: updateTabs()
            }
        }
    }

    // Active indicator
    Rectangle {
        id: activeIndicator
        height: variant === "primary" ? 3 : 2
        radius: variant === "primary" ? 1.5 : 0
        color: colors.primary
        anchors.bottom: parent.bottom

        property var targetTab: tabsContainer.children[currentIndex]
        x: targetTab ? targetTab.x : 0
        width: targetTab ? targetTab.width : 0

        Behavior on x {
            NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
        }
        Behavior on width {
            NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
        }
        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }

    // Divider
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: colors.surfaceVariant
        z: -1

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }

    function updateTabs() {
        for (var i = 0; i < tabsContainer.children.length; i++) {
            var tab = tabsContainer.children[i]
            if (tab.hasOwnProperty("tabIndex")) {
                tab.tabIndex = i
                tab.selected = Qt.binding(function() {
                    return this.tabIndex === currentIndex
                }.bind(tab))
                tab.variant = Qt.binding(function() { return root.variant })
                tab.enabled = Qt.binding(function() { return root.enabled })

                tab.clicked.connect(function(idx) {
                    currentIndex = idx
                    tabClicked(idx)
                }.bind(null, i))
            }
        }
    }

    Component.onCompleted: updateTabs()

    Accessible.role: Accessible.PageTabList
    Accessible.name: "Tab bar"
}
