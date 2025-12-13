import QtQuick
import QtQuick.Controls.Basic as T
import "../../theme" as Theme

T.MenuSeparator {
    topPadding: 8
    bottomPadding: 8
    contentItem: Rectangle {
        implicitWidth: 200
        implicitHeight: 1
        color: Theme.ChiTheme.colors.outlineVariant
        opacity: 0.5
    }
}
