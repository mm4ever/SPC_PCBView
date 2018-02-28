#include "LanguageSetting.hpp"

using namespace std;

using namespace App;
using namespace SSDK;

LanguageSetting::LanguageSetting(QObject *parent) : QObject(parent),
    m_languageSelectedIndex(0)
{
    try
    {
        this->m_languages.push_back(LanguageType::CHINESE);
        this->m_languages.push_back(LanguageType::ENGLISH);
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("语言设置的构造函数出错!")
}

LanguageSetting::~LanguageSetting()
{

}

QStringList LanguageSetting::languageTypeList() const
{
    static QStringList languageTypeList;
    if( 0 == languageTypeList.count() )
    {
        languageTypeList = getStringListFromQEnum<LanguageSetting::LanguageType>();
    }
    return languageTypeList;
}


void LanguageSetting::setLanguage(LanguageType languageType)
{
    try
    {
        switch (m_languageSelectedIndex)
        {
        case 0:
            this->m_pTranslator->load(this->m_filesPathArr[int(LanguageType::CHINESE)]);
            break;

        case 1:
            this->m_pTranslator->load(this->m_filesPathArr[int(LanguageType::ENGLISH)]);
            break;

        default:
            break;
        }

        if(nullptr != this->m_pEngine)
        {
            this->m_pEngine->retranslate();
        }
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("设置语言时出错!")
}

void LanguageSetting::setLanguage()
{
    try
    {
        this->m_pTranslator->load(this->m_filesPathArr[int(languageType())]);
        if(nullptr != this->m_pEngine)
        {
            this->m_pEngine->retranslate();
        }
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("设置语言时出错!")
}

void LanguageSetting::setLanguageType(int languageIndex, LanguageType languageType)
{
    try
    {
        if(languageIndex > -1 && languageIndex < this->m_languages.count())
        {
            switch (languageType)
            {
            case LanguageType::CHINESE:
                this->m_languages[languageIndex] = languageType;
                break;
            case LanguageType::ENGLISH:
                this->m_languages[languageIndex] = languageType;
                break;
            default:
                break;
            }
        }
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("从qml设置数据到C++部分出错!")
}

int LanguageSetting::languageSelectedIndex() const
{
    return this->m_languageSelectedIndex;
}
void LanguageSetting::setLanguageSelectedIndex(int languageIndex)
{
    this->m_languageSelectedIndex = languageIndex;
    emit languageSelectedIndexChanged(this->m_languageSelectedIndex);

    setLanguage();
}
LanguageSetting::LanguageType LanguageSetting::languageType() const
{
    QString key = languageTypeList().at(m_languageSelectedIndex);
    auto val = getQEnumValFromKey<LanguageSetting::LanguageType>(key.toStdString());
    return (LanguageSetting::LanguageType)val.toInt();
}

void LanguageSetting::setPEngine(QQmlApplicationEngine *pEngine)
{
    m_pEngine = pEngine;
}

void LanguageSetting::setPTranslator(QTranslator *pTranslator)
{
    m_pTranslator = pTranslator;
}
