import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../../theme" as Theme

Item {
    id: root

    property bool open: false
    property string variant: "standard"
    property string position: "right"
    property string title: ""
    property bool showClose: true
    property bool showDivider: true
    property bool showActions: false
    property real sheetWidth: 320
    property real maxWidth: 400

    default property alias content: contentContainer.data
    property alias actions: actionsContainer.data

    signal closed()
    signal primaryAction()
    signal secondaryAction()

    anchors.fill: parent
    visible: open || closeAnimation.running
    z: _modal ? 1000 : 0

    property var colors: Theme.ChiTheme.colors
    readonly property string fontFamily: Theme.ChiTheme.fontFamily

    readonly property bool _modal: variant === "modal"
    readonly property bool _left: position === "left"

    Rectangle {
        id: scrim
        visible: root._modal
        anchors.fill: parent
        color: colors.scrim
        opacity: root.open ? 0.32 : 0
        radius: 28

        Behavior on opacity {
            NumberAnimation {
                id: closeAnimation
                duration: 250
                easing.type: Easing.OutCubic
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: root._modal && root.open
            onClicked: root.close()
        }
    }

    Rectangle {
        id: sheet
        width: Math.min(root.sheetWidth, root.maxWidth)
        height: parent.height
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        x: root._left ? (root.open ? 0 : -width) :
                         (root.open ? parent.width - width : parent.width)
        color: colors.surface

        Behavior on x {
            NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
        }
        Behavior on color { ColorAnimation { duration: 200 } }

        Rectangle {
            visible: root.showDivider
            width: 1
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            x: root._left ? parent.width - 1 : 0
            color: colors.outlineVariant
            Behavior on color { ColorAnimation { duration: 200 } }
        }

        layer.enabled: root._modal && root.open
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.15)
            shadowHorizontalOffset: root._left ? 4 : -4
            shadowVerticalOffset: 0
            shadowBlur: 0.6
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 76

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 24
                    anchors.rightMargin: 12
                    anchors.topMargin: 12
                    anchors.bottomMargin: 16
                    spacing: 0

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: 6
                            text: root.title
                            font.family: fontFamily
                            font.pixelSize: 22
                            font.weight: Font.Normal
                            color: colors.onSurfaceVariant
                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                    }

                    Item {
                        visible: root.showClose
                        Layout.preferredWidth: 48
                        Layout.preferredHeight: 48

                        Rectangle {
                            anchors.centerIn: parent
                            width: 40
                            height: 40
                            radius: 20
                            color: colors.onSurfaceVariant
                            opacity: closeMouse.containsMouse ? 0.08 : 0
                            Behavior on opacity { NumberAnimation { duration: 100 } }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "✕"
                            font.pixelSize: 24
                            color: colors.onSurfaceVariant
                            Behavior on color { ColorAnimation { duration: 200 } }
                        }

                        MouseArea {
                            id: closeMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.close()
                        }
                    }
                }
            }

            Item {
                id: contentContainer
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
            }

            Item {
                visible: root.showActions && actionsContainer.children.length > 0
                Layout.fillWidth: true
                Layout.preferredHeight: 61

                Rectangle {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 1
                    color: colors.outlineVariant
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                RowLayout {
                    id: actionsContainer
                    anchors.fill: parent
                    anchors.leftMargin: 24
                    anchors.rightMargin: 24
                    anchors.topMargin: 12
                    spacing: 8
                }
            }
        }
    }

    Keys.onEscapePressed: if (open) close()

    function show() { open = true }
    function close() { open = false; closed() }
    function toggle() { if (open) close(); else show() }

    Accessible.role: Accessible.Pane
    Accessible.name: title || "Side sheet"
}
