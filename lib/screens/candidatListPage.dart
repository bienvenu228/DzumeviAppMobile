import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/candidat.dart';
import 'candidat.detail.dart';

class CandidatListPage extends StatefulWidget {
  final String? voteId; // optionnel si liste filtrée par vote
  const CandidatListPage({super.key, this.voteId});

  @override
  State<CandidatListPage> createState() => _CandidatListPageState();
}

class _CandidatListPageState extends State<CandidatListPage> {
  late Future<List<Candidat>> _futureCandidats;

  @override
  void initState() {
    super.initState();
    _futureCandidats = _fetchCandidats();
  }

  Future<List<Candidat>> _fetchCandidats() async {
  String url = "http://127.0.0.1:8000/api/candidats"; // si Android emulator
  final response = await http.get(Uri.parse(url));
  print(response.body); // <-- Ajouté pour debug
  if (response.statusCode != 200) throw Exception("Erreur API");

  final jsonBody = jsonDecode(response.body);
  final data = jsonBody["data"] as List;
  return data.map((e) {
    final candidat = Candidat.fromJson(e);
    candidat.id = int.tryParse(candidat.id.toString()) ?? 0;
    return candidat;
  }).toList();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Liste des candidats")),
      body: FutureBuilder<List<Candidat>>(
        future: _futureCandidats,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final candidats = snapshot.data!;

          return ListView.builder(
            itemCount: candidats.length,
            itemBuilder: (context, i) {
              final c = candidats[i];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: c.photo?.isNotEmpty == true ? NetworkImage(c.photo!) : null,
                  child: c.photo?.isEmpty ?? true ? const Icon(Icons.person) : null,
                ),
                title: Text("${c.firstname} ${c.lastname}"),
                subtitle: Text("Catégorie : ${c.categorie} — Votes : ${c.votes}"),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CandidatDetailPage(candidatId: c.id)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
