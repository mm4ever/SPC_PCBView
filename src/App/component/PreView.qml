import QtQuick 2.7

import an.qt.CModel 1.0

import "../scripts/AddTarget.js" as AddTarget

Item {
    visible: true;
    anchors.centerIn: parent;
    clip: true;

    Rectangle{          // 画背景
        anchors.fill: parent;
        color: "grey";
    }

    Canvas{
        id: preViewCanvas;
        anchors.centerIn: parent;
        width: 1280;
        height: 720;
        clip: true;
        contextType: "2d";
        scale: 0.4;

        onPaint: {
            AddTarget.drawShape( preViewCanvas.context,
                                 elementList,
                                 selected,
                                 0,
                                 0,
                                 1 );
        }
    }

    Rectangle{
        id: rectBox;
        x: 0;
        y: 0;
        width: 512;
        height: 288;
        border.width: 1;
        border.color: "red";
        color: "transparent";
    }

    // 重新渲染
    function renderTargets(){
        preViewCanvas.context.clearRect(0,0,1280,720);
        AddTarget.drawShape( preViewCanvas.context,
                             elementList,
                             selected,
                             0,
                             0,
                             1 );
        preViewCanvas.requestPaint();
    }

    // 重新画缩略图预览框
    function renderRectBox(){
        if( elementScale < 1 ){
            rectBox.x = 0;
            rectBox.y = 0;
            rectBox.width = 512;
            rectBox.height = 288;
        }
        else{
            rectBox.x = -xOffset/elementScale*0.4;
            rectBox.y = -yOffset/elementScale*0.4;
            rectBox.width = 512/elementScale;
            rectBox.height = 288/elementScale;
        }
    }
}
