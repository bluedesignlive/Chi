import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme

Item {
    id: root

    property string icon: ""
    property string activeIcon: ""
    property string label: ""
    property bool selected: false
    property bool showLabel: true
    property bool showBadge: false
    property string badgeText: ""
    property bool enabled: true
    property int navIndex: 0

    signal clicked

    readonly property var _c: Theme.ChiTheme.colors
    readonly property var _t: Theme.ChiTheme.typography

    readonly property string _displayIcon: selected && activeIcon !== "" ? activeIcon : icon

    Layout.fillWidth: true
    Layout.fillHeight: true
    opacity: enabled ? 1.0 : 0.38

    Column {
        anchors.centerIn: parent
        spacing: 4

        // ── Icon Container ────────────────────────────────────
        Item {
            width: 64
            height: 32
            anchors.horizontalCenter: parent.horizontalCenter

            // ── Indicator pill ────────────────────────────────
            //
            //   The spring is emulated as a SequentialAnimation:
            //
            //   SELECT:  32→80 (fast stretch past target)
            //            80→64 (settle back with slight undershoot feel)
            //            64→66 (tiny final breathe — optional but delicious)
            //            66→64 (rest)
            //
            //   DESELECT: 64→20 (quick snap inward)
            //             20→0  (snap to gone)
            //
            //   This is how spring physics actually behaves —
            //   explicit keyframes beat easing math for this case
            //   because OutBack on 0→64 dips negative before climbing.

            Rectangle {
                id: indicator
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                height: 32
                width: 0
                radius: 16
                color: _c.secondaryContainer
                opacity: 0.0
                transformOrigin: Item.Center

                Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.OutCubic } }

                // ── SELECT spring ─────────────────────────────
                SequentialAnimation {
                    id: pillSelect
                    // Opacity snaps on immediately
                    NumberAnimation { target: indicator; property: "opacity"; to: 1.0; duration: 80; easing.type: Easing.OutCubic }
                    // Stretch fast past target (overshoot)
                    NumberAnimation { target: indicator; property: "width"; to: 80; duration: 180; easing.type: Easing.OutCubic }
                    // Spring back to rest
                    NumberAnimation { target: indicator; property: "width"; to: 60; duration: 140; easing.type: Easing.InOutCubic }
                    // Tiny final breathe — the "alive" feeling
                    NumberAnimation { target: indicator; property: "width"; to: 66; duration: 100; easing.type: Easing.OutCubic }
                    NumberAnimation { target: indicator; property: "width"; to: 64; duration: 120; easing.type: Easing.InOutCubic }
                }

                // ── DESELECT snap ─────────────────────────────
                SequentialAnimation {
                    id: pillDeselect
                    // Quick pinch inward
                    NumberAnimation { target: indicator; property: "width"; to: 24; duration: 140; easing.type: Easing.InCubic }
                    // Snap to gone + fade together
                    NumberAnimation { target: indicator; property: "width"; to: 0;  duration: 100; easing.type: Easing.InQuart }
                    NumberAnimation { target: indicator; property: "opacity"; to: 0.0; duration: 80; easing.type: Easing.OutCubic }
                }
            }

            // ── State layer (hover / press) ───────────────────
            Rectangle {
                anchors.centerIn: parent
                width: 64; height: 32; radius: 16
                color: root.selected ? _c.onSecondaryContainer : _c.onSurface
                opacity: tapHandler.pressed ? 0.12 : hoverHandler.hovered ? 0.08 : 0
                Behavior on opacity { NumberAnimation { duration: 80; easing.type: Easing.OutCubic } }
            }

            // ── Icon ──────────────────────────────────────────
            Text {
                anchors.centerIn: parent
                text: root._displayIcon
                font.family: Theme.ChiTheme.iconFamily
                font.pixelSize: 24
                color: root.selected ? _c.onSecondaryContainer : _c.onSurfaceVariant
                Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.OutCubic } }
            }

            // ── Badge ─────────────────────────────────────────
            Rectangle {
                id: badge
                visible: root.showBadge
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: 12
                anchors.topMargin: 2
                width: root.badgeText === "" ? 6 : Math.max(16, badgeLabel.implicitWidth + 8)
                height: root.badgeText === "" ? 6 : 16
                radius: height / 2
                color: _c.error
                transformOrigin: Item.Center
                scale: 0

                SequentialAnimation {
                    id: badgeIn
                    running: false
                    NumberAnimation { target: badge; property: "scale"; to: 1.3;  duration: 200; easing.type: Easing.OutCubic }
                    NumberAnimation { target: badge; property: "scale"; to: 0.9;  duration: 120; easing.type: Easing.InOutCubic }
                    NumberAnimation { target: badge; property: "scale"; to: 1.05; duration: 80;  easing.type: Easing.OutCubic }
                    NumberAnimation { target: badge; property: "scale"; to: 1.0;  duration: 80;  easing.type: Easing.InOutCubic }
                }
                SequentialAnimation {
                    id: badgeOut
                    running: false
                    NumberAnimation { target: badge; property: "scale"; to: 1.15; duration: 80;  easing.type: Easing.OutCubic }
                    NumberAnimation { target: badge; property: "scale"; to: 0.0;  duration: 160; easing.type: Easing.InBack; easing.overshoot: 0.8 }
                }

                Behavior on color { ColorAnimation { duration: 200 } }

                Text {
                    id: badgeLabel
                    visible: root.badgeText !== ""
                    anchors.centerIn: parent
                    text: root.badgeText
                    font.family: _t.labelSmall.family
                    font.pixelSize: _t.labelSmall.size
                    font.weight: _t.labelSmall.weight
                    color: _c.onError
                    Behavior on color { ColorAnimation { duration: 200 } }
                }
            }
        }

        // ── Label ─────────────────────────────────────────────
        Item {
            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.max(idleLabel.implicitWidth, selectedLabel.implicitWidth)
            height: selectedLabel.implicitHeight
            visible: root.showLabel

            Text {
                id: idleLabel
                anchors.centerIn: parent
                text: root.label
                font.family: _t.labelMedium.family
                font.pixelSize: _t.labelMedium.size
                font.weight: Font.Normal
                font.letterSpacing: _t.labelMedium.spacing
                color: _c.onSurfaceVariant
                opacity: root.selected ? 0.0 : 1.0
                Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                Behavior on color   { ColorAnimation  { duration: 200 } }
            }
            Text {
                id: selectedLabel
                anchors.centerIn: parent
                text: root.label
                font.family: _t.labelMedium.family
                font.pixelSize: _t.labelMedium.size
                font.weight: Font.Medium
                font.letterSpacing: _t.labelMedium.spacing
                color: _c.onSurface
                opacity: root.selected ? 1.0 : 0.0
                Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                Behavior on color   { ColorAnimation  { duration: 200 } }
            }
        }
    }

    // ── Trigger the spring sequences ──────────────────────────
    onSelectedChanged: {
        if (selected) {
            pillDeselect.stop()
            // reset to starting state so spring always fires from clean position
            indicator.width   = 32
            indicator.opacity = 0.0
            pillSelect.start()
            if (showBadge) { badgeOut.stop(); badgeIn.start() }
        } else {
            pillSelect.stop()
            pillDeselect.start()
        }
    }

    onShowBadgeChanged: {
        if (showBadge) { badgeOut.stop(); badge.scale = 0; badgeIn.start() }
        else           { badgeIn.stop();  badgeOut.start() }
    }

    // ── Input ─────────────────────────────────────────────────
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

    // ── Accessibility ─────────────────────────────────────────
    Accessible.role: Accessible.PageTab
    Accessible.name: label
    Accessible.selected: selected
}
