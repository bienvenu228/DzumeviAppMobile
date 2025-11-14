import 'package:flutter/material.dart';

class CandidatDetailPage extends StatefulWidget {
  final String candidatId;

  const CandidatDetailPage({super.key, required this.candidatId});

  @override
  State<CandidatDetailPage> createState() => _CandidatDetailPageState();
}

class _CandidatDetailPageState extends State<CandidatDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Candidat ${{widget.candidatId}}')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ID du Candidat: ${{widget.candidatId}}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }
}
