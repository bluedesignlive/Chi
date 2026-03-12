// // import QtQuick
// // import QtQuick.Layouts
// // import Qt5Compat.GraphicalEffects
// // import "../common" as Common
// // import "../theme" as Theme

// // Item {
// //     id: root

// //     property string title: ""
// //     property string supportingText: ""
// //     property string icon: ""

// //     property bool open: false
// //     property bool modal: true
// //     property bool closeOnOverlayClick: true
// //     property bool closeOnEscape: true

// //     property string type: "basic"  // "basic", "fullscreen", "assistant"
// //     property string size: "medium" // "small", "medium", "large"
// //     property string position: "center"

// //     property string confirmText: "Save"
// //     property bool showCloseButton: true
// //     property bool showHeaderDivider: false
// //     property bool showActionsDivider: false

// //     property Component content: null
    
// //     // Actions row - defined at root level so alias works
// //     default property alias actions: theActionsRow.children

// //     signal opened()
// //     signal closed()
// //     signal accepted()
// //     signal rejected()

// //     readonly property var sizeSpecs: ({
// //         small: { width: 280, maxHeight: 400 },
// //         medium: { width: 400, maxHeight: 560 },
// //         large: { width: 560, maxHeight: 720 }
// //     })
// //     readonly property var currentSize: sizeSpecs[size] || sizeSpecs.medium
// //     readonly property bool isFullscreen: type === "fullscreen"
// //     readonly property bool isAssistant: type === "assistant"
// //     readonly property bool hasIcon: icon !== ""
// //     readonly property bool hasTitle: title !== ""
// //     readonly property bool hasSupportingText: supportingText !== ""
// //     readonly property bool hasContent: content !== null
// //     readonly property bool hasActions: theActionsRow.children.length > 0

// //     property var colors: Theme.ChiTheme.colors

// //     width: 0
// //     height: 0
// //     visible: false

// //     property Item appWindow: {
// //         var p = root.parent
// //         while (p) {
// //             if (p.toString().indexOf("Window") !== -1) return p
// //             if (!p.parent) return p
// //             p = p.parent
// //         }
// //         return null
// //     }

// //     // The actual actions row - at root level
// //     Row {
// //         id: theActionsRow
// //         spacing: 8
// //         visible: false
// //         layoutDirection: Qt.LeftToRight
// //     }

// //     // Scrim overlay
// //     Rectangle {
// //         id: scrim
// //         parent: root.appWindow || root.parent
// //         anchors.fill: parent
// //         color: root.colors.scrim
// //         opacity: root.open ? 0.32 : 0
// //         visible: root.open
// //         z: 9998

// //         Behavior on opacity { NumberAnimation { duration: 200 } }

// //         MouseArea {
// //             anchors.fill: parent
// //             enabled: root.modal && root.closeOnOverlayClick && !root.isFullscreen
// //             onClicked: { root.rejected(); root.close() }
// //         }
// //     }

// //     // ==================== BASIC DIALOG ====================
// //     Rectangle {
// //         id: basicDialog
// //         visible: root.open && !root.isFullscreen && !root.isAssistant
// //         parent: root.appWindow || root.parent
// //         z: 9999

// //         anchors.centerIn: root.position === "center" ? parent : undefined
// //         anchors.horizontalCenter: root.position !== "center" ? parent.horizontalCenter : undefined
// //         anchors.top: root.position === "top" ? parent.top : undefined
// //         anchors.bottom: root.position === "bottom" ? parent.bottom : undefined
// //         anchors.topMargin: root.position === "top" ? 56 : 0
// //         anchors.bottomMargin: root.position === "bottom" ? 56 : 0

// //         width: Math.min(root.currentSize.width, (parent ? parent.width : 400) - 48)
// //         height: Math.min(basicContentCol.implicitHeight, root.currentSize.maxHeight, (parent ? parent.height : 600) - 96)
// //         radius: 28
// //         color: root.colors.surfaceContainerHigh
// //         clip: true

// //         layer.enabled: true
// //         layer.effect: DropShadow {
// //             transparentBorder: true
// //             horizontalOffset: 0
// //             verticalOffset: 8
// //             radius: 24
// //             samples: 25
// //             color: Qt.rgba(0, 0, 0, 0.25)
// //         }

// //         Column {
// //             id: basicContentCol
// //             width: parent.width
// //             spacing: 0

// //             // Icon
// //             Item {
// //                 visible: root.hasIcon
// //                 width: parent.width
// //                 height: 48

// //                 Common.Icon {
// //                     anchors.centerIn: parent
// //                     anchors.topMargin: 24
// //                     source: root.icon
// //                     size: 24
// //                     color: root.colors.secondary
// //                 }
// //             }

// //             // Title
// //             Text {
// //                 visible: root.hasTitle
// //                 text: root.title
// //                 font.family: "Roboto"
// //                 font.pixelSize: 24
// //                 color: root.colors.onSurface
// //                 wrapMode: Text.WordWrap
// //                 horizontalAlignment: root.hasIcon ? Text.AlignHCenter : Text.AlignLeft
// //                 width: parent.width - 48
// //                 x: 24
// //                 topPadding: root.hasIcon ? 0 : 24
// //             }

// //             // Header Divider
// //             Rectangle {
// //                 visible: root.showHeaderDivider && root.hasTitle
// //                 width: parent.width
// //                 height: 1
// //                 color: root.colors.outlineVariant
// //                 y: 16
// //             }

// //             // Spacer after title
// //             Item {
// //                 width: parent.width
// //                 height: root.hasTitle ? 16 : 0
// //             }

// //             // Supporting Text
// //             Text {
// //                 visible: root.hasSupportingText
// //                 text: root.supportingText
// //                 font.family: "Roboto"
// //                 font.pixelSize: 14
// //                 color: root.colors.onSurfaceVariant
// //                 wrapMode: Text.WordWrap
// //                 width: parent.width - 48
// //                 x: 24
// //                 topPadding: root.hasTitle ? 0 : 24
// //             }

// //             // Spacer after supporting text
// //             Item {
// //                 width: parent.width
// //                 height: (root.hasTitle || root.hasSupportingText) ? 16 : 0
// //             }

// //             // Content Loader
// //             Item {
// //                 visible: root.hasContent
// //                 width: parent.width - 48
// //                 x: 24
// //                 height: basicContentLoader.item ? Math.min(basicContentLoader.item.implicitHeight, 300) : 0

// //                 Loader {
// //                     id: basicContentLoader
// //                     width: parent.width
// //                     sourceComponent: root.open && !root.isFullscreen && !root.isAssistant ? root.content : null
// //                 }
// //             }

// //             // Spacer before actions
// //             Item {
// //                 width: parent.width
// //                 height: root.hasContent ? 16 : 0
// //             }

// //             // Actions Divider
// //             Rectangle {
// //                 visible: root.showActionsDivider && root.hasActions
// //                 width: parent.width
// //                 height: 1
// //                 color: root.colors.outlineVariant
// //             }

// //             // Actions Area
// //             Item {
// //                 id: basicActionsArea
// //                 width: parent.width
// //                 height: root.hasActions ? 72 : 24
// //             }
// //         }
// //     }

// //     // ==================== FULLSCREEN DIALOG ====================
// //     Rectangle {
// //         id: fullscreenDialog
// //         visible: root.open && root.isFullscreen
// //         parent: root.appWindow || root.parent
// //         anchors.fill: parent
// //         z: 9999
// //         color: root.colors.surfaceContainerHigh

// //         Column {
// //             anchors.fill: parent
// //             spacing: 0

// //             // Header Bar
// //             Rectangle {
// //                 width: parent.width
// //                 height: 56
// //                 color: root.colors.surfaceContainerHigh

// //                 Row {
// //                     anchors.fill: parent
// //                     anchors.leftMargin: 8
// //                     anchors.rightMargin: 16
// //                     spacing: 8

// //                     // Close Button
// //                     Rectangle {
// //                         visible: root.showCloseButton
// //                         width: 48
// //                         height: 48
// //                         radius: 24
// //                         anchors.verticalCenter: parent.verticalCenter
// //                         color: fsCloseMA.containsMouse ? Qt.alpha(root.colors.onSurface, 0.08) : "transparent"

// //                         Common.Icon {
// //                             anchors.centerIn: parent
// //                             source: "close"
// //                             size: 24
// //                             color: root.colors.onSurface
// //                         }

// //                         MouseArea {
// //                             id: fsCloseMA
// //                             anchors.fill: parent
// //                             hoverEnabled: true
// //                             cursorShape: Qt.PointingHandCursor
// //                             onClicked: { root.rejected(); root.close() }
// //                         }
// //                     }

// //                     // Title
// //                     Text {
// //                         text: root.title
// //                         font.family: "Roboto"
// //                         font.pixelSize: 22
// //                         color: root.colors.onSurface
// //                         elide: Text.ElideRight
// //                         anchors.verticalCenter: parent.verticalCenter
// //                         width: parent.width - 150
// //                     }

// //                     Item { width: 1; height: 1; Layout.fillWidth: true }

// //                     // Confirm Button
// //                     Rectangle {
// //                         visible: root.confirmText !== ""
// //                         width: fsConfirmText.implicitWidth + 32
// //                         height: 40
// //                         radius: 20
// //                         anchors.verticalCenter: parent.verticalCenter
// //                         color: fsConfirmMA.containsMouse ? Qt.alpha(root.colors.primary, 0.08) : "transparent"

// //                         Text {
// //                             id: fsConfirmText
// //                             anchors.centerIn: parent
// //                             text: root.confirmText
// //                             font.family: "Roboto"
// //                             font.pixelSize: 14
// //                             font.weight: Font.Medium
// //                             color: root.colors.primary
// //                         }

// //                         MouseArea {
// //                             id: fsConfirmMA
// //                             anchors.fill: parent
// //                             hoverEnabled: true
// //                             cursorShape: Qt.PointingHandCursor
// //                             onClicked: { root.accepted(); root.close() }
// //                         }
// //                     }
// //                 }

// //                 // Header Divider
// //                 Rectangle {
// //                     visible: root.showHeaderDivider
// //                     anchors.bottom: parent.bottom
// //                     width: parent.width
// //                     height: 1
// //                     color: root.colors.outlineVariant
// //                 }
// //             }

// //             // Scrollable Content
// //             Flickable {
// //                 width: parent.width
// //                 height: parent.height - 56
// //                 contentHeight: fsContentLoader.item ? fsContentLoader.item.implicitHeight + 48 : parent.height
// //                 clip: true
// //                 boundsBehavior: Flickable.StopAtBounds

// //                 Loader {
// //                     id: fsContentLoader
// //                     x: 24
// //                     y: 24
// //                     width: parent.width - 48
// //                     sourceComponent: root.open && root.isFullscreen ? root.content : null
// //                 }
// //             }
// //         }
// //     }

// //     // ==================== ASSISTANT DIALOG ====================
// //     Rectangle {
// //         id: assistantDialog
// //         visible: root.open && root.isAssistant
// //         parent: root.appWindow || root.parent
// //         z: 9999

// //         anchors.centerIn: parent
// //         width: Math.min(600, (parent ? parent.width : 700) - 64)
// //         height: Math.min(500, (parent ? parent.height : 600) - 64)
// //         radius: 28
// //         color: root.colors.surfaceContainerHigh
// //         clip: true

// //         layer.enabled: true
// //         layer.effect: DropShadow {
// //             transparentBorder: true
// //             horizontalOffset: 0
// //             verticalOffset: 12
// //             radius: 32
// //             samples: 25
// //             color: Qt.rgba(0, 0, 0, 0.2)
// //         }

// //         Column {
// //             anchors.fill: parent
// //             spacing: 0

// //             // Header
// //             Rectangle {
// //                 width: parent.width
// //                 height: 64
// //                 color: "transparent"

// //                 Row {
// //                     anchors.fill: parent
// //                     anchors.leftMargin: 24
// //                     anchors.rightMargin: 24
// //                     spacing: 16

// //                     Common.Icon {
// //                         visible: root.hasIcon
// //                         anchors.verticalCenter: parent.verticalCenter
// //                         source: root.icon
// //                         size: 28
// //                         color: root.colors.primary
// //                     }

// //                     Text {
// //                         text: root.title
// //                         font.family: "Roboto"
// //                         font.pixelSize: 20
// //                         font.weight: Font.Medium
// //                         color: root.colors.onSurface
// //                         anchors.verticalCenter: parent.verticalCenter
// //                         width: parent.width - 100
// //                     }

// //                     Item { width: 1; height: 1 }

// //                     Rectangle {
// //                         width: 40
// //                         height: 40
// //                         radius: 20
// //                         anchors.verticalCenter: parent.verticalCenter
// //                         color: assistCloseMA.containsMouse ? Qt.alpha(root.colors.onSurface, 0.08) : "transparent"

// //                         Common.Icon {
// //                             anchors.centerIn: parent
// //                             source: "close"
// //                             size: 24
// //                             color: root.colors.onSurfaceVariant
// //                         }

// //                         MouseArea {
// //                             id: assistCloseMA
// //                             anchors.fill: parent
// //                             hoverEnabled: true
// //                             cursorShape: Qt.PointingHandCursor
// //                             onClicked: { root.rejected(); root.close() }
// //                         }
// //                     }
// //                 }

// //                 Rectangle {
// //                     anchors.bottom: parent.bottom
// //                     width: parent.width
// //                     height: 1
// //                     color: root.colors.outlineVariant
// //                 }
// //             }

// //             // Content Area
// //             Flickable {
// //                 width: parent.width
// //                 height: parent.height - 64 - 80  // header + footer
// //                 contentHeight: assistContentLoader.item ? assistContentLoader.item.implicitHeight + 48 : height
// //                 clip: true
// //                 boundsBehavior: Flickable.StopAtBounds

// //                 Loader {
// //                     id: assistContentLoader
// //                     x: 24
// //                     y: 24
// //                     width: parent.width - 48
// //                     sourceComponent: root.open && root.isAssistant ? root.content : null
// //                 }
// //             }

// //             // Footer Actions Bar
// //             Rectangle {
// //                 id: assistActionsArea
// //                 width: parent.width
// //                 height: 80
// //                 color: root.colors.surfaceContainerLow
// //             }
// //         }
// //     }

// //     // State-based reparenting of actions
// //     states: [
// //         State {
// //             name: "basic"
// //             when: root.open && !root.isFullscreen && !root.isAssistant
// //             ParentChange {
// //                 target: theActionsRow
// //                 parent: basicActionsArea
// //             }
// //             PropertyChanges {
// //                 target: theActionsRow
// //                 visible: true
// //                 anchors.right: basicActionsArea.right
// //                 anchors.bottom: basicActionsArea.bottom
// //                 anchors.rightMargin: 24
// //                 anchors.bottomMargin: 24
// //             }
// //         },
// //         State {
// //             name: "assistant"
// //             when: root.open && root.isAssistant
// //             ParentChange {
// //                 target: theActionsRow
// //                 parent: assistActionsArea
// //             }
// //             PropertyChanges {
// //                 target: theActionsRow
// //                 visible: true
// //                 anchors.right: assistActionsArea.right
// //                 anchors.verticalCenter: assistActionsArea.verticalCenter
// //                 anchors.rightMargin: 24
// //             }
// //         },
// //         State {
// //             name: "closed"
// //             when: !root.open
// //             PropertyChanges {
// //                 target: theActionsRow
// //                 visible: false
// //             }
// //         }
// //     ]

// //     onOpenChanged: {
// //         if (open) {
// //             opened()
// //         } else {
// //             closed()
// //         }
// //     }

// //     Keys.onEscapePressed: {
// //         if (open && closeOnEscape) {
// //             rejected()
// //             close()
// //         }
// //     }

// //     function show() { open = true }
// //     function close() { open = false }
// //     function accept() { accepted(); close() }
// //     function reject() { rejected(); close() }
// // }


// // qml/smartui/ui/dialogs/Dialog.qml
// import QtQuick
// import QtQuick.Layouts
// import Qt5Compat.GraphicalEffects
// import "../common" as Common
// import "../theme" as Theme

// Item {
//     id: root

//     property string title: ""
//     property string supportingText: ""
//     property string icon: ""

//     property bool open: false
//     property bool modal: true
//     property bool closeOnOverlayClick: true
//     property bool closeOnEscape: true

//     property string type: "basic"  // "basic", "fullscreen", "assistant"
//     property string size: "medium" // "small", "medium", "large"
//     property string position: "center"

//     property string confirmText: "Save"
//     property bool showCloseButton: true
//     property bool showHeaderDivider: false
//     property bool showActionsDivider: false

//     property Component content: null

//     default property alias actions: theActionsRow.children

//     signal opened()
//     signal closed()
//     signal accepted()
//     signal rejected()

//     readonly property var sizeSpecs: ({
//         small: { width: 280, maxHeight: 400 },
//         medium: { width: 400, maxHeight: 560 },
//         large: { width: 560, maxHeight: 720 }
//     })
//     readonly property var currentSize: sizeSpecs[size] || sizeSpecs.medium
//     readonly property bool isFullscreen: type === "fullscreen"
//     readonly property bool isAssistant: type === "assistant"
//     readonly property bool hasIcon: icon !== ""
//     readonly property bool hasTitle: title !== ""
//     readonly property bool hasSupportingText: supportingText !== ""
//     readonly property bool hasContent: content !== null
//     readonly property bool hasActions: theActionsRow.children.length > 0

//     // REMOVED: property var colors: Theme.ChiTheme.colors
//     // Use Theme.ChiTheme.colors directly everywhere!

//     width: 0
//     height: 0
//     visible: false

//     property Item appWindow: {
//         var p = root.parent
//         while (p) {
//             if (p.toString().indexOf("Window") !== -1) return p
//             if (!p.parent) return p
//             p = p.parent
//         }
//         return null
//     }

//     Row {
//         id: theActionsRow
//         spacing: 8
//         visible: false
//         layoutDirection: Qt.LeftToRight
//     }

//     // Scrim overlay
//     Rectangle {
//         id: scrim
//         parent: root.appWindow || root.parent
//         anchors.fill: parent
//         color: Theme.ChiTheme.colors.scrim
//         opacity: root.open ? 0.32 : 0
//         visible: root.open
//         z: 9998

//         Behavior on opacity { NumberAnimation { duration: 200 } }

//         MouseArea {
//             anchors.fill: parent
//             enabled: root.modal && root.closeOnOverlayClick && !root.isFullscreen
//             onClicked: { root.rejected(); root.close() }
//         }
//     }

//     // ==================== BASIC DIALOG ====================
//     Rectangle {
//         id: basicDialog
//         visible: root.open && !root.isFullscreen && !root.isAssistant
//         parent: root.appWindow || root.parent
//         z: 9999

//         anchors.centerIn: root.position === "center" ? parent : undefined
//         anchors.horizontalCenter: root.position !== "center" ? parent.horizontalCenter : undefined
//         anchors.top: root.position === "top" ? parent.top : undefined
//         anchors.bottom: root.position === "bottom" ? parent.bottom : undefined
//         anchors.topMargin: root.position === "top" ? 56 : 0
//         anchors.bottomMargin: root.position === "bottom" ? 56 : 0

//         width: Math.min(root.currentSize.width, (parent ? parent.width : 400) - 48)
//         height: Math.min(basicContentCol.implicitHeight, root.currentSize.maxHeight, (parent ? parent.height : 600) - 96)
//         radius: 28
//         color: Theme.ChiTheme.colors.surfaceContainerHigh
//         clip: true

//         Behavior on color { ColorAnimation { duration: 250; easing.type: Easing.OutCubic } }

//         layer.enabled: true
//         layer.effect: DropShadow {
//             transparentBorder: true
//             horizontalOffset: 0
//             verticalOffset: 8
//             radius: 24
//             samples: 25
//             color: Qt.rgba(0, 0, 0, 0.25)
//         }

//         Column {
//             id: basicContentCol
//             width: parent.width
//             spacing: 0

//             // Icon
//             Item {
//                 visible: root.hasIcon
//                 width: parent.width
//                 height: 48

//                 Common.Icon {
//                     anchors.centerIn: parent
//                     anchors.topMargin: 24
//                     source: root.icon
//                     size: 24
//                     color: Theme.ChiTheme.colors.secondary
//                 }
//             }

//             // Title
//             Text {
//                 visible: root.hasTitle
//                 text: root.title
//                 font.family: "Roboto"
//                 font.pixelSize: 24
//                 color: Theme.ChiTheme.colors.onSurface
//                 wrapMode: Text.WordWrap
//                 horizontalAlignment: root.hasIcon ? Text.AlignHCenter : Text.AlignLeft
//                 width: parent.width - 48
//                 x: 24
//                 topPadding: root.hasIcon ? 0 : 24
//             }

//             // Header Divider
//             Rectangle {
//                 visible: root.showHeaderDivider && root.hasTitle
//                 width: parent.width
//                 height: 1
//                 color: Theme.ChiTheme.colors.outlineVariant
//                 y: 16
//             }

//             Item {
//                 width: parent.width
//                 height: root.hasTitle ? 16 : 0
//             }

//             // Supporting Text
//             Text {
//                 visible: root.hasSupportingText
//                 text: root.supportingText
//                 font.family: "Roboto"
//                 font.pixelSize: 14
//                 color: Theme.ChiTheme.colors.onSurfaceVariant
//                 wrapMode: Text.WordWrap
//                 width: parent.width - 48
//                 x: 24
//                 topPadding: root.hasTitle ? 0 : 24
//             }

//             Item {
//                 width: parent.width
//                 height: (root.hasTitle || root.hasSupportingText) ? 16 : 0
//             }

//             // Content Loader
//             Item {
//                 visible: root.hasContent
//                 width: parent.width - 48
//                 x: 24
//                 height: basicContentLoader.item ? Math.min(basicContentLoader.item.implicitHeight, 300) : 0

//                 Loader {
//                     id: basicContentLoader
//                     width: parent.width
//                     sourceComponent: root.open && !root.isFullscreen && !root.isAssistant ? root.content : null
//                 }
//             }

//             Item {
//                 width: parent.width
//                 height: root.hasContent ? 16 : 0
//             }

//             // Actions Divider
//             Rectangle {
//                 visible: root.showActionsDivider && root.hasActions
//                 width: parent.width
//                 height: 1
//                 color: Theme.ChiTheme.colors.outlineVariant
//             }

//             // Actions Area
//             Item {
//                 id: basicActionsArea
//                 width: parent.width
//                 height: root.hasActions ? 72 : 24
//             }
//         }
//     }

//     // ==================== FULLSCREEN DIALOG ====================
//     Rectangle {
//         id: fullscreenDialog
//         visible: root.open && root.isFullscreen
//         parent: root.appWindow || root.parent
//         anchors.fill: parent
//         z: 9999
//         color: Theme.ChiTheme.colors.surfaceContainerHigh

//         Behavior on color { ColorAnimation { duration: 250; easing.type: Easing.OutCubic } }

//         Column {
//             anchors.fill: parent
//             spacing: 0

//             // Header Bar
//             Rectangle {
//                 width: parent.width
//                 height: 56
//                 color: Theme.ChiTheme.colors.surfaceContainerHigh

//                 Behavior on color { ColorAnimation { duration: 250 } }

//                 Row {
//                     anchors.fill: parent
//                     anchors.leftMargin: 8
//                     anchors.rightMargin: 16
//                     spacing: 8

//                     Rectangle {
//                         visible: root.showCloseButton
//                         width: 48
//                         height: 48
//                         radius: 24
//                         anchors.verticalCenter: parent.verticalCenter
//                         color: fsCloseMA.containsMouse ? Qt.alpha(Theme.ChiTheme.colors.onSurface, 0.08) : "transparent"

//                         Common.Icon {
//                             anchors.centerIn: parent
//                             source: "close"
//                             size: 24
//                             color: Theme.ChiTheme.colors.onSurface
//                         }

//                         MouseArea {
//                             id: fsCloseMA
//                             anchors.fill: parent
//                             hoverEnabled: true
//                             cursorShape: Qt.PointingHandCursor
//                             onClicked: { root.rejected(); root.close() }
//                         }
//                     }

//                     Text {
//                         text: root.title
//                         font.family: "Roboto"
//                         font.pixelSize: 22
//                         color: Theme.ChiTheme.colors.onSurface
//                         elide: Text.ElideRight
//                         anchors.verticalCenter: parent.verticalCenter
//                         width: parent.width - 150
//                     }

//                     Item { width: 1; height: 1; Layout.fillWidth: true }

//                     Rectangle {
//                         visible: root.confirmText !== ""
//                         width: fsConfirmText.implicitWidth + 32
//                         height: 40
//                         radius: 20
//                         anchors.verticalCenter: parent.verticalCenter
//                         color: fsConfirmMA.containsMouse ? Qt.alpha(Theme.ChiTheme.colors.primary, 0.08) : "transparent"

//                         Text {
//                             id: fsConfirmText
//                             anchors.centerIn: parent
//                             text: root.confirmText
//                             font.family: "Roboto"
//                             font.pixelSize: 14
//                             font.weight: Font.Medium
//                             color: Theme.ChiTheme.colors.primary
//                         }

//                         MouseArea {
//                             id: fsConfirmMA
//                             anchors.fill: parent
//                             hoverEnabled: true
//                             cursorShape: Qt.PointingHandCursor
//                             onClicked: { root.accepted(); root.close() }
//                         }
//                     }
//                 }

//                 Rectangle {
//                     visible: root.showHeaderDivider
//                     anchors.bottom: parent.bottom
//                     width: parent.width
//                     height: 1
//                     color: Theme.ChiTheme.colors.outlineVariant
//                 }
//             }

//             Flickable {
//                 width: parent.width
//                 height: parent.height - 56
//                 contentHeight: fsContentLoader.item ? fsContentLoader.item.implicitHeight + 48 : parent.height
//                 clip: true
//                 boundsBehavior: Flickable.StopAtBounds

//                 Loader {
//                     id: fsContentLoader
//                     x: 24
//                     y: 24
//                     width: parent.width - 48
//                     sourceComponent: root.open && root.isFullscreen ? root.content : null
//                 }
//             }
//         }
//     }

//     // ==================== ASSISTANT DIALOG ====================
//     Rectangle {
//         id: assistantDialog
//         visible: root.open && root.isAssistant
//         parent: root.appWindow || root.parent
//         z: 9999

//         anchors.centerIn: parent
//         width: Math.min(600, (parent ? parent.width : 700) - 64)
//         height: Math.min(500, (parent ? parent.height : 600) - 64)
//         radius: 28
//         color: Theme.ChiTheme.colors.surfaceContainerHigh
//         clip: true

//         Behavior on color { ColorAnimation { duration: 250; easing.type: Easing.OutCubic } }

//         layer.enabled: true
//         layer.effect: DropShadow {
//             transparentBorder: true
//             horizontalOffset: 0
//             verticalOffset: 12
//             radius: 32
//             samples: 25
//             color: Qt.rgba(0, 0, 0, 0.2)
//         }

//         Column {
//             anchors.fill: parent
//             spacing: 0

//             // Header
//             Rectangle {
//                 width: parent.width
//                 height: 64
//                 color: "transparent"

//                 Row {
//                     anchors.fill: parent
//                     anchors.leftMargin: 24
//                     anchors.rightMargin: 24
//                     spacing: 16

//                     Common.Icon {
//                         visible: root.hasIcon
//                         anchors.verticalCenter: parent.verticalCenter
//                         source: root.icon
//                         size: 28
//                         color: Theme.ChiTheme.colors.primary
//                     }

//                     Text {
//                         text: root.title
//                         font.family: "Roboto"
//                         font.pixelSize: 20
//                         font.weight: Font.Medium
//                         color: Theme.ChiTheme.colors.onSurface
//                         anchors.verticalCenter: parent.verticalCenter
//                         width: parent.width - 100
//                     }

//                     Item { width: 1; height: 1 }

//                     Rectangle {
//                         width: 40
//                         height: 40
//                         radius: 20
//                         anchors.verticalCenter: parent.verticalCenter
//                         color: assistCloseMA.containsMouse ? Qt.alpha(Theme.ChiTheme.colors.onSurface, 0.08) : "transparent"

//                         Common.Icon {
//                             anchors.centerIn: parent
//                             source: "close"
//                             size: 24
//                             color: Theme.ChiTheme.colors.onSurfaceVariant
//                         }

//                         MouseArea {
//                             id: assistCloseMA
//                             anchors.fill: parent
//                             hoverEnabled: true
//                             cursorShape: Qt.PointingHandCursor
//                             onClicked: { root.rejected(); root.close() }
//                         }
//                     }
//                 }

//                 Rectangle {
//                     anchors.bottom: parent.bottom
//                     width: parent.width
//                     height: 1
//                     color: Theme.ChiTheme.colors.outlineVariant
//                 }
//             }

//             // Content Area
//             Flickable {
//                 width: parent.width
//                 height: parent.height - 64 - 80
//                 contentHeight: assistContentLoader.item ? assistContentLoader.item.implicitHeight + 48 : height
//                 clip: true
//                 boundsBehavior: Flickable.StopAtBounds

//                 Loader {
//                     id: assistContentLoader
//                     x: 24
//                     y: 24
//                     width: parent.width - 48
//                     sourceComponent: root.open && root.isAssistant ? root.content : null
//                 }
//             }

//             // Footer Actions Bar - with rounded bottom corners
//             Item {
//                 id: assistActionsArea
//                 width: parent.width
//                 height: 80

//                 Rectangle {
//                     id: footerBg
//                     anchors.fill: parent
//                     color: Theme.ChiTheme.colors.surfaceContainerLow
//                     radius: 28

//                     Behavior on color { ColorAnimation { duration: 250; easing.type: Easing.OutCubic } }

//                     // Cover top rounded corners
//                     Rectangle {
//                         width: parent.width
//                         height: parent.radius
//                         color: parent.color
//                         anchors.top: parent.top
//                     }
//                 }

//                 // Divider at top of footer
//                 Rectangle {
//                     width: parent.width
//                     height: 1
//                     color: Theme.ChiTheme.colors.outlineVariant
//                     anchors.top: parent.top
//                 }
//             }
//         }
//     }

//     // State-based reparenting of actions
//     states: [
//         State {
//             name: "basic"
//             when: root.open && !root.isFullscreen && !root.isAssistant
//             ParentChange {
//                 target: theActionsRow
//                 parent: basicActionsArea
//             }
//             PropertyChanges {
//                 target: theActionsRow
//                 visible: true
//                 anchors.right: basicActionsArea.right
//                 anchors.bottom: basicActionsArea.bottom
//                 anchors.rightMargin: 24
//                 anchors.bottomMargin: 24
//             }
//         },
//         State {
//             name: "assistant"
//             when: root.open && root.isAssistant
//             ParentChange {
//                 target: theActionsRow
//                 parent: assistActionsArea
//             }
//             PropertyChanges {
//                 target: theActionsRow
//                 visible: true
//                 anchors.right: assistActionsArea.right
//                 anchors.verticalCenter: assistActionsArea.verticalCenter
//                 anchors.rightMargin: 24
//             }
//         },
//         State {
//             name: "closed"
//             when: !root.open
//             PropertyChanges {
//                 target: theActionsRow
//                 visible: false
//             }
//         }
//     ]

//     onOpenChanged: {
//         if (open) {
//             opened()
//         } else {
//             closed()
//         }
//     }

//     Keys.onEscapePressed: {
//         if (open && closeOnEscape) {
//             rejected()
//             close()
//         }
//     }

//     function show() { open = true }
//     function close() { open = false }
//     function accept() { accepted(); close() }
//     function reject() { rejected(); close() }
// }


// qml/smartui/ui/dialogs/Dialog.qml
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../common" as Common
import "../theme" as Theme

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
        small: { width: 280, maxHeight: 400 },
        medium: { width: 400, maxHeight: 560 },
        large: { width: 560, maxHeight: 720 }
    })
    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.medium
    readonly property bool isFullscreen: type === "fullscreen"
    readonly property bool isAssistant: type === "assistant"
    readonly property bool hasIcon: icon !== ""
    readonly property bool hasTitle: title !== ""
    readonly property bool hasSupportingText: supportingText !== ""
    readonly property bool hasContent: content !== null
    readonly property bool hasActions: theActionsRow.children.length > 0

    // Same pattern as Menu.qml - this creates the binding
    property var colors: Theme.ChiTheme.colors

    // Computed colors - these will re-evaluate when colors changes
    readonly property color dialogBackgroundColor: colors.surfaceContainerHigh
    readonly property color dialogFooterColor: colors.surfaceContainerLow
    readonly property color scrimColor: colors.scrim
    readonly property color onSurfaceColor: colors.onSurface
    readonly property color onSurfaceVariantColor: colors.onSurfaceVariant
    readonly property color primaryColor: colors.primary
    readonly property color secondaryColor: colors.secondary
    readonly property color outlineVariantColor: colors.outlineVariant

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
        color: root.scrimColor
        opacity: root.open ? 0.32 : 0
        visible: root.open
        z: 9998

        Behavior on opacity { NumberAnimation { duration: 200 } }

        MouseArea {
            anchors.fill: parent
            enabled: root.modal && root.closeOnOverlayClick && !root.isFullscreen
            onClicked: { root.rejected(); root.close() }
        }
    }

    // ==================== BASIC DIALOG ====================
    Rectangle {
        id: basicDialog
        visible: root.open && !root.isFullscreen && !root.isAssistant
        parent: root.appWindow || root.parent
        z: 9999

        anchors.centerIn: root.position === "center" ? parent : undefined
        anchors.horizontalCenter: root.position !== "center" ? parent.horizontalCenter : undefined
        anchors.top: root.position === "top" ? parent.top : undefined
        anchors.bottom: root.position === "bottom" ? parent.bottom : undefined
        anchors.topMargin: root.position === "top" ? 56 : 0
        anchors.bottomMargin: root.position === "bottom" ? 56 : 0

        width: Math.min(root.currentSize.width, (parent ? parent.width : 400) - 48)
        height: Math.min(basicContentCol.implicitHeight, root.currentSize.maxHeight, (parent ? parent.height : 600) - 96)
        radius: 28
        color: root.dialogBackgroundColor
        clip: true

        Behavior on color { ColorAnimation { duration: 250; easing.type: Easing.OutCubic } }

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 8
            radius: 24
            samples: 25
            color: Qt.rgba(0, 0, 0, 0.25)
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
                    color: root.secondaryColor
                }
            }

            // Title
            Text {
                visible: root.hasTitle
                text: root.title
                font.family: "Roboto"
                font.pixelSize: 24
                color: root.onSurfaceColor
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
                color: root.outlineVariantColor
                y: 16
            }

            Item {
                width: parent.width
                height: root.hasTitle ? 16 : 0
            }

            // Supporting Text
            Text {
                visible: root.hasSupportingText
                text: root.supportingText
                font.family: "Roboto"
                font.pixelSize: 14
                color: root.onSurfaceVariantColor
                wrapMode: Text.WordWrap
                width: parent.width - 48
                x: 24
                topPadding: root.hasTitle ? 0 : 24
            }

            Item {
                width: parent.width
                height: (root.hasTitle || root.hasSupportingText) ? 16 : 0
            }

            // Content Loader
            Item {
                visible: root.hasContent
                width: parent.width - 48
                x: 24
                height: basicContentLoader.item ? Math.min(basicContentLoader.item.implicitHeight, 300) : 0

                Loader {
                    id: basicContentLoader
                    width: parent.width
                    sourceComponent: root.open && !root.isFullscreen && !root.isAssistant ? root.content : null
                }
            }

            Item {
                width: parent.width
                height: root.hasContent ? 16 : 0
            }

            // Actions Divider
            Rectangle {
                visible: root.showActionsDivider && root.hasActions
                width: parent.width
                height: 1
                color: root.outlineVariantColor
            }

            // Actions Area
            Item {
                id: basicActionsArea
                width: parent.width
                height: root.hasActions ? 72 : 24
            }
        }
    }

    // ==================== FULLSCREEN DIALOG ====================
    Rectangle {
        id: fullscreenDialog
        visible: root.open && root.isFullscreen
        parent: root.appWindow || root.parent
        anchors.fill: parent
        z: 9999
        color: root.dialogBackgroundColor

        Behavior on color { ColorAnimation { duration: 250; easing.type: Easing.OutCubic } }

        Column {
            anchors.fill: parent
            spacing: 0

            // Header Bar
            Rectangle {
                width: parent.width
                height: 56
                color: root.dialogBackgroundColor

                Behavior on color { ColorAnimation { duration: 250 } }

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 16
                    spacing: 8

                    Rectangle {
                        visible: root.showCloseButton
                        width: 48
                        height: 48
                        radius: 24
                        anchors.verticalCenter: parent.verticalCenter
                        color: fsCloseMA.containsMouse ? Qt.alpha(root.onSurfaceColor, 0.08) : "transparent"

                        Common.Icon {
                            anchors.centerIn: parent
                            source: "close"
                            size: 24
                            color: root.onSurfaceColor
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
                        font.family: "Roboto"
                        font.pixelSize: 22
                        color: root.onSurfaceColor
                        elide: Text.ElideRight
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 150
                    }

                    Item { width: 1; height: 1; Layout.fillWidth: true }

                    Rectangle {
                        visible: root.confirmText !== ""
                        width: fsConfirmText.implicitWidth + 32
                        height: 40
                        radius: 20
                        anchors.verticalCenter: parent.verticalCenter
                        color: fsConfirmMA.containsMouse ? Qt.alpha(root.primaryColor, 0.08) : "transparent"

                        Text {
                            id: fsConfirmText
                            anchors.centerIn: parent
                            text: root.confirmText
                            font.family: "Roboto"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: root.primaryColor
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
                    width: parent.width
                    height: 1
                    color: root.outlineVariantColor
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
                    x: 24
                    y: 24
                    width: parent.width - 48
                    sourceComponent: root.open && root.isFullscreen ? root.content : null
                }
            }
        }
    }

    // ==================== ASSISTANT DIALOG ====================
    Rectangle {
        id: assistantDialog
        visible: root.open && root.isAssistant
        parent: root.appWindow || root.parent
        z: 9999

        anchors.centerIn: parent
        width: Math.min(600, (parent ? parent.width : 700) - 64)
        height: Math.min(500, (parent ? parent.height : 600) - 64)
        radius: 28
        color: root.dialogBackgroundColor
        clip: true

        Behavior on color { ColorAnimation { duration: 250; easing.type: Easing.OutCubic } }

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 12
            radius: 32
            samples: 25
            color: Qt.rgba(0, 0, 0, 0.2)
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
                        color: root.primaryColor
                    }

                    Text {
                        text: root.title
                        font.family: "Roboto"
                        font.pixelSize: 20
                        font.weight: Font.Medium
                        color: root.onSurfaceColor
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 100
                    }

                    Item { width: 1; height: 1 }

                    Rectangle {
                        width: 40
                        height: 40
                        radius: 20
                        anchors.verticalCenter: parent.verticalCenter
                        color: assistCloseMA.containsMouse ? Qt.alpha(root.onSurfaceColor, 0.08) : "transparent"

                        Common.Icon {
                            anchors.centerIn: parent
                            source: "close"
                            size: 24
                            color: root.onSurfaceVariantColor
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
                    width: parent.width
                    height: 1
                    color: root.outlineVariantColor
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
                    x: 24
                    y: 24
                    width: parent.width - 48
                    sourceComponent: root.open && root.isAssistant ? root.content : null
                }
            }

            // Footer Actions Bar - with rounded bottom corners
            Item {
                id: assistActionsArea
                width: parent.width
                height: 80

                Rectangle {
                    id: footerBg
                    anchors.fill: parent
                    color: root.dialogFooterColor
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

                // Divider at top of footer
                Rectangle {
                    width: parent.width
                    height: 1
                    color: root.outlineVariantColor
                    anchors.top: parent.top
                }
            }
        }
    }

    // State-based reparenting of actions
    states: [
        State {
            name: "basic"
            when: root.open && !root.isFullscreen && !root.isAssistant
            ParentChange {
                target: theActionsRow
                parent: basicActionsArea
            }
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
            when: root.open && root.isAssistant
            ParentChange {
                target: theActionsRow
                parent: assistActionsArea
            }
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
            PropertyChanges {
                target: theActionsRow
                visible: false
            }
        }
    ]

    onOpenChanged: {
        if (open) {
            opened()
        } else {
            closed()
        }
    }

    Keys.onEscapePressed: {
        if (open && closeOnEscape) {
            rejected()
            close()
        }
    }

    function show() { open = true }
    function close() { open = false }
    function accept() { accepted(); close() }
    function reject() { rejected(); close() }
}
