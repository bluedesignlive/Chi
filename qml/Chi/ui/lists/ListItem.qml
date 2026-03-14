import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
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
        small:  { height: 48, avatarSize: 32, iconSize: 20, fontSize: 14, secondarySize: 12 },
        medium: { height: hasSecondaryText ? 72 : 56, avatarSize: 40, iconSize: 24, fontSize: 16, secondarySize: 14 },
        large:  { height: hasTertiaryText ? 88 : 72, avatarSize: 48, iconSize: 24, fontSize: 16, secondarySize: 14 }
    })

    readonly property var cs: sizeSpecs[size] || sizeSpecs.medium
    readonly property bool _hasAvSrc: avatarSource !== ""

    implicitWidth: parent ? parent.width : 360
    implicitHeight: cs.height

    opacity: enabled ? 1.0 : 0.38

    property var colors: Theme.ChiTheme.colors
    readonly property var _typo: Theme.ChiTheme.typography

    Rectangle {
        anchors.fill: parent
        color: root.selected ? colors.secondaryContainer : "transparent"
        Behavior on color { ColorAnimation { duration: 150 } }

        // State layer
        Rectangle {
            anchors.fill: parent
            color: colors.onSurface
            opacity: !root.enabled ? 0 :
                     (mouseArea.pressed ? 0.12 : (mouseArea.containsMouse ? 0.08 : 0))
            Behavior on opacity { NumberAnimation { duration: 100 } }
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 16

            // ─── Leading content ───
            Item {
                visible: root.hasLeading
                Layout.preferredWidth: root.showAvatar ? cs.avatarSize : cs.iconSize
                Layout.preferredHeight: Layout.preferredWidth
                Layout.alignment: Qt.AlignVCenter

                // Checkbox
                Rectangle {
                    visible: root.showCheckbox
                    anchors.centerIn: parent
                    width: 20; height: 20; radius: 2
                    color: root.checked ? colors.primary : "transparent"
                    border.width: root.checked ? 0 : 2
                    border.color: colors.onSurfaceVariant

                    Text {
                        visible: root.checked
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
                        onClicked: { root.checked = !root.checked; root.checkboxToggled(root.checked) }
                    }
                }

                // Radio
                Rectangle {
                    visible: root.showRadio
                    anchors.centerIn: parent
                    width: 20; height: 20; radius: 10
                    color: "transparent"
                    border.width: 2
                    border.color: root.radioChecked ? colors.primary : colors.onSurfaceVariant

                    Rectangle {
                        anchors.centerIn: parent
                        width: root.radioChecked ? 10 : 0
                        height: width
                        radius: width * 0.5
                        color: colors.primary
                        Behavior on width { NumberAnimation { duration: 150 } }
                    }

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -8
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { root.radioChecked = true; root.radioToggled() }
                    }
                }

                // Avatar
                Rectangle {
                    visible: root.showAvatar
                    anchors.fill: parent
                    radius: width * 0.5
                    color: colors.primaryContainer

                    Text {
                        visible: !root._hasAvSrc
                        anchors.centerIn: parent
                        text: root.avatarText || (root.text.length > 0 ? root.text[0].toUpperCase() : "")
                        font.family: Theme.ChiTheme.fontFamily
                        font.pixelSize: cs.avatarSize * 0.4
                        font.weight: Font.Medium
                        color: colors.onPrimaryContainer
                    }

                    Image {
                        visible: root._hasAvSrc
                        anchors.fill: parent
                        source: root._hasAvSrc ? root.avatarSource : ""
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true

                        layer.enabled: visible && status === Image.Ready
                        layer.effect: MultiEffect {
                            maskEnabled: true
                            maskSource: Rectangle {
                                width: cs.avatarSize
                                height: cs.avatarSize
                                radius: cs.avatarSize * 0.5
                                visible: false
                            }
                        }
                    }
                }

                // Icon
                Text {
                    visible: !root.showCheckbox && !root.showRadio && !root.showAvatar && root.leadingIcon !== ""
                    anchors.centerIn: parent
                    text: root.leadingIcon
                    font.family: Theme.ChiTheme.iconFamily
                    font.pixelSize: cs.iconSize
                    color: colors.onSurfaceVariant
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
            }

            // ─── Text content ───
            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: 2

                Text {
                    text: root.text
                    font.family: Theme.ChiTheme.fontFamily
                    font.pixelSize: cs.fontSize
                    color: colors.onSurface
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                Text {
                    visible: root.hasSecondaryText
                    text: root.secondaryText
                    font.family: Theme.ChiTheme.fontFamily
                    font.pixelSize: cs.secondarySize
                    color: colors.onSurfaceVariant
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                Text {
                    visible: root.hasTertiaryText
                    text: root.tertiaryText
                    font.family: Theme.ChiTheme.fontFamily
                    font.pixelSize: cs.secondarySize
                    color: colors.onSurfaceVariant
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
            }

            // ─── Trailing content ───
            Item {
                visible: root.hasTrailing
                Layout.preferredWidth: root.showSwitch ? 52 :
                    (root.trailingText !== "" ? trailingLabel.implicitWidth : cs.iconSize)
                Layout.preferredHeight: root.showSwitch ? 32 : cs.iconSize
                Layout.alignment: Qt.AlignVCenter

                // Switch
                Item {
                    visible: root.showSwitch
                    anchors.fill: parent

                    Rectangle {
                        anchors.centerIn: parent
                        width: 52; height: 32; radius: 16
                        color: root.switchChecked ? colors.primary : colors.surfaceContainerHighest
                        border.width: root.switchChecked ? 0 : 2
                        border.color: colors.outline

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            x: root.switchChecked ? parent.width - width - 4 : 4
                            width: root.switchChecked ? 24 : 16
                            height: width
                            radius: width * 0.5
                            color: root.switchChecked ? colors.onPrimary : colors.outline
                            Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                            Behavior on width { NumberAnimation { duration: 150 } }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { root.switchChecked = !root.switchChecked; root.switchToggled(root.switchChecked) }
                    }
                }

                // Trailing text
                Text {
                    id: trailingLabel
                    visible: !root.showSwitch && root.trailingText !== ""
                    anchors.centerIn: parent
                    text: root.trailingText
                    font.family: Theme.ChiTheme.fontFamily
                    font.pixelSize: cs.secondarySize
                    color: colors.onSurfaceVariant
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                // Trailing icon
                Text {
                    visible: !root.showSwitch && root.trailingText === "" && root.trailingIcon !== ""
                    anchors.centerIn: parent
                    text: root.trailingIcon
                    font.family: Theme.ChiTheme.iconFamily
                    font.pixelSize: cs.iconSize
                    color: colors.onSurfaceVariant
                    Behavior on color { ColorAnimation { duration: 150 } }

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -8
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.trailingClicked()
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
