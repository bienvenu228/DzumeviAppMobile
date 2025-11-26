// lib/services/concours_api_service.dart
import 'dart:convert';
import 'package:dzumevimobile/models/concours.dart';
import 'package:http/http.dart' as http;

class ConcoursApiService {
  static const String baseUrl = 'http://192.168.0.41:8080/Dzumevi_APi/public/api';

  final http.Client client;

  ConcoursApiService({required this.client});

  Future<List<Concours>> getAllConcours() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/concours/actifs'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Nettoyer la réponse des commentaires HTML
        String cleanedResponse = _cleanResponse(response.body);
        final Map<String, dynamic> jsonResponse = json.decode(cleanedResponse);
        
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

  Future<Concours> getConcoursById(int id) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/concours/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        String cleanedResponse = _cleanResponse(response.body);
        final Map<String, dynamic> jsonResponse = json.decode(cleanedResponse);
        
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

  String _cleanResponse(String response) {
    return response.replaceAll(RegExp(r'<!--.*?-->'), '').trim();
  }
}