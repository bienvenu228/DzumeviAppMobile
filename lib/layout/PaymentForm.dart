// lib/components/payment_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/candidat.dart';
import '../models/payment_details.dart';
import '../providers/candidat_provider.dart';

// Constantes de paiement
const List<String> availablePaymentModes = ['mtn_open', 'moov', 'airtel', 't_money'];
const double defaultVoteAmount = 100.0;
const String defaultCurrency = 'XOF';
const String defaultCountry = 'BJ';

class PaymentForm extends ConsumerStatefulWidget {
  final Candidat candidat;
  final InputDecoration inputDecoration;
  final String Function(String) formatModeName;

  const PaymentForm({
    super.key,
    required this.candidat,
    required this.inputDecoration,
    required this.formatModeName,
  });

  @override
  ConsumerState<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends ConsumerState<PaymentForm> {
  String name = 'Amiir OURO-AKPO';
  String email = 'amiirkhazri@gmail.com';
  String phoneNumber = '+22892646688';
  String mode = availablePaymentModes.first;
  bool isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => isLoading = true);

    try {
      final paymentDetails = PaymentDetails(
        candidatId: widget.candidat.id,
        voteId: widget.candidat.voteId,
        name: name,
        email: email,
        phoneNumber: phoneNumber.replaceAll(' ', ''),
        country: defaultCountry,
        amount: defaultVoteAmount,
        currency: defaultCurrency,
        description: 'Vote pour ${widget.candidat.firstname} (${widget.candidat.matricule})',
        mode: mode,
      );

      await ref.read(candidatNotifierProvider.notifier).voteForCandidat(paymentDetails);
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Paiement initié avec succès!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Échec du paiement: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // En-tête
          Text(
            'Voter pour ${widget.candidat.firstname}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Montant: ${defaultVoteAmount.toInt()} $defaultCurrency',
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Champs du formulaire
          TextFormField(
            initialValue: name,
            decoration: widget.inputDecoration.copyWith(labelText: 'Nom Complet'),
            validator: (value) => value!.isEmpty ? 'Entrez votre nom' : null,
            onSaved: (value) => name = value!,
          ),
          const SizedBox(height: 12),

          TextFormField(
            initialValue: email,
            decoration: widget.inputDecoration.copyWith(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => value!.isEmpty || !value.contains('@') ? 'Email invalide' : null,
            onSaved: (value) => email = value!,
          ),
          const SizedBox(height: 12),

          TextFormField(
            initialValue: phoneNumber,
            decoration: widget.inputDecoration.copyWith(labelText: 'Téléphone'),
            keyboardType: TextInputType.phone,
            validator: (value) => value!.isEmpty ? 'Numéro invalide' : null,
            onSaved: (value) => phoneNumber = value!,
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: mode,
            decoration: widget.inputDecoration.copyWith(labelText: 'Mode de Paiement'),
            items: availablePaymentModes.map((m) {
              return DropdownMenuItem(
                value: m,
                child: Text(widget.formatModeName(m)),
              );
            }).toList(),
            onChanged: (value) => setState(() => mode = value!),
          ),
          const SizedBox(height: 20),

          // Boutons
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                  child: const Text('ANNULER'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submitPayment,
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('PAYER ${defaultVoteAmount.toInt()} $defaultCurrency'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}