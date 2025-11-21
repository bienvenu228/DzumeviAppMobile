import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/candidat.dart';

class CandidatDetailPage extends StatefulWidget {
  final int candidatId;
  const CandidatDetailPage({super.key, required this.candidatId});

  @override
  State<CandidatDetailPage> createState() => _CandidatDetailPageState();
}

class _CandidatDetailPageState extends State<CandidatDetailPage> {
  late Future<Candidat> _futureCandidat;

  @override
  void initState() {
    super.initState();
    _futureCandidat = _fetchCandidat();
  }

  Future<Candidat> _fetchCandidat() async {
    final response = await http.get(Uri.parse("http://127.0.0.1:8000/api/candidats/${widget.candidatId}"));
    if (response.statusCode != 200) throw Exception("Erreur API");

    final data = jsonDecode(response.body)["data"];
    final candidat = Candidat.fromJson(data);
    candidat.id = int.tryParse(candidat.id.toString()) ?? 0;
    return candidat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Détails du candidat")),
      body: FutureBuilder<Candidat>(
        future: _futureCandidat,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final c = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: c.photo?.isNotEmpty == true ? NetworkImage(c.photo!) : null,
                  child: c.photo?.isEmpty ?? true ? const Icon(Icons.person, size: 60) : null,
                ),
                const SizedBox(height: 16),
                Text("${c.firstname} ${c.lastname}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Catégorie : ${c.categorie}"),
                const SizedBox(height: 8),
                Text("Votes : ${c.votes}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
