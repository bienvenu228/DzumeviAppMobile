import 'dart:convert';
import 'package:dzumevimobile/models/candidat.dart';
import 'package:dzumevimobile/models/concours.dart';
import 'package:dzumevimobile/models/paiement.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'http://192.168.0.119:8080/Dzumevi_APi/public/api'; // À adapter

  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur HTTP ${response.statusCode}: ${response.body}');
    }
  }

  // Récupérer tous les concours actifs
  static Future<List<Concours>> getConcoursActifs() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/concours'),
        headers: headers,
      );

      final data = _handleResponse(response);

      if (data['success'] == true) {
        List<dynamic> concoursData = data['data'];
        return concoursData.map((json) => Concours.fromJson(json)).toList();
      } else {
        throw Exception(data['message'] ?? 'Erreur inconnue');
      }
    } catch (e) {
      throw Exception('Erreur réseau: $e');
    }
  }

  // Récupérer les candidats d'un concours (CORRIGÉ)
  static Future<List<Candidat>> getCandidatsByConcours(int concoursId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/concours/$concoursId/candidats'),
        headers: headers,
      );

      final data = _handleResponse(response);

      if (data['success'] == true) {
        List<dynamic> candidatsData = data['data'];

        // Conversion sécurisée avec gestion des null
        return candidatsData.map((json) {
          try {
            return Candidat.fromJson(json);
          } catch (e) {
            // Log l'erreur mais continue avec les autres candidats
            print('Erreur de parsing pour le candidat: $json');
            print('Erreur: $e');
            // Retourne un candidat par défaut pour éviter de casser toute la liste
            return Candidat(
              id: json['id'] ?? 0,
              firstname: json['firstname']?.toString() ?? 'Inconnu',
              lastname: json['lastname']?.toString(),
              name: json['name']?.toString(),
              matricule: json['matricule']?.toString() ?? 'Non fourni',
              description: json['description']?.toString(),
              categorie: json['categorie']?.toString() ?? 'Général',
              photo: json['photo']?.toString(),
              votes: json['votes'] ?? 0,
              concoursId: json['concours_id'] ?? concoursId,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
          }
        }).toList();
      } else {
        throw Exception(data['message'] ?? 'Erreur inconnue');
      }
    } catch (e) {
      throw Exception('Erreur lors du chargement des candidats: $e');
    }
  }

  // Effectuer un paiement
  static Future<PaiementResponse> effectuerPaiement(dynamic dataToSend) async {
    try {
      final body = json.encode({
        'candidat_id': dataToSend["candidat_id"],
        'concours_id': dataToSend["concours_id"],
        'phone_number': dataToSend["phone_number"],
        'amount': dataToSend["amount"],
        'name': dataToSend["name"],
        'email': dataToSend["email"],
        'country': dataToSend["country"],
        'votes': dataToSend["votes"],
        'currency': 'XOF',
        'description': 'Vote pour le candidat${dataToSend["candidat_id"]}',
        'mode': dataToSend["mode"],
        'customer': dataToSend["phone_number"],
      });
      // print(body);
      final response = await http.post(
        Uri.parse('$baseUrl/paiements/${dataToSend["candidat_id"]}/vote'),
        headers: headers,
        body: body,
      );
      final data = _handleResponse(response);
      print(response);

      if (data['success'] == true) {
        print(PaiementResponse.fromJson(data['data']));
        return PaiementResponse.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? 'Erreur lors du paiement');
      }
    } catch (e) {
      print(e);
      throw Exception('Erreur de paiement: $e');
    }
  }

  // Vérifier le statut d'un paiement
  static Future<PaiementResponse> verifierStatutPaiement(
    String transactionId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/paiement/verifier/$transactionId'),
        headers: headers,
      );

      final data = _handleResponse(response);

      if (data['success'] == true) {
        return PaiementResponse.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? 'Erreur de vérification');
      }
    } catch (e) {
      throw Exception('Erreur de vérification: $e');
    }
  }

  static Future<bool> testImageUrl(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
