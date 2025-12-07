import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Rectangle {
    id: root

    property string title: "Application"
    property string subtitle: ""
    property string icon: ""
    property string windowStyle: "macos"     // "macos", "windows", "gnome"
    property bool showTitleBar: true
    property bool showShadow: true
    property bool resizable: true
    property bool draggable: true
    property real minWidth: 400
    property real minHeight: 300
    property real maxWidth: 9999
    property real maxHeight: 9999
    property bool isMaximized: false
    property bool isFocused: true

    default property alias content: contentContainer.data
    property alias titleBarLeftContent: titleBar.leftContent
    property alias titleBarRightContent: titleBar.rightContent

    signal minimizeRequested()
    signal maximizeRequested()
    signal closeRequested()
    signal focused()
    signal blurred()

    implicitWidth: 800
    implicitHeight: 600

    property var colors: Theme.ChiTheme.colors

    radius: isMaximized ? 0 : 12
    color: colors.surface
    border.width: isFocused ? 0 : 1
    border.color: colors.outlineVariant

    Behavior on color {
        ColorAnimation { duration: 200 }
    }
    Behavior on radius {
        NumberAnimation { duration: 200 }
    }

    clip: true

    layer.enabled: showShadow && !isMaximized
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: isFocused ? 16 : 8
        radius: isFocused ? 32 : 16
        samples: 33
        color: Qt.rgba(0, 0, 0, isFocused ? 0.25 : 0.15)

        Behavior on verticalOffset {
            NumberAnimation { duration: 200 }
        }
        Behavior on radius {
            NumberAnimation { duration: 200 }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Title bar
        TitleBar {
            id: titleBar
            visible: showTitleBar
            Layout.fillWidth: true
            title: root.title
            subtitle: root.subtitle
            icon: root.icon
            style: windowStyle
            isMaximized: root.isMaximized
            draggable: root.draggable

            onMinimizeClicked: minimizeRequested()
            onMaximizeClicked: maximizeRequested()
            onCloseClicked: closeRequested()
            onDoubleClicked: maximizeRequested()
        }

        // Content area
        Item {
            id: contentContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    // Resize handles
    Item {
        visible: resizable && !isMaximized
        anchors.fill: parent

        // Corners
        MouseArea {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: 16
            height: 16
            cursorShape: Qt.SizeFDiagCursor

            property point startPos
            property size startSize

            onPressed: (mouse) => {
                startPos = Qt.point(mouse.x, mouse.y)
                startSize = Qt.size(root.width, root.height)
            }

            onPositionChanged: (mouse) => {
                if (pressed) {
                    var newWidth = Math.max(minWidth, Math.min(maxWidth, startSize.width + mouse.x - startPos.x))
                    var newHeight = Math.max(minHeight, Math.min(maxHeight, startSize.height + mouse.y - startPos.y))
                    root.width = newWidth
                    root.height = newHeight
                }
            }
        }

        MouseArea {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: 16
            height: 16
            cursorShape: Qt.SizeBDiagCursor

            property point startPos
            property size startSize
            property real startX

            onPressed: (mouse) => {
                startPos = mapToItem(root.parent, mouse.x, mouse.y)
                startSize = Qt.size(root.width, root.height)
                startX = root.x
            }

            onPositionChanged: (mouse) => {
                if (pressed) {
                    var globalPos = mapToItem(root.parent, mouse.x, mouse.y)
                    var deltaX = globalPos.x - startPos.x
                    var newWidth = Math.max(minWidth, Math.min(maxWidth, startSize.width - deltaX))
                    var newHeight = Math.max(minHeight, Math.min(maxHeight, startSize.height + mouse.y))

                    if (newWidth !== root.width) {
                        root.x = startX + (startSize.width - newWidth)
                        root.width = newWidth
                    }
                    root.height = newHeight
                }
            }
        }

        // Right edge
        MouseArea {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 16
            anchors.bottomMargin: 16
            width: 6
            cursorShape: Qt.SizeHorCursor

            property real startX
            property real startWidth

            onPressed: (mouse) => {
                startX = mouse.x
                startWidth = root.width
            }

            onPositionChanged: (mouse) => {
                if (pressed) {
                    root.width = Math.max(minWidth, Math.min(maxWidth, startWidth + mouse.x - startX))
                }
            }
        }

        // Bottom edge
        MouseArea {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            height: 6
            cursorShape: Qt.SizeVerCursor

            property real startY
            property real startHeight

            onPressed: (mouse) => {
                startY = mouse.y
                startHeight = root.height
            }

            onPositionChanged: (mouse) => {
                if (pressed) {
                    root.height = Math.max(minHeight, Math.min(maxHeight, startHeight + mouse.y - startY))
                }
            }
        }
    }

    // Focus handling
    MouseArea {
        anchors.fill: parent
        z: -100
        onPressed: (mouse) => {
            root.forceActiveFocus()
            focused()
            mouse.accepted = false
        }
    }

    Accessible.role: Accessible.Window
    Accessible.name: title
}
