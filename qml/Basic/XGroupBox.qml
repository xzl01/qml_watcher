import QtQuick 2.0

import QtQuick.Layouts 1.15

Rectangle {
    id:root
    property alias title: _title.text
    property alias titleTextColor: _title.color

    anchors.topMargin:_title.height
    Layout.topMargin:_title.height/2
    implicitHeight:50
    implicitWidth:50
    border.color: "black"
    radius: 5
    Rectangle {
        z:2
        x:20
        color:root.color
        height: _title.height
        width:_title.width
        anchors.top: parent.top
        anchors.topMargin: -_title.height/2
        anchors.bottomMargin: _title.height
        Text {
            id: _title
            font.pixelSize: 14
        }
    }
}
