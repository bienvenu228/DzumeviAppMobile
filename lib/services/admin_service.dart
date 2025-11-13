import 'dart:convert';
import '../services/api_service.dart';
import '../models/admin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminService {
  /// 🔹 Connexion de l'administrateur
  static Future<bool> login(String name, String password) async {
    try {
      final response = await ApiService.post(
        'admin/login', // ✅ correspond à ta route Laravel: /api/admin/login
        {
          'name': name,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Vérifie la présence du token et de l'admin
        final token = data['token'];
        final admin = data['admin'];

        if (token != null && admin != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('admin_name', admin['name']);
          return true;
        } else {
          throw Exception("Données de connexion invalides.");
        }
      } else {
        final message = jsonDecode(response.body)['message'] ?? 'Erreur de connexion';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception("Erreur lors de la connexion : $e");
    }
  }

  /// 🔹 Récupère le profil de l’admin connecté
  static Future<Admin> getProfile() async {
    final res = await ApiService.get('admin/profile', auth: true);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return Admin.fromJson(data['data']);
    } else {
      throw Exception('Erreur de récupération du profil');
    }
  }

  /// 🔹 Mise à jour du profil admin
  static Future<bool> updateProfile(String name, String email) async {
    final res = await ApiService.post('admin/update', {
      'name': name,
      'email': email,
    }, auth: true);

    return res.statusCode == 200;
  }

  /// 🔹 Déconnexion
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
