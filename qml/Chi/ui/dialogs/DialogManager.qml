pragma Singleton
import QtQuick

QtObject {
    property var openDialogs: []

    function registerDialog(dialog) {
        if (openDialogs.indexOf(dialog) === -1) {
            openDialogs.push(dialog)
        }
    }

    function unregisterDialog(dialog) {
        var idx = openDialogs.indexOf(dialog)
        if (idx !== -1) {
            openDialogs.splice(idx, 1)
        }
    }

    function getTopDialog() {
        for (var i = openDialogs.length - 1; i >= 0; i--) {
            if (openDialogs[i].open) return openDialogs[i]
        }
        return null
    }

    function closeTopDialog() {
        var top = getTopDialog()
        if (top) {
            top.rejected()
            top.close()
            return true
        }
        return false
    }

    function closeAll() {
        for (var i = openDialogs.length - 1; i >= 0; i--) {
            if (openDialogs[i].open) {
                openDialogs[i].close()
            }
        }
    }
}
