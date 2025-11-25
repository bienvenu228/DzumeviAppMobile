import 'package:dzumevimobile/models/candidat.dart';
import 'package:dzumevimobile/models/concours.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static String baseUrl = "http://192.168.0.41:8080/Dzumevi_APi/public/api";

  static Future<List<Concours>> getConcours() async {
    final response = await http.get(Uri.parse('$baseUrl/concours'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse.map((c) => Concours.fromJson(c)).toList();
    } else {
      throw Exception('Erreur chargement concours');
    }
  }

  static Future<List<Candidat>> getCandidats(int concoursId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/concours/$concoursId/candidats'),
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((c) => Candidat.fromJson(c)).toList();
    } else {
      throw Exception('Erreur candidats');
    }
  }

  // Cette fonction appelle ton endpoint qui redirige vers TMoney/Flooz
  static Future<Map<String, dynamic>> initierPaiement({
    required int candidatId,
    required String nomVotant,
    required int nombreVotes,
    required String telephone,
    required String operateur, // "t-money" ou "flooz"
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/paiement/initier'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'candidat_id': candidatId,
        'nom_votant': nomVotant,
        'nombre_votes': nombreVotes,
        'telephone': telephone,
        'operateur': operateur,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur paiement: ${response.body}');
    }
  }
}
