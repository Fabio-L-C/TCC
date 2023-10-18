import 'dart:convert';
import 'dart:io';
import 'package:app_ocr/utils/constants.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;

import 'package:app_ocr/components/bottom_ber.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  Widget? imageWidget;
  String? textoRecebido;
  bool isImage = true;
  bool isText = false;

  final FlutterTts flutterTts = FlutterTts();

  getImagePicker(ImageSource source) async {
    isImage = true;
    isText = false;

    image = await _picker.pickImage(source: source);

    setState(() {
      imageWidget = Image.file(File(image!.path));
    });
  }

  teste() async {
    Uri url = Uri.parse(IMAGE_URL_TESSERACT);
    var response = await http.post(
      url,
      body: {
        "title": "teste_${DateTime.now().millisecondsSinceEpoch}",
        "image": base64Encode(File(image!.path).readAsBytesSync()),
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        textoRecebido = response.body;
        isText = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OCR APP"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: isImage
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    alignment: Alignment.center,
                    color: Colors.white,
                    child: imageWidget ?? imageWidget,
                  )
                : isText
                    ? SingleChildScrollView(child: ExibirTexto())
                    : const CircularProgressIndicator(),
          ),
          BottomBar(getImagePicker: getImagePicker),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 65.0,
        width: 65.0,
        child: FittedBox(
          child: FloatingActionButton(
            // Lógica para desabilitar o botão quando não tiver imagem
            onPressed: imageWidget == null
                ? null
                : () {
                    setState(() {
                      isImage = false;
                    });
                    teste();
                  },
            child: const Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  speak(String text) async {
    await flutterTts.setLanguage("pt-BR");
    await flutterTts.setVoice({"name": "pt-BR-language", "locale": "pt-BR"});
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  // ignore: non_constant_identifier_names
  Text ExibirTexto() {
    speak(textoRecebido!);
    return Text(textoRecebido!);
  }
}
