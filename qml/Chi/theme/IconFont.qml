pragma Singleton
import QtQuick

QtObject {
    id: root
    
    readonly property FontLoader _embeddedFont: FontLoader {
        source: "qrc:/SmartUI/fonts/MaterialSymbolsRounded.ttf"
        onStatusChanged: {
            if (status === FontLoader.Ready) {
                console.log("SmartUI IconFont: Loaded '" + name + "'")
            } else if (status === FontLoader.Error) {
                console.error("SmartUI IconFont: FAILED to load font!")
            }
        }
    }
    
    readonly property string family: _embeddedFont.status === FontLoader.Ready 
        ? _embeddedFont.name 
        : "Material Symbols Rounded"
        
    readonly property bool ready: _embeddedFont.status === FontLoader.Ready
}
