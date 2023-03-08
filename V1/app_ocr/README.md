# App OCR

Um aplicativo mobile feito em Flutter com a função de enviar imagens para o back-end e fazer o TTS (text-to-speech / texto para fala) do texto recebido.

Para baixar as dependencias do projeto use

```
flutter pub get
```

Se necessario habilite o modo de desenvolvedor do seu pc

```
start ms-settings:developers
```

<hr>
Pegue o **IPv4** de sua maquina e use-o para substituir o seguinte codigo dentro de **../lib\utils\constants.dart**

```
3| const BASE_URL = 'http://<IPv4>:5000/';
4| const IMAGE_URL = 'http://<IPv4>:5000/image'; // POST
```
