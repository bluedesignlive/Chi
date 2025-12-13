// import QtQuick
// import QtQuick.Window
// import QtQuick.Controls.Basic
// import QtQuick.Layouts
// import "../../theme" as Theme

// Window {
//     id: root
    
//     visible: true
//     color: "transparent"
//     flags: Qt.Window | Qt.FramelessWindowHint
    
//     property string title: "Application"
//     property bool showControls: true
//     default property alias content: contentContainer.data
//     property var colors: Theme.ChiTheme.colors

//     // Main Container
//     Rectangle {
//         id: appBackground
//         anchors.fill: parent
        
//         anchors.margins: root.visibility === Window.Maximized ? 0 : 10
//         radius: root.visibility === Window.Maximized ? 0 : 20
        
//         // CRITICAL FIX: Use 'background' (The tinted tonal surface)
//         color: colors.background
        
//         border.width: 1
//         border.color: colors.outlineVariant
//         clip: true

//         Behavior on color { ColorAnimation { duration: 300 } }

//         // 1. Title Bar
//         Item {
//             id: titleBarArea
//             height: 48
//             anchors.top: parent.top
//             anchors.left: parent.left
//             anchors.right: parent.right
//             z: 999

//             MouseArea {
//                 anchors.fill: parent
//                 onPressed: root.startSystemMove()
//                 onDoubleClicked: {
//                     if (root.visibility === Window.Maximized) root.showNormal()
//                     else root.showMaximized()
//                 }
//             }

//             Text {
//                 anchors.centerIn: parent
//                 text: root.title
//                 font.family: "Roboto"
//                 font.weight: Font.Medium
//                 font.pixelSize: 14
//                 color: colors.onSurfaceVariant
//             }

//             WindowControls {
//                 visible: root.showControls
//                 targetWindow: root
//                 anchors.right: parent.right
//                 anchors.verticalCenter: parent.verticalCenter
//                 anchors.rightMargin: 12
//             }
//         }

//         // 2. Content Area
//         Item {
//             id: contentContainer
//             anchors.top: titleBarArea.bottom
//             anchors.left: parent.left
//             anchors.right: parent.right
//             anchors.bottom: parent.bottom
//         }
//     }

//     // 3. Resize Handles (Only when windowed)
//     Item {
//         anchors.fill: parent
//         visible: root.visibility !== Window.Maximized
//         z: 1000
//         property int e: 6

//         MouseArea { anchors { right: parent.right; top: parent.top; bottom: parent.bottom } width: parent.e; cursorShape: Qt.SizeHorCursor; onPressed: root.startSystemResize(Qt.RightEdge) }
//         MouseArea { anchors { left: parent.left; top: parent.top; bottom: parent.bottom } width: parent.e; cursorShape: Qt.SizeHorCursor; onPressed: root.startSystemResize(Qt.LeftEdge) }
//         MouseArea { anchors { bottom: parent.bottom; left: parent.left; right: parent.right } height: parent.e; cursorShape: Qt.SizeVerCursor; onPressed: root.startSystemResize(Qt.BottomEdge) }
//         MouseArea { anchors { top: parent.top; left: parent.left; right: parent.right } height: parent.e; cursorShape: Qt.SizeVerCursor; onPressed: root.startSystemResize(Qt.TopEdge) }
//         MouseArea { anchors { bottom: parent.bottom; right: parent.right } width: 12; height: 12; cursorShape: Qt.SizeFDiagCursor; onPressed: root.startSystemResize(Qt.RightEdge | Qt.BottomEdge) }
//     }
// }




import QtQuick
import QtQuick.Window
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects // Required for smooth masking
import "../../theme" as Theme

Window {
    id: root

    visible: true
    color: "transparent"
    flags: Qt.Window | Qt.FramelessWindowHint

    property string title: "Application"
    property bool showControls: true
    default property alias content: contentContainer.data
    property var colors: Theme.ChiTheme.colors

    // 1. Define the Shape (Mask Source)
    // We separate the shape definition so we can use it to mask the content
    Rectangle {
        id: windowShape
        anchors.fill: parent
        anchors.margins: root.visibility === Window.Maximized ? 0 : 10
        radius: root.visibility === Window.Maximized ? 0 : 20
        visible: false // Used as a mask source only
    }

    // 2. The Visible Background & Content (Masked)
    Item {
        id: maskedArea
        anchors.fill: windowShape

        // This ensures the sidebar/content inside main.qml respects the rounded corners
        // OpacityMask cuts off anything outside the 'windowShape' radius cleanly
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: windowShape
        }

        // The Background Color
        Rectangle {
            anchors.fill: parent
            color: colors.background
            Behavior on color { ColorAnimation { duration: 300 } }
        }

        // Title Bar
        Item {
            id: titleBarArea
            height: 48
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            z: 999

            MouseArea {
                anchors.fill: parent
                onPressed: root.startSystemMove()
                onDoubleClicked: {
                    if (root.visibility === Window.Maximized) root.showNormal()
                    else root.showMaximized()
                }
            }

            Text {
                anchors.centerIn: parent
                text: root.title
                font.family: "Roboto"
                font.weight: Font.Medium
                font.pixelSize: 14
                color: colors.onSurfaceVariant
            }

            WindowControls {
                visible: root.showControls
                targetWindow: root
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 12
            }
        }

        // Content Area
        Item {
            id: contentContainer
            anchors.top: titleBarArea.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            // Content inside here will now be clipped by the OpacityMask
        }
    }

    // 3. Border Overlay
    // We draw the border *outside* the mask so it looks crisp and isn't half-clipped
    Rectangle {
        anchors.fill: windowShape
        radius: windowShape.radius
        color: "transparent"
        border.width: 1
        border.color: colors.outlineVariant
        visible: root.visibility !== Window.Maximized
        z: 1001 // On top of content
    }

    // 4. Resize Handles
    Item {
        anchors.fill: parent
        visible: root.visibility !== Window.Maximized
        z: 1002
        property int e: 6

        MouseArea { anchors { right: parent.right; top: parent.top; bottom: parent.bottom } width: parent.e; cursorShape: Qt.SizeHorCursor; onPressed: root.startSystemResize(Qt.RightEdge) }
        MouseArea { anchors { left: parent.left; top: parent.top; bottom: parent.bottom } width: parent.e; cursorShape: Qt.SizeHorCursor; onPressed: root.startSystemResize(Qt.LeftEdge) }
        MouseArea { anchors { bottom: parent.bottom; left: parent.left; right: parent.right } height: parent.e; cursorShape: Qt.SizeVerCursor; onPressed: root.startSystemResize(Qt.BottomEdge) }
        MouseArea { anchors { top: parent.top; left: parent.left; right: parent.right } height: parent.e; cursorShape: Qt.SizeVerCursor; onPressed: root.startSystemResize(Qt.TopEdge) }
        MouseArea { anchors { bottom: parent.bottom; right: parent.right } width: 12; height: 12; cursorShape: Qt.SizeFDiagCursor; onPressed: root.startSystemResize(Qt.RightEdge | Qt.BottomEdge) }
    }
}
