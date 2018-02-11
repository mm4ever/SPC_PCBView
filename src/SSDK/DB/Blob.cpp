#include "Blob.hpp"

using namespace SSDK::DB;

Blob::Blob(const char* pSrc)
{
    if(nullptr!=pSrc)
    {
        int cnt = strlen(pSrc)+1;
        this->m_pBuf = new char[cnt];
        strcpy(this->m_pBuf,pSrc);
    }
}

Blob::Blob(const std::string& src)
{
    Blob(src.data());
}

Blob::Blob(const Blob &blob)
{
    auto pBuf = blob.buf();

    if(nullptr!=pBuf)
    {
        int cnt = strlen(pBuf)+1;
        this->m_pBuf = new char[cnt];
        strcpy(this->m_pBuf,pBuf);

    }
}

Blob::~Blob()
{
    if(this->m_pBuf!= nullptr)
    {
        delete[] this->m_pBuf;
    }
}
