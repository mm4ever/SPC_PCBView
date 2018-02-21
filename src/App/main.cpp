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
#include "StyleSetting.hpp"


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

    qmlRegisterType<StyleSetting>("an.qt.StyleSetting",1,0,"StyleSetting"); //主题相关

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
    translator.load(":/language/tr_en.qm");
    app.installTranslator(&translator);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("availableStyles", QQuickStyle::availableStyles());
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
