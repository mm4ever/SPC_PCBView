import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3

Item {
    id: mainWindow;

    GridLayout{
        columns: 2;
        anchors.fill: parent;
        anchors.margins: 20;
        Material.foreground: Material.Pink;

        Item{
            id: pcbViewArea;                    // PCBView窗口
            width: 1284;
            height: 721;
            Text{
                id: pcbViewTitle;
                text: qsTr("PCBView");
            }
            Loader{
                id: pcbView;
                anchors.top: pcbViewTitle.bottom;
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.bottom: parent.bottom;
                anchors.margins: 2;
                source: "qrc:/component/PCBView.qml";
            }
            Loader{
                id: rotation;
                height: 24;
                width: 24;
                anchors.right: pcbView.right;
                anchors.bottom: pcbView.top;
                source: "qrc:/component/RotationTriangle.qml";
            }

            Loader{
                id: preView;
                width: 512;
                height: 297;
                anchors.top: pcbView.top;
                anchors.right: pcbView.right;
                visible: false;
                source: "qrc:/component/PreView.qml";
            }
        }

        Item{
            id: listArea;                       // List窗口
            Layout.fillWidth: true;
            height: pcbViewArea.height;
            Text{
                text: qsTr("List");
            }
        }

        Item{
            id: equpmentArea;                   // Equipment窗口
            Layout.fillHeight: true;
            width: pcbViewArea.width;

            Text{
                text: qsTr("Equipment");
            }
        }

        Item{
            id: lotsArea;                       // Lots窗口
            Layout.fillHeight: true;
            Layout.fillWidth: true;

            Text{
                text: qsTr("Lots");
            }
        }
    }
    Connections{
        target: rotation.item;
        onRotationChanged:{
            preView.visible = !preView.visible;
        }
    }

}
