import QtQuick
import QtQuick.Layouts
import Chi 1.0

ChiApplicationWindow {
    id: window
    width: 620
    height: 740
    minimumWidth: 420
    minimumHeight: 500
    title: "Chi Settings"
    showMenu: false
    controlsStyle: "macOS"

    property var colors: ChiTheme.colors
    property bool showCustomPicker: false

    readonly property var presets: [
        { name: "Deep Purple", hex: "#673AB7" },
        { name: "Red",         hex: "#D32F2F" },
        { name: "Pink",        hex: "#C2185B" },
        { name: "Purple",      hex: "#7B1FA2" },
        { name: "Indigo",      hex: "#303F9F" },
        { name: "Blue",        hex: "#1976D2" },
        { name: "Cyan",        hex: "#0097A7" },
        { name: "Teal",        hex: "#00796B" },
        { name: "Green",       hex: "#388E3C" },
        { name: "Lime",        hex: "#689F38" },
        { name: "Orange",      hex: "#F57C00" },
        { name: "Deep Orange", hex: "#E64A19" },
        { name: "Brown",       hex: "#5D4037" },
        { name: "Blue Grey",   hex: "#455A64" }
    ]

    // ═══════════════════════════════════════════════════════
    // INLINE COMPONENTS
    // ═══════════════════════════════════════════════════════

    component SectionLabel: Text {
        property string label: ""
        text: label.toUpperCase()
        font.family: ChiTheme.fontFamily
        font.pixelSize: 12
        font.weight: Font.Medium
        font.letterSpacing: 0.8
        color: colors.primary
        leftPadding: 16
        topPadding: 8
        bottomPadding: 4
    }

    component SettingsCard: Rectangle {
        default property alias content: _cardCol.data
        width: parent.width
        implicitHeight: _cardCol.implicitHeight + 32
        radius: 16
        color: colors.surfaceContainerLow
        border.width: 1
        border.color: colors.outlineVariant

        Column {
            id: _cardCol
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 16
            spacing: 12
        }
    }

    component ColorDot: Rectangle {
        property color dotColor: "#000000"
        property bool selected: false
        signal clicked()

        width: 40; height: 40; radius: 20
        color: dotColor
        border.width: selected ? 3 : 0
        border.color: colors.onSurface

        Rectangle {
            visible: parent.selected
            anchors.centerIn: parent
            width: 16; height: 16; radius: 8
            color: parent.dotColor.hslLightness > 0.5 ? "#000000" : "#FFFFFF"

            Text {
                anchors.centerIn: parent
                text: "\u2713"
                font.pixelSize: 11; font.weight: Font.Bold
                color: parent.color.hslLightness > 0.5 ? "#FFFFFF" : "#000000"
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: parent.clicked()
        }
    }

    component ColorSwatch: Rectangle {
        property string label: ""
        property color swatchColor: "#000000"
        width: parent ? parent.width : 100
        height: 42; radius: 10; color: swatchColor

        Text {
            anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 12
            text: parent.label
            font.family: ChiTheme.fontFamily; font.pixelSize: 12; font.weight: Font.Medium
            color: parent.swatchColor.hslLightness > 0.5 ? "#1C1B1F" : "#FFFFFF"
        }

        Text {
            anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 12
            text: parent.swatchColor.toString().toUpperCase()
            font.family: ChiTheme.fontFamily; font.pixelSize: 11
            color: parent.swatchColor.hslLightness > 0.5
                   ? Qt.rgba(0, 0, 0, 0.5) : Qt.rgba(1, 1, 1, 0.6)
        }
    }

    // ═══════════════════════════════════════════════════════
    // MAIN CONTENT
    // ═══════════════════════════════════════════════════════

    Flickable {
        anchors.fill: parent
        contentHeight: mainCol.height + 48
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: mainCol
            width: Math.min(560, parent.width - 48)
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12
            topPadding: 16
            bottomPadding: 32

            // ── APPEARANCE ──────────────────────────────────
            SectionLabel { label: "Appearance" }

            // ── Dark Mode Toggle ────────────────────────────
            SettingsCard {
                Rectangle {
                    width: parent.width; height: 52; radius: 12
                    color: _darkRow.containsMouse ? colors.surfaceContainerHighest : "transparent"

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 12; anchors.rightMargin: 12
                        spacing: 16

                        Rectangle {
                            width: 40; height: 40; radius: 20
                            anchors.verticalCenter: parent.verticalCenter
                            color: colors.primaryContainer

                            Text {
                                anchors.centerIn: parent
                                text: ChiTheme.isDarkMode ? "\uEF44" : "\uE430"
                                font.family: ChiTheme.iconFamily
                                font.pixelSize: 22
                                color: colors.onPrimaryContainer
                            }
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - 120; spacing: 2

                            Text {
                                text: "Dark Mode"
                                font.family: ChiTheme.fontFamily; font.pixelSize: 16
                                font.weight: Font.Medium; color: colors.onSurface
                            }
                            Text {
                                text: ChiTheme.isDarkMode ? "On" : "Off"
                                font.family: ChiTheme.fontFamily; font.pixelSize: 13
                                color: colors.onSurfaceVariant
                            }
                        }

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 52; height: 32; radius: 16
                            color: ChiTheme.isDarkMode ? colors.primary : colors.surfaceContainerHighest
                            border.width: ChiTheme.isDarkMode ? 0 : 2
                            border.color: colors.outline

                            Rectangle {
                                width: ChiTheme.isDarkMode ? 24 : 16
                                height: width; radius: width / 2
                                anchors.verticalCenter: parent.verticalCenter
                                x: ChiTheme.isDarkMode ? parent.width - width - 4 : 6
                                color: ChiTheme.isDarkMode ? colors.onPrimary : colors.outline
                                Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                                Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                            }
                        }
                    }

                    MouseArea {
                        id: _darkRow; anchors.fill: parent
                        hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onClicked: ChiTheme.toggleDarkMode()
                    }
                }
            }

            // ── Accent Color ────────────────────────────────
            SettingsCard {
                Row {
                    spacing: 12
                    Rectangle {
                        width: 40; height: 40; radius: 20
                        anchors.verticalCenter: parent.verticalCenter
                        color: colors.primaryContainer
                        Text {
                            anchors.centerIn: parent; text: "\uE40A"
                            font.family: ChiTheme.iconFamily; font.pixelSize: 22
                            color: colors.onPrimaryContainer
                        }
                    }
                    Column {
                        anchors.verticalCenter: parent.verticalCenter; spacing: 2
                        Text {
                            text: "Accent Color"
                            font.family: ChiTheme.fontFamily; font.pixelSize: 16
                            font.weight: Font.Medium; color: colors.onSurface
                        }
                        Text {
                            text: "Affects buttons, links, and highlights"
                            font.family: ChiTheme.fontFamily; font.pixelSize: 13
                            color: colors.onSurfaceVariant
                        }
                    }
                }

                Rectangle {
                    width: parent.width; height: 44; radius: 12
                    color: ChiTheme.primaryColor
                    Text {
                        anchors.centerIn: parent
                        text: ChiTheme.primaryColor.toString().toUpperCase()
                        font.family: ChiTheme.fontFamily; font.pixelSize: 14; font.weight: Font.Medium
                        color: ChiTheme.primaryColor.hslLightness > 0.5 ? "#1C1B1F" : "#FFFFFF"
                    }
                }

                Flow {
                    width: parent.width; spacing: 8
                    Repeater {
                        model: presets
                        ColorDot {
                            dotColor: modelData.hex
                            selected: {
                                var a = Qt.color(modelData.hex)
                                var b = ChiTheme.primaryColor
                                return Math.abs(a.r - b.r) < 0.02
                                    && Math.abs(a.g - b.g) < 0.02
                                    && Math.abs(a.b - b.b) < 0.02
                            }
                            onClicked: {
                                ChiTheme.setPrimaryColor(modelData.hex)
                                showCustomPicker = false
                            }
                        }
                    }
                }

                Rectangle {
                    width: parent.width; height: 44; radius: 12
                    color: _customBtn.containsMouse ? colors.surfaceContainerHighest : colors.surfaceContainer
                    border.width: 1; border.color: colors.outlineVariant

                    Row {
                        anchors.centerIn: parent; spacing: 8
                        Text {
                            text: "\uE3B8"; font.family: ChiTheme.iconFamily
                            font.pixelSize: 20; color: colors.primary
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: showCustomPicker ? "Hide Color Picker" : "Custom Color\u2026"
                            font.family: ChiTheme.fontFamily; font.pixelSize: 14
                            font.weight: Font.Medium; color: colors.primary
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    MouseArea {
                        id: _customBtn; anchors.fill: parent
                        hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onClicked: showCustomPicker = !showCustomPicker
                    }
                }
            }

            // ── Color Picker ────────────────────────────────
            ColorPicker {
                visible: showCustomPicker
                width: Math.min(328, parent.width)
                anchors.horizontalCenter: parent.horizontalCenter
                initialColor: ChiTheme.primaryColor
                showAlpha: false
                showEyedropper: false
                showHistory: true
                showActions: true

                onColorSelected: function(c) {
                    ChiTheme.setPrimaryColor(c)
                    showCustomPicker = false
                }
                onCancelled: showCustomPicker = false
            }

            // ── PREVIEW ─────────────────────────────────────
            SectionLabel { label: "Preview" }

            SettingsCard {
                Text {
                    text: "Components"
                    font.family: ChiTheme.fontFamily; font.pixelSize: 14
                    font.weight: Font.Medium; color: colors.onSurfaceVariant
                }

                Row {
                    spacing: 8
                    Button { text: "Filled"; variant: "filled" }
                    Button { text: "Tonal"; variant: "tonal" }
                    Button { text: "Outlined"; variant: "outlined" }
                }

                Row {
                    spacing: 12
                    IconButton { icon: "favorite"; variant: "filled" }
                    IconButton { icon: "bookmark"; variant: "tonal" }
                    IconButton { icon: "share"; variant: "outlined" }
                    IconButton { icon: "more_vert" }
                }
            }

            SettingsCard {
                Text {
                    text: "Color Palette"
                    font.family: ChiTheme.fontFamily; font.pixelSize: 14
                    font.weight: Font.Medium; color: colors.onSurfaceVariant
                }

                ColorSwatch { label: "Primary";           swatchColor: colors.primary }
                ColorSwatch { label: "Primary Container"; swatchColor: colors.primaryContainer }
                ColorSwatch { label: "Secondary";         swatchColor: colors.secondary }
                ColorSwatch { label: "Tertiary";          swatchColor: colors.tertiary }
                ColorSwatch { label: "Error";             swatchColor: colors.error }

                Rectangle {
                    width: parent.width
                    height: _surfCol.implicitHeight + 16
                    radius: 10; color: colors.surface
                    border.width: 1; border.color: colors.outlineVariant

                    Column {
                        id: _surfCol
                        anchors.fill: parent; anchors.margins: 8; spacing: 4

                        Repeater {
                            model: [
                                { l: "Surface",                  c: "surface" },
                                { l: "Surface Container",        c: "surfaceContainer" },
                                { l: "Surface Container High",   c: "surfaceContainerHigh" },
                                { l: "Surface Container Highest", c: "surfaceContainerHighest" }
                            ]

                            Rectangle {
                                width: parent.width; height: 32; radius: 8
                                color: colors[modelData.c]
                                Text {
                                    anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                                    anchors.leftMargin: 12
                                    text: modelData.l
                                    font.family: ChiTheme.fontFamily; font.pixelSize: 12
                                    color: colors.onSurface
                                }
                            }
                        }
                    }
                }
            }

            // ── RESET ───────────────────────────────────────
            SectionLabel { label: "Reset" }

            SettingsCard {
                Rectangle {
                    width: parent.width; height: 48; radius: 12
                    color: _resetMa.containsMouse ? colors.errorContainer : "transparent"
                    border.width: 1; border.color: colors.outlineVariant

                    Row {
                        anchors.centerIn: parent; spacing: 8
                        Text {
                            text: "\uE8BA"; font.family: ChiTheme.iconFamily
                            font.pixelSize: 20; color: colors.error
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: "Reset to Defaults"
                            font.family: ChiTheme.fontFamily; font.pixelSize: 14
                            font.weight: Font.Medium; color: colors.error
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    MouseArea {
                        id: _resetMa; anchors.fill: parent
                        hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            ChiTheme.setDarkMode(true)
                            ChiTheme.setPrimaryColor("#673AB7")
                            showCustomPicker = false
                        }
                    }
                }
            }

            // ── ABOUT ───────────────────────────────────────
            SectionLabel { label: "About" }

            SettingsCard {
                Row {
                    spacing: 16
                    Rectangle {
                        width: 48; height: 48; radius: 12
                        anchors.verticalCenter: parent.verticalCenter
                        color: colors.primaryContainer
                        Text {
                            anchors.centerIn: parent; text: "\u03C7"
                            font.pixelSize: 24; font.weight: Font.Bold
                            color: colors.onPrimaryContainer
                        }
                    }
                    Column {
                        anchors.verticalCenter: parent.verticalCenter; spacing: 2
                        Text {
                            text: "Chi Design System"
                            font.family: ChiTheme.fontFamily; font.pixelSize: 16
                            font.weight: Font.Medium; color: colors.onSurface
                        }
                        Text {
                            text: "Material Design 3 for Qt/QML"
                            font.family: ChiTheme.fontFamily; font.pixelSize: 13
                            color: colors.onSurfaceVariant
                        }
                        Text {
                            text: "Version 1.0"
                            font.family: ChiTheme.fontFamily; font.pixelSize: 12
                            color: colors.outline
                        }
                    }
                }
            }
        }
    }
}
