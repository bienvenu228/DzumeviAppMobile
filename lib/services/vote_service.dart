import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vote.dart';

class VoteService {
  final String baseUrl = "http://127.0.0.1:8000/api";

  Future<List<Vote>> getVotes() async {
    final res = await http.get(Uri.parse('$baseUrl/votes'));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => Vote.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors du chargement des votes');
    }
  }

  Future<void> createVote(Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('$baseUrl/votes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (res.statusCode != 201) {
      throw Exception('Erreur lors de la création du vote');
    }
  }

  Future<void> updateVote(int voteId, Map<String, dynamic> body) async {
    final res = await http.put(
      Uri.parse('$baseUrl/votes/$voteId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (res.statusCode != 200) {
      throw Exception('Erreur lors de la mise à jour du vote');
    }
  }
}