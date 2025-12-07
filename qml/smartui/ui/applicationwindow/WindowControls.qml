import QtQuick
import "../../theme" as Theme

Row {
    id: root
    spacing: 8

    // The window instance to control
    property Window targetWindow: Window.window

    // Button Component
    component WinBtn: Rectangle {
        id: btn
        width: 40
        height: 40
        radius: 20
        color: "transparent"

        property string symbol: ""
        property bool isDestructive: false // For Close button
        signal clicked()

        // Hover State
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: btn.isDestructive ? Theme.ChiTheme.colors.error : Theme.ChiTheme.colors.onSurface
            opacity: {
                if (ma.pressed) return 0.12
                if (ma.containsMouse) return btn.isDestructive ? 1.0 : 0.08
                return 0
            }
            visible: ma.containsMouse || ma.pressed

            Behavior on opacity { NumberAnimation { duration: 150 } }
        }

        // Icon/Text
        Text {
            anchors.centerIn: parent
            text: btn.symbol
            font.pixelSize: 16
            color: {
                if (btn.isDestructive && ma.containsMouse) return Theme.ChiTheme.colors.onError
                return Theme.ChiTheme.colors.onSurface
            }
            font.family: "Material Icons" // Fallback to system font if missing
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            onClicked: btn.clicked()
        }
    }

    WinBtn {
        symbol: "─" // Minimize
        onClicked: root.targetWindow.showMinimized()
    }

    WinBtn {
        // Toggle icon based on state
        symbol: root.targetWindow.visibility === Window.Maximized ? "❐" : "☐"
        onClicked: {
            if (root.targetWindow.visibility === Window.Maximized)
                root.targetWindow.showNormal()
            else
                root.targetWindow.showMaximized()
        }
    }

    WinBtn {
        symbol: "✕" // Close
        isDestructive: true
        onClicked: root.targetWindow.close()
    }
}
