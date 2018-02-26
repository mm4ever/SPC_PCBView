#ifndef BLOB_HPP
#define BLOB_HPP

#include  <string>
#include <string.h>
#include <memory>

namespace SSDK
{
    namespace DB
    {
         /**
         *  @brief 代表了数据库中存储的二进制对象
         *
         *  @author rime
         *  @version 1.00 2017-05-10 author
         *                note:create it
         */
        struct Blob
        {
        public:
            Blob(const char* pSrc);
            Blob(const std::string& src);
            Blob(const Blob& blob);
            ~Blob();

            const char* buf()const{return this->m_pBuf;}
            int size()const{return strlen(this->m_pBuf)+1;}

            std::string toString()const{ return std::string(m_pBuf);}

        private:
            char* m_pBuf;
        };//End of Blob
    }//End of namespace DB
}//End of namespace SSDK

#endif // BLOB_HPP
