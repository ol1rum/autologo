// pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import "components"

ApplicationWindow {
    id: main
    title: "AutoLogo"
    width: 900
    height: 600
    visible: true
    color: "#222222"
    visibility: Window.Maximized

    property var configSalva: null

    // Splash Screen
    Rectangle {
        id: cortina
        anchors.fill: parent
        color: "#222222"
        z: 999
        visible: true

        function abrirCortina() {
            timercortina.start()
        }

        Image{
            source: "./imgs/logo_autologo.png"
            anchors.centerIn: parent
            width: 850
            height: 400
            fillMode: Image.PreserveAspectFit
        }

        NumberAnimation {
            id: animacaoSumir
            target: cortina
            property: "opacity"

            to: 0
            duration: 500
            easing.type: Easing.InOutQuad

            onFinished: cortina.visible = false
        }

        Timer {
            id: timercortina
            interval: 1000
            repeat: false
            onTriggered: animacaoSumir.start()
        }
    }

    Component.onCompleted: {  // Carregar configurações após a pagina toda estiver carregada
        configSalva = ponte.carregarConfig()

        if (configSalva) {
            if (configSalva.path_logo) {
                logo.source = configSalva.path_logo
            }
            if (configSalva.tam_logo !== undefined) {
                tamanhoLogo.value = configSalva.tam_logo
            }
            if (configSalva.substituir !== undefined) {
                substituirFoto.checked = configSalva.substituir
            }
            if (configSalva.relx && configSalva.relx !== undefined && configSalva.rely !== undefined) {
                logo.memoriaX = configSalva.relx
                logo.memoriaY = configSalva.rely
            }
        }

        cortina.abrirCortina()
    }

    onClosing: {  // Salvar após fechar a janela
        ponte.salvarConfig(logo.source, tamanhoLogo.value, logo.memoriaX, logo.memoriaY, substituirFoto.checked)
    }
    
    ListModel {
        id: modeloImagens
    }

    FileDialog {
        id: seletorImagens
        title: "Selecione as imagens"
        fileMode: FileDialog.OpenFiles
        nameFilters: ["Imagens (*.png *.jpg *.jpeg)"]

        onAccepted: {
            for (var i = 0; i < selectedFiles.length; i++) {
                var urlArquivo = selectedFiles[i].toString()

                modeloImagens.append({
                    "caminho": urlArquivo,
                })
            }
            previewImage.source = modeloImagens.get(0).caminho
        }
    }

    FileDialog {
        id: seletorLogo
        title: "Selecione a logo"
        fileMode: FileDialog.OpenFiles
        nameFilters: ["Imagens (*.png *.jpg *.jpeg)"]

        onAccepted: {
            var urlArquivo = selectedFiles[0].toString()
            logo.source = urlArquivo
        }
    }

    // Are apara soltar imagens seguradas
    DropArea {
        id: droparea
        anchors.fill: parent
        keys: ["text/uri-list"]

        onDropped: (drop) => {
            if (drop.hasUrls) {
                for (var i = 0; i < drop.urls.length; i++) {
                    var urlArquivo = drop.urls[i].toString()
                    var extensao = urlArquivo.split('.').pop().toLowerCase()
                    
                    // Filtro simples para garantir que é imagem
                    if (["jpg", "jpeg", "png"].indexOf(extensao) !== -1) {
                        modeloImagens.append({
                            "caminho": urlArquivo
                        })
                    }
                previewImage.source = modeloImagens.get(0).caminho
                }   
            }
        }
    }

    Rectangle {
        id: overlayDrag
        anchors.fill: parent
        color: '#7d111111'
        visible: droparea.containsDrag
        z: 999

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 10

            Text{
                text: "📂"
                font.pixelSize: 80
                Layout.alignment: Qt.AlignCenter
            }
            Text {
                text: "Solte as imagens aqui"
                font.pixelSize: 20
                color: "white"
                Layout.alignment: Qt.AlignCenter
                font.bold: true
            }
        }
    }

    // Interface do app
    header: ToolBar {
        height: 30

        RowLayout {
            anchors.fill: parent

            BotaoHeader {
                id: addimg
                text: "Adicionar Imagens"
                Layout.fillHeight: true

                onClicked: {
                    seletorImagens.open()
                }
            }
            BotaoHeader {
                id: alterarlogo
                text: "Alterar Logo"
                Layout.fillHeight: true

                onClicked: {
                    seletorLogo.open()
                }
            }

            Item { Layout.fillWidth: true }

            BotaoHeader {
                id: limpar
                text: "Limpar"
                Layout.fillHeight: true

                onClicked: {
                    modeloImagens.clear()
                    previewImage.source = ""
                }
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        
        Rectangle { // Lista de imagens
            Layout.fillHeight: true
            Layout.preferredWidth: 270

            color: "#333"

            ListView {
                id: listaVisual
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5
                clip: true
                pixelAligned: true


                property real targetY: contentY
                property Item refPreview: previewImage

                onContentYChanged: {
                    if  (!animacaoScroll.running) {
                        targetY = contentY
                    }
                }

                ScrollBar.vertical: BarraScroll { id: barraVertical }

                model: modeloImagens

                delegate: Rectangle {
                    id: itemDelegate
                    width: ListView.view.width - 20
                    height: 140
                    color: "transparent"
                    radius: 5

                    required property var model
                    required property int index
                    
                    Image {
                        anchors.fill: parent
                        source: itemDelegate.model.caminho
                        fillMode: Image.PreserveAspectFit
                        sourceSize: Qt.size(250, 100)
                        asynchronous: true

                        ToolButton {
                            width: 30
                            height: width
                            text: "🗑️"
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.margins: 10
                            id: lixeira
                            

                            background: Rectangle {
                                color: lixeira.hovered ? "red" : "#333"
                                opacity: lixeira.hovered ? 0.8 : 0.4
                                radius: 5
                            }

                            onClicked: {
                                var imagemRemovida = itemDelegate.model.caminho
                                modeloImagens.remove(itemDelegate.index)

                                if (previewImage.source == imagemRemovida || modeloImagens.count === 0) {
                                    previewImage.source = modeloImagens.count > 0 ? modeloImagens.get(0).caminho : ""
                                }
                            }

                            

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                acceptedButtons: Qt.NoButton
                            }
                        }
                    }

                    

                    MouseArea {
                        anchors.fill: parent
                        z: -1
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            previewImage.source = itemDelegate.model.caminho
                        }
                    }
                }
                
                WheelHandler {
                    onWheel: (event) => {

                        var novoY = listaVisual.targetY - event.angleDelta.y * 1.5
                        
                        novoY = Math.max(0, Math.min(novoY, listaVisual.contentHeight - listaVisual.height))

                        listaVisual.targetY = novoY
                        listaVisual.contentY = novoY
                        event.accepted = true
                    }
                }

                Behavior on contentY {
                    enabled: !barraVertical.pressed
                    NumberAnimation {
                        id: animacaoScroll
                        duration: 250
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }

        
        ColumnLayout { // Preview das imagens e configurações
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 20


            Layout.margins: 20

            Rectangle {  // Area de preview da imagem
                id: previewArea
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "#333"

                border.width: 1
                border.color: "#444"
                radius: 10


                Text {
                    id: txtAguardandoImagem
                    anchors.centerIn: parent
                    text: modeloImagens.count > 0 ? "Carregando Imagem..." : "Adicione imagens para iniciar"
                    visible: previewImage.status !== Image.Ready
                    color: "white"
                    font.pixelSize: 20
                }

                Image {  // Imagem de preview
                    id: previewImage
                    anchors.fill: parent
                    source: ""
                    fillMode: Image.PreserveAspectFit
                    sourceSize: Qt.size(1920, 1920)
                    
                    mipmap: true
                    autoTransform: true
                    asynchronous: true
                }

                Rectangle {  // Area pintada
                    id: areaPintada
                    width: previewImage.paintedWidth
                    height: previewImage.paintedHeight
                    anchors.centerIn: parent
                    color: "transparent"
                    // border.color: "green"; border.width: 2

                    
                    Image {  //  Logo

                        // Configurações gerais
                        id: logo
                        source: ""
                        fillMode: Image.PreserveAspectFit
                        autoTransform: true
                        visible: previewImage.status === Image.Ready
                        
                        // propriedas
                        property bool ehHorizontal: implicitWidth > implicitHeight
                        property real porcentagem: tamanhoLogo.value / 100

                        property real memoriaX: 0.95
                        property real memoriaY: 0.95

                        property real espacoLivreX: areaPintada.width - width
                        property real espacoLivreY: areaPintada.height - height

                        // O X e Y agora são "vivos". Se areaPintada mudar, eles mudam na hora.
                        // Usamos 'memoriaX' como a porcentagem relativa (0.0 a 1.0)
                        x: (!mouseAreaLogo.drag.active) ? (espacoLivreX * memoriaX) : x
                        y: (!mouseAreaLogo.drag.active) ? (espacoLivreY * memoriaY) : y

                        // Quando arrastar, atualizamos a memória (ao soltar ou mover)
                        onXChanged: {
                            if (mouseAreaLogo.drag.active && espacoLivreX > 0) {
                                memoriaX = x / espacoLivreX
                            }
                        }
                        onYChanged: {
                            if (mouseAreaLogo.drag.active && espacoLivreY > 0) {
                                memoriaY = y / espacoLivreY
                            }
                        }

                        // Ajustar tamanho da logo
                        width: {
                            if (implicitWidth === 0 || implicitHeight === 0) return 50

                            if (ehHorizontal) {
                                return parent.width * porcentagem
                            } else {
                                var alturaDesejada = parent.height * porcentagem
                                return alturaDesejada * (implicitWidth / implicitHeight)
                            }
                        }
                        height: implicitWidth > 0 ? width * (implicitHeight / implicitWidth) : width

                        Rectangle {
                            anchors.fill: parent
                            color: "transparent"
                            border.color: "white"
                            border.width: 1
                            opacity: 0.5
                            visible: parent.status === Image.Ready
                        }

                        MouseArea {
                            id: mouseAreaLogo
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            
                            drag.target: parent
                            drag.axis: Drag.XAndYAxis

                            //  Definir limites
                            drag.minimumX: 0
                            drag.minimumY: 0
                            drag.maximumX: areaPintada.width - width
                            drag.maximumY: areaPintada.height - height

                            onPositionChanged: {
                                if (drag.active) {
                                    var espacoLivreX = areaPintada.width - width
                                    var espacoLivreY = areaPintada.height - height

                                    if (espacoLivreX > 0) { parent.memoriaX = logo.x / espacoLivreX } else { parent.memoriaX = 0 }
                                    if (espacoLivreY > 0) { parent.memoriaY = logo.y / espacoLivreY } else { parent.memoriaY = 0 }
                                }
                                if (parent.x > drag.maximumX) parent.x = drag.maximumX
                                if (parent.y > drag.maximumY) parent.y = drag.maximumY
                                if (parent.x < drag.minimumX) parent.x = drag.minimumX
                                if (parent.y < drag.minimumY) parent.y = drag.minimumY
                            }
                        }
                    }
                }
            }

            
            RowLayout {  // Ajustar tamanho da logo
                Layout.alignment: Qt.AlignCenter
                spacing: 40 

                Rectangle {
                    id: fundoGrupoTamanho
                    color: "#333"

                    border.width: 1
                    border.color: "#444"
                    radius: 10

                    implicitWidth: grupoTamanho.implicitWidth + 30
                    implicitHeight: 40

                    RowLayout {
                        id: grupoTamanho
                        spacing: 5
                        anchors.centerIn: parent

                        Label { text: "Tamanho da logo:"; color: "white"; font.pixelSize: 15 }
                        SliderQuadrado {
                            id: tamanhoLogo
                            from: 5
                            to: 100
                            value: 20
                        }
                    }
                }

                Rectangle { // Switch para substituir
                    id: fundoGrupoSubstituir
                    color: "#333"

                    border.width: 1
                    border.color: "#444"
                    radius: 10

                    implicitWidth: grupoSubstituir.implicitWidth + 30
                    implicitHeight: 40
                    
                    RowLayout {
                        id: grupoSubstituir
                        spacing: 5  
                        anchors.centerIn: parent

                        Label { text: "Substituir foto:"; color: "white"; font.pixelSize: 15 }
                        SwitchQuadrado {
                            id: substituirFoto
                        }
                    }
                }
            }
            Item {
                id: containerAcao
                // Layout.preferredWidth: expandido ? parent.width : 600
                Layout.preferredHeight: 50
                Layout.preferredWidth: main.contentItem.width - 250 - 40
                Layout.alignment: Qt.AlignCenter
                // Layout.fillWidth: true

                property bool estaProcessando: false
                state: estaProcessando ? "BARRA" : "BOTAO"

                states: [
                    State {
                        name: "BOTAO"
                        PropertyChanges {
                            target: containerAcao
                            Layout.preferredWidth: main.contentItem.width - 250 - 40
                        }
                    },
                    State {
                        name: "BARRA"
                        PropertyChanges {
                            target: containerAcao
                            Layout.preferredWidth: 600
                        }
                    }
                ]

                transitions: [
                    Transition {
                        from: "*"
                        to: "*"

                        NumberAnimation {
                            property: "Layout.preferredWidth"
                            duration: 500
                            easing.type: Easing.InOutQuad
                        }
                    }
                ]
                Botao {
                    anchors.fill: parent
                    id: iniciarProcesso
                    flat: true

                    text: "Colocar Logo"
                    font.bold: true
                    font.pixelSize: 15

                    visible: parent.estaProcessando === false

                    onClicked: {
                        if (modeloImagens.count === 0 ) {return}

                        parent.estaProcessando = true
                        barraProgresso.value = 0

                        var listaSimples = []
        
                        for (var i = 0; i < modeloImagens.count; i++) {
                            listaSimples.push(modeloImagens.get(i).caminho)
                        }

                        ponte.colocarLogo(
                            logo.memoriaX,
                            logo.memoriaY,
                            tamanhoLogo.value,
                            listaSimples,
                            logo.source.toString(),
                            substituirFoto.checked
                        )
                    }
                }

                BarraProgresso {
                    id: barraProgresso
                    anchors.fill: parent
                    radius: 10
                
                    visible: parent.estaProcessando

                    from: 0
                    to: 100
                    value: 0
                }

                Connections {
                    target: ponte

                    function onAtualizarProgresso(progresso) {
                        barraProgresso.value = progresso
                    }
                    function onFinalizado(sucesso) {
                        timerReset.start()
                    }
                    function onError(erro) {
                        console.error(erro)
                        containerAcao.estaProcessando = false
                    }
                }

                Timer {
                    id: timerReset
                    interval: 1000
                    onTriggered: parent.estaProcessando = false
                }
            }
        }
    }   
}
