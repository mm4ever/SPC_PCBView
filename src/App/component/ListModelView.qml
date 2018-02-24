import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3

Item {
    signal listDataChanged();

    Item{
        id: headerVw;                       // ListModelView的表头
        width: parent.width;
        height: 30;
        RowLayout{
            spacing: 8;
            Text {
                text: qsTr("X");
                font.bold: true;
                font.pointSize: 18;
                Layout.preferredWidth: 100;
                color: Material.primary;
            }
            Text {
                text: qsTr("Y");
                font.bold: true;
                font.pointSize: 18;
                Layout.preferredWidth: 100;
                color: Material.primary;

            }
            Text {
                text: qsTr("Width");
                font.bold: true;
                font.pointSize: 18;
                Layout.preferredWidth: 100;
                color: Material.primary;

            }
            Text {
                text: qsTr("Height");
                font.bold: true;
                font.pointSize: 18;
                Layout.preferredWidth: 100;
                color: Material.primary;

            }
            Text {
                text: qsTr("Shape");
                font.bold: true;
                font.pointSize: 18;
                Layout.fillWidth: true;
                color: Material.primary;

            }
        }
    }

    Component{
        id: elementDelegate;                // ListModelView的数据
        Item{
            id: itemWrapper;
            width: parent.width-10;         // 减去ScrollBar宽度10
            height: 50;

//            Connections{
//                target:fileDialog
//                onClearAllElement:{
//                    elementList.remove(0);
//                }
//            }

            MouseArea{
                anchors.fill: parent;

                onClicked: {
                    //调用listView的属性
                    selected = index;       // 当前选中目标
                    itemWrapper.ListView.view.currentIndex = selected;
                    emit:listDataChanged();
                }
                onDoubleClicked: {
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
                    color: itemWrapper.ListView.isCurrentItem ? Material.accent : "grey";
                    font.pointSize: itemWrapper.ListView.isCurrentItem ? 18 : 16;
                    Layout.preferredWidth: 100;
                }
                Text {
                    text: centralY;
                    color: itemWrapper.ListView.isCurrentItem ? Material.accent : "grey";
                    font.pointSize: itemWrapper.ListView.isCurrentItem ? 18 : 16;
                    Layout.preferredWidth: 100;
                }
                Text {
                    text: cwidth;
                    color: itemWrapper.ListView.isCurrentItem ? Material.accent : "grey";
                    font.pointSize: itemWrapper.ListView.isCurrentItem ? 18 : 16;
                    Layout.preferredWidth: 100;
                }
                Text {
                    text: cheight;
                    color: itemWrapper.ListView.isCurrentItem ? Material.accent : "grey";
                    font.pointSize: itemWrapper.ListView.isCurrentItem ? 18 : 16;
                    Layout.preferredWidth: 100;
                }
                Text {
                    text: shape;
                    color: itemWrapper.ListView.isCurrentItem ? Material.accent : "grey";
                    font.pointSize: itemWrapper.ListView.isCurrentItem ? 18 : 16;
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

        // 这里引用的VideoListModel其实是来自与C++了
        model: elementList;
        focus: true;
        highlightMoveDuration: 750;
        // 选中的高亮区域
        highlight: Rectangle{
            radius: 4;
            color: "lightgrey";
        }
        ScrollBar.vertical: ScrollBar{
            id: scrollBar;
            width: 10;
            anchors.top: lstVm.top;
            anchors.right: lstVm.right;
            anchors.bottom: lstVm.bottom;
        }
    }

    // 设置当前的ListModel索引为鼠标选中的元件
    function updateListView(){
        lstVm.currentIndex = selected;
    }
}
