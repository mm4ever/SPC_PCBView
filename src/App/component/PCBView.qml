import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3

import an.qt.CModel 1.0
import an.qt.Shape 1.0

import "../scripts/AddTarget.js" as AddTarget

Item {
    id: pcbViewItem;
    visible: true;
    anchors.centerIn: parent;
    clip: true;

    property point clickPos: "0,0";             // 鼠标点击的位置坐标
    property var floatWinComponent: null;
    property var floatWin;

    signal pcbDataChanged();
    signal pcbAreaChanged();

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
            var cnt = 2000;
            var x = 0;
            var y = 0;
            for( var i = 0; i < cnt; ++i ){
                x = parseInt(Math.random()*1280);
                y = parseInt(Math.random()*720);
                if( 0 === i % 2 ){
                    elementList.add(Shape.RECTANGLE,x,y,10,10);
                }
                else{
                    elementList.add(Shape.CIRCLE,x,y,10,10);
                }

            }
        }
    }

    Menu {
        id: contentMenu;
        x: curPos.mouseX;
        y: curPos.mouseY;
        width: 100;

        Menu { // 右键菜单
            title: qsTr("Edit");
            MenuItem {
                id: menuItem;
                text: qsTr("add");
                onTriggered: {
                    if(null === pcbViewItem.floatWinComponent){
                        pcbViewItem.floatWin = Qt.createComponent("qrc:/component/FloatingWindow.qml");
                        pcbViewItem.floatWinComponent = pcbViewItem.floatWin.createObject(pcbViewItem,{"x":300,"y":150});
                    }
                }
            }

            MenuItem {
                text: qsTr("continue1");
                onTriggered: { menuTip.visible = true; }
            }

            MenuItem {
                text: qsTr("continue2");
                onTriggered: { menuTip.visible = true; }
            }

            Item {
                ToolTip {
                    id: menuTip;
                    timeout: 1000;
                    text: qsTr("此功能暂未开放！");
                }
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

        onClicked: {
            mouse.accept = true;
            if (mouse.button === Qt.RightButton) { // 右键菜单
                contentMenu.popup();
            }
            else{
                if( null != pcbViewItem.floatWinComponent &&
                     -1 === selected  ) {
                    var xDelta = parseInt( (clickPos.x - xOffset )/elementScale );
                    var yDelta = parseInt( (clickPos.y - yOffset )/elementScale );
                    //判断鼠标点击的区域是否存在已有target
                    if(pcbViewItem.floatWinComponent.checkedShape === "rectangle"){
                        //要添加的target是矩形
                        elementList.add(Shape.RECTANGLE,xDelta,yDelta,10,10);
                    }
                    else if(pcbViewItem.floatWinComponent.checkedShape === "circle"){
                        //要添加的target是圆形
                        elementList.add(Shape.CIRCLE,xDelta,yDelta,10,10);
                    }
                    renderTargets();
                    emit:pcbDataChanged();
                }
            }
        }

        onDoubleClicked: {
            mouse.accept = true;
            if( -1 === selected ){
                xOffset = 0;                        // canvas上绘图的起始位置偏移量恢复
                yOffset = 0;
                elementScale = 1;                   // canvas上绘图的比例恢复
                renderTargets();
                emit:pcbAreaChanged();
            }
            else{
                distinguishTarget(clickPos);
                elementList.remove(selected);
                emit:listModelView.item.listDataChanged();
            }
        }

        onPressed: { //接收鼠标按下事件
            clickPos  = Qt.point(mouse.x,mouse.y);
            distinguishTarget(clickPos);
        }

        onPositionChanged: {
            // canvas偏移量
            xOffset += mouse.x - clickPos.x;
            yOffset += mouse.y - clickPos.y;
            renderTargets();
            clickPos  = Qt.point(mouse.x,mouse.y);
            emit:pcbAreaChanged();
        }
        onWheel: {
            if (wheel.modifiers & Qt.ControlModifier) {
                var tempScale = wheel.angleDelta.y/1200;
                elementScale += tempScale;
                if (elementScale < 0.3) {
                    // 画布最小缩放比例为0.3
                    elementScale = 0.3;
                    tempScale = 0;
                }
                else if(elementScale > 10) {
                    // 画布最大缩放比例为10
                    elementScale = 10.0;
                    tempScale = 0;
                }
                // canvas偏移量
                xOffset+=(hoveredCursor.mouseX-xOffset)/(elementScale-tempScale)*(-tempScale);
                yOffset+=(hoveredCursor.mouseY-yOffset)/(elementScale-tempScale)*(-tempScale);
                renderTargets();
                emit:pcbAreaChanged();
            }
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
    function distinguishTarget(clickPos){
        var xDelta = parseInt( (clickPos.x - xOffset )/elementScale );
        var yDelta = parseInt( (clickPos.y - yOffset )/elementScale );
        var cnt = elementList.rowCount();
        var x = 0;
        var y = 0;
        var width = 0;
        var height = 0;
        var distance = 0;
        var shape = "rectangle";

        for(var i = 0; i < cnt; ++i){
            x = parseInt(elementList.elementData(i,0));
            y = parseInt(elementList.elementData(i,1));
            width = parseInt(elementList.elementData(i,2));
            height = parseInt(elementList.elementData(i,3));
            shape = elementList.elementData(i,4);

            if( shape === "rectangle"){
                // 当前鼠标在矩形的target上
                if( xDelta > x &&
                    xDelta < ( x + width ) &&
                    yDelta > y &&
                    yDelta < ( y + height ) ){
                    selected = i;
                    renderTargets();
                    emit:pcbDataChanged();
                    return;
                }
            }
            else{
                // 当前鼠标在圆形的target上
                distance = Math.floor( (Math.sqrt(
                           Math.pow( x +  width/2  - xDelta, 2) +
                           Math.pow( y +  height/2 - yDelta, 2) )*10)/10);
                if( distance < width/2 ){
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
}
