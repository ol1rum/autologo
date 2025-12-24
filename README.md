# 🎨 AutoLogo

**AutoLogo** é uma aplicação desktop desenvolvida para automatizar a inserção de logotipos e marcas d'água em imagens. Diferente de soluções simples baseadas em scripts, o AutoLogo oferece uma interface gráfica moderna, preview em tempo real e processamento otimizado.

![Demonstração do AutoLogo](https://github.com/user-attachments/assets/edbaa0d4-4ec9-4536-b9e3-71892fe05dd6)

## ✨ Funcionalidades

* **Interface Moderna (QML):** Design fluido com animações suaves e tema escuro.
* **Memória de Configuração:** O app salva automaticamente a última logo utilizada, sua posição exata e tamanho, permitindo retomar o trabalho exatamente de onde parou.
* **Drag & Drop:** Arraste e solte imagens diretamente da pasta para o aplicativo com feedback visual.
* **Preview em Tempo Real:** Posicione a logo visualmente arrastando-a sobre a imagem e ajuste o tamanho com slider.
* **Processamento em Lote:** Aplique a marca d'água em centenas de fotos de uma vez sem travar a interface (Multithreading).
* **Qualidade Profissional:** Utiliza a biblioteca `Pillow` com reamostragem *Lanczos* para redimensionamento de alta qualidade e preservação de transparência (PNG).
* **Smart State:** O botão de ação transforma-se numa barra de progresso para feedback visual imediato.

## 🛠️ Tecnologias Utilizadas

* **Linguagem:** Python 3.12+
* **GUI:** PySide6 (Qt for Python) + QML
* **Processamento de Imagem:** Pillow (PIL)
* **Estrutura:** Separação completa entre Frontend (QML), Backend (Python) e Workers (QThreads).

## 🚀 Como Rodar

### Pré-requisitos
* Python 3.x instalado.

### Instalação

1.  Clone o repositório:
    ```bash
    git clone https://github.com/ol1rum/autologo
    cd autologo
    ```

2.  Instale as dependências:
    ```bash
    pip install -r requirements.txt
    ```

3.  Execute a aplicação:
    ```bash
    python autologo/main.pyw
    ```
    *(Nota: A extensão .pyw executa o programa sem abrir o terminal da consola no Windows)*

## 📦 Como Criar o Executável (.exe)

Se desejar distribuir o aplicativo, utilize o PyInstaller:

```bash
pyinstaller --noconsole --onefile --icon="autologo/imgs/icone_autologo.ico" --add-data "autologo/main.qml;." --add-data "autologo/imgs;imgs" --add-data "autologo/components;components" autologo/main.pyw
```

## ❤️ Agradecimentos

Um agradecimento especial ao meu pai, a grande inspiração para este projeto. Esta ferramenta foi criada para automatizar o seu trabalho e, com sorte, reformar finalmente o uso do Microsoft Paint no escritório! 😂

---
*Desenvolvido por Murilo*
