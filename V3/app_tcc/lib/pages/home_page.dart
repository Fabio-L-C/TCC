import 'dart:io' as io;

import 'package:app_tcc/pages/camera_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterTts flutterTts = FlutterTts();
  final TextRecognizer textRecognizer = TextRecognizer();
  late ObjectDetector objectDetector;

  // Função para realizar a sintese de voz
  doVoiceSynthesis(String text) async {
    print('doVoiceSynthesis');
    await flutterTts.setLanguage("pt-BR");
    await flutterTts.setVoice({"name": "pt-BR-language", "locale": "pt-BR"});
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1);

    await flutterTts.awaitSpeakCompletion(false);
    await flutterTts.speak(text);
  }

  // Função para realizar o reconhecimento de texto na imagem
  Future<String> doTextRecognition(InputImage inputImage) async {
    print('doTextRecognition');
    final recognizedText = await textRecognizer.processImage(inputImage);

    if (recognizedText.text.isNotEmpty) {
      return recognizedText.text;
    } else {
      return '';
    }
  }

  // Função para realizar o reconhecimento de objetos na imagem
  Future<List<String>> doRecognizeObjects(InputImage inputImage) async {
    print('doRecognizeObjects');

    _initializeDetector(DetectionMode.single);

    final objects = await objectDetector.processImage(inputImage);

    if (objects.isNotEmpty) {
      List<String> recognitionObjects = [];

      for (final DetectedObject detectedObject in objects) {
        for (final Label label in detectedObject.labels) {
          print('--------------------------------------');
          print('======================================');
          print('${label.text} ${label.confidence}\n');
          recognitionObjects.add(label.text);
          print('======================================');
          print('--------------------------------------');
        }
      }
      return recognitionObjects;
    } else {
      return [];
    }
  }

  // Função para pegar a imagem da câmera
  getImage(InputImage inputImage) async {
    print('getImage');
    createText(inputImage);
  }

  // Função para criar o texto
  createText(InputImage inputImage) async {
    print('createText');
    final texts = await doTextRecognition(inputImage);
    final objects = await doRecognizeObjects(inputImage);

    String generateText = '';

    /* 
      obj && tex
      obj && !tex
      !obj && tex
      !obj && !tex    
    */

    if (objects.isNotEmpty && texts.isNotEmpty) {
      generateText =
          'Foi identificado os seguintes objetos: ${objects.join(', ')}. A seguir o texto reconhecido: $texts';
    } else if (objects.isNotEmpty && texts.isEmpty) {
      generateText =
          'Foi identificado os seguintes objetos: ${objects.join(', ')}.';
    } else if (objects.isEmpty && texts.isNotEmpty) {
      generateText = 'A seguir o texto reconhecido: $texts';
    } else {
      generateText = 'Não foi possível reconhecer o objeto ou texto.';
    }

    doVoiceSynthesis(generateText);
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   doVoiceSynthesis(
  //       'Olá, seja bem vindo ao aplicativo de reconhecimento de objetos e texto.'
  //       'Para usar-lo basta apontar a câmera para o objeto ou texto'
  //       'que deseja reconhecer e apertar o botão abaixo.');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: CameraPage(
        getImage: (InputImage inputImage) => getImage(inputImage),
      ),
    );
  }

  void _initializeDetector(DetectionMode mode) async {
    const path = 'assets/ml/object_labeler.tflite';
    final modelPath = await _getModel(path);
    final options = LocalObjectDetectorOptions(
      mode: mode,
      modelPath: modelPath,
      classifyObjects: true,
      multipleObjects: true,
    );

    objectDetector = ObjectDetector(options: options);
  }

  Future<String> _getModel(String assetPath) async {
    if (io.Platform.isAndroid) {
      return 'flutter_assets/$assetPath';
    }
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await io.Directory(dirname(path)).create(recursive: true);
    final file = io.File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }
}
