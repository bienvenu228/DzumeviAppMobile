import 'package:flutter/material.dart';
import '../models/candidat.dart';
import '../core/constants.dart';

class CandidatCard extends StatelessWidget {
  final Candidat candidat;
  final VoidCallback onTap;
  final bool showProgress;
  final int totalVotesConcours;

  const CandidatCard({
    Key? key,
    required this.candidat,
    required this.onTap,
    this.showProgress = false,
    required this.totalVotesConcours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Photo du candidat
            _buildPhotoSection(),
            
            // Informations du candidat
            _buildInfoSection(),
            
            // Barre de progression (si activée)
            if (showProgress) _buildProgressSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        image: candidat.photoUrl != null
            ? DecorationImage(
                image: NetworkImage(candidat.photoUrl!),
                fit: BoxFit.cover,
              )
            : const DecorationImage(
                image: AssetImage('assets/images/1.jpg'),
                fit: BoxFit.cover,
              ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.transparent,
            ],
          ),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppConstants.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${candidat.votes} votes',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
 Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nom du candidat (utilise fullName)
          Text(
            candidat.fullName, // Utilise fullName au lieu de name
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 4),
          
          // Matricule
          Text(
            candidat.matricule,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Catégorie
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppConstants.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppConstants.secondary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              candidat.categorie,
              style: TextStyle(
                fontSize: 10,
                color: AppConstants.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(height: 6),
          
          // Description (utilise safeDescription)
          Text(
            candidat.safeDescription, // Utilise safeDescription
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  Widget _buildProgressSection() {
    final percentage = totalVotesConcours > 0 
        ? (candidat.votes / totalVotesConcours) * 100 
        : 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pourcentage
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppConstants.primary,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Barre de progression
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(3),
            ),
            child: Stack(
              children: [
                // Fond de la barre
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                
                // Progression
                FractionallySizedBox(
                  widthFactor: percentage / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppConstants.primary,
                          AppConstants.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
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