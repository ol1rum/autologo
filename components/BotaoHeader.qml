import QtQuick
import QtQuick.Controls


ToolButton {
    id: control
    
    topPadding: 5
    bottomPadding: 5
    leftPadding: 10
    rightPadding: 10

    property color corNormal: "transparent"
    property color corHover: "#bababa"
    property color corClick: "#aaa"
    property color corTexto: "#000"

    background: Rectangle {
        anchors.fill: parent
        
        color: control.down ? control.corClick :
               control.hovered ? control.corHover :
               control.corNormal
        }

    contentItem: Text {
        text: control.text
        font: control.font
        color: control.corTexto

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        elide: Text.ElideRight  // corta texto caso não tenha espaço suficiente
    }

    MouseArea {
        id: areaBotao
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.NoButton
    }
}