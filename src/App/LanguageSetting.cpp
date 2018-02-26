#include "LanguageSetting.hpp"

using namespace std;

using namespace App;
using namespace SSDK;

LanguageSetting::LanguageSetting(QObject *parent) : QObject(parent),
    m_languageIndex(1)
{
    try
    {

    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("语言设置的构造函数出错!")
}

LanguageSetting::~LanguageSetting()
{

}

QStringList LanguageSetting::languageTypeList() const
{
    //只会初始化一次
    static QStringList languageTypeList;
    if( 0 == languageTypeList.count() )
    {
        //该函数在MetaeEum.hpp中
        languageTypeList = getStringListFromQEnum<LanguageSetting::LanguageType>();
    }
    return languageTypeList;
}

int LanguageSetting::languageIndex() const
{
    return this->m_languageIndex;
}

void LanguageSetting::setLanguageIndex(int index)
{
    this->m_languageIndex = index;
    emit languageIndexChanged(this->m_languageIndex);
}

LanguageSetting::LanguageType LanguageSetting::languageType() const
{
    QString key = languageTypeList().at(m_languageIndex);
    auto val = getQEnumValFromKey<LanguageSetting::LanguageType>(key.toStdString());
    return (LanguageSetting::LanguageType)val.toInt();
}

void LanguageSetting::setPEngine(QQmlApplicationEngine *pEngine)
{
    this->m_pEngine = pEngine;
}

void LanguageSetting::setPTranslator(QTranslator *pTranslator)
{
    this->m_pTranslator = pTranslator;
}

void LanguageSetting::changeLanguageType()
{
    this->m_pTranslator->load(this->m_filesPathArr[int(languageType())]);
    if(nullptr != this->m_pEngine)
    {
        this->m_pEngine->retranslate();
    }
}
