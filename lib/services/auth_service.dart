import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/admin.dart';
import '../models/votant.dart';
import 'api_service.dart';

class AuthService {
  final String baseUrl = "http://127.0.0.1:8000/api";
  final storage = const FlutterSecureStorage();

  Future<Admin> loginAdmin(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/admin/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(res.body);

      final token = data['token'];
      final adminJson = data['admin'];

      await storage.write(key: 'jwt_token', value: token);
      await storage.write(key: 'user_type', value: 'admin');

      return Admin.fromJson(adminJson);
    }

    throw Exception(jsonDecode(res.body)['message'] ?? "Connexion admin échouée");
  }

  Future<Votant> loginVotant(String matricule) async {
    final res = await http.post(
      Uri.parse('$baseUrl/votants/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'matricule': matricule}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      final token = data['token'];
      final votantJson = data['votant'];

      await storage.write(key: 'jwt_token', value: token);
      await storage.write(key: 'user_type', value: 'votant');

      return Votant.fromJson(votantJson);
    }

    throw Exception(jsonDecode(res.body)['message'] ?? "Connexion votant échouée");
  }

  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
    await storage.delete(key: 'user_type');
  }

  Future<bool> isAuthenticated() async {
    final token = await storage.read(key: 'jwt_token');
    if (token == null) return false;


    try {
      final res = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<String?> getUserType() async {
    return await storage.read(key: 'user_type');
  }
}