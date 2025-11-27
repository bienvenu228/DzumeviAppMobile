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
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                        fontWeight: FontWeight.w600,
                        color: AppConstants.primary,
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
                            fontWeight: FontWeight.w600,
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

              // Informations de dates
              Row(
                children: [
                  _buildInfoItem(
                    Icons.calendar_today,
                    'Début: ${_formatDate(concours.dateDebut)}',
                  ),
                  const SizedBox(width: 16),
                  _buildInfoItem(
                    Icons.event_available,
                    'Fin: ${_formatDate(concours.dateFin)}',
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Prix par vote
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppConstants.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppConstants.secondary.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.attach_money,
                      size: 14,
                      color: AppConstants.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${concours.prixParVote.toInt()} FCFA = 1 VOTE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.secondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Statistiques
              Row(
                children: [
                  _buildStatItem(
                    Icons.people,
                    '${concours.nombreCandidats} Candidats',
                  ),
                  const SizedBox(width: 16),
                  _buildStatItem(
                    Icons.how_to_vote,
                    '${concours.nombreVotes} Votes',
                  ),
                  const SizedBox(width: 16),
                  _buildStatItem(
                    Icons.monetization_on,
                    '${concours.totalRecettes.toInt()} FCFA',
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Bouton d'action
              Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  gradient: _getButtonGradient(concours.statut),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    _getButtonText(concours.statut),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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

  Widget _buildStatItem(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppConstants.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppConstants.primary),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 11,
                  color: AppConstants.primary,
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

  LinearGradient _getButtonGradient(String statut) {
    switch (statut) {
      case 'actif':
        return LinearGradient(
          colors: [AppConstants.primary, AppConstants.secondary],
        );
      case 'inactif':
        return const LinearGradient(
          colors: [Colors.orange, Colors.deepOrange],
        );
      case 'termine':
        return const LinearGradient(
          colors: [Colors.grey, Colors.blueGrey],
        );
      default:
        return LinearGradient(
          colors: [AppConstants.primary, AppConstants.secondary],
        );
    }
  }

  String _getButtonText(String statut) {
    switch (statut) {
      case 'actif':
        return 'Voter Maintenant';
      case 'inactif':
        return 'Bientôt Disponible';
      case 'termine':
        return 'Concours Terminé';
      default:
        return 'Voir Détails';
    }
  }
}