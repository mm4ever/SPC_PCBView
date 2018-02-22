import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3

import an.qt.CModel 1.0
import an.qt.LanguageSetting 1.0

Item {
    id: mainWindow;

    property int  selected: 0;

    ElementListModel{
        id: elementList;
        source: "../data/qml";
    }

    GridLayout{
        columns: 2;
        anchors.fill: parent;
        anchors.margins: 20;
        Material.foreground: Material.Pink;

        Item{
            id: pcbViewArea;                    // PCBView窗口
            width: 1284;
            height: 741;

            Text{
                id: pcbViewTitle;
                text: qsTr("PCBView");
                color: "#ff00ff"
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
                width: 516;
                height: 292;
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
                    color: "#ff00ff"
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
                color: "#ff00ff"
            }
        }

        Item{
            id: lotsArea;                       // Lots窗口
            Layout.fillHeight: true;
            Layout.fillWidth: true;

            Text{
                text: qsTr("Lots");
                color: "#ff00ff"
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
    }

}// end of mainWindow
