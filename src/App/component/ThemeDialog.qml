import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3

import an.qt.ThemeSetting 1.0

Dialog {
    id: themeDialog;
    x: -width/2;
    y: -height/2;
    modal: true;
    focus: true;

    ThemeSetting{
        id: themeSetting;

        Component.onCompleted: {
            themeCmb.model = themeSetting.themeTypeList();
            themeCmb.currentIndex = themes.themeIndex;
            themeSetting.updateStyle();
            themes.themeIndex = Qt.binding(function() { return themeCmb.currentIndex});
        }

        //这个函数更新窗口风格
        function updateStyle(){
            //附加属性在material中
            appWnd.Material.accent = themeSetting.getAccent(themes.themeIndex);
            appWnd.Material.primary = themeSetting.getPrimary(themes.themeIndex);
            appWnd.Material.foreground = themeSetting.getForeground(themes.themeIndex);
            appWnd.Material.background = themeSetting.getBackground(themes.themeIndex);
        }
    }//End of ThemeSetting

    standardButtons:  Dialog.Cancel;
    font.capitalization: Font.MixedCase;

    onRejected: {
        themeDialog.close();
    }

    contentItem: ColumnLayout {
        spacing: 20;

        RowLayout {
            spacing: 10;

            Label {
                text: qsTr("Theme:");
                color: Material.accent;
                font.pointSize: 14;
            }

            ComboBox {
                id: themeCmb;
                Layout.fillWidth: true;
            }
        }
    }

    Connections {
        target: themes;
        onThemeIndexChanged: themeSetting.updateStyle();
    }
}
