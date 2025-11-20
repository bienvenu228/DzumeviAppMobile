class Candidat {
  final String id;
  final String firstname;
  final String lastname;
  final String matricule;
  final String description;
  final String categorie;
  final String photoUrl;
  final String voteId;
  final int votes; // ajout du nombre de votes

  Candidat({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.matricule,
    required this.description,
    required this.categorie,
    required this.photoUrl,
    required this.voteId,
    required this.votes,
  });

  factory Candidat.fromJson(Map<String, dynamic> json) {
    return Candidat(
      id: json['id'].toString(),
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      matricule: json['matricule'] ?? '',
      description: json['description'] ?? '',
      categorie: json['categorie'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      voteId: json['vote_id'].toString(),
      votes: json['votes'] ?? 0, // par défaut 0
    );
  }
}
