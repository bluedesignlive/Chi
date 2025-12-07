import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Item {
    id: root

    property string title: ""
    property string message: ""
    property string icon: ""
    property string urgency: "normal"        // "low", "normal", "critical"
    property string actionText: ""
    property int timeout: 5000               // 0 = persistent
    property bool showProgress: false
    property real progress: 0

    signal clicked()
    signal actionClicked()
    signal closed()

    readonly property bool hasDismiss: timeout > 0 || urgency !== "critical"
    readonly property bool hasAction: actionText !== ""
    readonly property bool hasIcon: icon !== ""

    implicitWidth: 360
    implicitHeight: contentColumn.implicitHeight + 24

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        id: container
        anchors.fill: parent
        radius: 12
        color: colors.surfaceContainerHigh
        clip: true

        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 4
            radius: 16
            samples: 17
            color: Qt.rgba(0, 0, 0, 0.2)
        }

        // Urgency indicator
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 4
            radius: 2
            color: {
                switch (urgency) {
                case "critical": return colors.error
                case "low": return colors.outline
                default: return colors.primary
                }
            }

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }

        ColumnLayout {
            id: contentColumn
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 12
            anchors.topMargin: 12
            anchors.bottomMargin: 12
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                // Icon
                Rectangle {
                    visible: hasIcon
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    radius: 20
                    color: {
                        switch (urgency) {
                        case "critical": return colors.errorContainer
                        case "low": return colors.surfaceContainerHighest
                        default: return colors.primaryContainer
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: icon
                        font.pixelSize: 20
                        color: {
                            switch (urgency) {
                            case "critical": return colors.onErrorContainer
                            case "low": return colors.onSurfaceVariant
                            default: return colors.onPrimaryContainer
                            }
                        }
                    }
                }

                // Text content
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        text: title
                        font.family: "Roboto"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        color: colors.onSurface
                        elide: Text.ElideRight
                        Layout.fillWidth: true

                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }

                    Text {
                        visible: message !== ""
                        text: message
                        font.family: "Roboto"
                        font.pixelSize: 14
                        color: colors.onSurfaceVariant
                        wrapMode: Text.WordWrap
                        maximumLineCount: 3
                        elide: Text.ElideRight
                        Layout.fillWidth: true

                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }
                }

                // Close button
                Item {
                    visible: hasDismiss
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                    Layout.alignment: Qt.AlignTop

                    Rectangle {
                        anchors.fill: parent
                        radius: 16
                        color: colors.onSurface
                        opacity: closeMouse.containsMouse ? 0.08 : 0
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        font.pixelSize: 16
                        color: colors.onSurfaceVariant
                    }

                    MouseArea {
                        id: closeMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            dismissAnimation.start()
                        }
                    }
                }
            }

            // Progress bar
            Rectangle {
                visible: showProgress
                Layout.fillWidth: true
                Layout.preferredHeight: 4
                radius: 2
                color: colors.surfaceContainerHighest

                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width * progress
                    radius: 2
                    color: colors.primary

                    Behavior on width {
                        NumberAnimation { duration: 100 }
                    }
                }
            }

            // Action button
            Item {
                visible: hasAction
                Layout.preferredWidth: actionLabel.implicitWidth + 24
                Layout.preferredHeight: 36
                Layout.alignment: Qt.AlignRight

                Rectangle {
                    anchors.fill: parent
                    radius: 18
                    color: colors.primary
                    opacity: actionMouse.containsMouse ? 0.12 : 0
                }

                Text {
                    id: actionLabel
                    anchors.centerIn: parent
                    text: actionText
                    font.family: "Roboto"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    color: colors.primary
                }

                MouseArea {
                    id: actionMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: actionClicked()
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            z: -1
            onClicked: root.clicked()
        }
    }

    // Auto-dismiss timer
    Timer {
        id: dismissTimer
        interval: timeout
        running: timeout > 0 && root.visible
        onTriggered: dismissAnimation.start()
    }

    // Dismiss animation
    SequentialAnimation {
        id: dismissAnimation

        NumberAnimation {
            target: root
            property: "opacity"
            to: 0
            duration: 200
            easing.type: Easing.OutCubic
        }

        ScriptAction {
            script: {
                root.visible = false
                root.opacity = 1
                closed()
            }
        }
    }

    Accessible.role: Accessible.AlertMessage
    Accessible.name: title
    Accessible.description: message
}
