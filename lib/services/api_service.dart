import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  
  // NOTE: Dans un vrai projet, vous devriez avoir un service pour stocker/récupérer le token.
  // Ce token doit être récupéré et stocké après la connexion de l'utilisateur.
  static String? _authToken; 

  // Méthode pour définir le token après la connexion
  static void setAuthToken(String token) {
    _authToken = token;
  }

  // --- GET avec support d'authentification ---
  static Future<http.Response> get(
    String endpoint, {
    bool withAuth = false, // Correction : Ajout du paramètre nommé 'withAuth'
  }) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    
    Map<String, String> headers = {};
    
    if (withAuth) {
      if (_authToken == null) {
        // Optionnel : Lancer une erreur ou rediriger l'utilisateur si le token manque
        throw Exception('Authentication required but no token is set.');
      }
      // Ajout de l'en-tête d'authentification Bearer
      headers['Authorization'] = 'Bearer $_authToken';
    }
    
    return await http.get(url, headers: headers);
  }

  // --- POST (similaire, mais pour les données JSON, il faut l'en-tête Content-Type) ---
  static Future<http.Response> post(
    String endpoint, 
    Map<String, dynamic> body, {
    bool withAuth = false, // Ajout du paramètre 'withAuth' pour la cohérence
  }) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    Map<String, String> headers = {
      'Content-Type': 'application/json', // Généralement nécessaire pour les requêtes POST
    };
    
    if (withAuth) {
      if (_authToken != null) {
        headers['Authorization'] = 'Bearer $_authToken';
      }
    }

    return await http.post(
      url, 
      headers: headers,
      body: jsonEncode(body), // N'oubliez pas d'encoder le corps en JSON
    );
  }
}