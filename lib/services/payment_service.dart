import 'dart:convert';
import 'api_service.dart';

class PaymentService {
  /// Récupère les transactions.
  /// Si la route n'existe pas ou renvoie une erreur, retourne simplement une liste vide.
  Future<List<Map<String, dynamic>>> getTransactions() async {
    try {
      final res = await ApiService.get('paiements');

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final list = data is Map && data['data'] != null ? data['data'] : data;
        return List<Map<String, dynamic>>.from(list as List);
      }

      print("⚠️ Avertissement: /paiements a renvoyé un status ${res.statusCode}");
      return [];
    } catch (e) {
      print("⚠️ Impossible de récupérer les transactions: $e");
      return []; // Fallback pour éviter tout crash
    }
  }

  /// Calcule les totaux et statistiques.
  Map<String, dynamic> computeAggregates(List<Map<String, dynamic>> txs) {
    double total = 0.0;
    final byMethod = <String, double>{};

    for (final t in txs) {
      final amount = double.tryParse(t['montant']?.toString() ?? '0') ?? 0.0;
      total += amount;

      final method = (t['moyen'] ?? t['method'] ?? 'unknown').toString();
      byMethod[method] = (byMethod[method] ?? 0) + amount;
    }

    final avg = txs.isNotEmpty ? total / txs.length : 0.0;

    return {
      'total': total,
      'average': avg,
      'byMethod': byMethod,
      'count': txs.length,
    };
  }
}