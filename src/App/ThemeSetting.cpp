#include "ThemeSetting.hpp"

using namespace std;

using namespace App;
using namespace SSDK;


ThemeSetting::ThemeSetting(QObject *parent):QObject(parent)
{
    try
    {
        this->m_themeIndex = 0; //默认为light主题
        this->m_settingPath = "./config/ThemeSetting.ini";
        readConfiguration(this->m_settingPath); //读配置文件
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("主题设置的构造函数出错")
}

ThemeSetting::~ThemeSetting()
{

}

QColor ThemeSetting::getAccent(int themeIndex)
{
    return this->m_accentColorList[themeIndex];
}

QColor ThemeSetting::getForeground(int themeIndex)
{
    return this->m_foregroundColorList[themeIndex];
}

QColor ThemeSetting::getBackground(int themeIndex)
{
    return this->m_backgroundColorList[themeIndex];
}

QColor ThemeSetting::getPrimary(int themeIndex)
{
    return this->m_primaryColorList[themeIndex];
}

QStringList ThemeSetting::themeTypeList() const
{
    static QStringList themeTypeList;
    if( 0 == themeTypeList.count() )
    {
        themeTypeList = getStringListFromQEnum<ThemeType>();
    }
    return themeTypeList;
}

int ThemeSetting::themeIndex() const
{
    return this->m_themeIndex;
}

void ThemeSetting::setThemeIndex(const int themeIndex)
{
    //与当前主题不一致时改变主题
    if(this->m_themeIndex != themeIndex)
    {
        this->m_themeIndex = themeIndex;
        emit themeIndexChanged(this->m_themeIndex);
    }
}

void ThemeSetting::readConfiguration(const QString &path)
{
    try
    {
        //判断文件是否存在，不存在生成默认配置文件
        if(!QFile::exists(path))
        {
            cout << "指定目录下没有数据生成相关配置文件,生成默认配置文件" << endl;
            writeConfiguration(path);
            return;
        }
        QSettings settings(path, QSettings::IniFormat);

        //文件存在把主题相关颜色数据存入到相应成员变量中
        int PrimaryTypeCnt = settings.beginReadArray("PRIMARY_COLOR");
        QColor primaryColor;
        for (int i = 0; i < PrimaryTypeCnt; ++i)
        {
            settings.setArrayIndex(i);
            primaryColor = settings.value("PrimaryColor").value<QColor>();
            this->m_primaryColorList.push_back(primaryColor);
        }
        settings.endArray();

        int accentTypeCnt = settings.beginReadArray("ACCENT_COLOR");
        QColor accentColor;
        for (int i = 0; i < accentTypeCnt; ++i)
        {
            settings.setArrayIndex(i);
            accentColor = settings.value("AccentColor").value<QColor>();
            this->m_accentColorList.push_back(accentColor);
        }
        settings.endArray();

        int foregroundTypeCnt = settings.beginReadArray("FOREGROUND_COLOR");
        QColor foregroundColor;
        for (int i = 0; i < foregroundTypeCnt; ++i)
        {
            settings.setArrayIndex(i);
            foregroundColor = settings.value("ForegroundColor").value<QColor>();
            this->m_foregroundColorList.push_back(foregroundColor);
        }
        settings.endArray();

        int backgroundTypeCnt = settings.beginReadArray("BACKGROUND_COLOR");
        QColor backgroundColor;
        for (int i = 0; i < backgroundTypeCnt; ++i)
        {
            settings.setArrayIndex(i);
            backgroundColor = settings.value("BackgroundColor").value<QColor>();
            this->m_backgroundColorList.push_back(backgroundColor);
        }
        settings.endArray();
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("读取主题相关配置文件出错")
}

void ThemeSetting::writeConfiguration(const QString &path)
{
    try
    {
        //主题相关颜色配置都不存在，存入默认颜色配置
        if(0 == this->m_primaryColorList.size() &&
                0 == this->m_accentColorList.size() &&
                0 == this->m_foregroundColorList.size() &&
                0 == this->m_backgroundColorList.size())
        {
            this->m_primaryColorList.push_back("#0069c0");
            this->m_primaryColorList.push_back("#0069c0");
            this->m_primaryColorList.push_back("#9C27B0");

            this->m_accentColorList.push_back("#0069c0");
            this->m_accentColorList.push_back("white");
            this->m_accentColorList.push_back("#9C27B0");

            this->m_foregroundColorList.push_back("black");
            this->m_foregroundColorList.push_back("White");
            this->m_foregroundColorList.push_back("#000000");

            this->m_backgroundColorList.push_back("White");
            this->m_backgroundColorList.push_back("#263238");
            this->m_backgroundColorList.push_back("#EEEEEE");
        }

        //把主题的相关颜色配置写入到配置文件
        QSettings settings(path, QSettings::IniFormat);
        settings.beginWriteArray("PRIMARY_COLOR");
        for (int i = 0; i < this->m_primaryColorList.size(); ++i)
        {
            settings.setArrayIndex(i);
            settings.setValue("PrimaryColor", this->m_primaryColorList[i]);
        }
        settings.endArray();

        settings.beginWriteArray("ACCENT_COLOR");
        for (int i = 0; i < this->m_accentColorList.size(); ++i)
        {
            settings.setArrayIndex(i);
            settings.setValue("AccentColor", this->m_accentColorList.at(i));
        }
        settings.endArray();

        settings.beginWriteArray("FOREGROUND_COLOR");
        for (int i = 0; i < this->m_primaryColorList.size(); ++i)
        {
            settings.setArrayIndex(i);
            settings.setValue("ForegroundColor", this->m_primaryColorList.at(i));
        }
        settings.endArray();

        settings.beginWriteArray("BACKGROUND_COLOR");
        for (int i = 0; i < this->m_primaryColorList.size(); ++i)
        {
            settings.setArrayIndex(i);
            settings.setValue("BackgroundColor", this->m_backgroundColorList[i]);
        }
        settings.endArray();
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("写主题相关配置文件出错")

}

