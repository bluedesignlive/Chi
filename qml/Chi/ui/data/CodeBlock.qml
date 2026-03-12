import QtQuick
import QtQuick.Layouts
import "../theme" as Theme

Rectangle {
    id: root

    property string code: ""
    property string language: ""
    property bool showLineNumbers: true
    property bool showCopyButton: true
    property bool wrapLines: false
    property int tabSize: 4
    property string fontFamily: "JetBrains Mono, Fira Code, Consolas, monospace"
    property int fontSize: 13

    signal copied()

    readonly property var lines: code.split("\n")

    implicitWidth: 400
    implicitHeight: Math.max(80, codeColumn.implicitHeight + 24)

    property var colors: Theme.ChiTheme.colors

    radius: 8
    color: colors.surfaceContainerHighest
    border.width: 1
    border.color: colors.outlineVariant

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    clip: true

    // Header with language and copy button
    Rectangle {
        id: header
        visible: language !== "" || showCopyButton
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 36
        color: colors.surfaceContainerLow
        radius: 8

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: parent.radius
            color: parent.color
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 8
            spacing: 8

            Text {
                text: language
                font.family: "Roboto"
                font.pixelSize: 12
                font.weight: Font.Medium
                color: colors.onSurfaceVariant
                Layout.fillWidth: true
            }

            Item {
                visible: showCopyButton
                Layout.preferredWidth: 32
                Layout.preferredHeight: 28

                Rectangle {
                    anchors.fill: parent
                    radius: 4
                    color: colors.onSurface
                    opacity: copyMouse.containsMouse ? 0.08 : 0
                }

                Text {
                    anchors.centerIn: parent
                    text: "📋"
                    font.pixelSize: 14
                }

                MouseArea {
                    id: copyMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        // Copy to clipboard would need platform integration
                        copied()
                    }
                }
            }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 1
            color: colors.outlineVariant
        }
    }

    Flickable {
        anchors.top: header.visible ? header.bottom : parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 12
        contentWidth: wrapLines ? width : codeRow.implicitWidth
        contentHeight: codeColumn.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: wrapLines ? Flickable.VerticalFlick : Flickable.AutoFlickDirection

        Row {
            id: codeRow
            spacing: 16

            // Line numbers
            Column {
                id: lineNumbers
                visible: showLineNumbers

                Repeater {
                    model: lines.length

                    Text {
                        text: (index + 1).toString()
                        font.family: fontFamily
                        font.pixelSize: fontSize
                        color: colors.onSurfaceVariant
                        opacity: 0.5
                        width: Math.max(24, (lines.length.toString().length) * 10)
                        horizontalAlignment: Text.AlignRight
                        height: fontSize + 6
                    }
                }
            }

            // Code content
            Column {
                id: codeColumn

                Repeater {
                    model: lines

                    Text {
                        text: modelData.replace(/\t/g, " ".repeat(tabSize))
                        font.family: fontFamily
                        font.pixelSize: fontSize
                        color: colors.onSurface
                        wrapMode: wrapLines ? Text.WrapAnywhere : Text.NoWrap
                        width: wrapLines ? root.width - 48 - (showLineNumbers ? 40 : 0) : implicitWidth
                        height: fontSize + 6

                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }
                }
            }
        }
    }

    Accessible.role: Accessible.StaticText
    Accessible.name: "Code block"
    Accessible.description: language
}
