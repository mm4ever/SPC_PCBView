import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import an.qt.LoginCheck 1.0

Item{
    signal login(var user);           // 登录完成

    LoginCheck{
        id: account;                  // 登录账户的用户名及密码检测
    }

    Popup{
        id: loginPop;
        x: -width/2;
        y: -height/2;
        width: 300;
        height: 320;
        focus: true;
        modal: true;
        closePolicy: Popup.CloseOnEscape;


        ColumnLayout {
            id: col;
            spacing: 20;
            anchors.centerIn: parent;

            Label {
                elide: Label.ElideMiddle;
                text: qsTr("Please enter the credentials:");
                font.pointSize: 14;
                Layout.fillWidth: true;
            }
            TextField {
                id: userName;
                focus: true;
                placeholderText: qsTr("Username");
                font.pointSize: 12;
                maximumLength: 8;
                Layout.fillWidth: true;
            }
            TextField {
                id: userPasswd;
                placeholderText: qsTr("Password");
                font.pointSize: 12;
                echoMode: TextField.Password;
                maximumLength: 8;
                Layout.fillWidth: true;
            }
            Label{
                id: msg;                    // 登录或注册时的提示信息
                elide:Label.ElideMiddle;
                text: qsTr("");
                Layout.fillWidth: true;
            }

            RowLayout{
                spacing: 60;
                Layout.alignment: Qt.AlignCenter
                Button{
                    text: qsTr("Register");
                    font.pointSize: 12;
                    font.capitalization: Font.MixedCase;

                    onClicked: {
                        if(userName.text === "" || userPasswd.text === ""){
                            msg.text = qsTr("Input is empty!");
                        }
                        else{
                            account.user = userName.text;
                            account.passwd = userPasswd.text;
                            account.registerAccount();
                        }
                    }
                }
                Button{
                    text: qsTr("Login");
                    font.pointSize: 12;
                    font.capitalization: Font.MixedCase;

                    onClicked: {
                        if(userName.text === "" || userPasswd.text === ""){
                            msg.text = qsTr("Input is empty!");
                        }
                        else{
                            account.user = userName.text;
                            account.passwd = userPasswd.text;
                            msg.text = qsTr("Username or Passwd error!");
                            account.loginAccount();
                        }
                    }
                }
            }
        }
    }
    Component.onCompleted: loginPop.open();

    Connections{
        target: account;
        onRegisterSuccess:{
            msg.text = qsTr("Register success!");
            timer.running = true;
        }
    }
    Connections{
        target: account;
        onLoginSuccess:{
            msg.text = qsTr("Login success!");
            timer.running = true;
        }
    }
    Timer{
        id: timer;
        repeat: true;
        interval: 25;
        triggeredOnStart: true;
        property int cnt: 0;
        onTriggered:{
            if ( timer.cnt === 20 ){
                timer.running = false;
                msg.text = qsTr(" ");
                timer.cnt = 0;                // 重新置为0,下次注册或登录时关闭任然有效
                emit:login(account.user);     // 登录或注册成功
                loginPop.close();
            }
            timer.cnt++;
        }
    }

    function openLoginWnd(){
        loginPop.open();
    }
}
