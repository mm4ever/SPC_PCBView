#include "LanguageSetting.hpp"

using namespace SSDK;
using namespace Job;

LanguageSetting::LanguageSetting(QObject *parent) : QObject(parent),
    m_laguageIndex(0)
{
    try
    {
        this->m_languages.push_back(LanguageType::CHINESE);
        this->m_languages.push_back(LanguageType::ENGLISH);
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("语言设置的构造函数出错!");
}

LanguageSetting::LanguageSetting(QGuiApplication &app,
                                 QQmlApplicationEngine &engine,
                                 QTranslator &translator)
{
    try
    {
        this->m_pApp = &app;
        this->m_pEngine = &engine;
        this->m_pTranslator = &translator;
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("语言设置的构造函数出错!");
}

LanguageSetting::~LanguageSetting()
{
    try
    {
        delete this->m_pApp;
        this->m_pApp = nullptr;
        delete this->m_pEngine;
        this->m_pEngine = nullptr;
        delete this->m_pTranslator;
        this->m_pTranslator = nullptr;
    }
    catch(...)
    {
        delete this->m_pApp;
        this->m_pApp = nullptr;
        delete this->m_pEngine;
        this->m_pEngine = nullptr;
        delete this->m_pTranslator;
        this->m_pTranslator = nullptr;
    }
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
        this->m_pApp->installTranslator(this->m_pTranslator);
        this->m_pEngine->retranslate();
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("设置语言时出错!");
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
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("从qml设置数据到C++部分出错!");
}

int LanguageSetting::laguageIndex() const
{
    return this->m_laguageIndex;
}

void LanguageSetting::setLaguageIndex(int laguageIndex)
{
    this->m_laguageIndex = laguageIndex;
}
