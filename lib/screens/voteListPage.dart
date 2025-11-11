import 'package:flutter/material.dart';
import '../widgets/vote_card.dart';

class VoteScreen extends StatelessWidget {
  const VoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Votes disponibles')),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) => const VoteCard(title: 'Concours de Danse', statut: 'En cours'),
      ),
    );
  }
}
