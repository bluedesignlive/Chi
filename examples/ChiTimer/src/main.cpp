#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName("ChiTimer");
    app.setOrganizationName("ChiProject");

    QQmlApplicationEngine engine;
    
    // Add Chi import path (assumes Chi is built/installed alongside)
    engine.addImportPath(QGuiApplication::applicationDirPath() + "/../qml");
    
    engine.load(QUrl(QStringLiteral("qrc:/ChiTimer/qml/Main.qml")));
    
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
