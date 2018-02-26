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
        id: myTheme;

        Component.onCompleted: {
            myTheme.updateStyle();
        }

        // 触发信号直接改变主题
        onThemeIndexChanged: {
            myTheme.updateStyle();
        }

        function updateStyle(){
            appWnd.Material.accent =
                    myTheme.color(ThemeSetting.ACCENT);
            appWnd.Material.primary =
                    myTheme.color(ThemeSetting.PRIMARY);
            appWnd.Material.foreground =
                    myTheme.color(ThemeSetting.FORGROUND);
            appWnd.Material.background =
                    myTheme.color(ThemeSetting.BACKGROUND);
        }
    }


    standardButtons: Dialog.Cancel;
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
                font.pixelSize: 14;
            }

            ComboBox {
                id: styleBox;
                Layout.fillWidth: true;

                Component.onCompleted: {
                    styleBox.model = myTheme.themeTypeList();
                    styleBox.currentIndex = myTheme.themeIndex;
                    // 这里是绑定,ComboBox索引改变触发themeIndexChanged信号
                    myTheme.themeIndex = Qt.binding(function() { return styleBox.currentIndex })
                }
            }
        }
    }
}
