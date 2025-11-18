// services/candidat_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/candidat.dart'; // Assurez-vous d'avoir ce modèle
import 'api_service.dart';

class CandidatService {
  
  // Implémente CandidatsController@index
  static Future<List<Candidat>> fetchAllCandidats() async {
    final url = Uri.parse('${ApiService.baseUrl}/candidats');
    final response = await http.get(url, headers: ApiService.getHeaders());

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      
      if (jsonResponse['status'] == 'success' && jsonResponse['data'] is List) {
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) => Candidat.fromJson(json)).toList();
      }
      throw Exception(jsonResponse['message'] ?? 'Format de réponse invalide.');
    } else {
      throw Exception('Échec de la récupération de la liste des candidats. Statut: ${response.statusCode}');
    }
  }

  // Implémente CandidatsController@candidatsByVote
  

  Future<List<Candidat>> getCandidatsByVote(int voteId) async {
    // ⚠️ Remplacez l'URL par votre endpoint Laravel
    // Ex: GET /api/candidats?vote_id=1
    final url = Uri.parse('${ApiService.baseUrl}/candidats').replace(
      queryParameters: {'vote_id': voteId.toString()},
    );

    try {
      final response = await http.get(url, headers: ApiService.getHeaders());

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        
        // Assurez-vous que la réponse contient la liste sous 'data'
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] is List) {
          final List<dynamic> data = jsonResponse['data'];
          
          // ⭐️ Important : Assurez-vous d'avoir la méthode Candidat.fromJson pour cette conversion.
          return data.map((json) => Candidat.fromJson(json)).toList();
        }
        throw Exception(jsonResponse['message'] ?? 'Format de réponse API invalide.');
      } else {
        throw Exception('Échec du chargement des candidats: Statut ${response.statusCode}');
      }
    } catch (e) {
      // Pour debug
      print('Erreur dans getCandidatsByVote: $e');
      rethrow;
    }
  }

  // NOTE: Les méthodes store/update/delete sont omises ici pour se concentrer sur l'affichage et le vote.
}