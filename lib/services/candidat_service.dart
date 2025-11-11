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
}
