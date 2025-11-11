class Admin {
  final int id;
  final String nom;
  final String email;
  final String password;

  Admin({
    required this.id,
    required this.nom,
    required this.email,
    required this.password,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'],
      nom: json['nom'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
        'email': email,
        'password': password,
      };
}
