import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3

import an.qt.CModel 1.0

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
                height: 297;
                visible: false;
                anchors.top: pcbView.top;
                anchors.right: pcbView.right;
            }
        }// end of pcbViewArea

        Item{
            id: listArea;                       // List窗口
            Layout.fillWidth: true;
            height: pcbViewArea.height;

            Item {  //list区域的title
                id: listTitle;
                height: parent.height / 10;
                width: parent.width;
                anchors.top: parent.top;

                Text{
                    text: qsTr("List\ncentralX\tcentralY\tcwidth\tcheight\tshape");
                    anchors.top: parent.top;
                }
            }

            Item{   //元件列表区域
                id: elementList
                anchors.top: listTitle.bottom;
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.bottom: parent.bottom;

                //Delegate
                Component{
                    id: elementDelegate;

                    Item{
                        id: itemWrapper;
                        width: parent.width;
                        height: 50;

                        MouseArea{
                            anchors.fill: parent;

                            onClicked: {
                                //调用listView的属性
                                itemWrapper.ListView.view.currentIndex = index;
                            }

                            onDoubleClicked: {
                                itemWrapper.ListView.view.model.remove(index);
                                mouse.accept = true;
                            }
                        }

                        ColumnLayout{
                            height: parent.height;
                            spacing: 2;
                            anchors.leftMargin: 4;
                            anchors.left: parent.left;
                            anchors.top: parent.top;

                            Text{
                                Layout.fillWidth: true;
                                text:   centralX + "\t" + centralY + "\t" + cwidth + "\t" + cheight + "\t" + shape;
                                color: itemWrapper.ListView.isCurrentItem ? "blue" : "black";
                                font.pixelSize: 18;
                                elide: Text.ElideRight;
                            }
                        }
                    }// end of itemWrapper
                }//end of elementDelegate

                ListView{
                    anchors.fill: parent;
                    spacing: 2;
                    delegate: elementDelegate;

                    //这里引用的VideoListModel其实是来自与C++了
                    model: ElementListModel { source: "../data/qml"; }
                    focus: true;
                    highlight: Rectangle{
                        width: parent.width;
                        color: "lightblue";
                    }
                }
            }// end of elementList
        }// end of listArea

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
    }// end of GridLayout

    Connections{
        target: rotation.item;
        onRotationChanged:{
            preView.visible = !preView.visible;
        }
    }

}// end of mainWindow
