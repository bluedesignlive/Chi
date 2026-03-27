pragma Singleton
import QtQuick

QtObject {
    id: root

    readonly property FontLoader _embeddedFont: FontLoader {
        source: "qrc:/Chi/fonts/MaterialSymbolsRounded.ttf"
        onStatusChanged: {
            if (status === FontLoader.Ready)
                console.log("Chi IconFont: Loaded embedded '" + name + "'")
            else if (status === FontLoader.Error)
                console.error("Chi IconFont: Embedded font failed, using system fallback")
        }
    }

    readonly property string family: _embeddedFont.status === FontLoader.Ready
        ? _embeddedFont.name
        : "Material Symbols Rounded"

    readonly property bool ready: _embeddedFont.status === FontLoader.Ready
}
