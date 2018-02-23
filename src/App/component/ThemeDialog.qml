import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Controls.Universal 2.2

import an.qt.ThemeSetting 1.0

Dialog {
    id: themeDialog
    x: -width/2;
    y: -height/2;
    modal: true;
    focus: true;
    title: qsTr("Theme");

    ThemeSetting{
        id: themeSetting;

        property color accentColor1;
        property color primaryColor1;
        property color foregroundColor1;
        property color backgroundColor1;

        property color accentColor2;
        property color primaryColor2;
        property color foregroundColor2;
        property color backgroundColor2;

        Component.onCompleted: {
            //把系统的Materil不同Theme的颜色缓存下来，以便在自定义改了颜色后能够恢复
            var origTheme =  appWnd.Material.theme;
            appWnd.Material.theme = Material.Light;

            themeSetting.setThemeColor(0, ThemeSetting.ACCENT, appWnd.Material.accent );
            themeSetting.setThemeColor(0, ThemeSetting.PRIMARY, appWnd.Material.primary );
            themeSetting.setThemeColor(0, ThemeSetting.FORGROUND, appWnd.Material.foreground );
            themeSetting.setThemeColor(0, ThemeSetting.BACKGROUND, appWnd.Material.background );

            appWnd.Material.theme = Material.Dark;

            themeSetting.setThemeColor(1, ThemeSetting.ACCENT, appWnd.Material.accent );
            themeSetting.setThemeColor(1, ThemeSetting.PRIMARY, appWnd.Material.primary );
            themeSetting.setThemeColor(1, ThemeSetting.FORGROUND, appWnd.Material.foreground );
            themeSetting.setThemeColor(1, ThemeSetting.BACKGROUND, appWnd.Material.background );

            appWnd.Material.theme = origTheme;

            styleBox.model = themeSetting.themeList;
            styleBox.currentIndex = themeSetting.themeIndex;
            updateStyle();
        }

        //这个函数更新窗口风格
        function updateStyle(){
            //附加属性在material中
            appWnd.Material.accent =
                    themeSetting.getThemeColor(themeSetting.themeIndex, ThemeSetting.ACCENT);
            appWnd.Material.primary =
                    themeSetting.getThemeColor(themeSetting.themeIndex, ThemeSetting.PRIMARY);
            appWnd.Material.foreground =
                    themeSetting.getThemeColor(themeSetting.themeIndex, ThemeSetting.FORGROUND);
            appWnd.Material.background =
                    themeSetting.getThemeColor(themeSetting.themeIndex, ThemeSetting.BACKGROUND);
        }
    }//End of ThemeSetting

    standardButtons: Dialog.Ok | Dialog.Cancel
    onAccepted: {
        themeSetting.themeIndex = styleBox.currentIndex;
        themeSetting.updateStyle();
    }
    onRejected: {
        styleBox.currentIndex = themeSetting.themeIndex;
        themeDialog.close();
    }

    contentItem: ColumnLayout {
        spacing: 20;

        RowLayout {
            spacing: 10;

            Label {
                text: qsTr("Style:");
            }

            ComboBox {
                id: styleBox;
                property int styleIndex: -1
                Layout.fillWidth: true;
            }
        }
    }

}
