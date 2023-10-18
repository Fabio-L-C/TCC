# 192.168.1.104

# venv\Scripts\Activate
# flask --app app/main --debug run -h 192.168.1.100 -p 5000

import os
from flask import Flask, request
from flask_cors import CORS
import base64

from usandoTesseract import ReconhecimentoDeTextoComTesseract

ALLOWED_EXTENSIONS = set(['txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'])
UPLOAD_FOLDER = 'app/src/uploads'

app = Flask(__name__)
CORS(app)

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['CORS_HEADERS'] = 'Content-Type'


@app.route("/")
def hello_world():
    return "<p>Aplicação Web para fazer o precessamento das imagens</p>"


@app.route("/image", methods=["POST"])
def imageProcessing():
    if request.method == "POST":

        title = request.form['title']
        image = request.form['image']

        base64_img_bytes = image.encode('utf-8')

        source = 'app/src/uploads/' + title + '.png'

        with open(source, 'wb') as file_to_save:
            decoded_image_data = base64.decodebytes(base64_img_bytes)
            file_to_save.write(decoded_image_data)

        res = ReconhecimentoDeTextoComTesseract(source, title)
        return res
