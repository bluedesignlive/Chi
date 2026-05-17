pragma Singleton
import QtQuick

QtObject {
    readonly property int level0: 0
    readonly property int level1: 1
    readonly property int level2: 3
    readonly property int level3: 6
    readonly property int level4: 8
    readonly property int level5: 12

    readonly property color surfaceTintColor: "#6750A4"

    readonly property var _shadowParams: ({
        level0: [0, 0, 0],
        level1: [1, 0.15, 0.30],
        level2: [2, 0.25, 0.30],
        level3: [4, 0.40, 0.30],
        level4: [6, 0.50, 0.32],
        level5: [8, 0.60, 0.34]
    })

    function _params(level) { return _shadowParams["level" + level] || _shadowParams.level0 }

    function verticalOffset(level) { return _params(level)[0] }
    function blurRadius(level) { return _params(level)[1] }
    function shadowOpacity(level) { return _params(level)[2] }

    readonly property color _shadowColor: "#000000"

    function shadowColor(level) {
        return _shadowParams["level" + level] ? _shadowColor : "transparent"
    }
}
