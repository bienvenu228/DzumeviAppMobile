import 'dart:convert';
import 'api_service.dart';
import '../models/transaction.dart';

class TransactionService {
  static Future<List<Transaction>> getAll() async {
    final res = await ApiService.get('transactions', auth: true);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['data'] as List)
          .map((e) => Transaction.fromJson(e))
          .toList();
    } else {
      throw Exception('Erreur lors du chargement des transactions');
    }
  }
}
