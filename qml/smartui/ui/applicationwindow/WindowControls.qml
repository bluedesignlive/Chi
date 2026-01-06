// // // // // // // // qml/smartui/ui/applicationwindow/WindowControls.qml

// // // // // // // import QtQuick
// // // // // // // import QtQuick.Layouts
// // // // // // // import "../../theme" as Theme
// // // // // // // import "../common"

// // // // // // // Item {
// // // // // // //     id: root

// // // // // // //     property var targetWindow: null
// // // // // // //     property var colors: Theme.ChiTheme.colors

// // // // // // //     // Customization
// // // // // // //     property string minimizeIcon: "remove"
// // // // // // //     property string maximizeIcon: "crop_square"
// // // // // // //     property string restoreIcon: "filter_none"
// // // // // // //     property string closeIcon: "close"

// // // // // // //     property bool showMinimize: true
// // // // // // //     property bool showMaximize: true
// // // // // // //     property bool showClose: true

// // // // // // //     // Style variants: "default", "macOS", "filled"
// // // // // // //     property string variant: "default"

// // // // // // //     // macOS style colors
// // // // // // //     property color macCloseColor: "#FF5F57"
// // // // // // //     property color macMinimizeColor: "#FEBC2E"
// // // // // // //     property color macMaximizeColor: "#28C840"

// // // // // // //     implicitWidth: controlsRow.implicitWidth
// // // // // // //     implicitHeight: 40

// // // // // // //     Row {
// // // // // // //         id: controlsRow
// // // // // // //         anchors.centerIn: parent
// // // // // // //         spacing: variant === "macOS" ? 8 : 4
// // // // // // //         layoutDirection: variant === "macOS" ? Qt.LeftToRight : Qt.RightToLeft

// // // // // // //         // Close Button
// // // // // // //         WindowControlButton {
// // // // // // //             visible: showClose
// // // // // // //             icon: closeIcon
// // // // // // //             variant: root.variant
// // // // // // //             macColor: macCloseColor
// // // // // // //             isClose: true
// // // // // // //             onClicked: targetWindow?.close()
// // // // // // //             tooltipText: "Close"
// // // // // // //         }

// // // // // // //         // Minimize Button
// // // // // // //         WindowControlButton {
// // // // // // //             visible: showMinimize
// // // // // // //             icon: minimizeIcon
// // // // // // //             variant: root.variant
// // // // // // //             macColor: macMinimizeColor
// // // // // // //             onClicked: targetWindow?.showMinimized()
// // // // // // //             tooltipText: "Minimize"
// // // // // // //         }

// // // // // // //         // Maximize/Restore Button
// // // // // // //         WindowControlButton {
// // // // // // //             visible: showMaximize
// // // // // // //             icon: targetWindow?.visibility === Window.Maximized ? restoreIcon : maximizeIcon
// // // // // // //             variant: root.variant
// // // // // // //             macColor: macMaximizeColor
// // // // // // //             onClicked: {
// // // // // // //                 if (targetWindow) {
// // // // // // //                     if (targetWindow.visibility === Window.Maximized)
// // // // // // //                         targetWindow.showNormal()
// // // // // // //                     else
// // // // // // //                         targetWindow.showMaximized()
// // // // // // //                 }
// // // // // // //             }
// // // // // // //             tooltipText: targetWindow?.visibility === Window.Maximized ? "Restore" : "Maximize"
// // // // // // //         }
// // // // // // //     }

// // // // // // //     // Window Control Button Component
// // // // // // //     component WindowControlButton: Item {
// // // // // // //         id: btn

// // // // // // //         property string icon: ""
// // // // // // //         property string variant: "default"
// // // // // // //         property color macColor: "#888"
// // // // // // //         property bool isClose: false
// // // // // // //         property string tooltipText: ""

// // // // // // //         signal clicked()

// // // // // // //         width: variant === "macOS" ? 14 : 40
// // // // // // //         height: variant === "macOS" ? 14 : 40

// // // // // // //         // Default/Filled style
// // // // // // //         Rectangle {
// // // // // // //             anchors.fill: parent
// // // // // // //             radius: variant === "macOS" ? 7 : 20
// // // // // // //             visible: variant !== "macOS"

// // // // // // //             color: {
// // // // // // //                 if (btnMouse.pressed) {
// // // // // // //                     return isClose ?
// // // // // // //                         Qt.rgba(colors.error.r, colors.error.g, colors.error.b, 0.2) :
// // // // // // //                         Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.12)
// // // // // // //                 }
// // // // // // //                 if (btnMouse.containsMouse) {
// // // // // // //                     return isClose ?
// // // // // // //                         Qt.rgba(colors.error.r, colors.error.g, colors.error.b, 0.1) :
// // // // // // //                         Qt.rgba(colors.onSurface.r, colors.onSurface.g, colors.onSurface.b, 0.08)
// // // // // // //                 }
// // // // // // //                 return "transparent"
// // // // // // //             }

// // // // // // //             Behavior on color { ColorAnimation { duration: 150 } }

// // // // // // //             Icon {
// // // // // // //                 anchors.centerIn: parent
// // // // // // //                 source: btn.icon
// // // // // // //                 size: 20
// // // // // // //                 color: {
// // // // // // //                     if (isClose && btnMouse.containsMouse) return colors.error
// // // // // // //                     return colors.onSurfaceVariant
// // // // // // //                 }
// // // // // // //                 Behavior on color { ColorAnimation { duration: 150 } }
// // // // // // //             }
// // // // // // //         }

// // // // // // //         // macOS style
// // // // // // //         Rectangle {
// // // // // // //             anchors.fill: parent
// // // // // // //             radius: 7
// // // // // // //             visible: variant === "macOS"

// // // // // // //             color: btnMouse.containsMouse ? macColor : Qt.darker(macColor, 1.1)
// // // // // // //             border.width: 0.5
// // // // // // //             border.color: Qt.darker(macColor, 1.3)

// // // // // // //             Behavior on color { ColorAnimation { duration: 100 } }

// // // // // // //             // Show icon on hover for macOS style
// // // // // // //             Icon {
// // // // // // //                 anchors.centerIn: parent
// // // // // // //                 source: btn.icon
// // // // // // //                 size: 8
// // // // // // //                 color: Qt.rgba(0, 0, 0, 0.5)
// // // // // // //                 visible: btnMouse.containsMouse
// // // // // // //                 opacity: btnMouse.containsMouse ? 1 : 0
// // // // // // //                 Behavior on opacity { NumberAnimation { duration: 100 } }
// // // // // // //             }
// // // // // // //         }

// // // // // // //         MouseArea {
// // // // // // //             id: btnMouse
// // // // // // //             anchors.fill: parent
// // // // // // //             hoverEnabled: true
// // // // // // //             cursorShape: Qt.PointingHandCursor
// // // // // // //             onClicked: btn.clicked()
// // // // // // //         }

// // // // // // //         // Tooltip
// // // // // // //         Rectangle {
// // // // // // //             id: tooltip
// // // // // // //             visible: btnMouse.containsMouse && tooltipText !== ""
// // // // // // //             opacity: visible ? 1 : 0

// // // // // // //             x: (parent.width - width) / 2
// // // // // // //             y: parent.height + 8

// // // // // // //             width: tooltipLabel.implicitWidth + 16
// // // // // // //             height: 28
// // // // // // //             radius: 6
// // // // // // //             color: colors.inverseSurface

// // // // // // //             Behavior on opacity { NumberAnimation { duration: 150 } }

// // // // // // //             Text {
// // // // // // //                 id: tooltipLabel
// // // // // // //                 anchors.centerIn: parent
// // // // // // //                 text: tooltipText
// // // // // // //                 font.family: "Roboto"
// // // // // // //                 font.pixelSize: 12
// // // // // // //                 color: colors.inverseOnSurface
// // // // // // //             }
// // // // // // //         }
// // // // // // //     }
// // // // // // // }



// // // // // // // qml/smartui/ui/applicationwindow/WindowControls.qml

// // // // // // import QtQuick
// // // // // // import QtQuick.Window
// // // // // // import "../../theme" as Theme
// // // // // // import "../common"

// // // // // // Item {
// // // // // //     id: root

// // // // // //     property var targetWindow: null
// // // // // //     property var colors: Theme.ChiTheme.colors

// // // // // //     // Icon customization (Material 3 icon names)
// // // // // //     property string minimizeIcon: "remove"
// // // // // //     property string maximizeIcon: "crop_square"
// // // // // //     property string restoreIcon: "filter_none"
// // // // // //     property string closeIcon: "close"

// // // // // //     property bool showMinimize: true
// // // // // //     property bool showMaximize: true
// // // // // //     property bool showClose: true

// // // // // //     // Style: "default", "macOS", "filled"
// // // // // //     property string variant: "default"

// // // // // //     // macOS traffic light colors
// // // // // //     readonly property color macCloseColor: "#FF5F57"
// // // // // //     readonly property color macMinimizeColor: "#FEBC2E"
// // // // // //     readonly property color macMaximizeColor: "#28C840"

// // // // // //     implicitWidth: controlsRow.implicitWidth
// // // // // //     implicitHeight: 40

// // // // // //     Row {
// // // // // //         id: controlsRow
// // // // // //         anchors.centerIn: parent
// // // // // //         spacing: variant === "macOS" ? 8 : 2

// // // // // //         // macOS: Close, Minimize, Maximize (left to right)
// // // // // //         // Windows: Minimize, Maximize, Close (left to right)

// // // // // //         Loader {
// // // // // //             active: variant === "macOS" ? showClose : showMinimize
// // // // // //             sourceComponent: variant === "macOS" ? closeBtn : minimizeBtn
// // // // // //         }

// // // // // //         Loader {
// // // // // //             active: showMinimize && showMaximize
// // // // // //             sourceComponent: variant === "macOS" ? minimizeBtn : maximizeBtn
// // // // // //         }

// // // // // //         Loader {
// // // // // //             active: variant === "macOS" ? showMaximize : showClose
// // // // // //             sourceComponent: variant === "macOS" ? maximizeBtn : closeBtn
// // // // // //         }
// // // // // //     }

// // // // // //     // ═══════════════════════════════════════════════════════════════
// // // // // //     // BUTTON COMPONENTS
// // // // // //     // ═══════════════════════════════════════════════════════════════

// // // // // //     Component {
// // // // // //         id: closeBtn

// // // // // //         WindowControlButton {
// // // // // //             icon: closeIcon
// // // // // //             variant: root.variant
// // // // // //             macColor: macCloseColor
// // // // // //             hoverColor: colors.error
// // // // // //             tooltipText: "Close"
// // // // // //             onClicked: targetWindow?.close()
// // // // // //         }
// // // // // //     }

// // // // // //     Component {
// // // // // //         id: minimizeBtn

// // // // // //         WindowControlButton {
// // // // // //             icon: minimizeIcon
// // // // // //             variant: root.variant
// // // // // //             macColor: macMinimizeColor
// // // // // //             tooltipText: "Minimize"
// // // // // //             onClicked: targetWindow?.showMinimized()
// // // // // //         }
// // // // // //     }

// // // // // //     Component {
// // // // // //         id: maximizeBtn

// // // // // //         WindowControlButton {
// // // // // //             icon: targetWindow?.visibility === Window.Maximized ? restoreIcon : maximizeIcon
// // // // // //             variant: root.variant
// // // // // //             macColor: macMaximizeColor
// // // // // //             tooltipText: targetWindow?.visibility === Window.Maximized ? "Restore" : "Maximize"
// // // // // //             onClicked: {
// // // // // //                 if (targetWindow) {
// // // // // //                     if (targetWindow.visibility === Window.Maximized)
// // // // // //                         targetWindow.showNormal()
// // // // // //                     else
// // // // // //                         targetWindow.showMaximized()
// // // // // //                 }
// // // // // //             }
// // // // // //         }
// // // // // //     }

// // // // // //     // ═══════════════════════════════════════════════════════════════
// // // // // //     // WINDOW CONTROL BUTTON
// // // // // //     // ═══════════════════════════════════════════════════════════════

// // // // // //     component WindowControlButton: Item {
// // // // // //         id: btn

// // // // // //         property string icon: ""
// // // // // //         property string variant: "default"
// // // // // //         property color macColor: "#888"
// // // // // //         property color hoverColor: colors.onSurfaceVariant
// // // // // //         property string tooltipText: ""

// // // // // //         signal clicked()

// // // // // //         width: variant === "macOS" ? 14 : 36
// // // // // //         height: variant === "macOS" ? 14 : 36

// // // // // //         // ─────────────────────────────────────────────────────────
// // // // // //         // DEFAULT / FILLED STYLE
// // // // // //         // ─────────────────────────────────────────────────────────

// // // // // //         Rectangle {
// // // // // //             id: defaultBg
// // // // // //             anchors.fill: parent
// // // // // //             radius: variant === "filled" ? 8 : 18
// // // // // //             visible: variant !== "macOS"

// // // // // //             color: {
// // // // // //                 if (btnMouse.pressed) {
// // // // // //                     return Qt.rgba(hoverColor.r, hoverColor.g, hoverColor.b, 0.2)
// // // // // //                 }
// // // // // //                 if (btnMouse.containsMouse) {
// // // // // //                     return Qt.rgba(hoverColor.r, hoverColor.g, hoverColor.b, 0.12)
// // // // // //                 }
// // // // // //                 return "transparent"
// // // // // //             }

// // // // // //             Behavior on color { ColorAnimation { duration: 120 } }
// // // // // //         }

// // // // // //         Icon {
// // // // // //             visible: variant !== "macOS"
// // // // // //             anchors.centerIn: parent
// // // // // //             source: btn.icon
// // // // // //             size: 18
// // // // // //             color: btnMouse.containsMouse ? hoverColor : colors.onSurfaceVariant

// // // // // //             Behavior on color { ColorAnimation { duration: 120 } }
// // // // // //         }

// // // // // //         // ─────────────────────────────────────────────────────────
// // // // // //         // macOS STYLE (Traffic Lights)
// // // // // //         // ─────────────────────────────────────────────────────────

// // // // // //         Rectangle {
// // // // // //             id: macBg
// // // // // //             anchors.fill: parent
// // // // // //             radius: 7
// // // // // //             visible: variant === "macOS"

// // // // // //             color: {
// // // // // //                 if (!root.targetWindow?.active) {
// // // // // //                     return colors.outlineVariant
// // // // // //                 }
// // // // // //                 return macColor
// // // // // //             }

// // // // // //             border.width: 0.5
// // // // // //             border.color: Qt.darker(macColor, 1.2)

// // // // // //             Behavior on color { ColorAnimation { duration: 150 } }

// // // // // //             // Icon appears on hover
// // // // // //             Icon {
// // // // // //                 anchors.centerIn: parent
// // // // // //                 source: btn.icon
// // // // // //                 size: 8
// // // // // //                 color: Qt.rgba(0, 0, 0, 0.6)
// // // // // //                 opacity: btnMouse.containsMouse && root.targetWindow?.active ? 1 : 0

// // // // // //                 Behavior on opacity { NumberAnimation { duration: 100 } }
// // // // // //             }
// // // // // //         }

// // // // // //         // ─────────────────────────────────────────────────────────
// // // // // //         // INTERACTION
// // // // // //         // ─────────────────────────────────────────────────────────

// // // // // //         MouseArea {
// // // // // //             id: btnMouse
// // // // // //             anchors.fill: parent
// // // // // //             hoverEnabled: true
// // // // // //             cursorShape: Qt.PointingHandCursor
// // // // // //             onClicked: btn.clicked()
// // // // // //         }

// // // // // //         // Tooltip
// // // // // //         Rectangle {
// // // // // //             id: tooltip
// // // // // //             visible: tooltipVisible
// // // // // //             opacity: tooltipVisible ? 1 : 0

// // // // // //             property bool tooltipVisible: btnMouse.containsMouse && tooltipText !== "" && variant !== "macOS"

// // // // // //             x: (parent.width - width) / 2
// // // // // //             y: parent.height + 6
// // // // // //             z: 1000

// // // // // //             width: tooltipLabel.implicitWidth + 12
// // // // // //             height: 24
// // // // // //             radius: 4
// // // // // //             color: colors.inverseSurface

// // // // // //             Behavior on opacity { NumberAnimation { duration: 150 } }

// // // // // //             Text {
// // // // // //                 id: tooltipLabel
// // // // // //                 anchors.centerIn: parent
// // // // // //                 text: tooltipText
// // // // // //                 font.family: "Roboto"
// // // // // //                 font.pixelSize: 11
// // // // // //                 color: colors.inverseOnSurface
// // // // // //             }
// // // // // //         }
// // // // // //     }
// // // // // // }



// // // // // // qml/smartui/ui/applicationwindow/WindowControls.qml

// // // // // import QtQuick
// // // // // import QtQuick.Window
// // // // // import "../../theme" as Theme
// // // // // import "../common"

// // // // // Item {
// // // // //     id: root

// // // // //     property var targetWindow: null
// // // // //     property var colors: Theme.ChiTheme.colors

// // // // //     // Icon customization (Material 3 icon names)
// // // // //     property string minimizeIcon: "remove"
// // // // //     property string maximizeIcon: "crop_square"
// // // // //     property string restoreIcon: "filter_none"
// // // // //     property string closeIcon: "close"

// // // // //     property bool showMinimize: true
// // // // //     property bool showMaximize: true
// // // // //     property bool showClose: true

// // // // //     // Style: "default", "macOS", "filled"
// // // // //     property string variant: "default"

// // // // //     // macOS traffic light colors
// // // // //     readonly property color macCloseColor: "#FF5F57"
// // // // //     readonly property color macMinimizeColor: "#FEBC2E"
// // // // //     readonly property color macMaximizeColor: "#28C840"

// // // // //     implicitWidth: controlsRow.implicitWidth
// // // // //     implicitHeight: 40

// // // // //     Row {
// // // // //         id: controlsRow
// // // // //         anchors.centerIn: parent
// // // // //         spacing: variant === "macOS" ? 8 : 2

// // // // //         // Close (first for macOS, last for Windows)
// // // // //         WindowControlButton {
// // // // //             visible: variant === "macOS" ? showClose : showMinimize
// // // // //             icon: variant === "macOS" ? closeIcon : minimizeIcon
// // // // //             macColor: variant === "macOS" ? macCloseColor : macMinimizeColor
// // // // //             isCloseButton: variant === "macOS"
// // // // //             onClicked: {
// // // // //                 if (variant === "macOS") {
// // // // //                     targetWindow?.close()
// // // // //                 } else {
// // // // //                     targetWindow?.showMinimized()
// // // // //                 }
// // // // //             }
// // // // //         }

// // // // //         // Minimize (middle for macOS) / Maximize (middle for Windows)
// // // // //         WindowControlButton {
// // // // //             visible: showMinimize && showMaximize
// // // // //             icon: variant === "macOS" ? minimizeIcon : (targetWindow?.visibility === Window.Maximized ? restoreIcon : maximizeIcon)
// // // // //             macColor: variant === "macOS" ? macMinimizeColor : macMaximizeColor
// // // // //             onClicked: {
// // // // //                 if (variant === "macOS") {
// // // // //                     targetWindow?.showMinimized()
// // // // //                 } else {
// // // // //                     if (targetWindow) {
// // // // //                         if (targetWindow.visibility === Window.Maximized)
// // // // //                             targetWindow.showNormal()
// // // // //                         else
// // // // //                             targetWindow.showMaximized()
// // // // //                     }
// // // // //                 }
// // // // //             }
// // // // //         }

// // // // //         // Maximize (last for macOS) / Close (last for Windows)
// // // // //         WindowControlButton {
// // // // //             visible: variant === "macOS" ? showMaximize : showClose
// // // // //             icon: variant === "macOS" ? (targetWindow?.visibility === Window.Maximized ? restoreIcon : maximizeIcon) : closeIcon
// // // // //             macColor: variant === "macOS" ? macMaximizeColor : macCloseColor
// // // // //             isCloseButton: variant !== "macOS"
// // // // //             onClicked: {
// // // // //                 if (variant === "macOS") {
// // // // //                     if (targetWindow) {
// // // // //                         if (targetWindow.visibility === Window.Maximized)
// // // // //                             targetWindow.showNormal()
// // // // //                         else
// // // // //                             targetWindow.showMaximized()
// // // // //                     }
// // // // //                 } else {
// // // // //                     targetWindow?.close()
// // // // //                 }
// // // // //             }
// // // // //         }
// // // // //     }

// // // // //     // ═══════════════════════════════════════════════════════════════
// // // // //     // WINDOW CONTROL BUTTON COMPONENT
// // // // //     // ═══════════════════════════════════════════════════════════════

// // // // //     component WindowControlButton: Item {
// // // // //         id: btn

// // // // //         property string icon: ""
// // // // //         property color macColor: "#888"
// // // // //         property bool isCloseButton: false

// // // // //         signal clicked()

// // // // //         width: root.variant === "macOS" ? 14 : 36
// // // // //         height: root.variant === "macOS" ? 14 : 36

// // // // //         // ─────────────────────────────────────────────────────────
// // // // //         // DEFAULT / FILLED STYLE
// // // // //         // ─────────────────────────────────────────────────────────

// // // // //         Rectangle {
// // // // //             anchors.fill: parent
// // // // //             radius: root.variant === "filled" ? 8 : 18
// // // // //             visible: root.variant !== "macOS"

// // // // //             color: {
// // // // //                 var hoverColor = isCloseButton ? colors.error : colors.onSurfaceVariant
// // // // //                 if (btnMouse.pressed) {
// // // // //                     return Qt.rgba(hoverColor.r, hoverColor.g, hoverColor.b, 0.2)
// // // // //                 }
// // // // //                 if (btnMouse.containsMouse) {
// // // // //                     return Qt.rgba(hoverColor.r, hoverColor.g, hoverColor.b, 0.12)
// // // // //                 }
// // // // //                 return "transparent"
// // // // //             }

// // // // //             Behavior on color { ColorAnimation { duration: 120 } }
// // // // //         }

// // // // //         Icon {
// // // // //             visible: root.variant !== "macOS"
// // // // //             anchors.centerIn: parent
// // // // //             source: btn.icon
// // // // //             size: 18
// // // // //             color: {
// // // // //                 if (isCloseButton && btnMouse.containsMouse) {
// // // // //                     return colors.error
// // // // //                 }
// // // // //                 return colors.onSurfaceVariant
// // // // //             }

// // // // //             Behavior on color { ColorAnimation { duration: 120 } }
// // // // //         }

// // // // //         // ─────────────────────────────────────────────────────────
// // // // //         // macOS STYLE (Traffic Lights)
// // // // //         // ─────────────────────────────────────────────────────────

// // // // //         Rectangle {
// // // // //             anchors.fill: parent
// // // // //             radius: 7
// // // // //             visible: root.variant === "macOS"

// // // // //             color: {
// // // // //                 if (root.targetWindow && !root.targetWindow.active) {
// // // // //                     return colors.outlineVariant
// // // // //                 }
// // // // //                 return macColor
// // // // //             }

// // // // //             border.width: 0.5
// // // // //             border.color: Qt.darker(macColor, 1.2)

// // // // //             Behavior on color { ColorAnimation { duration: 150 } }

// // // // //             // Icon appears on hover
// // // // //             Icon {
// // // // //                 anchors.centerIn: parent
// // // // //                 source: btn.icon
// // // // //                 size: 8
// // // // //                 color: Qt.rgba(0, 0, 0, 0.6)
// // // // //                 visible: btnMouse.containsMouse && root.targetWindow && root.targetWindow.active
// // // // //             }
// // // // //         }

// // // // //         // ─────────────────────────────────────────────────────────
// // // // //         // INTERACTION
// // // // //         // ─────────────────────────────────────────────────────────

// // // // //         MouseArea {
// // // // //             id: btnMouse
// // // // //             anchors.fill: parent
// // // // //             hoverEnabled: true
// // // // //             cursorShape: Qt.PointingHandCursor
// // // // //             onClicked: btn.clicked()
// // // // //         }
// // // // //     }
// // // // // }



// // // // ////////////////////////////// last



// // // // // qml/smartui/ui/applicationwindow/WindowControls.qml

// // // // import QtQuick
// // // // import QtQuick.Window
// // // // import "../../theme" as Theme
// // // // import "../common"

// // // // Item {
// // // //     id: root

// // // //     property var targetWindow: null
// // // //     property var colors: Theme.ChiTheme.colors

// // // //     // Icon customization (Material 3 icon names)
// // // //     property string minimizeIcon: "remove"
// // // //     property string maximizeIcon: "crop_square"
// // // //     property string restoreIcon: "filter_none"
// // // //     property string closeIcon: "close"

// // // //     property bool showMinimize: true
// // // //     property bool showMaximize: true
// // // //     property bool showClose: true

// // // //     // Style: "default", "macOS"
// // // //     property string variant: "default"

// // // //     implicitWidth: controlsRow.implicitWidth
// // // //     implicitHeight: 36

// // // //     Row {
// // // //         id: controlsRow
// // // //         anchors.centerIn: parent
// // // //         spacing: variant === "macOS" ? 8 : 0

// // // //         // Order: macOS = close, min, max (left to right)
// // // //         //        default = min, max, close (left to right)

// // // //         Loader {
// // // //             active: variant === "macOS" ? showClose : showMinimize
// // // //             sourceComponent: variant === "macOS" ? macCloseBtn : defaultMinBtn
// // // //         }

// // // //         Loader {
// // // //             active: showMinimize && showMaximize
// // // //             sourceComponent: variant === "macOS" ? macMinBtn : defaultMaxBtn
// // // //         }

// // // //         Loader {
// // // //             active: variant === "macOS" ? showMaximize : showClose
// // // //             sourceComponent: variant === "macOS" ? macMaxBtn : defaultCloseBtn
// // // //         }
// // // //     }

// // // //     // ═══════════════════════════════════════════════════════════════
// // // //     // DEFAULT STYLE BUTTONS (Unique M3 Expressive)
// // // //     // ═══════════════════════════════════════════════════════════════

// // // //     Component {
// // // //         id: defaultMinBtn
// // // //         DefaultControlButton {
// // // //             icon: minimizeIcon
// // // //             tooltipText: "Minimize"
// // // //             buttonType: "minimize"
// // // //             onClicked: targetWindow?.showMinimized()
// // // //         }
// // // //     }

// // // //     Component {
// // // //         id: defaultMaxBtn
// // // //         DefaultControlButton {
// // // //             icon: targetWindow?.visibility === Window.Maximized ? restoreIcon : maximizeIcon
// // // //             tooltipText: targetWindow?.visibility === Window.Maximized ? "Restore" : "Maximize"
// // // //             buttonType: "maximize"
// // // //             onClicked: {
// // // //                 if (targetWindow) {
// // // //                     if (targetWindow.visibility === Window.Maximized)
// // // //                         targetWindow.showNormal()
// // // //                     else
// // // //                         targetWindow.showMaximized()
// // // //                 }
// // // //             }
// // // //         }
// // // //     }

// // // //     Component {
// // // //         id: defaultCloseBtn
// // // //         DefaultControlButton {
// // // //             icon: closeIcon
// // // //             tooltipText: "Close"
// // // //             buttonType: "close"
// // // //             onClicked: targetWindow?.close()
// // // //         }
// // // //     }

// // // //     // ═══════════════════════════════════════════════════════════════
// // // //     // macOS STYLE BUTTONS (Traffic Lights)
// // // //     // ═══════════════════════════════════════════════════════════════

// // // //     Component {
// // // //         id: macCloseBtn
// // // //         MacControlButton {
// // // //             icon: closeIcon
// // // //             baseColor: "#FF5F57"
// // // //             onClicked: targetWindow?.close()
// // // //         }
// // // //     }

// // // //     Component {
// // // //         id: macMinBtn
// // // //         MacControlButton {
// // // //             icon: minimizeIcon
// // // //             baseColor: "#FEBC2E"
// // // //             onClicked: targetWindow?.showMinimized()
// // // //         }
// // // //     }

// // // //     Component {
// // // //         id: macMaxBtn
// // // //         MacControlButton {
// // // //             icon: targetWindow?.visibility === Window.Maximized ? restoreIcon : maximizeIcon
// // // //             baseColor: "#28C840"
// // // //             onClicked: {
// // // //                 if (targetWindow) {
// // // //                     if (targetWindow.visibility === Window.Maximized)
// // // //                         targetWindow.showNormal()
// // // //                     else
// // // //                         targetWindow.showMaximized()
// // // //                 }
// // // //             }
// // // //         }
// // // //     }

// // // //     // ═══════════════════════════════════════════════════════════════
// // // //     // DEFAULT CONTROL BUTTON (M3 Expressive Style)
// // // //     // ═══════════════════════════════════════════════════════════════

// // // //     component DefaultControlButton: Item {
// // // //         id: defBtn

// // // //         property string icon: ""
// // // //         property string tooltipText: ""
// // // //         property string buttonType: "default" // "minimize", "maximize", "close"

// // // //         signal clicked()

// // // //         width: 32
// // // //         height: 32

// // // //         // Background with subtle tonal color
// // // //         Rectangle {
// // // //             id: btnBg
// // // //             anchors.fill: parent
// // // //             radius: 8

// // // //             color: {
// // // //                 // Base state colors based on button type
// // // //                 if (defBtnMouse.pressed) {
// // // //                     if (buttonType === "close")
// // // //                         return Qt.rgba(colors.error.r, colors.error.g, colors.error.b, 0.25)
// // // //                     return Qt.rgba(colors.primary.r, colors.primary.g, colors.primary.b, 0.2)
// // // //                 }
// // // //                 if (defBtnMouse.containsMouse) {
// // // //                     if (buttonType === "close")
// // // //                         return Qt.rgba(colors.error.r, colors.error.g, colors.error.b, 0.15)
// // // //                     return Qt.rgba(colors.onSurfaceVariant.r, colors.onSurfaceVariant.g, colors.onSurfaceVariant.b, 0.1)
// // // //                 }
// // // //                 return "transparent"
// // // //             }

// // // //             Behavior on color {
// // // //                 ColorAnimation { duration: Theme.ChiTheme.motion.durationFast }
// // // //             }
// // // //         }

// // // //         // Icon
// // // //         Icon {
// // // //             anchors.centerIn: parent
// // // //             source: defBtn.icon
// // // //             size: 16

// // // //             color: {
// // // //                 if (buttonType === "close" && defBtnMouse.containsMouse) {
// // // //                     return colors.error
// // // //                 }
// // // //                 if (defBtnMouse.containsMouse) {
// // // //                     return colors.onSurface
// // // //                 }
// // // //                 return colors.onSurfaceVariant
// // // //             }

// // // //             Behavior on color {
// // // //                 ColorAnimation { duration: Theme.ChiTheme.motion.durationFast }
// // // //             }
// // // //         }

// // // //         MouseArea {
// // // //             id: defBtnMouse
// // // //             anchors.fill: parent
// // // //             hoverEnabled: true
// // // //             cursorShape: Qt.PointingHandCursor
// // // //             onClicked: defBtn.clicked()
// // // //         }

// // // //         // Tooltip
// // // //         Rectangle {
// // // //             id: tooltip
// // // //             visible: defBtnMouse.containsMouse && tooltipText !== ""
// // // //             opacity: visible ? 1 : 0

// // // //             x: (parent.width - width) / 2
// // // //             y: parent.height + 6
// // // //             z: 1000

// // // //             width: tooltipLabel.implicitWidth + 12
// // // //             height: 24
// // // //             radius: 6
// // // //             color: colors.inverseSurface

// // // //             Behavior on opacity {
// // // //                 NumberAnimation { duration: Theme.ChiTheme.motion.durationFast }
// // // //             }

// // // //             Text {
// // // //                 id: tooltipLabel
// // // //                 anchors.centerIn: parent
// // // //                 text: tooltipText
// // // //                 font.family: "Roboto"
// // // //                 font.pixelSize: 11
// // // //                 color: colors.inverseOnSurface
// // // //             }
// // // //         }
// // // //     }

// // // //     // ═══════════════════════════════════════════════════════════════
// // // //     // macOS CONTROL BUTTON (Traffic Light Style)
// // // //     // ═══════════════════════════════════════════════════════════════

// // // //     component MacControlButton: Item {
// // // //         id: macBtn

// // // //         property string icon: ""
// // // //         property color baseColor: "#888"

// // // //         signal clicked()

// // // //         width: 12
// // // //         height: 12

// // // //         Rectangle {
// // // //             anchors.fill: parent
// // // //             radius: 6

// // // //             color: {
// // // //                 if (root.targetWindow && !root.targetWindow.active) {
// // // //                     return colors.outlineVariant
// // // //                 }
// // // //                 if (macBtnMouse.pressed) {
// // // //                     return Qt.darker(baseColor, 1.2)
// // // //                 }
// // // //                 return baseColor
// // // //             }

// // // //             border.width: root.targetWindow && root.targetWindow.active ? 0.5 : 0
// // // //             border.color: Qt.darker(baseColor, 1.3)

// // // //             Behavior on color {
// // // //                 ColorAnimation { duration: Theme.ChiTheme.motion.durationFast }
// // // //             }

// // // //             // Symbol on hover
// // // //             Icon {
// // // //                 anchors.centerIn: parent
// // // //                 source: macBtn.icon
// // // //                 size: 7
// // // //                 color: Qt.rgba(0, 0, 0, 0.5)
// // // //                 visible: macBtnMouse.containsMouse && root.targetWindow && root.targetWindow.active
// // // //             }
// // // //         }

// // // //         MouseArea {
// // // //             id: macBtnMouse
// // // //             anchors.fill: parent
// // // //             hoverEnabled: true
// // // //             cursorShape: Qt.PointingHandCursor
// // // //             onClicked: macBtn.clicked()
// // // //         }
// // // //     }
// // // // }





// // // ///////////////////////////////////////////////// second


// // // // qml/smartui/ui/applicationwindow/WindowControls.qml

// // // import QtQuick
// // // import QtQuick.Window
// // // import "../../theme" as Theme
// // // import "../common"

// // // Item {
// // //     id: root

// // //     property var targetWindow: null
// // //     property var colors: Theme.ChiTheme.colors

// // //     // Icons
// // //     property string minimizeIcon: "remove"
// // //     property string maximizeIcon: "crop_square"
// // //     property string restoreIcon: "filter_none"
// // //     property string closeIcon: "close"

// // //     property bool showMinimize: true
// // //     property bool showMaximize: true
// // //     property bool showClose: true

// // //     // Style: "default", "macOS"
// // //     property string variant: "default"

// // //     implicitWidth: controlsRow.implicitWidth
// // //     implicitHeight: 36

// // //     Row {
// // //         id: controlsRow
// // //         anchors.centerIn: parent
// // //         spacing: variant === "macOS" ? 8 : 2

// // //         // Order depends on style
// // //         Loader {
// // //             active: variant === "macOS" ? showClose : showMinimize
// // //             sourceComponent: variant === "macOS" ? macCloseBtn : defaultMinBtn
// // //         }

// // //         Loader {
// // //             active: showMinimize && showMaximize
// // //             sourceComponent: variant === "macOS" ? macMinBtn : defaultMaxBtn
// // //         }

// // //         Loader {
// // //             active: variant === "macOS" ? showMaximize : showClose
// // //             sourceComponent: variant === "macOS" ? macMaxBtn : defaultCloseBtn
// // //         }
// // //     }

// // //     // ═══════════════════════════════════════════════════════════════
// // //     // DEFAULT STYLE BUTTONS (Colorful M3 Expressive)
// // //     // ═══════════════════════════════════════════════════════════════

// // //     Component {
// // //         id: defaultMinBtn

// // //         ExpressiveControlButton {
// // //             icon: minimizeIcon
// // //             tooltipText: "Minimize"
// // //             accentColor: colors.tertiary
// // //             onClicked: targetWindow?.showMinimized()
// // //         }
// // //     }

// // //     Component {
// // //         id: defaultMaxBtn

// // //         ExpressiveControlButton {
// // //             icon: targetWindow?.visibility === Window.Maximized ? restoreIcon : maximizeIcon
// // //             tooltipText: targetWindow?.visibility === Window.Maximized ? "Restore" : "Maximize"
// // //             accentColor: colors.secondary
// // //             onClicked: {
// // //                 if (targetWindow) {
// // //                     if (targetWindow.visibility === Window.Maximized)
// // //                         targetWindow.showNormal()
// // //                     else
// // //                         targetWindow.showMaximized()
// // //                 }
// // //             }
// // //         }
// // //     }

// // //     Component {
// // //         id: defaultCloseBtn

// // //         ExpressiveControlButton {
// // //             icon: closeIcon
// // //             tooltipText: "Close"
// // //             accentColor: colors.error
// // //             isClose: true
// // //             onClicked: targetWindow?.close()
// // //         }
// // //     }

// // //     // ═══════════════════════════════════════════════════════════════
// // //     // macOS STYLE BUTTONS (Traffic Lights)
// // //     // ═══════════════════════════════════════════════════════════════

// // //     Component {
// // //         id: macCloseBtn

// // //         MacControlButton {
// // //             icon: closeIcon
// // //             baseColor: "#FF5F57"
// // //             onClicked: targetWindow?.close()
// // //         }
// // //     }

// // //     Component {
// // //         id: macMinBtn

// // //         MacControlButton {
// // //             icon: minimizeIcon
// // //             baseColor: "#FEBC2E"
// // //             onClicked: targetWindow?.showMinimized()
// // //         }
// // //     }

// // //     Component {
// // //         id: macMaxBtn

// // //         MacControlButton {
// // //             icon: targetWindow?.visibility === Window.Maximized ? restoreIcon : maximizeIcon
// // //             baseColor: "#28C840"
// // //             onClicked: {
// // //                 if (targetWindow) {
// // //                     if (targetWindow.visibility === Window.Maximized)
// // //                         targetWindow.showNormal()
// // //                     else
// // //                         targetWindow.showMaximized()
// // //                 }
// // //             }
// // //         }
// // //     }

// // //     // ═══════════════════════════════════════════════════════════════
// // //     // EXPRESSIVE CONTROL BUTTON (Colorful Default Style)
// // //     // ═══════════════════════════════════════════════════════════════

// // //     component ExpressiveControlButton: Item {
// // //         id: expBtn

// // //         property string icon: ""
// // //         property string tooltipText: ""
// // //         property color accentColor: colors.primary
// // //         property bool isClose: false

// // //         signal clicked()

// // //         width: 32
// // //         height: 32

// // //         Rectangle {
// // //             id: btnBg
// // //             anchors.fill: parent
// // //             radius: 8

// // //             // Subtle tint in normal state, stronger on hover
// // //             color: {
// // //                 if (expBtnMouse.pressed) {
// // //                     return Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.25)
// // //                 }
// // //                 if (expBtnMouse.containsMouse) {
// // //                     return Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.18)
// // //                 }
// // //                 // Subtle ambient tint
// // //                 return Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.06)
// // //             }

// // //             Behavior on color { ColorAnimation { duration: 150 } }

// // //             // Subtle border on hover
// // //             border.width: expBtnMouse.containsMouse ? 1 : 0
// // //             border.color: Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.3)

// // //             Behavior on border.width { NumberAnimation { duration: 100 } }
// // //         }

// // //         Icon {
// // //             anchors.centerIn: parent
// // //             source: expBtn.icon
// // //             size: 16

// // //             color: {
// // //                 if (expBtnMouse.containsMouse || expBtnMouse.pressed) {
// // //                     return accentColor
// // //                 }
// // //                 return colors.onSurfaceVariant
// // //             }

// // //             Behavior on color { ColorAnimation { duration: 150 } }

// // //             // Subtle scale on hover
// // //             scale: expBtnMouse.containsMouse ? 1.1 : 1.0
// // //             Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
// // //         }

// // //         MouseArea {
// // //             id: expBtnMouse
// // //             anchors.fill: parent
// // //             hoverEnabled: true
// // //             cursorShape: Qt.PointingHandCursor
// // //             onClicked: expBtn.clicked()
// // //         }

// // //         // Tooltip
// // //         Rectangle {
// // //             visible: expBtnMouse.containsMouse && tooltipText !== ""
// // //             opacity: visible ? 1 : 0

// // //             x: (parent.width - width) / 2
// // //             y: parent.height + 6
// // //             z: 1000

// // //             width: tooltipLabel.implicitWidth + 12
// // //             height: 24
// // //             radius: 6
// // //             color: colors.inverseSurface

// // //             Behavior on opacity { NumberAnimation { duration: 150 } }

// // //             Text {
// // //                 id: tooltipLabel
// // //                 anchors.centerIn: parent
// // //                 text: tooltipText
// // //                 font.family: "Roboto"
// // //                 font.pixelSize: 11
// // //                 color: colors.inverseOnSurface
// // //             }
// // //         }
// // //     }

// // //     // ═══════════════════════════════════════════════════════════════
// // //     // macOS CONTROL BUTTON (Traffic Light Style)
// // //     // ═══════════════════════════════════════════════════════════════

// // //     component MacControlButton: Item {
// // //         id: macBtn

// // //         property string icon: ""
// // //         property color baseColor: "#888"

// // //         signal clicked()

// // //         width: 12
// // //         height: 12

// // //         Rectangle {
// // //             anchors.fill: parent
// // //             radius: 6

// // //             color: {
// // //                 if (root.targetWindow && !root.targetWindow.active) {
// // //                     return colors.outlineVariant
// // //                 }
// // //                 if (macBtnMouse.pressed) {
// // //                     return Qt.darker(baseColor, 1.2)
// // //                 }
// // //                 return baseColor
// // //             }

// // //             border.width: root.targetWindow && root.targetWindow.active ? 0.5 : 0
// // //             border.color: Qt.darker(baseColor, 1.3)

// // //             Behavior on color { ColorAnimation { duration: 150 } }

// // //             Icon {
// // //                 anchors.centerIn: parent
// // //                 source: macBtn.icon
// // //                 size: 7
// // //                 color: Qt.rgba(0, 0, 0, 0.5)
// // //                 visible: macBtnMouse.containsMouse && root.targetWindow && root.targetWindow.active
// // //             }
// // //         }

// // //         MouseArea {
// // //             id: macBtnMouse
// // //             anchors.fill: parent
// // //             hoverEnabled: true
// // //             cursorShape: Qt.PointingHandCursor
// // //             onClicked: macBtn.clicked()
// // //         }
// // //     }
// // // }





// // //////////////////////////////////// thrid



// // // qml/smartui/ui/applicationwindow/WindowControls.qml

// // import QtQuick
// // import QtQuick.Window
// // import "../../theme" as Theme
// // import "../common"

// // Item {
// //     id: root

// //     property var targetWindow: null
// //     property var colors: Theme.ChiTheme.colors

// //     // Icons
// //     property string minimizeIcon: "remove"
// //     property string maximizeIcon: "crop_square"
// //     property string restoreIcon: "filter_none"
// //     property string closeIcon: "close"

// //     property bool showMinimize: true
// //     property bool showMaximize: true
// //     property bool showClose: true

// //     // Style: "macOS" (default), "windows"
// //     property string variant: "macOS"

// //     implicitWidth: controlsRow.implicitWidth
// //     implicitHeight: variant === "macOS" ? 20 : 36

// //     Row {
// //         id: controlsRow
// //         anchors.centerIn: parent
// //         spacing: variant === "macOS" ? 8 : 2

// //         // macOS: Close, Minimize, Maximize (left to right)
// //         // Windows: Minimize, Maximize, Close (left to right)

// //         Loader {
// //             active: variant === "macOS" ? showClose : showMinimize
// //             sourceComponent: variant === "macOS" ? macCloseBtn : winMinBtn
// //         }

// //         Loader {
// //             active: showMinimize && showMaximize
// //             sourceComponent: variant === "macOS" ? macMinBtn : winMaxBtn
// //         }

// //         Loader {
// //             active: variant === "macOS" ? showMaximize : showClose
// //             sourceComponent: variant === "macOS" ? macMaxBtn : winCloseBtn
// //         }
// //     }

// //     // ═══════════════════════════════════════════════════════════════
// //     // macOS STYLE (Traffic Lights) - DEFAULT
// //     // ═══════════════════════════════════════════════════════════════

// //     Component {
// //         id: macCloseBtn

// //         TrafficLightButton {
// //             baseColor: "#FF5F57"
// //             icon: closeIcon
// //             onClicked: targetWindow?.close()
// //         }
// //     }

// //     Component {
// //         id: macMinBtn

// //         TrafficLightButton {
// //             baseColor: "#FEBC2E"
// //             icon: minimizeIcon
// //             onClicked: targetWindow?.showMinimized()
// //         }
// //     }

// //     Component {
// //         id: macMaxBtn

// //         TrafficLightButton {
// //             baseColor: "#28C840"
// //             icon: targetWindow?.visibility === Window.Maximized ? restoreIcon : maximizeIcon
// //             onClicked: {
// //                 if (targetWindow) {
// //                     if (targetWindow.visibility === Window.Maximized)
// //                         targetWindow.showNormal()
// //                     else
// //                         targetWindow.showMaximized()
// //                 }
// //             }
// //         }
// //     }

// //     // ═══════════════════════════════════════════════════════════════
// //     // WINDOWS STYLE
// //     // ═══════════════════════════════════════════════════════════════

// //     Component {
// //         id: winMinBtn

// //         WindowsButton {
// //             icon: minimizeIcon
// //             accentColor: colors.tertiary
// //             onClicked: targetWindow?.showMinimized()
// //         }
// //     }

// //     Component {
// //         id: winMaxBtn

// //         WindowsButton {
// //             icon: targetWindow?.visibility === Window.Maximized ? restoreIcon : maximizeIcon
// //             accentColor: colors.secondary
// //             onClicked: {
// //                 if (targetWindow) {
// //                     if (targetWindow.visibility === Window.Maximized)
// //                         targetWindow.showNormal()
// //                     else
// //                         targetWindow.showMaximized()
// //                 }
// //             }
// //         }
// //     }

// //     Component {
// //         id: winCloseBtn

// //         WindowsButton {
// //             icon: closeIcon
// //             accentColor: colors.error
// //             isClose: true
// //             onClicked: targetWindow?.close()
// //         }
// //     }

// //     // ═══════════════════════════════════════════════════════════════
// //     // TRAFFIC LIGHT BUTTON (macOS Style)
// //     // ═══════════════════════════════════════════════════════════════

// //     component TrafficLightButton: Item {
// //         id: tlBtn

// //         property color baseColor: "#888"
// //         property string icon: ""

// //         signal clicked()

// //         width: 12
// //         height: 12

// //         Rectangle {
// //             id: tlBg
// //             anchors.fill: parent
// //             radius: 6

// //             color: {
// //                 if (root.targetWindow && !root.targetWindow.active) {
// //                     return colors.outlineVariant
// //                 }
// //                 if (tlMouse.pressed) {
// //                     return Qt.darker(baseColor, 1.25)
// //                 }
// //                 if (tlMouse.containsMouse) {
// //                     return Qt.lighter(baseColor, 1.1)
// //                 }
// //                 return baseColor
// //             }

// //             border.width: root.targetWindow && root.targetWindow.active ? 0.5 : 0
// //             border.color: Qt.darker(baseColor, 1.4)

// //             Behavior on color { ColorAnimation { duration: 100 } }

// //             // Icon on hover
// //             Icon {
// //                 anchors.centerIn: parent
// //                 source: tlBtn.icon
// //                 size: 7
// //                 color: Qt.rgba(0, 0, 0, 0.55)
// //                 visible: tlMouse.containsMouse && root.targetWindow && root.targetWindow.active
// //             }
// //         }

// //         MouseArea {
// //             id: tlMouse
// //             anchors.fill: parent
// //             hoverEnabled: true
// //             cursorShape: Qt.PointingHandCursor
// //             onClicked: tlBtn.clicked()
// //         }
// //     }

// //     // ═══════════════════════════════════════════════════════════════
// //     // WINDOWS BUTTON (Alternative Style)
// //     // ═══════════════════════════════════════════════════════════════

// //     component WindowsButton: Item {
// //         id: winBtn

// //         property string icon: ""
// //         property color accentColor: colors.primary
// //         property bool isClose: false

// //         signal clicked()

// //         width: 32
// //         height: 32

// //         Rectangle {
// //             anchors.fill: parent
// //             radius: 8

// //             color: {
// //                 if (winBtnMouse.pressed) {
// //                     return Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.25)
// //                 }
// //                 if (winBtnMouse.containsMouse) {
// //                     return Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.15)
// //                 }
// //                 return Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.05)
// //             }

// //             Behavior on color { ColorAnimation { duration: 120 } }
// //         }

// //         Icon {
// //             anchors.centerIn: parent
// //             source: winBtn.icon
// //             size: 16

// //             color: {
// //                 if (winBtnMouse.containsMouse) {
// //                     return accentColor
// //                 }
// //                 return colors.onSurfaceVariant
// //             }

// //             Behavior on color { ColorAnimation { duration: 120 } }
// //         }

// //         MouseArea {
// //             id: winBtnMouse
// //             anchors.fill: parent
// //             hoverEnabled: true
// //             cursorShape: Qt.PointingHandCursor
// //             onClicked: winBtn.clicked()
// //         }
// //     }
// // }




// /////////////////////////////////////////////////v fourth




// // qml/smartui/ui/applicationwindow/WindowControls.qml

// import QtQuick
// import QtQuick.Window
// import "../../theme" as Theme
// import "../common"

// Item {
//     id: root

//     property var targetWindow: null
//     property var colors: Theme.ChiTheme.colors

//     // Icons
//     property string minimizeIcon: "remove"
//     property string maximizeIcon: "crop_square"
//     property string restoreIcon: "filter_none"
//     property string closeIcon: "close"

//     property bool showMinimize: true
//     property bool showMaximize: true
//     property bool showClose: true

//     // Style: "macOS" is DEFAULT
//     property string variant: "macOS"

//     implicitWidth: controlsRow.implicitWidth
//     implicitHeight: variant === "macOS" ? 20 : 36

//     Row {
//         id: controlsRow
//         anchors.centerIn: parent
//         spacing: variant === "macOS" ? 8 : 2

//         // macOS: Close, Minimize, Maximize (left to right)
//         // windows: Minimize, Maximize, Close (left to right)

//         Loader {
//             active: variant === "macOS" ? showClose : showMinimize
//             sourceComponent: variant === "macOS" ? macCloseBtn : winMinBtn
//         }

//         Loader {
//             active: showMinimize && showMaximize
//             sourceComponent: variant === "macOS" ? macMinBtn : winMaxBtn
//         }

//         Loader {
//             active: variant === "macOS" ? showMaximize : showClose
//             sourceComponent: variant === "macOS" ? macMaxBtn : winCloseBtn
//         }
//     }

//     // ═══════════════════════════════════════════════════════════════
//     // macOS STYLE (Traffic Lights) - DEFAULT
//     // ═══════════════════════════════════════════════════════════════

//     Component {
//         id: macCloseBtn
//         TrafficLightButton {
//             baseColor: "#FF5F57"
//             icon: closeIcon
//             onClicked: targetWindow?.close()
//         }
//     }

//     Component {
//         id: macMinBtn
//         TrafficLightButton {
//             baseColor: "#FEBC2E"
//             icon: minimizeIcon
//             onClicked: targetWindow?.showMinimized()
//         }
//     }

//     Component {
//         id: macMaxBtn
//         TrafficLightButton {
//             baseColor: "#28C840"
//             icon: targetWindow?.visibility === Window.Maximized ? restoreIcon : maximizeIcon
//             onClicked: {
//                 if (targetWindow) {
//                     if (targetWindow.visibility === Window.Maximized)
//                         targetWindow.showNormal()
//                     else
//                         targetWindow.showMaximized()
//                 }
//             }
//         }
//     }

//     // ═══════════════════════════════════════════════════════════════
//     // WINDOWS STYLE
//     // ═══════════════════════════════════════════════════════════════

//     Component {
//         id: winMinBtn
//         WindowsButton {
//             icon: minimizeIcon
//             accentColor: colors.tertiary
//             onClicked: targetWindow?.showMinimized()
//         }
//     }

//     Component {
//         id: winMaxBtn
//         WindowsButton {
//             icon: targetWindow?.visibility === Window.Maximized ? restoreIcon : maximizeIcon
//             accentColor: colors.secondary
//             onClicked: {
//                 if (targetWindow) {
//                     if (targetWindow.visibility === Window.Maximized)
//                         targetWindow.showNormal()
//                     else
//                         targetWindow.showMaximized()
//                 }
//             }
//         }
//     }

//     Component {
//         id: winCloseBtn
//         WindowsButton {
//             icon: closeIcon
//             accentColor: colors.error
//             onClicked: targetWindow?.close()
//         }
//     }

//     // ═══════════════════════════════════════════════════════════════
//     // TRAFFIC LIGHT BUTTON (macOS Style)
//     // ═══════════════════════════════════════════════════════════════

//     component TrafficLightButton: Item {
//         id: tlBtn

//         property color baseColor: "#888"
//         property string icon: ""

//         signal clicked()

//         width: 12
//         height: 12

//         Rectangle {
//             anchors.fill: parent
//             radius: 6

//             color: {
//                 if (root.targetWindow && !root.targetWindow.active) {
//                     return colors.outlineVariant
//                 }
//                 if (tlMouse.pressed) {
//                     return Qt.darker(baseColor, 1.25)
//                 }
//                 if (tlMouse.containsMouse) {
//                     return Qt.lighter(baseColor, 1.1)
//                 }
//                 return baseColor
//             }

//             border.width: root.targetWindow && root.targetWindow.active ? 0.5 : 0
//             border.color: Qt.darker(baseColor, 1.4)

//             // Icon on hover
//             Icon {
//                 anchors.centerIn: parent
//                 source: tlBtn.icon
//                 size: 7
//                 color: Qt.rgba(0, 0, 0, 0.55)
//                 visible: tlMouse.containsMouse && root.targetWindow && root.targetWindow.active
//             }
//         }

//         MouseArea {
//             id: tlMouse
//             anchors.fill: parent
//             hoverEnabled: true
//             cursorShape: Qt.PointingHandCursor
//             onClicked: tlBtn.clicked()
//         }
//     }

//     // ═══════════════════════════════════════════════════════════════
//     // WINDOWS BUTTON (Alternative Style)
//     // ═══════════════════════════════════════════════════════════════

//     component WindowsButton: Item {
//         id: winBtn

//         property string icon: ""
//         property color accentColor: colors.primary

//         signal clicked()

//         width: 32
//         height: 32

//         Rectangle {
//             anchors.fill: parent
//             radius: 8

//             color: {
//                 if (winBtnMouse.pressed) {
//                     return Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.25)
//                 }
//                 if (winBtnMouse.containsMouse) {
//                     return Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.15)
//                 }
//                 return Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.05)
//             }
//         }

//         Icon {
//             anchors.centerIn: parent
//             source: winBtn.icon
//             size: 16
//             color: winBtnMouse.containsMouse ? accentColor : colors.onSurfaceVariant
//         }

//         MouseArea {
//             id: winBtnMouse
//             anchors.fill: parent
//             hoverEnabled: true
//             cursorShape: Qt.PointingHandCursor
//             onClicked: winBtn.clicked()
//         }
//     }
// }


////////////////////////////////// fifth




// qml/smartui/ui/applicationwindow/WindowControls.qml

import QtQuick
import QtQuick.Window
import "../../theme" as Theme
import "../common"

Item {
    id: root

    property var targetWindow: null
    property var colors: Theme.ChiTheme.colors

    property string minimizeIcon: "remove"
    property string maximizeIcon: "crop_square"
    property string restoreIcon: "filter_none"
    property string closeIcon: "close"

    property bool showMinimize: true
    property bool showMaximize: true
    property bool showClose: true

    // macOS is DEFAULT
    property string variant: "macOS"

    implicitWidth: controlsRow.implicitWidth
    implicitHeight: variant === "macOS" ? 20 : 36

    Row {
        id: controlsRow
        anchors.centerIn: parent
        spacing: variant === "macOS" ? 8 : 2

        Loader {
            active: variant === "macOS" ? showClose : showMinimize
            sourceComponent: variant === "macOS" ? macCloseBtn : winMinBtn
        }

        Loader {
            active: showMinimize && showMaximize
            sourceComponent: variant === "macOS" ? macMinBtn : winMaxBtn
        }

        Loader {
            active: variant === "macOS" ? showMaximize : showClose
            sourceComponent: variant === "macOS" ? macMaxBtn : winCloseBtn
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // macOS STYLE (Traffic Lights) - DEFAULT
    // ═══════════════════════════════════════════════════════════════

    Component {
        id: macCloseBtn
        TrafficLightButton {
            baseColor: "#FF5F57"
            icon: closeIcon
            onClicked: targetWindow?.close()
        }
    }

    Component {
        id: macMinBtn
        TrafficLightButton {
            baseColor: "#FEBC2E"
            icon: minimizeIcon
            onClicked: targetWindow?.showMinimized()
        }
    }

    Component {
        id: macMaxBtn
        TrafficLightButton {
            baseColor: "#28C840"
            icon: targetWindow?.visibility === Window.Maximized ? restoreIcon : maximizeIcon
            onClicked: {
                if (targetWindow) {
                    if (targetWindow.visibility === Window.Maximized)
                        targetWindow.showNormal()
                    else
                        targetWindow.showMaximized()
                }
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // WINDOWS STYLE
    // ═══════════════════════════════════════════════════════════════

    Component {
        id: winMinBtn
        WindowsButton {
            icon: minimizeIcon
            accentColor: colors.tertiary
            onClicked: targetWindow?.showMinimized()
        }
    }

    Component {
        id: winMaxBtn
        WindowsButton {
            icon: targetWindow?.visibility === Window.Maximized ? restoreIcon : maximizeIcon
            accentColor: colors.secondary
            onClicked: {
                if (targetWindow) {
                    if (targetWindow.visibility === Window.Maximized)
                        targetWindow.showNormal()
                    else
                        targetWindow.showMaximized()
                }
            }
        }
    }

    Component {
        id: winCloseBtn
        WindowsButton {
            icon: closeIcon
            accentColor: colors.error
            onClicked: targetWindow?.close()
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // TRAFFIC LIGHT BUTTON (macOS Style)
    // ═══════════════════════════════════════════════════════════════

    component TrafficLightButton: Item {
        id: tlBtn

        property color baseColor: "#888"
        property string icon: ""

        signal clicked()

        width: 12
        height: 12

        Rectangle {
            anchors.fill: parent
            radius: 6

            color: {
                if (root.targetWindow && !root.targetWindow.active) {
                    return colors.outlineVariant
                }
                if (tlMouse.pressed) {
                    return Qt.darker(baseColor, 1.25)
                }
                if (tlMouse.containsMouse) {
                    return Qt.lighter(baseColor, 1.1)
                }
                return baseColor
            }

            border.width: root.targetWindow && root.targetWindow.active ? 0.5 : 0
            border.color: Qt.darker(baseColor, 1.4)

            Icon {
                anchors.centerIn: parent
                source: tlBtn.icon
                size: 7
                color: Qt.rgba(0, 0, 0, 0.55)
                visible: tlMouse.containsMouse && root.targetWindow && root.targetWindow.active
            }
        }

        MouseArea {
            id: tlMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: tlBtn.clicked()
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // WINDOWS BUTTON
    // ═══════════════════════════════════════════════════════════════

    component WindowsButton: Item {
        id: winBtn

        property string icon: ""
        property color accentColor: colors.primary

        signal clicked()

        width: 32
        height: 32

        Rectangle {
            anchors.fill: parent
            radius: 8

            color: {
                if (winBtnMouse.pressed) {
                    return Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.25)
                }
                if (winBtnMouse.containsMouse) {
                    return Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.15)
                }
                return Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.05)
            }
        }

        Icon {
            anchors.centerIn: parent
            source: winBtn.icon
            size: 16
            color: winBtnMouse.containsMouse ? accentColor : colors.onSurfaceVariant
        }

        MouseArea {
            id: winBtnMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: winBtn.clicked()
        }
    }
}
