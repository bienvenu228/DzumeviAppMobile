class Votant {
  final int id;
  final String firstname;
  final String lastname;
  final String email;
  final String number;
  final String matricule;

  Votant({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.number,
    required this.matricule,
  });

  factory Votant.fromJson(Map<String, dynamic> json) {
    return Votant(
      id: json['id'],
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
      number: json['number'] ?? '',
      matricule: json['matricule'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'number': number,
      'matricule': matricule,
    };
  }

  String get fullName => "$firstname $lastname";
}
