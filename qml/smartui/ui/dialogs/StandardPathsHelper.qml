pragma Singleton
import QtQuick
import Qt.labs.platform

QtObject {
    readonly property url home: StandardPaths.writableLocation(StandardPaths.HomeLocation)
    readonly property url documents: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
    readonly property url downloads: StandardPaths.writableLocation(StandardPaths.DownloadLocation)
    readonly property url pictures: StandardPaths.writableLocation(StandardPaths.PicturesLocation)
    readonly property url music: StandardPaths.writableLocation(StandardPaths.MusicLocation)
    readonly property url videos: StandardPaths.writableLocation(StandardPaths.MoviesLocation)
    readonly property url desktop: StandardPaths.writableLocation(StandardPaths.DesktopLocation)
}
