// qml/smartui/ui/search/SearchSuggestionItem.qml
// M3 search suggestion row — icon, text, optional trailing action
import QtQuick
import QtQuick.Layouts
import "../theme" as Theme
import "../common" as Common

Item {
    id: root

    // ═══════════════════════════════════════════════════════════════════
    // PROPERTIES
    // ═══════════════════════════════════════════════════════════════════

    property var suggestionData
    property int suggestionIndex: 0
    property real horizontalPadding: 16
    property real iconSize: 24
    property real iconSpacing: 16
    property var colors: Theme.ChiTheme.colors
    property var motion: Theme.ChiTheme.motion

    // ═══════════════════════════════════════════════════════════════════
    // SIGNALS
    // ═══════════════════════════════════════════════════════════════════

    signal clicked()
    signal insertClicked()

    // ═══════════════════════════════════════════════════════════════════
    // DERIVED STATE
    // ═══════════════════════════════════════════════════════════════════

    readonly property bool isHovered: mouseArea.containsMouse
    readonly property bool isPressed: mouseArea.pressed

    readonly property string displayText: {
        if (suggestionData === undefined || suggestionData === null) return ""
        return suggestionData.text !== undefined ? suggestionData.text : String(suggestionData)
    }

    readonly property string displayIcon: {
        if (suggestionData === undefined || suggestionData === null) return "history"
        return suggestionData.icon !== undefined ? suggestionData.icon : "history"
    }

    readonly property string displaySubtitle: {
        if (suggestionData === undefined || suggestionData === null) return ""
        return suggestionData.subtitle !== undefined ? suggestionData.subtitle : ""
    }

    readonly property string displayTrailing: {
        if (suggestionData === undefined || suggestionData === null) return "north_west"
        return suggestionData.trailing !== undefined ? suggestionData.trailing : "north_west"
    }

    readonly property bool showTrailing: {
        if (suggestionData === undefined || suggestionData === null) return true
        return suggestionData.showTrailing !== false
    }

    // ═══════════════════════════════════════════════════════════════════
    // TYPOGRAPHY — set by parent SearchBar to match input size
    // ═══════════════════════════════════════════════════════════════════

    property var _titleTypo: Theme.ChiTheme.typography.bodyMedium
    property var _subtitleTypo: Theme.ChiTheme.typography.bodySmall

    // ═══════════════════════════════════════════════════════════════════
    // HOVER BACKGROUND
    // ═══════════════════════════════════════════════════════════════════

    Rectangle {
        anchors.fill: parent
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        radius: 12
        color: colors.onSurface
        opacity: isPressed ? 0.12 : (isHovered ? 0.08 : 0)

        Behavior on opacity {
            NumberAnimation { duration: root.motion.durationFast; easing.type: Easing.OutCubic }
        }
    }

    // ═══════════════════════════════════════════════════════════════════
    // CONTENT ROW
    // ═══════════════════════════════════════════════════════════════════

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: horizontalPadding
        anchors.rightMargin: horizontalPadding
        spacing: iconSpacing

        // Leading icon
        Common.Icon {
            source: displayIcon
            size: iconSize
            color: colors.onSurfaceVariant
            Layout.alignment: Qt.AlignVCenter
        }

        // Text content
        Column {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 2

            Text {
                width: parent.width
                text: displayText
                font.family: root._titleTypo.family
                font.pixelSize: root._titleTypo.size
                font.weight: root._titleTypo.weight
                font.letterSpacing: root._titleTypo.spacing || 0
                color: colors.onSurface
                elide: Text.ElideRight
            }

            Text {
                visible: displaySubtitle !== ""
                width: parent.width
                text: displaySubtitle
                font.family: root._subtitleTypo.family
                font.pixelSize: root._subtitleTypo.size
                font.weight: root._subtitleTypo.weight
                font.letterSpacing: root._subtitleTypo.spacing || 0
                color: colors.onSurfaceVariant
                elide: Text.ElideRight
            }
        }

        // Trailing icon (insert action)
        Item {
            visible: showTrailing
            Layout.preferredWidth: iconSize
            Layout.preferredHeight: iconSize
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                id: trailingHover
                anchors.centerIn: parent
                width: parent.width + 8; height: parent.height + 8
                radius: width / 2
                color: colors.onSurface
                opacity: 0; z: -1

                Behavior on opacity {
                    NumberAnimation { duration: root.motion.durationFast; easing.type: Easing.OutCubic }
                }
            }

            Common.Icon {
                anchors.centerIn: parent
                source: displayTrailing
                size: iconSize * 0.8
                color: colors.onSurfaceVariant
            }

            MouseArea {
                id: trailingMouse
                anchors.fill: parent
                anchors.margins: -4
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                propagateComposedEvents: false

                onContainsMouseChanged: trailingHover.opacity = containsMouse ? 0.08 : 0
                onPressed: function(mouse) {
                    trailingHover.opacity = 0.12
                    mouse.accepted = true
                }
                onReleased: trailingHover.opacity = containsMouse ? 0.08 : 0
                onClicked: function(mouse) {
                    mouse.accepted = true
                    root.insertClicked()
                }
            }
        }
    }

    // Full-area click handler behind everything
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        z: -1

        onClicked: root.clicked()
    }
}
