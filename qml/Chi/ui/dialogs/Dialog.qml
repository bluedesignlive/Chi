// Dialog — Material 3 dialog (basic, fullscreen, assistant)
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

    property string type: "basic"  // "basic", "fullscreen", "assistant"
    property string size: "medium" // "small", "medium", "large"
    property string position: "center"

    property string confirmText: "Save"
    property bool showCloseButton: true
    property bool showHeaderDivider: false
    property bool showActionsDivider: false

    property Component content: null

    default property alias actions: theActionsRow.children

    signal opened()
    signal closed()
    signal accepted()
    signal rejected()

    readonly property var sizeSpecs: ({
        small:  { width: 280, maxHeight: 400 },
        medium: { width: 400, maxHeight: 560 },
        large:  { width: 560, maxHeight: 720 }
    })
    readonly property var cs: sizeSpecs[size] || sizeSpecs.medium

    // Cached type flags
    readonly property bool _fs: type === "fullscreen"
    readonly property bool _assist: type === "assistant"
    readonly property bool _basic: !_fs && !_assist
    readonly property bool hasIcon: icon !== ""
    readonly property bool hasTitle: title !== ""
    readonly property bool hasSupportingText: supportingText !== ""
    readonly property bool hasContent: content !== null
    readonly property bool hasActions: theActionsRow.children.length > 0

    property var colors: Theme.ChiTheme.colors
    readonly property var _typo: Theme.ChiTheme.typography

    // Cached dialog colors
    readonly property color _bgColor: colors.surfaceContainerHigh
    readonly property color _footerColor: colors.surfaceContainerLow
    readonly property color _onSurface: colors.onSurface
    readonly property color _onSurfaceVar: colors.onSurfaceVariant
    readonly property color _primary: colors.primary
    readonly property color _secondary: colors.secondary
    readonly property color _outlineVar: colors.outlineVariant

    width: 0
    height: 0
    visible: false

    property Item appWindow: {
        var p = root.parent
        while (p) {
            if (p.toString().indexOf("Window") !== -1) return p
            if (!p.parent) return p
            p = p.parent
        }
        return null
    }

    Row {
        id: theActionsRow
        spacing: 8
        visible: false
        layoutDirection: Qt.LeftToRight
    }

    // Scrim overlay
    Rectangle {
        id: scrim
        parent: root.appWindow || root.parent
        anchors.fill: parent
        color: colors.scrim
        opacity: root.open ? 0.32 : 0
        visible: root.open
        z: 9998

        Behavior on opacity { NumberAnimation { duration: 200 } }

        MouseArea {
            anchors.fill: parent
            enabled: root.modal && root.closeOnOverlayClick && !root._fs
            onClicked: { root.rejected(); root.close() }
        }
    }

    // ════════════════════ BASIC DIALOG ════════════════════
    Rectangle {
        id: basicDialog
        visible: root.open && root._basic
        parent: root.appWindow || root.parent
        z: 9999

        anchors.centerIn: root.position === "center" ? parent : undefined
        anchors.horizontalCenter: root.position !== "center" ? parent.horizontalCenter : undefined
        anchors.top: root.position === "top" ? parent.top : undefined
        anchors.bottom: root.position === "bottom" ? parent.bottom : undefined
        anchors.topMargin: root.position === "top" ? 56 : 0
        anchors.bottomMargin: root.position === "bottom" ? 56 : 0

        width: Math.min(root.cs.width, (parent ? parent.width : 400) - 48)
        height: Math.min(basicContentCol.implicitHeight, root.cs.maxHeight, (parent ? parent.height : 600) - 96)
        radius: 28
        color: root._bgColor
        clip: true

        Behavior on color { ColorAnimation { duration: 250; easing.type: Easing.OutCubic } }

        layer.enabled: root.open && root._basic
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.25)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 8
            shadowBlur: 0.8
        }

        Column {
            id: basicContentCol
            width: parent.width
            spacing: 0

            // Icon
            Item {
                visible: root.hasIcon
                width: parent.width
                height: 48

                Common.Icon {
                    anchors.centerIn: parent
                    anchors.topMargin: 24
                    source: root.icon
                    size: 24
                    color: root._secondary
                }
            }

            // Title
            Text {
                visible: root.hasTitle
                text: root.title
                font.family: Theme.ChiTheme.fontFamily
                font.pixelSize: _typo.headlineSmall.size
                color: root._onSurface
                wrapMode: Text.WordWrap
                horizontalAlignment: root.hasIcon ? Text.AlignHCenter : Text.AlignLeft
                width: parent.width - 48
                x: 24
                topPadding: root.hasIcon ? 0 : 24
            }

            // Header Divider
            Rectangle {
                visible: root.showHeaderDivider && root.hasTitle
                width: parent.width
                height: 1
                color: root._outlineVar
                y: 16
            }

            Item { width: parent.width; height: root.hasTitle ? 16 : 0 }

            // Supporting Text
            Text {
                visible: root.hasSupportingText
                text: root.supportingText
                font.family: Theme.ChiTheme.fontFamily
                font.pixelSize: _typo.bodyMedium.size
                color: root._onSurfaceVar
                wrapMode: Text.WordWrap
                width: parent.width - 48
                x: 24
                topPadding: root.hasTitle ? 0 : 24
            }

            Item { width: parent.width; height: (root.hasTitle || root.hasSupportingText) ? 16 : 0 }

            // Content Loader
            Item {
                visible: root.hasContent
                width: parent.width - 48
                x: 24
                height: basicContentLoader.item ? Math.min(basicContentLoader.item.implicitHeight, 300) : 0

                Loader {
                    id: basicContentLoader
                    width: parent.width
                    sourceComponent: root.open && root._basic ? root.content : null
                }
            }

            Item { width: parent.width; height: root.hasContent ? 16 : 0 }

            // Actions Divider
            Rectangle {
                visible: root.showActionsDivider && root.hasActions
                width: parent.width
                height: 1
                color: root._outlineVar
            }

            // Actions Area
            Item {
                id: basicActionsArea
                width: parent.width
                height: root.hasActions ? 72 : 24
            }
        }
    }

    // ════════════════════ FULLSCREEN DIALOG ════════════════════
    Rectangle {
        id: fullscreenDialog
        visible: root.open && root._fs
        parent: root.appWindow || root.parent
        anchors.fill: parent
        z: 9999
        color: root._bgColor

        Behavior on color { ColorAnimation { duration: 250; easing.type: Easing.OutCubic } }

        Column {
            anchors.fill: parent
            spacing: 0

            // Header Bar
            Rectangle {
                width: parent.width
                height: 56
                color: root._bgColor
                Behavior on color { ColorAnimation { duration: 250 } }

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 16
                    spacing: 8

                    Rectangle {
                        visible: root.showCloseButton
                        width: 48; height: 48; radius: 24
                        anchors.verticalCenter: parent.verticalCenter
                        color: fsCloseMA.containsMouse ? Qt.alpha(root._onSurface, 0.08) : "transparent"

                        Common.Icon {
                            anchors.centerIn: parent
                            source: "close"
                            size: 24
                            color: root._onSurface
                        }

                        MouseArea {
                            id: fsCloseMA
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: { root.rejected(); root.close() }
                        }
                    }

                    Text {
                        text: root.title
                        font.family: Theme.ChiTheme.fontFamily
                        font.pixelSize: _typo.titleLarge.size
                        color: root._onSurface
                        elide: Text.ElideRight
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 150
                    }

                    Item { width: 1; height: 1; Layout.fillWidth: true }

                    Rectangle {
                        visible: root.confirmText !== ""
                        width: fsConfirmText.implicitWidth + 32
                        height: 40; radius: 20
                        anchors.verticalCenter: parent.verticalCenter
                        color: fsConfirmMA.containsMouse ? Qt.alpha(root._primary, 0.08) : "transparent"

                        Text {
                            id: fsConfirmText
                            anchors.centerIn: parent
                            text: root.confirmText
                            font.family: Theme.ChiTheme.fontFamily
                            font.pixelSize: _typo.labelLarge.size
                            font.weight: Font.Medium
                            color: root._primary
                        }

                        MouseArea {
                            id: fsConfirmMA
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: { root.accepted(); root.close() }
                        }
                    }
                }

                Rectangle {
                    visible: root.showHeaderDivider
                    anchors.bottom: parent.bottom
                    width: parent.width; height: 1
                    color: root._outlineVar
                }
            }

            Flickable {
                width: parent.width
                height: parent.height - 56
                contentHeight: fsContentLoader.item ? fsContentLoader.item.implicitHeight + 48 : parent.height
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                Loader {
                    id: fsContentLoader
                    x: 24; y: 24
                    width: parent.width - 48
                    sourceComponent: root.open && root._fs ? root.content : null
                }
            }
        }
    }

    // ════════════════════ ASSISTANT DIALOG ════════════════════
    Rectangle {
        id: assistantDialog
        visible: root.open && root._assist
        parent: root.appWindow || root.parent
        z: 9999

        anchors.centerIn: parent
        width: Math.min(600, (parent ? parent.width : 700) - 64)
        height: Math.min(500, (parent ? parent.height : 600) - 64)
        radius: 28
        color: root._bgColor
        clip: true

        Behavior on color { ColorAnimation { duration: 250; easing.type: Easing.OutCubic } }

        layer.enabled: root.open && root._assist
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.2)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 12
            shadowBlur: 1.0
        }

        Column {
            anchors.fill: parent
            spacing: 0

            // Header
            Rectangle {
                width: parent.width
                height: 64
                color: "transparent"

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 24
                    anchors.rightMargin: 24
                    spacing: 16

                    Common.Icon {
                        visible: root.hasIcon
                        anchors.verticalCenter: parent.verticalCenter
                        source: root.icon
                        size: 28
                        color: root._primary
                    }

                    Text {
                        text: root.title
                        font.family: Theme.ChiTheme.fontFamily
                        font.pixelSize: _typo.titleMedium.size
                        font.weight: Font.Medium
                        color: root._onSurface
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 100
                    }

                    Item { width: 1; height: 1 }

                    Rectangle {
                        width: 40; height: 40; radius: 20
                        anchors.verticalCenter: parent.verticalCenter
                        color: assistCloseMA.containsMouse ? Qt.alpha(root._onSurface, 0.08) : "transparent"

                        Common.Icon {
                            anchors.centerIn: parent
                            source: "close"
                            size: 24
                            color: root._onSurfaceVar
                        }

                        MouseArea {
                            id: assistCloseMA
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: { root.rejected(); root.close() }
                        }
                    }
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width; height: 1
                    color: root._outlineVar
                }
            }

            // Content Area
            Flickable {
                width: parent.width
                height: parent.height - 64 - 80
                contentHeight: assistContentLoader.item ? assistContentLoader.item.implicitHeight + 48 : height
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                Loader {
                    id: assistContentLoader
                    x: 24; y: 24
                    width: parent.width - 48
                    sourceComponent: root.open && root._assist ? root.content : null
                }
            }

            // Footer Actions Bar
            Item {
                id: assistActionsArea
                width: parent.width
                height: 80

                Rectangle {
                    anchors.fill: parent
                    color: root._footerColor
                    radius: 28

                    Behavior on color { ColorAnimation { duration: 250; easing.type: Easing.OutCubic } }

                    // Cover top rounded corners
                    Rectangle {
                        width: parent.width
                        height: parent.radius
                        color: parent.color
                        anchors.top: parent.top
                    }
                }

                Rectangle {
                    width: parent.width; height: 1
                    color: root._outlineVar
                    anchors.top: parent.top
                }
            }
        }
    }

    // State-based reparenting of actions
    states: [
        State {
            name: "basic"
            when: root.open && root._basic
            ParentChange { target: theActionsRow; parent: basicActionsArea }
            PropertyChanges {
                target: theActionsRow
                visible: true
                anchors.right: basicActionsArea.right
                anchors.bottom: basicActionsArea.bottom
                anchors.rightMargin: 24
                anchors.bottomMargin: 24
            }
        },
        State {
            name: "assistant"
            when: root.open && root._assist
            ParentChange { target: theActionsRow; parent: assistActionsArea }
            PropertyChanges {
                target: theActionsRow
                visible: true
                anchors.right: assistActionsArea.right
                anchors.verticalCenter: assistActionsArea.verticalCenter
                anchors.rightMargin: 24
            }
        },
        State {
            name: "closed"
            when: !root.open
            PropertyChanges { target: theActionsRow; visible: false }
        }
    ]

    onOpenChanged: if (open) opened(); else closed()

    Keys.onEscapePressed: {
        if (open && closeOnEscape) { rejected(); close() }
    }

    function show() { open = true }
    function close() { open = false }
    function accept() { accepted(); close() }
    function reject() { rejected(); close() }
}
