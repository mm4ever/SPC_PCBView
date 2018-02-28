import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3

import an.qt.LanguageSetting 1.0


Dialog {
    id: languageDialog;
    width: 267;
    height: 144;
    x: -width/2;
    y: -height/2;
    modal: true;
    focus: true;

    standardButtons: Dialog.Cancel;
    font.capitalization: Font.MixedCase;

    onRejected: {
        languageDialog.close();
    }

    Component.onCompleted: {
        languageCmb.model = languages.languageTypeList();
        languageCmb.currentIndex = languages.laguageIndex;
        languages.laguageIndex = Qt.binding(function() { return languageCmb.currentIndex});
    }

    contentItem: ColumnLayout {
        spacing: 20;

        RowLayout {
            spacing: 10;

            Label {
                text: qsTr("Language:");
                color: Material.accent;
                font.pointSize: 14;
            }

            ComboBox {
                id: languageCmb;
                Layout.fillWidth: true;
            }
        }
    }

    Connections {
        target: languages;
        onLaguageIndexChanged: languages.languageUpdate();
    }
}
