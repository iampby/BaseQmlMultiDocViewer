#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include"htmlhandler.h"
#include"texthandler.h"
int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
qmlRegisterType<HtmlHandler>("pbyFirst",1,0,"HtmlHandler");
qmlRegisterType<TextHandler>("pbySecond",1,0,"TextHandler");
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
