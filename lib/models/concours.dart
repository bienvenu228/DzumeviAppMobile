class Concours {
  final int id;
  final String name;
  final String date;
  final String echeance;
  final String statut;

  Concours({
    required this.id,
    required this.name,
    required this.date,
    required this.echeance,
    required this.statut,
  });

  factory Concours.fromJson(Map<String, dynamic> json) {
    return Concours(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      echeance: json['echeance'],
      statut: json['statut'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date,
      'echeance': echeance,
      'statut': statut,
    };
  }
}
