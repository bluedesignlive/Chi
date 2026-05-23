import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Chi

ChiApplicationWindow {
    id: root
    title: "ChiTimer"
    width: 480
    height: 800

    readonly property var colors: ChiTheme.colors
    readonly property string fontFamily: ChiTheme.fontFamily

    NavigationBar {
        id: navBar
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        currentIndex: 0
        showLabels: true

        NavigationBarItem { icon: "timer";         activeIcon: "timer";         label: "Timer" }
        NavigationBarItem { icon: "alarm";          activeIcon: "alarm";         label: "Alarm" }
        NavigationBarItem { icon: "stopwatch";      activeIcon: "stopwatch";     label: "Stopwatch" }
        NavigationBarItem { icon: "globe";          activeIcon: "globe";         label: "World" }
    }

    StackLayout {
        id: contentStack
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: navBar.top
        currentIndex: navBar.currentIndex

        TimerTab {
            id: timerTab
        }

        AlarmTab {
            id: alarmTab
        }

        StopwatchTab {
            id: stopwatchTab
        }

        WorldClockTab {
            id: worldClockTab
        }
    }
}
