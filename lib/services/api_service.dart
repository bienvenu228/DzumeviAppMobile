// services/api_service.dart

class ApiService {
  // static const String baseUrl = 'http://127.0.0.1:8000/api';
  static const String baseUrl = 'http://192.168.0.30/Dzumevi_APi/public/api';
  
  // NOTE: Dans un vrai projet, vous devriez avoir un service pour stocker/récupérer le token.
  // Ce token doit être récupéré et stocké après la connexion de l'utilisateur.
  static String? _authToken; 

  // Méthode utilitaire pour construire les en-têtes JSON
  static Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // Ajoutez ici d'autres en-têtes comme l'Authorization Bearer Token si nécessaire
    };
  }
}