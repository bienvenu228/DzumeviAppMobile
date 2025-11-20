import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/candidat.dart';

class CandidatDetailPage extends StatefulWidget {
  final String candidatId;

  const CandidatDetailPage({super.key, required this.candidatId});

  @override
  State<CandidatDetailPage> createState() => _CandidatDetailPageState();
}

class _CandidatDetailPageState extends State<CandidatDetailPage> {
  late Future<Candidat> _candidatFuture;

  @override
  void initState() {
    super.initState();
    _candidatFuture = fetchCandidat();
  }

  Future<Candidat> fetchCandidat() async {
    final url = 'http://127.0.0.1:8000/api/candidats/${widget.candidatId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return Candidat.fromJson(data);
    } else {
      throw Exception('Erreur lors du chargement du candidat');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détails du Candidat')),
      body: FutureBuilder<Candidat>(
        future: _candidatFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          final candidat = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(candidat.photoUrl),
                ),
                const SizedBox(height: 16),
                Text('${candidat.firstname} ${candidat.lastname}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Matricule: ${candidat.matricule}'),
                const SizedBox(height: 8),
                Text('Catégorie: ${candidat.categorie}'),
                const SizedBox(height: 16),
                Text(
                  candidat.description.isNotEmpty ? candidat.description : 'Pas de description',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
