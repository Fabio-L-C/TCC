import os

def ReconhecimentoDeTextoComModeloCriado(modelo_path):

    if os.path.exists(modelo_path):
        print(f"O arquivo do modelo foi encontrado em {modelo_path}")
    else:
        print(f"O arquivo do modelo não foi encontrado em {modelo_path}")



# if __name__ == '__main__':
#     # Testando a função com um exemplo
#     caminho_imagem = 'src/img/1.png'
#     # ReconhecimentoDeTextoComModeloCriado("C:/Users/fabio/OneDrive/Documentos/Codigos/TCC/TCC/V5/api_ocr/app/src/modelo/rede_neural")
#     # ReconhecimentoDeTextoComModeloCriado("app/src/modelo/rede_neural")

#     # ReconhecimentoDeTextoComModeloCriado("app/src/img/1.png")
