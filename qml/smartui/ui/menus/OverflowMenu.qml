// qml/smartui/ui/menus/OverflowMenu.qml
// M3 overflow menu — grouped model-driven, in-place submenu navigation
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
    width: 260
    padding: 0

    // ═══════════════════════════════════════════════════════════════════
    // SUBMENU NAVIGATION STACK
    // ═══════════════════════════════════════════════════════════════════

    property var _navStack: []
    readonly property bool _inSubmenu: _navStack.length > 0
    readonly property string _subTitle: _inSubmenu
        ? _navStack[_navStack.length - 1].title : ""
    readonly property var _subItems: _inSubmenu
        ? _navStack[_navStack.length - 1].items : []
    readonly property string _subMenuId: _inSubmenu
        ? _navStack[_navStack.length - 1].menuId : ""

    property real _mainOp: _inSubmenu ? 0 : 1
    property real _subOp:  _inSubmenu ? 1 : 0
    Behavior on _mainOp { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
    Behavior on _subOp  { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

    function _pushSub(title, items, menuId) {
        var s = _navStack.slice()
        s.push({ title: title, items: items, menuId: menuId })
        _navStack = s
    }

    function _popSub() {
        if (_navStack.length > 0) {
            var s = _navStack.slice()
            s.pop(); _navStack = s
        }
    }

    onClosed: { _navStack = []; _subFlick.contentY = 0 }

    height: Math.min(_inSubmenu ? _subCol.implicitHeight + 56
                                : _mainCol.implicitHeight + 16, maxHeight)

    Behavior on height {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    // ═══════════════════════════════════════════════════════════════════
    // BACKGROUND
    // ═══════════════════════════════════════════════════════════════════

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

    // ═══════════════════════════════════════════════════════════════════
    // CONTENT
    // ═══════════════════════════════════════════════════════════════════

    contentItem: Item {
        clip: true

        // ─── MAIN VIEW ──────────────────────────────────────────

        Flickable {
            id: _mainFlick
            anchors.fill: parent
            contentHeight: _mainCol.implicitHeight
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            visible: root._mainOp > 0.01
            opacity: root._mainOp
            x: (1 - root._mainOp) * -24

            Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

            Column {
                id: _mainCol
                width: parent.width
                padding: 4
                spacing: 0

                Repeater {
                    model: root.menus

                    delegate: Column {
                        required property var modelData
                        required property int index

                        width: _mainCol.width - 8
                        x: 4
                        spacing: 0

                        // Group header
                        Item {
                            width: parent.width; height: 28
                            visible: (modelData.title || "") !== ""

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                                text: modelData.title || ""
                                font.family: Theme.ChiTheme.typography.labelSmall.family
                                font.pixelSize: Theme.ChiTheme.typography.labelSmall.size
                                font.weight: Font.Bold
                                color: root.colors.primary
                            }
                        }

                        // Group items
                        Repeater {
                            model: modelData.items || []

                            delegate: Item {
                                required property var modelData
                                required property int index

                                width: parent.width
                                height: modelData.type === "divider" ? 9 : 36

                                readonly property bool _isDivider: modelData.type === "divider"
                                readonly property bool _hasSub: (modelData.items || []).length > 0

                                // Divider
                                Rectangle {
                                    visible: _isDivider
                                    anchors.centerIn: parent
                                    width: parent.width - 16; height: 1
                                    color: root.colors.outlineVariant
                                }

                                // Item
                                Rectangle {
                                    visible: !_isDivider
                                    anchors.fill: parent
                                    anchors.margins: 1
                                    radius: 8
                                    color: _oMouse.containsMouse
                                        ? Qt.alpha(root.colors.onSurface, 0.08)
                                        : "transparent"

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: 12
                                        anchors.rightMargin: 12
                                        spacing: 10

                                        Icon {
                                            visible: (modelData.icon || "") !== ""
                                            source: modelData.icon || ""
                                            size: 20
                                            color: root.colors.onSurfaceVariant
                                            Layout.alignment: Qt.AlignVCenter
                                        }

                                        Text {
                                            text: modelData.text || ""
                                            font.family: Theme.ChiTheme.typography.bodyMedium.family
                                            font.pixelSize: Theme.ChiTheme.typography.bodyMedium.size
                                            font.weight: Theme.ChiTheme.typography.bodyMedium.weight
                                            color: root.colors.onSurface
                                            elide: Text.ElideRight
                                            Layout.fillWidth: true
                                        }

                                        Text {
                                            visible: (modelData.shortcut || "") !== "" && !_hasSub
                                            text: modelData.shortcut || ""
                                            font.family: Theme.ChiTheme.typography.labelSmall.family
                                            font.pixelSize: Theme.ChiTheme.typography.labelSmall.size
                                            color: root.colors.onSurfaceVariant
                                            opacity: 0.7
                                            Layout.alignment: Qt.AlignVCenter
                                        }

                                        Icon {
                                            visible: _hasSub
                                            source: "chevron_right"
                                            size: 16
                                            color: root.colors.onSurfaceVariant
                                            Layout.alignment: Qt.AlignVCenter
                                        }
                                    }

                                    MouseArea {
                                        id: _oMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            if (_hasSub) {
                                                // Navigate in-place
                                                var parentId = parent.parent.parent.modelData.id || ""
                                                root._pushSub(modelData.text, modelData.items, parentId)
                                            } else {
                                                var mId = parent.parent.parent.modelData.id || ""
                                                root.itemTriggered(mId, modelData.id || "")
                                                root.close()
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Separator between groups
                        Item {
                            width: parent.width; height: 5
                            visible: index < root.menus.length - 1
                            Rectangle {
                                anchors.centerIn: parent
                                width: parent.width - 16; height: 1
                                color: root.colors.outlineVariant
                            }
                        }
                    }
                }
            }
        }

        // ─── SUBMENU VIEW ────────────────────────────────────────

        Flickable {
            id: _subFlick
            anchors.fill: parent
            contentHeight: _subCol.implicitHeight
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            visible: root._subOp > 0.01
            opacity: root._subOp
            x: (1 - root._subOp) * 24

            Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

            Column {
                id: _subCol
                width: parent.width
                padding: 4
                spacing: 0

                // Back header
                Item {
                    width: parent.width - 8; x: 4
                    height: 36

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 1
                        radius: 8
                        color: _backM.containsMouse
                            ? Qt.alpha(root.colors.onSurface, 0.08) : "transparent"

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 12
                            spacing: 8

                            Icon {
                                source: "arrow_back"
                                size: 18
                                color: root.colors.onSurfaceVariant
                                Layout.alignment: Qt.AlignVCenter
                            }

                            Text {
                                text: root._subTitle
                                font.family: Theme.ChiTheme.typography.labelLarge.family
                                font.pixelSize: Theme.ChiTheme.typography.labelLarge.size
                                font.weight: Theme.ChiTheme.typography.labelLarge.weight
                                color: root.colors.onSurface
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                        }

                        MouseArea {
                            id: _backM
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root._popSub()
                        }
                    }
                }

                // Divider
                Item {
                    width: parent.width - 8; x: 4
                    height: 5
                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.width - 16; height: 1
                        color: root.colors.outlineVariant
                    }
                }

                // Sub items
                Repeater {
                    model: root._subItems

                    delegate: Item {
                        required property var modelData
                        required property int index

                        width: _subCol.width - 8
                        x: 4
                        height: modelData.type === "divider" ? 9 : 36

                        readonly property bool _isDivider: modelData.type === "divider"
                        readonly property bool _hasSub: (modelData.items || []).length > 0

                        Rectangle {
                            visible: _isDivider
                            anchors.centerIn: parent
                            width: parent.width - 16; height: 1
                            color: root.colors.outlineVariant
                        }

                        Rectangle {
                            visible: !_isDivider
                            anchors.fill: parent
                            anchors.margins: 1
                            radius: 8
                            color: _subM.containsMouse
                                ? Qt.alpha(root.colors.onSurface, 0.08)
                                : "transparent"

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                spacing: 10

                                Icon {
                                    visible: (modelData.icon || "") !== ""
                                    source: modelData.icon || ""
                                    size: 20
                                    color: root.colors.onSurfaceVariant
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                Text {
                                    text: modelData.text || ""
                                    font.family: Theme.ChiTheme.typography.bodyMedium.family
                                    font.pixelSize: Theme.ChiTheme.typography.bodyMedium.size
                                    font.weight: Theme.ChiTheme.typography.bodyMedium.weight
                                    color: root.colors.onSurface
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                Icon {
                                    visible: _hasSub
                                    source: "chevron_right"
                                    size: 16
                                    color: root.colors.onSurfaceVariant
                                    Layout.alignment: Qt.AlignVCenter
                                }
                            }

                            MouseArea {
                                id: _subM
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (_hasSub)
                                        root._pushSub(modelData.text, modelData.items, root._subMenuId)
                                    else {
                                        root.itemTriggered(root._subMenuId, modelData.id || "")
                                        root.close()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
