import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import Qt.labs.platform 1.0

import an.qt.CModel 1.0

Item {
    id: mainWindow;

    property int  selected: -1;
    property int xOffset: 0;
    property int yOffset: 0;
    property real elementScale: 1;

    GridLayout{
        columns: 2;
        anchors.fill: parent;
        anchors.margins: 20;

        Item{
            id: pcbViewArea;                    // PCBView窗口
            width: 1284;
            height: 745;

            Text{
                id: pcbViewTitle;
                text: qsTr("PCBView");
                font.pointSize: 14;
                color: Material.accent;
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
                width: 514;
                height: 290;
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
                text: qsTr("List");
                font.pointSize: 14;
                color: Material.accent;
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
                text: qsTr("Equipment");
                font.pointSize: 14;
                color: Material.accent;
            }
        }

        Item{
            id: lotsArea;                       // Lots窗口
            Layout.fillHeight: true;
            Layout.fillWidth: true;

            Text{
                text: qsTr("Lots");
                font.pointSize: 14;
                color: Material.accent;
            }
        }
    }// end of GridLayout

    Item{
        id: connectionsItem;                    // 信号实现
        Connections{
            target: rotation.item;              // PreView上旋转动画的信号
            onRotationChanged:{
                preView.visible = !preView.visible;
            }
        }
        Connections{
            target: listModelView.item;         // ListModelView数据变化的信号
            onListDataChanged:{
                pcbView.item.renderTargets();
                preView.item.renderTargets();
            }
        }
        Connections{
            target: pcbView.item;               // PCBView中数据和位置变化的信号
            onPcbDataChanged:{
                listModelView.item.updateListView();
                preView.item.renderTargets();
            }
            onPcbAreaChanged:{
                preView.item.renderRectBox();
            }
        }
        Connections{
            target: fileDialog;
            onClearElements:{
                var cnt = elementList.rowCount();
                for(var i = 0; i < cnt; ++i){
                    elementList.remove(0);
                }
                pcbView.item.renderTargets();
            }
        }
    }
}// end of mainWindow
