class Candidat {
  int id;
  final String? lastname;
  final String firstname;
  final String matricule;
  final String categorie;
  final String? description;
  final String? photo;
  int votes; // non-final pour pouvoir l’incrémenter
  final int age;
  final int voteId;

  Candidat({
    required this.id,
    this.lastname,
    required this.firstname,
    required this.matricule,
    required this.categorie,
    this.description,
    this.photo,
    required this.votes,
    required this.age,
    required this.voteId,
  });

  factory Candidat.fromJson(Map<String, dynamic> json) {
    return Candidat(
      id: (json['id'] as num).toInt(),
      lastname: json['lastname'] as String?,
      firstname: json['firstname'] as String,
      matricule: json['matricule'] as String,
      categorie: json['categorie'] as String,
      description: json['description'] as String?,
      photo: json['photo'] as String?,
      votes: (json['votes'] as num? ?? 0).toInt(),
      age: (json['age'] as num? ?? 20).toInt(),
      voteId: (json['vote_id'] as num).toInt(),
    );
  }
}
