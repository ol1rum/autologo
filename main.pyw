import sys, json
from pathlib import Path
from PySide6.QtWidgets import QApplication
from PySide6.QtGui import QIcon
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import Slot, QObject, Signal
from PySide6.QtQuickControls2 import QQuickStyle
from processamento import ColocarLogoThread



class Backend(QObject):
    atualizarProgresso = Signal(int)
    finalizado = Signal(bool)
    error = Signal(str)

    ARQUIVO_CONFIG = Path(__file__).parent.joinpath("config.json")

    def __init__(self):
        super().__init__()
        self.worker = None

    @Slot(result=dict)
    def carregarConfig(self):
        if not self.ARQUIVO_CONFIG.exists():
            return {}
        try:
            with open(self.ARQUIVO_CONFIG, "r") as f:
                return json.load(f)
        except:
            return {}
    
    @Slot(str, float, float, float, bool)
    def salvarConfig(self, path_logo, tam_logo, relx, rely, substituir):
        with open(self.ARQUIVO_CONFIG, "w") as f:
            json.dump({
                "path_logo": path_logo,
                "tam_logo": tam_logo,
                "relx": relx,
                "rely": rely,
                "substituir": substituir
            }, f, indent=4)

    @Slot(float, float, float, list, str, bool)
    def colocarLogo(
        self,
        relx: float,
        rely: float,
        tam_logo: float,
        lista_imagens: list,
        path_logo: str,
        substituir: bool = False
    ):
        self.worker = ColocarLogoThread(relx, rely, tam_logo, lista_imagens, path_logo, substituir)

        self.worker.progresso.connect(self.atualizarProgresso.emit)
        self.worker.finalizado.connect(self.finalizado.emit)
        self.worker.erro.connect(self.error.emit)
        self.worker.erro.connect(print)

        self.worker.start()
            


if __name__ == '__main__':
    app_dir = Path(__file__).parent.absolute()

    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # -------- Configurações Visuais -a--------
    QQuickStyle.setStyle("Basic")
    app.setWindowIcon(QIcon(str(app_dir / "imgs" / "icone_autologo.ico")))

    # -------- Conexão do qml com python ---------
    backend = Backend()
    engine.rootContext().setContextProperty("ponte", backend)

    engine.load(app_dir / "main.qml")

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())
