import QtQuick 2.10
import QtQuick.Dialogs 1.3

FileDialog {
    id: openFile;
    title: qsTr("Please choose a file");
    showFocusHighlight: true;

    folder: shortcuts.home;
    // ["All file (*)","Sqlite file (*.db)"];
    nameFilters: ["Sqlite file (*.sung)"];

    onAccepted: {
        fileDialog.clearElements();
        elementList.source = openFile.fileUrl.toString();
        openFile.close();
    }
}


