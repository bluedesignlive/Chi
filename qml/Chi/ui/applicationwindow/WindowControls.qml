// WindowControls.qml — macOS traffic lights + Windows rounded-rect buttons
// Windows buttons use colored Rectangle hover states only (no icon glyphs)
import QtQuick
import QtQuick.Window
import "../../theme" as Theme
import "../common"
import "../menus" as Menus

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
        Menus.Tooltip {
            id: tlTooltip
            text: tlBtn.tooltipText !== "" && !root.menuOpen ? tlBtn.tooltipText : ""
            ready: root._macTooltipsHot
            delay: 500
            positionTarget: tlMouse
            onShown: {
                root._macTooltipsHot = true
                macTooltipsHotTimer.stop()
            }
        }

        function _clampTlTooltip() {
            tlTooltip.x = (parent.width - tlTooltip.width) / 2
            tlTooltip.y = parent.height + 8
            if (root.targetWindow) {
                var sx = tlTooltip.mapToItem(root.targetWindow.contentItem, 0, 0).x
                if (sx < 4) tlTooltip.x += 4 - sx
                if (sx + tlTooltip.width > root.targetWindow.width - 4)
                    tlTooltip.x -= sx + tlTooltip.width - root.targetWindow.width + 4
            }
            tlTooltip._positionCaret()
        }

        Connections {
            target: tlMouse
            function onContainsMouseChanged() {
                if (tlMouse.containsMouse && tlBtn.tooltipText !== "" && !root.menuOpen) {
                    _clampTlTooltip()
                    tlTooltip.show()
                } else {
                    tlTooltip.hide()
                }
            }
        }

        Connections {
            target: tlTooltip
            function onWidthChanged() { if (tlTooltip.isVisible) { _clampTlTooltip(); tlTooltip._positionCaret() } }
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
        Menus.Tooltip {
            id: winTooltip
            text: winBtn.tooltipText !== "" && !root.menuOpen ? winBtn.tooltipText : ""
            ready: root._winTooltipsHot
            delay: 500
            positionTarget: winBtnMouse
            onShown: {
                root._winTooltipsHot = true
                winTooltipsHotTimer.stop()
            }
        }

        function _clampWinTooltip() {
            winTooltip.x = (parent.width - winTooltip.width) / 2
            winTooltip.y = parent.height + 8
            if (root.targetWindow) {
                var sx = winTooltip.mapToItem(root.targetWindow.contentItem, 0, 0).x
                if (sx < 4) winTooltip.x += 4 - sx
                if (sx + winTooltip.width > root.targetWindow.width - 4)
                    winTooltip.x -= sx + winTooltip.width - root.targetWindow.width + 4
            }
            winTooltip._positionCaret()
        }

        Connections {
            target: winBtnMouse
            function onContainsMouseChanged() {
                if (winBtnMouse.containsMouse && winBtn.tooltipText !== "" && !root.menuOpen) {
                    _clampWinTooltip()
                    winTooltip.show()
                } else {
                    winTooltip.hide()
                }
            }
        }

        Connections {
            target: winTooltip
            function onWidthChanged() { if (winTooltip.isVisible) { _clampWinTooltip(); winTooltip._positionCaret() } }
        }
    }
}
