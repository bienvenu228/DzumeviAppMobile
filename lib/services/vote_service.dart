import 'dart:convert';
import '../models/vote.dart';
import 'api_service.dart';

class VoteService {
  Future<List<Vote>> getVotes() async {
    final res = await ApiService.get('votes', auth: true);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['data'] as List).map((e) => Vote.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors du chargement des votes');
    }
  }

  Future<void> createVote(Vote vote) async {
    final body = vote.toJson();
    final res = await ApiService.post('votes', body, auth: true);

    if (res.statusCode != 201) {
      throw Exception('Erreur lors de la création du vote');
    }
  }
}
