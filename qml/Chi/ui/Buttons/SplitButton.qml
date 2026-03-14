// SplitButton — Leading action + trailing toggle split button
import QtQuick
import QtQuick.Effects
import "../../theme" as Theme

Item {
    id: splitButton

    property string text: "Action"
    property string leadingIcon: ""
    property bool showLeadingIcon: false
    property string trailingIcon: "⌄"

    property string variant: "filled"
    property string size: "small"
    property bool enabled: true
    property bool trailingSelected: false

    signal leadingClicked()
    signal trailingClicked()

    opacity: enabled ? 1.0 : 0.38
    Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

    readonly property var sizeSpecs: ({
        xsmall: { height: 32, padding: 6,  horizontalPadding: 12, gap: 4,  iconSize: 20, fontSize: 14, fontWeight: Font.Medium, letterSpacing: 0.1,  fullRadius: 16, smallRadius: 4,  buttonGap: 2, trailingIconSize: 16 },
        small:  { height: 40, padding: 10, horizontalPadding: 16, gap: 8,  iconSize: 20, fontSize: 14, fontWeight: Font.Medium, letterSpacing: 0.1,  fullRadius: 20, smallRadius: 4,  buttonGap: 2, trailingIconSize: 18 },
        medium: { height: 56, padding: 16, horizontalPadding: 24, gap: 8,  iconSize: 24, fontSize: 16, fontWeight: Font.Medium, letterSpacing: 0.15, fullRadius: 28, smallRadius: 4,  buttonGap: 2, trailingIconSize: 20 },
        large:  { height: 96, padding: 32, horizontalPadding: 48, gap: 12, iconSize: 32, fontSize: 24, fontWeight: Font.Normal, letterSpacing: 0,    fullRadius: 48, smallRadius: 8,  buttonGap: 2, trailingIconSize: 28 },
        xlarge: { height: 136, padding: 48, horizontalPadding: 64, gap: 16, iconSize: 40, fontSize: 32, fontWeight: Font.Normal, letterSpacing: 0,   fullRadius: 68, smallRadius: 12, buttonGap: 2, trailingIconSize: 36 }
    })

    readonly property var cs: sizeSpecs[size] || sizeSpecs.small

    // Cached variant flags
    readonly property bool _filled: variant === "filled"
    readonly property bool _elevated: variant === "elevated"
    readonly property bool _tonal: variant === "tonal"
    readonly property bool _outlined: variant === "outlined"

    readonly property bool isIconImage: {
        var s = leadingIcon
        return s.indexOf(".svg") !== -1 || s.indexOf(".png") !== -1 ||
               s.indexOf(".jpg") !== -1 || s.indexOf("qrc:/") === 0
    }

    // Cached colors — shared by both leading and trailing halves
    readonly property color _interactColor: _filled ? colors.onPrimary :
                                            _tonal ? colors.onSecondaryContainer : colors.primary
    readonly property color _labelColor: enabled ? _interactColor : colors.onSurface
    readonly property color _containerColor: {
        if (!enabled && (_filled || _elevated)) return "transparent"
        if (_filled) return colors.primary
        if (_elevated) return colors.surfaceContainerLow
        if (_tonal) return colors.secondaryContainer
        return "transparent"
    }

    implicitWidth: leadingButtonContainer.implicitWidth + cs.buttonGap + trailingButtonContainer.width
    implicitHeight: cs.height

    property var colors: Theme.ChiTheme.colors

    Row {
        spacing: cs.buttonGap

        // ─── LEADING BUTTON ───
        Rectangle {
            id: leadingButtonContainer
            implicitWidth: leadingContent.implicitWidth
            height: cs.height
            clip: true

            topLeftRadius: cs.fullRadius
            bottomLeftRadius: cs.fullRadius
            topRightRadius: cs.smallRadius
            bottomRightRadius: cs.smallRadius

            color: splitButton._containerColor
            border.width: splitButton._outlined ? 1 : 0
            border.color: splitButton._outlined ? colors.outline : "transparent"

            // Disabled overlay
            Rectangle {
                anchors.fill: parent
                topLeftRadius: parent.topLeftRadius
                topRightRadius: parent.topRightRadius
                bottomLeftRadius: parent.bottomLeftRadius
                bottomRightRadius: parent.bottomRightRadius
                visible: !splitButton.enabled && (splitButton._filled || splitButton._elevated)
                color: colors.onSurface
                opacity: 0.12
            }

            // Ripple
            Rectangle {
                anchors.fill: parent
                topLeftRadius: parent.topLeftRadius
                topRightRadius: parent.topRightRadius
                bottomLeftRadius: parent.bottomLeftRadius
                bottomRightRadius: parent.bottomRightRadius
                color: splitButton._interactColor
                opacity: 0

                SequentialAnimation on opacity {
                    id: leadingRippleAnimation
                    running: false
                    NumberAnimation { from: 0; to: 0.16; duration: 90; easing.type: Easing.OutCubic }
                    NumberAnimation { to: 0; duration: 210; easing.type: Easing.OutCubic }
                }
            }

            // State layer
            Rectangle {
                anchors.fill: parent
                topLeftRadius: parent.topLeftRadius
                topRightRadius: parent.topRightRadius
                bottomLeftRadius: parent.bottomLeftRadius
                bottomRightRadius: parent.bottomRightRadius
                color: splitButton._interactColor

                opacity: !splitButton.enabled ? 0 :
                         (leadingMouseArea.pressed ? 0.12 :
                         (splitButton.activeFocus ? 0.12 :
                         (leadingMouseArea.containsMouse ? 0.08 : 0)))

                Behavior on opacity {
                    NumberAnimation { duration: leadingMouseArea.pressed ? 50 : 150; easing.type: Easing.OutCubic }
                }
            }

            Row {
                id: leadingContent
                anchors.centerIn: parent
                spacing: cs.gap
                padding: cs.padding
                leftPadding: cs.horizontalPadding
                rightPadding: cs.horizontalPadding

                // Leading icon (text/ligature)
                Text {
                    visible: splitButton.showLeadingIcon && splitButton.leadingIcon !== "" && !splitButton.isIconImage
                    text: splitButton.leadingIcon
                    font.family: Theme.ChiTheme.iconFamily
                    font.pixelSize: cs.iconSize
                    color: splitButton._labelColor
                    anchors.verticalCenter: parent.verticalCenter
                }

                // Leading icon (image)
                Image {
                    visible: splitButton.showLeadingIcon && splitButton.leadingIcon !== "" && splitButton.isIconImage
                    width: cs.iconSize; height: cs.iconSize
                    source: splitButton.leadingIcon
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    anchors.verticalCenter: parent.verticalCenter
                }

                // Label
                Text {
                    text: splitButton.text
                    font.family: Theme.ChiTheme.fontFamily
                    font.weight: cs.fontWeight
                    font.pixelSize: cs.fontSize
                    font.letterSpacing: cs.letterSpacing
                    // Better vertical centering
                    verticalAlignment: Text.AlignVCenter
                    color: splitButton._labelColor
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                id: leadingMouseArea
                anchors.fill: parent
                enabled: splitButton.enabled
                hoverEnabled: true
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onPressed: leadingRippleAnimation.restart()
                onClicked: splitButton.leadingClicked()
            }
        }

        // ─── TRAILING BUTTON ───
        Rectangle {
            id: trailingButtonContainer
            width: cs.height
            height: cs.height
            clip: true

            // Left corners morph on selected/pressed; right corners always full
            topLeftRadius: splitButton.trailingSelected ? cs.fullRadius :
                          (trailingMouseArea.pressed ? cs.smallRadius * 3 : cs.smallRadius)
            bottomLeftRadius: splitButton.trailingSelected ? cs.fullRadius :
                             (trailingMouseArea.pressed ? cs.smallRadius * 3 : cs.smallRadius)
            topRightRadius: cs.fullRadius
            bottomRightRadius: cs.fullRadius

            Behavior on topLeftRadius { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
            Behavior on bottomLeftRadius { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

            color: splitButton._containerColor
            border.width: splitButton._outlined ? 1 : 0
            border.color: splitButton._outlined ? colors.outline : "transparent"

            // Ripple
            Rectangle {
                anchors.fill: parent
                topLeftRadius: parent.topLeftRadius
                topRightRadius: parent.topRightRadius
                bottomLeftRadius: parent.bottomLeftRadius
                bottomRightRadius: parent.bottomRightRadius
                color: splitButton._interactColor
                opacity: 0

                SequentialAnimation on opacity {
                    id: trailingRippleAnimation
                    running: false
                    NumberAnimation { from: 0; to: 0.16; duration: 90; easing.type: Easing.OutCubic }
                    NumberAnimation { to: 0; duration: 210; easing.type: Easing.OutCubic }
                }
            }

            // State layer
            Rectangle {
                anchors.fill: parent
                topLeftRadius: parent.topLeftRadius
                topRightRadius: parent.topRightRadius
                bottomLeftRadius: parent.bottomLeftRadius
                bottomRightRadius: parent.bottomRightRadius
                color: splitButton._interactColor

                opacity: !splitButton.enabled ? 0 :
                         (splitButton.trailingSelected ? 0.12 :
                         (trailingMouseArea.pressed ? 0.12 :
                         (trailingMouseArea.containsMouse ? 0.08 : 0)))

                Behavior on opacity {
                    NumberAnimation { duration: trailingMouseArea.pressed ? 50 : 150; easing.type: Easing.OutCubic }
                }
            }

            // Trailing icon
            Text {
                anchors.centerIn: parent
                text: splitButton.trailingIcon
                font.family: Theme.ChiTheme.fontFamily
                font.pixelSize: cs.trailingIconSize
                font.weight: Font.Bold
                color: splitButton._labelColor
                rotation: splitButton.trailingSelected ? 180 : 0
                Behavior on rotation { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
            }

            // Focus indicator
            Rectangle {
                visible: splitButton.trailingSelected && splitButton.activeFocus
                anchors.fill: parent
                anchors.margins: 2
                radius: parent.radius
                color: "transparent"
                border.width: 3
                border.color: colors.secondary
            }

            MouseArea {
                id: trailingMouseArea
                anchors.fill: parent
                enabled: splitButton.enabled
                hoverEnabled: true
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onPressed: trailingRippleAnimation.restart()
                onClicked: {
                    splitButton.trailingSelected = !splitButton.trailingSelected
                    splitButton.trailingClicked()
                }
            }
        }
    }

    // Elevation for elevated variant
    layer.enabled: _elevated && enabled
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: Qt.rgba(0, 0, 0, 0.3)
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 1
        shadowBlur: 0.2
    }
}
