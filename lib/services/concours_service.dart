import 'dart:convert';
import '../models/concours.dart';
import 'api_service.dart';

class ConcoursService {
  static Future<List<Concours>> getAll() async {
    final response = await ApiService.get('/concours');
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Concours.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors du chargement des concours');
    }
  }

  static Future<void> add(Concours concours) async {
    final response = await ApiService.post('/concours', concours.toJson());
    if (response.statusCode != 201) {
      throw Exception('Erreur lors de l’ajout du concours');
    }
  }

  static Future<void> update(Concours concours) async {
    final response = await ApiService.put('/concours/${concours.id}', concours.toJson());
    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la modification du concours');
    }
  }

  static Future<void> delete(int id) async {
    final response = await ApiService.delete('/concours/$id');
    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la suppression du concours');
    }
  }
}
