import QtQuick
import QtQuick.Window
import QtQuick.Controls.Basic
import QtQuick.Layouts
import "../../theme" as Theme

Window {
    id: root

    // Default Properties
    visible: true
    color: "transparent"
    flags: Qt.Window | Qt.FramelessWindowHint

    // Custom Properties
    property string title: "Application"
    property bool showControls: true

    // The content inside the window
    default property alias content: contentContainer.data

    // Theme shortcut
    property var colors: Theme.ChiTheme.colors

    // Background Container (The actual visible window)
    Rectangle {
        id: appBackground
        anchors.fill: parent

        // When maximized, remove margins and radius
        anchors.margins: root.visibility === Window.Maximized ? 0 : 10
        radius: root.visibility === Window.Maximized ? 0 : 20 // M3 Expressive uses large radii

        color: colors.background

        // Subtle border for definition against dark wallpapers
        border.width: 1
        border.color: colors.outlineVariant

        clip: true

        // 1. Custom Title Bar
        Item {
            id: titleBarArea
            height: 48
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            z: 999 // Keep above content

            // Drag Area (Title Bar)
            MouseArea {
                anchors.fill: parent
                // Exclude the buttons area from dragging if necessary,
                // but usually fine to overlap as buttons consume the event first.

                onPressed: root.startSystemMove()
                onDoubleClicked: {
                    if (root.visibility === Window.Maximized)
                        root.showNormal()
                    else
                        root.showMaximized()
                }
            }

            // Window Title
            Text {
                anchors.centerIn: parent
                text: root.title
                font.family: "Roboto"
                font.weight: Font.Medium
                font.pixelSize: 14
                color: colors.onSurfaceVariant
            }

            // Window Controls (Min/Max/Close)
            WindowControls {
                visible: root.showControls
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 8
            }
        }

        // 2. Main Content Area
        Item {
            id: contentContainer
            anchors.top: titleBarArea.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }
    }

    // 3. Resize Handles (Invisible MouseAreas)
    // Only active when not maximized
    Item {
        anchors.fill: parent
        visible: root.visibility !== Window.Maximized
        z: 1000 // Topmost

        property int edge: 5 // Thickness of resize area

        // Right
        MouseArea {
            anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
            width: parent.edge
            cursorShape: Qt.SizeHorCursor
            onPressed: root.startSystemResize(Qt.RightEdge)
        }
        // Left
        MouseArea {
            anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
            width: parent.edge
            cursorShape: Qt.SizeHorCursor
            onPressed: root.startSystemResize(Qt.LeftEdge)
        }
        // Bottom
        MouseArea {
            anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
            height: parent.edge
            cursorShape: Qt.SizeVerCursor
            onPressed: root.startSystemResize(Qt.BottomEdge)
        }
        // Top
        MouseArea {
            anchors { top: parent.top; left: parent.left; right: parent.right }
            height: parent.edge
            cursorShape: Qt.SizeVerCursor
            onPressed: root.startSystemResize(Qt.TopEdge)
        }
        // Bottom-Right Corner
        MouseArea {
            anchors { bottom: parent.bottom; right: parent.right }
            width: 10; height: 10
            cursorShape: Qt.SizeFDiagCursor
            onPressed: root.startSystemResize(Qt.RightEdge | Qt.BottomEdge)
        }
    }
}
