// Tab.qml - Material 3 Tab Item
// Primary: icon above text (stacked). Secondary: icon inline with text.

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../common" as Common
import "../../theme" as Theme

Item {
 id: root

 // --- Properties ---
 property string text: ""
 property string icon: ""
 property bool showBadge: false
 property string badgeText: ""
 property string variant: "primary" // "primary" or "secondary"

 property bool selected: false
 property int index: 0

 signal clicked
 property var colors: Theme.ChiTheme.colors
 readonly property string fontFamily: Theme.ChiTheme.fontFamily

 // --- Sizing ---
 // Implicit height helps the parent calculate max height,
 // but the parent will likely override actual 'height'.
 implicitHeight: (variant === "primary" && icon !== "" && text !== "") ? 64 : 48
 implicitWidth: Math.max(90, contentLoader.item ? contentLoader.item.implicitWidth + 32 : 90)

 readonly property real contentWidth: contentLoader.item ? contentLoader.item.implicitWidth : 0

 // --- Accessibility ---
 Accessible.role: Accessible.PageTab
 Accessible.name: text
 Accessible.selected: selected
 Accessible.onPressAction: root.clicked()

 focus: true
 activeFocusOnTab: true

 // Keyboard Focus Tracking
 property bool _isKeyboardFocus: false

 // Handle Space/Enter for activation
 Keys.onPressed: event => {
 _isKeyboardFocus = true;
 if (event.key === Qt.Key_Space || event.key === Qt.Key_Return) {
 root.clicked();
 event.accepted = true;
 }
 }

 // --- Interaction ---
 MouseArea {
 id: mouseArea
 anchors.fill: parent
 hoverEnabled: true
 cursorShape: Qt.PointingHandCursor

 onPressed: {
 root._isKeyboardFocus = false;
 root.forceActiveFocus();
 }
 onClicked: root.clicked()
 }

 // --- State Layer ---
 Rectangle {
 id: stateLayer
 anchors.fill: parent
 color: root.colors.onSurface
 opacity: 0
 z: 0

 states: [
 State {
 name: "pressed"
 when: mouseArea.pressed
 PropertyChanges {
 target: stateLayer
 opacity: 0.12
 color: root.selected ? root.colors.primary : root.colors.onSurface
 }
 },
 State {
 name: "hovered"
 when: mouseArea.containsMouse && !mouseArea.pressed
 PropertyChanges {
 target: stateLayer
 opacity: 0.08
 color: root.selected ? root.colors.primary : root.colors.onSurface
 }
 },
 State {
 name: "keyboard_focused"
 when: root.activeFocus && root._isKeyboardFocus
 PropertyChanges {
 target: stateLayer
 opacity: 0.12
 color: root.selected ? root.colors.primary : root.colors.onSurface
 }
 }
 ]
 transitions: Transition {
 NumberAnimation {
 property: "opacity"
 duration: 100
 }
 }
 }

 // --- Content ---
 Loader {
 id: contentLoader
 anchors.centerIn: parent // Keeps text centered even if Tab stretches height
 z: 1
 sourceComponent: root.variant === "secondary" ? inlineLayout : stackedLayout
 }

 Component {
 id: stackedLayout
 ColumnLayout {
 spacing: (root.icon !== "" && root.text !== "") ? 2 : 0
 Item {
 visible: root.icon !== ""
 Layout.alignment: Qt.AlignHCenter
 Layout.preferredWidth: 24
 Layout.preferredHeight: 24
 Common.Icon {
 anchors.centerIn: parent
 source: root.icon
 size: 24
 color: root.selected ? root.colors.primary : root.colors.onSurfaceVariant
 Behavior on color {
 ColorAnimation {
 duration: 150
 }
 }
 }
 Loader {
 sourceComponent: badgeComponent
 active: root.showBadge
 }
 }
 Text {
 visible: root.text !== ""
 text: root.text
 Layout.alignment: Qt.AlignHCenter
 font.family: fontFamily
 font.pixelSize: 14
 font.weight: Font.Medium
 font.letterSpacing: 0.1
 color: root.selected ? root.colors.primary : root.colors.onSurfaceVariant
 horizontalAlignment: Text.AlignHCenter
 Behavior on color {
 ColorAnimation {
 duration: 150
 }
 }
 }
 }
 }

 Component {
 id: inlineLayout
 RowLayout {
 spacing: 8
 Item {
 visible: root.icon !== ""
 Layout.alignment: Qt.AlignVCenter
 Layout.preferredWidth: 24
 Layout.preferredHeight: 24
 Common.Icon {
 anchors.centerIn: parent
 source: root.icon
 size: 24
 color: root.selected ? root.colors.onSurface : root.colors.onSurfaceVariant
 Behavior on color {
 ColorAnimation {
 duration: 150
 }
 }
 }
 }
 Text {
 visible: root.text !== ""
 text: root.text
 Layout.alignment: Qt.AlignVCenter
 font.family: fontFamily
 font.pixelSize: 14
 font.weight: Font.Medium
 font.letterSpacing: 0.1
 color: root.selected ? root.colors.onSurface : root.colors.onSurfaceVariant
 horizontalAlignment: Text.AlignHCenter
 Behavior on color {
 ColorAnimation {
 duration: 150
 }
 }
 }
 Loader {
 sourceComponent: badgeComponent
 active: root.showBadge
 Layout.alignment: Qt.AlignTop
 }
 }
 }

 Component {
 id: badgeComponent
 Rectangle {
 width: root.badgeText === "" ? 6 : Math.max(16, badgeLabel.implicitWidth + 8)
 height: root.badgeText === "" ? 6 : 16
 radius: height / 2
 color: root.colors.error
 x: 14
 y: -2
 Text {
 id: badgeLabel
 visible: root.badgeText !== ""
 anchors.centerIn: parent
 text: root.badgeText
 font.family: fontFamily
 font.pixelSize: 11
 font.weight: Font.Medium
 color: root.colors.onError
 }
 }
 }

 // --- Keyboard Focus Ring ---
 Rectangle {
 anchors.fill: parent
 anchors.margins: 4
 radius: 4
 color: "transparent"
 border.width: 3
 border.color: root.colors.secondary
 visible: root.activeFocus && root._isKeyboardFocus
 z: 10
 }
}
