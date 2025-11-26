
import 'package:dzumevimobile/core/enums/concours_statut.dart';

class Concours {
  final int id;
  final String name;
  final String description;
  final DateTime date;
  final DateTime echeance;
  final ConcoursStatut statut;
  final String? imageUrl;
  final int nombreCandidats;
  final int nombreVotes;

  Concours({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.echeance,
    required this.statut,
    this.imageUrl,
    this.nombreCandidats = 0,
    this.nombreVotes = 0,
  });

  factory Concours.fromJson(Map<String, dynamic> json) {
    return Concours(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      date: DateTime.parse(json['date']),
      echeance: DateTime.parse(json['echeance']),
      statut: ConcoursStatut.fromString(json['statut']),
      imageUrl: json['image_url'],
      nombreCandidats: json['nombre_candidats'] ?? 0,
      nombreVotes: json['nombre_votes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date': date.toIso8601String(),
      'echeance': echeance.toIso8601String(),
      'statut': statut.value,
      'image_url': imageUrl,
      'nombre_candidats': nombreCandidats,
      'nombre_votes': nombreVotes,
    };
  }

  bool get isActive => statut == ConcoursStatut.enCours;
  bool get isComing => statut == ConcoursStatut.aVenir;
  bool get isFinished => statut == ConcoursStatut.passe;
}