import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3

Item{
    signal login();           // 登录完成

    Dialog {
        id: inputDialog;
        x: (parent.width - width) / 2;
        y: (parent.height - height) / 2;

        focus: true;
        modal: true;
        title: qsTr("Login");
        standardButtons: Dialog.Cancel | Dialog.Ok;
        onAccepted: {
            emit:login();
        }

        ColumnLayout {
            spacing: 20;
            anchors.fill: parent;
            Label {
                elide: Label.ElideRight;
                text: qsTr("Please enter the credentials:");
                Layout.fillWidth: true;
            }
            TextField {
                focus: true;
                placeholderText: qsTr("Username");
                maximumLength: 15;
                Layout.fillWidth: true;
            }
            TextField {
                placeholderText: qsTr("Password");
                echoMode: TextField.Password;
                maximumLength: 15;
                Layout.fillWidth: true;
            }
        }
    }
    Component.onCompleted: inputDialog.open();
}
