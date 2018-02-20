import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Universal 2.1

Dialog {
    id: themeDialog
    x: -width/2;
    y: -height/2;
    focus: true
    title: "Theme";

    standardButtons: Dialog.Ok | Dialog.Cancel
    onAccepted: {
        settings.style = styleBox.displayText
        themeDialog.close()
    }
    onRejected: {
        styleBox.currentIndex = styleBox.styleIndex
        themeDialog.close()
    }

    contentItem: ColumnLayout {
        spacing: 20;
        RowLayout {
            spacing: 10;

            Label {
                text: "Style:";
            }
            ComboBox {
                id: styleBox;
                property int styleIndex: -1;
                model: availableStyles;
                Component.onCompleted: {
                    styleIndex = find(settings.style, Qt.MatchFixedString)
                    if (styleIndex !== -1)
                        currentIndex = styleIndex;
                }
                Layout.fillWidth: true;
            }
        }

        Label {
            text: "Restart required";
            color: "#e41e25";
            opacity: styleBox.currentIndex !== styleBox.styleIndex ? 1.0 : 0.0
            horizontalAlignment: Label.AlignHCenter;
            verticalAlignment: Label.AlignVCenter;
            Layout.fillWidth: true;
            Layout.fillHeight: true;
        }
    }
}
