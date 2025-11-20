class Vote {
  final String id;
  final String name;
  final String date;
  final String echeance;
  final String statuts;

  Vote({
    required this.id,
    required this.name,
    required this.date,
    required this.echeance,
    required this.statuts,
  });

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      echeance: json['echeance'] ?? '',
      statuts: json['statuts'] ?? '',
    );
  }
}
