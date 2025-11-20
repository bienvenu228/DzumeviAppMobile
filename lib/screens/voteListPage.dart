import 'dart:convert';
import 'package:dzumevimobile/screens/candidat.detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/candidat.dart';

class VoteListPage extends StatefulWidget {
  final String voteId;

  const VoteListPage({super.key, required this.voteId});

  @override
  State<VoteListPage> createState() => _VoteListPageState();
}

class _VoteListPageState extends State<VoteListPage> {
  late Future<List<Candidat>> _candidatsFuture;

  @override
  void initState() {
    super.initState();
    _candidatsFuture = fetchCandidats();
  }

  Future<List<Candidat>> fetchCandidats() async {
    final url = 'http://127.0.0.1:8000/api/candidatsByConcours/${widget.voteId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      List<Candidat> candidats = data.map((json) => Candidat.fromJson(json)).toList();
      // Trier par votes décroissant
      candidats.sort((a, b) => b.votes.compareTo(a.votes));
      return candidats;
    } else {
      throw Exception('Erreur lors du chargement des candidats');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Classement des Candidats')),
      body: FutureBuilder<List<Candidat>>(
        future: _candidatsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun candidat trouvé.'));
          }

          final candidats = snapshot.data!;
          final totalVotes = candidats.fold<int>(0, (sum, c) => sum + c.votes);

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Encadré Top 3
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff9b2cf0), Color(0xffe639c7)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.bar_chart, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Top 3",
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "$totalVotes votes au total",
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Top 3 candidats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    3,
                    (index) => _buildTopCandidate(candidats[index], index == 0),
                  ),
                ),
                const SizedBox(height: 20),
                // Liste complète
                ...List.generate(
                  candidats.length,
                  (index) => _buildRankTile(candidats[index], index + 1, totalVotes),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopCandidate(Candidat candidat, bool isWinner) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CandidatDetailPage(candidatId: candidat.id)),
        );
      },
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: isWinner ? 45 : 40,
                backgroundImage: NetworkImage(candidat.photoUrl),
              ),
              if (isWinner)
                const Positioned(
                  top: -2,
                  right: -2,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.yellow,
                    child: Icon(Icons.emoji_events, size: 18, color: Colors.white),
                  ),
                )
            ],
          ),
          const SizedBox(height: 6),
          Text('${candidat.firstname} ${candidat.lastname}', style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 3),
          Text("${candidat.votes} votes", style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildRankTile(Candidat candidat, int rank, int totalVotes) {
    final percent = totalVotes > 0 ? (candidat.votes / totalVotes) * 100 : 0.0;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CandidatDetailPage(candidatId: candidat.id)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 24, backgroundImage: NetworkImage(candidat.photoUrl)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$rank. ${candidat.firstname} ${candidat.lastname}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(candidat.categorie, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: percent / 100,
                    minHeight: 6,
                    backgroundColor: Colors.pink.shade100,
                    valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                const Icon(Icons.favorite, color: Colors.pink, size: 20),
                Text("${candidat.votes}"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
