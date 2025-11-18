import 'dart:convert';
import '../models/candidat.dart';
import 'api_service.dart';

class CandidatService {
  Future<List<Candidat>> getCandidatsByVote(int voteId) async {
    final res = await ApiService.get('votes/$voteId/candidats');

    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List;
      return list.map((e) => Candidat.fromJson(e)).toList();
    }

    throw Exception("Impossible de charger les candidats");
  }

  Future<void> createCandidat(Map<String, dynamic> body) async {
    final res = await ApiService.post('candidats', body, withAuth: true);

    if (res.statusCode != 201) {
      throw Exception("Erreur de création du candidat");
    }
  }

  Future<void> updateCandidat(int id, Map<String, dynamic> body) async {
    final res = await ApiService.put('candidats/$id', body, withAuth: true);

    if (res.statusCode != 200) {
      throw Exception("Erreur de mise à jour du candidat");
    }
  }

  Future<void> deleteCandidat(int id) async {
    final res = await ApiService.delete('candidats/$id', withAuth: true);

    if (res.statusCode != 200) {
      throw Exception("Erreur de suppression du candidat");
    }
  }
}