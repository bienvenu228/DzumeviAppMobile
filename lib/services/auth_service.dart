import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/admin.dart';
import '../models/votant.dart';

// Importez votre service de stockage ici (ex: import 'package:flutter_secure_storage/flutter_secure_storage.dart';)

class AuthService {
  final String baseUrl = "https://mon-api.com/api";
  
  // NOTE: Dans une vraie application, vous devriez utiliser un service sécurisé
  // pour stocker le token au lieu de cette ligne.
  // final storage = const FlutterSecureStorage(); 

  // --- Méthodes de Connexion (Laissées intactes) ---

  Future<Admin> loginAdmin(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/admin/login'),
      body: {'email': email, 'password': password},
    );

    if (res.statusCode == 200) {
      // TODO: Stocker le token de l'admin après la connexion réussie
      return Admin.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Erreur de connexion admin');
    }
  }

  Future<Votant> loginVotant(String matricule) async {
    final res = await http.post(
      Uri.parse('$baseUrl/votants/login'),
      body: {'matricule': matricule},
    );

    if (res.statusCode == 200) {
      // TODO: Stocker le token du votant après la connexion réussie
      return Votant.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Erreur de connexion votant');
    }
  }

  // -------------------------------------------------------------------
  // --- CORRECTION 1 : isAuthenticated doit retourner Future<bool> ---
  // -------------------------------------------------------------------

  Future<bool> isAuthenticated() async {
    // 1. Récupérer le token stocké localement
    // String? token = await storage.read(key: 'jwt_token'); 
    
    // Pour l'exemple, supposons que nous récupérons le token d'un placeholder
    String? token = "TEMP_TOKEN"; // REMPLACER PAR LA LOGIQUE DE STOCKAGE

    if (token == null) {
      return false; // Pas de token stocké, donc pas authentifié
    }
    
    // 2. Vérifier si le token est valide auprès de l'API
    final res = await http.get(
      Uri.parse('$baseUrl/votants/me'),
      headers: {'Authorization': 'Bearer $token'},
    );

    // 3. Retourner true si le token est accepté (Status 200)
    if (res.statusCode == 200) {
      return true;
    } else {
      // Optionnel : Effacer le token s'il est invalide (401, 403)
      // await storage.delete(key: 'jwt_token'); 
      return false;
    }
  }

  // -------------------------------------------------------------------
  // --- CORRECTION 2 : getUserType doit retourner Future<String> ---
  // -------------------------------------------------------------------

  Future<String> getUserType() async {
    // 1. Récupérer le token (similaire à isAuthenticated)
    // String? token = await storage.read(key: 'jwt_token');
    String? token = "TEMP_TOKEN"; // REMPLACER PAR LA LOGIQUE DE STOCKAGE

    if (token == null) {
      // Si on n'a pas de token, on ne peut pas être authentifié, on lance une erreur
      throw Exception('Tentative de récupérer le type utilisateur sans token.');
    }

    final res = await http.get(
      Uri.parse('$baseUrl/user/type'),
      headers: {'Authorization': 'Bearer $token'}, // L'API a besoin de l'auth pour savoir qui vous êtes
    );
    
    if (res.statusCode == 200) {
      final jsonResponse = jsonDecode(res.body);
      
      // Assurez-vous que votre API retourne bien une structure qui contient le 'type'
      if (jsonResponse.containsKey('type')) {
        return jsonResponse['type'] as String; // Doit retourner 'admin' ou 'votant'
      } else {
        throw Exception("API response missing 'type' field.");
      }
    } else {
      // Si la vérification échoue, on suppose qu'on ne peut pas déterminer le type
      throw Exception('Failed to fetch user type. Status Code: ${res.statusCode}');
    }
  }
}