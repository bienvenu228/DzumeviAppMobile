class Candidat {
  final int id;
  final String nom;
  final String categorie;
  final String descriptionShort;
  final String photo;

  Candidat({
    required this.id,
    required this.nom,
    required this.categorie,
    required this.descriptionShort,
    required this.photo,
  });

  factory Candidat.fromJson(Map<String, dynamic> json) {
    return Candidat(
      id: json['id'],
      nom: json['nom'],
      categorie: json['categorie'],
      descriptionShort: json['description_short'],
      photo: json['photo'],
    );
  }
}
