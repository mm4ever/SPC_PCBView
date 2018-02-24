import QtQuick 2.10
import QtQuick.Dialogs 1.3

FileDialog {
    id: fileDialog;
    title: qsTr("Please choose a file");
    folder: shortcuts.home;
    nameFilters: ["All file (*)","Sqlite file (*.db)"];
    onAccepted: {
//        elementList.source = "../data/default_180223191222";
        console.log( fileDialog.folder);
    }
}
