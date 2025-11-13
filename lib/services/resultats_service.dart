import 'dart:convert';
import 'api_service.dart';

class ResultatsService {
  static Future<List<dynamic>> getResultats() async {
    final res = await ApiService.get('resultats', auth: true);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['data'] ?? [];
    } else {
      throw Exception('Erreur de chargement des résultats');
    }
  }
}
