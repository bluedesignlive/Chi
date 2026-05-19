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

    property var _navStack: []
    readonly property bool _inSub: _navStack.length > 0
    readonly property var _subItems: _inSub ? _navStack[_navStack.length - 1].items : []
    readonly property string _subTitle: _inSub ? _navStack[_navStack.length - 1].title : ""

    readonly property real _itemH: 36
    readonly property real _divH: 9

    readonly property int _mainH: {
        var h = 0
        for (var i = 0; i < items.length; i++) {
            if (items[i].type === "divider")
                h += _divH
            else
                h += _itemH
        }
        return h
    }
    readonly property int _subH: {
        var h = _itemH + _divH
        for (var i = 0; i < _subItems.length; i++) {
            if (_subItems[i].type === "divider")
                h += _divH
            else
                h += _itemH
        }
        return h
    }

    property real _mainSlide: _inSub ? -16 : 0
    property real _subSlide: _inSub ? 0 : 16
    property real _mainOpac: _inSub ? 0 : 1
    property real _subOpac: _inSub ? 1 : 0

    Behavior on _mainSlide { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
    Behavior on _subSlide { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
    Behavior on _mainOpac { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
    Behavior on _subOpac { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

    enter: Transition {
        ParallelAnimation {
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 200
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                property: "scale"
                from: 0.85
                to: 1
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
    }
    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1
            to: 0
            duration: 150
            easing.type: Easing.OutCubic
        }
    }

    function _pushSub(title, subItems) {
        var s = _navStack.slice()
        s.push({ title: title, items: subItems })
        _navStack = s
        _highlightIdx = -1
    }

    function _popSub() {
        if (_navStack.length > 0) {
            var s = _navStack.slice()
            s.pop()
            _navStack = s
        }
        _highlightIdx = -1
    }

    onAboutToShow: {
        _navStack = []
        _highlightIdx = -1
    }

    onClosed: _navStack = []

    property int _highlightIdx: -1

    function _activateItem(idx) {
        var list = _inSub ? _subItems : items
        if (idx < 0 || idx >= list.length)
            return
        var item = list[idx]
        if (!item || item.type === "divider" || item.enabled === false)
            return
        if (item.submenu && item.submenu.length > 0) {
            _pushSub(item.text || "", item.submenu)
        } else {
            itemClicked(item.id || "")
            close()
        }
    }

    function _scrollToIdx(flick, idx) {
        if (!flick)
            return
        var y = 0
        var list = _inSub ? _subItems : items
        for (var i = 0; i < idx && i < list.length; i++) {
            if (list[i].type === "divider")
                y += _divH
            else
                y += _itemH
        }
        if (y < flick.contentY)
            flick.contentY = y
        else if (y + _itemH > flick.contentY + flick.height)
            flick.contentY = y + _itemH - flick.height
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
        implicitHeight: root._inSub ? root._subH : root._mainH
        activeFocusOnTab: true

        // ── Main view ──
        Flickable {
            id: _mainFlick
            anchors.fill: parent
            visible: root._mainOpac > 0.01
            opacity: root._mainOpac
            x: root._mainSlide
            contentHeight: _mainCol.implicitHeight
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            Column {
                id: _mainCol
                width: parent.width
                spacing: 0

                Repeater {
                    model: root.items

                    delegate: Item {
                        required property var modelData
                        required property int index

                        width: parent ? parent.width : 200
                        height: _isDivider ? root._divH : root._itemH

                        readonly property string _id: modelData.id || ""
                        readonly property string _text: modelData.text || ""
                        readonly property string _icon: modelData.icon || ""
                        readonly property string _shortcut: modelData.shortcut || ""
                        readonly property bool _isDivider: modelData.type === "divider"
                        readonly property bool _hasSub: (modelData.submenu || []).length > 0
                        readonly property bool _enabled: modelData.enabled !== false

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
                            opacity: _enabled ? 1.0 : 0.38

                            color: {
                                if (!_enabled)
                                    return "transparent"
                                if (_dropMouse.containsMouse || index === root._highlightIdx)
                                    return Qt.alpha(root.colors.onSurface, 0.08)
                                return "transparent"
                            }

                            Behavior on color {
                                ColorAnimation { duration: 100 }
                            }

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
                                    visible: _shortcut !== "" && !_hasSub
                                    text: _shortcut
                                    font.family: Theme.ChiTheme.typography.labelSmall.family
                                    font.pixelSize: Theme.ChiTheme.typography.labelSmall.size
                                    font.weight: Theme.ChiTheme.typography.labelSmall.weight
                                    color: root.colors.onSurfaceVariant
                                    opacity: 0.6
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
                                id: _dropMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: _enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                enabled: _enabled
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
        }

        // ── Submenu view ──
        Flickable {
            id: _subFlick
            anchors.fill: parent
            visible: root._subOpac > 0.01
            opacity: root._subOpac
            x: root._subSlide
            contentHeight: _subCol.implicitHeight
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            Column {
                id: _subCol
                width: parent.width
                spacing: 0

                // Back header
                Item {
                    width: parent.width
                    height: root._itemH

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 1
                        radius: 8

                        color: _backMouse.containsMouse ? Qt.alpha(root.colors.onSurface, 0.08) : "transparent"

                        Behavior on color {
                            ColorAnimation { duration: 100 }
                        }

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
                            id: _backMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root._popSub()
                        }
                    }
                }

                // Divider
                Item {
                    width: parent.width
                    height: root._divH
                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.width - 16
                        height: 1
                        color: root.colors.outlineVariant
                    }
                }

                Repeater {
                    model: root._subItems

                    delegate: Item {
                        required property var modelData
                        required property int index

                        width: parent ? parent.width : 200
                        height: _isDivider ? root._divH : root._itemH

                        readonly property string _id: modelData.id || ""
                        readonly property string _text: modelData.text || ""
                        readonly property string _icon: modelData.icon || ""
                        readonly property string _shortcut: modelData.shortcut || ""
                        readonly property bool _isDivider: modelData.type === "divider"
                        readonly property bool _enabled: modelData.enabled !== false

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
                            opacity: _enabled ? 1.0 : 0.38

                            color: {
                                if (!_enabled)
                                    return "transparent"
                                if (_subM.containsMouse || index === root._highlightIdx)
                                    return Qt.alpha(root.colors.onSurface, 0.08)
                                return "transparent"
                            }

                            Behavior on color {
                                ColorAnimation { duration: 100 }
                            }

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
                                id: _subM
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: _enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                enabled: _enabled
                                onClicked: {
                                    root.itemClicked(_id)
                                    root.close()
                                }
                            }
                        }
                    }
                }
            }
        }

        // ── Scroll indicator — top ──
        Item {
            id: _scrollUp
            readonly property bool _show: {
                var f = root._inSub ? _subFlick : _mainFlick
                return f.contentHeight > f.height + 4 && f.contentY > 4
            }
            property var f: root._inSub ? _subFlick : _mainFlick
            visible: _show
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            height: 28
            z: 10
            opacity: _show ? 1 : 0

            Behavior on opacity {
                NumberAnimation { duration: 100 }
            }

            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    orientation: Gradient.Vertical
                    GradientStop {
                        position: 0.0
                        color: root.colors.surfaceContainerHigh
                    }
                    GradientStop {
                        position: 1.0
                        color: Qt.alpha(root.colors.surfaceContainerHigh, 0)
                    }
                }
            }

            Icon {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 6
                source: "expand_less"
                size: 16
                color: root.colors.onSurfaceVariant
                opacity: 0.7
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onPressed: {
                    _scrollUp.f.contentY = Math.max(0, _scrollUp.f.contentY - root._itemH)
                }
                onContainsMouseChanged: {
                    if (containsMouse)
                        _scrollUpAuto.start()
                    else
                        _scrollUpAuto.stop()
                }
            }
        }

        Timer {
            id: _scrollUpAuto
            interval: 50
            repeat: true
            onTriggered: {
                _scrollUp.f.contentY = Math.max(0, _scrollUp.f.contentY - 3)
            }
        }

        // ── Scroll indicator — bottom ──
        Item {
            id: _scrollDown
            readonly property bool _show: {
                var f = root._inSub ? _subFlick : _mainFlick
                return f.contentHeight > f.height + 4
                    && f.contentY + f.height < f.contentHeight - 4
            }
            property var f: root._inSub ? _subFlick : _mainFlick
            visible: _show
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
            height: 28
            z: 10
            opacity: _show ? 1 : 0

            Behavior on opacity {
                NumberAnimation { duration: 100 }
            }

            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    orientation: Gradient.Vertical
                    GradientStop {
                        position: 0.0
                        color: Qt.alpha(root.colors.surfaceContainerHigh, 0)
                    }
                    GradientStop {
                        position: 1.0
                        color: root.colors.surfaceContainerHigh
                    }
                }
            }

            Icon {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 6
                source: "expand_more"
                size: 16
                color: root.colors.onSurfaceVariant
                opacity: 0.7
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onPressed: {
                    var f = _scrollDown.f
                    f.contentY = Math.min(f.contentHeight - f.height, f.contentY + root._itemH)
                }
                onContainsMouseChanged: {
                    if (containsMouse)
                        _scrollDownAuto.start()
                    else
                        _scrollDownAuto.stop()
                }
            }
        }

        Timer {
            id: _scrollDownAuto
            interval: 50
            repeat: true
            onTriggered: {
                var f = _scrollDown.f
                f.contentY = Math.min(f.contentHeight - f.height, f.contentY + 3)
            }
        }

        // ── Keyboard ──
        Keys.onUpPressed: {
            if (root._highlightIdx > 0) {
                root._highlightIdx--
                _scrollToIdx(root._inSub ? _subFlick : _mainFlick, root._highlightIdx)
            }
        }

        Keys.onDownPressed: {
            var list = root._inSub ? root._subItems : root.items
            if (root._highlightIdx < list.length - 1) {
                root._highlightIdx++
                _scrollToIdx(root._inSub ? _subFlick : _mainFlick, root._highlightIdx)
            }
        }

        Keys.onReturnPressed: root._activateItem(root._highlightIdx)
        Keys.onEnterPressed: root._activateItem(root._highlightIdx)
        Keys.onSpacePressed: root._activateItem(root._highlightIdx)

        Keys.onEscapePressed: {
            if (root._inSub)
                root._popSub()
            else
                root.close()
        }

        Keys.onLeftPressed: {
            if (root._inSub)
                root._popSub()
        }

        Keys.onRightPressed: {
            var list = root._inSub ? root._subItems : root.items
            if (root._highlightIdx >= 0 && root._highlightIdx < list.length) {
                var item = list[root._highlightIdx]
                if (item && item.submenu && item.submenu.length > 0)
                    root._pushSub(item.text || "", item.submenu)
            }
        }

        Keys.onPressed: function(event) {
            if (!event.text || event.text.length !== 1)
                return
            var ch = event.text.toLowerCase()
            var list = root._inSub ? root._subItems : root.items
            var start = root._highlightIdx + 1
            for (var i = 0; i < list.length; i++) {
                var idx = (start + i) % list.length
                var it = list[idx]
                if (it && it.type !== "divider" && it.enabled !== false) {
                    var txt = (it.text || "").toLowerCase()
                    if (txt.length > 0 && txt[0] === ch) {
                        root._highlightIdx = idx
                        _scrollToIdx(root._inSub ? _subFlick : _mainFlick, idx)
                        break
                    }
                }
            }
        }
    }
}
