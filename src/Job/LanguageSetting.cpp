#include "LanguageSetting.hpp"

using namespace std;

using namespace Job;
using namespace SSDK;

LanguageSetting::LanguageSetting(QObject *parent) : QObject(parent),
    m_laguageIndex(0)
{
    try
    {
        this->m_languageList = QEnumStringList<LanguageSetting>(string("LanguageType"));

        this->m_languages.push_back(LanguageType::CHINESE);
        this->m_languages.push_back(LanguageType::ENGLISH);
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("语言设置的构造函数出错!")
}

LanguageSetting::~LanguageSetting()
{

}

void LanguageSetting::setLanguage(LanguageType languageType)
{
    try
    {
        switch (languageType)
        {
        case LanguageType::CHINESE:
            this->m_pTranslator->load(this->m_filesPathArr[int(languageType)]);
            break;
        case LanguageType::ENGLISH:
            this->m_pTranslator->load(this->m_filesPathArr[int(languageType)]);
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

int LanguageSetting::laguageIndex() const
{
    return this->m_laguageIndex;
}

void LanguageSetting::setLaguageIndex(int laguageIndex)
{
    this->m_laguageIndex = laguageIndex;
}
void LanguageSetting::setPEngine(QQmlApplicationEngine *pEngine)
{
    m_pEngine = pEngine;
}

void LanguageSetting::setPTranslator(QTranslator *pTranslator)
{
    m_pTranslator = pTranslator;
}

QStringList LanguageSetting::languageList()
{
    if(0 == this->m_languageList.count())
    {
        this->m_languageList = QEnumStringList<LanguageSetting>(string("LanguageType"));
    }
    return this->m_languageList;
}
