import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Item {
    id: root

    property string title: ""
    property string supportingText: ""
    property string icon: ""
    property bool open: false
    property bool modal: true
    property bool closeOnOverlayClick: true
    property string size: "medium"           // "small", "medium", "large", "fullscreen"

    default property alias content: contentContainer.data
    property alias actions: actionsContainer.data

    signal opened()
    signal closed()
    signal accepted()
    signal rejected()

    readonly property var sizeSpecs: ({
        small: { width: 280, maxHeight: 400 },
        medium: { width: 400, maxHeight: 560 },
        large: { width: 560, maxHeight: 720 },
        fullscreen: { width: -1, maxHeight: -1 }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.medium
    readonly property bool hasIcon: icon !== ""
    readonly property bool hasTitle: title !== ""
    readonly property bool hasSupportingText: supportingText !== ""
    readonly property bool hasContent: contentContainer.children.length > 0
    readonly property bool hasActions: actionsContainer.children.length > 0

    anchors.fill: parent
    visible: open || fadeAnimation.running
    z: 1000

    property var colors: Theme.ChiTheme.colors

    // Scrim/Overlay
    Rectangle {
        id: scrim
        anchors.fill: parent
        color: colors.scrim
        opacity: open ? 0.32 : 0

        Behavior on opacity {
            NumberAnimation {
                id: fadeAnimation
                duration: 250
                easing.type: Easing.OutCubic
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: modal && closeOnOverlayClick
            onClicked: {
                root.rejected()
                root.close()
            }
        }
    }

    // Dialog container
    Rectangle {
        id: dialogContainer
        anchors.centerIn: parent
        width: size === "fullscreen" ? parent.width - 32 : Math.min(currentSize.width, parent.width - 48)
        height: Math.min(dialogContent.implicitHeight, size === "fullscreen" ? parent.height - 32 : currentSize.maxHeight)
        radius: size === "fullscreen" ? 28 : 28
        color: colors.surfaceContainerHigh
        clip: true

        scale: open ? 1 : 0.9
        opacity: open ? 1 : 0

        Behavior on scale {
            NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
        }
        Behavior on opacity {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }
        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 8
            radius: 24
            samples: 25
            color: Qt.rgba(0, 0, 0, 0.25)
        }

        ColumnLayout {
            id: dialogContent
            anchors.fill: parent
            spacing: 0

            // Header (Icon + Title)
            ColumnLayout {
                visible: hasIcon || hasTitle
                Layout.fillWidth: true
                Layout.topMargin: 24
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                spacing: 16

                // Icon
                Text {
                    visible: hasIcon
                    text: icon
                    font.family: "Material Icons"
                    font.pixelSize: 24
                    color: colors.secondary
                    Layout.alignment: Qt.AlignHCenter

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                // Title
                Text {
                    visible: hasTitle
                    text: title
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Normal
                    color: colors.onSurface
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    horizontalAlignment: hasIcon ? Text.AlignHCenter : Text.AlignLeft

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }
            }

            // Supporting text
            Text {
                visible: hasSupportingText
                text: supportingText
                font.family: "Roboto"
                font.pixelSize: 14
                font.weight: Font.Normal
                color: colors.onSurfaceVariant
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                Layout.topMargin: hasTitle ? 16 : 24
                Layout.leftMargin: 24
                Layout.rightMargin: 24

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }
            }

            // Custom content
            Item {
                id: contentContainer
                visible: hasContent
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.topMargin: (hasTitle || hasSupportingText) ? 16 : 24
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.minimumHeight: hasContent ? 48 : 0
                implicitHeight: childrenRect.height
            }

            // Actions
            RowLayout {
                id: actionsContainer
                visible: hasActions
                Layout.fillWidth: true
                Layout.topMargin: 24
                Layout.bottomMargin: 24
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.alignment: Qt.AlignRight
                spacing: 8
            }

            // Bottom spacing if no actions
            Item {
                visible: !hasActions
                Layout.fillWidth: true
                height: 24
            }
        }
    }

    // Keyboard handling
    Keys.onEscapePressed: {
        rejected()
        close()
    }

    function show() {
        open = true
        opened()
    }

    function close() {
        open = false
        closed()
    }

    function accept() {
        accepted()
        close()
    }

    function reject() {
        rejected()
        close()
    }

    Accessible.role: Accessible.Dialog
    Accessible.name: title
    Accessible.description: supportingText
}
