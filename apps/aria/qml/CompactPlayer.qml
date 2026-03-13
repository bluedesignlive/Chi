import QtQuick
import Chi 1.0

// Compact mode player strip — minimal footprint.
// Uses Chi's LinearProgressIndicator instead of custom progress bar.
// Expand action lives only in the toolbar (no duplicate button here).
Item {
    id: cp

    property bool   isPlaying: false
    property real   progress: 0.0
    property int    currentMs: 0
    property int    totalMs: 0
    property real   currentVolume: 0.75
    property bool   isMuted: false
    property string fileName: ""
    property int    currentIndex: -1
    property int    totalCount: 0
    property bool   hasNext: false
    property bool   hasPrevious: false

    property var colors: ChiTheme.colors

    signal playPauseTriggered()
    signal previousTriggered()
    signal nextTriggered()
    signal seekTriggered(real position)
    signal volumeAdjusted(real value)
    signal muteToggled(bool value)

    implicitHeight: 80

    Rectangle {
        anchors.fill: parent
        color: colors.surfaceContainer

        // Chi library progress bar — seekable
        LinearProgressIndicator {
            id: progressBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            progress: cp.progress
            trackThickness: 4
            showStopIndicator: false
        }

        // Seek hit area on the progress bar
        MouseArea {
            anchors.left: parent.left; anchors.right: parent.right
            anchors.top: parent.top
            height: 16
            cursorShape: Qt.PointingHandCursor
            onPressed: function(mouse) {
                cp.seekTriggered(Math.max(0, Math.min(1, mouse.x / width)))
            }
        }

        // Controls row
        Item {
            anchors.fill: parent
            anchors.topMargin: 4
            anchors.leftMargin: 16
            anchors.rightMargin: 16

            // Left: transport
            Row {
                id: leftRow
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4

                IconButtonToggle {
                    anchors.verticalCenter: parent.verticalCenter
                    icon: "play_arrow"; selectedIcon: "pause"; size: "medium"
                    Binding on selected { value: cp.isPlaying }
                    onToggled: cp.playPauseTriggered()
                }
                IconButton {
                    anchors.verticalCenter: parent.verticalCenter
                    icon: "skip_previous"; variant: "tonal"; size: "small"
                    enabled: cp.hasPrevious; onClicked: cp.previousTriggered()
                }
                IconButton {
                    anchors.verticalCenter: parent.verticalCenter
                    icon: "skip_next"; variant: "tonal"; size: "small"
                    enabled: cp.hasNext; onClicked: cp.nextTriggered()
                }
            }

            // Center: track info
            Column {
                anchors.left: leftRow.right; anchors.right: rightRow.left
                anchors.leftMargin: 12; anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Text {
                    width: parent.width
                    text: cp.fileName || "No file"
                    font.family: ChiTheme.fontFamily; font.pixelSize: 14; font.weight: Font.Medium
                    color: colors.onSurface; elide: Text.ElideMiddle
                    horizontalAlignment: Text.AlignHCenter
                }
                Text {
                    width: parent.width
                    text: _fmt(cp.currentMs) + " / " + _fmt(cp.totalMs)
                    font.family: ChiTheme.fontFamily; font.pixelSize: 12
                    color: colors.onSurfaceVariant
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            // Right: badge + volume (no expand button — toolbar handles it)
            Row {
                id: rightRow
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                Rectangle {
                    visible: cp.totalCount > 1
                    anchors.verticalCenter: parent.verticalCenter
                    width: _bt.implicitWidth + 14; height: 22; radius: 11
                    color: colors.surfaceContainerHighest
                    Text {
                        id: _bt; anchors.centerIn: parent
                        text: (cp.currentIndex + 1) + "/" + cp.totalCount
                        font.family: ChiTheme.fontFamily; font.pixelSize: 11
                        color: colors.onSurfaceVariant
                    }
                }

                VolumeSlider {
                    anchors.verticalCenter: parent.verticalCenter
                    volume: cp.currentVolume; muted: cp.isMuted
                    onVolumeChanged: cp.volumeAdjusted(volume)
                    onMutedChanged: cp.muteToggled(muted)
                }
            }
        }
    }

    function _fmt(ms) {
        var s = Math.floor(ms / 1000), m = Math.floor(s / 60)
        s = s % 60
        return m + ":" + (s < 10 ? "0" : "") + s
    }
}
