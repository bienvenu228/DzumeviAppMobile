import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // NOUVEL IMPORT
import '../models/admin.dart';
import '../models/votant.dart';

class AuthService {
  final String baseUrl = "https://http://127.0.0.1:8000/api";
  
  // Instance du service de stockage sécurisé
  final storage = const FlutterSecureStorage(); 

  // --- Méthode de Connexion Administrateur (Mise à jour pour le token et JSON) ---

  Future<Admin> loginAdmin(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/admin/login'),
      // Ajout du header Content-Type pour spécifier l'envoi en JSON
      headers: {'Content-Type': 'application/json'},
      // Envoi du corps de la requête encodé en JSON
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(res.body);
      
      // ASSUMER que l'API retourne : {"token": "...", "admin": {...}}
      final String token = jsonResponse['token'] as String;
      final Map<String, dynamic> adminJson = jsonResponse['admin'] as Map<String, dynamic>;

      // 1. Stocker le token de l'admin après la connexion réussie
      await storage.write(key: 'jwt_token', value: token);
      
      // 2. Stocker le type d'utilisateur pour la vérification rapide
      await storage.write(key: 'user_type', value: 'admin');

      return Admin.fromJson(adminJson);
    } else {
      // Tentative d'extraction du message d'erreur de l'API
      try {
        final errorBody = jsonDecode(res.body);
        final message = errorBody['message'] ?? 'Erreur inconnue de connexion admin';
        throw Exception(message);
      } catch (_) {
        throw Exception('Erreur de connexion admin. Statut: ${res.statusCode}');
      }
    }
  }

  // --- Méthode de Connexion Votant (Mise à jour pour le token et JSON) ---
  
  Future<Votant> loginVotant(String matricule) async {
    final res = await http.post(
      Uri.parse('$baseUrl/votants/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'matricule': matricule}),
    );

    if (res.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(res.body);
      
      // ASSUMER que l'API retourne : {"token": "...", "votant": {...}}
      final String token = jsonResponse['token'] as String;
      final Map<String, dynamic> votantJson = jsonResponse['votant'] as Map<String, dynamic>;

      // Stocker le token et le type
      await storage.write(key: 'jwt_token', value: token);
      await storage.write(key: 'user_type', value: 'votant');
      
      return Votant.fromJson(votantJson);
    } else {
       try {
        final errorBody = jsonDecode(res.body);
        final message = errorBody['message'] ?? 'Erreur inconnue de connexion votant';
        throw Exception(message);
      } catch (_) {
        throw Exception('Erreur de connexion votant. Statut: ${res.statusCode}');
      }
    }
  }

  // --- Logique de Déconnexion (Ajoutée pour un service complet) ---
  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
    await storage.delete(key: 'user_type');
  }

  // -------------------------------------------------------------------
  // --- isAuthenticated utilise le stockage sécurisé et vérifie l'API ---
  // -------------------------------------------------------------------

  Future<bool> isAuthenticated() async {
    String? token = await storage.read(key: 'jwt_token'); 
    
    if (token == null) {
      return false; 
    }
    
    // 2. Vérifier si le token est valide auprès de l'API (Endpoint /auth/me recommandé)
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/auth/me'), // Endpoint de vérification de session
        headers: {'Authorization': 'Bearer $token'},
      );

      if (res.statusCode == 200) {
        return true;
      } else {
        // Effacer le token s'il est invalide (401, 403)
        await storage.delete(key: 'jwt_token'); 
        await storage.delete(key: 'user_type');
        return false;
      }
    } catch (e) {
      // Gérer les erreurs de réseau (pas de connexion)
      return false;
    }
  }

  // -------------------------------------------------------------------
  // --- getUserType utilise le type stocké localement (optimisation) ---
  // -------------------------------------------------------------------

  Future<String?> getUserType() async {
    // Retourne 'admin', 'votant', ou null si non trouvé
    return await storage.read(key: 'user_type');
  }
}