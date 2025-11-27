// lib/models/candidat.dart
import 'package:http/http.dart' as http;


class Candidat {
  final int id;
  final String firstname;
  final String? lastname;
  final String? name;
  final String matricule;
  final String? description;
  final String categorie;
  final String? photo;
  final int votes;
  final int concoursId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Candidat({
    required this.id,
    required this.firstname,
    this.lastname,
    this.name,
    required this.matricule,
    this.description,
    required this.categorie,
    this.photo,
    required this.votes,
    required this.concoursId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Candidat.fromJson(Map<String, dynamic> json) {
    return Candidat(
      id: json['id'],
      firstname: json['firstname'] ?? 'Sans nom', // Valeur par défaut
      lastname: json['lastname'],
      name: json['name'],
      matricule: json['matricule'] ?? 'N/A', // Valeur par défaut
      description: json['description'] ?? 'Aucune description', // Valeur par défaut
      categorie: json['categorie'] ?? 'Général', // Valeur par défaut
      photo: json['photo'],
      votes: json['votes'] ?? 0,
      concoursId: json['concours_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Getter pour le nom complet
  String get fullName {
    if (lastname != null) {
      return '$firstname $lastname';
    }
    return firstname;
  }

  // Getter pour l'URL complète de la photo
  String? get photoUrl {
    if (photo == null) return null;
    if (photo!.startsWith('http')) return photo;
    return 'http://192.168.0.41:8080/Dzumevi_APi/storage/app/public/$photo'; // Adaptez l'URL
  }

  // Méthode pour vérifier si l'image existe
  static Future<bool> checkImageExists(String? url) async {
    if (url == null) return false;
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  // Getter pour la description sécurisée
  String get safeDescription {
    return description ?? 'Aucune description disponible';
  }
}