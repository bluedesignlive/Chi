pragma Singleton
import QtQuick

QtObject {
    property var openMenus: []

    function registerMenu(menu) {
        if (openMenus.indexOf(menu) === -1) openMenus.push(menu)
    }

    function unregisterMenu(menu) {
        var idx = openMenus.indexOf(menu)
        if (idx !== -1) openMenus.splice(idx, 1)
    }

    function closeAllExcept(menu) {
        for (var i = openMenus.length - 1; i >= 0; i--) {
            if (openMenus[i] !== menu && openMenus[i].open) {
                openMenus[i].open = false
            }
        }
    }

    function closeAll() {
        for (var i = openMenus.length - 1; i >= 0; i--) {
            if (openMenus[i].open) openMenus[i].open = false
        }
    }
}
