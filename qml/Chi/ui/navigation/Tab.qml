// // // // import QtQuick
// // // // import QtQuick.Controls
// // // // import QtQuick.Layouts
// // // // import "../common" as Common
// // // // import "../../theme" as Theme

// // // // pragma ComponentBehavior: Bound

// // // // Rectangle {
// // // //     id: root

// // // //     property alias text: label.text
// // // //     property string icon: ""
// // // //     property bool showBadge: false
// // // //     property string badgeText: ""
// // // //     property bool checked: false
// // // //     property int index: 0

// // // //     property var colors: Theme.ChiTheme.colors

// // // //     signal clicked()

// // // //     implicitWidth: Math.max(90, contentColumn.implicitWidth + 16)
// // // //     implicitHeight: 48

// // // //     color: "transparent"

// // // //     Row {
// // // //         id: contentColumn
// // // //         anchors.centerIn: parent
// // // //         spacing: 8

// // // //         Item {
// // // //             visible: icon !== ""
// // // //             width: 24
// // // //             height: 24
// // // //             anchors.verticalCenter: parent.verticalCenter

// // // //             Common.Icon {
// // // //                 anchors.centerIn: parent
// // // //                 source: icon
// // // //                 size: 24
// // // //                 color: root.checked ? colors.primary : colors.onSurfaceVariant
// // // //             }

// // // //             Rectangle {
// // // //                 visible: showBadge
// // // //                 anchors.top: parent.top
// // // //                 anchors.right: parent.right
// // // //                 anchors.topMargin: -2
// // // //                 anchors.rightMargin: -4

// // // //                 width: badgeText === "" ? 6 : Math.max(16, badgeTextIcon.implicitWidth + 8)
// // // //                 height: badgeText === "" ? 6 : 16
// // // //                 radius: height / 2
// // // //                 color: colors.error

// // // //                 scale: showBadge ? 1 : 0

// // // //                 Behavior on scale {
// // // //                     NumberAnimation { duration: 150; easing.type: Easing.OutBack }
// // // //                 }

// // // //                 Text {
// // // //                     id: badgeTextIcon
// // // //                     visible: badgeText !== ""
// // // //                     anchors.centerIn: parent
// // // //                     text: badgeText
// // // //                     font.family: "Roboto"
// // // //                     font.pixelSize: 11
// // // //                     font.weight: Font.Medium
// // // //                     color: colors.onError
// // // //                 }
// // // //             }
// // // //         }

// // // //         Text {
// // // //             id: label
// // // //             font.family: "Roboto"
// // // //             font.pixelSize: 14
// // // //             font.weight: Font.Medium
// // // //             font.letterSpacing: 0.1
// // // //             color: root.checked ? colors.primary : colors.onSurfaceVariant
// // // //             anchors.verticalCenter: parent.verticalCenter
// // // //             horizontalAlignment: Text.AlignHCenter

// // // //             Behavior on color {
// // // //                 ColorAnimation { duration: 150 }
// // // //             }
// // // //         }
// // // //     }

// // // //     MouseArea {
// // // //         id: mouseArea
// // // //         anchors.fill: parent
// // // //         hoverEnabled: true
// // // //         cursorShape: Qt.PointingHandCursor

// // // //         onClicked: {
// // // //             root.clicked()
// // // //         }
// // // //     }
// // // // }



// // // import QtQuick
// // // import QtQuick.Controls
// // // import QtQuick.Layouts
// // // import "../common" as Common
// // // import "../../theme" as Theme

// // // pragma ComponentBehavior: Bound

// // // Item {
// // //     id: root

// // //     // --- Public Properties ---
// // //     property alias text: label.text
// // //     property string icon: ""
// // //     property bool showBadge: false
// // //     property string badgeText: ""

// // //     // Controlled by parent Tabs
// // //     property bool selected: false
// // //     property int index: 0

// // //     // Signal for parent
// // //     signal clicked()

// // //     // --- Theme ---
// // //     property var colors: Theme.ChiTheme.colors

// // //     // --- Dimensions & A11y ---
// // //     // M3 Spec: 48dp for text only, 64dp for text+icon
// // //     implicitHeight: icon !== "" && text !== "" ? 64 : 48
// // //     // M3 Spec: Min width 90dp
// // //     implicitWidth: Math.max(90, contentContainer.implicitWidth + 32)

// // //     // Accessible Role
// // //     Accessible.role: Accessible.PageTab
// // //     Accessible.name: text
// // //     Accessible.selected: selected
// // //     Accessible.onPressAction: root.clicked()

// // //     // Focus handling
// // //     focus: true
// // //     activeFocusOnTab: true

// // //     // Helper for the parent to size the indicator line
// // //     readonly property real contentWidth: contentContainer.implicitWidth

// // //     // --- State Layer (Hover/Focus/Press Overlay) ---
// // //     Rectangle {
// // //         id: stateLayer
// // //         anchors.fill: parent
// // //         color: root.colors.onSurface
// // //         opacity: 0
// // //         z: 0 // Behind content, above background

// // //         states: [
// // //             State {
// // //                 name: "pressed"
// // //                 when: mouseArea.pressed
// // //                 PropertyChanges { target: stateLayer; opacity: 0.12 }
// // //             },
// // //             State {
// // //                 name: "focused"
// // //                 when: root.activeFocus
// // //                 PropertyChanges { target: stateLayer; opacity: 0.12 }
// // //             },
// // //             State {
// // //                 name: "hovered"
// // //                 when: mouseArea.containsMouse
// // //                 PropertyChanges { target: stateLayer; opacity: 0.08 }
// // //             }
// // //         ]

// // //         transitions: Transition {
// // //             NumberAnimation { property: "opacity"; duration: 200 }
// // //         }
// // //     }

// // //     // --- Content Layout ---
// // //     ColumnLayout {
// // //         id: contentContainer
// // //         anchors.centerIn: parent
// // //         spacing: icon !== "" && text !== "" ? 2 : 0
// // //         z: 1

// // //         // Icon Container
// // //         Item {
// // //             id: iconItem
// // //             visible: root.icon !== ""
// // //             Layout.alignment: Qt.AlignHCenter
// // //             Layout.preferredWidth: 24
// // //             Layout.preferredHeight: 24

// // //             Common.Icon {
// // //                 anchors.centerIn: parent
// // //                 source: root.icon
// // //                 size: 24
// // //                 color: root.selected ? root.colors.primary : root.colors.onSurfaceVariant

// // //                 Behavior on color { ColorAnimation { duration: 150 } }
// // //             }

// // //             // Badge
// // //             Rectangle {
// // //                 visible: root.showBadge
// // //                 anchors.top: parent.top
// // //                 anchors.left: parent.right
// // //                 anchors.topMargin: -4
// // //                 anchors.leftMargin: -10
// // //                 z: 1

// // //                 width: root.badgeText === "" ? 6 : Math.max(16, badgeLabel.implicitWidth + 8)
// // //                 height: root.badgeText === "" ? 6 : 16
// // //                 radius: height / 2
// // //                 color: root.colors.error

// // //                 Text {
// // //                     id: badgeLabel
// // //                     visible: root.badgeText !== ""
// // //                     anchors.centerIn: parent
// // //                     text: root.badgeText
// // //                     font.family: "Roboto"
// // //                     font.pixelSize: 11
// // //                     font.weight: Font.Medium
// // //                     color: root.colors.onError
// // //                 }
// // //             }
// // //         }

// // //         // Label
// // //         Text {
// // //             id: label
// // //             visible: text !== ""
// // //             Layout.alignment: Qt.AlignHCenter

// // //             font.family: "Roboto"
// // //             font.pixelSize: 14
// // //             font.weight: Font.Medium
// // //             font.letterSpacing: 0.1

// // //             color: root.selected ? root.colors.primary : root.colors.onSurfaceVariant
// // //             horizontalAlignment: Text.AlignHCenter

// // //             Behavior on color { ColorAnimation { duration: 150 } }
// // //         }
// // //     }

// // //     // --- Interaction ---
// // //     MouseArea {
// // //         id: mouseArea
// // //         anchors.fill: parent
// // //         hoverEnabled: true
// // //         cursorShape: Qt.PointingHandCursor
// // //         onClicked: {
// // //             root.forceActiveFocus()
// // //             root.clicked()
// // //         }
// // //     }

// // //     // --- Keyboard Navigation ---
// // //     Keys.onSpacePressed: root.clicked()
// // //     Keys.onReturnPressed: root.clicked()
// // // }






// // import QtQuick
// // import QtQuick.Controls
// // import QtQuick.Layouts
// // import "../common" as Common
// // import "../../theme" as Theme

// // pragma ComponentBehavior: Bound

// // Item {
// //     id: root

// //     // --- Public Properties ---
// //     // CHANGED: Cannot alias to items inside a Loader/Component. Use strings.
// //     property string text: ""
// //     property string icon: ""
// //     property bool showBadge: false
// //     property string badgeText: ""

// //     // "primary" (Stacked, 64dp) or "secondary" (Inline, 48dp)
// //     property string variant: "primary"

// //     // Controlled by parent Tabs
// //     property bool selected: false
// //     property int index: 0

// //     // Signal for parent
// //     signal clicked()

// //     // --- Theme ---
// //     property var colors: Theme.ChiTheme.colors

// //     // --- Dimensions & Logic ---
// //     // Primary with Icon+Text = 64dp. Everything else (Text only, Icon only, or Secondary) = 48dp
// //     implicitHeight: (variant === "primary" && icon !== "" && text !== "") ? 64 : 48

// //     // Width adapts to content + padding (min 90dp for touch targets)
// //     implicitWidth: Math.max(90, contentLoader.item ? contentLoader.item.implicitWidth + 32 : 90)

// //     // Helper for parent indicator sizing
// //     readonly property real contentWidth: contentLoader.item ? contentLoader.item.implicitWidth : 0

// //     // --- Accessibility & Focus Logic ---
// //     Accessible.role: Accessible.PageTab
// //     Accessible.name: text
// //     Accessible.selected: selected
// //     Accessible.onPressAction: root.clicked()

// //     focus: true
// //     activeFocusOnTab: true

// //     // Only show the visual Focus Ring if focus came from Keyboard, not Mouse
// //     property bool _isKeyboardFocus: false

// //     Keys.onPressed: (event) => {
// //         _isKeyboardFocus = true
// //         if (event.key === Qt.Key_Space || event.key === Qt.Key_Return) {
// //             root.clicked()
// //             event.accepted = true
// //         }
// //     }

// //     // --- Interaction ---
// //     MouseArea {
// //         id: mouseArea
// //         anchors.fill: parent
// //         hoverEnabled: true
// //         cursorShape: Qt.PointingHandCursor

// //         onPressed: {
// //             root._isKeyboardFocus = false // Mouse interaction disables focus ring
// //             root.forceActiveFocus()
// //         }
// //         onClicked: root.clicked()
// //     }

// //     // --- State Layer (Hover/Press Opacity) ---
// //     Rectangle {
// //         id: stateLayer
// //         anchors.fill: parent
// //         color: root.colors.onSurface
// //         opacity: 0
// //         z: 0

// //         states: [
// //             State {
// //                 name: "pressed"
// //                 when: mouseArea.pressed
// //                 PropertyChanges { target: stateLayer; opacity: 0.12; color: root.selected ? root.colors.primary : root.colors.onSurface }
// //             },
// //             State {
// //                 name: "hovered"
// //                 when: mouseArea.containsMouse
// //                 PropertyChanges { target: stateLayer; opacity: 0.08; color: root.selected ? root.colors.primary : root.colors.onSurface }
// //             },
// //             State {
// //                 name: "focused"
// //                 // Show subtle opacity focus state always, but Ring only on keyboard
// //                 when: root.activeFocus && !mouseArea.pressed
// //                 PropertyChanges { target: stateLayer; opacity: 0.12; color: root.selected ? root.colors.primary : root.colors.onSurface }
// //             }
// //         ]

// //         transitions: Transition {
// //             NumberAnimation { property: "opacity"; duration: 150 }
// //         }
// //     }

// //     // --- Content Loader (Switches Layouts) ---
// //     Loader {
// //         id: contentLoader
// //         anchors.centerIn: parent
// //         z: 1

// //         // Switch component based on variant
// //         sourceComponent: root.variant === "secondary" ? inlineLayout : stackedLayout
// //     }

// //     // --- Layout 1: Stacked (Primary) ---
// //     Component {
// //         id: stackedLayout
// //         ColumnLayout {
// //             spacing: (root.icon !== "" && root.text !== "") ? 2 : 0

// //             Item {
// //                 visible: root.icon !== ""
// //                 Layout.alignment: Qt.AlignHCenter
// //                 Layout.preferredWidth: 24
// //                 Layout.preferredHeight: 24

// //                 Common.Icon {
// //                     anchors.centerIn: parent
// //                     source: root.icon
// //                     size: 24
// //                     color: root.selected ? root.colors.primary : root.colors.onSurfaceVariant
// //                     Behavior on color { ColorAnimation { duration: 150 } }
// //                 }
// //                 // Badge
// //                 Loader { sourceComponent: badgeComponent; active: root.showBadge }
// //             }

// //             Text {
// //                 visible: root.text !== ""
// //                 text: root.text
// //                 Layout.alignment: Qt.AlignHCenter
// //                 font.family: "Roboto"
// //                 font.pixelSize: 14
// //                 font.weight: Font.Medium
// //                 font.letterSpacing: 0.1
// //                 color: root.selected ? root.colors.primary : root.colors.onSurfaceVariant
// //                 horizontalAlignment: Text.AlignHCenter
// //                 Behavior on color { ColorAnimation { duration: 150 } }
// //             }
// //         }
// //     }

// //     // --- Layout 2: Inline (Secondary) ---
// //     Component {
// //         id: inlineLayout
// //         RowLayout {
// //             spacing: 8

// //             Item {
// //                 visible: root.icon !== ""
// //                 Layout.alignment: Qt.AlignVCenter
// //                 Layout.preferredWidth: 24
// //                 Layout.preferredHeight: 24

// //                 Common.Icon {
// //                     anchors.centerIn: parent
// //                     source: root.icon
// //                     size: 24
// //                     color: root.selected ? root.colors.onSurface : root.colors.onSurfaceVariant // Secondary text is often onSurface
// //                     Behavior on color { ColorAnimation { duration: 150 } }
// //                 }
// //             }

// //             Text {
// //                 visible: root.text !== ""
// //                 text: root.text
// //                 Layout.alignment: Qt.AlignVCenter
// //                 font.family: "Roboto"
// //                 font.pixelSize: 14
// //                 font.weight: Font.Medium
// //                 font.letterSpacing: 0.1
// //                 // Secondary tabs often use OnSurface for Active
// //                 color: root.selected ? root.colors.onSurface : root.colors.onSurfaceVariant
// //                 horizontalAlignment: Text.AlignHCenter
// //                 Behavior on color { ColorAnimation { duration: 150 } }
// //             }

// //              // Badge (Inline usually places badge next to text or top right of icon, simplistic approach here)
// //              Loader { sourceComponent: badgeComponent; active: root.showBadge; Layout.alignment: Qt.AlignTop }
// //         }
// //     }

// //     // --- Shared Badge Component ---
// //     Component {
// //         id: badgeComponent
// //         Rectangle {
// //             // Position logic depends on parent, doing simple relative positioning
// //             width: root.badgeText === "" ? 6 : Math.max(16, badgeLabel.implicitWidth + 8)
// //             height: root.badgeText === "" ? 6 : 16
// //             radius: height / 2
// //             color: root.colors.error

// //             // Manual positioning tweak
// //             x: 14
// //             y: -2

// //             Text {
// //                 id: badgeLabel
// //                 visible: root.badgeText !== ""
// //                 anchors.centerIn: parent
// //                 text: root.badgeText
// //                 font.family: "Roboto"
// //                 font.pixelSize: 11
// //                 font.weight: Font.Medium
// //                 color: root.colors.onError
// //             }
// //         }
// //     }

// //     // --- Accessibility Focus Ring (Keyboard Only) ---
// //     // M3 Spec: 3px solid #625B71 (Secondary color), with 2px gap (handled by placement) or inset
// //     Rectangle {
// //         id: focusIndicator
// //         anchors.fill: parent
// //         anchors.margins: 4
// //         radius: 4
// //         color: "transparent"
// //         border.width: 3
// //         border.color: root.colors.secondary
// //         visible: root.activeFocus && root._isKeyboardFocus
// //         z: 10
// //     }
// // }


// // ////// version 2


// import QtQuick
// import QtQuick.Controls
// import QtQuick.Layouts
// import "../common" as Common
// import "../../theme" as Theme

// pragma ComponentBehavior: Bound

// Item {
//     id: root

//     // --- Properties ---
//     property string text: ""
//     property string icon: ""
//     property bool showBadge: false
//     property string badgeText: ""

//     // "primary" (Stacked 64dp) or "secondary" (Inline 48dp)
//     property string variant: "primary"

//     property bool selected: false
//     property int index: 0

//     signal clicked()
//     property var colors: Theme.ChiTheme.colors

//     // --- Sizing ---
//     // Height: Primary=64, Secondary=48
//     implicitHeight: (variant === "primary" && icon !== "" && text !== "") ? 64 : 48
//     // Width: Adapts to content + padding, min 90
//     implicitWidth: Math.max(90, contentLoader.item ? contentLoader.item.implicitWidth + 32 : 90)

//     // Helper for the Indicator Line to match content width exactly
//     readonly property real contentWidth: contentLoader.item ? contentLoader.item.implicitWidth : 0

//     // --- Focus Logic ---
//     Accessible.role: Accessible.PageTab
//     Accessible.name: text
//     Accessible.selected: selected
//     Accessible.onPressAction: root.clicked()

//     focus: true
//     activeFocusOnTab: true

//     // Flag to track if focus came from Keyboard
//     property bool _isKeyboardFocus: false

//     Keys.onPressed: (event) => {
//         _isKeyboardFocus = true
//         if (event.key === Qt.Key_Space || event.key === Qt.Key_Return) {
//             root.clicked()
//             event.accepted = true
//         }
//     }

//     // --- Interaction ---
//     MouseArea {
//         id: mouseArea
//         anchors.fill: parent
//         hoverEnabled: true
//         cursorShape: Qt.PointingHandCursor

//         onPressed: {
//             root._isKeyboardFocus = false // Reset keyboard focus flag on mouse interaction
//             root.forceActiveFocus()
//         }
//         onClicked: root.clicked()
//     }

//     // --- State Layer (The Overlay) ---
//     // FIXED: Strictly controlled. No persistent state on mouse click.
//     Rectangle {
//         id: stateLayer
//         anchors.fill: parent
//         color: root.colors.onSurface
//         opacity: 0
//         z: 0

//         states: [
//             State {
//                 name: "pressed"
//                 when: mouseArea.pressed
//                 PropertyChanges { target: stateLayer; opacity: 0.12; color: root.selected ? root.colors.primary : root.colors.onSurface }
//             },
//             State {
//                 name: "hovered"
//                 when: mouseArea.containsMouse && !mouseArea.pressed
//                 PropertyChanges { target: stateLayer; opacity: 0.08; color: root.selected ? root.colors.primary : root.colors.onSurface }
//             },
//             State {
//                 name: "keyboard_focused"
//                 // ONLY visible if activeFocus is true AND it was caused by keyboard
//                 when: root.activeFocus && root._isKeyboardFocus
//                 PropertyChanges { target: stateLayer; opacity: 0.12; color: root.selected ? root.colors.primary : root.colors.onSurface }
//             }
//         ]

//         transitions: Transition {
//             NumberAnimation { property: "opacity"; duration: 100 }
//         }
//     }

//     // --- Content Loader ---
//     Loader {
//         id: contentLoader
//         anchors.centerIn: parent
//         z: 1
//         sourceComponent: root.variant === "secondary" ? inlineLayout : stackedLayout
//     }

//     // Layout 1: Stacked (Primary)
//     Component {
//         id: stackedLayout
//         ColumnLayout {
//             spacing: (root.icon !== "" && root.text !== "") ? 2 : 0

//             Item {
//                 visible: root.icon !== ""
//                 Layout.alignment: Qt.AlignHCenter
//                 Layout.preferredWidth: 24
//                 Layout.preferredHeight: 24

//                 Common.Icon {
//                     anchors.centerIn: parent
//                     source: root.icon
//                     size: 24
//                     color: root.selected ? root.colors.primary : root.colors.onSurfaceVariant
//                     Behavior on color { ColorAnimation { duration: 150 } }
//                 }
//                 Loader { sourceComponent: badgeComponent; active: root.showBadge }
//             }

//             Text {
//                 visible: root.text !== ""
//                 text: root.text
//                 Layout.alignment: Qt.AlignHCenter
//                 font.family: "Roboto"
//                 font.pixelSize: 14
//                 font.weight: Font.Medium
//                 font.letterSpacing: 0.1
//                 color: root.selected ? root.colors.primary : root.colors.onSurfaceVariant
//                 horizontalAlignment: Text.AlignHCenter
//                 Behavior on color { ColorAnimation { duration: 150 } }
//             }
//         }
//     }

//     // Layout 2: Inline (Secondary)
//     Component {
//         id: inlineLayout
//         RowLayout {
//             spacing: 8

//             Item {
//                 visible: root.icon !== ""
//                 Layout.alignment: Qt.AlignVCenter
//                 Layout.preferredWidth: 24
//                 Layout.preferredHeight: 24

//                 Common.Icon {
//                     anchors.centerIn: parent
//                     source: root.icon
//                     size: 24
//                     color: root.selected ? root.colors.onSurface : root.colors.onSurfaceVariant
//                     Behavior on color { ColorAnimation { duration: 150 } }
//                 }
//             }

//             Text {
//                 visible: root.text !== ""
//                 text: root.text
//                 Layout.alignment: Qt.AlignVCenter
//                 font.family: "Roboto"
//                 font.pixelSize: 14
//                 font.weight: Font.Medium
//                 font.letterSpacing: 0.1
//                 color: root.selected ? root.colors.onSurface : root.colors.onSurfaceVariant
//                 horizontalAlignment: Text.AlignHCenter
//                 Behavior on color { ColorAnimation { duration: 150 } }
//             }
//             Loader { sourceComponent: badgeComponent; active: root.showBadge; Layout.alignment: Qt.AlignTop }
//         }
//     }

//     // Badge
//     Component {
//         id: badgeComponent
//         Rectangle {
//             width: root.badgeText === "" ? 6 : Math.max(16, badgeLabel.implicitWidth + 8)
//             height: root.badgeText === "" ? 6 : 16
//             radius: height / 2
//             color: root.colors.error
//             x: 14; y: -2

//             Text {
//                 id: badgeLabel
//                 visible: root.badgeText !== ""
//                 anchors.centerIn: parent
//                 text: root.badgeText
//                 font.family: "Roboto"
//                 font.pixelSize: 11
//                 font.weight: Font.Medium
//                 color: root.colors.onError
//             }
//         }
//     }

//     // --- Keyboard Focus Ring ---
//     Rectangle {
//         id: focusIndicator
//         anchors.fill: parent
//         anchors.margins: 4
//         radius: 4
//         color: "transparent"
//         border.width: 3
//         border.color: root.colors.secondary
//         visible: root.activeFocus && root._isKeyboardFocus
//         z: 10
//     }
// }



// ///////////////// version 3 -fix accesability


import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../common" as Common
import "../../theme" as Theme

pragma ComponentBehavior: Bound

Item {
    id: root

    // --- Properties ---
    property string text: ""
    property string icon: ""
    property bool showBadge: false
    property string badgeText: ""
    property string variant: "primary" // "primary" or "secondary"

    property bool selected: false
    property int index: 0

    signal clicked()
    property var colors: Theme.ChiTheme.colors
    readonly property string fontFamily: Theme.ChiTheme.fontFamily

    // --- Sizing ---
    // Implicit height helps the parent calculate max height,
    // but the parent will likely override actual 'height'.
    implicitHeight: (variant === "primary" && icon !== "" && text !== "") ? 64 : 48
    implicitWidth: Math.max(90, contentLoader.item ? contentLoader.item.implicitWidth + 32 : 90)

    readonly property real contentWidth: contentLoader.item ? contentLoader.item.implicitWidth : 0

    // --- Accessibility ---
    Accessible.role: Accessible.PageTab
    Accessible.name: text
    Accessible.selected: selected
    Accessible.onPressAction: root.clicked()

    focus: true
    activeFocusOnTab: true

    // Keyboard Focus Tracking
    property bool _isKeyboardFocus: false

    // Handle Space/Enter for activation
    Keys.onPressed: (event) => {
        _isKeyboardFocus = true
        if (event.key === Qt.Key_Space || event.key === Qt.Key_Return) {
            root.clicked()
            event.accepted = true
        }
    }

    // --- Interaction ---
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onPressed: {
            root._isKeyboardFocus = false
            root.forceActiveFocus()
        }
        onClicked: root.clicked()
    }

    // --- State Layer ---
    Rectangle {
        id: stateLayer
        anchors.fill: parent
        color: root.colors.onSurface
        opacity: 0
        z: 0

        states: [
            State {
                name: "pressed"
                when: mouseArea.pressed
                PropertyChanges { target: stateLayer; opacity: 0.12; color: root.selected ? root.colors.primary : root.colors.onSurface }
            },
            State {
                name: "hovered"
                when: mouseArea.containsMouse && !mouseArea.pressed
                PropertyChanges { target: stateLayer; opacity: 0.08; color: root.selected ? root.colors.primary : root.colors.onSurface }
            },
            State {
                name: "keyboard_focused"
                when: root.activeFocus && root._isKeyboardFocus
                PropertyChanges { target: stateLayer; opacity: 0.12; color: root.selected ? root.colors.primary : root.colors.onSurface }
            }
        ]
        transitions: Transition { NumberAnimation { property: "opacity"; duration: 100 } }
    }

    // --- Content ---
    Loader {
        id: contentLoader
        anchors.centerIn: parent // Keeps text centered even if Tab stretches height
        z: 1
        sourceComponent: root.variant === "secondary" ? inlineLayout : stackedLayout
    }

    Component {
        id: stackedLayout
        ColumnLayout {
            spacing: (root.icon !== "" && root.text !== "") ? 2 : 0
            Item {
                visible: root.icon !== ""
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 24; Layout.preferredHeight: 24
                Common.Icon {
                    anchors.centerIn: parent
                    source: root.icon
                    size: 24
                    color: root.selected ? root.colors.primary : root.colors.onSurfaceVariant
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
                Loader { sourceComponent: badgeComponent; active: root.showBadge }
            }
            Text {
                visible: root.text !== ""
                text: root.text
                Layout.alignment: Qt.AlignHCenter
                font.family: fontFamily; font.pixelSize: 14; font.weight: Font.Medium; font.letterSpacing: 0.1
                color: root.selected ? root.colors.primary : root.colors.onSurfaceVariant
                horizontalAlignment: Text.AlignHCenter
                Behavior on color { ColorAnimation { duration: 150 } }
            }
        }
    }

    Component {
        id: inlineLayout
        RowLayout {
            spacing: 8
            Item {
                visible: root.icon !== ""
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 24; Layout.preferredHeight: 24
                Common.Icon {
                    anchors.centerIn: parent
                    source: root.icon
                    size: 24
                    color: root.selected ? root.colors.onSurface : root.colors.onSurfaceVariant
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
            }
            Text {
                visible: root.text !== ""
                text: root.text
                Layout.alignment: Qt.AlignVCenter
                font.family: fontFamily; font.pixelSize: 14; font.weight: Font.Medium; font.letterSpacing: 0.1
                color: root.selected ? root.colors.onSurface : root.colors.onSurfaceVariant
                horizontalAlignment: Text.AlignHCenter
                Behavior on color { ColorAnimation { duration: 150 } }
            }
            Loader { sourceComponent: badgeComponent; active: root.showBadge; Layout.alignment: Qt.AlignTop }
        }
    }

    Component {
        id: badgeComponent
        Rectangle {
            width: root.badgeText === "" ? 6 : Math.max(16, badgeLabel.implicitWidth + 8)
            height: root.badgeText === "" ? 6 : 16
            radius: height / 2
            color: root.colors.error
            x: 14; y: -2
            Text {
                id: badgeLabel
                visible: root.badgeText !== ""
                anchors.centerIn: parent
                text: root.badgeText
                font.family: fontFamily; font.pixelSize: 11; font.weight: Font.Medium
                color: root.colors.onError
            }
        }
    }

    // --- Keyboard Focus Ring ---
    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        radius: 4
        color: "transparent"
        border.width: 3
        border.color: root.colors.secondary
        visible: root.activeFocus && root._isKeyboardFocus
        z: 10
    }
}
