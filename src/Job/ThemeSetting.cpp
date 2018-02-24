#include "ThemeSetting.hpp"

using namespace std;

using namespace Job;
using namespace SSDK;

ThemeSetting::ThemeSetting(QObject *parent):QObject(parent)
{
    try
    {
        this->m_themeIndex = 0; //默认为light主题
        this->m_themeList = QEnumStringList<ThemeSetting>(string("ThemeType"));
        int cnt = m_themeList.count();
        for (int i = 0; i < cnt ; ++i)
        {
            this->m_backgroundColorList.push_back(QColor());
            this->m_foregroundColorList.push_back(QColor());
            this->m_primaryColorList.push_back(QColor());
            this->m_accentColorList.push_back(QColor());
        }

        //自定义初始值
        this->m_backgroundColorList[(int)ThemeType::CUSTOM] = QColor("#EEEEEE");
        this->m_foregroundColorList[(int)ThemeType::CUSTOM] = QColor("#000000");
        this->m_primaryColorList[(int)ThemeType::CUSTOM] = QColor("#9C27B0");
        this->m_accentColorList[(int)ThemeType::CUSTOM] = QColor("#00BCD4");
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("主题设置的构造函数出错")
}

ThemeSetting::~ThemeSetting()
{

}

void ThemeSetting::setThemeColor(int themeIndex, ColorType colorType, QColor color)
{
    try
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
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("设置主题颜色时出错")
}

QColor ThemeSetting::getThemeColor(int themeIndex, ColorType colorType)
{
    try
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
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("获取主题颜色时出错")
}

QStringList ThemeSetting::themeList()
{
    if(0 == this->m_themeList.count())
    {
        this->m_themeList = QEnumStringList<ThemeSetting>(string("ThemeType"));
    }
    return this->m_themeList;
}

int ThemeSetting::themeIndex() const
{
    return this->m_themeIndex;
}

void ThemeSetting::setThemeIndex(const int themeIndex)
{
    this->m_themeIndex = themeIndex;
}

