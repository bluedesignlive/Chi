import QtQuick
import "../../theme" as Theme
import "." as Menus

Menu {
    id: root

    property real clickX: 0
    property real clickY: 0

    Timer {
        id: contextReopenTimer
        interval: 16
        onTriggered: {
            updatePosition()
            open = true
        }
    }

    function updatePosition() {
        if (!appWindow) return

        var parentPos = parent ? parent.mapToItem(appWindow, 0, 0) : Qt.point(0, 0)
        var windowWidth = appWindow.width
        var windowHeight = appWindow.height

        var absX = Math.round(parentPos.x + clickX)
        var absY = Math.round(parentPos.y + clickY)

        if (absX + implicitWidth > windowWidth - 8) {
            absX = Math.max(8, absX - implicitWidth)
        }
        if (absY + implicitHeight > windowHeight - 8) {
            absY = Math.max(8, absY - implicitHeight)
        }

        menuX = absX
        menuY = absY
    }

    function popup(px, py) {
        clickX = px
        clickY = py
        Menus.MenuManager.closeAllExcept(root)
        
        if (open) {
            open = false
            contextReopenTimer.start()
        } else {
            updatePosition()
            open = true
        }
    }
}
