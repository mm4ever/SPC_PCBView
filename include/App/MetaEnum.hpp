#ifndef ENUMHELPER_H
#define ENUMHELPER_H

#include <string>
#include <sstream>

#include <QMetaEnum>

namespace SSDK
{
            //>>>----------------------------------------------------------------------------------------------------------
            //1. 如果不基于QEnum，想要实现枚举的反射机制，可以使用SEnum

            //用法举例
            //SEnum(HandlerType,
            //      AI_Response = 0,//detail hander function, it is designed by user
            //      Retry,//do again
            //      Ignore,//ignore and go on
            //      Abort,//stop and exit
            //      );//exit,usually use in show msg only

            /**
             * @brief
             * Because c++ enumeration is does not support the reflection.
             * the macro is used in reflection, is mainly responsible for:
             *      1.the definition of enumeration and
             *      2.the convertion with string and
             *      3.the convertion to map of string and
             *      4.get number of enumeration
             *
             *  @author rime
             *  @version 1.00 2017-04-03 rime
             *                note:create it
            */
            #define SEnum(EnumName, ...)\
            class EnumName/*eg: SEnum(HandlerType,retry = 0,redo = 1,abort = 2) */ \
            {\
            public:\
             \
                class Exception : public std::exception {};\
                \
                \
                enum{__VA_ARGS__};\
                EnumName():m_value(0){}\
                EnumName(int value):m_value(value){}\
            \
                operator int() const{return m_value;}\
                bool operator<(const EnumName value){return (int)*this < (int)value;} \
                \
                int count(){return getMap().size();}\
                static std::map<int, std::string> getMap()                     \
                {                                                               \
                     using namespace std;  \
                    \
                     static map<int, string> tmp; \
                    if(tmp.size() != 0)\
                    {\
                        return tmp;\
                    }\
                    else\
                    {\
                         int val = 0;                                                \
                         string buf_1, buf_2, str = #__VA_ARGS__;                    \
                         replace(str.begin(), str.end(), '=', ' ');                  \
                         stringstream stream(str);                                   \
                         vector<string> strings;                                     \
                         while (getline(stream, buf_1, ','))                         \
                             strings.push_back(buf_1);                               \
                                          \
                         for(vector<string>::iterator it = strings.begin();          \
                                                                it != strings.end(); \
                                                                ++it)                \
                         {                                                           \
                             buf_1.clear(); buf_2.clear();                           \
                             stringstream localStream(*it);                          \
                             localStream>> buf_1 >> buf_2;                           \
                             if(buf_2.size() > 0)                                    \
                                 val = atoi(buf_2.c_str());                          \
                             tmp[val++] = buf_1;                                     \
                         } \
                    }\
                                                                                  \
                     return tmp;                                                 \
                }\
\
                std::string toString(void)const\
                {\
                    return toString(m_value);\
                }\
                static std::string toString(int enumValue)\
                {\
                    return getMap()[enumValue];\
                }\
                static EnumName fromString(const std::string& str)\
                {\
                    auto it = find_if(getMap().begin(),getMap().end(),[str](const std::pair<int,std::string>& p)\
                                                                            {\
                                                                                return p.second == str;\
                                                                            });\
                    if(it == getMap().end())\
                    {\
                        /*value not found*/                                         \
                        throw EnumName::Exception();  \
                    }\
                    else\
                    {\
                        return (EnumName)(it->first);\
                    }\
                }\
                \
                static  QList<QString> getQStringList()\
                {\
                    using namespace std;\
            \
                    static QList<QString> tmp;\
                   if(tmp.count() != 0)\
                   {\
                       return tmp;\
                   }\
                   else\
                   {\
                        string buf_1, buf_2, str = #__VA_ARGS__;\
                        replace(str.begin(), str.end(), '=', ' ');\
                        stringstream stream(str);\
                        vector<string> strings;\
                        while (getline(stream, buf_1, ','))\
                            strings.push_back(buf_1);\
            \
                        for(vector<string>::iterator it = strings.begin();\
                                                               it != strings.end();\
                                                               ++it)\
                        {\
                            buf_1.clear(); buf_2.clear();\
                            stringstream localStream(*it);\
                            localStream>> buf_1 >> buf_2;\
                            tmp.push_back(QString::fromStdString(buf_1));\
                        }\
                   }\
            \
                    return tmp;\
                }\
                \
                private:\
                    int m_value;\
                }\
                \

                //>>>----------------------------------------------------------------------------------------------------------
                //2. 基于QEnum，可以直接基于元系统实现反射

                /**
                 *  @brief
                 *       convert QEnum to QList of QString
                 *
                 *  @tparam :
                 *       ClassType: type of class which contains QEnum
                 *  @param :
                 *       enumTypeName: String of QEnum
                 *
                 *  @return
                 *       QList of QString represented QEnum.
                 *
                 * eg:
                 *      Q_ENUMS(LangType)
                 *      enum LangType
                 *      {
                 *          CN,
                 *          EN,
                 *          UN
                 *      };
                 *
                 * return QList<QString>(){"CN","EN","UN"}
                 */
                template<typename QEnumType>
                const QList<QString> getStringListFromQEnum()
                {
                    auto list = QList<QString>();

                    auto meta = QMetaEnum::fromType<QEnumType>();
                    for(int i=0; i <meta.keyCount(); ++i)
                    {
                        list.push_back(QObject::tr(meta.key(i)));
                    }

                    return list;
                }

                /**
                 *  @brief
                 *       convert QEnum to QMap of QString
                 *
                 *  @tparam :
                 *       ClassType: type of class which contains QEnum
                 *  @param :
                 *       enumTypeName: String of QEnum
                 * pEumStringMap
                 *
                 *  @return
                 *       QList of QString represented QEnum.
                 *
                 * eg:
                 *      Q_ENUMS(LangType)
                 *      enum LangType
                 *      {
                 *          CN,
                 *          EN,
                 *          UN
                 *      };
                 *
                 * return QMap<QString, QVariant>()
                 * {
                 *      {"CN",(int)LangType::CN},
                 *      {"EN",(int)LangType::EN},
                 *      {"UN",(int)LangType::UN}
                 * }
                 */
                template<typename QEnumType>
                const QVariantMap getMapFromQEnum()
                {
                    auto map = QVariantMap();

                    auto meta = QMetaEnum::fromType<QEnumType>();
                    for(int i=0; i <meta.keyCount(); ++i)
                    {
                        map.insert(QString(meta.key(i)),meta.value(i));
                    }

                    return map;
                }

                /**
                 * @brief getQEnumValFromKey
                 *              由一个注册为QEnum的枚举的字符串得到相应的值
                 * @param key
                 *              注册为QEnum的枚举的字符串
                 * @return
                 *
                 * 注意：
                 *      1.一定要使用QEnum才能得到正确的结果，使用QEnums会转换失败
                 *          如：
                 *                 enum class FilterType
                                    {
                                        BLUR,
                                        GAUSSIAN,
                                        MEDIAN,
                                        BILATERAL
                                    };
                                    Q_ENUM(FilterType)

                         2.一定要为public
                 */
                template<typename EnumType>
                QVariant getQEnumValFromKey(const std::string& key)
                {
                   auto meta = QMetaEnum::fromType<EnumType>();
                   return meta.keysToValue(key.data());
                }

                /**
                 * @brief getQEnumKeyFromVal
                 *              由一个注册为QEnum的枚举的值得到相应的字符串
                 * @param value
                 *              注册为QEnum的枚举的字符串
                 * @return
                 */
                template<typename EnumType>
                std::string getQEnumKeyFromVal(int value)
                {
                   auto meta = QMetaEnum::fromType<EnumType>();
                   return std::string(meta.valueToKey(value));
                }

    }//End of namespace SSDK

//#include "Core/enumhelper.hpp.inl"

#endif // ENUMHELPER_H
