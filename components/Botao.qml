import QtQuick
import QtQuick.Controls


Button {
    id: control

    topPadding: 10
    bottomPadding: 10
    leftPadding: 20
    rightPadding: 20

    property color corNormal: "#fff"
    property color corHover: "#bababa"
    property color corClick: "#aaa"
    property color corTexto: "#000"

    background: Rectangle {
        anchors.fill: parent
        radius: 10

        border.width: 1
        border.color: Qt.darker(color, 1.2)


        color: control.down ? control.corClick :
               control.hovered ? control.corHover :
               control.corNormal

        Behavior on color {
            ColorAnimation {
                duration: control.pressed ? 0 : 200
                easing.type: Easing.InOutQuad
            }
        }
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