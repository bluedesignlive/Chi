import QtQuick
import QtQuick.Layouts
import "../theme" as Theme

Item {
    id: root

    property string text: ""
    property string icon: ""
    property string activeIcon: ""
    property bool selected: false
    property bool enabled: true
    property string badge: ""
    property string trailingText: ""
    property string density: "compact"       // "small" | "compact" | "standard"

    signal clicked()

    // ─── Theme Tokens ───────────────────────────────────────
    readonly property var _c: Theme.ChiTheme.colors
    readonly property var _t: Theme.ChiTheme.typography
    readonly property var _m: Theme.ChiTheme.motion

    // ─── Density Metrics ────────────────────────────────────
    //
    //              small       compact      standard
    //  height      36          40           56
    //  radius      18          20           28
    //  pill margin 6           8            12
    //  icon        18          20           24
    //  left pad    10          12           16
    //  right pad   10          16           24
    //  spacing     6           8            12
    //  label       bodySmall   labelLarge   labelLarge
    //  badge       18          20           24

    readonly property bool _isSmall: density === "small"
    readonly property bool _isStandard: density === "standard"

    readonly property real _itemHeight: _isSmall ? 36 : _isStandard ? 56 : 40
    readonly property real _pillRadius: _isSmall ? 18 : _isStandard ? 28 : 20
    readonly property real _pillMargin: _isSmall ? 6 : _isStandard ? 12 : 8
    readonly property real _iconSize: _isSmall ? 18 : _isStandard ? 24 : 20
    readonly property real _leftPad: _isSmall ? 10 : _isStandard ? 16 : 12
    readonly property real _rightPad: _isSmall ? 10 : _isStandard ? 24 : 16
    readonly property real _spacing: _isSmall ? 6 : _isStandard ? 12 : 8
    readonly property real _labelSize: _isSmall ? _t.bodySmall.size : _t.labelLarge.size
    readonly property real _badgeSize: _isSmall ? 18 : _isStandard ? 24 : 20

    // ─── Derived ────────────────────────────────────────────
    readonly property string _displayIcon: selected && activeIcon !== "" ? activeIcon : icon
    readonly property bool _hasIcon: icon !== ""
    readonly property bool _hasBadge: badge !== ""
    readonly property bool _hasTrailing: trailingText !== ""

    // ─── Layout ─────────────────────────────────────────────
    Layout.fillWidth: true
    implicitHeight: _itemHeight
    opacity: enabled ? 1.0 : 0.38

    Rectangle {
        id: pill
        anchors.fill: parent
        anchors.leftMargin: root._pillMargin
        anchors.rightMargin: root._pillMargin
        radius: root._pillRadius
        color: root.selected ? _c.secondaryContainer : "transparent"

        // ─── State Layer ────────────────────────────────────
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: root.selected ? _c.onSecondaryContainer : _c.onSurface
            opacity: tapHandler.pressed ? 0.12
                   : hoverHandler.hovered ? 0.08
                   : 0

            Behavior on opacity {
                NumberAnimation { duration: _m.durationFast }
            }
        }

        // ─── Content Row ────────────────────────────────────
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: root._leftPad
            anchors.rightMargin: root._rightPad
            spacing: root._spacing

            Text {
                visible: root._hasIcon
                text: root._displayIcon
                font.family: Theme.ChiTheme.iconFamily
                font.pixelSize: root._iconSize
                color: root.selected ? _c.onSecondaryContainer : _c.onSurfaceVariant
                Layout.alignment: Qt.AlignVCenter
            }

            Text {
                text: root.text
                font.family: _t.labelLarge.family
                font.pixelSize: root._labelSize
                font.weight: root.selected ? Font.Bold : _t.labelLarge.weight
                font.letterSpacing: _t.labelLarge.spacing
                color: root.selected ? _c.onSecondaryContainer : _c.onSurfaceVariant
                elide: Text.ElideRight
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
            }

            Text {
                visible: root._hasTrailing
                text: root.trailingText
                font.family: _t.labelLarge.family
                font.pixelSize: root._labelSize
                font.weight: _t.labelLarge.weight
                color: _c.onSurfaceVariant
                Layout.alignment: Qt.AlignVCenter
            }

            Rectangle {
                visible: root._hasBadge
                Layout.preferredWidth: Math.max(root._badgeSize, badgeLabel.implicitWidth + 8)
                Layout.preferredHeight: root._badgeSize
                Layout.alignment: Qt.AlignVCenter
                radius: height / 2
                color: root.selected ? _c.secondaryContainer : _c.error

                Text {
                    id: badgeLabel
                    anchors.centerIn: parent
                    text: root.badge
                    font.family: _t.labelSmall.family
                    font.pixelSize: _t.labelSmall.size
                    font.weight: _t.labelSmall.weight
                    color: root.selected ? _c.onSecondaryContainer : _c.onError
                }
            }
        }

        // ─── Input Handlers ─────────────────────────────────
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
    }

    Accessible.role: Accessible.MenuItem
    Accessible.name: text
    Accessible.selected: selected
}
