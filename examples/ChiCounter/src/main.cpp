#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName("ChiCounter");
    app.setOrganizationName("ChiProject");

    QQmlApplicationEngine engine;

    engine.addImportPath(QGuiApplication::applicationDirPath() + "/../qml");

    engine.load(QUrl(QStringLiteral("qrc:/ChiCounter/qml/Main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
