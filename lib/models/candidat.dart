// --- MODÈLE CANDIDAT (Adapté à la réponse JSON de CandidatsController) ---
class Candidat {
  final int id;
  final String? lastname; 
  final String firstname;
  final String maticule;
  final String categorie;
  final String? description;
  final String? photo;
  // ⭐️ CORRECTION : RETIRER FINAL ICI ⭐️
  int votes; // Rendre non-final pour pouvoir l'incrémenter via setState
  final int age; 
  final int voteId;

  Candidat({
    required this.id,
    this.lastname,
    required this.firstname,
    required this.maticule,
    required this.categorie,
    this.description,
    this.photo,
    required this.votes, // Laisser requis dans le constructeur
    required this.age,
    required this.voteId,
  });

  factory Candidat.fromJson(Map<String, dynamic> json) {
    return Candidat(
      id: (json['id'] as num).toInt(),
      lastname: json['lastname'] as String?,
      firstname: json['firstname'] as String,
      maticule: json['maticule'] as String,
      categorie: json['categorie'] as String,
      description: json['description'] as String?,
      photo: json['photo'] as String?,
      votes: (json['votes'] as num? ?? 0).toInt(), 
      age: (json['age'] as num? ?? 20).toInt(),
      voteId: (json['vote_id'] as num).toInt(),
    );
  }
}
// -----------------------------------------------------------------------------------