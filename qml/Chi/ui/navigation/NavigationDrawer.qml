import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../theme" as Theme

Item {
    id: root

    // ═════════════════════════════════════════════════════════
    // PUBLIC API
    //
    //  items: [
    //      { section: "Controls", items: [
    //          { text: "Buttons", icon: "smart_button" },
    //      ]},
    //  ]
    //
    //  Flat list (no sections):
    //  items: [
    //      { text: "Home", icon: "home" },
    //  ]
    // ═════════════════════════════════════════════════════════

    property var items: []
    property list<Item> pages
    property int currentIndex: 0
    property string density: "compact"       // "small" | "compact" | "standard"
    property real drawerWidth: -1
    property string position: "left"
    property string headline: ""
    property bool open: !_isNarrow

    default property alias drawerContent: drawerManualColumn.data

    signal closed()

    // ═════════════════════════════════════════════════════════
    // THEME TOKENS
    // ═════════════════════════════════════════════════════════

    readonly property var _c: Theme.ChiTheme.colors
    readonly property var _t: Theme.ChiTheme.typography
    readonly property var _m: Theme.ChiTheme.motion

    // ═════════════════════════════════════════════════════════
    // RESPONSIVE BREAKPOINTS (internal)
    // ═════════════════════════════════════════════════════════

    readonly property bool _isNarrow: width < 560
    readonly property bool _isModal: _isNarrow
    readonly property bool _isLeft: position === "left"

    on_IsNarrowChanged: {
        if (_isNarrow) close()
        else show()
    }

    // ═════════════════════════════════════════════════════════
    // DENSITY METRICS
    //
    //                  small     compact    standard
    //  drawer width    180       200        260
    //  top margin      4         6          0
    //  section left    10        12         16
    //  section top     4         6          12
    //  divider height  5         7          17
    //  divider inset   10        12         28
    //  item spacing    1         1          0
    // ═════════════════════════════════════════════════════════

    readonly property bool _isSmall: density === "small"
    readonly property bool _isStandard: density === "standard"

    readonly property real _resolvedWidth: drawerWidth > 0
        ? drawerWidth
        : (_isSmall ? 200 : _isStandard ? 360 : 240)

    readonly property real _topMargin: _isSmall ? 4 : _isStandard ? 0 : 6
    readonly property real _sectionLeftMargin: _isSmall ? 10 : _isStandard ? 16 : 12
    readonly property real _sectionTopMargin: _isSmall ? 4 : _isStandard ? 12 : 6
    readonly property real _dividerHeight: 1 + (_isSmall ? 4 : _isStandard ? 16 : 6)
    readonly property real _dividerInset: _isSmall ? 10 : _isStandard ? 28 : 12
    readonly property real _itemSpacing: _isStandard ? 0 : 1

    // ═════════════════════════════════════════════════════════
    // MODEL (computed once from items)
    // ═════════════════════════════════════════════════════════

    readonly property bool _hasModel: items.length > 0

    readonly property bool _isSectioned:
        _hasModel && items[0].items !== undefined

    readonly property var _normalizedSections: {
        if (!_hasModel) return []

        if (_isSectioned) {
            var idx = 0
            var result = []
            for (var s = 0; s < items.length; s++) {
                var sec = { name: items[s].section || "", items: [] }
                var sitems = items[s].items
                for (var i = 0; i < sitems.length; i++) {
                    sec.items.push({
                        text: sitems[i].text || "",
                        icon: sitems[i].icon || "",
                        activeIcon: sitems[i].activeIcon || "",
                        pageIndex: idx++
                    })
                }
                result.push(sec)
            }
            return result
        }

        var flat = []
        for (var f = 0; f < items.length; f++) {
            flat.push({
                text: items[f].text || "",
                icon: items[f].icon || "",
                activeIcon: items[f].activeIcon || "",
                pageIndex: f
            })
        }
        return [{ name: "", items: flat }]
    }

    // ═════════════════════════════════════════════════════════
    // PAGE TRANSITION STATE
    // ═════════════════════════════════════════════════════════

    property int _prevIndex: 0
    readonly property bool _goingForward: currentIndex >= _prevIndex

    onCurrentIndexChanged: {
        if (pageStack.count === 0) return
        _pageTransition.restart()
    }

    onPagesChanged: _reparentPages()

    function _reparentPages() {
        for (var i = 0; i < pages.length; i++) {
            pages[i].parent = pageStack
            pages[i].Layout.fillWidth = true
            pages[i].Layout.fillHeight = true
        }
        pageStack.currentIndex = Qt.binding(function() { return root.currentIndex })
    }

    Component.onCompleted: {
        if (pages.length > 0) _reparentPages()
    }

    // ═════════════════════════════════════════════════════════
    // LAYOUT
    // ═════════════════════════════════════════════════════════

    anchors.fill: parent
    z: _isModal ? 1000 : 0

    // ─── Scrim ──────────────────────────────────────────────

    Rectangle {
        id: scrim
        anchors.fill: parent
        color: _c.scrim
        opacity: root.open && root._isModal ? 0.32 : 0
        visible: root._isModal && opacity > 0

        Behavior on opacity {
            NumberAnimation {
                duration: _m.durationMedium
                easing.type: _m.easeStandard
            }
        }

        TapHandler {
            enabled: root.open && root._isModal
            onTapped: root.close()
        }
    }

    // ─── Drawer Panel ───────────────────────────────────────

    Rectangle {
        id: drawerPanel
        width: root._resolvedWidth
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        x: root._isLeft
            ? (root.open ? 0 : -width)
            : (root.open ? parent.width - width : parent.width)

        color: _c.surfaceContainerLow
        radius: 16

        Behavior on x {
            NumberAnimation {
                duration: _m.durationMedium
                easing.type: _m.easeEmphasized
            }
        }

        // Flat-edge: radius only on trailing edge
        Rectangle {
            width: 16
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            color: parent.color
            x: root._isLeft ? 0 : parent.width - width
        }

        // Shadow (modal only)
        layer.enabled: root._isModal && root.open
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.2)
            shadowBlur: 0.4
            shadowHorizontalOffset: root._isLeft ? 4 : -4
            shadowVerticalOffset: 0
        }

        // Edge-swipe dismiss (modal)
        DragHandler {
            enabled: root.open && root._isModal
            target: null
            yAxis.enabled: false

            onActiveChanged: {
                if (!active) {
                    var threshold = root._resolvedWidth * 0.4
                    if (root._isLeft && translation.x < -threshold)
                        root.close()
                    else if (!root._isLeft && translation.x > threshold)
                        root.close()
                }
            }
        }

        // ─── Drawer Content ─────────────────────────────────

        ColumnLayout {
            anchors.fill: parent
            anchors.topMargin: root._topMargin
            spacing: 0

            Text {
                visible: root.headline !== ""
                text: root.headline
                font.family: _t.titleSmall.family
                font.pixelSize: _t.titleSmall.size
                font.weight: _t.titleSmall.weight
                font.letterSpacing: _t.titleSmall.spacing
                color: _c.onSurfaceVariant
                Layout.fillWidth: true
                Layout.topMargin: root._sectionTopMargin
                Layout.leftMargin: root._sectionLeftMargin
                Layout.rightMargin: root._sectionLeftMargin
                Layout.bottomMargin: 2
            }

            Flickable {
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentHeight: root._hasModel
                    ? drawerModelColumn.implicitHeight
                    : drawerManualColumn.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                interactive: contentHeight > height

                // ── Model-driven ────────────────────────────
                ColumnLayout {
                    id: drawerModelColumn
                    width: parent.width
                    visible: root._hasModel
                    spacing: root._itemSpacing

                    Repeater {
                        model: root._normalizedSections

                        delegate: ColumnLayout {
                            id: sectionDelegate

                            required property var modelData
                            required property int index

                            Layout.fillWidth: true
                            spacing: root._itemSpacing

                            // Divider (between sections, never first)
                            Item {
                                visible: sectionDelegate.index > 0
                                Layout.fillWidth: true
                                implicitHeight: root._dividerHeight

                                Rectangle {
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.leftMargin: root._dividerInset
                                    anchors.rightMargin: root._dividerInset
                                    anchors.verticalCenter: parent.verticalCenter
                                    height: 1
                                    color: _c.outlineVariant
                                }
                            }

                            // Section title
                            Text {
                                visible: sectionDelegate.modelData.name !== ""
                                text: sectionDelegate.modelData.name
                                font.family: _t.labelSmall.family
                                font.pixelSize: _t.labelSmall.size
                                font.weight: _t.labelSmall.weight
                                font.letterSpacing: _t.labelSmall.spacing
                                color: _c.onSurfaceVariant
                                Layout.fillWidth: true
                                Layout.leftMargin: root._sectionLeftMargin
                                Layout.rightMargin: root._sectionLeftMargin
                                Layout.topMargin: root._sectionTopMargin
                                Layout.bottomMargin: 2
                            }

                            // Items
                            Repeater {
                                model: sectionDelegate.modelData.items

                                delegate: NavigationDrawerItem {
                                    required property var modelData
                                    required property int index

                                    density: root.density
                                    text: modelData.text
                                    icon: modelData.icon
                                    activeIcon: modelData.activeIcon
                                    selected: root.currentIndex === modelData.pageIndex
                                    Layout.fillWidth: true

                                    onClicked: {
                                        root.currentIndex = modelData.pageIndex
                                        if (root._isModal) root.close()
                                    }
                                }
                            }
                        }
                    }
                }

                // ── Manual fallback ─────────────────────────
                ColumnLayout {
                    id: drawerManualColumn
                    width: parent.width
                    visible: !root._hasModel
                    spacing: root._itemSpacing
                }
            }
        }
    }

    // ═════════════════════════════════════════════════════════
    // CONTENT AREA
    // ═════════════════════════════════════════════════════════

    Item {
        id: contentArea
        anchors.fill: parent
        anchors.leftMargin: root._isModal || !root.open ? 0 : root._resolvedWidth
        clip: true

        Behavior on anchors.leftMargin {
            NumberAnimation {
                duration: _m.durationMedium
                easing.type: _m.easeEmphasized
            }
        }

        property real _animOpacity: 1.0
        property real _animY: 0
        property real _animScale: 1.0

        StackLayout {
            id: pageStack
            anchors.fill: parent
            opacity: contentArea._animOpacity

            transform: [
                Translate { y: contentArea._animY },
                Scale {
                    origin.x: contentArea.width / 2
                    origin.y: contentArea.height / 2
                    xScale: contentArea._animScale
                    yScale: contentArea._animScale
                }
            ]
        }

        SequentialAnimation {
            id: _pageTransition

            ParallelAnimation {
                NumberAnimation {
                    target: contentArea; property: "_animOpacity"
                    to: 0; duration: _m.pageExitDuration
                    easing.type: _m.pageExitEasing
                }
                NumberAnimation {
                    target: contentArea; property: "_animY"
                    to: root._goingForward ? -_m.pageSlideDistance : _m.pageSlideDistance
                    duration: _m.pageExitDuration
                    easing.type: _m.pageExitEasing
                }
                NumberAnimation {
                    target: contentArea; property: "_animScale"
                    to: _m.pageScaleOut
                    duration: _m.pageExitDuration
                    easing.type: _m.pageExitEasing
                }
            }

            ScriptAction {
                script: {
                    pageStack.currentIndex = root.currentIndex
                    contentArea._animY = root._goingForward
                        ? _m.pageSlideDistance : -_m.pageSlideDistance
                    contentArea._animScale = _m.pageScaleOut
                    root._prevIndex = root.currentIndex
                }
            }

            ParallelAnimation {
                NumberAnimation {
                    target: contentArea; property: "_animOpacity"
                    to: 1; duration: _m.pageEnterDuration
                    easing.type: _m.pageEnterEasing
                }
                NumberAnimation {
                    target: contentArea; property: "_animY"
                    to: 0; duration: _m.pageEnterDuration
                    easing.type: _m.pageEnterEasing
                }
                NumberAnimation {
                    target: contentArea; property: "_animScale"
                    to: 1.0; duration: _m.pageEnterDuration
                    easing.type: _m.pageEnterEasing
                }
            }
        }
    }

    // ═════════════════════════════════════════════════════════
    // KEYBOARD / METHODS / ACCESSIBILITY
    // ═════════════════════════════════════════════════════════

    Keys.onEscapePressed: (event) => {
        if (root.open) root.close()
    }

    function show() { root.open = true }

    function close() {
        root.open = false
        root.closed()
    }

    function toggle() {
        if (root.open) close()
        else show()
    }

    Accessible.role: Accessible.Pane
    Accessible.name: headline !== "" ? headline : "Navigation drawer"
}
