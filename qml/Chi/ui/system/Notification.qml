import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
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
    readonly property bool _isCritical: urgency === "critical"
    readonly property bool _isLow: urgency === "low"

    // Urgency-based colors cached once
    readonly property color _urgencyBg: _isCritical ? colors.errorContainer :
                                        (_isLow ? colors.surfaceContainerHighest : colors.primaryContainer)
    readonly property color _urgencyFg: _isCritical ? colors.onErrorContainer :
                                        (_isLow ? colors.onSurfaceVariant : colors.onPrimaryContainer)
    readonly property color _urgencyStrip: _isCritical ? colors.error :
                                           (_isLow ? colors.outline : colors.primary)

    implicitWidth: 360
    implicitHeight: contentColumn.implicitHeight + 24

    property var colors: Theme.ChiTheme.colors
    readonly property var _typo: Theme.ChiTheme.typography

    Rectangle {
        id: container
        anchors.fill: parent
        radius: 12
        color: colors.surfaceContainerHigh
        clip: true

        Behavior on color { ColorAnimation { duration: 200 } }

        layer.enabled: root.visible
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.2)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 4
            shadowBlur: 0.6
        }

        // Urgency indicator strip
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 4
            radius: 2
            color: root._urgencyStrip
            Behavior on color { ColorAnimation { duration: 200 } }
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
                    visible: root.hasIcon
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    radius: 20
                    color: root._urgencyBg

                    Text {
                        anchors.centerIn: parent
                        text: root.icon
                        font.pixelSize: 20
                        color: root._urgencyFg
                    }
                }

                // Text content
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        text: root.title
                        font.family: Theme.ChiTheme.fontFamily
                        font.pixelSize: _typo.bodyMedium.size
                        font.weight: Font.Medium
                        color: colors.onSurface
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }

                    Text {
                        visible: root.message !== ""
                        text: root.message
                        font.family: Theme.ChiTheme.fontFamily
                        font.pixelSize: _typo.bodyMedium.size
                        color: colors.onSurfaceVariant
                        wrapMode: Text.WordWrap
                        maximumLineCount: 3
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }
                }

                // Close button
                Item {
                    visible: root.hasDismiss
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
                        onClicked: dismissAnimation.start()
                    }
                }
            }

            // Progress bar
            Rectangle {
                visible: root.showProgress
                Layout.fillWidth: true
                Layout.preferredHeight: 4
                radius: 2
                color: colors.surfaceContainerHighest

                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width * root.progress
                    radius: 2
                    color: colors.primary
                    Behavior on width { NumberAnimation { duration: 100 } }
                }
            }

            // Action button
            Item {
                visible: root.hasAction
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
                    text: root.actionText
                    font.family: Theme.ChiTheme.fontFamily
                    font.pixelSize: _typo.labelLarge.size
                    font.weight: Font.Medium
                    color: colors.primary
                }

                MouseArea {
                    id: actionMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.actionClicked()
                }
            }
        }

        // Background click area
        MouseArea {
            anchors.fill: parent
            z: -1
            onClicked: root.clicked()
        }
    }

    // Auto-dismiss timer
    Timer {
        id: dismissTimer
        interval: root.timeout
        running: root.timeout > 0 && root.visible
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
                root.closed()
            }
        }
    }

    Accessible.role: Accessible.AlertMessage
    Accessible.name: title
    Accessible.description: message
}
