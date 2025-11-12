import 'package:flutter/material.dart';
class VoteListPage extends StatefulWidget {
   VoteListPage({super.key});

  @override
  State<VoteListPage> createState() => _VoteListPageState();
}

class _VoteListPageState extends State<VoteListPage> {
  @override
  Widget build(BuildContext context) {
    final votes = ['Vote 1', 'Vote 2', 'Vote 3'];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Votes'),
      ),
      body: ListView.builder(
        itemCount: votes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(votes[index]),
            onTap: () {
              // Navigation avec argument (ID du vote)
              Navigator.pushNamed(
                context,
                '/vote/${index + 1}',
              );
            },
          );
        },
      ),
    );
  }
}
