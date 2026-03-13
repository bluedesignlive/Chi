import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme

Item {
    id: root

    // ─── Public API ─────────────────────────────────────────
    property string icon: ""
    property string activeIcon: ""
    property string label: ""
    property bool selected: false
    property bool showLabel: true
    property bool showBadge: false
    property string badgeText: ""
    property bool enabled: true
    property int navIndex: 0

    signal clicked()

    // ─── Theme Tokens ───────────────────────────────────────
    readonly property var _c: Theme.ChiTheme.colors
    readonly property var _t: Theme.ChiTheme.typography
    readonly property var _m: Theme.ChiTheme.motion

    // ─── Derived (private) ──────────────────────────────────
    readonly property string _displayIcon: selected && activeIcon !== "" ? activeIcon : icon

    // ─── Layout ─────────────────────────────────────────────
    Layout.fillWidth: true
    Layout.fillHeight: true
    opacity: enabled ? 1.0 : 0.38

    Column {
        anchors.centerIn: parent
        spacing: 4

        // ─── Icon Container ─────────────────────────────────
        Item {
            width: 64
            height: 32
            anchors.horizontalCenter: parent.horizontalCenter

            // Active indicator pill
            Rectangle {
                id: indicator
                anchors.centerIn: parent
                width: root.selected ? 64 : 0
                height: 32
                radius: 16
                color: _c.secondaryContainer
                opacity: root.selected ? 1 : 0

                Behavior on width {
                    NumberAnimation {
                        duration: _m.durationFast
                        easing.type: _m.easeStandard
                    }
                }
                Behavior on opacity {
                    NumberAnimation { duration: _m.durationFast }
                }
                Behavior on color {
                    ColorAnimation { duration: _m.durationFast }
                }
            }

            // State layer
            Rectangle {
                anchors.centerIn: parent
                width: 64
                height: 32
                radius: 16
                color: root.selected ? _c.onSecondaryContainer : _c.onSurface
                opacity: tapHandler.pressed ? 0.12
                       : hoverHandler.hovered ? 0.08
                       : 0

                Behavior on opacity {
                    NumberAnimation { duration: _m.durationFast }
                }
            }

            // Icon
            Text {
                anchors.centerIn: parent
                text: root._displayIcon
                font.family: Theme.ChiTheme.iconFamily
                font.pixelSize: 24
                color: root.selected ? _c.onSecondaryContainer : _c.onSurfaceVariant

                Behavior on color {
                    ColorAnimation { duration: _m.durationFast }
                }
            }

            // Badge
            Rectangle {
                visible: root.showBadge
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: 12
                anchors.topMargin: 2
                width: root.badgeText === "" ? 6 : Math.max(16, badgeLabel.implicitWidth + 8)
                height: root.badgeText === "" ? 6 : 16
                radius: height / 2
                color: _c.error
                scale: root.showBadge ? 1 : 0

                Behavior on scale {
                    NumberAnimation {
                        duration: _m.durationFast
                        easing.type: _m.easeBack
                    }
                }
                Behavior on color {
                    ColorAnimation { duration: _m.durationFast }
                }

                Text {
                    id: badgeLabel
                    visible: root.badgeText !== ""
                    anchors.centerIn: parent
                    text: root.badgeText
                    font.family: _t.labelSmall.family
                    font.pixelSize: _t.labelSmall.size
                    font.weight: _t.labelSmall.weight
                    color: _c.onError

                    Behavior on color {
                        ColorAnimation { duration: _m.durationFast }
                    }
                }
            }
        }

        // ─── Label ──────────────────────────────────────────
        Text {
            visible: root.showLabel
            text: root.label
            font.family: _t.labelMedium.family
            font.pixelSize: _t.labelMedium.size
            font.weight: root.selected ? Font.Medium : Font.Normal
            font.letterSpacing: _t.labelMedium.spacing
            color: root.selected ? _c.onSurface : _c.onSurfaceVariant
            anchors.horizontalCenter: parent.horizontalCenter

            Behavior on color {
                ColorAnimation { duration: _m.durationFast }
            }
        }
    }

    // ─── Input Handlers ─────────────────────────────────────
    HoverHandler {
        id: hoverHandler
        enabled: root.enabled
        cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
    }

    TapHandler {
        id: tapHandler
        enabled: root.enabled
        onTapped: root.clicked()
    }

    // ─── Accessibility ──────────────────────────────────────
    Accessible.role: Accessible.PageTab
    Accessible.name: label
    Accessible.selected: selected
}
