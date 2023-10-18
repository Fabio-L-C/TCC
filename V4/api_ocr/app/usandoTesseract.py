import cv2
import numpy as np
import pytesseract


def ReconhecimentoDeTextoComTesseract(image, title):
    # Carrega a imagem
    img = cv2.imread(image)

    # Redimensiona a imagem
    img = cv2.resize(img, None, fx=1.2, fy=1.2, interpolation=cv2.INTER_CUBIC)

    # Converte a imagem para escala de cinza
    img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Aplicando dilatação e erosão para remover o ruído
    kernel = np.ones((1, 1), np.uint8)
    img = cv2.dilate(img, kernel, iterations=1)
    img = cv2.erode(img, kernel, iterations=1)

    # Aplicando o desfoque
    cv2.threshold(cv2.bilateralFilter(img, 5, 75, 75), 0,
                  255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)[1]

    cv2.imwrite('app/src/uploads/' + title + '_resultado.png', img)

    # Apontar para o caminho do Tesseract
    pytesseract.pytesseract.tesseract_cmd = 'C:\src\Tesseract-OCR/tesseract.exe'

    # Recupera o texto da imagem
    res = pytesseract.image_to_string(img)

    return res
