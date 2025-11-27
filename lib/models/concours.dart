class Concours {
  final int id;
  final String name;
  final String description;
  final DateTime dateDebut;
  final DateTime dateFin;
  final String statut;
  final String? imageUrl;
  final double prixParVote;
  final int nombreCandidats;
  final int nombreVotes;
  final double totalRecettes;
  final bool isActive;

  Concours({
    required this.id,
    required this.name,
    required this.description,
    required this.dateDebut,
    required this.dateFin,
    required this.statut,
    this.imageUrl,
    required this.prixParVote,
    required this.nombreCandidats,
    required this.nombreVotes,
    required this.totalRecettes,
    required this.isActive,
  });

  factory Concours.fromJson(Map<String, dynamic> json) {
    return Concours(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      dateDebut: DateTime.parse(json['date_debut']),
      dateFin: DateTime.parse(json['date_fin']),
      statut: json['statut'],
      imageUrl: json['image_url'],
      prixParVote: double.parse(json['prix_par_vote'].toString()),
      nombreCandidats: json['nombre_candidats'] ?? 0,
      nombreVotes: json['nombre_votes'] ?? 0,
      totalRecettes: double.parse(json['total_recettes']?.toString() ?? '0'),
      isActive: json['is_active'] ?? true,
    );
  }

  // Méthode utilitaire pour vérifier si le concours est actif
  bool get estActif {
    final now = DateTime.now();
    return isActive && dateDebut.isBefore(now) && dateFin.isAfter(now);
  }
}