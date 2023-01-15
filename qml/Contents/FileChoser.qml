import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.1

FileDialog {
    id:root
    title:qsTr("chose a QML file")
    visible: false
    nameFilters: ["QML FILE (*.qml)","ALL FILE (*)"] 
}

