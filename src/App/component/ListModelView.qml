import QtQuick 2.10
import QtQuick.Layouts 1.3

Item {
    signal listDataChanged();

    Item{
        id: headerVw;
        width: parent.width;
        height: 30;
        RowLayout{
            spacing: 8;
            Text {
                text: qsTr("x");
                font.bold: true;
                font.pixelSize: 24;
                Layout.preferredWidth: 100;
                color: "grey";
            }
            Text {
                text: qsTr("y");
                font.bold: true;
                font.pixelSize: 24;
                Layout.preferredWidth: 100;
                color: "grey";
            }
            Text {
                text: qsTr("width");
                font.bold: true;
                font.pixelSize: 24;
                Layout.preferredWidth: 100;
                color: "grey";
            }
            Text {
                text: qsTr("height");
                font.bold: true;
                font.pixelSize: 24;
                Layout.preferredWidth: 100;
                color: "grey";
            }
            Text {
                text: qsTr("shape");
                font.bold: true;
                font.pixelSize: 24;
                Layout.fillWidth: true;
                color: "grey";
            }
        }
    }
    //    }

    Component{
        id: elementDelegate;
        Item{
            id: itemWrapper;
            width: parent.width;
            height: 50;

            MouseArea{
                anchors.fill: parent;

                onClicked: {
                    mouse.accept = true;
                    //调用listView的属性
                    selected = index;       // 当前选中目标
                    itemWrapper.ListView.view.currentIndex = selected;
                    emit:listDataChanged();
                }
                onDoubleClicked: {
                    mouse.accept = true;
                    itemWrapper.ListView.view.model.remove(selected);
                    emit:listDataChanged();
                    itemWrapper.ListView.view.currentIndex = selected;
                }
            }

            RowLayout{
                anchors.verticalCenter: parent.verticalCenter;
                spacing: 8;
                Text {
                    text: centralX;
                    color: itemWrapper.ListView.isCurrentItem ? "#8E24AA" : "grey";
                    font.pixelSize: itemWrapper.ListView.isCurrentItem ? 22 : 18;
                    Layout.preferredWidth: 100;
                }
                Text {
                    text: centralY;
                    color: itemWrapper.ListView.isCurrentItem ? "#8E24AA" : "grey";
                    font.pixelSize: itemWrapper.ListView.isCurrentItem ? 22 : 18;
                    Layout.preferredWidth: 100;
                }
                Text {
                    text: cwidth;
                    color: itemWrapper.ListView.isCurrentItem ? "#8E24AA" : "grey";
                    font.pixelSize: itemWrapper.ListView.isCurrentItem ? 22 : 18;
                    Layout.preferredWidth: 100;
                }
                Text {
                    text: cheight;
                    color: itemWrapper.ListView.isCurrentItem ? "#8E24AA" : "grey";
                    font.pixelSize: itemWrapper.ListView.isCurrentItem ? 22 : 18;
                    Layout.preferredWidth: 100;
                }
                Text {
                    text: shape;
                    color: itemWrapper.ListView.isCurrentItem ? "#8E24AA" : "grey";
                    font.pixelSize: itemWrapper.ListView.isCurrentItem ? 22 : 18;
                    Layout.fillWidth: true;
                }
            }

            Component.onCompleted: {
                itemWrapper.ListView.view.currentIndex = selected;
            }
        }
    }

    ListView{
        id: lstVm;
        //        anchors.fill: parent;
        anchors.top: headerVw.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        clip: true;

        spacing: 2;
        //        header: headerVw;
        delegate: elementDelegate;

        //这里引用的VideoListModel其实是来自与C++了
        model: elementList;
        focus: true;
        highlightMoveDuration: 750;
        highlight: Rectangle{
            radius: 4;
            color: "#81D4FA";
        }
    }

    function updateListView(){
        lstVm.currentIndex = selected;
    }

}
