// lib/models/payment_details.dart
/// Modèle pour encapsuler toutes les données nécessaires à l'initiation d'un paiement FedaPay.
class PaymentDetails {
  final int candidatId;
  final int voteId;
  final String name;
  final String email;
  final String phoneNumber;
  final String country;
  final double amount;
  final String currency;
  final String description;
  final String mode; // Ex: 'mtn_open', 'moov', 'airtel'

  PaymentDetails({
    required this.candidatId,
    required this.voteId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.country,
    required this.amount,
    required this.currency,
    required this.description,
    required this.mode,
  });

  // Convertit l'objet en Map pour l'envoi à l'API.
  Map<String, dynamic> toJson() {
    return {
      'candidat_id': candidatId,
      'vote_id': voteId,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'country': country,
      'amount': amount,
      'currency': currency,
      'description': description,
      'mode': mode,
    };
  }
}