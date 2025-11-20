import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/candidat.dart'; 

class CandidatService {
  // 🚨 IMPORTANT : Vérifiez et ajustez cette URL si nécessaire.
  final String _baseUrl = 'http://127.0.0.1:8000/api';

  Future<List<Candidat>> fetchCandidats() async {
    final response = await http.get(Uri.parse('$_baseUrl/candidats'));
String cleanBody = response.body
    .replaceAll("<!--", "")
    .replaceAll("-->", "")
    .trim();

// On parse le JSON propre
final data = jsonDecode(cleanBody);

    print('Response body: ${data}'); // Pour le débogage
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(cleanBody);

      if (data['status'] == 'success' && data.containsKey('data')) {
        final List<dynamic> candidatsJson = data['data'];

        return candidatsJson
            .map((jsonItem) => Candidat.fromJson(jsonItem))
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

  // NOUVELLE MÉTHODE : Envoie le vote au backend
  Future<Map<String, dynamic>> voteForCandidat(int candidatId, int voteId) async {
    final url = Uri.parse('$_baseUrl/paiement'); // La route que vous avez définie

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // Le corps de la requête doit inclure les données attendues par votre PaiementsController@doVote
      body: jsonEncode(<String, dynamic>{
        // Assurez-vous que ces clés correspondent à ce qu'attend votre contrôleur Laravel
        'candidat_id': candidatId,
        'vote_id': voteId, 
        // Ajoutez ici d'autres champs nécessaires si votre PaiementsController le requiert (ex: user_id)
      }),
    );

    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Succès (status 200 ou 201 si le paiement a créé une ressource)
      return responseData; 
    } else {
      // Échec de la requête ou validation ratée
      throw Exception(
          'Erreur lors du vote: ${responseData['message'] ?? 'Erreur inconnue'}');
    }
  }
}
