// ShapeTokens.qml — Material 3 Shape Token System
// Single source of truth for corner radii across all components.
// Components reference these tokens instead of hardcoding pixel values.
pragma Singleton
import QtQuick

QtObject {
    readonly property int none: 0
    readonly property int extraSmall: 4
    readonly property int small: 8
    readonly property int medium: 12
    readonly property int large: 16
    readonly property int extraLarge: 28
    readonly property int full: 9999
}
