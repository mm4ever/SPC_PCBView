import QtQuick 2.10
import QtQuick.Layouts 1.3

import an.qt.CModel 1.0

Item {
    Component{
        id: headerVw;
        Item{
            width: parent.width;
            height: 30;
            RowLayout{
                spacing: 8;
                Text {
                    text: qsTr("x");
                    font.bold: true;
                    font.pixelSize: 24;
                    Layout.preferredWidth: 100;
                }
                Text {
                    text: qsTr("y");
                    font.bold: true;
                    font.pixelSize: 24;
                    Layout.preferredWidth: 100;
                }
                Text {
                    text: qsTr("width");
                    font.bold: true;
                    font.pixelSize: 24;
                    Layout.preferredWidth: 100;
                }
                Text {
                    text: qsTr("height");
                    font.bold: true;
                    font.pixelSize: 24;
                    Layout.preferredWidth: 100;
                }
                Text {
                    text: qsTr("shape");
                    font.bold: true;
                    font.pixelSize: 24;
                    Layout.fillWidth: true;
                }
            }
        }
    }

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

            RowLayout{
                anchors.verticalCenter: parent.verticalCenter;
                spacing: 8;
                Text {
                    text: centralX;
                    color: itemWrapper.ListView.isCurrentItem ? "#8E24AA" : "black";
                    font.pixelSize: itemWrapper.ListView.isCurrentItem ? 22 : 18;
                    Layout.preferredWidth: 100;
                }
                Text {
                    text: centralY;
                    color: itemWrapper.ListView.isCurrentItem ? "#8E24AA" : "black";
                    font.pixelSize: itemWrapper.ListView.isCurrentItem ? 22 : 18;
                    Layout.preferredWidth: 100;
                }
                Text {
                    text: cwidth;
                    color: itemWrapper.ListView.isCurrentItem ? "#8E24AA" : "black";
                    font.pixelSize: itemWrapper.ListView.isCurrentItem ? 22 : 18;
                    Layout.preferredWidth: 100;
                }
                Text {
                    text: cheight;
                    color: itemWrapper.ListView.isCurrentItem ? "#8E24AA" : "black";
                    font.pixelSize: itemWrapper.ListView.isCurrentItem ? 22 : 18;
                    Layout.preferredWidth: 100;
                }
                Text {
                    text: shape;
                    color: itemWrapper.ListView.isCurrentItem ? "#8E24AA" : "black";
                    font.pixelSize: itemWrapper.ListView.isCurrentItem ? 22 : 18;
                    Layout.fillWidth: true;
                }
            }
        }
    }

    ListView{
        anchors.fill: parent;
        clip: true;

        spacing: 2;
        header: headerVw;
        delegate: elementDelegate;

        //这里引用的VideoListModel其实是来自与C++了
        model: ElementListModel { source: "../data/qml"; }
        focus: true;
        highlight: Rectangle{
            radius: 4;
            color: "#81D4FA";
        }
    }
}
