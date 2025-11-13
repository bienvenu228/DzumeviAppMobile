import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "http://127.0.0.1:8000/api";

  Future<Map<String, dynamic>> loginAdmin(String name, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/admin/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'password': password}), // ✅ champs corrects
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body); // contient 'admin' + 'token'
    } else {
      throw Exception(jsonDecode(res.body)['message'] ?? 'Erreur de connexion admin');
    }
  }
}
