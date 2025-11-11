import 'package:flutter/material.dart';

class VoteDetailPage extends StatefulWidget {
  final String voteId;

  const VoteDetailPage({
    super.key,
    required this.voteId,
  });

  @override
  State<VoteDetailPage> createState() => _VoteDetailPageState();
}

class _VoteDetailPageState extends State<VoteDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détail du Vote ${{widget.voteId}}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ID du Vote: ${{widget.voteId}}',
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
