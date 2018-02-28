#include "LanguageSetting.hpp"

using namespace std;

using namespace App;
using namespace SSDK;

LanguageSetting::LanguageSetting(QObject *parent) : QObject(parent),
    m_laguageIndex(1)
{

}

LanguageSetting::~LanguageSetting()
{

}

int LanguageSetting::laguageIndex() const
{
    return this->m_laguageIndex;
}

void LanguageSetting::setLaguageIndex(int laguageIndex)
{
    if(this->m_laguageIndex != laguageIndex)
    {
        this->m_laguageIndex = laguageIndex;
        emit laguageIndexChanged(this->m_laguageIndex);
    }
}
void LanguageSetting::setPEngine(QQmlApplicationEngine *pEngine)
{
    this->m_pEngine = pEngine;
}

void LanguageSetting::setPTranslator(QTranslator *pTranslator)
{
    this->m_pTranslator = pTranslator;
}

QStringList LanguageSetting::languageTypeList() const
{
    static QStringList languageTypeList;
    if( 0==languageTypeList.count() )
    {
        languageTypeList = getStringListFromQEnum<LanguageType>();
    }
    return languageTypeList;
}


void LanguageSetting::languageUpdate()
{
    if(nullptr != this->m_pTranslator && nullptr != this->m_pEngine)
    {
        this->m_pTranslator->load(this->m_filesPathArr[this->m_laguageIndex]);
        this->m_pEngine->retranslate();
    }
    else
    {
        THROW_EXCEPTION("Translator Or Engine is null");
    }
}
