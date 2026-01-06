// smartui/ui/Buttons/ConnectedIconButtonGroup.qml - Icon-only Connected Button Group
import QtQuick
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Item {
    id: iconGroup

    property string size: "small"
    property string shape: "round"
    property string selectionMode: "single"
    property bool enabled: true
    property bool elevated: false
    property string iconFont: "Material Icons"
    property var icons: []

    property int selectedIndex: -1
    property var selectedIndices: []

    signal selectionChanged(var indices)
    signal itemClicked(int index)

    readonly property var sizeSpecs: ({
        xsmall: { height: 32, width: 32, innerPadding: 2, innerRadius: 4, outerRadius: 16, squareRadius: 4, iconSize: 18, minWidth: 48 },
        small: { height: 40, width: 40, innerPadding: 2, innerRadius: 8, outerRadius: 20, squareRadius: 8, iconSize: 20, minWidth: 48 },
        medium: { height: 56, width: 56, innerPadding: 2, innerRadius: 8, outerRadius: 28, squareRadius: 8, iconSize: 24, minWidth: 56 },
        large: { height: 96, width: 96, innerPadding: 2, innerRadius: 16, outerRadius: 48, squareRadius: 16, iconSize: 32, minWidth: 96 },
        xlarge: { height: 136, width: 136, innerPadding: 2, innerRadius: 20, outerRadius: 68, squareRadius: 20, iconSize: 40, minWidth: 136 }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.small
    property var colors: Theme.ChiTheme.colors

    implicitWidth: container.implicitWidth
    implicitHeight: currentSize.height

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity { NumberAnimation { duration: 200 } }

    Rectangle {
        id: container
        anchors.fill: parent
        radius: shape === "round" ? currentSize.outerRadius : currentSize.squareRadius
        color: colors.surfaceContainerLow
        clip: true

        implicitWidth: iconRow.implicitWidth + currentSize.innerPadding * 2
        implicitHeight: currentSize.height

        layer.enabled: elevated && iconGroup.enabled
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 1
            radius: 4
            samples: 9
            color: Qt.rgba(0, 0, 0, 0.25)
        }

        Row {
            id: iconRow
            anchors.centerIn: parent
            spacing: currentSize.innerPadding

            Repeater {
                model: iconGroup.icons

                Rectangle {
                    id: iconSegment

                    property int itemIndex: index
                    property bool isFirst: index === 0
                    property bool isLast: index === iconGroup.icons.length - 1
                    property bool isSelected: iconGroup.selectedIndices.indexOf(index) !== -1
                    property bool isPressed: iconMouse.pressed
                    property bool isHovered: iconMouse.containsMouse

                    width: Math.max(currentSize.minWidth, currentSize.width)
                    height: currentSize.height - currentSize.innerPadding * 2

                    property real baseLeft: isFirst ? (shape === "round" ? currentSize.outerRadius - currentSize.innerPadding : currentSize.squareRadius) : currentSize.innerRadius
                    property real baseRight: isLast ? (shape === "round" ? currentSize.outerRadius - currentSize.innerPadding : currentSize.squareRadius) : currentSize.innerRadius

                    topLeftRadius: (isSelected || isPressed) ? currentSize.innerRadius : baseLeft
                    bottomLeftRadius: (isSelected || isPressed) ? currentSize.innerRadius : baseLeft
                    topRightRadius: (isSelected || isPressed) ? currentSize.innerRadius : baseRight
                    bottomRightRadius: (isSelected || isPressed) ? currentSize.innerRadius : baseRight

                    Behavior on topLeftRadius { NumberAnimation { duration: Theme.ChiTheme.motion.durationMedium; easing.type: Easing.OutCubic } }
                    Behavior on bottomLeftRadius { NumberAnimation { duration: Theme.ChiTheme.motion.durationMedium; easing.type: Easing.OutCubic } }
                    Behavior on topRightRadius { NumberAnimation { duration: Theme.ChiTheme.motion.durationMedium; easing.type: Easing.OutCubic } }
                    Behavior on bottomRightRadius { NumberAnimation { duration: Theme.ChiTheme.motion.durationMedium; easing.type: Easing.OutCubic } }

                    color: isSelected ? colors.secondaryContainer : colors.surfaceContainerLow
                    Behavior on color { ColorAnimation { duration: Theme.ChiTheme.motion.durationMedium } }
                    clip: true

                    Rectangle {
                        anchors.fill: parent
                        topLeftRadius: parent.topLeftRadius
                        bottomLeftRadius: parent.bottomLeftRadius
                        topRightRadius: parent.topRightRadius
                        bottomRightRadius: parent.bottomRightRadius
                        color: isSelected ? colors.onSecondaryContainer : colors.onSurfaceVariant
                        opacity: 0

                        SequentialAnimation on opacity {
                            id: iconRipple
                            running: false
                            NumberAnimation { from: 0; to: 0.16; duration: 90 }
                            NumberAnimation { to: 0; duration: 210 }
                        }
                    }

                    Rectangle {
                        anchors.fill: parent
                        topLeftRadius: parent.topLeftRadius
                        bottomLeftRadius: parent.bottomLeftRadius
                        topRightRadius: parent.topRightRadius
                        bottomRightRadius: parent.bottomRightRadius
                        color: isSelected ? colors.onSecondaryContainer : colors.onSurfaceVariant
                        opacity: isPressed ? 0.12 : (isHovered ? 0.08 : 0)
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        font.family: iconGroup.iconFont
                        font.pixelSize: currentSize.iconSize
                        color: isSelected ? colors.onSecondaryContainer : colors.onSurfaceVariant
                        Behavior on color { ColorAnimation { duration: Theme.ChiTheme.motion.durationMedium } }
                    }

                    MouseArea {
                        id: iconMouse
                        anchors.fill: parent
                        enabled: iconGroup.enabled
                        hoverEnabled: true
                        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onPressed: iconRipple.restart()
                        onClicked: iconGroup.handleClick(index)
                    }
                }
            }
        }
    }

    function handleClick(index) {
        itemClicked(index)
        var newIndices = selectedIndices.slice()

        if (selectionMode === "single") {
            newIndices = [index]
            selectedIndex = index
        } else if (selectionMode === "multi") {
            var idx = newIndices.indexOf(index)
            if (idx !== -1) newIndices.splice(idx, 1)
            else { newIndices.push(index); newIndices.sort() }
        } else if (selectionMode === "required") {
            var idx2 = newIndices.indexOf(index)
            if (idx2 !== -1 && newIndices.length > 1) newIndices.splice(idx2, 1)
            else if (idx2 === -1) newIndices = [index]
            selectedIndex = newIndices[0] !== undefined ? newIndices[0] : -1
        }

        selectedIndices = newIndices
        selectionChanged(selectedIndices)
    }

    Component.onCompleted: {
        if (selectionMode === "required" && selectedIndices.length === 0 && icons.length > 0) {
            selectedIndex = 0
            selectedIndices = [0]
        }
    }
}
