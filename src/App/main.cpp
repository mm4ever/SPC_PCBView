#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QQuickStyle>

#include "LoginCheck.hpp"
#include "ElementListModel.hpp"
#include "ThemeSetting.hpp"
#include "LanguageSetting.hpp"

using namespace Job;

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
    LanguageSetting languageSetting(app, engine, translator);

    LanguageSetting langSetting; // qml与C++的枚举绑定
    const QMetaObject* metaObj = langSetting.metaObject();
    QMetaEnum enumType = metaObj->enumerator(metaObj->indexOfEnumerator("LanguageType"));
    QStringList list;
    for(int i=0; i < enumType.keyCount(); ++i)
    {
        QString item = QString::fromLatin1(enumType.key(i));
        list.append(item);
    }
    engine.rootContext()->setContextProperty("languageModel", QVariant::fromValue(list));
    engine.rootContext()->setContextProperty("languages", &languageSetting);
    app.installTranslator(&translator);

    // 加载
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
