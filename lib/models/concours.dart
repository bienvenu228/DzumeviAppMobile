class Concours {
  final int id;
  final String titre;
  final String description;
  final String image;           // URL ou chemin de l'image du concours
  final DateTime dateDebut;
  final DateTime dateFin;
  // final bool estActif;
  final int prixParVote;        // FCFA par vote (peut varier par concours)
  final int totalVotes;
  final int totalRecettes;

  Concours({
    required this.id,
    required this.titre,
    required this.description,
    required this.image,
    required this.dateDebut,
    required this.dateFin,
    // required this.estActif,
    this.prixParVote = 100,
    this.totalVotes = 0,
    this.totalRecettes = 0,
  });

  factory Concours.fromJson(Map<String, dynamic> json) {
    return Concours(
      id: json['id'] as int,
      titre: json['titre'] as String,
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      dateDebut: DateTime.parse(json['date_debut'] as String),
      dateFin: DateTime.parse(json['date_fin'] as String),
      // estActif: json['est_actif'] as bool? ?? true,
      prixParVote: json['prix_par_vote'] as int? ?? 100,
      totalVotes: json['total_votes'] as int? ?? 0,
      totalRecettes: json['total_recettes'] as int? ?? 0,
    );
  }

  // Utile pour les logs ou debug
  // @override
  // String toString() {
  //   return 'Concours{id: $id, titre: $titre, actif: $estActif}';
  // }

//   bool get estTermine => DateTime.now().isAfter(dateFin);
//   bool get estEnCours => estActif && !estTermine;
}