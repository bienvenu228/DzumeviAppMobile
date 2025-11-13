class Transaction {
  final int id;
  final String votant;
  final double montant;
  final String date;

  Transaction({
    required this.id,
    required this.votant,
    required this.montant,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      votant: json['votant'],
      montant: double.tryParse(json['montant'].toString()) ?? 0,
      date: json['created_at'] ?? '',
    );
  }
}
