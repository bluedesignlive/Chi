import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Item {
    id: root

    property string text: "Chip"
    property string variant: "assist"        // "assist", "filter", "input", "suggestion"
    property string size: "medium"           // "small", "medium", "large"
    property string leadingIcon: ""
    property string trailingIcon: ""
    property bool selected: false
    property bool enabled: true
    property bool elevated: false
    property bool showAvatar: false
    property string avatarSource: ""

    signal clicked()
    signal trailingIconClicked()
    signal removed()

    readonly property bool hasLeadingIcon: leadingIcon !== "" || showAvatar
    readonly property bool hasTrailingIcon: trailingIcon !== "" || variant === "input"
    readonly property bool isSelectable: variant === "filter"
    readonly property bool isDismissible: variant === "input"

    readonly property var sizeSpecs: ({
        small: { height: 28, fontSize: 12, iconSize: 16, padding: 8, gap: 6, avatarSize: 20 },
        medium: { height: 32, fontSize: 14, iconSize: 18, padding: 12, gap: 8, avatarSize: 24 },
        large: { height: 40, fontSize: 16, iconSize: 20, padding: 16, gap: 10, avatarSize: 28 }
    })

    readonly property var currentSize: sizeSpecs[size] || sizeSpecs.medium

    implicitWidth: contentRow.implicitWidth + currentSize.padding * 2
    implicitHeight: currentSize.height

    opacity: enabled ? 1.0 : 0.38

    Behavior on opacity {
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
    }

    property var colors: Theme.ChiTheme.colors

    Rectangle {
        id: container
        anchors.fill: parent
        radius: height / 2

        color: {
            if (variant === "filter" && selected) {
                return colors.secondaryContainer
            }
            if (elevated) {
                return colors.surfaceContainerLow
            }
            return "transparent"
        }

        border.width: (elevated || (variant === "filter" && selected)) ? 0 : 1
        border.color: selected ? colors.secondary : colors.outline

        Behavior on color {
            ColorAnimation { duration: 150 }
        }
        Behavior on border.color {
            ColorAnimation { duration: 150 }
        }

        // State layer
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: {
                if (variant === "filter" && selected) return colors.onSecondaryContainer
                return colors.onSurface
            }
            opacity: {
                if (!enabled) return 0
                if (mouseArea.pressed) return 0.12
                if (mouseArea.containsMouse) return 0.08
                return 0
            }

            Behavior on opacity {
                NumberAnimation { duration: 100 }
            }
        }

        RowLayout {
            id: contentRow
            anchors.centerIn: parent
            spacing: currentSize.gap

            // Leading icon or avatar
            Item {
                visible: hasLeadingIcon
                width: showAvatar ? currentSize.avatarSize : currentSize.iconSize
                height: width
                Layout.alignment: Qt.AlignVCenter

                // Avatar
                Rectangle {
                    visible: showAvatar
                    anchors.fill: parent
                    radius: width / 2
                    color: colors.primaryContainer

                    Image {
                        visible: avatarSource !== ""
                        anchors.fill: parent
                        source: avatarSource
                        fillMode: Image.PreserveAspectCrop
                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: Rectangle {
                                width: parent.width
                                height: parent.height
                                radius: width / 2
                            }
                        }
                    }
                }

                // Icon
                Text {
                    visible: !showAvatar && leadingIcon !== ""
                    anchors.centerIn: parent
                    text: {
                        if (variant === "filter" && selected && leadingIcon === "") {
                            return "✓"
                        }
                        return leadingIcon
                    }
                    font.family: "Material Icons"
                    font.pixelSize: currentSize.iconSize
                    color: {
                        if (variant === "filter" && selected) return colors.onSecondaryContainer
                        return colors.primary
                    }

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }
            }

            // Check icon for filter chips (when no leading icon)
            Text {
                visible: variant === "filter" && selected && !hasLeadingIcon
                text: "✓"
                font.family: "Material Icons"
                font.pixelSize: currentSize.iconSize
                color: colors.onSecondaryContainer
                Layout.alignment: Qt.AlignVCenter

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            // Label
            Text {
                text: root.text
                font.family: "Roboto"
                font.pixelSize: currentSize.fontSize
                font.weight: Font.Medium
                color: {
                    if (variant === "filter" && selected) return colors.onSecondaryContainer
                    return colors.onSurface
                }
                Layout.alignment: Qt.AlignVCenter

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            // Trailing icon / remove button
            Item {
                visible: hasTrailingIcon
                width: currentSize.iconSize
                height: width
                Layout.alignment: Qt.AlignVCenter

                Text {
                    anchors.centerIn: parent
                    text: variant === "input" ? "✕" : trailingIcon
                    font.family: variant === "input" ? "Roboto" : "Material Icons"
                    font.pixelSize: currentSize.iconSize
                    color: colors.onSurfaceVariant

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -4
                    cursorShape: Qt.PointingHandCursor
                    enabled: root.enabled

                    onClicked: {
                        if (variant === "input") {
                            root.removed()
                        } else {
                            root.trailingIconClicked()
                        }
                    }
                }
            }
        }

        // Shadow for elevated
        layer.enabled: elevated && enabled
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 1
            radius: 3
            samples: 9
            color: Qt.rgba(0, 0, 0, 0.2)
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        onClicked: {
            if (variant === "filter") {
                selected = !selected
            }
            root.clicked()
        }
    }

    Accessible.role: Accessible.Button
    Accessible.name: text
    Accessible.checked: selected
    Accessible.checkable: variant === "filter"
}
