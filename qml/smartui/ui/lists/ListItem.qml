import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Item {
    id: root

    property string text: ""
    property string secondaryText: ""
    property string tertiaryText: ""
    property string leadingIcon: ""
    property string trailingIcon: ""
    property string trailingText: ""
    property bool showAvatar: false
    property string avatarSource: ""
    property string avatarText: ""
    property bool showCheckbox: false
    property bool checked: false
    property bool showSwitch: false
    property bool switchChecked: false
    property bool showRadio: false
    property bool radioChecked: false
    property bool enabled: true
    property bool selected: false
    property string size: "medium"

    signal clicked()
    signal checkboxToggled(bool checked)
    signal switchToggled(bool checked)
    signal radioToggled()
    signal trailingClicked()

    readonly property bool hasSecondaryText: secondaryText !== ""
    readonly property bool hasTertiaryText: tertiaryText !== ""
    readonly property bool hasLeading: leadingIcon !== "" || showAvatar || showCheckbox || showRadio
    readonly property bool hasTrailing: trailingIcon !== "" || trailingText !== "" || showSwitch

    readonly property var sizeSpecs: ({
        small: { height: 48, avatarSize: 32, iconSize: 20, fontSize: 14, secondarySize: 12 },
        medium: { height: hasSecondaryText ? 72 : 56, avatarSize: 40, iconSize: 24, fontSize: 16, secondarySize: 14 },
        large: { height: hasTertiaryText ? 88 : 72, avatarSize: 48, iconSize: 24, fontSize: 16, secondarySize: 14 }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.medium

    implicitWidth: parent ? parent.width : 360
    implicitHeight: currentSize.height

    opacity: enabled ? 1.0 : 0.38

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        anchors.fill: parent
        color: selected ? colors.secondaryContainer : "transparent"
        Behavior on color { ColorAnimation { duration: 150 } }

        Rectangle {
            anchors.fill: parent
            color: colors.onSurface
            opacity: {
                if (!enabled) return 0
                if (mouseArea.pressed) return 0.12
                if (mouseArea.containsMouse) return 0.08
                return 0
            }
            Behavior on opacity { NumberAnimation { duration: 100 } }
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 16

            // Leading content
            Item {
                visible: hasLeading
                Layout.preferredWidth: showAvatar ? currentSize.avatarSize : currentSize.iconSize
                Layout.preferredHeight: Layout.preferredWidth
                Layout.alignment: Qt.AlignVCenter

                // Checkbox
                Rectangle {
                    visible: showCheckbox
                    anchors.centerIn: parent
                    width: 20
                    height: 20
                    radius: 2
                    color: checked ? colors.primary : "transparent"
                    border.width: checked ? 0 : 2
                    border.color: colors.onSurfaceVariant

                    Text {
                        visible: checked
                        anchors.centerIn: parent
                        text: "✓"
                        font.pixelSize: 16
                        font.weight: Font.Bold
                        color: colors.onPrimary
                    }

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -8
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            checked = !checked
                            checkboxToggled(checked)
                        }
                    }
                }

                // Radio
                Rectangle {
                    visible: showRadio
                    anchors.centerIn: parent
                    width: 20
                    height: 20
                    radius: 10
                    color: "transparent"
                    border.width: 2
                    border.color: radioChecked ? colors.primary : colors.onSurfaceVariant

                    Rectangle {
                        anchors.centerIn: parent
                        width: radioChecked ? 10 : 0
                        height: width
                        radius: width / 2
                        color: colors.primary
                        Behavior on width { NumberAnimation { duration: 150 } }
                    }

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -8
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            radioChecked = true
                            radioToggled()
                        }
                    }
                }

                // Avatar
                Rectangle {
                    visible: showAvatar
                    anchors.fill: parent
                    radius: width / 2
                    color: colors.primaryContainer

                    Text {
                        visible: avatarSource === ""
                        anchors.centerIn: parent
                        text: avatarText || (text.length > 0 ? text[0].toUpperCase() : "")
                        font.family: "Roboto"
                        font.pixelSize: currentSize.avatarSize * 0.4
                        font.weight: Font.Medium
                        color: colors.onPrimaryContainer
                    }

                    Image {
                        visible: avatarSource !== ""
                        anchors.fill: parent
                        source: avatarSource
                        fillMode: Image.PreserveAspectCrop
                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: Rectangle {
                                width: currentSize.avatarSize
                                height: currentSize.avatarSize
                                radius: currentSize.avatarSize / 2
                            }
                        }
                    }
                }

                // Icon
                Text {
                    visible: !showCheckbox && !showRadio && !showAvatar && leadingIcon !== ""
                    anchors.centerIn: parent
                    text: leadingIcon
                    font.family: "Material Icons"
                    font.pixelSize: currentSize.iconSize
                    color: colors.onSurfaceVariant
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
            }

            // Text content
            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: 2

                Text {
                    text: root.text
                    font.family: "Roboto"
                    font.pixelSize: currentSize.fontSize
                    color: colors.onSurface
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                Text {
                    visible: hasSecondaryText
                    text: secondaryText
                    font.family: "Roboto"
                    font.pixelSize: currentSize.secondarySize
                    color: colors.onSurfaceVariant
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                Text {
                    visible: hasTertiaryText
                    text: tertiaryText
                    font.family: "Roboto"
                    font.pixelSize: currentSize.secondarySize
                    color: colors.onSurfaceVariant
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
            }

            // Trailing content
            Item {
                visible: hasTrailing
                Layout.preferredWidth: showSwitch ? 52 : (trailingText !== "" ? trailingLabel.implicitWidth : currentSize.iconSize)
                Layout.preferredHeight: showSwitch ? 32 : currentSize.iconSize
                Layout.alignment: Qt.AlignVCenter

                // Switch
                Item {
                    visible: showSwitch
                    anchors.fill: parent

                    Rectangle {
                        id: switchTrack
                        anchors.centerIn: parent
                        width: 52
                        height: 32
                        radius: 16
                        color: switchChecked ? colors.primary : colors.surfaceContainerHighest
                        border.width: switchChecked ? 0 : 2
                        border.color: colors.outline

                        Rectangle {
                            id: switchThumb
                            anchors.verticalCenter: parent.verticalCenter
                            x: switchChecked ? parent.width - width - 4 : 4
                            width: switchChecked ? 24 : 16
                            height: width
                            radius: width / 2
                            color: switchChecked ? colors.onPrimary : colors.outline
                            Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                            Behavior on width { NumberAnimation { duration: 150 } }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            switchChecked = !switchChecked
                            switchToggled(switchChecked)
                        }
                    }
                }

                // Trailing text
                Text {
                    id: trailingLabel
                    visible: !showSwitch && trailingText !== ""
                    anchors.centerIn: parent
                    text: trailingText
                    font.family: "Roboto"
                    font.pixelSize: currentSize.secondarySize
                    color: colors.onSurfaceVariant
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                // Trailing icon
                Text {
                    visible: !showSwitch && trailingText === "" && trailingIcon !== ""
                    anchors.centerIn: parent
                    text: trailingIcon
                    font.family: "Material Icons"
                    font.pixelSize: currentSize.iconSize
                    color: colors.onSurfaceVariant
                    Behavior on color { ColorAnimation { duration: 150 } }

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -8
                        cursorShape: Qt.PointingHandCursor
                        onClicked: trailingClicked()
                    }
                }
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            enabled: root.enabled
            hoverEnabled: true
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: root.clicked()
        }
    }

    Accessible.role: Accessible.ListItem
    Accessible.name: text
    Accessible.description: secondaryText
}
