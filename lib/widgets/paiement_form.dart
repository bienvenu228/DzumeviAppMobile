// --- WIDGET DU FORMULAIRE DE PAIEMENT FEDAPAY ---

// Définition des modes de paiement FedaPay adaptés
import 'package:dzumevimobile/core/constants.dart';
import 'package:dzumevimobile/core/services/concours_api.dart';
import 'package:dzumevimobile/models/candidat.dart';
import 'package:dzumevimobile/models/concours.dart';
import 'package:dzumevimobile/screens/success_screen.dart';
import 'package:flutter/material.dart';

class FedaPayMode {
  final String label;
  final String value;
  final String countryCode;
  final Color color;

  FedaPayMode(this.label, this.value, this.countryCode, this.color);
}

// Liste des modes FedaPay spécifiques pour le Bénin/Togo (XOF)
final List<FedaPayMode> fedapayModes = [
  FedaPayMode('Moov Togo (Flooz)', 'moov_tg', 'TG', AppConstants.floozColor),
  FedaPayMode('Togocel (T-Money)', 'togocel', 'TG', AppConstants.tMoneyColor),
  FedaPayMode(
    'MoMo (MTN)',
    'mtn_gj',
    'BJ',
    AppConstants.secondary,
  ), // Jaune pour MTN Bénin
  FedaPayMode('Moov Bénin (Flooz)', 'moov_gj', 'BJ', AppConstants.floozColor),
  FedaPayMode('Carte Bancaire', 'card', 'ALL', AppConstants.primary),
];

class FedaPayPaymentForm extends StatefulWidget {
  final Candidat candidat;
  final Concours concours;
  final int prixUnitaire; // prix d'un vote en FCFA

  const FedaPayPaymentForm({
    super.key,
    required this.candidat,
    required this.concours,
    required this.prixUnitaire,
  });

  @override
  State<FedaPayPaymentForm> createState() => _FedaPayPaymentFormState();
}

class _FedaPayPaymentFormState extends State<FedaPayPaymentForm> {
  final _formKey = GlobalKey<FormState>();

  // États du formulaire
  String? _fullName;
  String? _email;
  String? _phoneNumber;
  int _numberOfVotes = 1;
  FedaPayMode? _selectedMode;
  bool _isLoading = false;

  // Montant total calculé
  int get _totalAmount => _numberOfVotes * widget.prixUnitaire;

  // Afficher les modes basés sur le code pays du candidat ou du concours si disponible
  List<FedaPayMode> get _filteredModes {
    // Par défaut, nous affichons tous les modes
    return fedapayModes.where((mode) {
      if (mode.countryCode == 'ALL') return true;
      // Simplification : Assumer que le candidat est du pays du concours si disponible
      // Vous pouvez affiner la logique de filtrage ici si nécessaire
      return mode.countryCode == 'TG' || mode.countryCode == 'BJ';
    }).toList();
  }

  void _submitPayment() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_selectedMode == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Veuillez sélectionner un opérateur de paiement."),
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // ----------------------------------------------------------------------
      // --- APPEL API VERS VOTRE BACKEND POUR INITIATION FEDAPAY ---
      // ----------------------------------------------------------------------

      final Map<String, dynamic> dataToSend = {
        'candidat_id': widget.candidat.id,
        // 'name': widget.candidat.fullName,
        'concours_id': widget.concours.id,
        'nombre_votes': _numberOfVotes,
        'amount': _totalAmount, // Montant total en XOF
        'votes': _totalAmount / widget.concours.prixParVote, // Montant total en XOF
        'currency': 'XOF',
        'mode': _selectedMode!.value,
        'country': _selectedMode!.countryCode,
        'name': _fullName,
        'email': _email,
        'phone_number' : _phoneNumber,
      };

      try {
        // Remplacez cette simulation par un véritable appel HTTP à votre API Laravel/Dzumevi_APi
        // Exemple :
        final response = await ApiService.effectuerPaiement((dataToSend));
        if (response.success) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SuccessScreen(
                nombreVotes: _numberOfVotes,
                candidat: widget.candidat,
                montantPaye: _totalAmount,
              ),
            ),
          );
        }
        // SIMULATION
        // await Future.delayed(const Duration(seconds: 3));
        // Fin de la SIMULATION

        // Si l'appel API réussit (code 200/201 et contient l'URL FedaPay)
        // final jsonResponse = json.decode(response.body);
        // if (response.statusCode == 200 && jsonResponse['redirect_url'] != null) {
        //   // Rediriger l'utilisateur vers la page de paiement FedaPay
        //   // Vous utiliserez ici 'url_launcher' ou 'inappwebview'
        //   // launchUrl(Uri.parse(jsonResponse['redirect_url']));
        //
        //   // Affichage de succès simulé:
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text("Redirection vers la page de paiement FedaPay...", style: TextStyle(color: Colors.white)), backgroundColor: Colors.orange),
        //   );

        // } else {
        //   // Gestion des erreurs
        //   throw Exception('Échec de l\'initialisation du paiement: ${jsonResponse['message']}');
        // }

        // GESTION DU SUCCÈS SIMULÉE (temporaire)
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text("✅ Vote de $_numberOfVotes initié. Total: $_totalAmount XOF."),
        //     backgroundColor: Colors.green,
        //   ),
        // );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Erreur de paiement: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // --- NOMBRE DE VOTES / QUANTITÉ ---
          Row(
            children: [
              const Text(
                "Nombre de votes:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              _buildQuantityButton(Icons.remove, () {
                if (_numberOfVotes > 1) {
                  setState(() => _numberOfVotes--);
                }
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '$_numberOfVotes',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildQuantityButton(Icons.add, () {
                setState(() => _numberOfVotes++);
              }),
            ],
          ),
          const SizedBox(height: 15),

          // --- MONTANT TOTAL ---
          Card(
            color: AppConstants.secondary.withOpacity(0.1),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Montant Total à Payer:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "${_totalAmount.toString()} XOF",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppConstants.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 30),

          // --- NOM COMPLET ---
          _buildTextFormField(
            label: 'Nom complet',
            hint: 'Ex: Jean Dupont',
            onSaved: (value) => _fullName = value,
            validator: (value) =>
                value == null || value.isEmpty ? 'Champ requis.' : null,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 15),

          // --- EMAIL ---
          _buildTextFormField(
            label: 'Adresse email',
            hint: 'votre@email.com (reçu)',
            onSaved: (value) => _email = value,
            validator: (value) => value == null || !value.contains('@')
                ? 'Email non valide.'
                : null,
            icon: Icons.alternate_email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 15),

          // --- MODE DE PAIEMENT ---
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Sélectionner l\'opérateur',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF333333),
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio:
                  3.5, // Pour que les cartes ne soient pas trop hautes
            ),
            itemCount: _filteredModes.length,
            itemBuilder: (context, index) {
              final mode = _filteredModes[index];
              final isSelected =
                  _selectedMode?.value == mode.value &&
                  _selectedMode?.countryCode == mode.countryCode;

              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedMode = mode;
                  });
                },
                child: _buildModeCard(mode, isSelected),
              );
            },
          ),
          const SizedBox(height: 15),

          // --- NUMÉRO DE TÉLÉPHONE MOBILE MONEY (S'affiche uniquement pour MM) ---
          if (_selectedMode != null && _selectedMode!.value != 'card')
            _buildTextFormField(
              label: 'Numéro de Téléphone (${_selectedMode!.label})',
              hint:
                  '+${_selectedMode!.countryCode == 'TG' ? '228' : '229'}XXXXXXXX',
              onSaved: (value) => _phoneNumber = value,
              validator: (value) => value == null || value.isEmpty
                  ? 'Veuillez entrer le numéro pour ${_selectedMode!.label}.'
                  : null, // Validation plus stricte sur l'indicatif peut être ajoutée
              icon: Icons.phone_android,
              keyboardType: TextInputType.phone,
            ),
          if (_selectedMode != null && _selectedMode!.value != 'card')
            const SizedBox(height: 30),

          // --- BOUTON PAYER ---
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              onPressed: _isLoading || _selectedMode == null
                  ? null
                  : _submitPayment,
              icon: _isLoading
                  ? const SizedBox.shrink()
                  : const Icon(Icons.send_rounded, size: 24),
              label: _isLoading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Préparation de la transaction...",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    )
                  : Text(
                      "PAYER ${_totalAmount.toString()} XOF",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedMode == null
                    ? Colors.grey
                    : _selectedMode!.color.darken(20),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget utilitaire pour les champs de texte
  Widget _buildTextFormField({
    required String label,
    required String hint,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF333333),
            ),
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: AppConstants.primary.withOpacity(0.8),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 10.0,
            ),
          ),
          keyboardType: keyboardType,
          onSaved: onSaved,
          validator: validator,
        ),
      ],
    );
  }

  // Widget pour les boutons de quantité
  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, color: AppConstants.primary),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      ),
    );
  }

  // Widget pour la carte de sélection du mode de paiement
  Widget _buildModeCard(FedaPayMode mode, bool isSelected) {
    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? mode.color : Colors.grey.shade200,
          width: isSelected ? 2.5 : 1,
        ),
      ),
      color: isSelected ? mode.color.withOpacity(0.1) : Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            mode.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? mode.color.darken(30) : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }
}

// --- EXTENSION DE COULEUR POUR LE DESIGN ---
extension ColorExtension on Color {
  Color darken([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    final f = 1 - percent / 100;
    return Color.fromARGB(
      alpha,
      (red * f).round(),
      (green * f).round(),
      (blue * f).round(),
    );
  }
}
