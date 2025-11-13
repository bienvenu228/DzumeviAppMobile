import 'package:flutter/material.dart';
import '../../models/candidat.dart';
import '../../services/candidat_service.dart';

class CandidatsParVoteScreen extends StatefulWidget {
  final int voteId;

  const CandidatsParVoteScreen({super.key, required this.voteId});

  @override
  State<CandidatsParVoteScreen> createState() => _CandidatsParVoteScreenState();
}

class _CandidatsParVoteScreenState extends State<CandidatsParVoteScreen> {
  late Future<List<Candidat>> _futureCandidats;

  @override
  void initState() {
    super.initState();
    _chargerCandidats();
  }

  void _chargerCandidats() {
    setState(() {
      // Appel statique correct
      _futureCandidats = CandidatService.getCandidatsByVote(widget.voteId);
    });
  }

  void _supprimerCandidat(int id) async {
    try {
      await CandidatService.delete(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Candidat supprimé")),
      );
      _chargerCandidats();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Candidats du vote"),
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder<List<Candidat>>(
        future: _futureCandidats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun candidat trouvé"));
          }

          final candidats = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: candidats.length,
            itemBuilder: (context, index) {
              final c = candidats[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(c.photo),
                  ),
                  title: Text("${c.firstname} ${c.lastname}"),
                  subtitle: Text("Catégorie : ${c.categorie}"),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'supprimer') _supprimerCandidat(c.id);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'modifier', child: Text("Modifier")),
                      const PopupMenuItem(value: 'supprimer', child: Text("Supprimer")),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
