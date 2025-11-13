class Candidat {
  final int id;
  final String firstname;
  final String lastname;
  final String categorie;
  final String photo;

  Candidat({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.categorie,
    required this.photo,
  });

  factory Candidat.fromJson(Map<String, dynamic> json) {
    return Candidat(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      categorie: json['categorie'] ?? '',
      photo: json['photo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'categorie': categorie,
      'photo': photo,
    };
  }
}
