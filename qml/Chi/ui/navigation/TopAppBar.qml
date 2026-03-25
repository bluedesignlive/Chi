import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../../theme" as Theme

Rectangle {
    id: root

    property string title: ""
    property string subtitle: ""
    property string variant: "small"
    property string navigationIcon: "←"
    property bool showNavigation: true
    property bool elevated: false
    property real scrollOffset: 0
    property real expandedHeight: _isLarge ? 152 : (_isMedium ? 112 : 64)
    property real collapsedHeight: 64

    property alias actions: actionsRow.data

    signal navigationClicked()

    readonly property bool _isSmall: variant === "small"
    readonly property bool _isCenter: variant === "center"
    readonly property bool _isMedium: variant === "medium"
    readonly property bool _isLarge: variant === "large"
    readonly property bool isExpanded: !_isSmall && !_isCenter
    readonly property real scrollProgress: {
        var range = expandedHeight - collapsedHeight
        return range > 0 ? Math.min(1, scrollOffset / range) : 0
    }
    readonly property real currentHeight: isExpanded ?
        expandedHeight - scrollProgress * (expandedHeight - collapsedHeight) : collapsedHeight
    readonly property bool _hasShadow: elevated || scrollProgress > 0

    implicitWidth: parent ? parent.width : 400
    implicitHeight: currentHeight

    property var colors: Theme.ChiTheme.colors
    readonly property string fontFamily: Theme.ChiTheme.fontFamily
    readonly property string iconFamily: Theme.ChiTheme.iconFamily

    color: _hasShadow ? colors.surfaceContainer : colors.surface

    Behavior on color { ColorAnimation { duration: 200 } }

    layer.enabled: _hasShadow
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: Qt.rgba(0, 0, 0, 0.15)
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 2
        shadowBlur: 0.2
    }

    RowLayout {
        id: topRow
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 64
        spacing: 4

        Item {
            visible: root.showNavigation
            Layout.preferredWidth: 48
            Layout.preferredHeight: 48
            Layout.leftMargin: 4

            Rectangle {
                anchors.centerIn: parent
                width: 40; height: 40; radius: 20
                color: colors.onSurface
                opacity: navMouse.containsMouse ? 0.08 : 0
                Behavior on opacity { NumberAnimation { duration: 100 } }
            }

            Text {
                anchors.centerIn: parent
                text: root.navigationIcon
                font.family: root.navigationIcon.length > 2 ? iconFamily : fontFamily
                font.pixelSize: 24
                color: colors.onSurface
                Behavior on color { ColorAnimation { duration: 200 } }
            }

            MouseArea {
                id: navMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.navigationClicked()
            }
        }

        Item {
            visible: !root.showNavigation
            Layout.preferredWidth: 16
        }

        Text {
            visible: root._isSmall || root._isCenter || root.scrollProgress > 0.5
            text: root.title
            font.family: fontFamily
            font.pixelSize: 22
            font.weight: Font.Normal
            color: colors.onSurface
            elide: Text.ElideRight
            opacity: (root._isSmall || root._isCenter) ? 1 :
                Math.max(0, (root.scrollProgress - 0.5) * 2)
            Layout.fillWidth: !root._isCenter
            Layout.alignment: root._isCenter ? Qt.AlignHCenter : Qt.AlignLeft
            Behavior on color { ColorAnimation { duration: 200 } }
        }

        Item {
            visible: root._isCenter
            Layout.fillWidth: true
        }

        RowLayout {
            id: actionsRow
            Layout.rightMargin: 4
            spacing: 0
        }
    }

    Column {
        visible: root.isExpanded && root.scrollProgress < 1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        anchors.bottomMargin: root._isLarge ? 28 : 20
        spacing: 0
        opacity: 1 - root.scrollProgress

        Text {
            text: root.title
            font.family: fontFamily
            font.pixelSize: root._isLarge ? 36 : 28
            font.weight: Font.Normal
            color: colors.onSurface
            elide: Text.ElideRight
            width: parent.width
            Behavior on color { ColorAnimation { duration: 200 } }
        }

        Text {
            visible: root.subtitle !== "" && root._isMedium
            text: root.subtitle
            font.family: fontFamily
            font.pixelSize: 14
            color: colors.onSurfaceVariant
            elide: Text.ElideRight
            width: parent.width
            topPadding: 4
            Behavior on color { ColorAnimation { duration: 200 } }
        }
    }

    Accessible.role: Accessible.ToolBar
    Accessible.name: title
}
