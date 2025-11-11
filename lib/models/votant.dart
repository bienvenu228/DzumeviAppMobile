class Votant {
  final int id;
  final String nom;
  final String prenoms;
  final String numero;
  final String matricule;

  Votant({
    required this.id,
    required this.nom,
    required this.prenoms,
    required this.numero,
    required this.matricule,
  });

  factory Votant.fromJson(Map<String, dynamic> json) {
    return Votant(
      id: json['id'],
      nom: json['nom'],
      prenoms: json['prenoms'],
      numero: json['numero'],
      matricule: json['matricule'],
    );
  }
}
