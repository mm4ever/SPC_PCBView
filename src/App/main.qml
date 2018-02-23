import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Controls.Universal 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtQuick.Dialogs 1.1

import an.qt.CModel 1.0
import an.qt.LanguageSetting 1.0

ApplicationWindow {
    id: appWnd;
    x:(screen.width-width)/2;                   // 将主窗口限定在屏幕中央
    y:(screen.height-height)/2;
    width: 320;
    height: 520;
    visible: true;
    flags: Qt.Window | Qt.FramelessWindowHint   //去标题栏

    Shortcut{
        sequence: "Ctrl+Q";
        onActivated: Qt.quit();
    }

    ElementListModel{
        id: elementList;
        source: "../data/default";
    }

    header: ToolBar {
        id: titleBar;
        visible: false;
        Material.foreground: "white";
            RowLayout {
                anchors.margins: 20;
                ToolButton {
                    text: qsTr("File");
                    font.capitalization: Font.MixedCase;
                    onClicked: fileDialog.item.open();
                }
                ToolButton {
                    text: qsTr("Theme");
                    font.capitalization: Font.MixedCase;
                    onClicked: themeDialog.item.open();
                }
                ToolButton {
                    text: qsTr("Language");
                    font.capitalization: Font.MixedCase;
                    onClicked: languageDialog.item.open();
                }
                ToolButton {
                    text: qsTr("Exit");
                    font.capitalization: Font.MixedCase;
                    onClicked: Qt.quit();
                }
            }
            ToolButton{
                id: loginMsg;
                text: qsTr("Login");
                anchors.right: parent.right;
                font.capitalization: Font.MixedCase;
                onClicked: {
                    loginView.source = "qrc:/component/LoginView.qml";
                    loginView.item.openLoginWnd();
                }
            }
        }

    Loader{
        id: fileDialog;
        anchors.centerIn: parent;
        source: "qrc:/component/FileDialog.qml";
    }

    Loader{
        id: themeDialog;            // 主题设置
        anchors.centerIn: parent;
        source: "qrc:/component/ThemeDialog.qml";
    }

    Loader{
        id: languageDialog;         // 语言设置
        anchors.centerIn: parent;
        source: "qrc:/component/LanguageDialog.qml";
    }

    Loader{
        id: loadingView;            // loading
        anchors.fill: parent;
        source: "qrc:/component/LoadingView.qml";
    }

    Loader{
        id:loginView;               // login
        anchors.centerIn: parent;
    }

    Loader{
        id:mainWindow;              // 主程序窗口
        anchors.fill: parent;
    }

    Connections{
        target: loadingView.item;   // 加载完成,启动登录界面
        onLoadin:{
            loadingView.source = "";
            loginView.source = "qrc:/component/LoginView.qml";
            titleBar.visible = true;
            appWnd.showFullScreen();
        }
    }

    Connections{
        target: loginView.item;
        onLogin:{
            loginMsg.text = user;
            loginView.source = "";
            mainWindow.source = "qrc:/component/MainWindow.qml";
        }
    }
}
