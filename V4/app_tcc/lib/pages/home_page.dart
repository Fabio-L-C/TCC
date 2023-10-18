import 'package:app_tcc/components/camera.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: const Camera(),
    );
  }
}
