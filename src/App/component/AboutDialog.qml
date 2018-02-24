import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3

Dialog {
    title: qsTr("<font size='4'>About</font>");
    x: -width/2;
    y: -height/2;
    modal: true;
    focus: true;

    Text {
        id: aboutDialog;
        text: qsTr("The project is for statistical about PCB!");
        font.pixelSize: 18;
        color: appWnd.Material.foreground;
    }
}
