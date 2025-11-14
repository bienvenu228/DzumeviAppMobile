import 'package:flutter/material.dart';

class VoteCard extends StatelessWidget {
  final String title;
  final String statut;

  const VoteCard({super.key, required this.title, required this.statut});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(title),
        subtitle: Text('Statut : $statut'),
      ),
    );
  }
}
