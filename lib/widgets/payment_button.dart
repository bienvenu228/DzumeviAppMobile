// lib/widgets/payment_button.dart
import 'package:flutter/material.dart';
import '../core/constants.dart';

class PaymentButton extends StatelessWidget {
  final String operateur; // "t-money" ou "flooz"
  final VoidCallback onPressed;
  final bool isLoading;
  final int montant;

  const PaymentButton({
    Key? key,
    required this.operateur,
    required this.onPressed,
    this.isLoading = false,
    required this.montant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isTMoney = operateur == "t-money";

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isTMoney ? AppConstants.tMoneyColor : AppConstants.floozColor,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: isTMoney ? Colors.green : Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 28,
                width: 28,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo opérateur (simple icône)
                  Icon(
                    isTMoney ? Icons.phone_android : Icons.send_to_mobile,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isTMoney ? "PAYER AVEC TMONEY" : "PAYER AVEC FLOOZ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "$montant FCFA",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}