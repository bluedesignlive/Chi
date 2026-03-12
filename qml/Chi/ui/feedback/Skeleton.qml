import QtQuick
import "../theme" as Theme

Rectangle {
    id: root

    property string variant: "text"          // "text", "circular", "rectangular", "rounded"
    property bool animated: true
    property real aspectRatio: 0             // 0 = use explicit height

    implicitWidth: variant === "circular" ? 40 : 200
    implicitHeight: {
        if (variant === "circular") return width
        if (aspectRatio > 0) return width / aspectRatio
        if (variant === "text") return 16
        return 100
    }

    property var colors: Theme.ChiTheme.colors

    radius: {
        switch (variant) {
        case "circular": return width / 2
        case "rounded": return 8
        case "text": return 4
        default: return 4
        }
    }

    color: colors.surfaceContainerHighest

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    // Shimmer effect
    Rectangle {
        id: shimmer
        visible: animated
        width: parent.width * 0.5
        height: parent.height
        radius: parent.radius

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.5; color: Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.05) }
            GradientStop { position: 1.0; color: "transparent" }
        }

        SequentialAnimation on x {
            running: animated && root.visible
            loops: Animation.Infinite

            NumberAnimation {
                from: -shimmer.width
                to: root.width
                duration: 1500
                easing.type: Easing.InOutQuad
            }

            PauseAnimation {
                duration: 500
            }
        }
    }

    clip: true
}
