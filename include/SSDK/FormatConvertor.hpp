#ifndef FORMATCONVERTION_HPP
#define FORMATCONVERTION_HPP

#include <iostream>
#include <string>
#include <sstream>

#include "CustomException.hpp"

using namespace std;

namespace SSDK
{

    //>>>-----------------------------------------------------------------------
    // define function

    //宏函数,取出枚举类型中的元素
    #define VAR_TO_STR(var)\
        ({\
            std::string name = (#var);\
            int pos = 0;\
            int length = 0;\
            length = name.length();\
            pos = name.find_last_of(':',length);\
            if ( pos == -1 )\
            {\
                pos = 0;\
                name = name.substr(pos,length);\
            }\
            else\
            {\
                name = name.substr(pos + 1,length);\
            }\
            (name);\
        })

    /**
     *  @brief  FormatConvertion
     *          将整形(int)数字转为为字符串形(string)
     *  @author peter
     *  @version 1.00 2018-01-05 peter
     *                note:create it
     */
    class FormatConvertion
    {
    public:

        //>>>-------------------------------------------------------------------
        // constructor & destructor

        FormatConvertion();

        virtual~FormatConvertion();

        //>>>-------------------------------------------------------------------
        // member function

        /**
         *  @brief  intToString
         *          将整形数字转换为字符串
         *  @param  value: 整形变量,即需要转换成字符串的整形变量
         *  @return 将整形数字转换后的字符传返回
         */
        static std::string intToString(int value);

        //<<<-------------------------------------------------------------------
    };
}   //End of namespace SSDK

#endif // FORMATCONVERTION_HPP
