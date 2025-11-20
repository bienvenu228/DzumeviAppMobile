// services/api_service.dart

class ApiService {
  // ⚠️ Remplacez cette URL par l'adresse IP de votre machine (pour un téléphone physique) 
  // ou '10.0.2.2' (pour un émulateur Android) ou 'localhost' (pour iOS Simulator).
  static const String baseUrl = "http://127.0.0.1:8000/api"; 

  // Méthode utilitaire pour construire les en-têtes JSON
  static Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // Ajoutez ici d'autres en-têtes comme l'Authorization Bearer Token si nécessaire
    };
  }
}