import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Controls.Universal 2.1
import QtQuick.Layouts 1.3

ApplicationWindow {
    id: appWnd;
    width: fixedWidth;
    height: fixedHeight;
    minimumWidth: fixedWidth;
    minimumHeight: fixedHeight;
    maximumWidth: fixedWidth;
    maximumHeight: fixedHeight;

    visible: true;
    title: qsTr("SPC");

    Material.accent: Material.Purple;
    Material.foreground: Material.Pink;

    property int  fixedWidth : 320;
    property int  fixedHeight: 480;
    Button{
        anchors.bottom: parent.bottom;
        onClicked: Qt.quit();
    }

    Loader{
        id: loadingView;            // loading窗口
        anchors.fill: parent;
        source: "qrc:/component/LoadingView.qml";
    }

    Loader{
        id:loginView;               // login窗口
        anchors.fill: parent;
    }

    Loader{
        id:mainWindow;              // 主程序窗口
        anchors.fill: parent;
    }

    Connections{
        target: loadingView.item;
        onLoadin:{
            loadingView.source = "";
            mainWindow.source = "qrc:/component/MainWindow.qml";
            loginView.source = "qrc:/component/LoginView.qml";
            appWnd.fixedWidth=1920;
            appWnd.fixedHeight=980;
        }
    }
    Connections{
        target: loginView.item;
        onLogin:{
            loginView.source = "";
        }
    }
}
