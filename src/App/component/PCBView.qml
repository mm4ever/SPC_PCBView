import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3

import an.qt.CModel 1.0

import "../scripts/AddTarget.js" as AddTarget

Item {
    visible: true;
    anchors.centerIn: parent;
    clip: true;

    property point delta: "0,0";
    property point clickPos: "0,0";

    signal pcbDataChanged();

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
            AddTarget.drawShape(pcbViewCanvas.context,elementList,selected);
        }
    }

    MouseArea{
        id: curPos;
        anchors.fill: parent;

        onDoubleClicked: {
            delta = Qt.point(0,0);
            pcbViewCanvas.x = 0;
            pcbViewCanvas.y = 0;
            pcbViewCanvas.scale = 1;
        }

        onPressed: { //接收鼠标按下事件
            clickPos  = Qt.point(mouse.x,mouse.y);
            distinguishTarget(mouse.x,mouse.y);
            console.log("click:",mouse.x,mouse.y)

        }
        onPositionChanged: { //鼠标按下后改变位置
            //鼠标偏移量
            delta = Qt.point( mouse.x - clickPos.x + delta.x,
                              mouse.y - clickPos.y + delta.y );

            pcbViewCanvas.x = delta.x;
            pcbViewCanvas.y = delta.y;
            console.log("delta:",delta.x,delta.y)
            clickPos  = Qt.point(mouse.x,mouse.y);
        }
        onWheel: {
            if (wheel.modifiers & Qt.ControlModifier) {
                pcbViewCanvas.scale += 0.11 * wheel.angleDelta.y / 120;
                pcbViewCanvas.scale = Math.floor(pcbViewCanvas.scale*10)/10;
                if (pcbViewCanvas.scale < 0.3) {
                    // 画布最小缩放比例为0.3
                    pcbViewCanvas.scale = 0.3;
                }
                else if(pcbViewCanvas.scale > 10) {
                    // 画布最大缩放比例为5
                    pcbViewCanvas.scale = 5.0;
                }
                pcbViewCanvas.x = 0;
                pcbViewCanvas.y = 0;
            }
        }

    }

    // 重新渲染
    function renderTargets( ){
        pcbViewCanvas.context.clearRect(0,0,1280,720);
        AddTarget.drawShape(pcbViewCanvas.context,elementList,selected);
        pcbViewCanvas.requestPaint();
    }

    // 判断鼠标点击的是空白区域还是在target上
    function distinguishTarget(clickX,clickY){
        clickX = parseInt( (clickX - ( 1- pcbViewCanvas.scale ) * 640 )/pcbViewCanvas.scale - delta.x );
        clickY = parseInt( (clickY - ( 1- pcbViewCanvas.scale ) * 320 )/pcbViewCanvas.scale - delta.y );
        console.log("to:",clickX,clickY)
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
                if( clickX > x &&
                    clickX < ( x + width ) &&
                    clickY > y &&
                    clickY < ( y + height ) ){
                    selected = i;
                    renderTargets(selected);
                    emit:pcbDataChanged();
                    return;
                }
            }
            else{
                // 当前鼠标在圆形的target上
                distance = Math.floor( (Math.sqrt(
                           Math.pow( x +  width/2  - clickX, 2) +
                           Math.pow( y +  height/2 - clickY, 2) )*10)/10);
                if( distance < width/2 ){
                    selected = i;
                    renderTargets(selected);
                    emit:pcbDataChanged();
                    return;
                }
            }
        }
    }

}
