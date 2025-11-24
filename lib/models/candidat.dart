// lib/models/candidat.dart
class Candidat {
  final int id;
  final String firstname;
  final String matricule;
  final String? description;
  final String categorie;
  final String? photo;
  final int voteId;
  final String? createdAt;
  final String? updatedAt;

  Candidat({
    required this.id,
    required this.firstname,
    this.matricule,
    this.description,
    this.categorie,
    this.photo,
    required this.voteId,
    this.createdAt,
    this.updatedAt,
  });

  factory Candidat.fromJson(Map<String, dynamic> json) {
    return Candidat(
      id: json['id'] ?? 0,
      firstname: json['firstname']?.toString() ?? 'Nom inconnu', // Correction ici
      matricule: json['matricule']?.toString(),
      description: json['description']?.toString(),
      categorie: json['categorie']?.toString(),
      photo: json['photo']?.toString(),
      voteId: json['vote_id'] ?? 0,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  String get fullPhotoUrl {
    if (photo == null || photo!.isEmpty) {
      return '';
    }
    return "http://192.168.0.212/Dzumevi_APi/public/storage/$photo";
  }
}