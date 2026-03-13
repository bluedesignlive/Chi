import QtQuick
import QtQuick.Controls.Basic
import Chi 1.0
import Aria 1.0

ChiApplicationWindow {
    id: window
    width: 700
    height: 460
    minimumWidth: 480
    minimumHeight: compactMode ? 80 : 360
    title: folderPlayer.currentFileName || "Aria"
    controlsStyle: "macOS"

    // ── State ───────────────────────────────────────────────
    property bool compactMode: false
    property bool hasFile: folderPlayer.count > 0
    property bool sidebarOpen: true
    property var  colors: ChiTheme.colors
    property var  playNextQueue: []
    property int  contextTargetIndex: -1

    leadingIcon: "view_sidebar"
    onLeadingActionTriggered: sidebarOpen = !sidebarOpen

    toolbarActions: [
        QtObject {
            property string icon: "folder_open"
            property bool enabled: true
            function triggered() { fileDialog.open() }
        },
        QtObject {
            property string icon: compactMode ? "unfold_more" : "unfold_less"
            property bool enabled: hasFile
            function triggered() { compactMode = !compactMode }
        },
        QtObject {
            property string icon: ChiTheme.isDarkMode ? "\uE518" : "\uE51C"
            property bool enabled: true
            function triggered() { ChiTheme.isDarkMode = !ChiTheme.isDarkMode }
        }
    ]

    Component.onCompleted: {
        if (typeof commandLineFiles !== 'undefined' && commandLineFiles.length > 0) {
            var urls = []
            for (var i = 0; i < commandLineFiles.length; i++)
                urls.push(commandLineFiles[i])
            folderPlayer.loadUrls(urls)
        }
    }

    // ── Audio engine ────────────────────────────────────────
    AudioEngine {
        id: audio
        source: folderPlayer.currentFile
        onEndOfMedia: {
            if (playNextQueue.length > 0) {
                folderPlayer.currentIndex = playNextQueue.shift()
                playNextQueue = playNextQueue.slice()
            } else if (folderPlayer.hasNext) {
                folderPlayer.next()
            }
        }
        onMediaLoaded: { waveform.source = source; audio.play() }
    }

    FolderPlayer { id: folderPlayer }

    // ── File dialogs ────────────────────────────────────────
    FileDialog {
        id: fileDialog
        mode: "openMultiple"
        title: "Open Audio"
        nameFilters: [
            "Audio files (*.mp3 *.wav *.flac *.ogg *.m4a *.aac *.opus *.wma *.aiff *.ape)",
            "All files (*)"
        ]
        onAccepted: folderPlayer.loadUrls(selectedFiles)
    }

    FileDialog {
        id: folderDialog
        mode: "folder"
        title: "Open Folder"
        onAccepted: folderPlayer.loadFolder(selectedFile)
    }

    // ── Layout ──────────────────────────────────────────────
    Row {
        anchors.fill: parent

        // ── Sidebar ─────────────────────────────────────────
        Rectangle {
            id: sidebar
            width: sidebarOpen && hasFile && !compactMode ? 240 : 0
            height: parent.height
            color: colors.surfaceContainer
            clip: true
            Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

            ListView {
                id: trackList
                anchors.fill: parent
                model: folderPlayer.files
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                currentIndex: folderPlayer.currentIndex

                delegate: Item {
                    id: del
                    width: sidebar.width; height: 56
                    required property int index
                    required property string modelData

                    property bool isCurrent: index === folderPlayer.currentIndex
                    property bool isQueued: playNextQueue.indexOf(index) !== -1
                    property string trackName: {
                        var n = modelData.substring(modelData.lastIndexOf('/') + 1)
                        var d = n.lastIndexOf('.')
                        return d > 0 ? n.substring(0, d) : n
                    }

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 4
                        anchors.leftMargin: 8; anchors.rightMargin: 8
                        radius: 12
                        color: del.isCurrent ? colors.primaryContainer
                             : itemMouse.containsMouse ? colors.surfaceContainerHighest
                             : "transparent"

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 8; anchors.rightMargin: 12
                            spacing: 10

                            Rectangle {
                                width: 36; height: 36; radius: 8
                                anchors.verticalCenter: parent.verticalCenter
                                color: _trackColor(del.trackName)

                                Text {
                                    anchors.centerIn: parent
                                    text: del.trackName.charAt(0).toUpperCase()
                                    font.pixelSize: 15; font.weight: Font.Medium
                                    font.family: ChiTheme.fontFamily; color: "#ffffff"
                                }

                                Rectangle {
                                    anchors.fill: parent; radius: parent.radius
                                    color: colors.primary
                                    opacity: del.isCurrent && audio.playing ? 0.85 : 0
                                    visible: opacity > 0
                                    Behavior on opacity { NumberAnimation { duration: 150 } }
                                    Text {
                                        anchors.centerIn: parent
                                        text: "\uE050"
                                        font.family: ChiTheme.iconFamily
                                        font.pixelSize: 18; color: colors.onPrimary
                                    }
                                }
                            }

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 66; spacing: 1
                                Text {
                                    width: parent.width; text: del.trackName
                                    font.family: ChiTheme.fontFamily; font.pixelSize: 13
                                    font.weight: del.isCurrent ? Font.Medium : Font.Normal
                                    color: del.isCurrent ? colors.onPrimaryContainer : colors.onSurface
                                    elide: Text.ElideRight
                                }
                                Text {
                                    visible: del.isCurrent || del.isQueued
                                    text: del.isCurrent ? (audio.playing ? "Playing" : "Paused")
                                        : del.isQueued ? "Up Next" : ""
                                    font.family: ChiTheme.fontFamily; font.pixelSize: 11
                                    color: del.isCurrent ? colors.primary : colors.tertiary
                                }
                            }
                        }

                        MouseArea {
                            id: itemMouse; anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            cursorShape: Qt.PointingHandCursor
                            onClicked: function(mouse) {
                                if (mouse.button === Qt.LeftButton)
                                    folderPlayer.currentIndex = del.index
                                else {
                                    contextTargetIndex = del.index
                                    trackContextMenu.popup(mouse.x, mouse.y)
                                }
                            }
                        }
                    }
                }
            }

            ContextMenu {
                id: trackContextMenu

                MenuItem {
                    text: "Play"
                    leadingIcon: "\uE037"
                    enabled: contextTargetIndex !== folderPlayer.currentIndex
                    onClicked: folderPlayer.currentIndex = contextTargetIndex
                }
                MenuItem {
                    text: "Play Next"
                    leadingIcon: "\uE066"
                    enabled: contextTargetIndex !== folderPlayer.currentIndex
                    onClicked: _enqueue(contextTargetIndex)
                }
                MenuItem {
                    text: "Add to Queue"
                    leadingIcon: "\uE03B"
                    enabled: contextTargetIndex !== folderPlayer.currentIndex
                    onClicked: _enqueue(contextTargetIndex)
                }
                MenuItem {
                    text: "Remove from Queue"
                    leadingIcon: "\uE15D"
                    visible: playNextQueue.indexOf(contextTargetIndex) !== -1
                    onClicked: _dequeue(contextTargetIndex)
                }
            }
        }

        // ── Main content ────────────────────────────────────
        Rectangle {
            width: parent.width - sidebar.width
            height: parent.height
            color: colors.background

            DropZone {
                anchors.fill: parent; visible: !hasFile
                onFilesDropped: function(urls) { folderPlayer.loadUrls(urls) }
                onClicked: fileDialog.open()
            }

            CompactPlayer {
                anchors.fill: parent; visible: hasFile && compactMode
                isPlaying: audio.playing
                progress: audio.duration > 0 ? audio.position / audio.duration : 0
                currentMs: audio.position; totalMs: audio.duration
                currentVolume: audio.volume; isMuted: audio.muted
                fileName: folderPlayer.currentFileName
                currentIndex: folderPlayer.currentIndex; totalCount: folderPlayer.count
                hasNext: folderPlayer.hasNext; hasPrevious: folderPlayer.hasPrevious
                onPlayPauseTriggered: audio.togglePlayPause()
                onPreviousTriggered: folderPlayer.previous()
                onNextTriggered: folderPlayer.next()
                onSeekTriggered: function(pos) { audio.seek(pos) }
                onVolumeAdjusted: function(val) { audio.volume = val }
                onMuteToggled: function(val) { audio.muted = val }
            }

            Item {
                anchors.fill: parent; visible: hasFile && !compactMode

                Column {
                    anchors.centerIn: parent; spacing: 20
                    width: parent.width - 80

                    Waveform {
                        id: waveform; width: parent.width; height: 80
                        progress: audio.duration > 0 ? audio.position / audio.duration : 0
                        activeColor: colors.primary
                        inactiveColor: colors.surfaceContainerHighest
                        onSeekTriggered: function(pos) { audio.seek(pos) }
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: folderPlayer.currentFileName || "No file"
                        font.family: ChiTheme.fontFamily; font.pixelSize: 15; font.weight: Font.Medium
                        color: colors.onSurface; elide: Text.ElideMiddle; maximumLineCount: 1
                        width: Math.min(implicitWidth, parent.width)
                        horizontalAlignment: Text.AlignHCenter
                    }

                    TimeDisplay {
                        anchors.horizontalCenter: parent.horizontalCenter
                        currentMs: audio.position; totalMs: audio.duration
                        textColor: colors.onSurface; dimColor: colors.onSurfaceVariant
                    }

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter; spacing: 20
                        IconButton {
                            anchors.verticalCenter: parent.verticalCenter
                            icon: "skip_previous"; variant: "tonal"; size: "medium"
                            enabled: folderPlayer.hasPrevious; onClicked: folderPlayer.previous()
                        }
                        IconButtonToggle {
                            anchors.verticalCenter: parent.verticalCenter
                            icon: "play_arrow"; selectedIcon: "pause"; size: "large"
                            Binding on selected { value: audio.playing }
                            onToggled: audio.togglePlayPause()
                        }
                        IconButton {
                            anchors.verticalCenter: parent.verticalCenter
                            icon: "skip_next"; variant: "tonal"; size: "medium"
                            enabled: folderPlayer.hasNext; onClicked: folderPlayer.next()
                        }
                    }
                }

                Rectangle {
                    visible: folderPlayer.count > 1
                    anchors.right: parent.right; anchors.bottom: parent.bottom
                    anchors.rightMargin: 24; anchors.bottomMargin: 24
                    width: _badge.implicitWidth + 20; height: 28; radius: 14
                    color: colors.surfaceContainerHigh
                    Text {
                        id: _badge; anchors.centerIn: parent
                        text: (folderPlayer.currentIndex + 1) + " / " + folderPlayer.count
                        font.family: ChiTheme.fontFamily; font.pixelSize: 13; font.weight: Font.Medium
                        color: colors.onSurfaceVariant
                    }
                }

                VolumeSlider {
                    anchors.left: parent.left; anchors.bottom: parent.bottom
                    anchors.leftMargin: 24; anchors.bottomMargin: 24
                    volume: audio.volume; muted: audio.muted
                    onVolumeChanged: audio.volume = volume
                    onMutedChanged: audio.muted = muted
                }
            }

            DropArea {
                anchors.fill: parent; z: 1000
                onDropped: function(drop) { if (drop.hasUrls) folderPlayer.loadUrls(drop.urls) }
            }
        }
    }

    // ── Shortcuts ───────────────────────────────────────────
    Shortcut { sequence: "Ctrl+O";       onActivated: fileDialog.open() }
    Shortcut { sequence: "Ctrl+Shift+O"; onActivated: folderDialog.open() }
    Shortcut { sequence: "Space";        onActivated: if (hasFile) audio.togglePlayPause() }
    Shortcut { sequence: "Left";         onActivated: if (hasFile) audio.seekBackward(5000) }
    Shortcut { sequence: "Right";        onActivated: if (hasFile) audio.seekForward(5000) }
    Shortcut { sequence: "Ctrl+Left";    onActivated: if (folderPlayer.hasPrevious) folderPlayer.previous() }
    Shortcut { sequence: "Ctrl+Right";   onActivated: if (folderPlayer.hasNext) folderPlayer.next() }
    Shortcut { sequence: "Up";           onActivated: audio.volume = Math.min(1, audio.volume + 0.05) }
    Shortcut { sequence: "Down";         onActivated: audio.volume = Math.max(0, audio.volume - 0.05) }
    Shortcut { sequence: "M";            onActivated: audio.muted = !audio.muted }
    Shortcut { sequence: "Ctrl+M";       onActivated: compactMode = !compactMode }
    Shortcut { sequence: "Ctrl+B";       onActivated: sidebarOpen = !sidebarOpen }
    Shortcut { sequence: "Escape";       onActivated: if (compactMode) compactMode = false }
    Shortcut { sequence: "Ctrl+Q";       onActivated: Qt.quit() }

    onCompactModeChanged: height = compactMode ? 80 : 460

    // ── Helpers ─────────────────────────────────────────────
    function _enqueue(idx) {
        if (playNextQueue.indexOf(idx) === -1) {
            playNextQueue.push(idx)
            playNextQueue = playNextQueue.slice()
        }
    }

    function _dequeue(idx) {
        var i = playNextQueue.indexOf(idx)
        if (i !== -1) {
            playNextQueue.splice(i, 1)
            playNextQueue = playNextQueue.slice()
        }
    }

    function _trackColor(name) {
        var hash = 0
        for (var i = 0; i < name.length; i++)
            hash = name.charCodeAt(i) + ((hash << 5) - hash)
        return Qt.hsla(((hash & 0xFFFF) % 360) / 360, 0.45, 0.55, 1.0)
    }
}
