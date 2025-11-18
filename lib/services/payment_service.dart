// services/payment_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class PaymentService {
  
  // Cette méthode initie le processus de paiement (PaiementsController@doVote)
  static Future<Map<String, dynamic>> initiatePayment({
    required String name,
    required String email,
    required String phoneNumber,
    required String country,
    required double amount,
    required String currency,
    required String description,
    required String mode, // ex: mtn_open, moov
  }) async {
    final url = Uri.parse('${ApiService.baseUrl}/doVote'); // Assurez-vous que la route est /api/doVote
    
    final body = json.encode({
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'country': country,
      'amount': amount,
      'currency': currency,
      'description': description,
      'mode': mode,
      // ⚠️ Il manque l'ID du candidat dans la requête ! 
      // Vous devriez ajouter 'candidat_id' ici pour savoir qui voter après la confirmation du paiement.
    });

    final response = await http.post(url, headers: ApiService.getHeaders(), body: body);

    final jsonResponse = json.decode(response.body);

    if (response.statusCode == 201 && jsonResponse['success'] == true) {
      // Retourne l'ID de transaction pour le suivi
      return {
        'success': true,
        'transaction_id': jsonResponse['transaction_id'] as int,
        'message': jsonResponse['message'],
      };
    } else {
      // Gère les erreurs de validation ou d'API
      final errorMessage = jsonResponse['error'] ?? jsonResponse['message'] ?? 'Erreur inconnue lors de l\'initiation du paiement.';
      throw Exception(errorMessage);
    }
  }

  static Future<bool> voteCandidat(int candidatId) async {
    final url = Uri.parse('${ApiService.baseUrl}/vote-confirm'); 
    
    try {
      final response = await http.post(
        url,
        headers: ApiService.getHeaders(),
        body: json.encode({'candidat_id': candidatId}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['success'] == true;
      } else {
        print('Échec de la confirmation du vote (Statut: ${response.statusCode})');
        return false;
      }
    } catch (e) {
      print('Erreur de connexion lors du vote : $e');
      return false;
    }
  }

  // ⚠️ Fonctionnalité MANQUANTE ⚠️
  // Après l'initiation du paiement, vous devez avoir un **endpoint de webhook/callback** // côté Laravel pour valider la transaction FedaPay et ensuite seulement **incrémenter le vote** // du candidat dans la BDD. Ce n'est pas géré par ces contrôleurs.
}