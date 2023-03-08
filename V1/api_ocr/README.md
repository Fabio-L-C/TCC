# Api OCR

Um simples back-end feito em Python e Flask, para fazer o processamento da imagem e realizar o OCR (Optical Character Recognition / Reconhecimento ótico de caracteres) retornando o texto detectado.

## Fazendo o back-end funcionar

Primeiro crie um Venv (Virtual Environments / Ambiente Virtual) dentro da **..\V1\api_ocr**.

```
py -m venv ./venv
```

Ative o Venv

```
venv\Scripts\Activate
```

Baixe os pacotes necessarios usando o seguinte comando

```
pip install -r requirements.txt
```

Pegue o **IPv4** de sua maquina e use-o para executar a aplicação

```
flask --app app/main --debug run -h <IPv4> -p 5000
```

<hr>
### Use para acessar o projeto

```
[POST] http://<IPV4>:5000/image
```

Ela recebe dois parametros

```
{
    "title": string,
    "image": imagem codificada em base64,
}
```

Ela retorna uma **String** com o texto identificado na imagem
