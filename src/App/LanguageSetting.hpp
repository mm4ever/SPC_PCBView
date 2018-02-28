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
        Q_ENUMS(LanguageType)
        Q_PROPERTY(int laguageIndex READ laguageIndex  WRITE setLaguageIndex NOTIFY laguageIndexChanged)

    public:

        enum class LanguageType // 语言类型
        {
            CHINESE, // 中文
            ENGLISH  // 英文
        };
        Q_ENUM(LanguageType)

        Q_INVOKABLE QStringList languageTypeList() const;

        LanguageSetting(QObject* parent = 0);
        virtual ~LanguageSetting();

        int laguageIndex() const;
        void setLaguageIndex(int laguageIndex);

        void setPEngine(QQmlApplicationEngine *pEngine);
        void setPTranslator(QTranslator *pTranslator);


    signals:
        void laguageIndexChanged(int laguageIndex);


    public slots:
        void languageUpdate();


    private:
        int m_laguageIndex;                 // 进行语言类型切换时定位，和界面进行绑定
        QQmlApplicationEngine *m_pEngine;   // 调用翻译相关函数
        QTranslator *m_pTranslator;         // 调用翻译相关函数
        // 翻译文件所在的路径
        QString m_filesPathArr[2] = {":/language/tr_cn.qm",":/language/tr_en.qm"};
    };
}//End of namespace Job

#endif // LANGUAGESETTING_HPP
