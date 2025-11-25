// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/admin.dart';
import '../models/votant.dart';

class AuthService {
<<<<<<< HEAD
  final String baseUrl = "http://127.0.0.1:8000/api";
  final storage = const FlutterSecureStorage();
=======
  static const String _baseUrl = "http://192.168.0.212/Dzumevi_APi/public/api";
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  
  // Keys for secure storage
  static const String _jwtTokenKey = 'jwt_token';
  static const String _userTypeKey = 'user_type';
>>>>>>> e04e2f31bb20ddeb618e18be476914093ede4958

  Future<Admin> loginAdmin(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/admin/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final token = data['token'];
        final adminJson = data['admin'];

        await _saveAuthData(token, 'admin');
        return Admin.fromJson(adminJson);
      } else {
        final errorMessage = jsonDecode(response.body)['message'] ?? "Connexion admin échouée";
        throw AuthException(errorMessage, response.statusCode);
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException("Erreur de connexion: ${e.toString()}", 0);
    }
  }

  Future<Votant> loginVotant(String matricule) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/votants/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'matricule': matricule}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final token = data['token'];
        final votantJson = data['votant'];

        await _saveAuthData(token, 'votant');
        return Votant.fromJson(votantJson);
      } else {
        final errorMessage = jsonDecode(response.body)['message'] ?? "Connexion votant échouée";
        throw AuthException(errorMessage, response.statusCode);
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException("Erreur de connexion: ${e.toString()}", 0);
    }
  }

  Future<void> logout() async {
    try {
      await Future.wait([
        _storage.delete(key: _jwtTokenKey),
        _storage.delete(key: _userTypeKey),
      ]);
    } catch (e) {
      throw AuthException("Erreur lors de la déconnexion: ${e.toString()}", 0);
    }
  }

  Future<String?> getUserType() async {
    return await _storage.read(key: _userTypeKey);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _jwtTokenKey);
  }

  Future<Map<String, String>> getAuthHeaders() async {
    final String? token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Private helper method
  Future<void> _saveAuthData(String token, String userType) async {
    await Future.wait([
      _storage.write(key: _jwtTokenKey, value: token),
      _storage.write(key: _userTypeKey, value: userType),
    ]);
  }
}

class AuthException implements Exception {
  final String message;
  final int statusCode;

  AuthException(this.message, this.statusCode);

  @override
  String toString() => 'AuthException: $message (Status: $statusCode)';
}