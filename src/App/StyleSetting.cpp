#include "StyleSetting.hpp"

using namespace SSDK;

StyleSetting::StyleSetting(QObject *parent):QObject(parent)
{
    this->m_themeIndex = 0; //默认为light主题
    this->m_themeList = QEnumStringList<StyleSetting>(std::string("ThemeType"));
    int cnt = m_themeList.count();
    for (int i = 0; i < cnt ; ++i)
    {
        this->m_backgroundColorList.push_back(QColor());
        this->m_foregroundColorList.push_back(QColor());
        this->m_primaryColorList.push_back(QColor());
        this->m_accentColorList.push_back(QColor());
    }

    //自定义初始值
    this->m_backgroundColorList[(int)ThemeType::USER_DEFINED] = QColor("#E0FFFF");
    this->m_foregroundColorList[(int)ThemeType::USER_DEFINED] = QColor("#CCE5FF");
    this->m_primaryColorList[(int)ThemeType::USER_DEFINED] = QColor("#20B2AA");
    this->m_accentColorList[(int)ThemeType::USER_DEFINED] = QColor("#994C00");
}
StyleSetting::~StyleSetting()
{

}

void StyleSetting::setThemeColor(int themeIndex, ColorType colorType, QColor color)
{
    if( themeIndex > -1 && themeIndex < this->m_themeList.count())
    {
        switch (colorType)
        {
        case ColorType::ACCENT:
            this->m_accentColorList[themeIndex] = color;
            break;

        case ColorType::BACKGROUND:
            this->m_backgroundColorList[themeIndex] = color;
            break;

        case ColorType::FORGROUND:
            this->m_foregroundColorList[themeIndex] = color;
            break;

        case ColorType::PRIMARY:
            this->m_primaryColorList[themeIndex]= color;
            break;

        default:
            break;
        }
    }
}

QColor StyleSetting::getThemeColor(int themeIndex , ColorType colorType)
{
    if( themeIndex > -1 && themeIndex < this->m_themeList.count())
    {
        switch (colorType)
        {
        case ColorType::ACCENT:
            return this->m_accentColorList.at(themeIndex);

        case ColorType::BACKGROUND:
            return this->m_backgroundColorList.at(themeIndex);

        case ColorType::FORGROUND:
            return this->m_foregroundColorList.at(themeIndex);

        case ColorType::PRIMARY:
            return this->m_primaryColorList.at(themeIndex);

        default:
            break;
        }
    }
}


QStringList StyleSetting::themeList()
{
    if(0 == this->m_themeList.count())
    {
        this->m_themeList = QEnumStringList<StyleSetting>(std::string("ThemeType"));
    }

    return this->m_themeList;
}


int StyleSetting::themeIndex() const
{
    return this->m_themeIndex;
}

void StyleSetting::setThemeIndex(const int themeIndex)
{
    this->m_themeIndex = themeIndex;
}
