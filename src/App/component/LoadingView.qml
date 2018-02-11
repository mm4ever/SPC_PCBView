import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3

Item{
    signal loadin();    // 加载结束

    ProgressBar {
        x: ( parent.width - width ) / 2;
        y: ( parent.height - height ) / 4 * 3;
        value: 0            // 加载时进度条起始位置

        Timer{
            id: timer;      // 进度条加载动画时间
            repeat: true;
            interval: 5;
            triggeredOnStart: true;
            running: true;
            onTriggered:{
                if (parent.value >= 1){
                    running = false;
                    emit:loadin();
                }
                parent.value += 0.01;
            }
        }
    }
}


