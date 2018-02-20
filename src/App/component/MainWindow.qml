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
            width: 1280;
            height: 720;
            Text{
                text: qsTr("PCBView");
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

}
