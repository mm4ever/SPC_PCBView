#ifndef LANGUAGESETTING_HPP
#define LANGUAGESETTING_HPP

#include <QObject>
#include <QTranslator>
#include <QString>
#include <QQmlApplicationEngine>

#include "MetaEnum.hpp"
#include "CustomException.hpp"

namespace App
{
    /**
     *  @brief 此类实现程序在运行期间的语言切换，具体要配置qml界面使用
     *
     *  @author grace
     *  @version 1.00 2018-02-21 grace
     *                note:create it
     */
    class LanguageSetting : public QObject
    {
        Q_OBJECT
        Q_PROPERTY(int languageSelectedIndex READ languageSelectedIndex  WRITE setLanguageSelectedIndex NOTIFY languageSelectedIndexChanged)

    public:

        enum class LanguageType // 语言类型
        {
            CHINESE, // 中文
            ENGLISH  // 英文
        };
        Q_ENUM(LanguageType)

        LanguageSetting(QObject* parent = 0);
        virtual ~LanguageSetting();

void setLanguage();

        Q_INVOKABLE void setLanguage(LanguageType languageType);

        Q_INVOKABLE QStringList languageTypeList() const;

        Q_INVOKABLE void setLanguageType (int languageIndex,LanguageType languageType);

        int languageSelectedIndex() const;
        void setLanguageSelectedIndex(int languageIndex);
        LanguageType languageType()const;

        void setPEngine(QQmlApplicationEngine *pEngine);

        void setPTranslator(QTranslator *pTranslator);

        QList<LanguageType> languages() const;
        void setLanguages(const QList<LanguageType> &languages);

        QStringList languageList();

    signals:
        void languageSelectedIndexChanged(int selectedIndex);

    private:
        int m_languageSelectedIndex{0};                 // 进行语言类型切换时定位，和界面进行绑定
        QStringList m_languageList;
        QList<LanguageType> m_languages;    // 存放语言类型
        QQmlApplicationEngine *m_pEngine;   // 调用翻译相关函数
        QTranslator *m_pTranslator;         // 调用翻译相关函数
        // 翻译文件所在的路径
        QString m_filesPathArr[2] { ":/language/tr_cn.qm", ":/language/tr_en.qm" };
    };
}//End of namespace Job

#endif // LANGUAGESETTING_HPP
