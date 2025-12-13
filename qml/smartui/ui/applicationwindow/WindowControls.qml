import QtQuick
import "../../theme" as Theme

Row {
    id: root
    spacing: 8
    property Window targetWindow: Window.window
    property var colors: Theme.ChiTheme.colors

    component WinBtn: Rectangle {
        id: btn
        width: 32; height: 32; radius: 16
        color: "transparent"
        property string icon: ""
        property bool danger: false
        
        // FIX: Signal name must match usage (clicked -> onClicked)
        signal clicked()

        Rectangle {
            anchors.fill: parent; radius: 16
            color: btn.danger ? colors.error : colors.onSurface
            opacity: ma.pressed ? 0.12 : (ma.containsMouse ? (btn.danger ? 1.0 : 0.08) : 0)
            visible: ma.containsMouse || ma.pressed
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
        Text {
            anchors.centerIn: parent; text: btn.icon
            color: (btn.danger && ma.containsMouse) ? colors.onError : colors.onSurface
            font.pixelSize: 14; font.family: "Material Icons"
        }
        MouseArea { 
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            onClicked: btn.clicked() 
        }
    }

    WinBtn { icon: "─"; onClicked: root.targetWindow.showMinimized() }
    WinBtn { 
        icon: root.targetWindow.visibility === Window.Maximized ? "❐" : "☐"
        onClicked: { 
            if(root.targetWindow.visibility === Window.Maximized) 
                root.targetWindow.showNormal()
            else 
                root.targetWindow.showMaximized()
        } 
    }
    WinBtn { icon: "✕"; danger: true; onClicked: root.targetWindow.close() }
}
