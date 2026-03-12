import QtQuick
import "../theme" as Theme

Rectangle {
    id: root

    property string orientation: "horizontal" // "horizontal", "vertical"
    property bool inset: false
    property real insetStart: 16
    property real insetEnd: 16
    property string variant: "full"           // "full", "inset", "middle"

    property var colors: Theme.ChiTheme.colors

    implicitWidth: orientation === "horizontal" ? 200 : 1
    implicitHeight: orientation === "horizontal" ? 1 : 200

    color: colors.outlineVariant

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    // Adjust for inset variants
    anchors.leftMargin: {
        if (orientation !== "horizontal") return 0
        switch (variant) {
        case "inset": return insetStart
        case "middle": return insetStart
        default: return 0
        }
    }

    anchors.rightMargin: {
        if (orientation !== "horizontal") return 0
        switch (variant) {
        case "middle": return insetEnd
        default: return 0
        }
    }

    anchors.topMargin: {
        if (orientation !== "vertical") return 0
        switch (variant) {
        case "inset": return insetStart
        case "middle": return insetStart
        default: return 0
        }
    }

    anchors.bottomMargin: {
        if (orientation !== "vertical") return 0
        switch (variant) {
        case "middle": return insetEnd
        default: return 0
        }
    }
}
