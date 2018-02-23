import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.1

Pane {
    id: floatingRectArea;
    width: 300;
    height: 200;
    Material.elevation: 10;
    Material.background: floatRectColor;

    property color checkedColor: "#BCAAA4";
    property color defaultColor: "#B0BEC5";
    property color floatRectColor: "#AA455A64";

    property string checkedShape: "null";

    //>>>---------------------------------------------------------------------------
    // 悬浮框拖动功能
    MouseArea {
        id: dragRegion;
        anchors.fill: parent;
        property point clickPos: "0,0"; //鼠标被按下时的坐标

        onPressed: {    //当鼠标按下时，记录该位置并取消选中的添加原件类型
            clickPos = Qt.point(mouse.x,mouse.y);
            checkShape("null");
        }

        onPositionChanged: {
            //计算鼠标偏移量:
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y);

            //根据鼠标偏移量改变悬浮框的位置:
            floatingRectArea.x += delta.x;
            floatingRectArea.y += delta.y;
        }

    }// end of MouseArea (ID:dragRegion)

    //>>>---------------------------------------------------------------------------
    // 添加原件形状中的矩形
    Rectangle{
        id: rectOption;
        width: parent.width / 6;
        height: parent.width / 6;
        color: defaultColor;
        anchors.top: parent.top;
        anchors.topMargin: parent.height/3;
        anchors.left: parent.left;
        anchors.leftMargin: parent.width/5;

        MouseArea {
            id: rectArea;
            anchors.fill: parent;
            hoverEnabled: true;

            cursorShape: {  //当鼠标经过和点击时改变鼠标样式
                (containsMouse ? (pressed ? Qt.ClosedHandCursor :
                                            Qt.OpenHandCursor) :
                                 Qt.ArrowCursor);
            }

            onReleased: {   //选择矩形作为选中的添加元件类型
                checkShape("rectangle");
            }
        }//end of MouseArea
    }//end of Rectangle(id:rectOption)


    //>>>---------------------------------------------------------------------------
    // 添加原件形状中的圆形
    Rectangle{
        id: circleOption;
        width: parent.width / 6;
        height: parent.width / 6;
        radius: width / 2;
        color: defaultColor;
        anchors.top: parent.top;
        anchors.topMargin: parent.height / 3;
        anchors.left: rectOption.right;
        anchors.leftMargin: parent.width / 4;

        MouseArea {
            id: circleArea;
            anchors.fill: parent;
            hoverEnabled: true;

            //若加载未完成，当鼠标经过和点击时改变鼠标样式
            cursorShape: {
                (containsMouse ? (pressed ? Qt.ClosedHandCursor :
                                            Qt.OpenHandCursor) :
                                 Qt.ArrowCursor);
            }

            onReleased: {
                checkShape("circle");
            }
        }
    }//end of Rectangle(id:circleOption)


    //>>>---------------------------------------------------------------------------
    // 悬浮框上的退出按钮
    Button{
        width: 80;
        height: 30;
        text: qsTr("close");
        Material.background: "#FFAB91";
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        anchors.rightMargin: 20;
        anchors.bottomMargin: 1;

        onClicked: {
            pcbViewItem.floatWinComponent.destroy();
        }
    }//end of Button

    function checkShape(shape){
        if("circle" === shape){
            checkedShape = "circle";
            rectOption.color = defaultColor;
            circleOption.color = checkedColor;
        }
        else if("rectangle" === shape){
            checkedShape = "rectangle";
            rectOption.color = checkedColor;
            circleOption.color = defaultColor;
        }
        else{
            circleOption.color = defaultColor;
            rectOption.color = defaultColor;
            checkedShape = "null";
        }
    }
}// end of Rectangle(ID:floatingRect)

