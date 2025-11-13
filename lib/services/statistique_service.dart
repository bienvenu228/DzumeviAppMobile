import 'dart:convert';
import 'api_service.dart';

class StatistiqueService {
  static Future<Map<String, dynamic>> getStats() async {
    final res = await ApiService.get('admin/statistiques', auth: true);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['data'] ?? {};
    } else {
      throw Exception('Erreur de chargement des statistiques');
    }
  }
}
