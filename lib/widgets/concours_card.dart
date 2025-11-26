// lib/widgets/concours_card.dart
import 'package:dzumevimobile/core/constants.dart';
import 'package:dzumevimobile/core/enums/concours_statut.dart';
import 'package:flutter/material.dart';
import '../models/concours.dart';

class ConcoursCard extends StatelessWidget {
  final Concours concours;
  final VoidCallback onTap;

  const ConcoursCard({
    super.key,
    required this.concours,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6, // Utilisation de votre elevation
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Votre border radius
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec statut
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      concours.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600, // Votre typographie
                        color: AppConstants.primary, // Votre couleur primaire
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: ConcoursStatut.getColor(concours.statut).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: ConcoursStatut.getColor(concours.statut),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          ConcoursStatut.getIcon(concours.statut),
                          size: 14,
                          color: ConcoursStatut.getColor(concours.statut),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ConcoursStatut.getDisplayText(concours.statut),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600, // Votre typographie
                            color: ConcoursStatut.getColor(concours.statut),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                concours.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 16),

              // Informations
              Row(
                children: [
                  _buildInfoItem(
                    Icons.calendar_today,
                    'Début: ${_formatDate(concours.date)}',
                  ),
                  const SizedBox(width: 16),
                  _buildInfoItem(
                    Icons.event_available,
                    'Fin: ${_formatDate(concours.echeance)}',
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Statistiques
              Row(
                children: [
                  _buildStatItem(
                    Icons.people,
                    '${concours.nombreCandidats} Candidats',
                    context,
                  ),
                  const SizedBox(width: 16),
                  _buildStatItem(
                    Icons.how_to_vote,
                    '${concours.nombreVotes} Votes',
                    context,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Bouton d'action avec votre style de bouton
              Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  gradient: _getButtonGradient(concours.statut),
                  borderRadius: BorderRadius.circular(12), // Votre border radius
                ),
                child: Center(
                  child: Text(
                    _getButtonText(concours.statut),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600, // Votre typographie
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text, BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppConstants.primary.withOpacity(0.1), // Votre couleur primaire
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppConstants.primary), // Votre couleur primaire
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 11,
                  color: AppConstants.primary, // Votre couleur primaire
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  LinearGradient _getButtonGradient(ConcoursStatut statut) {
    switch (statut) {
      case ConcoursStatut.enCours:
        return LinearGradient(
          colors: [AppConstants.primary, AppConstants.secondary], // Vos couleurs primaire/secondaire
        );
      case ConcoursStatut.aVenir:
        return const LinearGradient(
          colors: [Colors.orange, Colors.deepOrange],
        );
      case ConcoursStatut.passe:
        return const LinearGradient(
          colors: [Colors.grey, Colors.blueGrey],
        );
    }
  }

  String _getButtonText(ConcoursStatut statut) {
    switch (statut) {
      case ConcoursStatut.enCours:
        return 'Voter Maintenant';
      case ConcoursStatut.aVenir:
        return 'Bientôt Disponible';
      case ConcoursStatut.passe:
        return 'Concours Terminé';
    }
  }
}

// Extension pour accéder facilement aux couleurs du contexte
extension BuildContextExtension on BuildContext {
  Color get primary => Theme.of(this).primaryColor;
  Color get secondary => Theme.of(this).colorScheme.secondary;
  Color get background => Theme.of(this).colorScheme.background;
  Color get surface => Theme.of(this).colorScheme.surface;
}