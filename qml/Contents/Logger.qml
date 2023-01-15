import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
ScrollView {
    id: root

    property alias textColor: ta_logger.color
    property alias backgoundColor: bg.color
    property alias border: bg.border

    function debug(msg){
        ta_logger.append(msg)
    }
    function error(msg){
        ta_logger.append(`<em style="color:red">error: ${msg}</em>`)
    }
    function info(msg,color="blue") {
        let str = `${(new Date()).toTimeString().split(' ')[0]}: ${msg}`;
        ta_logger.append(`<p style='color:${color};'>${str}</p>`);
    }
    function clear() {
        ta_logger.text=""
    }
    TextArea {
        id: ta_logger
        background: Rectangle {
            id:bg
            radius: 2
        }
        textFormat: TextEdit.RichText
        wrapMode: "Wrap"
        selectByMouse: true
        readOnly: true
        onTextChanged: root.scrollToButtom()
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
            onClicked: menu.popup()

            Menu {
                id: menu
//                Action{
//                    text: qsTr("Copy")
//                    onTriggered:{ ta_logger.copy()}
//                }
                Action {
                    text: qsTr("Clear All")
                    onTriggered: root.clear()
                }            }
        }
    }
    function scrollToButtom() {
        root.ScrollBar.vertical.position = 1 - root.ScrollBar.vertical.size;
    }
}
