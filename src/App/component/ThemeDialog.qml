import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Controls.Universal 2.2

import an.qt.StyleSetting 1.0

Dialog {
    id: themeDialog
    x: -width/2;
    y: -height/2;
    modal: true;
    focus: true;
    title: qsTr("Theme");

    StyleSetting{
        id: styleSetting;

        property color accentColor1;
        property color primaryColor1;
        property color foregroundColor1;
        property color backgroundColor1;

        property color accentColor2;
        property color primaryColor2;
        property color foregroundColor2;
        property color backgroundColor2;

        function updateStyle(){
            //附加属性在material中
            appWnd.Material.accent =
                    styleSetting.getThemeColor(styleSetting.themeIndex, StyleSetting.ACCENT);
            appWnd.Material.primary =
                    styleSetting.getThemeColor(styleSetting.themeIndex, StyleSetting.PRIMARY);
            appWnd.Material.foreground =
                    styleSetting.getThemeColor(styleSetting.themeIndex, StyleSetting.FORGROUND);
            appWnd.Material.background =
                    styleSetting.getThemeColor(styleSetting.themeIndex, StyleSetting.BACKGROUND);
        }

        Component.onCompleted: {
            //把系统的Materil不同Theme的颜色缓存下来，一遍在自定义改了颜色后能够恢复
            var origTheme =  appWnd.Material.theme;
            appWnd.Material.theme = Material.Light;

            styleSetting.setThemeColor(0, StyleSetting.ACCENT, appWnd.Material.accent );
            styleSetting.setThemeColor(0, StyleSetting.PRIMARY, appWnd.Material.primary );
            styleSetting.setThemeColor(0, StyleSetting.FORGROUND, appWnd.Material.foreground );
            styleSetting.setThemeColor(0, StyleSetting.BACKGROUND, appWnd.Material.background );

            appWnd.Material.theme = Material.Dark;

            styleSetting.setThemeColor(1, StyleSetting.ACCENT, appWnd.Material.accent );
            styleSetting.setThemeColor(1, StyleSetting.PRIMARY, appWnd.Material.primary );
            styleSetting.setThemeColor(1, StyleSetting.FORGROUND, appWnd.Material.foreground );
            styleSetting.setThemeColor(1, StyleSetting.BACKGROUND, appWnd.Material.background );

            appWnd.Material.theme = origTheme;

            styleBox.model = styleSetting.themeList;
            styleBox.currentIndex = styleSetting.themeIndex;
            updateStyle();
        }
    }

    standardButtons: Dialog.Ok | Dialog.Cancel
    onAccepted: {
        styleSetting.themeIndex = styleBox.currentIndex;
        styleSetting.updateStyle();
    }
    onRejected: {
        styleBox.currentIndex = styleBox.styleIndex
    }

    contentItem: ColumnLayout {
        id: settingsColumn
        spacing: 20

        RowLayout {
            spacing: 10

            Label {
                text: "Style:"
            }

            ComboBox {
                id: styleBox;
                property int styleIndex: -1
                Layout.fillWidth: true;
            }
        }

    }

}
