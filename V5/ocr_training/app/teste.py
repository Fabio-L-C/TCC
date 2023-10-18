# -*- coding: utf-8 -*-
import numpy as np
import cv2
from tensorflow.keras.models import load_model
from imutils.contours import sort_contours
import imutils

def teste(caminho_imagem, modelo_path='src/modelo/rede_neural'):
    """# Carregando a rede neural"""

    rede_neural = load_model(modelo_path)

    """# Carregando a imagem de teste"""

    img = cv2.imread(caminho_imagem)
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    """# Pré-processamento da imagem"""

    desfoque = cv2.GaussianBlur(gray, (3,3), 0)

    adapt_media = cv2.adaptiveThreshold(desfoque, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 11, 9)

    inv = 255 - adapt_media

    dilatado = cv2.dilate(inv, np.ones((3,3)))

    bordas = cv2.Canny(desfoque, 40, 150)

    dilatado = cv2.dilate(bordas, np.ones((3,3)))

    """# Detecção de contornos"""

    def encontrar_contornos(img):
      conts = cv2.findContours(img, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
      conts = imutils.grab_contours(conts)
      conts = sort_contours(conts, method='left-to-right')[0]
      return conts

    conts = encontrar_contornos(dilatado.copy())

    conts

    l_min, l_max = 4, 160
    a_min, a_max = 14, 140

    caracteres = []
    img_cp = img.copy()
    for c in conts:
      (x, y, w, h) = cv2.boundingRect(c)
      if (w >= l_min and w <= l_max) and (h >= a_min and h <= a_max):
        roi = gray[y:y+ h, x:x + w]
        thresh = cv2.threshold(roi, 0, 255, cv2.THRESH_BINARY_INV | cv2.THRESH_OTSU)[1]
        cv2.rectangle(img_cp, (x, y), (x + w, y + h), (255, 100, 0), 2)

    """# Processando os caracteres detectados

    ## Extração ROI
    """

    def extra_roi(img):
      roi = img[y:y + h, x:x + w]
      return roi

    """## Limiarização"""

    def limiarizacao(img):
      thresh = cv2.threshold(img, 0, 255, cv2.THRESH_BINARY_INV | cv2.THRESH_OTSU)[1]
      return thresh

    """## Redimensionamento"""

    def redimensiona_img(img, l, a):
      if l > a:
        redimensionada = imutils.resize(img, width=28)
      else:
        redimensionada = imutils.resize(img, height=28)

      (a, l) = redimensionada.shape
      dX = int(max(0, 28 - l) / 2.0)
      dY = int(max(0, 28 - a) / 2.0)

      preenchida = cv2.copyMakeBorder(redimensionada, top=dY, bottom=dY, right=dX, left=dX, borderType=cv2.BORDER_CONSTANT, value=(0,0,0))
      preenchida = cv2.resize(preenchida, (28, 28))
      return preenchida

    (x, y, w, h) = cv2.boundingRect(conts[6])
    img_teste = limiarizacao(gray[y:y+h, x:x+w])
    (a, l) = img_teste.shape
    img_teste2 = redimensiona_img(img_teste, l, a)
    img_teste2.shape

    """## Normalização"""

    def normalizacao(img):
      img = img.astype('float32') / 255.0
      img = np.expand_dims(img, axis=-1)
      return img

    img_teste2.shape, normalizacao(img_teste2).shape

    """## Processamento das detecções"""

    def processa_caixa(gray, x, y, w, h):
      roi = extra_roi(gray)
      limiar = limiarizacao(roi)
      (a, l) = limiar.shape
      redimensionada = redimensiona_img(limiar, l, a)
      normalizada = normalizacao(redimensionada)
      caracteres.append((normalizada, (x, y, w, h)))

    for c in conts:
      (x, y, w, h) = cv2.boundingRect(c)
      if (w >= l_min and w <= l_max) and (h >= a_min and h <= a_max):
        processa_caixa(gray, x, y, w, h)

    caracteres[0]

    caixas = [caixa[1] for caixa in caracteres]
    caixas

    caracteres = np.array([c[0] for c in caracteres], dtype='float32')

    caracteres

    """# Reconhecimento dos caracteres"""

    numeros = "0123456789"
    letras = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    lista_caracteres = numeros + letras
    lista_caracteres = [l for l in lista_caracteres]

    print(lista_caracteres)

    caracteres[0].shape

    caracteres.shape

    previsoes = rede_neural.predict(caracteres)

    previsoes

    previsoes.shape

    caixas

    img_cp = img.copy()
    for (previsoes, (x, y, w, h)) in zip(previsoes, caixas):
      i = np.argmax(previsoes)
      probabilidade = previsoes[i]
      caractere = lista_caracteres[i]

      cv2.rectangle(img_cp, (x, y), (x + w, y + h), (255,100,0), 2)
      cv2.putText(img_cp, caractere, (x - 10, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 1.1, (0,0,255), 2)
      print(caractere, ' -> ', probabilidade * 100)

    def extrai_roi(img, margem=2):
      roi = img[y - margem:y + h + margem, x - margem:x + w + margem]
      return roi

    conts = encontrar_contornos(dilatado.copy())
    caracteres = []
    for c in conts:
      (x, y, w, h) = cv2.boundingRect(c)
      if (w >= l_min and w <= l_max) and (h >= a_min and h <= a_max):
        processa_caixa(gray, x, y, w, h)

    caixas = [b[1] for b in caracteres]
    caracteres = np.array([c[0] for c in caracteres], dtype="float32")
    previsoes = rede_neural.predict(caracteres)

    texto_reconhecido = ''
    for (previsoes, (x, y, w, h)) in zip(previsoes, caixas):
      i = np.argmax(previsoes)
      probabilidade = previsoes[i]
      caractere = lista_caracteres[i]

      # Adicionando o caractere reconhecido à string de texto
      texto_reconhecido += caractere

    return texto_reconhecido


if __name__ == '__main__':
    # Testando a função com um exemplo
    caminho_imagem = 'src/img/1.png'
    texto = teste(caminho_imagem)

    # Imprimindo o texto reconhecido
    print(texto)