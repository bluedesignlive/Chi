// qml/smartui/ui/menus/ContextMenu.qml
// M3 context menu — positions itself at click coordinates
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
        onTriggered: { _updatePos(); open = true }
    }

    function _updatePos() {
        if (!appWindow) return

        var p = parent ? parent.mapToItem(appWindow, 0, 0) : Qt.point(0, 0)
        var ww = appWindow.width
        var wh = appWindow.height

        var ax = Math.round(p.x + clickX)
        var ay = Math.round(p.y + clickY)

        // Clamp to screen edges with 8 px margin
        if (ax + implicitWidth > ww - 8)
            ax = Math.max(8, ax - implicitWidth)
        if (ay + implicitHeight > wh - 8)
            ay = Math.max(8, ay - implicitHeight)

        menuX = ax
        menuY = ay
    }

    function popup(px, py) {
        clickX = px; clickY = py
        Menus.MenuManager.closeAllExcept(root)

        if (open) {
            open = false
            contextReopenTimer.start()
        } else {
            _updatePos()
            open = true
        }
    }
}
