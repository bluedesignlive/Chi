import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../theme" as Theme

Item {
    id: root

    property bool open: false
    property string variant: "standard"      // "standard", "modal"
    property bool showDragHandle: true
    property real minHeight: 200
    property real maxHeight: parent ? parent.height * 0.9 : 600
    property bool expandable: true
    property bool dismissible: true

    default property alias content: contentContainer.data

    signal closed()
    signal expanded()
    signal collapsed()

    readonly property bool isExpanded: sheetHeight > (minHeight + maxHeight) / 2
    readonly property real sheetHeight: sheet.height

    anchors.fill: parent
    z: variant === "modal" ? 1000 : 0
    visible: open || closeAnimation.running

    property var colors: Theme.ChiTheme.colors

    // Scrim for modal
    Rectangle {
        id: scrim
        visible: variant === "modal"
        anchors.fill: parent
        color: colors.scrim
        opacity: open ? 0.32 : 0

        Behavior on opacity {
            NumberAnimation {
                id: closeAnimation
                duration: 250
                easing.type: Easing.OutCubic
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: open && variant === "modal" && dismissible
            onClicked: root.close()
        }
    }

    // Sheet
    Rectangle {
        id: sheet
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        height: open ? minHeight : 0
        color: colors.surfaceContainerLow

        radius: 28

        // Only round top corners
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: parent.radius
            color: parent.color
        }

        Behavior on height {
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
        }
        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: -4
            radius: 16
            samples: 17
            color: Qt.rgba(0, 0, 0, 0.15)
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // Drag handle
            Item {
                visible: showDragHandle
                Layout.fillWidth: true
                Layout.preferredHeight: 36

                Rectangle {
                    anchors.centerIn: parent
                    width: 32
                    height: 4
                    radius: 2
                    color: colors.onSurfaceVariant
                    opacity: 0.4

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    drag.target: dragProxy
                    drag.axis: Drag.YAxis
                    drag.minimumY: parent.parent.parent.height - maxHeight
                    drag.maximumY: parent.parent.parent.height - minHeight

                    cursorShape: Qt.SizeVerCursor

                    onReleased: {
                        if (dragProxy.y > parent.parent.parent.height - minHeight / 2) {
                            if (dismissible) {
                                root.close()
                            } else {
                                sheet.height = minHeight
                            }
                        } else if (isExpanded) {
                            sheet.height = maxHeight
                            expanded()
                        } else {
                            sheet.height = minHeight
                            collapsed()
                        }
                    }
                }
            }

            // Content
            Flickable {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                Layout.bottomMargin: 16
                contentHeight: contentContainer.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                ColumnLayout {
                    id: contentContainer
                    width: parent.width
                    spacing: 16
                }
            }
        }
    }

    // Drag proxy
    Item {
        id: dragProxy
        y: parent.height - sheet.height

        onYChanged: {
            if (dragArea.drag.active) {
                sheet.height = parent.height - y
            }
        }
    }

    // Swipe area
    MouseArea {
        id: dragArea
        anchors.fill: sheet
        drag.target: null
        preventStealing: true
    }

    Keys.onEscapePressed: if (open && dismissible) close()

    function show() {
        open = true
        sheet.height = minHeight
    }

    function close() {
        sheet.height = 0
        open = false
        closed()
    }

    function expand() {
        sheet.height = maxHeight
        expanded()
    }

    function collapse() {
        sheet.height = minHeight
        collapsed()
    }

    Accessible.role: Accessible.Dialog
    Accessible.name: "Bottom sheet"
}
