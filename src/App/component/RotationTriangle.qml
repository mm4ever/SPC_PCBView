import QtQuick 2.0

Image{
    id: imgTriangle;            // 提示缩略图显示与关闭的图案
    source: "qrc:/images/arrow.png";
    anchors.fill: parent;

    signal rotationChanged();

    MouseArea{
        anchors.fill: parent;
        hoverEnabled: true;     // 当鼠标徘徊在当前区域变为小手
        cursorShape: (containsMouse ?
                          (pressed ? Qt.ClosedHandCursor :
                                     Qt.PointingHandCursor) :
                          Qt.ArrowCursor);
        onClicked:{             // 鼠标点击当前区域,打开缩略图
            if (rotationAnimation.running === true){
                return;         // 判断是否是在运行状态(打开缩略图)
            }
            rotationAnimation.start();
        }
    }
    RotationAnimation{
        id: rotationAnimation;  // 提示缩略图开关的图案的动画
        target: imgTriangle;
        from: 0;
        to: -90;                // 逆时针90度
        duration: 50;

        onStopped: {
            if (from === 0){
                from = -90;
                to = 0;
            }
            else{
                from = 0;
                to = -90;
            }
            emit:rotationChanged();
        }
    }
}
