// import QtQuick
// import QtQuick.Layouts
// import Qt5Compat.GraphicalEffects
// import "../../theme" as Theme

// Item {
//     id: root

//     property string text: ""
//     property string actionText: ""
//     property bool showClose: false
//     property int duration: 4000              // 0 = infinite
//     property string position: "bottom"       // "bottom", "top"
//     property bool multiLine: false

//     signal actionClicked()
//     signal closed()

//     readonly property bool hasAction: actionText !== ""
//     readonly property bool isShowing: state === "visible"

//     anchors.left: parent ? parent.left : undefined
//     anchors.right: parent ? parent.right : undefined
//     anchors.bottom: position === "bottom" && parent ? parent.bottom : undefined
//     anchors.top: position === "top" && parent ? parent.top : undefined
//     anchors.margins: 16

//     height: snackbarContainer.height
//     z: 999

//     state: "hidden"

//     states: [
//         State {
//             name: "hidden"
//             PropertyChanges { target: snackbarContainer; opacity: 0; y: position === "bottom" ? 20 : -20 }
//         },
//         State {
//             name: "visible"
//             PropertyChanges { target: snackbarContainer; opacity: 1; y: 0 }
//         }
//     ]

//     transitions: [
//         Transition {
//             from: "hidden"; to: "visible"
//             NumberAnimation { properties: "opacity,y"; duration: 250; easing.type: Easing.OutCubic }
//         },
//         Transition {
//             from: "visible"; to: "hidden"
//             NumberAnimation { properties: "opacity,y"; duration: 200; easing.type: Easing.InCubic }
//         }
//     ]

//     property var colors: Theme.ChiTheme.colors

//     Rectangle {
//         id: snackbarContainer
//         width: parent.width
//         height: contentRow.implicitHeight + 16
//         radius: 4
//         color: colors.inverseSurface

//         Behavior on color {
//             ColorAnimation { duration: 200 }
//         }

//         layer.enabled: true
//         layer.effect: DropShadow {
//             transparentBorder: true
//             horizontalOffset: 0
//             verticalOffset: 2
//             radius: 8
//             samples: 17
//             color: Qt.rgba(0, 0, 0, 0.25)
//         }

//         RowLayout {
//             id: contentRow
//             anchors.fill: parent
//             anchors.leftMargin: 16
//             anchors.rightMargin: showClose ? 8 : (hasAction ? 8 : 16)
//             anchors.topMargin: 8
//             anchors.bottomMargin: 8
//             spacing: 8

//             // Message text
//             Text {
//                 text: root.text
//                 font.family: "Roboto"
//                 font.pixelSize: 14
//                 color: colors.inverseOnSurface
//                 wrapMode: multiLine ? Text.WordWrap : Text.NoWrap
//                 elide: multiLine ? Text.ElideNone : Text.ElideRight
//                 maximumLineCount: multiLine ? 3 : 1
//                 Layout.fillWidth: true
//                 Layout.alignment: Qt.AlignVCenter

//                 Behavior on color {
//                     ColorAnimation { duration: 200 }
//                 }
//             }

//             // Action button
//             Item {
//                 visible: hasAction
//                 width: actionLabel.implicitWidth + 16
//                 height: 36
//                 Layout.alignment: Qt.AlignVCenter

//                 Rectangle {
//                     anchors.fill: parent
//                     radius: 4
//                     color: colors.inversePrimary
//                     opacity: actionMouse.containsMouse ? 0.16 : 0

//                     Behavior on opacity {
//                         NumberAnimation { duration: 100 }
//                     }
//                 }

//                 Text {
//                     id: actionLabel
//                     anchors.centerIn: parent
//                     text: actionText
//                     font.family: "Roboto"
//                     font.pixelSize: 14
//                     font.weight: Font.Medium
//                     color: colors.inversePrimary

//                     Behavior on color {
//                         ColorAnimation { duration: 200 }
//                     }
//                 }

//                 MouseArea {
//                     id: actionMouse
//                     anchors.fill: parent
//                     hoverEnabled: true
//                     cursorShape: Qt.PointingHandCursor
//                     onClicked: {
//                         root.actionClicked()
//                         root.hide()
//                     }
//                 }
//             }

//             // Close button
//             Item {
//                 visible: showClose
//                 width: 32
//                 height: 32
//                 Layout.alignment: Qt.AlignVCenter

//                 Rectangle {
//                     anchors.fill: parent
//                     radius: 16
//                     color: colors.inverseOnSurface
//                     opacity: closeMouse.containsMouse ? 0.16 : 0

//                     Behavior on opacity {
//                         NumberAnimation { duration: 100 }
//                     }
//                 }

//                 Text {
//                     anchors.centerIn: parent
//                     text: "✕"
//                     font.pixelSize: 18
//                     color: colors.inverseOnSurface

//                     Behavior on color {
//                         ColorAnimation { duration: 200 }
//                     }
//                 }

//                 MouseArea {
//                     id: closeMouse
//                     anchors.fill: parent
//                     hoverEnabled: true
//                     cursorShape: Qt.PointingHandCursor
//                     onClicked: root.hide()
//                 }
//             }
//         }
//     }

//     Timer {
//         id: hideTimer
//         interval: duration
//         running: false
//         onTriggered: root.hide()
//     }

//     function show(message, action, closeable) {
//         if (message !== undefined) text = message
//         if (action !== undefined) actionText = action
//         if (closeable !== undefined) showClose = closeable

//         state = "visible"

//         if (duration > 0) {
//             hideTimer.restart()
//         }
//     }

//     function hide() {
//         hideTimer.stop()
//         state = "hidden"
//         closed()
//     }

//     Accessible.role: Accessible.AlertMessage
//     Accessible.name: text
// }




////// material 3

import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
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
    readonly property bool isSingleLine: !multiLine && !longerAction
    readonly property int snackbarHeight: {
        if (longerAction) return 112
        if (multiLine) return 68
        return 48
    }

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

    Rectangle {
        id: snackbarContainer
        width: parent.width
        height: snackbarHeight
        radius: 4
        color: colors.inverseSurface

        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 4
            radius: 8
            samples: 17
            color: Qt.rgba(0, 0, 0, 0.15)
        }

        // Single line layout (with or without action/close inline)
        RowLayout {
            visible: isSingleLine
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: showClose ? 0 : (hasAction ? 8 : 16)
            spacing: 4

            // Supporting text
            Text {
                text: root.text
                font.family: "Roboto"
                font.pixelSize: 14
                font.weight: Font.Normal
                font.letterSpacing: 0.25
                color: colors.inverseOnSurface
                elide: Text.ElideRight
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }
            }

            // Action & close affordance container
            RowLayout {
                visible: hasAction || showClose
                spacing: 0
                Layout.alignment: Qt.AlignVCenter

                // Action button
                Item {
                    visible: hasAction
                    Layout.preferredWidth: actionLabel.implicitWidth + 24
                    Layout.preferredHeight: 40

                    Rectangle {
                        anchors.fill: parent
                        radius: 100
                        color: colors.inversePrimary
                        opacity: actionMouse.pressed ? 0.1 : (actionMouse.containsMouse ? 0.08 : 0)

                        Behavior on opacity {
                            NumberAnimation { duration: 100 }
                        }
                    }

                    Text {
                        id: actionLabel
                        anchors.centerIn: parent
                        text: actionText
                        font.family: "Roboto"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        font.letterSpacing: 0.1
                        color: colors.inversePrimary

                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }

                    MouseArea {
                        id: actionMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.actionClicked()
                            root.hide()
                        }
                    }
                }

                // Close affordance
                Item {
                    visible: showClose
                    Layout.preferredWidth: 48
                    Layout.preferredHeight: 48

                    Rectangle {
                        anchors.centerIn: parent
                        width: 40
                        height: 40
                        radius: 100
                        color: colors.inverseOnSurface
                        opacity: closeMouse.pressed ? 0.1 : (closeMouse.containsMouse ? 0.08 : 0)

                        Behavior on opacity {
                            NumberAnimation { duration: 100 }
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        font.pixelSize: 24
                        color: colors.inverseOnSurface

                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }

                    MouseArea {
                        id: closeMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.hide()
                    }
                }
            }
        }

        // Multi-line layout (text takes more space, action/close on right)
        RowLayout {
            visible: multiLine && !longerAction
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: showClose ? 0 : (hasAction ? 8 : 16)
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            spacing: 4

            // Supporting text
            Text {
                text: root.text
                font.family: "Roboto"
                font.pixelSize: 14
                font.weight: Font.Normal
                font.letterSpacing: 0.25
                color: colors.inverseOnSurface
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Text.ElideRight
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }
            }

            // Action & close affordance container
            RowLayout {
                visible: hasAction || showClose
                spacing: 0
                Layout.alignment: Qt.AlignVCenter

                // Action button
                Item {
                    visible: hasAction
                    Layout.preferredWidth: multiActionLabel.implicitWidth + 24
                    Layout.preferredHeight: 40

                    Rectangle {
                        anchors.fill: parent
                        radius: 100
                        color: colors.inversePrimary
                        opacity: multiActionMouse.pressed ? 0.1 : (multiActionMouse.containsMouse ? 0.08 : 0)
                    }

                    Text {
                        id: multiActionLabel
                        anchors.centerIn: parent
                        text: actionText
                        font.family: "Roboto"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        font.letterSpacing: 0.1
                        color: colors.inversePrimary
                    }

                    MouseArea {
                        id: multiActionMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.actionClicked()
                            root.hide()
                        }
                    }
                }

                // Close affordance
                Item {
                    visible: showClose
                    Layout.preferredWidth: 48
                    Layout.preferredHeight: 48

                    Rectangle {
                        anchors.centerIn: parent
                        width: 40
                        height: 40
                        radius: 100
                        color: colors.inverseOnSurface
                        opacity: multiCloseMouse.pressed ? 0.1 : (multiCloseMouse.containsMouse ? 0.08 : 0)
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        font.pixelSize: 24
                        color: colors.inverseOnSurface
                    }

                    MouseArea {
                        id: multiCloseMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.hide()
                    }
                }
            }
        }

        // Longer action layout (action on separate line at bottom right)
        ColumnLayout {
            visible: longerAction
            anchors.fill: parent
            spacing: 0

            // Content row
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 54

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    anchors.topMargin: 14
                    spacing: 10

                    Text {
                        text: root.text
                        font.family: "Roboto"
                        font.pixelSize: 14
                        font.weight: Font.Normal
                        font.letterSpacing: 0.25
                        color: colors.inverseOnSurface
                        wrapMode: Text.WordWrap
                        maximumLineCount: 2
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignTop

                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }
                }
            }

            // Action & close affordance row
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: showClose ? 48 : 44
                Layout.leftMargin: 8
                Layout.rightMargin: showClose ? 0 : 8
                Layout.bottomMargin: showClose ? 0 : 4
                spacing: 0

                Item { Layout.fillWidth: true }

                // Action button
                Item {
                    visible: hasAction
                    Layout.preferredWidth: longerActionLabel.implicitWidth + 24
                    Layout.preferredHeight: 40

                    Rectangle {
                        anchors.fill: parent
                        radius: 100
                        color: colors.inversePrimary
                        opacity: longerActionMouse.pressed ? 0.1 : (longerActionMouse.containsMouse ? 0.08 : 0)
                    }

                    Text {
                        id: longerActionLabel
                        anchors.centerIn: parent
                        text: actionText
                        font.family: "Roboto"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        font.letterSpacing: 0.1
                        color: colors.inversePrimary

                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }

                    MouseArea {
                        id: longerActionMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.actionClicked()
                            root.hide()
                        }
                    }
                }

                // Close affordance
                Item {
                    visible: showClose
                    Layout.preferredWidth: 48
                    Layout.preferredHeight: 48

                    Rectangle {
                        anchors.centerIn: parent
                        width: 40
                        height: 40
                        radius: 100
                        color: colors.inverseOnSurface
                        opacity: longerCloseMouse.pressed ? 0.1 : (longerCloseMouse.containsMouse ? 0.08 : 0)
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        font.pixelSize: 24
                        color: colors.inverseOnSurface
                    }

                    MouseArea {
                        id: longerCloseMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.hide()
                    }
                }
            }
        }
    }

    Timer {
        id: hideTimer
        interval: duration
        running: false
        onTriggered: root.hide()
    }

    function show(message, action, closeable) {
        if (message !== undefined) text = message
        if (action !== undefined) actionText = action
        if (closeable !== undefined) showClose = closeable

        state = "visible"

        if (duration > 0) {
            hideTimer.restart()
        }
    }

    function hide() {
        hideTimer.stop()
        state = "hidden"
        closed()
    }

    Accessible.role: Accessible.AlertMessage
    Accessible.name: text
}
