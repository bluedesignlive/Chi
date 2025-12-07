import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import testui 1.0

Window {
    width: 1400
    height: 900
    visible: true
    title: qsTr("SmartUI Component Showcase")

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        TabBar {
            id: tabBar
            Layout.fillWidth: true

            TabButton { text: "Buttons" }
            TabButton { text: "Icon Buttons" }
            TabButton { text: "Icon Toggles" }
            TabButton { text: "Switches" }
            TabButton { text: "Toggle Buttons" }
            TabButton { text: "Split Buttons" }
            TabButton { text: "FAB Menus" }
            TabButton { text: "Progress" }
            TabButton { text: "Navigation" }
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
