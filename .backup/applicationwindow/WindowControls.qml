// qml/smartui/ui/applicationwindow/WindowControls.qml

import QtQuick
import QtQuick.Window
import "../../theme" as Theme
import "../common"

Item {
    id: root

    property var targetWindow: null
    property var colors: Theme.SmartTheme

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
    // macOS STYLE (Traffic Lights) — DEFAULT
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
                if (root.targetWindow && !root.targetWindow.active)
                    return colors.outlineVariant
                if (tlMouse.pressed)
                    return Qt.darker(baseColor, 1.25)
                if (tlMouse.containsMouse)
                    return Qt.lighter(baseColor, 1.1)
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
            radius: Theme.SmartTheme.shape.small

            color: {
                if (winBtnMouse.pressed)
                    return Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.25)
                if (winBtnMouse.containsMouse)
                    return Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.15)
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
