import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ResultScreen extends StatelessWidget {
  final String text;
  ResultScreen({super.key, required this.text});

  final FlutterTts flutterTts = FlutterTts();

  speak(String text) async {
    await flutterTts.setLanguage("pt-BR");
    await flutterTts.setVoice({"name": "pt-BR-language", "locale": "pt-BR"});
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
        ),
        body: Container(
          padding: const EdgeInsets.all(30.0),
          child: TextSpeak(),
        ),
      );

  // ignore: non_constant_identifier_names
  Text TextSpeak() {
    speak(text);
    return Text(text);
  }
}
