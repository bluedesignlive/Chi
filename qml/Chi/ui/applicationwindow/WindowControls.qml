// WindowControls.qml — macOS traffic lights + Windows rounded-rect buttons
// Windows buttons use colored Rectangle hover states only (no icon glyphs)
import QtQuick
import QtQuick.Window
import "../../theme" as Theme
import "../common"

Item {
    id: root

    property var targetWindow: null
    property var colors: Theme.ChiTheme.colors

    property bool showMinimize: true
    property bool showMaximize: true
    property bool showClose: true

    property string variant: "macOS"
    property bool menuOpen: false

    // Group tooltip hot state — when true, subsequent buttons skip
    // the 1000ms delay when moving between buttons in the same group.
    property bool _macTooltipsHot: false
    property bool _winTooltipsHot: false

    implicitWidth: variant === "macOS" ? macContainer.implicitWidth : winRow.implicitWidth
    implicitHeight: variant === "macOS" ? 24 : 36

    // ═══════════════════════════════════════════════════════════════
    // macOS TRAFFIC LIGHTS
    //
    // HoverHandler on the group container: hovering ANY dot reveals
    // all colored dots — matching native macOS behaviour.
    // No icon glyphs drawn inside the circles.
    //
    // States:
    //   inactive + not hovered  → grey dots
    //   inactive + group hover  → coloured dots
    //   active   + not hovered  → coloured dots
    // ═══════════════════════════════════════════════════════════════

    Item {
        id: macContainer
        visible: root.variant === "macOS"
        anchors.centerIn: parent
        implicitWidth: macRow.implicitWidth + 12
        implicitHeight: 24

        HoverHandler { id: macGroupHover }

        // Hot state: after first tooltip shows, moving between buttons
        // skips the delay until the cursor leaves the group.
        Timer {
            id: macTooltipsHotTimer
            interval: 500
            onTriggered: root._macTooltipsHot = false
        }
        Connections {
            target: macGroupHover
            function onHoveredChanged() {
                if (!macGroupHover.hovered)
                    macTooltipsHotTimer.restart()
            }
        }

        Row {
            id: macRow
            anchors.centerIn: parent
            spacing: 8

            TrafficLightButton {
                visible: root.showClose
                baseColor: "#FF5F57"
                tooltipText: qsTr("Close  Alt+F4")
                groupHovered: macGroupHover.hovered
                onClicked: root.targetWindow?.close()
            }

            TrafficLightButton {
                visible: root.showMinimize
                baseColor: "#FEBC2E"
                tooltipText: qsTr("Minimize")
                groupHovered: macGroupHover.hovered
                onClicked: root.targetWindow?.showMinimized()
            }

            TrafficLightButton {
                visible: root.showMaximize
                baseColor: "#28C840"
                tooltipText: root.targetWindow?.visibility === Window.Maximized
                             ? qsTr("Restore") : qsTr("Maximize")
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

        HoverHandler { id: winGroupHover }

        Timer {
            id: winTooltipsHotTimer
            interval: 500
            onTriggered: root._winTooltipsHot = false
        }
        Connections {
            target: winGroupHover
            function onHoveredChanged() {
                if (!winGroupHover.hovered)
                    winTooltipsHotTimer.restart()
            }
        }

        WindowsButton {
            visible: root.showMinimize
            tooltipText: "Minimize"
            accentColor: root.colors.tertiary
            onClicked: root.targetWindow?.showMinimized()
        }

        WindowsButton {
            visible: root.showMaximize
            tooltipText: root.targetWindow?.visibility === Window.Maximized
                         ? qsTr("Restore") : qsTr("Maximize")
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
            tooltipText: qsTr("Close window  Alt+F4")
            accentColor: root.colors.error
            onClicked: root.targetWindow?.close()
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // TRAFFIC LIGHT BUTTON
    //
    // 12px coloured circle — no icon glyphs, just color.
    // Three states: inactive grey, active color, pressed darker.
    // ═══════════════════════════════════════════════════════════════

    component TrafficLightButton: Item {
        id: tlBtn

        property color baseColor: "#888"
        property string tooltipText: ""
        property bool groupHovered: false

        signal clicked()

        width: 12
        height: 12

        Accessible.role: Accessible.Button
        Accessible.name: tooltipText
        Accessible.onPressAction: clicked

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
            y: tlTooltipShown ? parent.height + 8 : parent.height + 2
            width: tlTooltipLabel.implicitWidth + 16
            height: 24
            z: 2000

            property bool tlTooltipShown: tlMouse.containsMouse
                                          && tlBtn.tooltipText !== ""
                                          && !tlTooltipDelay.running
                                          && tlTooltipReady
                                          && !root.menuOpen

            property bool tlTooltipReady: false
            onTlTooltipShownChanged: {
                if (tlTooltipShown) {
                    root._macTooltipsHot = true
                    macTooltipsHotTimer.stop()
                }
            }

            // Clamp to window edges
            onWidthChanged: _clampX()
            onVisibleChanged: if (visible) _clampX()
            function _clampX() {
                var cx = parent.width / 2 - width / 2
                if (root.targetWindow) {
                    var sx = mapToItem(root.targetWindow.contentItem, 0, 0).x
                    if (sx < 4) cx += -sx + 4
                    if (sx + width > root.targetWindow.width - 4)
                        cx += root.targetWindow.width - 4 - sx - width
                }
                x = cx
            }

            Timer {
                id: tlTooltipDelay
                interval: 500
                onTriggered: tlTooltip.tlTooltipReady = true
            }

            Connections {
                target: tlMouse
                function onContainsMouseChanged() {
                    if (tlMouse.containsMouse) {
                        if (root._macTooltipsHot) {
                            tlTooltip.tlTooltipReady = true
                        } else {
                            tlTooltip.tlTooltipReady = false
                            tlTooltipDelay.restart()
                        }
                    } else {
                        tlTooltipDelay.stop()
                        tlTooltip.tlTooltipReady = false
                    }
                }
            }

            scale: tlTooltipShown ? 1.0 : 0.92
            opacity: tlTooltipShown ? 1.0 : 0
            visible: opacity > 0
            transformOrigin: Item.Top

            Behavior on opacity {
                NumberAnimation {
                    duration: tlTooltip.tlTooltipShown ? 200 : 100
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on scale {
                NumberAnimation {
                    duration: tlTooltip.tlTooltipShown ? 250 : 100
                    easing.type: Easing.OutCubic
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: 4
                color: root.colors.inverseSurface
            }

            // Caret arrow
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                y: -4
                width: 8; height: 8
                color: root.colors.inverseSurface
                transform: Rotation { origin.x: 4; origin.y: 4; angle: 45 }
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
    // 32px rounded-rect with colored hover/press/accent state.
    // No icon glyphs — colored fill + hover animation is the visual cue.
    // ═══════════════════════════════════════════════════════════════

    component WindowsButton: Item {
        id: winBtn

        property string tooltipText: ""
        property color accentColor: root.colors.primary

        signal clicked()

        width: 32
        height: 32

        Accessible.role: Accessible.Button
        Accessible.name: tooltipText
        Accessible.onPressAction: clicked

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
            y: winTooltipShown ? parent.height + 6 : parent.height + 2
            width: winTooltipLabel.implicitWidth + 16
            height: 24
            z: 2000

            property bool winTooltipShown: winBtnMouse.containsMouse
                                           && winBtn.tooltipText !== ""
                                           && !winTooltipDelay.running
                                           && winTooltipReady
                                           && !root.menuOpen

            property bool winTooltipReady: false
            onWinTooltipShownChanged: {
                if (winTooltipShown) {
                    root._winTooltipsHot = true
                    winTooltipsHotTimer.stop()
                }
            }

            onWidthChanged: _clampX()
            onVisibleChanged: if (visible) _clampX()
            function _clampX() {
                var cx = parent.width / 2 - width / 2
                if (root.targetWindow) {
                    var sx = mapToItem(root.targetWindow.contentItem, 0, 0).x
                    if (sx < 4) cx += -sx + 4
                    if (sx + width > root.targetWindow.width - 4)
                        cx += root.targetWindow.width - 4 - sx - width
                }
                x = cx
            }

            Timer {
                id: winTooltipDelay
                interval: 500
                onTriggered: winTooltip.winTooltipReady = true
            }

            Connections {
                target: winBtnMouse
                function onContainsMouseChanged() {
                    if (winBtnMouse.containsMouse) {
                        if (root._winTooltipsHot) {
                            winTooltip.winTooltipReady = true
                        } else {
                            winTooltip.winTooltipReady = false
                            winTooltipDelay.restart()
                        }
                    } else {
                        winTooltipDelay.stop()
                        winTooltip.winTooltipReady = false
                    }
                }
            }

            scale: winTooltipShown ? 1.0 : 0.92
            opacity: winTooltipShown ? 1.0 : 0
            visible: opacity > 0
            transformOrigin: Item.Top

            Behavior on opacity {
                NumberAnimation {
                    duration: winTooltip.winTooltipShown ? 200 : 100
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on scale {
                NumberAnimation {
                    duration: winTooltip.winTooltipShown ? 250 : 100
                    easing.type: Easing.OutCubic
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: 4
                color: root.colors.inverseSurface
            }

            // Caret arrow
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                y: -4
                width: 8; height: 8
                color: root.colors.inverseSurface
                transform: Rotation { origin.x: 4; origin.y: 4; angle: 45 }
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
