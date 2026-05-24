import QtQuick
import "../../theme" as Theme
import "../common" as Common
import "../menus" as Menus

Item {
 id: root

 property string icon: ""
 property string iconName: "" // Named Material Symbol (e.g. "search"). Preferred.
 readonly property string _resolvedIcon: iconName !== "" ? iconName : icon
 property string tooltip: ""
 property bool enabled: true

 signal clicked

 implicitWidth: 48
 implicitHeight: 48

 opacity: enabled ? 1.0 : 0.38

 property var colors: Theme.ChiTheme.colors

 Rectangle {
 anchors.centerIn: parent
 width: 40
 height: 40
 radius: 20
 color: colors.onSurface
 opacity: mouseArea.containsMouse && enabled ? 0.08 : 0

 Behavior on opacity {
 NumberAnimation {
 duration: 100
 }
 }
 }

 Common.Icon {
 anchors.centerIn: parent
 source: root._resolvedIcon
 size: 24
 color: colors.onSurfaceVariant

 Behavior on color {
 ColorAnimation {
 duration: 200
 }
 }
 }

 MouseArea {
 id: mouseArea
 anchors.fill: parent
 enabled: root.enabled
 hoverEnabled: true
 cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

 onClicked: root.clicked()
 }

 Menus.Tooltip {
 target: mouseArea
 text: root.tooltip
 }

 Accessible.role: Accessible.Button
 Accessible.name: tooltip || icon
}
