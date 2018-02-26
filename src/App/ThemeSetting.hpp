#ifndef THEMESETTING_HPP
#define THEMESETTING_HPP

#include <QObject>
#include <QColor>
#include <QString>

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
     *                2018-2-27 peter
     *                修改c++绑定枚举
     */
    class ThemeSetting : public QObject
    {
        Q_OBJECT
        Q_ENUMS(ColorType)

        Q_PROPERTY(int themeIndex READ themeIndex WRITE setThemeIndex NOTIFY themeIndexChanged)

    public:

        SEnum(
            ThemeType,      // 主题类型
            LIGHT,          // 白色
            DARK,           // 黑色
            CUSTOM          // 自定义
        );

        enum class ColorType
        {
            PRIMARY,        // 原色
            ACCENT,         // 强调色
            FORGROUND,      // 前景色
            BACKGROUND      // 背景色
        };

        ThemeSetting(QObject* parent = 0);
        virtual ~ThemeSetting();

        Q_INVOKABLE QStringList themeTypeList() const;
        Q_INVOKABLE QColor color(ColorType colorType);

        void init();
        ThemeSetting::ThemeType themeType() const;

        int themeIndex() const;
        void setThemeIndex(const int themeIndex);

    signals:
        void themeIndexChanged(int selectedIndex);

    private:
        int m_themeIndex {0};        // 这里为了方便和界面进行绑定，都使用Index进行定位
        QList<QColor> m_primaryColorList;    // 存放所有主题的原色
        QList<QColor> m_accentColorList;     // 存放所有主题的强调色
        QList<QColor> m_foregroundColorList; // 存放所有主题的前景色
        QList<QColor> m_backgroundColorList; // 存放所有主题的背景色
    };
}//End of namespace App

#endif // THEMESETTING_HPP
