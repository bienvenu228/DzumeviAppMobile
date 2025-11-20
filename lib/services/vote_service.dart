import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vote.dart'; // Importez le nouveau modèle

class VoteService {
  // 🚨 IMPORTANT : Vérifiez et ajustez cette URL si nécessaire.
  // 10.0.2.2 est pour l'émulateur Android, utilisez votre IP locale pour un appareil physique.
  final String _baseUrl = 'http://127.0.0.1:8000/api';

  Future<List<Vote>> fetchVotes() async {
    final response = await http.get(Uri.parse('$_baseUrl/votes'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Vérifiez le 'status' et la structure de la réponse Laravel
      if (data['status'] == 'success' && data.containsKey('data')) {
        final List<dynamic> votesJson = data['data'];

        // Mappage de la liste JSON en objets Vote
        return votesJson
            .map((jsonItem) => Vote.fromJson(jsonItem))
            .toList();
      } else {
        throw Exception(
            'Réponse de l\'API inattendue : ${data['message'] ?? 'Format incorrect'}');
      }
    } else {
      throw Exception(
          'Échec de la requête API. Statut: ${response.statusCode}');
    }
  }
}