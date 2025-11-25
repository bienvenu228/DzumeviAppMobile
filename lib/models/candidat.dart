// lib/models/candidat.dart (version améliorée)
class Candidat {
  final int id;
  final String nom;
  final String prenom;
  final String photo;
  final String description;
  final int votes;
  final int concoursId;

  Candidat({
    required this.id,
    required this.nom,
    required this.prenom,
    this.photo = '',
    this.description = '',
    required this.votes,
    required this.concoursId,
  });

  factory Candidat.fromJson(Map<String, dynamic> json) {
    return Candidat(
      id: json['id'],
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      photo: json['photo'] ?? '',
      description: json['description'] ?? '',
      votes: json['votes'] ?? 0,
      concoursId: json['concours_id'],
    );
  }

  String get nomComplet => '$prenom $nom'.trim();
}