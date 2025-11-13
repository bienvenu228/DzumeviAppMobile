class Vote {
  final int id;
  final int candidatId;
  final int votantId;
  final DateTime date;

  Vote({
    required this.id,
    required this.candidatId,
    required this.votantId,
    required this.date,
  });

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      id: json['id'],
      candidatId: json['candidat_id'],
      votantId: json['votant_id'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'candidat_id': candidatId,
      'votant_id': votantId,
      'date': date.toIso8601String(),
    };
  }
}
