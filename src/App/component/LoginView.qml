import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3

import an.qt.LoginCheck 1.0

Item{
    signal login(var user);           // 登录完成
    function openLoginWnd(){
        loginPop.open();
    }

    LoginCheck{
        id: account;                  // 登录账户的用户名及密码检测
    }

    Popup{
        id: loginPop;
        x: -width/2;
        y: -height/2;
        width: 320;
        height: 300;
        focus: true;

        ColumnLayout {
            id: col;
            spacing: 20;
            anchors.centerIn: parent;
            Label {
                elide: Label.ElideMiddle;
                text: qsTr("Please enter the credentials:");
                Layout.fillWidth: true;
            }
            TextField {
                id: userName;
                focus: true;
                placeholderText: qsTr("Username");
                maximumLength: 15;
                Layout.fillWidth: true;
            }
            TextField {
                id: userPasswd;
                placeholderText: qsTr("Password");
                echoMode: TextField.Password;
                maximumLength: 15;
                Layout.fillWidth: true;
            }
            Label{
                id: msg;                    // 登录或注册时的提示信息
                elide:Label.ElideMiddle;
                text: qsTr("");
                Layout.fillWidth: true;
            }

            RowLayout{
                spacing: 50;
                Button{
                    anchors.left: parent.left;
                    text: qsTr("Regist");
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
                    anchors.right: parent.right;
                    text: qsTr("Login");
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
        interval: 50;
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
}







































//Item{
//    signal login();           // 登录完成

//    Dialog {
//        id: inputDialog;
//        x: (parent.width - width) / 2;
//        y: (parent.height - height) / 2;

//        focus: true;
//        modal: true;
//        title: qsTr("Login");
//        standardButtons: Dialog.Cancel | Dialog.Ok;
//        onAccepted: {
//            emit:login();
//        }

//        ColumnLayout {
//            spacing: 20;
//            anchors.fill: parent;
//            Label {
//                elide: Label.ElideRight;
//                text: qsTr("Please enter the credentials:");
//                Layout.fillWidth: true;
//            }
//            TextField {
//                focus: true;
//                placeholderText: qsTr("Username");
//                maximumLength: 15;
//                Layout.fillWidth: true;
//            }
//            TextField {
//                placeholderText: qsTr("Password");
//                echoMode: TextField.Password;
//                maximumLength: 15;
//                Layout.fillWidth: true;
//            }
//        }
//        Button{
//            id: btnLogin;
//            anchors.bottom: parent.bottom;
//            anchors.right:parent.right;
//            anchors.margins: 4;
//            text: qsTr("Login");
//            font.capitalization: Font.MixedCase;
//        }
//        Button{
//            id: btnRegist;
//            anchors.bottom: parent.bottom;
//            anchors.left: parent.left;
//            anchors.margins: 4;
//            text: qsTr("Regist");
//            font.capitalization: Font.MixedCase;
//        }
//    }
//    Component.onCompleted: inputDialog.open();
//}
