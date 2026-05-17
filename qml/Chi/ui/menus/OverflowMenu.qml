// qml/smartui/ui/menus/OverflowMenu.qml
// M3 overflow menu — grouped model-driven, cascade flyout to the right
// Headers styled as regular items, hover to open/switch cascade
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Effects
import "../../theme" as Theme
import "../common"

Popup {
    id: root

    property var menus: []
    property var colors: Theme.ChiTheme.colors
    property int maxHeight: 500

    signal itemTriggered(string menuId, string itemId)

    x: 0
    y: parent ? parent.height + 4 : 0
    padding: 0
    focus: true

    // ── Cascade state ──
    property var _cascadeItems: []
    property string _cascadeMenuId: ""
    property int _cascadeTargetIndex: -1

    // Content-aware width
    readonly property int _contentWidth: {
        var w = 200;
        for (var i = 0; i < root.menus.length; i++) {
            var t = root.menus[i].title || "";
            var tw = t.length * 7 + 56;
            if (tw > w)
                w = tw;
        }
        return Math.min(w, 360);
    }
    width: _contentWidth

    readonly property int _contentHeight: {
        var h = 8;
        for (var i = 0; i < root.menus.length; i++)
            h += 36;
        return h;
    }
    height: Math.min(_contentHeight, maxHeight)

    onClosed: _cascadePopup.close()

    background: Rectangle {
        color: root.colors.surfaceContainerHigh
        radius: 12
        border.width: 1
        border.color: root.colors.outlineVariant

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.15)
            shadowVerticalOffset: 4
            shadowBlur: 0.4
        }
    }

    contentItem: Flickable {
        id: _flick
        anchors.fill: parent
        contentHeight: _col.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: _col
            anchors.left: parent.left
            anchors.right: parent.right
            padding: 4
            spacing: 0

            Repeater {
                model: root.menus

                delegate: Item {
                    required property var modelData
                    required property int index

                    height: 36
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 0
                    anchors.rightMargin: 0

                    readonly property bool _hasItems: modelData.items && modelData.items.length > 0

                    Rectangle {
                        anchors.fill: parent
                        anchors.leftMargin: 4
                        anchors.rightMargin: 4
                        anchors.topMargin: 1
                        anchors.bottomMargin: 1
                        radius: 8
                        color: _headMouse.containsMouse && _hasItems ? Qt.alpha(root.colors.onSurface, 0.08) : "transparent"

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            spacing: 8

                            Text {
                                text: modelData.title || ""
                                font.family: Theme.ChiTheme.typography.bodyMedium.family
                                font.pixelSize: Theme.ChiTheme.typography.bodyMedium.size
                                font.weight: Theme.ChiTheme.typography.bodyMedium.weight
                                color: root.colors.onSurface
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            Icon {
                                visible: _hasItems
                                source: "chevron_right"
                                size: 16
                                color: root.colors.onSurfaceVariant
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }

                        // Hover timer for cascade open
                        Timer {
                            id: _cascadeTimer
                            interval: 60
                            onTriggered: root._openCascade(modelData.items, modelData.id || "", index, _headMouse.mapToItem(null, 0, 0).y)
                        }

                        MouseArea {
                            id: _headMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (_hasItems) {
                                    _cascadeTimer.stop();
                                    root._openCascade(modelData.items, modelData.id || "", index, _headMouse.mapToItem(null, 0, 0).y);
                                }
                            }
                            onContainsMouseChanged: {
                                if (containsMouse && _hasItems) {
                                    if (_cascadePopup.opened) {
                                        _cascadeTimer.stop();
                                        root._openCascade(modelData.items, modelData.id || "", index, _headMouse.mapToItem(null, 0, 0).y);
                                    } else {
                                        _cascadeTimer.restart();
                                    }
                                } else {
                                    _cascadeTimer.stop();
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    function _openCascade(items, menuId, index, yPos) {
        root._cascadeItems = items;
        root._cascadeMenuId = menuId;
        root._cascadeTargetIndex = index;

        // Position to the right, aligned with hovered item
        _cascadePopup.x = root.x + root.width;
        _cascadePopup.y = yPos;

        if (!_cascadePopup.opened)
            _cascadePopup.open();
    }

    // ── Cascade flyout ──
    Popup {
        id: _cascadePopup
        width: 240
        padding: 4
        focus: true

        readonly property int _contentH: {
            var h = 0;
            for (var i = 0; i < root._cascadeItems.length; i++)
                h += (root._cascadeItems[i].type === "divider" ? 9 : 36);
            return h;
        }
        height: Math.min(_contentH + 8, 400)

        background: Rectangle {
            color: root.colors.surfaceContainerHigh
            radius: 12
            border.width: 1
            border.color: root.colors.outlineVariant

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: Qt.rgba(0, 0, 0, 0.15)
                shadowVerticalOffset: 4
                shadowBlur: 0.4
            }
        }

        contentItem: Flickable {
            id: _cascFlick
            anchors.fill: parent
            contentHeight: _cascCol.implicitHeight
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            Column {
                id: _cascCol
                anchors.left: parent.left
                anchors.right: parent.right
                padding: 4
                spacing: 0

                Repeater {
                    model: root._cascadeItems

                    delegate: Item {
                        required property var modelData
                        required property int index

                        width: parent ? parent.width : 232
                        height: _isDivider ? 9 : 36

                        readonly property string _id: modelData.id || ""
                        readonly property string _text: modelData.text || ""
                        readonly property string _icon: modelData.icon || ""
                        readonly property string _shortcut: modelData.shortcut || ""
                        readonly property bool _isDivider: modelData.type === "divider"

                        Rectangle {
                            visible: _isDivider
                            anchors.centerIn: parent
                            width: parent.width - 16
                            height: 1
                            color: root.colors.outlineVariant
                        }

                        Rectangle {
                            visible: !_isDivider
                            anchors.fill: parent
                            anchors.margins: 1
                            radius: 8
                            color: _itemMouse.containsMouse ? Qt.alpha(root.colors.onSurface, 0.08) : "transparent"

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                spacing: 10

                                Icon {
                                    visible: _icon !== ""
                                    source: _icon
                                    size: 18
                                    color: root.colors.onSurfaceVariant
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                Text {
                                    text: _text
                                    font.family: Theme.ChiTheme.typography.bodyMedium.family
                                    font.pixelSize: Theme.ChiTheme.typography.bodyMedium.size
                                    font.weight: Theme.ChiTheme.typography.bodyMedium.weight
                                    color: root.colors.onSurface
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                Text {
                                    visible: _shortcut !== ""
                                    text: _shortcut
                                    font.family: Theme.ChiTheme.typography.labelSmall.family
                                    font.pixelSize: Theme.ChiTheme.typography.labelSmall.size
                                    font.weight: Theme.ChiTheme.typography.labelSmall.weight
                                    color: root.colors.onSurfaceVariant
                                    opacity: 0.6
                                    Layout.alignment: Qt.AlignVCenter
                                }
                            }

                            MouseArea {
                                id: _itemMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.itemTriggered(root._cascadeMenuId, _id);
                                    root.close();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
