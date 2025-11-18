import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static String? _authToken;

  static void setAuthToken(String token) {
    _authToken = token;
  }

  static Map<String, String> _buildHeaders({bool withAuth = false}) {
    final headers = {'Content-Type': 'application/json'};

    if (withAuth) {
      if (_authToken == null) {
        throw Exception("Token manquant. Veuillez vous reconnecter.");
      }
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  static Future<http.Response> get(String endpoint, {bool withAuth = false}) async {
    final url = Uri.parse("$baseUrl/$endpoint");
    return await http.get(url, headers: _buildHeaders(withAuth: withAuth));
  }

  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool withAuth = false,
  }) async {
    final url = Uri.parse("$baseUrl/$endpoint");
    return await http.post(
      url,
      headers: _buildHeaders(withAuth: withAuth),
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool withAuth = false,
  }) async {
    final url = Uri.parse("$baseUrl/$endpoint");
    return await http.put(
      url,
      headers: _buildHeaders(withAuth: withAuth),
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> delete(
    String endpoint, {
    bool withAuth = false,
  }) async {
    final url = Uri.parse("$baseUrl/$endpoint");
    return await http.delete(url, headers: _buildHeaders(withAuth: withAuth));
  }
}