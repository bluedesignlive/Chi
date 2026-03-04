// qml/smartui/ui/menus/MenuManager.qml
// Singleton — tracks open menus for mutual exclusion
pragma Singleton
import QtQuick

QtObject {
    id: root

    property var _menus: []

    function registerMenu(menu) {
        if (_menus.indexOf(menu) === -1)
            _menus.push(menu)
    }

    function unregisterMenu(menu) {
        var i = _menus.indexOf(menu)
        if (i !== -1) _menus.splice(i, 1)
    }

    function closeAllExcept(menu) {
        for (var i = _menus.length - 1; i >= 0; --i) {
            if (_menus[i] !== menu && _menus[i].open)
                _menus[i].close()
        }
    }

    function closeAll() {
        for (var i = _menus.length - 1; i >= 0; --i) {
            if (_menus[i].open) _menus[i].close()
        }
    }
}
