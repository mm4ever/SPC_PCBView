import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3

import an.qt.CModel 1.0
import an.qt.Shape 1.0

import "../scripts/AddTarget.js" as AddTarget

Item {
    id: pcbViewItem;
    anchors.centerIn: parent;
    clip: true;

    property point checkPos: "0,0";             // 鼠标点击的位置坐标
    property string checkedShape: "null";       // 鼠标选中要添加元件形状
    property var floatWinComponent: null;
    property var floatWin;
    property string buttonType: "left";

    property int elementSize: 20;               // 自动生成的元件尺寸(长宽)
    property int elementCnt: 5;                // 自动生成的元件数量

    signal pcbDataChanged();
    signal pcbAreaChanged();

    ToolTip{
        id: tipMsg;
        x: (screen.width-width)*0.5;
        y: (screen.height-height)*0.1;
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
        id: addMenu;
        Menu {                      // 右键菜单
            title: qsTr("Add");
            MenuItem {
                text: qsTr("Rectangle");
                onTriggered: {
                    pcbViewItem.checkedShape = "rectangle";
                    pcbViewItem.addChip();
                }
            }
            MenuItem {
                text: qsTr("Circle");
                onTriggered: {
                    pcbViewItem.checkedShape = "circle";
                    pcbViewItem.addChip();
                }
            }
            MenuItem {
                text: qsTr("...");
                onTriggered: {
                    tipMsg.text = qsTr("This option is not supported");
                    tipMsg.visible = true;
                }
            }
        }
        Menu{
            title: qsTr("...");
        }
    }

    Menu{
        id: deleteMenu;
        MenuItem{
            text: qsTr("Delete");
            onTriggered:pcbViewItem.deleteChip();
        }
        MenuItem{
            text: qsTr("...");
            onTriggered: {
                tipMsg.text = qsTr("This option is not supported");
                tipMsg.visible = true;
            }
        }
    }

    MouseArea{
        id: hoveredCursor;                      // 获取鼠标悬浮时的坐标
        anchors.fill: parent;
        hoverEnabled: true;
    }

    MouseArea{
        id: currentCursor;
        anchors.fill: parent;
        acceptedButtons: Qt.RightButton|Qt.LeftButton|Qt.WheelFocus; // 激活右键

        onPressed: {
            // 鼠标按下,判断是否选中元件
            pcbViewItem.checkPos = Qt.point(mouseX,mouseY);
            pcbViewItem.distinguishTarget(pcbViewItem.checkPos);
            if(mouse.button === Qt.LeftButton)
                pcbViewItem.buttonType = "left";
            else
                pcbViewItem.buttonType = "right";
        }

        onPositionChanged: {
            if( "left" === buttonType){
                    // 未选中元件时计算canvas偏移量
                    xOffset += mouseX - pcbViewItem.checkPos.x;
                    yOffset += mouseY - pcbViewItem.checkPos.y;
                    pcbViewItem.renderTargets();
                    pcbViewItem.checkPos  = Qt.point(mouse.x,mouse.y);
                    emit:pcbAreaChanged();
            }
            else{
                pcbViewItem.checkPos  = Qt.point(mouse.x,mouse.y);
            }
        }
        onClicked: {
            if ( mouse.button === Qt.RightButton) {
                if ( -1 === selected )
                    addMenu.popup();        // 弹出添加menu
                else
                    deleteMenu.popup();     // 弹出删除menu
            }
            else{
                pcbViewItem.checkPos = Qt.point(mouseX,mouseY);
                pcbViewItem.distinguishTarget(pcbViewItem.checkPos);
            }
        }

        onDoubleClicked: {
            if(  mouse.button === Qt.LeftButton ){
                if( -1 === selected ){
                    xOffset = 0; // canvas上绘图的起始位置偏移量恢复
                    yOffset = 0;
                    elementScale = 1;  // canvas上绘图的比例恢复
                    pcbViewItem.renderTargets();
                    emit:pcbAreaChanged();
                }
                else{
                    pcbViewItem.deleteChip();
                }
            }
        }

        onWheel: {
            var tempScale = wheel.angleDelta.y/1200;
            elementScale += tempScale;
            if ( elementScale < 0.3 ) {       // 画布最小缩放比例为0.3
                elementScale = 0.3;
                tempScale = 0;
            }
            else if( elementScale > 10 ) {    // 画布最大缩放比例为10
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

    // 将pcb恢复为默认尺寸和位置
    function reset(){
        xOffset = 0;        // canvas上绘图的起始位置偏移量恢复
        yOffset = 0;
        elementScale = 1;   // canvas上绘图的比例恢复
        pcbViewItem.renderTargets();
        emit:pcbAreaChanged();
    }

    // 在pcb上删除元件
    function deleteChip(){
        elementList.remove(selected);
        emit:listModelView.item.listDataChanged();
    }

    // 在pcb上添加元件
    function addChip( ){
        // 当前鼠标位置对应图像上的偏移量
        var xDelta = parseInt((pcbViewItem.checkPos.x-xOffset )/elementScale);
        var yDelta = parseInt((pcbViewItem.checkPos.y-yOffset )/elementScale);

        // 计算待添加元件起始坐标,长宽等信息
        var x = xDelta - pcbViewItem.elementSize / 2;
        var y = yDelta - pcbViewItem.elementSize / 2;
        var w = pcbViewItem.elementSize;
        var h = pcbViewItem.elementSize;

        // 判断待添加元件是否在pcb范围内(不是PCBView范围内)
        if ( x >= 0 && x <= 1280 - w &&
             y >= 0 && y <= 720 - h ){
            if( "rectangle" === checkedShape ){
                elementList.add( Shape.RECTANGLE,
                                 xDelta-pcbViewItem.elementSize / 2,
                                 yDelta-pcbViewItem.elementSize / 2,
                                 pcbViewItem.elementSize,
                                 pcbViewItem.elementSize);
            }
            else if( "circle" === checkedShape ){
                elementList.add( Shape.CIRCLE,
                                 xDelta-pcbViewItem.elementSize / 2,
                                 yDelta-pcbViewItem.elementSize / 2,
                                 pcbViewItem.elementSize,
                                 pcbViewItem.elementSize);
            }
        }
        else{
            tipMsg.text = qsTr("Out of pcb area!");
            tipMsg.visible = true;
        }

        pcbViewItem.renderTargets();
        emit:pcbDataChanged();
    }

    // 删除pcb重新画
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

    // 判断鼠标点击的是pcb的空白区域还是在元件上
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
                    pcbViewItem.renderTargets();
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
                    pcbViewItem.renderTargets();
                    emit:pcbDataChanged();
                    return;
                }
            }
        }
        selected = -1;
        emit:pcbDataChanged();
        emit:listModelView.item.listDataChanged();
    }
}
