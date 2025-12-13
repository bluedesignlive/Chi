import QtQuick
import QtQuick.Controls.Basic as T
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

T.Menu {
    id: control
    property var colors: Theme.ChiTheme.colors

    topPadding: 12
    bottomPadding: 12
    padding: 0
    
    background: Rectangle {
        implicitWidth: 240
        implicitHeight: 48
        color: colors.surfaceContainer
        radius: 16
        border.width: 1
        border.color: colors.outlineVariant

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 4
            radius: 16
            samples: 20
            color: Qt.rgba(0,0,0,0.15)
        }
    }

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 150 }
        NumberAnimation { property: "scale"; from: 0.95; to: 1; duration: 150; easing.type: Easing.OutCubic }
    }
    
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 100 }
    }
    
    delegate: MenuItem { }
}
