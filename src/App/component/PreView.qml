import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3

import an.qt.CModel 1.0

import "../scripts/AddTarget.js" as AddTarget

Item {
    visible: true;
    anchors.centerIn: parent;

    Canvas{
        anchors.fill: parent;   // 画背景
        contextType: "2d";
        onPaint: {
            context.fillStyle = "grey";
            context.beginPath();
            context.fillRect(0,0,parent.width,parent.height);
        }
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
            AddTarget.drawShape(preViewCanvas.context,elementList,selected);
        }
    }

    // 重新渲染
    function renderTargets(){
        preViewCanvas.context.clearRect(0,0,1280,720);
        AddTarget.drawShape(preViewCanvas.context,elementList,selected);
        preViewCanvas.requestPaint();
    }

}
