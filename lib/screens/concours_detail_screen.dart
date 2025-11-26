import 'package:dzumevimobile/core/constants.dart';
import 'package:dzumevimobile/core/services/api_service.dart';
import 'package:flutter/material.dart';
import '../models/concours.dart';
import '../models/candidat.dart';
import '../widgets/candidat_card.dart';

class ConcoursDetailScreen extends StatefulWidget {
  final Concours concours;
  const ConcoursDetailScreen({Key? key, required this.concours}) : super(key: key);

  @override
  State<ConcoursDetailScreen> createState() => _ConcoursDetailScreenState();
}

class _ConcoursDetailScreenState extends State<ConcoursDetailScreen> {
  late Future<List<Candidat>> futureCandidats;
  int totalVotes = 0;

  @override
  void initState() {
    super.initState();
    futureCandidats = ApiService.getCandidats(widget.concours.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.concours.titre, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppConstants.primary,
      ),
      body: FutureBuilder<List<Candidat>>(
        future: futureCandidats,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final candidats = snapshot.data!;
            totalVotes = candidats.fold(0, (sum, c) => sum + c.votes);

            if (candidats.isEmpty) {
              return Center(child: Text("Aucun candidat inscrit", style: TextStyle(fontSize: 18)));
            }

            return Column(
              children: [
                // Header info
                Container(
                  padding: EdgeInsets.all(20),
                  color: AppConstants.primary.withOpacity(0.1),
                  child: Column(
                    children: [
                      Text("Votez avec votre mobile", style: TextStyle(fontSize: 16, color: AppConstants.primary)),
                      SizedBox(height: 10),
                      Text("${widget.concours.prixParVote} FCFA = 1 vote", 
                          style:TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppConstants.accent)),
                      SizedBox(height: 10),
                      Text("Total votes : $totalVotes • Recettes : ${totalVotes * widget.concours.prixParVote} FCFA",
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                // Liste candidats
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: candidats.length,
                    itemBuilder: (context, index) {
                      final candidat = candidats[index];
                      return CandidatCard(
                        candidat: candidat,
                        showProgress: true,
                        totalVotesConcours: totalVotes > 0 ? totalVotes : 1,
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur de chargement des candidats"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}