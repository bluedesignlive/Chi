import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import SmartUIBeta 1.0

Window {
    width: 1400
    height: 900
    visible: true
    color: ChiTheme.colors.background
    title: qsTr("SmartUI Component Showcase")

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Tabs {
            id: tabBar
            Layout.fillWidth: true
            currentIndex: 0

            Tab { text: "Buttons" }
            Tab { text: "Icon Buttons" }
            Tab { text: "Icon Toggles" }
            Tab { text: "Switches" }
            Tab { text: "Toggle Buttons" }
            Tab { text: "Split Buttons" }
            Tab { text: "FAB Menus" }
            Tab { text: "Progress" }
            Tab { text: "Navigation" }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex

            ButtonShowcase { }
            IconButtonShowcase { }
            IconButtonToggleShowcase { }
            SwitchShowcase { }
            ToggleButtonShowcase { }
            SplitButtonShowcase { }
            FABMenuShowcase { }
            LinearProgressShowcase { }
            NavigationRailShowcase { }
        }
    }
}
