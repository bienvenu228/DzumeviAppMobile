// lib/services/concours_api_service.dart
import 'dart:convert';
import 'package:dzumevimobile/models/concours.dart';
import 'package:http/http.dart' as http;

class ConcoursApiService {
  // Base URL pointant sur le dossier public de Laravel
  static const String baseUrl = 'http://192.168.0.41:8080/Dzumevi_APi/public';

  final http.Client client;

  ConcoursApiService({required this.client});

  /// Récupère tous les concours
  Future<List<Concours>> getAllConcours() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/api/concours'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((item) => Concours.fromJson(item)).toList();
        } else {
          throw Exception('Erreur API: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Erreur HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  /// Récupère un concours spécifique par ID
  Future<Concours> getConcoursById(int id) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/api/concours/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          return Concours.fromJson(jsonResponse['data']);
        } else {
          throw Exception('Erreur API: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Erreur HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
}
