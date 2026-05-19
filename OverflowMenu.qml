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

    readonly property real _itemH: 36
    readonly property real _itemR: 8
    readonly property real _iconSz: 18
    readonly property real _chevronSz: 16
    readonly property real _leadSp: 12
    readonly property real _trailSp: 12
    readonly property real _cornerR: 12
    readonly property real _divH: 9
    readonly property real _pad: 4

    x: 0
    y: parent ? parent.height + _pad : 0
    padding: 0
    focus: true

    property var _cascadeItems: []
    property string _cascadeMenuId: ""
    property int _cascadeTargetIndex: -1

    readonly property int _contentWidth: {
        var w = 200
        for (var i = 0; i < menus.length; i++) {
            var t = menus[i].title || ""
            var tw = t.length * 7 + 56
            if (tw > w)
                w = tw
        }
        return Math.min(w, 264)
    }
    width: _contentWidth

    readonly property int _contentHeight: {
        var h = _pad * 2
        for (var i = 0; i < menus.length; i++)
            h += _itemH
        return h
    }
    height: Math.min(_contentHeight, maxHeight)

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

    onClosed: _cascadePopup.close()

    Timer {
        id: _cascadeCloseTimer
        interval: 200
        onTriggered: {
            if (!_cascadeHover.hovered)
                _cascadePopup.close()
        }
    }

    background: Rectangle {
        color: root.colors.surfaceContainerHigh
        radius: root._cornerR
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

    contentItem: Item {
        id: _content
        implicitHeight: root._contentHeight

        Flickable {
            id: _mainFlick
            anchors.fill: parent
            anchors.margins: root._pad
            contentHeight: _col.implicitHeight
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            Column {
                id: _col
                width: parent.width
                spacing: 0

                Repeater {
                    model: root.menus

                    delegate: Item {
                        id: _headItem
                        required property var modelData
                        required property int index

                        height: root._itemH
                        width: parent ? parent.width : 200

                        readonly property bool _hasItems: modelData.items && modelData.items.length > 0

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 1
                            radius: root._itemR

                            color: {
                                if (_headMouse.containsMouse && _headItem._hasItems)
                                    return Qt.alpha(root.colors.onSurface, 0.08)
                                return "transparent"
                            }

                            Behavior on color {
                                ColorAnimation { duration: 100 }
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: root._leadSp
                                anchors.rightMargin: root._trailSp
                                spacing: 8

                                Text {
                                    text: _headItem.modelData.title || ""
                                    font.family: Theme.ChiTheme.typography.bodyMedium.family
                                    font.pixelSize: Theme.ChiTheme.typography.bodyMedium.size
                                    font.weight: Theme.ChiTheme.typography.bodyMedium.weight
                                    color: root.colors.onSurface
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                Icon {
                                    visible: _headItem._hasItems
                                    source: "chevron_right"
                                    size: root._chevronSz
                                    color: root.colors.onSurfaceVariant
                                    Layout.alignment: Qt.AlignVCenter
                                }
                            }
                        }

                        Timer {
                            id: _cascadeOpenTimer
                            interval: 180
                            onTriggered: {
                                root._openCascade(
                                    _headItem.modelData.items,
                                    _headItem.modelData.id || "",
                                    _headItem.index,
                                    _headItem
                                )
                            }
                        }

                        MouseArea {
                            id: _headMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                if (_headItem._hasItems) {
                                    _cascadeOpenTimer.stop()
                                    root._openCascade(
                                        _headItem.modelData.items,
                                        _headItem.modelData.id || "",
                                        _headItem.index,
                                        _headItem
                                    )
                                }
                            }

                            onContainsMouseChanged: {
                                if (containsMouse && _headItem._hasItems) {
                                    _cascadeCloseTimer.stop()
                                    if (_cascadePopup.opened) {
                                        _cascadeOpenTimer.stop()
                                        root._openCascade(
                                            _headItem.modelData.items,
                                            _headItem.modelData.id || "",
                                            _headItem.index,
                                            _headItem
                                        )
                                    } else {
                                        _cascadeOpenTimer.restart()
                                    }
                                } else if (containsMouse && !_headItem._hasItems) {
                                    _cascadeOpenTimer.stop()
                                    _cascadeCloseTimer.stop()
                                    _cascadePopup.close()
                                } else {
                                    _cascadeOpenTimer.stop()
                                    _cascadeCloseTimer.restart()
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
            readonly property bool _show: _mainFlick.contentHeight > _mainFlick.height + 4
                && _mainFlick.contentY > 4
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
                    _mainFlick.contentY = Math.max(0, _mainFlick.contentY - root._itemH)
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
                _mainFlick.contentY = Math.max(0, _mainFlick.contentY - 3)
            }
        }

        // ── Scroll indicator — bottom ──
        Item {
            id: _scrollDown
            readonly property bool _show: _mainFlick.contentHeight > _mainFlick.height + 4
                && _mainFlick.contentY + _mainFlick.height < _mainFlick.contentHeight - 4
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
                    _mainFlick.contentY = Math.min(
                        _mainFlick.contentHeight - _mainFlick.height,
                        _mainFlick.contentY + root._itemH
                    )
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
                _mainFlick.contentY = Math.min(
                    _mainFlick.contentHeight - _mainFlick.height,
                    _mainFlick.contentY + 3
                )
            }
        }
    }

    function _openCascade(items, menuId, index, sourceItem) {
        root._cascadeItems = items
        root._cascadeMenuId = menuId
        root._cascadeTargetIndex = index

        _cascadePopup.x = root.width + 4
        var pt = sourceItem.mapToItem(root.contentItem, 0, 0)
        _cascadePopup.y = pt.y

        if (!_cascadePopup.opened)
            _cascadePopup.open()
    }

    Popup {
        id: _cascadePopup
        padding: 0
        focus: true

        readonly property int _cascW: {
            var w = 200
            for (var i = 0; i < root._cascadeItems.length; i++) {
                var t = (root._cascadeItems[i].text || "")
                var tw = t.length * 7 + 70
                if (tw > w)
                    w = tw
            }
            return Math.min(w, 264)
        }

        readonly property int _cascH: {
            var h = root._pad * 2
            for (var i = 0; i < root._cascadeItems.length; i++) {
                if (root._cascadeItems[i].type === "divider")
                    h += root._divH
                else
                    h += root._itemH
            }
            return h
        }

        width: _cascW
        height: Math.min(_cascH, root.maxHeight)

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
                    from: 0.92
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

        background: Rectangle {
            color: root.colors.surfaceContainerHigh
            radius: root._cornerR
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

        contentItem: Item {
            id: _cascContent
            implicitHeight: _cascadePopup._cascH

            HoverHandler {
                    onHoveredChanged: {
                        if (hovered)
                            _cascadeCloseTimer.stop()
                    }
                id: _cascadeHover
            }


            Flickable {
                id: _cascFlick
                anchors.fill: parent
                anchors.margins: root._pad
                contentHeight: _cascCol.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                Column {
                    id: _cascCol
                    width: parent.width
                    spacing: 0

                    Repeater {
                        model: root._cascadeItems

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
                                radius: root._itemR
                                opacity: _enabled ? 1.0 : 0.38

                                color: {
                                    if (!_enabled)
                                        return "transparent"
                                    if (_cascMouse.containsMouse)
                                        return Qt.alpha(root.colors.onSurface, 0.08)
                                    return "transparent"
                                }

                                Behavior on color {
                                    ColorAnimation { duration: 100 }
                                }

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: root._leadSp
                                    anchors.rightMargin: root._trailSp
                                    spacing: 10

                                    Icon {
                                        visible: _icon !== ""
                                        source: _icon
                                        size: root._iconSz
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
                                    id: _cascMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: _enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                    enabled: _enabled
                                    onClicked: {
                                        root.itemTriggered(root._cascadeMenuId, _id)
                                        root.close()
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // ── Cascade scroll indicator — top ──
            Item {
                id: _cascScrollUp
                readonly property bool _show: _cascFlick.contentHeight > _cascFlick.height + 4
                    && _cascFlick.contentY > 4
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
                        _cascFlick.contentY = Math.max(0, _cascFlick.contentY - root._itemH)
                    }
                    onContainsMouseChanged: {
                        if (containsMouse)
                            _cascScrollUpAuto.start()
                        else
                            _cascScrollUpAuto.stop()
                    }
                }
            }

            Timer {
                id: _cascScrollUpAuto
                interval: 50
                repeat: true
                onTriggered: {
                    _cascFlick.contentY = Math.max(0, _cascFlick.contentY - 3)
                }
            }

            // ── Cascade scroll indicator — bottom ──
            Item {
                id: _cascScrollDown
                readonly property bool _show: _cascFlick.contentHeight > _cascFlick.height + 4
                    && _cascFlick.contentY + _cascFlick.height < _cascFlick.contentHeight - 4
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
                        _cascFlick.contentY = Math.min(
                            _cascFlick.contentHeight - _cascFlick.height,
                            _cascFlick.contentY + root._itemH
                        )
                    }
                    onContainsMouseChanged: {
                        if (containsMouse)
                            _cascScrollDownAuto.start()
                        else
                            _cascScrollDownAuto.stop()
                    }
                }
            }

            Timer {
                id: _cascScrollDownAuto
                interval: 50
                repeat: true
                onTriggered: {
                    _cascFlick.contentY = Math.min(
                        _cascFlick.contentHeight - _cascFlick.height,
                        _cascFlick.contentY + 3
                    )
                }
            }
        }
    }
}
