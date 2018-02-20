#include "LoginCheck.hpp"

using namespace std;

using namespace Job;

LoginCheck::LoginCheck(QObject *parent) : QObject(parent)
{
    try
    {
        registerAccount();
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("Constructor error!");

}

LoginCheck::~LoginCheck()
{
    try
    {

    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("Destructor error!");
}

void LoginCheck::loginAccount()
{
    try
    {
        QSettings config(m_path,QSettings::IniFormat);
        auto currentUser = config.value(m_currentUser).toInt();
        if( 0 != currentUser )
        {
            auto rightPasswd = config.value(m_currentUser).toString();
            if( m_currentPasswd == rightPasswd ){
                emit loginSuccess();
            }
        }
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("Login account error!")
}

void LoginCheck::registerAccount()
{
    try
    {
        QSettings config( m_path,QSettings::IniFormat);
        config.setValue( m_currentUser,m_currentPasswd );
        emit registerSuccess();
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("Register account error!")
}

QString LoginCheck::user() const
{
    return this->m_currentUser;
}

void LoginCheck::setUser(const QString &user)
{
    this->m_currentUser = user;
}

QString LoginCheck::passwd() const
{
    return this->m_currentPasswd;
}

void LoginCheck::setPasswd(const QString &passwd)
{
    this->m_currentPasswd = passwd;
}
