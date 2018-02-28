import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3

import an.qt.CModel 1.0
import an.qt.Shape 1.0

import "../scripts/AddTarget.js" as AddTarget

Rectangle {
    id: pcbViewItem;
    visible: true;
    anchors.centerIn: parent;
    clip: true;
    border.color: appWnd.Material.accent;


    property point checkPos: "0,0";             // 鼠标点击的位置坐标
    property string checkedShape: "null";       // 鼠标选中要添加元件形状
    property var floatWin;

    property int elementSize: 20;               // 自动生成的元件尺寸(长宽)
    property int elementCnt: 50;                // 自动生成的元件数量

    signal pcbDataChanged();
    signal pcbAreaChanged();

    ToolTip{
        id: tipMsg;
        x: (parent.width-width)*0.5;
        y: (parent.height-height)*0.5;

        timeout: 800;
    }

    Canvas{
        id: pcbViewCanvas;
        x: 0;
        y: 0;
        width: 1280;
        height: 720;
        clip: true;
        contextType: "2d";
        scale: 1;


        onPaint: {
            AddTarget.drawShape( pcbViewCanvas.context,
                                elementList,
                                selected,
                                xOffset,
                                yOffset,
                                elementScale);
        }
        Component.onCompleted: {
            for( var i = 0; i < pcbViewItem.elementCnt; ++i ){
                if( 0 === i % 2 ){
                    elementList.add( Shape.RECTANGLE,
                                    parseInt(Math.random()*1280),
                                    parseInt(Math.random()*720),
                                    elementSize,
                                    elementSize);
                }
                else{
                    elementList.add( Shape.CIRCLE,
                                    parseInt(Math.random()*1280),
                                    parseInt(Math.random()*720),
                                    elementSize,
                                    elementSize);
                }
            }
        }
    }

    Menu {
        id: contentMenu;
        width: 150;
        modal: true;

        Menu {
            id: menuItem;
            title: qsTr("add");
            width: 150;


            Action{
                text: "Rectangle";
                onTriggered: {
                    checkedShape = "rectangle";
                }

            }
            Action{
                text: "Circle";
                onTriggered: {
                    checkedShape = "circle"
                }
            }
            Action{
                text: "Cancle";
                onTriggered: {
                    contentMenu.close();
                }
            }

        }

        MenuItem {
            id: continue1;
            text: "continue1";
            onTriggered: {
                tipMsg.text = qsTr("This option is not supported");
                tipMsg.visible = true;
            }
        }
        MenuItem {
            id: continue2;
            text: "continue2";
            onTriggered: {
                tipMsg.text = qsTr("This option is not supported");
                tipMsg.visible = true;
            }
        }
        MenuItem {
            text: "Cancle";
            onTriggered: {
                contentMenu.close();
            }
        }

    }

    MouseArea{
        id: hoveredCursor;                      // 获取鼠标悬浮时的坐标
        anchors.fill: parent;
        hoverEnabled: true;
    }

    MouseArea{
        id: curPos;
        anchors.fill: parent;
        acceptedButtons: Qt.RightButton|Qt.LeftButton|Qt.WheelFocus; // 激活右键

        onPressed: {
            // 鼠标按下,判断是否选中元件
            checkPos = Qt.point(mouseX,mouseY);
            distinguishTarget(checkPos);
        }

        onPositionChanged: {
            if( "null" === checkedShape){
                // 未添加元件时计算canvas偏移量
                xOffset += mouseX - checkPos.x;
                yOffset += mouseY - checkPos.y;
                renderTargets();
                checkPos  = Qt.point(mouse.x,mouse.y);
                emit:pcbAreaChanged();
            }
            else{
                // 意图在添加元件时移动,弹出提示信息
                tipMsg.text = qsTr("Add without moving!");
                tipMsg.visible = true;

            }
        }

        onClicked: {
            if (mouse.button === Qt.RightButton &&
                    "null" === checkedShape) {
                // 鼠标点击时为右键,弹出添加元件悬浮框
                checkPos = Qt.point(mouseX,mouseY);
                distinguishTarget(checkPos);
                if(-1 === selected){
                    contentMenu.popup();
                }
            }
            else if(mouse.button === Qt.LeftButton &&
                    "null" !== checkedShape &&
                    -1 === selected  ) {
                // 左键时,添加元件悬浮框打开+选中添加形状+空白处=添加所选形状元件
                checkPos = Qt.point(mouseX,mouseY);
                distinguishTarget(checkPos);
                addChip();
                checkedShape = "null";
            }
        }

        onDoubleClicked: {
            if(mouse.button === Qt.LeftButton &&
                    "null" === checkedShape ){
                if( -1 === selected ){
                    xOffset = 0;                // canvas上绘图的起始位置偏移量恢复
                    yOffset = 0;
                    elementScale = 1;           // canvas上绘图的比例恢复
                    renderTargets();
                    emit:pcbAreaChanged();
                }
                else{
                    elementList.remove(selected);
                    emit:listModelView.item.listDataChanged();
                }
            }
            else{
                tipMsg.text = qsTr("Add with blank!");
                tipMsg.visible = true;
            }
        }

        onWheel: {
            var tempScale = wheel.angleDelta.y/1200;
            elementScale += tempScale;
            if (elementScale < 0.3) {       // 画布最小缩放比例为0.3
                elementScale = 0.3;
                tempScale = 0;
            }
            else if(elementScale > 10) {    // 画布最大缩放比例为10
                elementScale = 10.0;
                tempScale = 0;
            }
            // 以当前鼠标位置放大缩小时,canvas的偏移量变化
            xOffset+=(hoveredCursor.mouseX-xOffset)/(elementScale-tempScale)*(-tempScale);
            yOffset+=(hoveredCursor.mouseY-yOffset)/(elementScale-tempScale)*(-tempScale);
            renderTargets();
            emit:pcbAreaChanged();
        }
    }

    // 重新渲染
    function renderTargets( ){
        pcbViewCanvas.context.clearRect(0,0,1280,720);
        AddTarget.drawShape( pcbViewCanvas.context,
                            elementList,
                            selected,
                            xOffset,
                            yOffset,
                            elementScale );
        pcbViewCanvas.requestPaint();
    }

    // 判断鼠标点击的是空白区域还是在target上
    function distinguishTarget(pos){
        // 当前点击在PCBView上的坐标位置映射到canvas画布上的坐标位置
        var xDelta = parseInt( (pos.x - xOffset )/elementScale );
        var yDelta = parseInt( (pos.y - yOffset )/elementScale );
        var cnt = elementList.rowCount();   // 当前elementList中总元件数

        for( var i = 0; i < cnt; ++i){
            // 当前元件的x坐标、y坐标、宽、长和形状
            var x = parseInt(elementList.elementData(i,0));
            var y = parseInt(elementList.elementData(i,1));
            var width = parseInt(elementList.elementData(i,2));
            var height = parseInt(elementList.elementData(i,3));
            var shape = elementList.elementData(i,4);

            if( shape === "rectangle"){     // 当前鼠标在矩形的target上
                if( xDelta >= x &&
                        xDelta <= ( x + width ) &&
                        yDelta >= y &&
                        yDelta <= ( y + height ) ){
                    selected = i;
                    renderTargets();
                    emit:pcbDataChanged();
                    return;
                }
            }
            else{                           // 当前鼠标在圆形的target上
                var distance = Math.floor( ( Math.sqrt(
                                                Math.pow( x +  width/2  - xDelta, 2) +
                                                Math.pow( y +  height/2 - yDelta, 2) )*10)/10);
                if( distance <= width/2 ){
                    selected = i;
                    renderTargets();
                    emit:pcbDataChanged();
                    return;
                }
            }
        }
        selected = -1;
        emit:pcbDataChanged();
        emit:listModelView.item.listDataChanged();
    }

    // 在PCBView上添加元件
    function addChip( ){
        var xDelta = parseInt( (checkPos.x - xOffset )/elementScale );
        var yDelta = parseInt( (checkPos.y - yOffset )/elementScale );

        if( "circle" === checkedShape ){
            elementList.add( Shape.CIRCLE,
                            xDelta-pcbViewItem.elementSize / 2,
                            yDelta-pcbViewItem.elementSize / 2,
                            pcbViewItem.elementSize,
                            pcbViewItem.elementSize);
        }
        else if( "rectangle" === checkedShape ){
            elementList.add( Shape.RECTANGLE,
                            xDelta-pcbViewItem.elementSize / 2,
                            yDelta-pcbViewItem.elementSize / 2,
                            pcbViewItem.elementSize,
                            pcbViewItem.elementSize);
        }
        renderTargets();
        emit:pcbDataChanged();
    }
}
