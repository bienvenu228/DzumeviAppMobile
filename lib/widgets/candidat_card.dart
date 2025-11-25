import 'package:dzumevimobile/screens/vote_screen.dart';
import 'package:flutter/material.dart';
import '../models/candidat.dart';
import '../core/constants.dart';

class CandidatCard extends StatelessWidget {
  final Candidat candidat;
  final bool showProgress;
  final int totalVotesConcours; // Optionnel : pour afficher %
  final bool showVotes; // Optionnel : pour afficher %

  const CandidatCard({
    Key? key,
    required this.candidat,
    this.showProgress = false,
    this.totalVotesConcours = 0,
    this.showVotes = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double pourcentage = totalVotesConcours > 0
        ? (candidat.votes / totalVotesConcours) * 100
        : 0;

    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          // Photo ronde + badge votes
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: candidat.photo.isNotEmpty
                      ? Image.network(
                          candidat.photo,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 80, color: Colors.white),
                        )
                      : const Icon(Icons.person, size: 100, color: Colors.white70),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppConstants.secondary,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.how_to_vote, color: Colors.black87, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        "${candidat.votes}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  candidat.nomComplet,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  candidat.description.isEmpty ? "Candidat(e) au concours" : candidat.description,
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                if (showProgress) ...[
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: pourcentage / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation(AppConstants.primary),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${pourcentage.toStringAsFixed(1)}% des votes",
                    style: TextStyle(fontWeight: FontWeight.w600, color: AppConstants.primary),
                  ),
                ],

                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => VoteScreen(candidat: candidat)),
                  ),
                  icon: const Icon(Icons.how_to_vote),
                  label: const Text("VOTER MAINTENANT"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}