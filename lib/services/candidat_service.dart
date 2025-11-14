import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/candidat.dart';

class CandidatService {
  final String baseUrl = "https://mon-api.com/api";

  Future<List<Candidat>> getCandidatsByVote(int voteId) async {
    final res = await http.get(Uri.parse('$baseUrl/votes/$voteId/candidats'));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => Candidat.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors du chargement des candidats');
    }
  }

  Future<void> createCandidat(Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('$baseUrl/candidats'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (res.statusCode != 201) {
      throw Exception('Erreur lors de la création du candidat');
    }
  }

  Future<void> updateCandidat(int candidatId, Map<String, dynamic> body) async {
    final res = await http.put(
      Uri.parse('$baseUrl/candidats/$candidatId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (res.statusCode != 200) {
      throw Exception('Erreur lors de la mise à jour du candidat');
    }
  }

  Future<void> deleteCandidat(int candidatId) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/candidats/$candidatId'),
    );

    if (res.statusCode != 200) {
      throw Exception('Erreur lors de la suppression du candidat');
    }
  }
}