import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme

Rectangle {
    id: root

    property string title: ""
    property string subtitle: ""
    property string icon: ""
    property string style: "macos"           // "macos", "windows", "gnome"
    property bool showWindowControls: true
    property bool showIcon: true
    property bool showMenu: false
    property bool isMaximized: false
    property bool draggable: true
    property bool enabled: true

    property alias leftContent: leftContainer.data
    property alias rightContent: rightContainer.data

    signal minimizeClicked()
    signal maximizeClicked()
    signal closeClicked()
    signal doubleClicked()

    readonly property bool isMacStyle: style === "macos"
    readonly property bool isWindowsStyle: style === "windows"
    readonly property bool isGnomeStyle: style === "gnome"

    implicitWidth: parent ? parent.width : 800
    implicitHeight: 40

    property var colors: Theme.ChiTheme.colors

    color: colors.surface

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 8

        // Left: Window controls (macOS style)
        WindowControls {
            visible: showWindowControls && isMacStyle
            style: "macos"
            isMaximized: root.isMaximized
            enabled: root.enabled
            Layout.alignment: Qt.AlignVCenter

            onMinimizeClicked: root.minimizeClicked()
            onMaximizeClicked: root.maximizeClicked()
            onCloseClicked: root.closeClicked()
        }

        // Left content slot
        Item {
            id: leftContainer
            Layout.preferredWidth: childrenRect.width
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignVCenter
        }

        // Spacer (macOS has centered title)
        Item {
            visible: isMacStyle
            Layout.fillWidth: true
        }

        // Icon (Windows/GNOME left, or macOS center area)
        Image {
            visible: showIcon && icon !== "" && icon.indexOf(".") !== -1
            source: icon
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
            Layout.alignment: Qt.AlignVCenter
            fillMode: Image.PreserveAspectFit
        }

        Text {
            visible: showIcon && icon !== "" && icon.indexOf(".") === -1
            text: icon
            font.pixelSize: 18
            color: colors.onSurface
            Layout.alignment: Qt.AlignVCenter
        }

        // Title
        Column {
            Layout.fillWidth: !isMacStyle
            Layout.alignment: Qt.AlignVCenter
            spacing: 0

            Text {
                text: title
                font.family: "Roboto"
                font.pixelSize: 14
                font.weight: Font.Medium
                color: colors.onSurface
                elide: Text.ElideRight
                width: parent.width

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }
            }

            Text {
                visible: subtitle !== ""
                text: subtitle
                font.family: "Roboto"
                font.pixelSize: 11
                color: colors.onSurfaceVariant
                elide: Text.ElideRight
                width: parent.width

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }
            }
        }

        // Spacer (Windows/GNOME has left-aligned title)
        Item {
            visible: !isMacStyle
            Layout.fillWidth: true
        }

        // Spacer for macOS centered title
        Item {
            visible: isMacStyle && !showWindowControls
            Layout.fillWidth: true
        }

        // Right content slot
        Item {
            id: rightContainer
            Layout.preferredWidth: childrenRect.width
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignVCenter
        }

        // Right: Window controls (Windows/GNOME style)
        WindowControls {
            visible: showWindowControls && !isMacStyle
            style: root.style
            isMaximized: root.isMaximized
            enabled: root.enabled
            Layout.alignment: Qt.AlignVCenter

            onMinimizeClicked: root.minimizeClicked()
            onMaximizeClicked: root.maximizeClicked()
            onCloseClicked: root.closeClicked()
        }
    }

    // Bottom border
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: colors.outlineVariant
        opacity: 0.5
    }

    // Drag area
    MouseArea {
        anchors.fill: parent
        z: -1
        enabled: draggable
        property point clickPos: Qt.point(0, 0)

        onPressed: (mouse) => {
            clickPos = Qt.point(mouse.x, mouse.y)
        }

        onPositionChanged: (mouse) => {
            if (pressed) {
                var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                // Window drag would be handled by parent Window item
            }
        }

        onDoubleClicked: root.doubleClicked()
    }

    Accessible.role: Accessible.TitleBar
    Accessible.name: title
}
