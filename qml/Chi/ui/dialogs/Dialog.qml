// Dialog — Material 3 Expressive Dialogs
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../common" as Common
import "../../theme" as Theme

Item {
    id: root

    property string title: ""
    property string supportingText: ""
    property string icon: ""

    property bool open: false
    property bool modal: true
    property bool closeOnOverlayClick: true
    property bool closeOnEscape: true

    property string type: "basic"
    property string size: "medium"
    property string position: "center"

    property string confirmText: "Save"
    property bool showCloseButton: true
    property bool showHeaderDivider: false
    property bool showActionsDivider: false

    property Component content: null

    default property alias actions: theActionsRow.children

    signal opened
    signal closed
    signal accepted
    signal rejected

    // ── match whatever corner radius ChiApplicationWindow uses ──
    readonly property real _autoRadius: { var w = root.appWindow; return (w && w.windowRadius !== undefined) ? w.windowRadius : 0 }

    readonly property var sizeSpecs: ({ small: { width: 280, maxHeight: 400 }, medium: { width: 400, maxHeight: 560 }, large: { width: 560, maxHeight: 720 } })
    readonly property var cs: sizeSpecs[size] || sizeSpecs.medium

    readonly property bool _fs:     type === "fullscreen"
    readonly property bool _assist: type === "assistant"
    readonly property bool _basic:  !_fs && !_assist
    readonly property bool hasIcon:           icon !== ""
    readonly property bool hasTitle:          title !== ""
    readonly property bool hasSupportingText: supportingText !== ""
    readonly property bool hasContent:        content !== null
    readonly property bool hasActions:        theActionsRow.children.length > 0

    property var colors: Theme.ChiTheme.colors
    readonly property var _typo: Theme.ChiTheme.typography

    readonly property color _bgColor:      colors.surfaceContainerHigh
    readonly property color _footerColor:  colors.surfaceContainerLow
    readonly property color _onSurface:    colors.onSurface
    readonly property color _onSurfaceVar: colors.onSurfaceVariant
    readonly property color _primary:      colors.primary
    readonly property color _secondary:    colors.secondary
    readonly property color _outlineVar:   colors.outlineVariant

    width: 0; height: 0; visible: false

    property Item appWindow: {
        var p = root.parent
        while (p) {
            if (p.toString().indexOf("Window") !== -1) return p
            if (!p.parent) return p
            p = p.parent
        }
        return null
    }

    readonly property Item _overlayTarget: {
        var w = root.appWindow
        return (w && w.dialogLayer) ? w.dialogLayer : (w || root.parent)
    }

    Row {
        id: theActionsRow
        spacing: 8
        visible: false
        layoutDirection: Qt.LeftToRight
    }

    // ════════════════════ SCRIM ════════════════════
    Rectangle {
        id: scrim
        parent: root._overlayTarget
        anchors.fill: parent
        color: colors.scrim
        z: 9998
        opacity: 0.0
        visible: opacity > 0

        states: [
            State { name: "open";   when: root.open;  PropertyChanges { target: scrim; opacity: 0.38 } },
            State { name: "closed"; when: !root.open; PropertyChanges { target: scrim; opacity: 0.0  } }
        ]
        transitions: [
            Transition {
                from: "closed"; to: "open"
                NumberAnimation { property: "opacity"; duration: 300; easing.type: Easing.OutCubic }
            },
            Transition {
                from: "open"; to: "closed"
                NumberAnimation { property: "opacity"; duration: 220; easing.type: Easing.InCubic }
            }
        ]

        MouseArea {
            anchors.fill: parent
            enabled: root.modal && root.closeOnOverlayClick && !root._fs
            onClicked: { root.rejected(); root.close() }
        }
    }

    // ════════════════════ BASIC DIALOG ════════════════════
    Rectangle {
        id: basicDialog
        parent: root._overlayTarget
        z: 9999

        anchors.centerIn:         root.position === "center" ? parent : undefined
        anchors.horizontalCenter: root.position !== "center" ? parent.horizontalCenter : undefined
        anchors.top:              root.position === "top"    ? parent.top    : undefined
        anchors.bottom:           root.position === "bottom" ? parent.bottom : undefined
        anchors.topMargin:    root.position === "top"    ? 56 : 0
        anchors.bottomMargin: root.position === "bottom" ? 56 : 0

        width:  Math.min(root.cs.width, (parent ? parent.width : 400) - 48)
        height: Math.min(basicContentCol.implicitHeight, root.cs.maxHeight, (parent ? parent.height : 600) - 96)
        radius: 28
        color:  root._bgColor
        clip:   true
        transformOrigin: Item.Center

        property real slideY: 24

        opacity: 0.0
        scale:   0.88
        visible: opacity > 0

        transform: Translate { y: basicDialog.slideY }

        states: [
            State {
                name: "open"
                when: root.open && root._basic
                PropertyChanges { target: basicDialog; opacity: 1.0; scale: 1.0; slideY: 0 }
            },
            State {
                name: "closed"
                when: !root.open || !root._basic
                PropertyChanges { target: basicDialog; opacity: 0.0; scale: 0.88; slideY: 24 }
            }
        ]
        transitions: [
            Transition {
                from: "closed"; to: "open"
                // stagger: scale leads, opacity follows — feels alive
                NumberAnimation { property: "opacity"; duration: 280; easing.type: Easing.OutCubic }
                NumberAnimation { property: "scale";   duration: 420; easing.type: Easing.OutBack; easing.overshoot: 0.6 }
                NumberAnimation { property: "slideY";  duration: 380; easing.type: Easing.OutCubic }
            },
            Transition {
                from: "open"; to: "closed"
                NumberAnimation { property: "opacity"; duration: 180; easing.type: Easing.InCubic }
                NumberAnimation { property: "scale";   duration: 220; easing.type: Easing.InQuart }
                NumberAnimation { property: "slideY";  duration: 220; easing.type: Easing.InCubic }
            }
        ]

        Behavior on color { ColorAnimation { duration: 250; easing.type: Easing.OutCubic } }

        layer.enabled: opacity > 0 && root._basic
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.28)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 10
            shadowBlur: 0.9
        }

        Column {
            id: basicContentCol
            width: parent.width; spacing: 0
            Item { visible: root.hasIcon; width: parent.width; height: 48
                Common.Icon { anchors.centerIn: parent; source: root.icon; size: 24; color: root._secondary }
            }
            Text {
                visible: root.hasTitle; text: root.title
                font.family: Theme.ChiTheme.fontFamily; font.pixelSize: _typo.headlineSmall.size
                color: root._onSurface; wrapMode: Text.WordWrap
                horizontalAlignment: root.hasIcon ? Text.AlignHCenter : Text.AlignLeft
                width: parent.width - 48; x: 24; topPadding: root.hasIcon ? 0 : 24
            }
            Rectangle { visible: root.showHeaderDivider && root.hasTitle; width: parent.width; height: 1; color: root._outlineVar; y: 16 }
            Item { width: parent.width; height: root.hasTitle ? 16 : 0 }
            Text {
                visible: root.hasSupportingText; text: root.supportingText
                font.family: Theme.ChiTheme.fontFamily; font.pixelSize: _typo.bodyMedium.size
                color: root._onSurfaceVar; wrapMode: Text.WordWrap
                width: parent.width - 48; x: 24; topPadding: root.hasTitle ? 0 : 24
            }
            Item { width: parent.width; height: (root.hasTitle || root.hasSupportingText) ? 16 : 0 }
            Item {
                visible: root.hasContent; width: parent.width - 48; x: 24
                height: basicContentLoader.item ? Math.min(basicContentLoader.item.implicitHeight, 300) : 0
                Loader { id: basicContentLoader; width: parent.width; sourceComponent: root._basic ? root.content : null }
            }
            Item { width: parent.width; height: root.hasContent ? 16 : 0 }
            Rectangle { visible: root.showActionsDivider && root.hasActions; width: parent.width; height: 1; color: root._outlineVar }
            Item { id: basicActionsArea; width: parent.width; height: root.hasActions ? 72 : 24 }
        }
    }

    // ════════════════════ FULLSCREEN DIALOG ════════════════════
    // Slides up from below like a sheet — rounded corners always
    // match the host window so the frameless chrome is never broken
    Rectangle {
        id: fullscreenDialog
        parent: root._overlayTarget
        z: 9999

        // fill the window but keep the host window's corner radius intact
        anchors.fill:        parent
        radius:              root._autoRadius
        clip:                true
        color:               root._bgColor

        // slide-up: starts fully below the window, lands flush
        property real slideY: (parent ? parent.height : 800)

        transform: Translate { y: fullscreenDialog.slideY }

        opacity: 0.0
        visible: opacity > 0

        states: [
            State {
                name: "open"
                when: root.open && root._fs
                PropertyChanges { target: fullscreenDialog; opacity: 1.0; slideY: 0 }
            },
            State {
                name: "closed"
                when: !root.open || !root._fs
                PropertyChanges {
                    target: fullscreenDialog
                    opacity: 0.0
                    slideY: parent ? parent.height : 800
                }
            }
        ]
        transitions: [
            Transition {
                from: "closed"; to: "open"
                // Opacity races ahead so you see the surface immediately,
                // then OutExpo carries it smoothly to rest
                NumberAnimation { property: "opacity"; duration: 240; easing.type: Easing.OutCubic }
                NumberAnimation { property: "slideY";  duration: 480; easing.type: Easing.OutExpo  }
            },
            Transition {
                from: "open"; to: "closed"
                // Accelerate hard downward — feels decisive, not sluggish
                NumberAnimation { property: "opacity"; duration: 200; easing.type: Easing.InCubic  }
                NumberAnimation { property: "slideY";  duration: 340; easing.type: Easing.InExpo   }
            }
        ]

        Behavior on color { ColorAnimation { duration: 250; easing.type: Easing.OutCubic } }

        Column {
            anchors.fill: parent; spacing: 0

            Rectangle {
                width: parent.width; height: 56; color: root._bgColor
                Row {
                    anchors.fill: parent; anchors.leftMargin: 8; anchors.rightMargin: 16; spacing: 8
                    Rectangle {
                        visible: root.showCloseButton; width: 48; height: 48; radius: 24
                        anchors.verticalCenter: parent.verticalCenter
                        color: fsCloseMA.containsMouse ? Qt.alpha(root._onSurface, 0.08) : "transparent"
                        Common.Icon { anchors.centerIn: parent; source: "close"; size: 24; color: root._onSurface }
                        MouseArea { id: fsCloseMA; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: { root.rejected(); root.close() } }
                    }
                    Text {
                        text: root.title
                        font.family: Theme.ChiTheme.fontFamily; font.pixelSize: _typo.titleLarge.size
                        color: root._onSurface; elide: Text.ElideRight
                        anchors.verticalCenter: parent.verticalCenter; width: parent.width - 150
                    }
                    Item { width: 1; height: 1; Layout.fillWidth: true }
                    Rectangle {
                        visible: root.confirmText !== ""
                        width: fsConfirmText.implicitWidth + 32; height: 40; radius: 20
                        anchors.verticalCenter: parent.verticalCenter
                        color: fsConfirmMA.containsMouse ? Qt.alpha(root._primary, 0.08) : "transparent"
                        Text { id: fsConfirmText; anchors.centerIn: parent; text: root.confirmText; font.family: Theme.ChiTheme.fontFamily; font.pixelSize: _typo.labelLarge.size; font.weight: Font.Medium; color: root._primary }
                        MouseArea { id: fsConfirmMA; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: { root.accepted(); root.close() } }
                    }
                }
                Rectangle { visible: root.showHeaderDivider; anchors.bottom: parent.bottom; width: parent.width; height: 1; color: root._outlineVar }
            }

            Flickable {
                width: parent.width; height: parent.height - 56
                contentHeight: fsContentLoader.item ? fsContentLoader.item.implicitHeight + 48 : parent.height
                clip: true; boundsBehavior: Flickable.StopAtBounds
                Loader { id: fsContentLoader; x: 24; y: 24; width: parent.width - 48; sourceComponent: root._fs ? root.content : null }
            }
        }
    }

    // ════════════════════ ASSISTANT DIALOG ════════════════════
    Rectangle {
        id: assistantDialog
        parent: root._overlayTarget
        z: 9999
        anchors.centerIn: parent
        width:  Math.min(600, (parent ? parent.width  : 700) - 64)
        height: Math.min(500, (parent ? parent.height : 600) - 64)
        radius: 28
        color:  root._bgColor
        clip:   true
        transformOrigin: Item.Center

        property real slideY: 32

        opacity: 0.0
        scale:   0.92
        visible: opacity > 0

        transform: Translate { y: assistantDialog.slideY }

        states: [
            State {
                name: "open"
                when: root.open && root._assist
                PropertyChanges { target: assistantDialog; opacity: 1.0; scale: 1.0; slideY: 0 }
            },
            State {
                name: "closed"
                when: !root.open || !root._assist
                PropertyChanges { target: assistantDialog; opacity: 0.0; scale: 0.92; slideY: 32 }
            }
        ]
        transitions: [
            Transition {
                from: "closed"; to: "open"
                NumberAnimation { property: "opacity"; duration: 260; easing.type: Easing.OutCubic }
                NumberAnimation { property: "scale";   duration: 440; easing.type: Easing.OutBack; easing.overshoot: 0.5 }
                NumberAnimation { property: "slideY";  duration: 400; easing.type: Easing.OutCubic }
            },
            Transition {
                from: "open"; to: "closed"
                NumberAnimation { property: "opacity"; duration: 180; easing.type: Easing.InCubic }
                NumberAnimation { property: "scale";   duration: 220; easing.type: Easing.InQuart }
                NumberAnimation { property: "slideY";  duration: 220; easing.type: Easing.InCubic }
            }
        ]

        Behavior on color { ColorAnimation { duration: 250; easing.type: Easing.OutCubic } }

        layer.enabled: opacity > 0 && root._assist
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.22)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 14
            shadowBlur: 1.0
        }

        Column {
            anchors.fill: parent; spacing: 0
            Rectangle {
                width: parent.width; height: 64; color: "transparent"
                Row {
                    anchors.fill: parent; anchors.leftMargin: 24; anchors.rightMargin: 24; spacing: 16
                    Common.Icon { visible: root.hasIcon; anchors.verticalCenter: parent.verticalCenter; source: root.icon; size: 28; color: root._primary }
                    Text { text: root.title; font.family: Theme.ChiTheme.fontFamily; font.pixelSize: _typo.titleMedium.size; font.weight: Font.Medium; color: root._onSurface; anchors.verticalCenter: parent.verticalCenter; width: parent.width - 100 }
                    Item { width: 1; height: 1 }
                    Rectangle {
                        width: 40; height: 40; radius: 20; anchors.verticalCenter: parent.verticalCenter
                        color: assistCloseMA.containsMouse ? Qt.alpha(root._onSurface, 0.08) : "transparent"
                        Common.Icon { anchors.centerIn: parent; source: "close"; size: 24; color: root._onSurfaceVar }
                        MouseArea { id: assistCloseMA; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: { root.rejected(); root.close() } }
                    }
                }
                Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: root._outlineVar }
            }
            Flickable {
                width: parent.width; height: parent.height - 64 - 80
                contentHeight: assistContentLoader.item ? assistContentLoader.item.implicitHeight + 48 : height
                clip: true; boundsBehavior: Flickable.StopAtBounds
                Loader { id: assistContentLoader; x: 24; y: 24; width: parent.width - 48; sourceComponent: root._assist ? root.content : null }
            }
            Item {
                id: assistActionsArea; width: parent.width; height: 80
                Rectangle {
                    anchors.fill: parent; color: root._footerColor; radius: 28
                    Behavior on color { ColorAnimation { duration: 250; easing.type: Easing.OutCubic } }
                    Rectangle { width: parent.width; height: parent.radius; color: parent.color; anchors.top: parent.top }
                }
                Rectangle { width: parent.width; height: 1; color: root._outlineVar; anchors.top: parent.top }
            }
        }
    }

    // ════════════════════ ACTIONS REPARENTING ════════════════════
    states: [
        State {
            name: "basic"
            when: root._basic
            ParentChange { target: theActionsRow; parent: basicActionsArea }
            PropertyChanges { target: theActionsRow; visible: true; anchors.right: basicActionsArea.right; anchors.bottom: basicActionsArea.bottom; anchors.rightMargin: 24; anchors.bottomMargin: 24 }
        },
        State {
            name: "assistant"
            when: root._assist
            ParentChange { target: theActionsRow; parent: assistActionsArea }
            PropertyChanges { target: theActionsRow; visible: true; anchors.right: assistActionsArea.right; anchors.verticalCenter: assistActionsArea.verticalCenter; anchors.rightMargin: 24 }
        }
    ]

    onOpenChanged: if (open) opened(); else closed()
    Keys.onEscapePressed: { if (open && closeOnEscape) { rejected(); close() } }
    function show()   { open = true  }
    function close()  { open = false }
    function accept() { accepted(); close() }
    function reject() { rejected(); close() }
}
