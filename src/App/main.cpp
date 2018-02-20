#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QQuickStyle>
#include <QIcon>
#include <QTranslator>
#include <QDebug>

#include "LoginCheck.hpp"
#include "ElementListModel.hpp"

using namespace Job;

int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication::setApplicationName("SPC");
    QGuiApplication app(argc, argv);

    // 注册
    qmlRegisterType<LoginCheck>("an.qt.LoginCheck",1,0,"LoginCheck");

    qmlRegisterType<ElementListModel>("an.qt.CModel", 1, 0, "ElementListModel");


    // 主题
    QSettings settings;
    QString style = QQuickStyle::name();
    if (!style.isEmpty())
        settings.setValue("style", style);
    else
        QQuickStyle::setStyle(settings.value("style").toString());

    // 语言
    QTranslator translator;
    translator.load(":/language/tr_en.qm");
    app.installTranslator(&translator);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("availableStyles", QQuickStyle::availableStyles());
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    //    engine.load(QUrl(QLatin1String("qrc:/03_CallCppModel.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();

//    // 数据测试
//    Element obj;
//    obj.setJobPath("../data/qml");

//    obj.read();

//    obj.add(SSDK::Shape::ShapeType::RECTANGLE,1,11,111,1111);
//    obj.add(SSDK::Shape::ShapeType::CIRCLE,2,22,222,2222);
//    obj.remove(123,222);
//    obj.remove(321,111);
//    obj.save();
}
