from PySide6.QtCore import QThread, Signal
from PIL import Image
from pathlib import Path
from math import ceil
import os



class ColocarLogoThread(QThread):
    erro = Signal(str)
    finalizado = Signal(bool)
    progresso = Signal(int)

    def __init__(
            self,
            relx: float,
            rely: float,
            tam_logo: float,
            lista_imagens: list,
            path_logo: str,
            substituir: bool = False,
        ):
        super().__init__()

        self.relx = relx
        self.rely = rely
        self.tam_logo = tam_logo
        self.lista_imagens = lista_imagens
        self.path_logo = path_logo
        self.substituir = substituir

    def _limpar_path(self, path: str):
        if path.startswith("file:///"): return path[8:]
        elif path.startswith("file://"): return path[7:]
        return path

    def run(self):
        try:
            # Abrir  a logo python
            path_logo = Path(self._limpar_path(self.path_logo))
            logo_original = Image.open(path_logo).convert("RGBA")

            w_logo_orig, h_logo_orig = logo_original.size
        
            # passar entre as imagens:
            for cont, path_imagem in enumerate(self.lista_imagens):

                path_imagem = Path(self._limpar_path(path_imagem))

                imagem_original = Image.open(path_imagem).convert("RGBA")

                w_imagem, h_imagem = imagem_original.size
                
                # -------- Definindo tamanaho da logo ---------
                ehHorizontal = w_logo_orig > h_logo_orig
                fator = self.tam_logo / 100

                if ehHorizontal:
                    novo_w = int(w_imagem * fator)
                    ratio = novo_w / w_logo_orig
                    novo_h = h_logo_orig * ratio

                else:
                    novo_h = int(h_imagem * fator)
                    ratio = novo_h / h_logo_orig
                    novo_w = w_logo_orig * ratio

                logo_redim = logo_original.resize((int(novo_w), int(novo_h)), Image.Resampling.LANCZOS)
                

                # -------- Posicionar Logo ---------
                w_logo_redim, h_logo_redim = logo_redim.size

                lim_x = w_imagem - w_logo_redim
                lim_y = h_imagem - h_logo_redim
                pos_x = int(lim_x * self.relx)
                pos_y = int(lim_y * self.rely)

                imagem_original.paste(logo_redim, (pos_x, pos_y), logo_redim)

                # -------- Reconverter Imagem JPEG ---------
                if path_imagem.suffix.lower() in [".jpg", ".jpeg"]:
                    imagem_original = imagem_original.convert("RGB")
                
                # -------- Salvar Imagem ---------
                if self.substituir:
                    imagem_original.save(str(path_imagem), quality=95)
                else:
                    imagem_original.save(
                        f"{path_imagem.parent}{os.sep}{path_imagem.stem}_comlogo{path_imagem.suffix.lower()}", quality=95
                    )
                
                self.progresso.emit(ceil((cont + 1) / len(self.lista_imagens) * 100))
                
            self.finalizado.emit(True)

        except Exception as erro:
            self.erro.emit(str(erro))
