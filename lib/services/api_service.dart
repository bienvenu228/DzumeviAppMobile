import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  
  static const String baseUrl = "http://127.0.0.1:8000/api";

  //Méthode GET
  static Future<http.Response> get(String endpoint, {bool auth = false}) async {
    final headers = await _buildHeaders(auth);
    final url = Uri.parse("$baseUrl/$endpoint");
    return await http.get(url, headers: headers);
  }

  //Méthode POST
  static Future<http.Response> post(String endpoint, Map<String, dynamic> body,
      {bool auth = false}) async {
    final headers = await _buildHeaders(auth);
    final url = Uri.parse("$baseUrl/$endpoint");
    return await http.post(url, headers: headers, body: jsonEncode(body));
  }

  //Méthode PUT
  static Future<http.Response> put(String endpoint, Map<String, dynamic> body,
      {bool auth = false}) async {
    final headers = await _buildHeaders(auth);
    final url = Uri.parse("$baseUrl/$endpoint");
    return await http.put(url, headers: headers, body: jsonEncode(body));
  }

  //Méthode DELETE
  static Future<http.Response> delete(String endpoint,
      {bool auth = false}) async {
    final headers = await _buildHeaders(auth);
    final url = Uri.parse("$baseUrl/$endpoint"); 
    return await http.delete(url, headers: headers);
  }

  //Génère les bons headers
  static Future<Map<String, String>> _buildHeaders(bool auth) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (auth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }
}
