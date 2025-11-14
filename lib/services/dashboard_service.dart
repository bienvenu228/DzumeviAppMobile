import 'dart:convert';
import '../services/api_service.dart';
import '../services/payment_service.dart';
import '../models/candidat.dart';

class DashboardService {
  final PaymentService _paymentService = PaymentService();

  /// Charge toutes les données nécessaires au tableau de bord admin
  Future<Map<String, dynamic>> fetchDashboardData() async {
    try {
      // --- Charger les candidats ---
      final candidatsRes = await ApiService.get('candidats', withAuth: true);

      if (candidatsRes.statusCode != 200) {
        throw Exception("Impossible de charger les candidats");
      }

      final candidatsJson = jsonDecode(candidatsRes.body);
      final list = candidatsJson is Map ? candidatsJson['data'] : candidatsJson;

      final candidats = (list as List)
          .map((e) => Candidat.fromJson(e))
          .toList();

      // --- Calcul du total des votes directement à partir des candidats ---
      // CORRECTION: Ajout de .toInt() pour s'assurer que le résultat est un int,
      // même si 'c.votes' est inféré comme 'num'.
      final totalVotes = candidats.fold<int>(
        0,
        (sum, c) => sum + (c.votes?.toInt() ?? 0),
      );

      // --- Générer classement ---
      final classement = List<Candidat>.from(candidats)
        // Correction similaire ici pour garantir la comparaison d'entiers
        ..sort((a, b) => (b.votes?.toInt() ?? 0).compareTo(a.votes?.toInt() ?? 0));

      // --- Charger paiements ---
      final txs = await _paymentService.getTransactions();
      final aggregates = _paymentService.computeAggregates(txs);

      return {
        'totalCandidats': candidats.length,
        'totalVotes': totalVotes,
        'revenus': aggregates['total'],
        'transactions': aggregates['count'],
        'classement': classement,
      };
    } catch (e) {
      throw Exception("Erreur du chargement du tableau de bord: $e");
    }
  }
}