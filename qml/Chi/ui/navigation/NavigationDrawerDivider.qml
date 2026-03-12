import QtQuick
import QtQuick.Layouts
import "../theme" as Theme

Item {
    id: root

    property string density: "compact"

    readonly property var _c: Theme.ChiTheme.colors
    readonly property bool _isCompact: density === "compact"

    Layout.fillWidth: true
    implicitHeight: 1 + (_isCompact ? 6 : 16)

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: root._isCompact ? 12 : 28
        anchors.rightMargin: root._isCompact ? 12 : 28
        anchors.verticalCenter: parent.verticalCenter
        height: 1
        color: _c.outlineVariant
    }

    Accessible.role: Accessible.Separator
}
