#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QUrl>
#include <QFileInfo>
#include "audioengine.h"
#include "waveformgenerator.h"
#include "folderplayer.h"

using namespace Qt::StringLiterals;

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName("Aria");
    app.setApplicationDisplayName("Aria");
    app.setOrganizationName("Chi");
    app.setOrganizationDomain("chi.aria");
    app.setDesktopFileName("io.github.chi.aria");
    app.setWindowIcon(QIcon::fromTheme("io.github.chi.aria",
                      QIcon::fromTheme("audio-x-generic")));

    qmlRegisterType<AudioEngine>("Aria", 1, 0, "AudioEngine");
    qmlRegisterType<WaveformGenerator>("Aria", 1, 0, "WaveformGenerator");
    qmlRegisterType<FolderPlayer>("Aria", 1, 0, "FolderPlayer");

    QQmlApplicationEngine engine;

    QStringList audioFiles;
    const QStringList args = app.arguments();
    for (int i = 1; i < args.size(); ++i) {
        if (!args.at(i).startsWith('-')) {
            QFileInfo fi(args.at(i));
            if (fi.exists())
                audioFiles.append(QUrl::fromLocalFile(fi.absoluteFilePath()).toString());
        }
    }
    engine.rootContext()->setContextProperty("commandLineFiles", audioFiles);

    const QUrl url(u"qrc:/qt/qml/Aria/qml/Main.qml"_s);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
