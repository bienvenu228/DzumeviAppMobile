// lib/models/candidat.dart
class Candidat {
  final int id;
  final String firstname;
  final String lastname;
  final String description;
  final String categorie;
  final String matricule;
  final int votes;
  final String? photo;

  Candidat({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.description,
    required this.categorie,
    required this.matricule,
    required this.votes,
    this.photo,
  });

  String get fullName => '$firstname $lastname';

  factory Candidat.fromJson(Map<String, dynamic> json) {
    return Candidat(
      id: json['id'] ?? 0,
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      description: json['description'] ?? '',
      categorie: json['categorie'] ?? '',
      matricule: json['matricule'] ?? '',
      votes: json['votes'] ?? 0,
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'description': description,
      'categorie': categorie,
      'matricule': matricule,
      'votes': votes,
      'photo': photo,
    };
  }
}