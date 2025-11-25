// lib/models/vote_result.dart
class VoteResult {
  final int id;
  final String name;
  final String city;
  final String image;
  final int votes;
  final double percent;
  final int rank;

  VoteResult({
    required this.id,
    required this.name,
    required this.city,
    required this.image,
    required this.votes,
    required this.percent,
    required this.rank,
  });

  factory VoteResult.fromJson(Map<String, dynamic> json) {
    return VoteResult(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? 'Nom inconnu', // Correction ici
      city: json['city']?.toString() ?? 'Ville inconnue',
      image: json['image']?.toString() ?? '',
      votes: json['votes'] ?? 0,
      percent: (json['percent'] ?? 0.0).toDouble(),
      rank: json['rank'] ?? 0,
    );
  }

  String get fullImageUrl {
    if (image.isEmpty) {
      return 'https://i.imgur.com/AKdB9s1.png'; // Image par défaut
    }
    if (image.startsWith('http')) {
      return image;
    }
    return "http://192.168.0.212/Dzumevi_APi/public/storage/$image";
  }
}