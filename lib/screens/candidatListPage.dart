import 'package:flutter/material.dart';

class CandidatListPage extends StatefulWidget {
  CandidatListPage({super.key});

  @override
  State<CandidatListPage> createState() => _CandidatListPageState();
}

class _CandidatListPageState extends State<CandidatListPage> {
  @override
  Widget build(BuildContext context) {
    final candidats = ['Candidat 1', 'Candidat 2', 'Candidat 3'];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Candidats'),
      ),
      body: ListView.builder(
        itemCount: candidats.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(candidats[index]),
            onTap: () {
              // Navigation avec argument (ID du candidat)
              Navigator.pushNamed(
                context,
                '/candidat/${index + 1}',
              );
            },
          );
        },
      ),
    );
  }
}