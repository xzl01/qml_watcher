import QtQuick 2.0
import QtQuick.Window 2.0
Rectangle {
    id:root

    property alias text:tip.text
    property alias textColor:tip.color
    property int winFlags: Qt.Window | Qt.WindowSystemMenuHint
                   | Qt.WindowTitleHint | Qt.WindowMinimizeButtonHint
                   | Qt.WindowMaximizeButtonHint | Qt.WindowCloseButtonHint
                   | Qt.WindowStaysOnTopHint
     property bool isLoadedWin: false//加载的是否是窗口
    Text {
        id:tip
        anchors.centerIn: parent
        font.pixelSize:24

    }
    Loader {
        id: loader
        asynchronous: true
//        anchors.fill:parent
        anchors.centerIn: parent
        onLoaded: {
            tip.visible=false
            //对加载窗口进进行处理
            root.visible= loader.item instanceof Item;
            root.isLoadedWin=! root.visible;
            if(root.isLoadedWin){
                loader.item.flags = root.winFlags
            }
        }
    }



    function load(sourceUrl) {
        loader.source = "";
        $Engine.clearCache();
        loader.setSource(sourceUrl);
    }

    //重新加载时 应该记录窗口原来的大小
    property size winSize:Qt.size(100,100)
    property point winPos: Qt.point(0,0)
    function reload(){
        let	s = loader.source;
        if(root.isLoadedWin&&loader.status === Loader.Ready)
        {
            winPos.x = loader.item.x;
            winPos.y = loader.item.y;
            winSize.width = loader.item.width;
            winSize.height = loader.item.height;
        }
        loader.source = "";
        $Engine.clearCache();
        if(root.isLoadedWin)
            loader.setSource(s, {"flags": winFlags, "x": winPos.x, "y": winPos.y, "width": winSize.width, "height": winSize.height});
        else
            loader.setSource(s);
    }


}
