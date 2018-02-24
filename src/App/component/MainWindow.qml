import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import Qt.labs.platform 1.0

import an.qt.CModel 1.0
import an.qt.LanguageSetting 1.0

Item {
    id: mainWindow;

    property int  selected: 0;
    property int xOffset: 0;
    property int yOffset: 0;
    property real elementScale: 1;

//    Shortcut{
//        sequence: "Ctrl+O";
//        onActivated: Qt.quit();
//    }

//    ElementListModel{
//        id: elementList;
////        source: "../data/qml";
//    }

//    FileDialog {
//        id: fileDialog1
//        fileMode: FileDialog.OpenFile
//        nameFilters: ["数据库文件 (*.db)", "全部文件 (*.*)"]
//        options :FileDialog.ReadOnly;
//    }

    GridLayout{
        columns: 2;
        anchors.fill: parent;
        anchors.margins: 20;

        Item{
            id: pcbViewArea;                    // PCBView窗口
            width: 1284;
            height: 741;

            Text{
                id: pcbViewTitle;
                text: qsTr("<font size='4'>PCBView</font>");
                color: Material.color(Material.Pink);
            }

            Loader{
                id: pcbView;
                source: "qrc:/component/PCBView.qml";
                anchors.margins: 2;
                anchors.top: pcbViewTitle.bottom;
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.bottom: parent.bottom;
            }

            Loader{
                id: rotation;
                source: "qrc:/component/RotationTriangle.qml";
                height: 24;
                width: 24;
                anchors.right: pcbView.right;
                anchors.bottom: pcbView.top;
            }

            Loader{
                id: preView;
                source: "qrc:/component/PreView.qml";
                width: 512;
                height: 288;
                visible: false;
                anchors.top: pcbView.top;
                anchors.right: pcbView.right;
            }
        }// end of pcbViewArea

        Item{
            id: listArea;                       // List窗口
            Layout.fillWidth: true;
            height: pcbViewArea.height;

            Text{
                id: listModelTitle;
                text: qsTr("<font size='4'>List</font>");
                color: Material.color(Material.Pink);
            }
            Loader{
                id: listModelView;
                anchors.top:listModelTitle.bottom;
                anchors.left: parent.left;
                anchors.leftMargin: 20;
                anchors.right: parent.right;
                anchors.bottom: parent.bottom;
                source: "qrc:/component/ListModelView.qml";
            }

        }// end of listArea

        Item{
            id: equpmentArea;                   // Equipment窗口
            Layout.fillHeight: true;
            width: pcbViewArea.width;

            Text{
                text: qsTr("<font size='4'>Equipment</font>");
                color: Material.color(Material.Pink);
            }
        }

        Item{
            id: lotsArea;                       // Lots窗口
            Layout.fillHeight: true;
            Layout.fillWidth: true;

            Text{
                text: qsTr("<font size='4'>Lots</font>");
                color: Material.color(Material.Pink);
            }
        }
    }// end of GridLayout

    Connections{
        target: rotation.item;
        onRotationChanged:{
            preView.visible = !preView.visible;
        }
    }
    Connections{
        target: listModelView.item;
        onListDataChanged:{
            pcbView.item.renderTargets();
            preView.item.renderTargets();
        }
    }
    Connections{
        target: pcbView.item;
        onPcbDataChanged:{
            listModelView.item.updateListView();
            preView.item.renderTargets();
        }
        onPcbAreaChanged:{
            preView.item.renderRectBox();
        }
    }

    Shortcut{
        sequence: "Ctrl+S";
        onActivated: elementList.save();
    }
}// end of mainWindow
