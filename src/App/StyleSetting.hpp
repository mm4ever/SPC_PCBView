#ifndef STYLESETTING_HPP
#define STYLESETTING_HPP

#include <QObject>
#include <QColor>
#include <QString>
#include <QMetaEnum>

#include "metaeeum.hpp"

/**
 *  @brief 这个类可以实现程序在运行期间的主题切换已经颜色配置，具体要配置qml界面使用
 *
 *  @author grace
 *  @version 1.00 2018-2-20 grace
 *                note:create it
 */
class StyleSetting: public QObject
{
    Q_OBJECT

    Q_ENUMS(ThemeType)
    Q_ENUMS(ColorType)
    Q_PROPERTY(int themeIndex READ themeIndex  WRITE setThemeIndex)
    Q_PROPERTY(QStringList themeList READ themeList )


public:

    enum class ThemeType //主题类型
    {
        LIGHT, //白色
        DARK, //黑色
        USER_DEFINED //自定义
    };

    enum class ColorType //颜色类型
    {
        PRIMARY, //原色
        ACCENT, //强调色
        FORGROUND, //前景色
        BACKGROUND //背景色
    };

    StyleSetting(QObject* parent = 0);
    ~StyleSetting();

    Q_INVOKABLE void setThemeColor (int themeIndex,ColorType colorType,QColor color);
    Q_INVOKABLE QColor getThemeColor (int themeIndex, ColorType colorType);

    QStringList themeList ();

    ThemeType theme() const;
    void setTheme(const ThemeType &theme);

    int themeIndex() const;
    void setThemeIndex(const int themeIndex);


private:
    int m_themeIndex;  // 这里为了方便和界面进行绑定，都使用Index进行定位

    // 和Combobox进行绑定，把QEnum转换为StringList再做处理
    QStringList m_themeList;             // 存放所有主题类型
    QList<QColor> m_primaryColorList;    // 存放所有主题的原色
    QList<QColor> m_accentColorList;     // 存放所有主题的强调色
    QList<QColor> m_foregroundColorList; // 存放所有主题的前景色
    QList<QColor> m_backgroundColorList; //存放所有主题的背景色
};

#endif // STYLESETTING_HPP
