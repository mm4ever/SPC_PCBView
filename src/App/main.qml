import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Controls.Universal 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtQuick.Dialogs 1.1

import an.qt.CModel 1.0

ApplicationWindow {
    id: appWnd;
    x:(screen.width-width)/2;                   // 将主窗口限定在屏幕中央
    y:(screen.height-height)/2;
    width: screen.width / 6;
    height: screen.height / 2;
    visible: true;
    flags: Qt.Window | Qt.FramelessWindowHint;   //去标题栏

    ElementListModel{
        id: elementList;                    // list数据
        source: "file:/../data/default.sung";
    }

    Loader{
        id: loadingView;                    // loading
        source: "qrc:/component/LoadingView.qml";
        anchors.fill: parent;
    }

    Loader{
        id:loginView;                       // login
        anchors.centerIn: parent;
    }

    Loader{
        id:mainWindow;                      // 主程序窗口
        anchors.fill: parent;
    }

    Loader{
        id: fileDialog;                     // 打开文件窗口
        source: "qrc:/component/FileDialog.qml";
        anchors.centerIn: parent;

        signal clearElements();
    }

    Loader{
        id: themeDialog;                    // 主题设置
        source: "qrc:/component/ThemeDialog.qml";
        anchors.centerIn: parent;
    }

    Loader{
        id: languageDialog;                 // 语言设置
        source: "qrc:/component/LanguageDialog.qml";
        anchors.centerIn: parent;
    }

    Loader{
        id: aboutDialog;                    // about
        source: "qrc:/component/AboutDialog.qml";
        anchors.centerIn: parent;
    }

    header: ToolBar {
        id: titleBar;
        visible: false;
        Material.foreground: "white";
        font.capitalization: Font.MixedCase;

        RowLayout {
            anchors.fill: parent;
            ToolButton {
                id: fileMenuButton;
                text: qsTr("&File");
                font.pointSize: 14;
                onClicked: fileMenu.open();
                Menu{
                    id: fileMenu;
                    y: titleBar.height;
                    MenuItem{action: openAction; }
                    MenuItem{action: saveAction; }
                    MenuSeparator { }
                    MenuItem{ action: quitAction; }
                }
            }
            ToolButton {
                id: toolMenuButton;
                text: qsTr("&Tools");
                font.pointSize: 14;
                onClicked: toolMenu.open();

                Menu{
                    id: toolMenu;
                    y: titleBar.height;
                    MenuItem{ action: chooseTheme; }
                    MenuItem{ action: chooseLanguage; }
                    MenuSeparator { }
                    MenuItem{ action: showAbout; }
                }
            }

            MouseArea{
                id: mouseArea;
                Layout.fillWidth: true;
                height: titleBar.height;
                onPressed: appWnd.showMaximized();
            }
            ToolButton{
                id: loginMsg;
                text: qsTr("Login");
                onClicked: {
                    loginView.source = "qrc:/component/LoginView.qml";
                }
                Rectangle{
                    anchors.centerIn: parent;
                    width: parent.width;
                    height: parent.height*0.75;
                    border.width: 2;
                    border.color: "white";
                    color: "transparent";
                    radius: 4;
                }
            }
        }

    }

    Item{
        id: actionItem;
        Action{
            id:openAction;
            text:qsTr("&Open");
            shortcut: StandardKey.Open;
            onTriggered: fileDialog.item.open();
        }
        Action{
            id:saveAction;
            text:qsTr("Save");
            shortcut: "Ctrl+S";
            onTriggered: elementList.save();
        }
        Action{
            id:quitAction;
            text:qsTr("Exit");
            shortcut: "Ctrl+Q";
            onTriggered: Qt.quit();
        }
        Action{
            id:chooseTheme;
            text: qsTr("Theme");
            onTriggered: themeDialog.item.open();
        }
        Action{
            id:chooseLanguage;
            text: qsTr("Language");
            onTriggered: languageDialog.item.open();
        }
        Action{
            id:showAbout;
            text:qsTr("About");
            onTriggered: aboutDialog.item.open();
        }
    }

    Item{
        id: connectionsItem;
        Connections{
            target: loadingView.item;                   // 加载完成,启动登录界面
            onLoadin:{
                loadingView.source = "";
                loginView.source = "qrc:/component/LoginView.qml";
                titleBar.visible = true;
                appWnd.showMaximized();                         // 窗口最大化
                // Screen.desktopAvailableHeight为获得当前屏幕有效高度1056
                // screen.height为获得当前屏幕高度1080
                // 将当前有效屏幕设置为最小值
                appWnd.minimumHeight = Screen.desktopAvailableHeight;
                appWnd.minimumWidth = Screen.desktopAvailableWidth;
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
}
