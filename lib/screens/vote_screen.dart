// lib/screens/paiement_screen.dart
import 'package:dzumevimobile/core/constants.dart';
import 'package:dzumevimobile/widgets/paiement_form.dart';
import 'package:flutter/material.dart';
import '../models/concours.dart';
import '../models/candidat.dart';
// NOTE: Assurez-vous d'avoir 'http' dans votre pubspec.yaml pour les appels API
// import 'package:http/http.dart' as http; 
// import 'dart:convert';

// --- (Le code de AppConstants et ThemeColors est supposé être dans 'package:dzumevimobile/core/constants.dart') ---

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
        title: const Text("Voter & Payer"),
        backgroundColor: AppConstants.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- EN-TÊTE RÉCAPITULATIF DU CANDIDAT ---
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: candidat.photo != null 
                          ? NetworkImage(candidat.photo!) 
                          : const AssetImage('assets/default_avatar.png') as ImageProvider,
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            candidat.fullName,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Concours: ${concours.name}",
                            style: const TextStyle(color: Colors.blueGrey, fontSize: 14),
                          ),
                          Text(
                            "Catégorie: ${candidat.categorie}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // --- TITRE DU FORMULAIRE ---
            const Text(
              "🗳️ Payer pour voter (FedaPay)",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
            ),
            const Divider(height: 20, thickness: 1),

            // --- FORMULAIRE DE PAIEMENT FEDAPAY INTÉGRÉ ---
            FedaPayPaymentForm(
              candidat: candidat,
              concours: concours,
              prixUnitaire: AppConstants.prixParVote,
            ),
            
            const SizedBox(height: 30),
            
            // --- BOUTON DE RETOUR ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.accent, // Couleur Rouge
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Retour à la liste", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}