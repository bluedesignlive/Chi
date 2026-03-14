import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../../theme" as Theme

Item {
    id: root

    property string text: ""
    property string actionText: ""
    property bool showClose: false
    property int duration: 4000              // 0 = infinite
    property string position: "bottom"       // "bottom", "top"
    property bool multiLine: false
    property bool longerAction: false        // Action on separate line

    signal actionClicked()
    signal closed()

    readonly property bool hasAction: actionText !== ""
    readonly property bool isShowing: state === "visible"
    readonly property bool _single: !multiLine && !longerAction
    readonly property int snackbarHeight: longerAction ? 112 : (multiLine ? 68 : 48)
    readonly property real _rightMargin: showClose ? 0 : (hasAction ? 8 : 16)

    anchors.left: parent ? parent.left : undefined
    anchors.right: parent ? parent.right : undefined
    anchors.bottom: position === "bottom" && parent ? parent.bottom : undefined
    anchors.top: position === "top" && parent ? parent.top : undefined
    anchors.margins: 16

    height: snackbarHeight
    z: 999
    state: "hidden"

    states: [
        State {
            name: "hidden"
            PropertyChanges { target: snackbarContainer; opacity: 0; y: position === "bottom" ? 20 : -20 }
        },
        State {
            name: "visible"
            PropertyChanges { target: snackbarContainer; opacity: 1; y: 0 }
        }
    ]

    transitions: [
        Transition {
            from: "hidden"; to: "visible"
            NumberAnimation { properties: "opacity,y"; duration: 250; easing.type: Easing.OutCubic }
        },
        Transition {
            from: "visible"; to: "hidden"
            NumberAnimation { properties: "opacity,y"; duration: 200; easing.type: Easing.InCubic }
        }
    ]

    property var colors: Theme.ChiTheme.colors
    readonly property var _typo: Theme.ChiTheme.typography

    // ─── Reusable inline components ───
    // Action button used in all 3 layouts
    component SnackAction: Item {
        visible: root.hasAction
        Layout.preferredWidth: _actionText.implicitWidth + 24
        Layout.preferredHeight: 40

        Rectangle {
            anchors.fill: parent
            radius: 100
            color: colors.inversePrimary
            opacity: _actionMa.pressed ? 0.1 : (_actionMa.containsMouse ? 0.08 : 0)
            Behavior on opacity { NumberAnimation { duration: 100 } }
        }

        Text {
            id: _actionText
            anchors.centerIn: parent
            text: root.actionText
            font.family: Theme.ChiTheme.fontFamily
            font.pixelSize: root._typo.labelLarge.size
            font.weight: Font.Medium
            font.letterSpacing: root._typo.labelLarge.spacing
            color: colors.inversePrimary
            Behavior on color { ColorAnimation { duration: 200 } }
        }

        MouseArea {
            id: _actionMa
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: { root.actionClicked(); root.hide() }
        }
    }

    // Close button used in all 3 layouts
    component SnackClose: Item {
        visible: root.showClose
        Layout.preferredWidth: 48
        Layout.preferredHeight: 48

        Rectangle {
            anchors.centerIn: parent
            width: 40; height: 40; radius: 100
            color: colors.inverseOnSurface
            opacity: _closeMa.pressed ? 0.1 : (_closeMa.containsMouse ? 0.08 : 0)
            Behavior on opacity { NumberAnimation { duration: 100 } }
        }

        Text {
            anchors.centerIn: parent
            text: "✕"
            font.pixelSize: 24
            color: colors.inverseOnSurface
            Behavior on color { ColorAnimation { duration: 200 } }
        }

        MouseArea {
            id: _closeMa
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.hide()
        }
    }

    // Supporting text used in all 3 layouts
    component SnackText: Text {
        text: root.text
        font.family: Theme.ChiTheme.fontFamily
        font.pixelSize: root._typo.bodyMedium.size
        font.weight: Font.Normal
        font.letterSpacing: root._typo.bodyMedium.spacing
        color: colors.inverseOnSurface
        elide: Text.ElideRight
        Layout.fillWidth: true
        Behavior on color { ColorAnimation { duration: 200 } }
    }

    Rectangle {
        id: snackbarContainer
        width: parent.width
        height: root.snackbarHeight
        radius: 4
        color: colors.inverseSurface

        Behavior on color { ColorAnimation { duration: 200 } }

        layer.enabled: root.isShowing
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.15)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 4
            shadowBlur: 0.4
        }

        // ─── Single line layout ───
        RowLayout {
            visible: root._single
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: root._rightMargin
            spacing: 4

            SnackText {
                Layout.alignment: Qt.AlignVCenter
            }

            RowLayout {
                visible: root.hasAction || root.showClose
                spacing: 0
                Layout.alignment: Qt.AlignVCenter
                SnackAction {}
                SnackClose {}
            }
        }

        // ─── Multi-line layout ───
        RowLayout {
            visible: root.multiLine && !root.longerAction
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: root._rightMargin
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            spacing: 4

            SnackText {
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                Layout.alignment: Qt.AlignTop
            }

            RowLayout {
                visible: root.hasAction || root.showClose
                spacing: 0
                Layout.alignment: Qt.AlignVCenter
                SnackAction {}
                SnackClose {}
            }
        }

        // ─── Longer action layout (action on separate line) ───
        ColumnLayout {
            visible: root.longerAction
            anchors.fill: parent
            spacing: 0

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 54

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    anchors.topMargin: 14
                    spacing: 10

                    SnackText {
                        wrapMode: Text.WordWrap
                        maximumLineCount: 2
                        Layout.alignment: Qt.AlignTop
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: root.showClose ? 48 : 44
                Layout.leftMargin: 8
                Layout.rightMargin: root.showClose ? 0 : 8
                Layout.bottomMargin: root.showClose ? 0 : 4
                spacing: 0

                Item { Layout.fillWidth: true }
                SnackAction {}
                SnackClose {}
            }
        }
    }

    Timer {
        id: hideTimer
        interval: root.duration
        running: false
        onTriggered: root.hide()
    }

    function show(message, action, closeable) {
        if (message !== undefined) text = message
        if (action !== undefined) actionText = action
        if (closeable !== undefined) showClose = closeable
        state = "visible"
        if (duration > 0) hideTimer.restart()
    }

    function hide() {
        hideTimer.stop()
        state = "hidden"
        closed()
    }

    Accessible.role: Accessible.AlertMessage
    Accessible.name: text
}
