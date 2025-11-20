import 'dart:convert';
import 'package:dzumevimobile/screens/voteListPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/vote.dart';

class VoteOverviewPage extends StatefulWidget {
  const VoteOverviewPage({super.key});

  @override
  State<VoteOverviewPage> createState() => _VoteOverviewPageState();
}

class _VoteOverviewPageState extends State<VoteOverviewPage> {
  late Future<List<Vote>> _votesFuture;

  @override
  void initState() {
    super.initState();
    _votesFuture = fetchVotes();
  }

  Future<List<Vote>> fetchVotes() async {
    final url = 'http://127.0.0.1:8000/api/votes';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((json) => Vote.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des votes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Concours Disponibles')),
      body: FutureBuilder<List<Vote>>(
        future: _votesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun concours trouvé.'));
          }

          final votes = snapshot.data!;
          return ListView.builder(
            itemCount: votes.length,
            itemBuilder: (context, index) {
              final vote = votes[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: ListTile(
                  title: Text(vote.name),
                  subtitle: Text('Du ${vote.date} au ${vote.echeance}'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    // Navigation vers VoteListPage avec voteId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VoteListPage(voteId: vote.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
