import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../../theme" as Theme

Item {
    id: root

    property bool open: false
    property string variant: "standard"
    property bool showDragHandle: true
    property real minHeight: 200
    property real maxHeight: parent ? parent.height * 0.9 : 600
    property bool expandable: true
    property bool dismissible: true

    default property alias content: contentContainer.data

    signal closed()
    signal expanded()
    signal collapsed()

    readonly property bool _modal: variant === "modal"
    readonly property bool isExpanded: sheet.height > (minHeight + maxHeight) * 0.5
    readonly property real sheetHeight: sheet.height

    anchors.fill: parent
    z: _modal ? 1000 : 0
    visible: open || closeAnimation.running

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        id: scrim
        visible: root._modal
        anchors.fill: parent
        color: colors.scrim
        opacity: root.open ? 0.32 : 0

        Behavior on opacity {
            NumberAnimation {
                id: closeAnimation
                duration: 250
                easing.type: Easing.OutCubic
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: root.open && root._modal && root.dismissible
            onClicked: root.close()
        }
    }

    Rectangle {
        id: sheet
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: root.open ? root.minHeight : 0
        color: colors.surfaceContainerLow
        radius: 28

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
        Behavior on color { ColorAnimation { duration: 200 } }

        layer.enabled: root.open
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.15)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: -4
            shadowBlur: 0.6
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Item {
                visible: root.showDragHandle
                Layout.fillWidth: true
                Layout.preferredHeight: 36

                Rectangle {
                    anchors.centerIn: parent
                    width: 32; height: 4; radius: 2
                    color: colors.onSurfaceVariant
                    opacity: 0.4
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                MouseArea {
                    anchors.fill: parent
                    drag.target: dragProxy
                    drag.axis: Drag.YAxis
                    drag.minimumY: root.height - root.maxHeight
                    drag.maximumY: root.height - root.minHeight
                    cursorShape: Qt.SizeVerCursor

                    onReleased: {
                        var threshold = root.height - root.minHeight * 0.5
                        if (dragProxy.y > threshold) {
                            if (root.dismissible) root.close()
                            else sheet.height = root.minHeight
                        } else if (root.isExpanded) {
                            sheet.height = root.maxHeight
                            root.expanded()
                        } else {
                            sheet.height = root.minHeight
                            root.collapsed()
                        }
                    }
                }
            }

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

    Item {
        id: dragProxy
        y: root.height - sheet.height
        onYChanged: if (dragArea.drag.active) sheet.height = root.height - y
    }

    MouseArea {
        id: dragArea
        anchors.fill: sheet
        drag.target: null
        preventStealing: true
    }

    Keys.onEscapePressed: if (open && dismissible) close()

    function show() { open = true; sheet.height = minHeight }
    function close() { sheet.height = 0; open = false; closed() }
    function expand() { sheet.height = maxHeight; expanded() }
    function collapse() { sheet.height = minHeight; collapsed() }

    Accessible.role: Accessible.Dialog
    Accessible.name: "Bottom sheet"
}
