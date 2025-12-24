import QtQuick
import QtQuick.Controls


ScrollBar {
    id: control
    visible: size < 1.0

    property color corBarra: '#9A9A9A'
    
    contentItem: Rectangle {
        implicitWidth: 6
        implicitHeight: 100
        radius: width / 2

        color: control.pressed ? control.corBarra.darker(1.4) : control.hovered ? control.corBarra.darker(1.2) : control.corBarra
    }
}