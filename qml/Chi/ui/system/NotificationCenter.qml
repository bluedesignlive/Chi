import QtQuick
import QtQuick.Layouts
import "../theme" as Theme

Item {
    id: root

    property bool open: false
    property var notifications: []
    property int maxVisible: 5

    signal notificationClicked(var notification, int index)
    signal notificationClosed(var notification, int index)
    signal clearAll()

    anchors.fill: parent
    visible: open
    z: 1500

    property var colors: Theme.ChiTheme.colors

    // Backdrop
    Rectangle {
        anchors.fill: parent
        color: colors.scrim
        opacity: open ? 0.32 : 0

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.close()
        }
    }

    // Panel
    Rectangle {
        id: panel
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: Math.min(400, parent.width - 32)
        color: colors.surfaceContainerLow

        x: open ? 0 : width

        Behavior on x {
            NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
        }
        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // Header
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                spacing: 16

                Text {
                    text: "Notifications"
                    font.family: "Roboto"
                    font.pixelSize: 22
                    font.weight: Font.Normal
                    color: colors.onSurface
                    Layout.fillWidth: true

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                Item {
                    visible: notifications.length > 0
                    Layout.preferredWidth: clearLabel.implicitWidth + 16
                    Layout.preferredHeight: 32

                    Rectangle {
                        anchors.fill: parent
                        radius: 16
                        color: colors.primary
                        opacity: clearMouse.containsMouse ? 0.12 : 0
                    }

                    Text {
                        id: clearLabel
                        anchors.centerIn: parent
                        text: "Clear all"
                        font.family: "Roboto"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        color: colors.primary
                    }

                    MouseArea {
                        id: clearMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            notifications = []
                            clearAll()
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: colors.outlineVariant
            }

            // Notifications list
            Flickable {
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentHeight: notificationsColumn.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                Column {
                    id: notificationsColumn
                    width: parent.width
                    padding: 16
                    spacing: 12

                    Repeater {
                        model: notifications

                        Notification {
                            width: parent.width - 32
                            title: modelData.title || ""
                            message: modelData.message || ""
                            icon: modelData.icon || ""
                            urgency: modelData.urgency || "normal"
                            actionText: modelData.actionText || ""
                            timeout: 0

                            onClicked: notificationClicked(modelData, index)

                            onClosed: {
                                var notifs = notifications.slice()
                                notifs.splice(index, 1)
                                notifications = notifs
                                notificationClosed(modelData, index)
                            }
                        }
                    }
                }
            }

            // Empty state
            Item {
                visible: notifications.length === 0
                Layout.fillWidth: true
                Layout.fillHeight: true

                Column {
                    anchors.centerIn: parent
                    spacing: 16

                    Text {
                        text: "🔔"
                        font.pixelSize: 48
                        anchors.horizontalCenter: parent.horizontalCenter
                        opacity: 0.5
                    }

                    Text {
                        text: "No notifications"
                        font.family: "Roboto"
                        font.pixelSize: 16
                        color: colors.onSurfaceVariant
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }
    }

    function show() {
        open = true
    }

    function close() {
        open = false
    }

    function toggle() {
        open = !open
    }

    function addNotification(notification) {
        var notifs = notifications.slice()
        notifs.unshift(notification)
        notifications = notifs
    }

    Accessible.role: Accessible.Pane
    Accessible.name: "Notification center"
}
