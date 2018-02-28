#ifndef THEMESETTING_HPP
#define THEMESETTING_HPP

#include <QObject>
#include <QColor>
#include <QString>
#include <QSettings>
#include <QFile>

#include "MetaEnum.hpp"
#include "CustomException.hpp"

namespace App
{
    /**
     *  @brief 这个类可以实现程序在运行期间的主题切换已经颜色配置，具体要配置qml界面使用
     *
     *  @author grace
     *  @version 1.00 2018-2-20 grace
     *                note:create it
     */
    class ThemeSetting : public QObject
    {
        Q_OBJECT

        Q_ENUMS(ThemeType)
        Q_PROPERTY(int themeIndex READ themeIndex WRITE setThemeIndex NOTIFY themeIndexChanged)


    public:

        enum class ThemeType // 主题类型
        {
            LIGHT,           // 白色
            DARK,            // 黑色
            CUSTOM           // 自定义
        };
        Q_ENUM(ThemeType)

        enum class ColorType // 颜色类型
        {
            PRIMARY,         // 原色
            ACCENT,          // 强调色
            FORGROUND,       // 前景色
            BACKGROUND       // 背景色
        };

        ThemeSetting(QObject* parent = 0);
        virtual ~ThemeSetting();

        Q_INVOKABLE QColor getAccent(const int themeIndex);
        Q_INVOKABLE QColor getForeground(const int themeIndex);
        Q_INVOKABLE QColor getBackground(const int themeIndex);
        Q_INVOKABLE QColor getPrimary(const int themeIndex);
        Q_INVOKABLE QStringList themeTypeList() const;

        int themeIndex() const;
        void setThemeIndex(const int themeIndex);

        /**
         * @brief readConfiguration：读配置文件，没有生成默认配置文件
         * @param path：配置文件所在路径
         */
        void readConfiguration(const QString& path);

        /**
         * @brief writeConfiguration：写配置文件
         * @param path：配置文件所在路径
         */
        void writeConfiguration(const QString& path);


    signals:
        void themeIndexChanged(const int themeIndex);


    private:
        int m_themeIndex; // 这里为了方便和界面进行绑定，都使用Index进行定位
        QList<QColor> m_primaryColorList;    // 存放所有主题的原色
        QList<QColor> m_accentColorList;     // 存放所有主题的强调色
        QList<QColor> m_foregroundColorList; // 存放所有主题的前景色
        QList<QColor> m_backgroundColorList; // 存放所有主题的背景色
        QString m_settingPath;               // 跟主题相关配置文件所在路径
    };
}//End of namespace Job

#endif // THEMESETTING_HPP
