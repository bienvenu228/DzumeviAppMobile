// lib/services/candidat_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/candidat.dart';
import '../models/payment_details.dart';

class CandidatService {
  static const String _baseUrl = "http://192.168.0.212/Dzumevi_APi/public/api";

  Future<List<Candidat>> fetchCandidats() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/candidats'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final String cleanBody = _cleanResponseBody(response.body);
        final Map<String, dynamic> data = jsonDecode(cleanBody);
        
        final List<dynamic> candidatsJson = data['data'] ?? [];
        
        return candidatsJson
            .map((jsonItem) => Candidat.fromJson(jsonItem))
            .toList();
      } else {
        throw CandidatException(
          'Échec du chargement des candidats: ${response.statusCode}',
          response.statusCode,
          response.body,
        );
      }
    } catch (e) {
      print('Network error: $e');
      throw CandidatException('Erreur de connexion: ${e.toString()}', 0, e.toString());
    }
  }

  Future<Map<String, dynamic>> voteForCandidat(PaymentDetails details) async {
    try {
      final url = Uri.parse('$_baseUrl/paiement');
      final body = details.toJson();

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );

      print('Vote response status: ${response.statusCode}');
      print('Vote response body: ${response.body}');

      final String cleanBody = _cleanResponseBody(response.body);
      final Map<String, dynamic> responseData = jsonDecode(cleanBody);

      if (response.statusCode == 201 && responseData['success'] == true) {
        return responseData;
      } else if (response.statusCode == 422) {
        throw CandidatException(
          'Erreur de validation',
          response.statusCode,
          responseData['message'] ?? 'Données invalides',
        );
      } else {
        throw CandidatException(
          'Erreur lors du vote',
          response.statusCode,
          responseData['message'] ?? responseData['error'] ?? 'Erreur inconnue',
        );
      }
    } catch (e) {
      print('Vote error: $e');
      throw CandidatException('Erreur réseau lors du vote', 0, e.toString());
    }
  }

  String _cleanResponseBody(String body) {
    return body.replaceAll("<!--", "").replaceAll("-->", "").trim();
  }
}

class CandidatException implements Exception {
  final String message;
  final int statusCode;
  final String details;

  CandidatException(this.message, this.statusCode, this.details);

  @override
  String toString() => 'CandidatException: $message (Status: $statusCode, Details: $details)';
}