#ifndef CUSTOMEXCEPTION_HPP
#define CUSTOMEXCEPTION_HPP

#include <sstream>
#include <iostream>

namespace SSDK
{
    /**
     *  @brief   追加异常信息并抛出异常
     *  @param   原来的异常信息
     *  @return  N/A
     */
    #define THROW_EXCEPTION(exMsg)\
    {\
        std::ostringstream message;\
        message << "File:"<<__FILE__<<"\n"\
                << "Line:"<<__LINE__<<"\n"\
                << "Func:"<<__FUNCTION__<<"\n"\
                << "Detail:"<<exMsg<<"\n";\
        std::string msg = message.str();\
        throw SSDK::CustomException(msg);\
    }

    #define CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ(appendedMsg)\
    catch (SSDK::CustomException& ex )\
    {\
        std::ostringstream message;\
        message << "File:"<<__FILE__<<"\n"\
                << "Line:"<<__LINE__<<"\n"\
                << "Func:"<<__FUNCTION__<<"\n"\
                << "Detail:"<<appendedMsg<<"\n" "\n"\
                << ex.what() <<"\n";\
        std::string msg = message.str();\
        throw SSDK::CustomException(msg);\
    }
    #define CATCH_AND_PRINT_EXCEPTION()\
    catch( SSDK::CustomException& ex )\
    {\
        std::cout << ex.what() << std::endl;\
    }
    /**
     *  @brief 自定义异常类
     *
     *  @author peter
     *  @version 1.00 2018-01-05 peter
     *                note:create it
     */
    class CustomException : public std::exception
    {
    public:

        //>>>-------------------------------------------------------------------
        // constructor & destructor

        /**
         *  @brief   将作为参数的异常信息存到成员变量
         *  @param   N/A
         *  @return  异常信息
         */
        explicit CustomException(std::string & message);

        virtual~CustomException();

        //>>>-------------------------------------------------------------------
        // set & get function

        /**
         *  @brief   获取异常信息
         *  @param   N/A
         *  @return  返回存储的异常信息
         */
        virtual const char * what() const _GLIBCXX_USE_NOEXCEPT override
        {
            return m_originalMsg.data();
        }


    private :

        //>>>-------------------------------------------------------------------
        // member variant

        std::string m_originalMsg{"\0"};  //异常信息

        //<<<-------------------------------------------------------------------
    };
}//End of namespace SSDK

#endif // CUSTOMEXCEPTION_HPP
