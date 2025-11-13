import 'dart:convert';
import '../models/candidat.dart';
import 'api_service.dart';

class CandidatService {
  // Récupérer tous les candidats
  static Future<List<Candidat>> getAll() async {
    final response = await ApiService.get('/candidats');
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Candidat.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors du chargement des candidats');
    }
  }

  // Nouvelle méthode pour récupérer les candidats par vote
  static Future<List<Candidat>> getCandidatsByVote(int voteId) async {
    final response = await ApiService.get('/votes/$voteId/candidats');
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Candidat.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors du chargement des candidats pour ce vote');
    }
  }

  static Future<void> add(Candidat candidat) async {
    final response = await ApiService.post('/candidats', candidat.toJson());
    if (response.statusCode != 201) {
      throw Exception('Erreur lors de l’ajout du candidat');
    }
  }

  static Future<void> update(int id, Candidat candidat) async {
    final response = await ApiService.put('/candidats/$id', candidat.toJson());
    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la modification');
    }
  }

  static Future<void> delete(int id) async {
    final response = await ApiService.delete('/candidats/$id');
    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la suppression');
    }
  }
}
