import QtQuick
import QtQuick.Layouts
import Chi 1.0

ChiApplicationWindow {
    id: window
    width: 780
    height: 820
    minimumWidth: 480
    minimumHeight: 560
    title: "Settings"
    showMenu: false
    controlsStyle: "macOS"

    readonly property var colors: ChiTheme.colors
    property int currentPage: 0

    // ═══════════════════════════════════════════════════════
    //  NAV MODEL  (icon codepoints for Material Icons font)
    // ═══════════════════════════════════════════════════════

    readonly property var navModel: [
        {
            label: "Appearance",
            icon: "\uE40A",
            iconFilled: "\uE40A"
        },
        {
            label: "Sound",
            icon: "\uE050",
            iconFilled: "\uE050"
        },
        {
            label: "About",
            icon: "\uE88E",
            iconFilled: "\uE88E"
        }
    ]

    // ═══════════════════════════════════════════════════════
    //  SHELL LAYOUT
    // ═══════════════════════════════════════════════════════

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // ─── LEFT RAIL ──────────────────────────────────────
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: 80
            color: colors.surfaceContainerLow

            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: 12
                anchors.bottomMargin: 12
                spacing: 4

                // Settings icon header
                Item {
                    Layout.preferredHeight: 56
                    Layout.fillWidth: true

                    Text {
                        anchors.centerIn: parent
                        text: "\uE8B8"
                        font.family: ChiTheme.iconFamily
                        font.pixelSize: 28
                        color: colors.onSurfaceVariant
                    }
                }

                Divider {
                    Layout.fillWidth: true
                    Layout.leftMargin: 16
                    Layout.rightMargin: 16
                }

                Item {
                    Layout.preferredHeight: 8
                }

                // Nav items
                Repeater {
                    model: navModel

                    Item {
                        Layout.preferredHeight: 64
                        Layout.fillWidth: true

                        required property int index
                        required property var modelData

                        readonly property bool active: currentPage === index

                        // Pill indicator
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: 4
                            width: active ? 56 : (navItemMa.containsMouse ? 48 : 0)
                            height: 32
                            radius: 16
                            color: active ? colors.secondaryContainer : colors.onSurface
                            opacity: active ? 1.0 : (navItemMa.containsMouse ? 0.08 : 0)

                            Behavior on width {
                                NumberAnimation {
                                    duration: 250
                                    easing.type: Easing.OutCubic
                                }
                            }
                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 200
                                    easing.type: Easing.OutCubic
                                }
                            }
                        }

                        // Icon
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: 8
                            text: modelData.icon
                            font.family: ChiTheme.iconFamily
                            font.pixelSize: 24
                            color: active ? colors.onSecondaryContainer : colors.onSurfaceVariant

                            Behavior on color {
                                ColorAnimation {
                                    duration: 200
                                }
                            }
                        }

                        // Label
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: 40
                            text: modelData.label
                            font.family: ChiTheme.fontFamily
                            font.pixelSize: 12
                            font.weight: active ? Font.DemiBold : Font.Medium
                            color: active ? colors.onSurface : colors.onSurfaceVariant

                            Behavior on color {
                                ColorAnimation {
                                    duration: 200
                                }
                            }
                        }

                        MouseArea {
                            id: navItemMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: currentPage = index
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                }

                // Dark mode quick-toggle at rail bottom
                Item {
                    Layout.preferredHeight: 48
                    Layout.fillWidth: true

                    Text {
                        anchors.centerIn: parent
                        text: ChiTheme.isDarkMode ? "\uEF44" : "\uE430"
                        font.family: ChiTheme.iconFamily
                        font.pixelSize: 24
                        color: colors.onSurfaceVariant
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: ChiTheme.toggleDarkMode()
                    }
                }
            }
        }

        // Rail / content divider
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: 1
            color: colors.outlineVariant
        }

        // ─── CONTENT AREA ───────────────────────────────────
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Page header
            ColumnLayout {
                id: contentColumn
                anchors.fill: parent
                spacing: 0

                // ── Title bar ───────────────────────────────
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 24
                        anchors.verticalCenter: parent.verticalCenter
                        text: navModel[currentPage].label
                        font.family: ChiTheme.fontFamily
                        font.pixelSize: ChiTheme.typography.headlineSmall.size
                        font.weight: Font.Normal
                        color: colors.onSurface
                    }
                }

                Divider {
                    Layout.fillWidth: true
                }

                // ── Page stack ──────────────────────────────
                StackLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    currentIndex: currentPage

                    AppearancePage {}
                    SoundPage {}
                    AboutPage {}
                }
            }
        }
    }
}
