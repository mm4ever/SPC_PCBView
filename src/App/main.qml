import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Controls.Universal 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

ApplicationWindow {
    id: appWnd;
    x:(screen.width-width)/2;       // 主窗口限定在屏幕中央
    y:(screen.height-height)/2;
    width: fixedWidth;
    height: fixedHeight;
    minimumWidth: fixedWidth;
    minimumHeight: fixedHeight;
    maximumWidth: fixedWidth;
    maximumHeight: fixedHeight;
    visible: true;

    property int  fixedWidth : 320;
    property int  fixedHeight: 520;

    header: ToolBar {
        id: titleBar;
        visible: false;
        Material.foreground: "white"
            RowLayout {
                anchors.margins: 20;
                ToolButton {
                    text: qsTr("File");
                    font.capitalization: Font.MixedCase;
                }
                ToolButton {
                    text: qsTr("Theme");
                    font.capitalization: Font.MixedCase;
                    onClicked: themeDialog.item.open();
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
        id: themeDialog;            // 主题设置
        anchors.centerIn: parent;
        source: "qrc:/component/ThemeDialog.qml";
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
            appWnd.fixedWidth=Screen.desktopAvailableWidth;
            appWnd.fixedHeight=Screen.desktopAvailableHeight-titleBar.height;
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
