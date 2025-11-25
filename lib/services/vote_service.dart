// lib/services/vote_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vote_result.dart';

class VoteService {
  static const String _baseUrl = "http://192.168.0.41:8080/Dzumevi_APi/public/api";

  Future<List<VoteResult>> getVoteResults() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/vote-results'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Vote results response status: ${response.statusCode}');
      print('Vote results response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> resultsJson = data['data'] ?? [];
        
        return resultsJson
            .map((jsonItem) => VoteResult.fromJson(jsonItem))
            .toList();
      } else {
        throw Exception('Échec du chargement des résultats: ${response.statusCode}');
      }
    } catch (e) {
      print('Vote results error: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<int> getTotalVotes() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/total-votes'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['total_votes'] ?? 0;
      } else {
        // Si l'endpoint n'existe pas, calculer le total à partir des résultats
        final results = await getVoteResults();
        return results.fold(0, (sum, result) => sum + result.votes);
      }
    } catch (e) {
      print('Total votes error: $e');
      // En cas d'erreur, retourner 0 ou une valeur par défaut
      return 7315; // Valeur de démo
    }
  }
}