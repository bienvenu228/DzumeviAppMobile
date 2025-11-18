// services/vote_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

// Classe Vote minimale pour le mapping (À compléter si nécessaire)
class Vote {
  final int id;
  final String name;
  final String statuts;
  
  Vote({required this.id, required this.name, required this.statuts});

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      id: json['id'] as int,
      name: json['name'] as String,
      statuts: json['statuts'] as String,
    );
  }
}

class VoteService {
  
  // Implémente VoteController@index
  static Future<List<Vote>> fetchAllVotes() async {
    final url = Uri.parse('${ApiService.baseUrl}/votes'); // Assurez-vous que la route est /api/votes
    final response = await http.get(url, headers: ApiService.getHeaders());

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      
      if (jsonResponse['status'] == 'success' && jsonResponse['data'] is List) {
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) => Vote.fromJson(json)).toList();
      }
      throw Exception(jsonResponse['message'] ?? 'Format de réponse des votes invalide.');
    } else {
      throw Exception('Échec de la récupération de la liste des votes. Statut: ${response.statusCode}');
    }
  }

  Future<dynamic> getVotes() async {
    // ⚠️ Remplacez 'votes/summary' par votre endpoint API réel.
    // Votre URL d'API devra être ajustée pour ne pas nécessiter d'ID
    final url = Uri.parse('${ApiService.baseUrl}/votes/all_summary');

    try {
      final response = await http.get(url, headers: ApiService.getHeaders());

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        
        // Assurez-vous que la réponse correspond au format attendu de votre API
        if (jsonResponse['status'] == 'success') {
          // Si cette méthode est utilisée pour obtenir des statistiques (nombre total de votes, etc.)
          return jsonResponse['data']; // Retourne les données brutes pour traitement
        }
        throw Exception(jsonResponse['message'] ?? 'Format de réponse API invalide.');
      } else {
        throw Exception('Échec du chargement des votes: Statut ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur dans getVotes: $e');
      rethrow;
    }
  }

  // NOTE: Les méthodes store/show/update/destroy sont omises ici.
}