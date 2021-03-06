#ifndef LOGINCHECK_HPP
#define LOGINCHECK_HPP

#include <string>
#include <cstring>

#include <QObject>
#include <QString>
#include <QSettings>

#include "CustomException.hpp"

namespace App
{
    class LoginCheck : public QObject
    {
        Q_OBJECT

        Q_PROPERTY(QString user READ user WRITE setUser)
        Q_PROPERTY(QString passwd READ passwd WRITE setPasswd)

    public:
        explicit LoginCheck(QObject *parent = nullptr);
        virtual~LoginCheck();

        Q_INVOKABLE void loginAccount();
        Q_INVOKABLE void registerAccount();

        QString user() const;
        void setUser( const QString& user );
        QString passwd() const;
        void setPasswd( const QString& passwd);

    signals:
        void loginSuccess();
        void registerSuccess();
    private:
        QString m_path {"./config/UserAccount.ini"};
        QString m_currentUser {"peter"};
        QString m_currentPasswd {"123"};

    };
} // End of namespace App
#endif // LOGINCHECK_HPP
