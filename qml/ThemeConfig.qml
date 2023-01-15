import QtQuick 2.15
import QtQml.Models 2.15
//全局主题配置
QtObject {
    id:root
    property color primaryColor: "#2e2f30"
    property color secondaryColor: "#1f1f1f"
    property color thirdaryColor:"#f8f8FF"
    property color textColor: "white"
    property int  curTheme: 0

    onCurThemeChanged: {
        let t=themeList.get(curTheme);
        root.primaryColor=t.primaryColor;
        root.secondaryColor=t.secondaryColor;
        root.thirdaryColor=t.thirdaryColor;
        root.textColor=t.textColor;
    }

    readonly property ListModel themeList: ListModel {
        ListElement {
            name:qsTr("Drak")
            primaryColor: "#2e2f30"
            secondaryColor: "#1f1f1f"
            thirdaryColor:"#f8f8ff"
            textColor: "white"
        }
        ListElement {
            name:"Light"
            primaryColor: "white"
            secondaryColor: "gray"
            thirdaryColor:"#000"
            textColor: "black"
        }
    }

}
