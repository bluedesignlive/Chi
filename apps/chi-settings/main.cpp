#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("Chi");
    app.setApplicationName("Chi Settings");

    QQmlApplicationEngine engine;
    engine.loadFromModule("ChiSettings", "Main");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
