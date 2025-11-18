import 'dart:convert';
import 'package:http/http.dart' as http;

// --- Classe de service pour gérer vote et paiement ---
class PaymentService {
  // URL de base de l'API (à modifier selon ton backend)
  static const String baseUrl = "https://127.0.0.1:8000/api";

  // --- Récupérer tous les candidats ---
  static Future<List<dynamic>> _fetchRawCandidats() async {
    final response = await http.get(Uri.parse('$baseUrl/candidats'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur API : ${response.statusCode}');
    }
  }

  // Transforme les données JSON en objets Candidat
  static Future<List<dynamic>> getCandidats() async {
    final raw = await _fetchRawCandidats();
    return raw.map((json) => json).toList(); // Remplacer par ton modèle si nécessaire
  }

  // --- Voter pour un candidat (après paiement réussi) ---
  static Future<bool> voteCandidat(int candidatId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/vote'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'candidat_id': candidatId}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Erreur vote API : $e");
      return false;
    }
  }

  // --- Effectuer un paiement avant vote ---
  // type: "TMoney" ou "Flooz"
  static Future<bool> makePayment({required String phoneNumber, required int amount, required String type}) async {
    try {
      // Simulateur : envoyer vers l'API paiement
      final response = await http.post(
        Uri.parse('$baseUrl/payment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': phoneNumber,
          'amount': amount,
          'type': type,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Erreur paiement : $e");
      return false;
    }
  }
}