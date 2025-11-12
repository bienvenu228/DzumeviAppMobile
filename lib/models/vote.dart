class Vote {
  final int id;
  final String nom;
  final String date;
  final String echeance;
  final String statut;

  Vote({
    required this.id,
    required this.nom,
    required this.date,
    required this.echeance,
    required this.statut,
  });

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      id: json['id'],
      nom: json['nom'],
      date: json['date'],
      echeance: json['echeance'],
      statut: json['statuts'],
    );
  }
}
