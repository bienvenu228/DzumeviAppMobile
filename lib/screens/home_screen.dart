import 'package:dzumevimobile/screens/voteListPage.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accueil')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Voir les votes'),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VoteScreen())),
        ),
      ),
    );
  }
}
