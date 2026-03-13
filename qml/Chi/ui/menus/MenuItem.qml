// qml/smartui/ui/menus/MenuItem.qml
// M3 menu item — supports compact (desktop) and standard density
import QtQuick
import QtQuick.Layouts
import "../common" as Common
import "../../theme" as Theme

Item {
    id: root

    // ═══════════════════════════════════════════════════════════════════
    // PROPERTIES
    // ═══════════════════════════════════════════════════════════════════

    property string text: ""
    property string leadingIcon: ""
    property string trailingIcon: ""
    property string trailingText: ""
    property string supportingText: ""
    property bool enabled: true
    property bool selected: false
    property bool destructive: false
    property bool showDivider: false
    property bool closeOnClick: true

    // Submenu: array of { text, icon, id, shortcut, type, submenu }
    property var submenu: null

    property string menuColorStyle: "standard"
    property string menuVariant: "expressive"

    // Density — set by parent Menu, "compact" (36 px) or "standard" (48 px)
    property string menuDensity: "compact"

    // ═══════════════════════════════════════════════════════════════════
    // SIGNALS
    // ═══════════════════════════════════════════════════════════════════

    signal clicked()
    signal submenuRequested(string title, var items)

    // ═══════════════════════════════════════════════════════════════════
    // DENSITY SPECS
    // ═══════════════════════════════════════════════════════════════════

    readonly property bool _compact: menuDensity === "compact"
    readonly property real _itemH: _compact ? 36 : 48
    readonly property real _supportH: _compact ? 52 : 64
    readonly property real _iconSize: _compact ? 20 : 24
    readonly property real _radius: menuVariant === "expressive"
        ? (_compact ? 8 : 12) : 0

    // ═══════════════════════════════════════════════════════════════════
    // DERIVED STATE
    // ═══════════════════════════════════════════════════════════════════

    readonly property bool hasLeadingIcon: leadingIcon !== ""
    readonly property bool hasTrailingIcon: trailingIcon !== ""
    readonly property bool hasTrailingText: trailingText !== ""
    readonly property bool hasSupportingText: supportingText !== ""
    readonly property bool hasSubmenu: submenu !== null && submenu !== undefined
                                       && submenu.length > 0

    implicitWidth: parent ? parent.width : 200
    implicitHeight: (hasSupportingText ? _supportH : _itemH)
                    + (showDivider ? 9 : 0)
    opacity: enabled ? 1.0 : 0.38

    // ═══════════════════════════════════════════════════════════════════
    // THEME
    // ═══════════════════════════════════════════════════════════════════

    property var colors: Theme.ChiTheme.colors

    readonly property bool _vibrant: menuColorStyle === "vibrant"

    readonly property var _bodyTypo: Theme.ChiTheme.typography.bodyMedium
    readonly property var _labelTypo: Theme.ChiTheme.typography.labelMedium
    readonly property var _supportTypo: Theme.ChiTheme.typography.bodySmall

    readonly property color _textColor: {
        if (destructive) return colors.error
        if (selected) return _vibrant ? colors.onTertiary : colors.onTertiaryContainer
        return _vibrant ? colors.onTertiaryContainer : colors.onSurface
    }

    readonly property color _iconColor: {
        if (destructive) return colors.error
        if (selected) return _vibrant ? colors.onTertiary : colors.onTertiaryContainer
        return _vibrant ? colors.onTertiaryContainer : colors.onSurfaceVariant
    }

    readonly property color _selectedBg: _vibrant ? colors.tertiary : colors.tertiaryContainer
    readonly property color _stateLayer: _vibrant ? colors.onTertiaryContainer : colors.onSurface

    // ═══════════════════════════════════════════════════════════════════
    // VISUAL
    // ═══════════════════════════════════════════════════════════════════

    Column {
        anchors.fill: parent
        spacing: 0

        // Item row
        Rectangle {
            width: parent.width
            height: root.implicitHeight - (showDivider ? 9 : 0)
            radius: root._radius
            color: selected ? root._selectedBg
                 : (mouseArea.containsMouse && root.enabled)
                   ? Qt.alpha(root._stateLayer, 0.08)
                 : "transparent"

            Behavior on color { ColorAnimation { duration: 120 } }

            // Press overlay
            Rectangle {
                anchors.fill: parent
                radius: root._radius
                color: destructive ? colors.error : root._stateLayer
                opacity: mouseArea.pressed && root.enabled ? 0.12 : 0
                Behavior on opacity { NumberAnimation { duration: 80 } }
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 12

                // Leading icon
                Common.Icon {
                    visible: root.hasLeadingIcon
                    source: root.leadingIcon
                    size: root._iconSize
                    color: root._iconColor
                    Layout.alignment: Qt.AlignVCenter
                }

                // Text column
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 1

                    Text {
                        text: root.text
                        font.family: root._bodyTypo.family
                        font.pixelSize: root._bodyTypo.size
                        font.weight: selected ? Font.Medium : root._bodyTypo.weight
                        font.letterSpacing: root._bodyTypo.spacing || 0
                        color: root._textColor
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Text {
                        visible: root.hasSupportingText
                        text: root.supportingText
                        font.family: root._supportTypo.family
                        font.pixelSize: root._supportTypo.size
                        font.weight: root._supportTypo.weight
                        font.letterSpacing: root._supportTypo.spacing || 0
                        color: root._vibrant ? colors.onTertiaryContainer
                                             : colors.onSurfaceVariant
                        opacity: 0.8
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                // Trailing text (shortcut)
                Text {
                    visible: root.hasTrailingText && !root.hasSubmenu
                    text: root.trailingText
                    font.family: root._labelTypo.family
                    font.pixelSize: root._labelTypo.size
                    font.weight: root._labelTypo.weight
                    font.letterSpacing: root._labelTypo.spacing || 0
                    color: root._vibrant ? colors.onTertiaryContainer
                                         : colors.onSurfaceVariant
                    opacity: 0.7
                    Layout.alignment: Qt.AlignVCenter
                }

                // Trailing icon OR submenu chevron
                Common.Icon {
                    visible: root.hasSubmenu || root.hasTrailingIcon
                    source: root.hasSubmenu ? "chevron_right" : root.trailingIcon
                    size: root.hasSubmenu ? 18 : root._iconSize
                    color: root._iconColor
                    Layout.alignment: Qt.AlignVCenter
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                enabled: root.enabled
                hoverEnabled: true
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

                onClicked: {
                    if (root.hasSubmenu)
                        root.submenuRequested(root.text, root.submenu)
                    else
                        root.clicked()
                }
            }
        }

        // Optional divider below
        Item {
            visible: root.showDivider
            width: parent.width; height: 9

            Rectangle {
                anchors.centerIn: parent
                width: parent.width - 24; height: 1
                color: colors.outlineVariant
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════════
    // ACCESSIBILITY
    // ═══════════════════════════════════════════════════════════════════

    Accessible.role: Accessible.MenuItem
    Accessible.name: text
}
