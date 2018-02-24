#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QQuickStyle>

#include "LoginCheck.hpp"
#include "ElementListModel.hpp"
#include "ThemeSetting.hpp"
#include "LanguageSetting.hpp"

#include <QDebug>

using namespace Job;
using namespace SSDK;

int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication::setApplicationName("SPC");
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;


    // 注册
    qmlRegisterType<LoginCheck>("an.qt.LoginCheck",1,0,"LoginCheck");
    qmlRegisterType<ElementListModel>("an.qt.CModel", 1, 0, "ElementListModel");
    qmlRegisterType<ThemeSetting>("an.qt.ThemeSetting",1,0,"ThemeSetting");
    qmlRegisterType<LanguageSetting>("an.qt.LanguageSetting",1,0,"LanguageSetting");
    qmlRegisterType<Shape>("an.qt.Shape", 1, 0, "Shape");

    qRegisterMetaType<Shape::ShapeType>();


    // 主题
    QSettings settings;
    QQuickStyle::setStyle("Material");
    QString style = QQuickStyle::name();
    if (!style.isEmpty())
        settings.setValue("style", style);
    else
        QQuickStyle::setStyle(settings.value("style").toString());


    // 语言
    QTranslator translator;
    LanguageSetting langSetting; // qml与C++的枚举绑定
    langSetting.setPEngine(&engine);
    langSetting.setPTranslator(&translator);
    engine.rootContext()->setContextProperty("languages", &langSetting);
    app.installTranslator(&translator);


    // 加载main.qml
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
