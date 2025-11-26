import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/candidat.dart';
import '../core/constants.dart';

class SuccessScreen extends StatelessWidget {
  final int nombreVotes;
  final Candidat candidat;
  final String transactionId;
  final int montantPaye;

  SuccessScreen({
    Key? key,
    required this.nombreVotes,
    required this.candidat,
    required this.montantPaye,
    String? transactionId,
  })  : transactionId = transactionId ?? _generateTransactionId(),
        super(key: key);

  // Génération d'un ID de transaction unique
  static String _generateTransactionId() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch.toString().substring(6);
    return "DZV-$timestamp";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Vote enregistré !",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: AppConstants.primary),
            onPressed: () => _shareResult(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Carte principale
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Icône de succès
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          size: 80,
                          color: Colors.green[700],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Message de remerciement
                      Text(
                        "Merci pour votre vote !",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      // Informations du vote
                      _buildVoteInfo(),
                      const SizedBox(height: 24),

                      // Détails de la transaction
                      _buildTransactionDetails(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Boutons d'action
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVoteInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            "Vous avez offert",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "$nombreVotes vote${nombreVotes > 1 ? 's' : ''}",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppConstants.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "à",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${candidat.firstname} ${candidat.lastname}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          if (candidat.categorie.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              candidat.categorie,
              style: TextStyle(
                fontSize: 14,
                color: AppConstants.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTransactionDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Détails de la transaction",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildDetailRow("Référence", transactionId),
        _buildDetailRow(
          "Date",
          DateFormat('dd/MM/yyyy à HH:mm').format(DateTime.now()),
        ),
        _buildDetailRow("Montant payé", "${montantPaye.toInt()} FCFA"),
        _buildDetailRow("Nombre de votes", nombreVotes.toString()),
        _buildDetailRow("Prix par vote", "${AppConstants.prixParVote} FCFA"),
        _buildDetailRow("Moyen de paiement", "Mobile Money"),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Bouton retour à l'accueil
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _returnToHome(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Retour à l'accueil",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // Bouton voir les résultats
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _viewResults(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppConstants.primary,
              side: BorderSide(color: AppConstants.primary),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Voir les résultats",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _shareResult(BuildContext context) {
    final shareText = "Je viens de voter pour ${candidat.firstname} ${candidat.lastname} "
        "avec $nombreVotes vote${nombreVotes > 1 ? 's' : ''} ! "
        "Rejoins-moi sur l'application Dzumevi pour soutenir tes candidats préférés 🎉";
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Texte copié dans le presse-papier"),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: "OK",
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
    
    // Ici vous pouvez intégrer un package de partage comme share_plus
    // await Share.share(shareText);
  }

  void _returnToHome(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void _viewResults(BuildContext context) {
    // Naviguer vers l'écran des résultats
    // Navigator.push(context, MaterialPageRoute(builder: (_) => ResultsScreen()));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Fonctionnalité résultats à venir"),
        duration: Duration(seconds: 2),
      ),
    );
  }
}