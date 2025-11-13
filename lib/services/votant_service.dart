import 'dart:convert';
import 'api_service.dart';

class VotantService {
  static Future<List<dynamic>> getAll() async {
    final res = await ApiService.get('votants', auth: true);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['data'] ?? [];
    } else {
      throw Exception('Erreur lors du chargement des votants');
    }
  }
}
