import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3

Item {
    visible: true;
    anchors.centerIn: parent;

    Text{
        id: preViewTitle;
        text: qsTr("PreView");
    }
    Rectangle{
        anchors.top: preViewTitle.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        color:"grey";
    }

}
