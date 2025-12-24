import QtQuick
import QtQuick.Controls


Slider {
    id: root

    property color corTrilho: "#efefef"
    property color corTrilhoAtivo: "#17a81a"
    
    
    background: Rectangle {  // trilho
        id: trilho
        implicitWidth: 200
        implicitHeight: 6
        
        width: root.availableWidth
        height: implicitHeight
        radius: 3

        x: root.leftPadding
        y: root.height / 2 - height / 2

        color: root.corTrilho
        border.color: root.corTrilho.lighter(1.2)
        border.width: 1

        Rectangle {  // barra preenchida
            id: barraPreenchida
            width: root.visualPosition * root.availableWidth
            height: trilho.height

            color: root.corTrilhoAtivo
            radius: trilho.radius
        }
    }

    handle: Rectangle { // Handle
        id: handle

        x: root. leftPadding + root.visualPosition * (root.availableWidth - width)
        y: root.height / 2 - height / 2  // centro

        width: 10
        height: trilho.height * 4
        radius: 3

        scale: root.pressed ? 1.2 : 1.0

        Behavior on scale {
            NumberAnimation {
                duration: root.pressed ? 0 : 200
                easing.type: Easing.InOutQuad            
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.NoButton
    }
}