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
      // Assurez-vous que le casting est correct pour la null safety
      id: json['id'] as int,
      nom: json['nom'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
        'email': email,
        'password': password,
      };

  // Ligne 'bool operator [](String other) {}' supprimée.
}