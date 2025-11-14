class Candidat {
  final int id;
  final String nom;
  final String categorie;
  final String descriptionShort;
  final String photo;
  
  // NOUVEAUX CHAMPS AJOUTÉS ET TYPÉS CORRECTEMENT
  final int? votes; // Essentiel pour le DashboardService
  final String? matricule; 
  final String? firstname;
  final String? description;

  Candidat({
    required this.id,
    required this.nom,
    required this.categorie,
    required this.descriptionShort,
    required this.photo,
    // Ces champs peuvent être nullables s'ils ne sont pas toujours présents
    this.votes, 
    this.matricule,
    this.firstname,
    this.description,
  });

  factory Candidat.fromJson(Map<String, dynamic> json) {
    return Candidat(
      id: json['id'] as int,
      nom: json['nom'] as String,
      categorie: json['categorie'] as String,
      descriptionShort: json['description_short'] as String,
      photo: json['photo'] as String,
      
      // Initialisation des nouveaux champs:
      // Nous utilisons le safe-cast 'as int?' ou 'as String?' pour gérer la nullité.
      votes: json['votes'] is num ? json['votes']?.toInt() : null,
      matricule: json['matricule'] as String?,
      firstname: json['firstname'] as String?,
      description: json['description'] as String?,
    );
  }

  // Suppression des 'get' qui retournaient null et faisaient doublon avec les champs finaux
  // (La déclaration 'final int? votes;' gère maintenant l'accès aux votes.)
}