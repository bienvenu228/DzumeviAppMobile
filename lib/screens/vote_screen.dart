// lib/screens/paiement_screen.dart
import 'package:dzumevimobile/core/constants.dart';
import 'package:flutter/material.dart';
import '../models/concours.dart';
import '../models/candidat.dart';

class PaiementScreen extends StatelessWidget {
  final Candidat candidat;
  final Concours concours;

  const PaiementScreen({
    Key? key,
    required this.candidat,
    required this.concours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paiement"),
        backgroundColor: AppConstants.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: candidat.photo != null 
                          ? NetworkImage(candidat.photo!) 
                          : const AssetImage('assets/default_avatar.png') as ImageProvider,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            candidat.fullName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            candidat.categorie,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Formulaire de paiement
            const Text(
              "Formulaire de paiement - À implémenter",
              style: TextStyle(fontSize: 16),
            ),
            
            const Spacer(),
            
            // Bouton de retour
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Retour"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}