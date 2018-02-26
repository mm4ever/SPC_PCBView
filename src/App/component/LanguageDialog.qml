import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3

Dialog {
    id: languageDialog;
    x: -width/2;
    y: -height/2;
    modal: true;
    focus: true;

    standardButtons: Dialog.Ok | Dialog.Cancel;
    font.capitalization: Font.MixedCase;
    onAccepted: {
        languages.changeLanguageType();
    }
    onRejected: {
        languageDialog.close();
    }

    Component.onCompleted: {

        language.model = languages.languageTypeList();
        language.currentIndex = languages.languageIndex;
        //这里是真正的绑定
        languages.languageIndex = Qt.binding(function() { return language.currentIndex })
    }

    contentItem: ColumnLayout {
        spacing: 20;

        RowLayout {
            spacing: 10;

            Label {
                text: qsTr("Language:");
                font.pointSize: 14;
                color: Material.accent;
            }

            ComboBox {
                id: language;
                Layout.fillWidth: true;
            }
        }
    }
}
