import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/candidat.dart';
import '../core/constants.dart';

class SuccessScreen extends StatelessWidget {
  final int nombreVotes;
  final Candidat candidat;
  final String transactionId;

  const SuccessScreen({
    Key? key,
    required this.nombreVotes,
    required this.candidat,
    String? transactionId, // ← on rend optionnel
  }) : transactionId = transactionId ?? "DZV-000000",
       super(key: key);

  // ID par défaut généré une seule fois
  static final String _defaultId = DateTime.now().millisecondsSinceEpoch
      .toString()
      .substring(6);
  @override
  Widget build(BuildContext context) {
    final String displayId = transactionId == "DZV-000000"
        ? "DZV-${DateTime.now().millisecondsSinceEpoch}"
        : transactionId;
    final int montant = nombreVotes * AppConstants.prixParVote;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Vote enregistré !"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Fonction partage non disponible"),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icône succès
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      size: 80,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    "Merci pour votre vote !",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  Text(
                    "Vous avez offert",
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  Text(
                    "$nombreVotes vote${nombreVotes > 1 ? 's' : ''}",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.accent,
                    ),
                  ),
                  Text(
                    "à",
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    candidat.nomComplet,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),

                  const Divider(height: 40, thickness: 1),

                  // Détails du reçu
                  _buildInfoRow("Référence", transactionId),
                  _buildInfoRow(
                    "Date",
                    DateFormat('dd MMM yyyy à HH:mm').format(DateTime.now()),
                  ),
                  _buildInfoRow("Montant payé", "$montant FCFA"),
                  _buildInfoRow("Moyen de paiement", "Mobile Money"),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: () =>
                        Navigator.popUntil(context, (route) => route.isFirst),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primary,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 40,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Retour à l'accueil",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 15)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
