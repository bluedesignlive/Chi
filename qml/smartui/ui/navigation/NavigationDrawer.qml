import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Item {
    id: root

    property bool open: false
    property string variant: "standard"      // "standard", "modal"
    property string position: "left"         // "left", "right"
    property real drawerWidth: 360
    property string headline: ""

    default property alias content: contentContainer.data
    property alias header: headerContainer.data

    signal closed()

    anchors.fill: parent
    z: variant === "modal" ? 1000 : 0

    property var colors: Theme.ChiTheme.colors

    // Scrim for modal variant
    Rectangle {
        id: scrim
        visible: variant === "modal"
        anchors.fill: parent
        color: colors.scrim
        opacity: open ? 0.32 : 0

        Behavior on opacity {
            NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
        }

        MouseArea {
            anchors.fill: parent
            enabled: open && variant === "modal"
            onClicked: root.close()
        }
    }

    // Drawer container
    Rectangle {
        id: drawer
        width: drawerWidth
        height: parent.height

        anchors.top: parent.top
        anchors.bottom: parent.bottom

        x: {
            if (position === "left") {
                return open ? 0 : -width
            } else {
                return open ? parent.width - width : parent.width
            }
        }

        color: colors.surfaceContainerLow
        radius: position === "left" ? Qt.vector4d(0, 16, 16, 0) : Qt.vector4d(16, 0, 0, 16)

        Behavior on x {
            NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
        }
        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        layer.enabled: variant === "modal" && open
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: position === "left" ? 4 : -4
            verticalOffset: 0
            radius: 16
            samples: 17
            color: Qt.rgba(0, 0, 0, 0.2)
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // Header area
            Item {
                id: headerContainer
                Layout.fillWidth: true
                Layout.preferredHeight: childrenRect.height > 0 ? childrenRect.height : 0
                Layout.topMargin: childrenRect.height > 0 ? 16 : 0
                Layout.leftMargin: 16
                Layout.rightMargin: 16
            }

            // Headline
            Text {
                visible: headline !== ""
                text: headline
                font.family: "Roboto"
                font.pixelSize: 14
                font.weight: Font.Medium
                font.letterSpacing: 0.1
                color: colors.onSurfaceVariant
                Layout.fillWidth: true
                Layout.topMargin: 16
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                Layout.bottomMargin: 8

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }
            }

            // Content
            Flickable {
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentHeight: contentContainer.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                ColumnLayout {
                    id: contentContainer
                    width: parent.width
                    spacing: 0
                }
            }
        }
    }

    // Keyboard handling
    Keys.onEscapePressed: if (open) close()

    function show() {
        open = true
    }

    function close() {
        open = false
        closed()
    }

    function toggle() {
        if (open) close()
        else show()
    }

    Accessible.role: Accessible.Pane
    Accessible.name: "Navigation drawer"
}
