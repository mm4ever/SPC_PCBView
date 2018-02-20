import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import an.qt.CModel 1.0

ApplicationWindow
{
    visible: true;
    width: 800;
    height: 800;

    //Delegate
    Component{
        id: videoDelegate;
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
                    // lstVw.model.remove(index);
                    mouse.accept = true;
                }
            }

            ColumnLayout{
//                anchors.left: parent.right;
                anchors.leftMargin: 4;
                anchors.left: parent.left;
                anchors.top: parent.top;
                height: parent.height;
                spacing: 2;

                //director_tag/director
                Text{
                    Layout.fillWidth: true;
                    text:  shape + "\t" + centralX + "\t" + centralY + "\t" + cwidth + "\t" + cheight;
                    color: itemWrapper.ListView.isCurrentItem ? "blue" : "black";
                    font.pixelSize: 18;
                    elide: Text.ElideRight;
                }
            }
        }
    }

    ListView{
        id: lstVw;
        anchors.fill: parent;
        spacing: 2;
        delegate: videoDelegate;

        //这里引用的VideoListModel其实是来自与C++了
        model: ElementListModel { source: "../data/job/qml"; }
        focus: true;
        highlight: Rectangle{
            width: parent.width;
            color: "lightblue";
        }
    }
}
