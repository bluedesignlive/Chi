import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Rectangle {
    id: root

    property string title: ""
    property string subtitle: ""
    property string variant: "small"         // "small", "medium", "large", "center"
    property string navigationIcon: "←"
    property bool showNavigation: true
    property bool elevated: false
    property real scrollOffset: 0            // For scroll behavior
    property real expandedHeight: variant === "large" ? 152 : (variant === "medium" ? 112 : 64)
    property real collapsedHeight: 64

    property alias actions: actionsRow.data

    signal navigationClicked()

    readonly property bool isExpanded: variant !== "small" && variant !== "center"
    readonly property real scrollProgress: Math.min(1, scrollOffset / (expandedHeight - collapsedHeight))
    readonly property real currentHeight: isExpanded ?
        expandedHeight - (scrollProgress * (expandedHeight - collapsedHeight)) : collapsedHeight

    implicitWidth: parent ? parent.width : 400
    implicitHeight: currentHeight

    property var colors: Theme.ChiTheme.colors

    color: elevated || scrollProgress > 0 ? colors.surfaceContainer : colors.surface

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    layer.enabled: elevated || scrollProgress > 0
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 2
        radius: 4
        samples: 9
        color: Qt.rgba(0, 0, 0, 0.15)
    }

    // Top row (navigation + title for small/center + actions)
    RowLayout {
        id: topRow
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 64
        spacing: 4

        // Navigation icon
        Item {
            visible: showNavigation
            Layout.preferredWidth: 48
            Layout.preferredHeight: 48
            Layout.leftMargin: 4

            Rectangle {
                anchors.centerIn: parent
                width: 40
                height: 40
                radius: 20
                color: colors.onSurface
                opacity: navMouse.containsMouse ? 0.08 : 0

                Behavior on opacity {
                    NumberAnimation { duration: 100 }
                }
            }

            Text {
                anchors.centerIn: parent
                text: navigationIcon
                font.family: navigationIcon.length > 2 ? "Material Icons" : "Roboto"
                font.pixelSize: 24
                color: colors.onSurface

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }
            }

            MouseArea {
                id: navMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.navigationClicked()
            }
        }

        // Spacer for navigation
        Item {
            visible: !showNavigation
            Layout.preferredWidth: 16
        }

        // Title (for small and center variants, or when scrolled)
        Text {
            visible: variant === "small" || variant === "center" || scrollProgress > 0.5
            text: title
            font.family: "Roboto"
            font.pixelSize: 22
            font.weight: Font.Normal
            color: colors.onSurface
            elide: Text.ElideRight
            opacity: (variant === "small" || variant === "center") ? 1 :
                Math.max(0, (scrollProgress - 0.5) * 2)
            Layout.fillWidth: variant !== "center"
            Layout.alignment: variant === "center" ? Qt.AlignHCenter : Qt.AlignLeft

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }

        Item {
            visible: variant === "center"
            Layout.fillWidth: true
        }

        // Actions
        RowLayout {
            id: actionsRow
            Layout.rightMargin: 4
            spacing: 0
        }
    }

    // Expanded title (for medium and large variants)
    Column {
        visible: isExpanded && scrollProgress < 1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        anchors.bottomMargin: variant === "large" ? 28 : 20
        spacing: 0
        opacity: 1 - scrollProgress

        Text {
            text: title
            font.family: "Roboto"
            font.pixelSize: variant === "large" ? 36 : 28
            font.weight: Font.Normal
            color: colors.onSurface
            elide: Text.ElideRight
            width: parent.width

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }

        Text {
            visible: subtitle !== "" && variant === "medium"
            text: subtitle
            font.family: "Roboto"
            font.pixelSize: 14
            color: colors.onSurfaceVariant
            elide: Text.ElideRight
            width: parent.width
            topPadding: 4

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }
    }

    Accessible.role: Accessible.ToolBar
    Accessible.name: title
}
