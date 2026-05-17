// qml/smartui/ui/menus/DropdownMenu.qml
// M3 dropdown menu — model-driven, desktop-density
// In-place submenu navigation, click to enter submenu
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Effects
import QtQuick.Layouts
import "../../theme" as Theme
import "../common"

Popup {
    id: root

    property var items: []
    property var colors: Theme.ChiTheme.colors

    signal itemClicked(string itemId)

    width: 200
    padding: 4
    focus: true

    // ── Submenu navigation stack ──
    property var _navStack: []
    readonly property bool _inSubmenu: _navStack.length > 0
    readonly property var _subItems: _inSubmenu
        ? _navStack[_navStack.length - 1].items : []
    readonly property string _subTitle: _inSubmenu
        ? _navStack[_navStack.length - 1].title : ""

    // Content height calculated from items
    readonly property int _mainH: {
        var h = 0
        for (var i = 0; i < root.items.length; i++)
            h += root.items[i].type === "divider" ? 9 : 36
        return h
    }
    readonly property int _subH: {
        var h = 41 // back header (36) + divider space (5)
        for (var i = 0; i < root._subItems.length; i++)
            h += root._subItems[i].type === "divider" ? 9 : 36
        return h
    }

    property real _mainOpacity: _inSubmenu ? 0 : 1
    property real _subOpacity: _inSubmenu ? 1 : 0
    Behavior on _mainOpacity {
        NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
    }
    Behavior on _subOpacity {
        NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
    }

    function _pushSub(title, items) {
        var s = _navStack.slice()
        s.push({ title: title, items: items })
        _navStack = s
    }

    function _popSub() {
        if (_navStack.length > 0) {
            var s = _navStack.slice()
            s.pop()
            _navStack = s
        }
        root._highlightIdx = -1
    }

    onAboutToShow: { _navStack = []; _highlightIdx = -1 }
    onClosed: _navStack = []

    // ── Keyboard nav ──
    property int _highlightIdx: -1

    function _activateItem(idx) {
        var list = root._inSubmenu ? root._subItems : root.items
        if (idx < 0 || idx >= list.length) return
        var item = list[idx]
        if (!item || item.type === "divider") return
        if (item.submenu && item.submenu.length > 0) {
            root._pushSub(item.text || "", item.submenu)
            root._highlightIdx = -1
        } else {
            root.itemClicked(item.id || "")
            root.close()
        }
    }

    background: Rectangle {
        color: root.colors.surfaceContainerHigh
        radius: 12
        border.width: 1
        border.color: root.colors.outlineVariant

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.12)
            shadowVerticalOffset: 4
            shadowBlur: 0.35
        }
    }

    contentItem: Item {
        id: _content
        implicitHeight: root._inSubmenu ? root._subH : root._mainH
        activeFocusOnTab: true
        clip: true

        // ── Submenu view ──
        Column {
            anchors.fill: parent
            spacing: 0
            opacity: root._subOpacity
            visible: root._inSubmenu

            Item {
                width: parent.width; height: 36

                Rectangle {
                    anchors.fill: parent; anchors.margins: 1; radius: 8
                    color: _backMouse.containsMouse
                        ? Qt.alpha(root.colors.onSurface, 0.08) : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8; anchors.rightMargin: 12; spacing: 8

                        Icon {
                            source: "arrow_back"; size: 18
                            color: root.colors.onSurfaceVariant
                            Layout.alignment: Qt.AlignVCenter
                        }
                        Text {
                            text: root._subTitle
                            font.family: Theme.ChiTheme.typography.labelLarge.family
                            font.pixelSize: Theme.ChiTheme.typography.labelLarge.size
                            font.weight: Theme.ChiTheme.typography.labelLarge.weight
                            color: root.colors.onSurface; elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }

                    MouseArea {
                        id: _backMouse; anchors.fill: parent; hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root._popSub()
                    }
                }
            }

            Item { width: parent.width; height: 5
                Rectangle { anchors.centerIn: parent; width: parent.width - 16; height: 1; color: root.colors.outlineVariant }
            }

            Repeater {
                model: root._subItems

                delegate: Item {
                    required property var modelData
                    required property int index

                    width: _content.width
                    height: _isDivider ? 9 : 36

                    readonly property string _id:       modelData.id || ""
                    readonly property string _text:     modelData.text || ""
                    readonly property string _icon:     modelData.icon || ""
                    readonly property string _shortcut: modelData.shortcut || ""
                    readonly property bool   _isDivider:  modelData.type === "divider"

                    Rectangle {
                        visible: _isDivider
                        anchors.centerIn: parent
                        width: parent.width - 16; height: 1
                        color: root.colors.outlineVariant
                    }

                    Rectangle {
                        visible: !_isDivider
                        anchors.fill: parent; anchors.margins: 1; radius: 8
                        color: _subM.containsMouse || index === root._highlightIdx
                            ? Qt.alpha(root.colors.onSurface, 0.08) : "transparent"

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12; anchors.rightMargin: 12; spacing: 10

                            Icon {
                                visible: _icon !== ""; source: _icon; size: 18
                                color: root.colors.onSurfaceVariant
                                Layout.alignment: Qt.AlignVCenter
                            }
                            Text {
                                text: _text
                                font.family: Theme.ChiTheme.typography.bodyMedium.family
                                font.pixelSize: Theme.ChiTheme.typography.bodyMedium.size
                                font.weight: Theme.ChiTheme.typography.bodyMedium.weight
                                color: root.colors.onSurface; elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                            Text {
                                visible: _shortcut !== ""
                                text: _shortcut
                                font.family: Theme.ChiTheme.typography.labelSmall.family
                                font.pixelSize: Theme.ChiTheme.typography.labelSmall.size
                                font.weight: Theme.ChiTheme.typography.labelSmall.weight
                                color: root.colors.onSurfaceVariant; opacity: 0.6
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }

                        MouseArea {
                            id: _subM; anchors.fill: parent; hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: { root.itemClicked(_id); root.close() }
                        }
                    }
                }
            }
        }

        // ── Main view ──
        Column {
            anchors.fill: parent
            spacing: 0
            opacity: root._mainOpacity
            visible: opacity > 0.01

            Repeater {
                model: root.items

                delegate: Item {
                    required property var modelData
                    required property int index

                    width: _content.width
                    height: _isDivider ? 9 : 36

                    readonly property string _id:       modelData.id || ""
                    readonly property string _text:     modelData.text || ""
                    readonly property string _icon:     modelData.icon || ""
                    readonly property string _shortcut: modelData.shortcut || ""
                    readonly property bool   _isDivider:  modelData.type === "divider"
                    readonly property bool   _hasSub:   (modelData.submenu || []).length > 0

                    Rectangle {
                        visible: _isDivider
                        anchors.centerIn: parent
                        width: parent.width - 16; height: 1
                        color: root.colors.outlineVariant
                    }

                    Rectangle {
                        visible: !_isDivider
                        anchors.fill: parent; anchors.margins: 1; radius: 8
                        color: _dropMouse.containsMouse || index === root._highlightIdx
                            ? Qt.alpha(root.colors.onSurface, 0.08) : "transparent"

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12; anchors.rightMargin: 12; spacing: 10

                            Icon {
                                visible: _icon !== ""; source: _icon; size: 18
                                color: root.colors.onSurfaceVariant
                                Layout.alignment: Qt.AlignVCenter
                            }
                            Text {
                                text: _text
                                font.family: Theme.ChiTheme.typography.bodyMedium.family
                                font.pixelSize: Theme.ChiTheme.typography.bodyMedium.size
                                font.weight: Theme.ChiTheme.typography.bodyMedium.weight
                                color: root.colors.onSurface; elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                            Text {
                                visible: _shortcut !== "" && !_hasSub
                                text: _shortcut
                                font.family: Theme.ChiTheme.typography.labelSmall.family
                                font.pixelSize: Theme.ChiTheme.typography.labelSmall.size
                                font.weight: Theme.ChiTheme.typography.labelSmall.weight
                                color: root.colors.onSurfaceVariant; opacity: 0.6
                                Layout.alignment: Qt.AlignVCenter
                            }
                            Icon {
                                visible: _hasSub
                                source: "chevron_right"; size: 16
                                color: root.colors.onSurfaceVariant
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }

                        MouseArea {
                            id: _dropMouse; anchors.fill: parent; hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (_hasSub) {
                                    root._pushSub(_text, modelData.submenu)
                                    root._highlightIdx = -1
                                } else {
                                    root.itemClicked(_id)
                                    root.close()
                                }
                            }
                        }
                    }
                }
            }
        }

        Keys.onUpPressed: {
            if (root._highlightIdx > 0)
                root._highlightIdx--
        }
        Keys.onDownPressed: {
            var list = root._inSubmenu ? root._subItems : root.items
            if (root._highlightIdx < list.length - 1)
                root._highlightIdx++
        }
        Keys.onReturnPressed: root._activateItem(root._highlightIdx)
        Keys.onEnterPressed: root._activateItem(root._highlightIdx)
        Keys.onSpacePressed: root._activateItem(root._highlightIdx)
        Keys.onEscapePressed: {
            if (root._inSubmenu)
                root._popSub()
            else
                root.close()
        }
    }
}
