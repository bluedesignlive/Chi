import QtQuick
import QtQuick.Layouts
import "../theme" as Theme

Rectangle {
    id: root

    property string fontFamily: "JetBrains Mono, Fira Code, monospace"
    property int fontSize: 14
    property var history: []
    property int historyIndex: -1
    property string currentLine: ""
    property string prompt: "$ "
    property bool showPrompt: true
    property var output: []
    property bool enabled: true
    property int maxLines: 1000
    property bool copyOnSelect: true

    signal commandEntered(string command)
    signal interrupted()

    implicitWidth: 600
    implicitHeight: 400

    property var colors: Theme.ChiTheme.colors

    color: Qt.rgba(0, 0, 0, 0.9)
    radius: 8

    // Terminal colors
    property var termColors: ({
        background: "#1a1a1a",
        foreground: "#f0f0f0",
        black: "#000000",
        red: "#ff5555",
        green: "#50fa7b",
        yellow: "#f1fa8c",
        blue: "#6272a4",
        magenta: "#ff79c6",
        cyan: "#8be9fd",
        white: "#f8f8f2",
        brightBlack: "#6272a4",
        brightRed: "#ff6e6e",
        brightGreen: "#69ff94",
        brightYellow: "#ffffa5",
        brightBlue: "#d6acff",
        brightMagenta: "#ff92df",
        brightCyan: "#a4ffff",
        brightWhite: "#ffffff"
    })

    Flickable {
        id: flickable
        anchors.fill: parent
        anchors.margins: 12
        contentHeight: outputColumn.height + inputRow.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        function scrollToBottom() {
            contentY = Math.max(0, contentHeight - height)
        }

        Column {
            id: outputColumn
            width: parent.width
            spacing: 2

            Repeater {
                model: output

                Text {
                    width: parent.width
                    text: modelData.text || modelData
                    font.family: fontFamily
                    font.pixelSize: fontSize
                    color: modelData.color || termColors.foreground
                    wrapMode: Text.WrapAnywhere
                    textFormat: Text.PlainText
                }
            }
        }

        Row {
            id: inputRow
            anchors.top: outputColumn.bottom
            anchors.topMargin: 2
            width: parent.width

            Text {
                visible: showPrompt
                text: prompt
                font.family: fontFamily
                font.pixelSize: fontSize
                color: termColors.green
            }

            TextInput {
                id: commandInput
                width: parent.width - (showPrompt ? prompt.length * fontSize * 0.6 : 0)
                font.family: fontFamily
                font.pixelSize: fontSize
                color: termColors.foreground
                selectionColor: termColors.blue
                selectedTextColor: termColors.white
                cursorVisible: true
                enabled: root.enabled

                onAccepted: {
                    if (text.trim() !== "") {
                        history.push(text)
                        historyIndex = history.length
                        commandEntered(text)
                    }
                    text = ""
                    flickable.scrollToBottom()
                }

                Keys.onUpPressed: {
                    if (historyIndex > 0) {
                        historyIndex--
                        text = history[historyIndex]
                        cursorPosition = text.length
                    }
                }

                Keys.onDownPressed: {
                    if (historyIndex < history.length - 1) {
                        historyIndex++
                        text = history[historyIndex]
                        cursorPosition = text.length
                    } else {
                        historyIndex = history.length
                        text = ""
                    }
                }

                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_C && event.modifiers & Qt.ControlModifier) {
                        interrupted()
                        event.accepted = true
                    }
                    if (event.key === Qt.Key_L && event.modifiers & Qt.ControlModifier) {
                        root.clear()
                        event.accepted = true
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: commandInput.forceActiveFocus()
    }

    function write(text, color) {
        output.push({ text: text, color: color || termColors.foreground })
        if (output.length > maxLines) {
            output.shift()
        }
        outputChanged()
        flickable.scrollToBottom()
    }

    function writeLine(text, color) {
        write(text + "\n", color)
    }

    function writeError(text) {
        write(text, termColors.red)
    }

    function writeSuccess(text) {
        write(text, termColors.green)
    }

    function writeWarning(text) {
        write(text, termColors.yellow)
    }

    function clear() {
        output = []
    }

    function focus() {
        commandInput.forceActiveFocus()
    }

    Component.onCompleted: focus()

    Accessible.role: Accessible.EditableText
    Accessible.name: "Terminal"
}
