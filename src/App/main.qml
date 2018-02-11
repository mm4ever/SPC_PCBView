import QtQuick 2.10
import QtQuick.Window 2.3
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Controls.Universal 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

ApplicationWindow {
    id: appWnd;
    x:(screen.width-width)/2;
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

    Settings{
        id: settings;
        property string style: "Fusion"
    }

    Loader{
        id: themeDialog;            // 主题设置
        anchors.margins: 50;
        source: "qrc:/component/ThemeDialog.qml";
    }

    Loader{
        id: loadingView;            // loading
        anchors.fill: parent;
        source: "qrc:/component/LoadingView.qml";
    }

    Loader{
        id:loginView;               // login
        anchors.fill: parent;
    }

    Loader{
        id:mainWindow;              // 主程序窗口
        anchors.fill: parent;
    }

    Connections{
        target: loadingView.item;   // 加载完成,启动登录界面
        onLoadin:{
            loadingView.source = "";
            mainWindow.source = "qrc:/component/MainWindow.qml";
            loginView.source = "qrc:/component/LoginView.qml";
            appWnd.fixedWidth=Screen.desktopAvailableWidth;
            appWnd.fixedHeight=Screen.desktopAvailableHeight;
        }
    }
    Connections{
        target: loginView.item;
        onLogin:{
            loginView.source = "";
        }
    }

    Button{
        id: btnQuit;
        anchors.centerIn: parent;
        text: qsTr("Quit");
        font.capitalization: Font.MixedCase;
        onClicked: {
            Qt.quit();
        }
    }

    Button{
        id: btnSelect;
        anchors.left: btnQuit.left;
        anchors.top: btnQuit.bottom;
        text: qsTr("Theme");
        font.capitalization: Font.MixedCase;
        onClicked: {
            themeDialog.item.open();
        }
    }

}
