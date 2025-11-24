// lib/services/candidat_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/candidat.dart';
import '../models/payment_details.dart'; // Import du modèle de paiement

class CandidatService {
  // 🚨 IMPORTANT : Vérifiez et ajustez cette URL si nécessaire.
  // Nous utilisons 127.0.0.1 comme demandé, mais 10.0.2.2 est souvent nécessaire pour l'émulateur Android.
  static const String _baseUrl = "http://192.168.0.212/Dzumevi_APi/public/api"; 

  // Méthode pour récupérer la liste des candidats
  Future<List<Candidat>> fetchCandidats() async {
    // 🚨 REMPLACER avec votre véritable endpoint /candidats pour la production
    final response = await http.get(Uri.parse('$_baseUrl/candidats'));

    // Bloc pour nettoyer le corps de la réponse si vous rencontrez des problèmes d'en-tête (comme les commentaires HTML)
    String cleanBody = response.body.replaceAll("<!--", "").replaceAll("-->", "").trim();
    
    // On parse le JSON propre
    final data = jsonDecode(cleanBody);
    print(data);
    
    if (response.statusCode == 200) {
      final List<dynamic> candidatsJson = data['data'];

      return candidatsJson
          .map((jsonItem) => Candidat.fromJson(jsonItem))
          .toList();
    } else {
      // En cas d'échec de l'appel API
      throw Exception('Échec du chargement des candidats. Statut: ${response.statusCode}');
    }
  }

  // MÉTHODE POUR INITIER LA TRANSACTION DE PAIEMENT/VOTE (mise à jour)
  // Elle prend un objet PaymentDetails qui contient TOUS les champs requis par votre contrôleur Laravel (name, email, amount, mode, etc.).
  Future<Map<String, dynamic>> voteForCandidat(PaymentDetails details) async {
    // L'endpoint est maintenant 'paiement' pour correspondre à la fonction de votre contrôleur
    final url = Uri.parse('$_baseUrl/paiement'); 
    
    // Convertit l'objet PaymentDetails en Map JSON (Contient tous les champs FedaPay + candidat_id/vote_id)
    final body = details.toJson();

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body)
      );

      print(response);

      final responseData = json.decode(response.body.replaceAll("<!--", "").replaceAll("-->", "").trim());

      // Succès: 201 Created pour une initiation de paiement réussie
      if (response.statusCode == 201 && responseData['success'] == true) {
        return responseData;
      } 
      
      // Gère les erreurs de validation (422) ou les erreurs internes (500)
      else if (response.statusCode == 500 || response.statusCode == 422) {
        // Récupère le message d'erreur du backend (souvent pour les erreurs de validation)
        throw Exception(responseData['message'] ?? responseData['error'] ?? 'Erreur lors de la soumission du vote.');
      } 
      
      // Autres erreurs HTTP 
      else {
        throw Exception('Échec de la connexion à l\'API. Statut HTTP: ${response.statusCode}');
      }
    } catch (e) {
      // Erreur de réseau, timeout, ou erreur de formatage JSON
      print(e);
      throw Exception('Erreur de réseau ou de traitement: $e');
    }
  }
}