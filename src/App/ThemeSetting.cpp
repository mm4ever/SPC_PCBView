#include "ThemeSetting.hpp"

using namespace std;

using namespace App;
using namespace SSDK;

ThemeSetting::ThemeSetting(QObject *parent):QObject(parent)
{
    this->init();
}

ThemeSetting::~ThemeSetting()
{

}

void ThemeSetting::init()
{
    try
    {
        int cnt = themeTypeList().count();
        for (int i = 0; i < cnt ; ++i)
        {
            this->m_primaryColorList.push_back(QColor());
            this->m_accentColorList.push_back(QColor());
            this->m_foregroundColorList.push_back(QColor());
            this->m_backgroundColorList.push_back(QColor());
        }

        // Material.Light
        this->m_primaryColorList[(int)ThemeType::LIGHT] = QColor("#3f51b5");
        this->m_accentColorList[(int)ThemeType::LIGHT] = QColor("#e91e63");
        this->m_foregroundColorList[(int)ThemeType::LIGHT] = QColor("#000000");
        this->m_backgroundColorList[(int)ThemeType::LIGHT] = QColor("#fafafa");

        // Material.Dark
        this->m_primaryColorList[(int)ThemeType::DARK] = QColor("#3f51b5");
        this->m_accentColorList[(int)ThemeType::DARK] = QColor("#f48fb1");
        this->m_foregroundColorList[(int)ThemeType::DARK] = QColor("#ffffff");
        this->m_backgroundColorList[(int)ThemeType::DARK] = QColor("#303030");

        // Material.Dark
        this->m_primaryColorList[(int)ThemeType::CUSTOM] = QColor("#9C27B0");
        this->m_accentColorList[(int)ThemeType::CUSTOM] = QColor("#00BCD4");
        this->m_foregroundColorList[(int)ThemeType::CUSTOM] = QColor("#000000");
        this->m_backgroundColorList[(int)ThemeType::CUSTOM] = QColor("#EEEEEE");
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("Init theme error!")
}

QStringList ThemeSetting::themeTypeList() const
{
    //只会初始化一次
    static QStringList themeTypeList;
    if( 0 == themeTypeList.count() )
    {
        themeTypeList = ThemeType::getQStringList();
    }
    return themeTypeList;
}

ThemeSetting::ThemeType ThemeSetting::themeType() const
{
    //基于SEnum
    QString key = themeTypeList().at(m_themeIndex);
    return ThemeType::fromString(key.toStdString());
}


int ThemeSetting::themeIndex() const
{
    return this->m_themeIndex;
}

void ThemeSetting::setThemeIndex(const int themeIndex)
{
    if( themeIndex != this->m_themeIndex )
    {
        this->m_themeIndex = themeIndex;
        emit themeIndexChanged(m_themeIndex);
    }
}

QColor ThemeSetting::color(ColorType colorType)
{
    try
    {
        if( m_themeIndex > -1 &&
            m_themeIndex < themeTypeList().count() )
        {
            switch (colorType)
            {
            case ColorType::ACCENT:
                return this->m_accentColorList.at(m_themeIndex);

            case ColorType::BACKGROUND:
                return this->m_backgroundColorList.at(m_themeIndex);

            case ColorType::FORGROUND:
                return this->m_foregroundColorList.at(m_themeIndex);

            case ColorType::PRIMARY:
                return this->m_primaryColorList.at(m_themeIndex);

            default:
                break;
            }
        }
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("Change theme error!")
}

