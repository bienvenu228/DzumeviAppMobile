import 'package:dio/dio.dart';
import 'package:dzumevimobile/models/candidat.dart';
import 'package:dzumevimobile/models/concours.dart';

class ApiService {
  // Base URL vers ton Laravel accessible depuis Flutter Web ou mobile
  static const baseUrl = "http://192.168.0.41:8080/Dzumevi_APi/public/api/";

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );

  // -----------------------------------
  // Récupérer tous les concours
  // -----------------------------------
  static Future<List<Concours>> getConcours() async {
    try {
      final response = await dio.get('concours');

      // response.data est déjà Map<String, dynamic>
      final decodedData = response.data as Map<String, dynamic>;
      print("Réponse API getConcours: $decodedData");

      // Assurer que 'data' est une liste
      final dataList = decodedData['data'] as List<dynamic>? ?? [];

      return dataList.map((json) => Concours.fromJson(json)).toList();
    } catch (e) {
      print("Erreur réseau/CORS getConcours: $e");
      throw Exception('Erreur réseau/CORS getConcours: $e');
    }
  }

  // -----------------------------------
  // Récupérer les candidats d'un concours
  // -----------------------------------
  static Future<List<Candidat>> getCandidats(int concoursId) async {
    try {
      final response = await dio.get('concours/$concoursId/candidats');

      final decodedData = response.data as Map<String, dynamic>;
      print("Réponse API getCandidats: $decodedData");

      final dataList = decodedData['data'] as List<dynamic>? ?? [];
      return dataList.map((json) => Candidat.fromJson(json)).toList();
    } catch (e) {
      print("Erreur réseau/CORS getCandidats: $e");
      throw Exception('Erreur réseau/CORS getCandidats: $e');
    }
  }

  // -----------------------------------
  // Initier un paiement
  // -----------------------------------
  static Future<Map<String, dynamic>> initierPaiement({
    required int candidatId,
    required String nomVotant,
    required int nombreVotes,
    required String telephone,
    required String operateur,
  }) async {
    try {
      final response = await dio.post(
        'paiement/initier',
        data: {
          'candidat_id': candidatId,
          'nom_votant': nomVotant,
          'nombre_votes': nombreVotes,
          'telephone': telephone,
          'operateur': operateur,
        },
      );

      final decodedData = response.data as Map<String, dynamic>;
      print("Réponse API initierPaiement: $decodedData");

      return decodedData;
    } catch (e) {
      print("Erreur initierPaiement: $e");
      throw Exception('Erreur initierPaiement: $e');
    }
  }
}
