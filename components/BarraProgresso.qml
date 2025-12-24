import QtQuick 2.12
import QtQuick.Controls 2.12

ProgressBar {
    id: control
    value: 0.5
    padding: 2
    height: 20
    width: 200

    property color corFundo: "#e6e6e6"
    property color corProgresso: "#008707"
    property color corTexto: "white"
    property int radius: 5

    // fundo
    background: Rectangle {
        implicitWidth: parent.width
        implicitHeight: parent.height
        color: control.corFundo
        border.color: control.corFundo.lighter(1.2)
        border.width: 1
        radius: control.radius
    }

    // progresso
    contentItem: Item {
        implicitWidth: parent.width
        implicitHeight: parent.height

        // barra preenchida
        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            radius: control.radius
            color: control.corProgresso

            // Progesso fluido
            Behavior on width {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // porcentagem
        Text {
            anchors.centerIn: parent

            text: parseInt(control.visualPosition * 100)  + "%"
            font.bold: true
            color: control.corTexto
            font.pixelSize: 12

            // Sombra
            style: Text.Outline
            styleColor: "black"

        }
    }
}