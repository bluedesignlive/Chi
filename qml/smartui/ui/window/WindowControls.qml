import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme

Item {
    id: root

    property string style: "macos"           // "macos", "windows", "gnome"
    property bool showMinimize: true
    property bool showMaximize: true
    property bool showClose: true
    property bool isMaximized: false
    property bool enabled: true
    property string size: "medium"           // "small", "medium", "large"

    signal minimizeClicked()
    signal maximizeClicked()
    signal closeClicked()

    readonly property var sizeSpecs: ({
        small: { buttonSize: 12, spacing: 6, padding: 8 },
        medium: { buttonSize: 14, spacing: 8, padding: 10 },
        large: { buttonSize: 16, spacing: 10, padding: 12 }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.medium
    readonly property bool isMacStyle: style === "macos"
    readonly property bool isWindowsStyle: style === "windows"
    readonly property bool isGnomeStyle: style === "gnome"

    implicitWidth: controlsRow.implicitWidth + currentSize.padding * 2
    implicitHeight: currentSize.buttonSize + currentSize.padding * 2

    property var colors: Theme.ChiTheme.colors

    // macOS traffic lights colors
    property var macColors: ({
        close: "#ff5f57",
        closeHover: "#ff3b30",
        minimize: "#febc2e",
        minimizeHover: "#ffcc00",
        maximize: "#28c840",
        maximizeHover: "#30d158"
    })

    Row {
        id: controlsRow
        anchors.centerIn: parent
        spacing: currentSize.spacing
        layoutDirection: isWindowsStyle ? Qt.RightToLeft : Qt.LeftToRight

        // Close button
        Item {
            visible: showClose
            width: isMacStyle ? currentSize.buttonSize : (isWindowsStyle ? 46 : 32)
            height: isMacStyle ? currentSize.buttonSize : 32

            Rectangle {
                anchors.fill: parent
                radius: isMacStyle ? width / 2 : (isGnomeStyle ? 16 : 0)

                color: {
                    if (isMacStyle) {
                        return closeMouse.containsMouse ? macColors.closeHover : macColors.close
                    }
                    if (isWindowsStyle) {
                        return closeMouse.containsMouse ? "#c42b1c" : "transparent"
                    }
                    return closeMouse.containsMouse ? colors.errorContainer : "transparent"
                }

                Behavior on color {
                    ColorAnimation { duration: 100 }
                }

                // macOS X icon
                Text {
                    visible: isMacStyle && closeMouse.containsMouse
                    anchors.centerIn: parent
                    text: "✕"
                    font.pixelSize: currentSize.buttonSize * 0.6
                    font.weight: Font.Bold
                    color: "#4a0002"
                }

                // Windows/GNOME X icon
                Text {
                    visible: !isMacStyle
                    anchors.centerIn: parent
                    text: "✕"
                    font.pixelSize: isWindowsStyle ? 10 : 14
                    color: {
                        if (isWindowsStyle) {
                            return closeMouse.containsMouse ? "#ffffff" : colors.onSurface
                        }
                        return closeMouse.containsMouse ? colors.onErrorContainer : colors.onSurface
                    }

                    Behavior on color {
                        ColorAnimation { duration: 100 }
                    }
                }
            }

            MouseArea {
                id: closeMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                enabled: root.enabled
                onClicked: closeClicked()
            }
        }

        // Minimize button
        Item {
            visible: showMinimize
            width: isMacStyle ? currentSize.buttonSize : (isWindowsStyle ? 46 : 32)
            height: isMacStyle ? currentSize.buttonSize : 32

            Rectangle {
                anchors.fill: parent
                radius: isMacStyle ? width / 2 : (isGnomeStyle ? 16 : 0)

                color: {
                    if (isMacStyle) {
                        return minMouse.containsMouse ? macColors.minimizeHover : macColors.minimize
                    }
                    return minMouse.containsMouse ? colors.surfaceContainerHighest : "transparent"
                }

                Behavior on color {
                    ColorAnimation { duration: 100 }
                }

                // macOS - icon
                Text {
                    visible: isMacStyle && minMouse.containsMouse
                    anchors.centerIn: parent
                    text: "−"
                    font.pixelSize: currentSize.buttonSize * 0.8
                    font.weight: Font.Bold
                    color: "#995700"
                }

                // Windows/GNOME − icon
                Text {
                    visible: !isMacStyle
                    anchors.centerIn: parent
                    text: "−"
                    font.pixelSize: isWindowsStyle ? 10 : 16
                    font.weight: isWindowsStyle ? Font.Normal : Font.Bold
                    color: colors.onSurface

                    Behavior on color {
                        ColorAnimation { duration: 100 }
                    }
                }
            }

            MouseArea {
                id: minMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                enabled: root.enabled
                onClicked: minimizeClicked()
            }
        }

        // Maximize button
        Item {
            visible: showMaximize
            width: isMacStyle ? currentSize.buttonSize : (isWindowsStyle ? 46 : 32)
            height: isMacStyle ? currentSize.buttonSize : 32

            Rectangle {
                anchors.fill: parent
                radius: isMacStyle ? width / 2 : (isGnomeStyle ? 16 : 0)

                color: {
                    if (isMacStyle) {
                        return maxMouse.containsMouse ? macColors.maximizeHover : macColors.maximize
                    }
                    return maxMouse.containsMouse ? colors.surfaceContainerHighest : "transparent"
                }

                Behavior on color {
                    ColorAnimation { duration: 100 }
                }

                // macOS diagonal arrows
                Text {
                    visible: isMacStyle && maxMouse.containsMouse
                    anchors.centerIn: parent
                    text: isMaximized ? "⤢" : "⤡"
                    font.pixelSize: currentSize.buttonSize * 0.6
                    font.weight: Font.Bold
                    color: "#006500"
                }

                // Windows □ icon
                Rectangle {
                    visible: isWindowsStyle
                    anchors.centerIn: parent
                    width: 9
                    height: 9
                    color: "transparent"
                    border.width: 1
                    border.color: colors.onSurface

                    Rectangle {
                        visible: isMaximized
                        anchors.right: parent.left
                        anchors.bottom: parent.top
                        anchors.rightMargin: -3
                        anchors.bottomMargin: -3
                        width: 9
                        height: 9
                        color: "transparent"
                        border.width: 1
                        border.color: colors.onSurface
                    }
                }

                // GNOME icon
                Text {
                    visible: isGnomeStyle
                    anchors.centerIn: parent
                    text: isMaximized ? "❐" : "□"
                    font.pixelSize: 14
                    color: colors.onSurface

                    Behavior on color {
                        ColorAnimation { duration: 100 }
                    }
                }
            }

            MouseArea {
                id: maxMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                enabled: root.enabled
                onClicked: maximizeClicked()
            }
        }
    }

    Accessible.role: Accessible.ButtonGroup
    Accessible.name: "Window controls"
}
