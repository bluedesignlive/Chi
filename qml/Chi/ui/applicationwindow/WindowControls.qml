// WindowControls.qml
import QtQuick
import QtQuick.Window
import "../../theme" as Theme
import "../common"

Item {
    id: root

    property var targetWindow: null
    property var colors: Theme.ChiTheme.colors

    // Material icon names — Windows style only (16px renders fine)
    property string minimizeIcon: "remove"
    property string maximizeIcon: "crop_square"
    property string restoreIcon: "filter_none"
    property string closeIcon: "close"

    property bool showMinimize: true
    property bool showMaximize: true
    property bool showClose: true

    property string variant: "macOS"

    implicitWidth: variant === "macOS" ? macContainer.implicitWidth : winRow.implicitWidth
    implicitHeight: variant === "macOS" ? 24 : 36

    // ═══════════════════════════════════════════════════════════════
    // macOS TRAFFIC LIGHTS
    //
    // HoverHandler on the group container: hovering ANY dot reveals
    // icons on ALL dots — matching native macOS behaviour.
    // HoverHandler is non-blocking so child MouseAreas retain
    // individual press/hover states and click handling.
    //
    // States (matching real macOS):
    //   inactive + not hovered  → grey dots, no icons
    //   inactive + group hover  → coloured dots, icons visible
    //   active   + not hovered  → coloured dots, no icons
    //   active   + group hover  → coloured dots, icons visible
    // ═══════════════════════════════════════════════════════════════

    Item {
        id: macContainer
        visible: root.variant === "macOS"
        anchors.centerIn: parent
        implicitWidth: macRow.implicitWidth + 12
        implicitHeight: 24

        HoverHandler { id: macGroupHover }

        Row {
            id: macRow
            anchors.centerIn: parent
            spacing: 8

            TrafficLightButton {
                visible: root.showClose
                baseColor: "#FF5F57"
                iconType: "close"
                tooltipText: "Close window"
                groupHovered: macGroupHover.hovered
                onClicked: root.targetWindow?.close()
            }

            TrafficLightButton {
                visible: root.showMinimize
                baseColor: "#FEBC2E"
                iconType: "minimize"
                tooltipText: "Minimize"
                groupHovered: macGroupHover.hovered
                onClicked: root.targetWindow?.showMinimized()
            }

            TrafficLightButton {
                visible: root.showMaximize
                baseColor: "#28C840"
                iconType: root.targetWindow?.visibility === Window.Maximized
                          ? "restore" : "maximize"
                tooltipText: root.targetWindow?.visibility === Window.Maximized
                             ? "Restore" : "Maximize"
                groupHovered: macGroupHover.hovered
                onClicked: {
                    if (root.targetWindow) {
                        if (root.targetWindow.visibility === Window.Maximized)
                            root.targetWindow.showNormal()
                        else
                            root.targetWindow.showMaximized()
                    }
                }
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // WINDOWS STYLE
    // ═══════════════════════════════════════════════════════════════

    Row {
        id: winRow
        visible: root.variant !== "macOS"
        anchors.centerIn: parent
        spacing: 2

        WindowsButton {
            visible: root.showMinimize
            iconName: root.minimizeIcon
            tooltipText: "Minimize"
            accentColor: root.colors.tertiary
            onClicked: root.targetWindow?.showMinimized()
        }

        WindowsButton {
            visible: root.showMaximize
            iconName: root.targetWindow?.visibility === Window.Maximized
                      ? root.restoreIcon : root.maximizeIcon
            tooltipText: root.targetWindow?.visibility === Window.Maximized
                         ? "Restore" : "Maximize"
            accentColor: root.colors.secondary
            onClicked: {
                if (root.targetWindow) {
                    if (root.targetWindow.visibility === Window.Maximized)
                        root.targetWindow.showNormal()
                    else
                        root.targetWindow.showMaximized()
                }
            }
        }

        WindowsButton {
            visible: root.showClose
            iconName: root.closeIcon
            tooltipText: "Close window"
            accentColor: root.colors.error
            onClicked: root.targetWindow?.close()
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // TRAFFIC LIGHT BUTTON
    //
    // 12px coloured circle with Canvas-drawn icon glyphs.
    // Canvas gives pixel-perfect 1.5px strokes at small sizes
    // where Material Icons font becomes illegible sub-pixel mush.
    // Scales cleanly with device pixel ratio (Qt6 Canvas handles
    // DPR automatically — logical coords map to physical pixels).
    // ═══════════════════════════════════════════════════════════════

    component TrafficLightButton: Item {
        id: tlBtn

        property color baseColor: "#888"
        property string iconType: "close"
        property string tooltipText: ""
        property bool groupHovered: false

        signal clicked()

        width: 12
        height: 12

        onIconTypeChanged: iconCanvas.requestPaint()

        readonly property bool _windowActive: root.targetWindow
                                              ? root.targetWindow.active : true
        readonly property bool _showColor: groupHovered || _windowActive

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            antialiasing: true

            color: {
                if (!tlBtn._showColor)
                    return root.colors.outlineVariant
                if (tlMouse.pressed)
                    return Qt.darker(tlBtn.baseColor, 1.3)
                if (tlMouse.containsMouse)
                    return Qt.lighter(tlBtn.baseColor, 1.15)
                return tlBtn.baseColor
            }

            border.width: tlBtn._showColor ? 0.5 : 0
            border.color: Qt.darker(tlBtn.baseColor, 1.4)

            Behavior on color { ColorAnimation { duration: 100 } }

            Canvas {
                id: iconCanvas
                anchors.centerIn: parent
                width: 8
                height: 8
                opacity: tlBtn.groupHovered ? 1.0 : 0.0
                visible: opacity > 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 120
                        easing.type: Easing.OutCubic
                    }
                }

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)

                    ctx.strokeStyle = Qt.darker(tlBtn.baseColor, 2.8).toString()
                    ctx.lineWidth = 1.5
                    ctx.lineCap = "round"
                    ctx.lineJoin = "round"

                    switch (tlBtn.iconType) {

                    case "close":
                        ctx.beginPath()
                        ctx.moveTo(1, 1)
                        ctx.lineTo(7, 7)
                        ctx.moveTo(7, 1)
                        ctx.lineTo(1, 7)
                        ctx.stroke()
                        break

                    case "minimize":
                        ctx.beginPath()
                        ctx.moveTo(1, 4)
                        ctx.lineTo(7, 4)
                        ctx.stroke()
                        break

                    case "maximize":
                        ctx.beginPath()
                        ctx.moveTo(4, 1)
                        ctx.lineTo(7, 1)
                        ctx.lineTo(7, 4)
                        ctx.stroke()
                        ctx.beginPath()
                        ctx.moveTo(4, 7)
                        ctx.lineTo(1, 7)
                        ctx.lineTo(1, 4)
                        ctx.stroke()
                        break

                    case "restore":
                        ctx.beginPath()
                        ctx.moveTo(7, 3)
                        ctx.lineTo(5, 3)
                        ctx.lineTo(5, 1)
                        ctx.stroke()
                        ctx.beginPath()
                        ctx.moveTo(1, 5)
                        ctx.lineTo(3, 5)
                        ctx.lineTo(3, 7)
                        ctx.stroke()
                        break
                    }
                }

                Component.onCompleted: requestPaint()
            }
        }

        MouseArea {
            id: tlMouse
            anchors.fill: parent
            anchors.margins: -3
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: tlBtn.clicked()
        }

        // Tooltip
        Item {
            id: tlTooltip
            anchors.horizontalCenter: parent.horizontalCenter
            y: tlTooltipShown ? parent.height + 8 : parent.height + 2
            width: tlTooltipLabel.implicitWidth + 16
            height: 24
            z: 2000

            property bool tlTooltipShown: tlMouse.containsMouse
                                          && tlBtn.tooltipText !== ""
                                          && !tlTooltipDelay.running
                                          && tlTooltipReady

            property bool tlTooltipReady: false

            Timer {
                id: tlTooltipDelay
                interval: 1000
                onTriggered: tlTooltip.tlTooltipReady = true
            }

            Connections {
                target: tlMouse
                function onContainsMouseChanged() {
                    if (tlMouse.containsMouse) {
                        tlTooltip.tlTooltipReady = false
                        tlTooltipDelay.restart()
                    } else {
                        tlTooltipDelay.stop()
                        tlTooltip.tlTooltipReady = false
                    }
                }
            }

            scale: tlTooltipShown ? 1.0 : 0.85
            opacity: tlTooltipShown ? 1.0 : 0
            visible: opacity > 0
            transformOrigin: Item.Top

            Behavior on opacity {
                NumberAnimation {
                    duration: tlTooltip.tlTooltipShown ? 200 : 120
                    easing.type: tlTooltip.tlTooltipShown ? Easing.OutQuart : Easing.InQuart
                }
            }
            Behavior on scale {
                NumberAnimation {
                    duration: tlTooltip.tlTooltipShown ? 250 : 120
                    easing.type: tlTooltip.tlTooltipShown ? Easing.OutBack : Easing.InQuart
                    easing.overshoot: 1.2
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: 4
                color: root.colors.inverseSurface
            }

            Text {
                id: tlTooltipLabel
                anchors.centerIn: parent
                text: tlBtn.tooltipText
                font.pixelSize: 11
                font.weight: Font.Medium
                color: root.colors.inverseOnSurface
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // WINDOWS BUTTON
    //
    // 32px rounded-rect with Material Icons via Icon component.
    // At 16px, Material Icons render within their designed range.
    // ═══════════════════════════════════════════════════════════════

    component WindowsButton: Item {
        id: winBtn

        property string iconName: ""
        property string tooltipText: ""
        property color accentColor: root.colors.primary

        signal clicked()

        width: 32
        height: 32

        Rectangle {
            anchors.fill: parent
            radius: 8

            color: {
                if (winBtnMouse.pressed)
                    return Qt.rgba(winBtn.accentColor.r, winBtn.accentColor.g,
                                   winBtn.accentColor.b, 0.25)
                if (winBtnMouse.containsMouse)
                    return Qt.rgba(winBtn.accentColor.r, winBtn.accentColor.g,
                                   winBtn.accentColor.b, 0.15)
                return Qt.rgba(winBtn.accentColor.r, winBtn.accentColor.g,
                               winBtn.accentColor.b, 0.05)
            }

            Behavior on color { ColorAnimation { duration: 100 } }
        }

        Icon {
            anchors.centerIn: parent
            source: winBtn.iconName
            size: 16
            color: winBtnMouse.containsMouse
                   ? winBtn.accentColor : root.colors.onSurfaceVariant

            Behavior on color { ColorAnimation { duration: 150 } }
        }

        MouseArea {
            id: winBtnMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: winBtn.clicked()
        }

        // Tooltip
        Item {
            id: winTooltip
            anchors.horizontalCenter: parent.horizontalCenter
            y: winTooltipShown ? parent.height + 6 : parent.height + 2
            width: winTooltipLabel.implicitWidth + 16
            height: 24
            z: 2000

            property bool winTooltipShown: winBtnMouse.containsMouse
                                           && winBtn.tooltipText !== ""
                                           && !winTooltipDelay.running
                                           && winTooltipReady

            property bool winTooltipReady: false

            Timer {
                id: winTooltipDelay
                interval: 1000
                onTriggered: winTooltip.winTooltipReady = true
            }

            Connections {
                target: winBtnMouse
                function onContainsMouseChanged() {
                    if (winBtnMouse.containsMouse) {
                        winTooltip.winTooltipReady = false
                        winTooltipDelay.restart()
                    } else {
                        winTooltipDelay.stop()
                        winTooltip.winTooltipReady = false
                    }
                }
            }

            scale: winTooltipShown ? 1.0 : 0.85
            opacity: winTooltipShown ? 1.0 : 0
            visible: opacity > 0
            transformOrigin: Item.Top

            Behavior on opacity {
                NumberAnimation {
                    duration: winTooltip.winTooltipShown ? 200 : 120
                    easing.type: winTooltip.winTooltipShown ? Easing.OutQuart : Easing.InQuart
                }
            }
            Behavior on scale {
                NumberAnimation {
                    duration: winTooltip.winTooltipShown ? 250 : 120
                    easing.type: winTooltip.winTooltipShown ? Easing.OutBack : Easing.InQuart
                    easing.overshoot: 1.2
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: 4
                color: root.colors.inverseSurface
            }

            Text {
                id: winTooltipLabel
                anchors.centerIn: parent
                text: winBtn.tooltipText
                font.pixelSize: 11
                font.weight: Font.Medium
                color: root.colors.inverseOnSurface
            }
        }
    }
}
