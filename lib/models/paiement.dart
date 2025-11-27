class PaiementResponse {
  final bool success;
  final String message;
  final String? paymentUrl;
  final String? transactionId;
  final String? status;
  final String? reference;

  PaiementResponse({
    required this.success,
    required this.message,
    this.paymentUrl,
    this.transactionId,
    this.status,
    this.reference,
  });

  factory PaiementResponse.fromJson(Map<String, dynamic> json) {
    return PaiementResponse(
      success: json['success'] ?? false,
      message: json['message'],
      paymentUrl: json['payment_url'],
      transactionId: json['transaction_id'],
      status: json['status'],
      reference: json['reference'],
    );
  }
}