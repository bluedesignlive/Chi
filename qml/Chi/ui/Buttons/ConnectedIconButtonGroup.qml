// ConnectedIconButtonGroup.qml — Production Quality Icon Group
import QtQuick
import QtQuick.Effects
import "../../theme" as Theme
import "../common" as Common

Item {
    id: iconGroup
    property string size: "small"
    property string shape: "round"
    property string selectionMode: "single"
    property bool enabled: true
    property bool elevated: false
    property string iconFont: Theme.ChiTheme.iconFamily
    property var icons: []

    property int selectedIndex: -1
    property var selectedIndices: []

    signal selectionChanged(var indices)
    signal itemClicked(int index)

    readonly property var cs: Theme.SizeSpecs.getSpec(Theme.SizeSpecs.connectedButtonGroup, size)
    readonly property bool _isRound: shape === "round"
    readonly property var colors: Theme.ChiTheme.colors

    implicitWidth: container.implicitWidth
    implicitHeight: cs.height

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity { NumberAnimation { duration: 200 } }

    Rectangle {
        id: container
        anchors.fill: parent
        radius: iconGroup._isRound ? height / 2 : cs.squareRadius
        color: colors.surfaceContainerLow

        implicitWidth: iconRow.implicitWidth + cs.innerPadding * 2
        implicitHeight: cs.height

        layer.enabled: iconGroup.elevated && iconGroup.enabled
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Theme.ChiElevation.shadowColor(Theme.ChiElevation.level1)
            shadowOpacity: Theme.ChiElevation.shadowOpacity(Theme.ChiElevation.level1)
            shadowVerticalOffset: Theme.ChiElevation.verticalOffset(Theme.ChiElevation.level1)
            shadowBlur: Theme.ChiElevation.blurRadius(Theme.ChiElevation.level1)
        }

        Row {
            id: iconRow
            anchors.centerIn: parent
            spacing: 6 

            Repeater {
                model: iconGroup.icons

                Item {
                    id: delegateItem
                    property bool isSelected: iconGroup.selectedIndices.indexOf(index) !== -1
                    
                    // Strict theme binding
                    readonly property color _contentColor: isSelected ? colors.onSecondaryContainer : colors.onSurfaceVariant

                    width: Math.max(cs.minWidth, cs.width)
                    height: cs.height - cs.innerPadding * 2

                    scale: iconMouse.pressed ? 0.90 : 1.0
                    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack; easing.overshoot: 2.0 } }

                    Rectangle {
                        id: bgRect
                        anchors.fill: parent
                        radius: iconGroup._isRound ? height / 2 : cs.innerRadius
                        color: delegateItem.isSelected ? colors.secondaryContainer : "transparent"
                        Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.InOutQuad } }

                        Common.Ripple { color: delegateItem._contentColor; radius: bgRect.radius; enabled: iconGroup.enabled }
                        Common.StateLayer { layerColor: delegateItem._contentColor; containerRadius: bgRect.radius; pressed: iconMouse.pressed; hovered: iconMouse.containsMouse; enabled: iconGroup.enabled }

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            font.family: iconGroup.iconFont
                            font.pixelSize: cs.iconSize
                            color: delegateItem._contentColor
                            
                            scale: delegateItem.isSelected ? 1.15 : 1.0
                            Behavior on scale { NumberAnimation { duration: 250; easing.type: Easing.OutBack } }
                            Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.InOutQuad } }
                        }
                    }

                    MouseArea {
                        id: iconMouse
                        anchors.fill: parent
                        enabled: iconGroup.enabled
                        hoverEnabled: true
                        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: iconGroup.handleClick(index)
                    }
                }
            }
        }
    }

    function handleClick(index) {
        itemClicked(index);
        var newIndices = selectedIndices.slice();
        if (selectionMode === "single") {
            newIndices = [index];
        } else if (selectionMode === "multi") {
            var idx = newIndices.indexOf(index);
            if (idx !== -1) newIndices.splice(idx, 1);
            else { newIndices.push(index); newIndices.sort(); }
        } else if (selectionMode === "required") {
            var idx2 = newIndices.indexOf(index);
            if (idx2 !== -1 && newIndices.length > 1) newIndices.splice(idx2, 1);
            else if (idx2 === -1) newIndices = [index];
        }
        selectedIndices = newIndices;
        selectedIndex = newIndices.length > 0 ? newIndices[0] : -1;
        selectionChanged(selectedIndices);
    }

    Component.onCompleted: {
        if (selectionMode === "required" && selectedIndices.length === 0 && icons.length > 0) {
            selectedIndex = 0;
            selectedIndices = [0];
        }
    }
}
