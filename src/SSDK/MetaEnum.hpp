#ifndef ENUMHELPER_H
#define ENUMHELPER_H

#include <string>
#include <sstream>

#include <QMetaEnum>

namespace SSDK
{
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
\
        \
                private:\
                    int m_value;\
                }\

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
                template<typename ClassType>
                const QStringList QEnumStringList(std::string enumTypeName)
                {
                    auto list = QStringList();

                    auto meta = ClassType::staticMetaObject;
                    for (int i=0; i < meta.enumeratorCount(); ++i)
                    {
                        QMetaEnum m  =meta.enumerator(i);
                        if(std::string(m.name()) == enumTypeName)
                        {
                            for(int j=0; j <m.keyCount(); ++j)
                            {
                                list.push_back(QObject::tr(m.key(j)).left(1) +
                                               QObject::tr(m.key(j)).right(QObject::tr(m.key(j)).length() - 1).toLower());
                            }

                            return list;
                        }
                    }
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
                template<typename ClassType>
                void setQEnumStringMap(QVariantMap* pEumStringMap,std::string enumTypeName)
                {
                    if(nullptr==pEumStringMap)
                        return;

                    auto meta = ClassType::staticMetaObject;
                    for (int i=0; i < meta.enumeratorCount(); ++i)
                    {
                        QMetaEnum m  =meta.enumerator(i);
                        if(std::string(m.name()) == enumTypeName)
                        {
                            for(int j=0; j <m.keyCount(); ++j)
                            {
                                pEumStringMap->insert(QString(m.key(j)),m.value(j));
                            }

                            return;
                        }
                    }
                }
    }//End of namespace SSDK

//#include "Core/enumhelper.hpp.inl"

#endif // ENUMHELPER_H
