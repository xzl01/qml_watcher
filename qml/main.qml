import QtQuick 2.11
import QtQuick.Window 2.11
//import QtQuick.Controls 1.4  as Ctrl1
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11

import "Contents"
import "Basic"
ApplicationWindow {
    id: window
    visible: true
    flags: Qt.Window | Qt.WindowSystemMenuHint
            | Qt.WindowTitleHint | Qt.WindowMinimizeButtonHint
            | Qt.WindowMaximizeButtonHint | Qt.WindowCloseButtonHint
            | Qt.WindowStaysOnTopHint //置顶
    width: 600
    height: 800
    title: qsTr("Qml watcher")

    ThemeConfig {
        id:theme
    }

    background: Rectangle {
        color:theme.primaryColor
    }

    FileChoser {
        id: qmlFileChoser
        onAccepted: {
            mainQmlInput.text=fileUrls[0];
            start();
        }
    }

    menuBar: MenuBar {
        Menu {
            title:qsTr("File")
            Action {
                text:qsTr("OpenFile")
                onTriggered: {
                    qmlFileChoser.open();
                }
            }
            MenuSeparator{}
            Action {
                text:qsTr("Quit")
                onTriggered: window.close()
            }
        }
        Menu {
            title:qsTr("&Settings")
            Menu {
                title: qsTr("Themes")

                Action {
                    text:theme.themeList.get(0).name
                    onTriggered: {
                        theme.curTheme=0;
                    }
                }
                Action {
                    text:theme.themeList.get(1).name
                    onTriggered: {
                        theme.curTheme=1;
                    }
                }
                //                Repeater {
                //                    model:theme.themeList
                //                    Action {
                //                        text:  model.name
                //                        onTriggered: {
                //                            theme.curTheme=model.index
                //                        }
                //                    }
                //                }
            }
        }
    }
    function start() {
        if(mainQmlInput.text.length>0)
        {
            let path = $Engine.setQmlPath(mainQmlInput.text);//监视 置顶目录
            logger.info(`load qmlfile : ${path}`);
            loader.winFlags=window.flags
            loader.load(`file:///${path}`);
        }
    }
    function reload() {
        logger.info("Reloading ...")
        loader.winFlags=window.flags
        loader.reload();
    }


    //主界面 布局
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 5
        //工具栏
        RowLayout {
            Layout.fillWidth: true
            TextField {
                id: mainQmlInput
                Layout.fillWidth: true
                placeholderText: qsTr("Double click to select main qml file")
                selectByMouse: true
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        mainQmlInput.focus=true
                    }
                    onDoubleClicked: {
                        qmlFileChoser.open();
                    }
                }
            }
            Button {
                text: qsTr("Load")
                onClicked:{
                    start();
                }
            }
        }
        //页面分割器
        SplitView {
            id:sv
            Layout.topMargin: 10
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: Qt.Vertical
            handle: Rectangle {
                implicitWidth: 4
                implicitHeight: 10
                color:"transparent"
            }
            //qml加载页面
            XGroupBox {
                SplitView.fillWidth: true
                SplitView.fillHeight: true
                SplitView.preferredHeight: parent.height/4*3
                title:qsTr("Qml Live")
                titleTextColor: theme.textColor
                color:theme.primaryColor
                border.color:theme.secondaryColor
                QmlLiveLoader {
                    id:loader
                    anchors.fill: parent
                    color:theme.primaryColor
                    textColor: theme.textColor
                    border.color:theme.thirdaryColor
                    text: qsTr("Drop qmlfile here to start Live")
                    DropArea {
                        anchors.fill: parent
                        onDropped: {
                            if (drop.hasUrls) {
                                mainQmlInput.text=drop.urls[0];
                                start();
                            }
                        }
                    }

                }
            }
            //日志输出
            XGroupBox {
                SplitView.fillHeight: true
                SplitView.fillWidth: true
                SplitView.preferredHeight: parent.height/4

                title:qsTr("Logger")
                border.color:theme.thirdaryColor
                titleTextColor: theme.textColor
                color:theme.primaryColor
                Logger {
                    id:logger
                    anchors.margins: 5
                    anchors.fill: parent
                    objectName: "logger"
                    backgoundColor: theme.primaryColor
//                    border.color:  theme.thirdaryColor
                    textColor: theme.textColor
                }
            }
        }
    }
}
