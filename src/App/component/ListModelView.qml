import QtQuick 2.10
import QtQuick.Controls 2.3
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
                    if( elementList.rowCount() > 1 ){
                        if( elementList.rowCount() === selected+1 ){
                            selected -= 1;
                            itemWrapper.ListView.view.model.remove(selected+1);
                        }
                        else{
                            itemWrapper.ListView.view.model.remove(selected);
                        }
                    }
                    else{
                        itemWrapper.ListView.view.model.remove(selected);
                    }
                    emit:listDataChanged();
                }
            }

            RowLayout{
                anchors.verticalCenter: parent.verticalCenter;
                spacing: 8;
                Text {
                    text: centralX;
                    color: itemWrapper.ListView.isCurrentItem ? "#9C27B0" : "grey";
                    font.pixelSize: itemWrapper.ListView.isCurrentItem ? 22 : 18;
                    Layout.preferredWidth: 100;
                }
                Text {
                    text: centralY;
                    color: itemWrapper.ListView.isCurrentItem ? "#9C27B0" : "grey";
                    font.pixelSize: itemWrapper.ListView.isCurrentItem ? 22 : 18;
                    Layout.preferredWidth: 100;
                }
                Text {
                    text: cwidth;
                    color: itemWrapper.ListView.isCurrentItem ? "#9C27B0" : "grey";
                    font.pixelSize: itemWrapper.ListView.isCurrentItem ? 22 : 18;
                    Layout.preferredWidth: 100;
                }
                Text {
                    text: cheight;
                    color: itemWrapper.ListView.isCurrentItem ? "#9C27B0" : "grey";
                    font.pixelSize: itemWrapper.ListView.isCurrentItem ? 22 : 18;
                    Layout.preferredWidth: 100;
                }
                Text {
                    text: shape;
                    color: itemWrapper.ListView.isCurrentItem ? "#9C27B0" : "grey";
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
        anchors.top: headerVw.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        clip: true;

        spacing: 2;
        delegate: elementDelegate;

        //这里引用的VideoListModel其实是来自与C++了
        model: elementList;
        focus: true;
        highlightMoveDuration: 750;
        highlight: Rectangle{
            radius: 4;
            color: "#81D4FA";
        }
        ScrollBar.vertical: ScrollBar{
            id: scrollBar;
            width: 10;
            anchors.top: lstVm.top;
            anchors.right: lstVm.right;
            anchors.bottom: lstVm.bottom;
        }
    }

    function updateListView(){
        lstVm.currentIndex = selected;
    }

}
