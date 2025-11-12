import 'package:flutter/material.dart';

class ResultatsScreen extends StatelessWidget {
  const ResultatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Résultats')),
      body: const Center(child: Text('Résultats du vote ici...')),
    );
  }
}
