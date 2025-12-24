import QtQuick
import QtQuick.Controls



Switch {
    id: control

    property color corAtivo: "#17a81a"
    property color corInativo: "#fff"


    indicator: Rectangle {
        implicitWidth: 48
        implicitHeight: 20
        x: control.leftPadding  // Switch coloca padding para o teto automaticamente
        y: parent.height / 2 - height / 2
        radius: 5
        color: control.checked ? control.corAtivo : control.corInativo
        border.color: control.checked ? control.corAtivo : "#cccccc"

        Rectangle {
            x: control.visualPosition * (parent.width - width)
            width: 24
            height: parent.height
            radius: parent.radius
            color: control.down ? "#cccccc" : "#ffffff"
            border.color: control.checked ? (control.down ? "#17a81a" : "#21be2b") : "#999999"

            Behavior on x {
                NumberAnimation {
                    duration: control.down ? 0 : 200
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: control.down ? "#17a81a" : "#21be2b"
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.NoButton
    }
}