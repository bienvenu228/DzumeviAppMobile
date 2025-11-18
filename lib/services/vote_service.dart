import 'dart:convert';
import '../models/vote.dart';
import 'api_service.dart';

class VoteService {
  Future<List<Vote>> getVotes() async {
    final res = await ApiService.get('votes');

    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List;
      return list.map((e) => Vote.fromJson(e)).toList();
    }

    throw Exception("Erreur lors du chargement des votes");
  }

  Future<void> createVote(Map<String, dynamic> body) async {
    final res = await ApiService.post('votes', body, withAuth: true);

    if (res.statusCode != 201) {
      throw Exception("Erreur de création du vote");
    }
  }

  Future<void> updateVote(int voteId, Map<String, dynamic> body) async {
    final res = await ApiService.put('votes/$voteId', body, withAuth: true);

    if (res.statusCode != 200) {
      throw Exception("Erreur de mise à jour du vote");
    }
  }
}