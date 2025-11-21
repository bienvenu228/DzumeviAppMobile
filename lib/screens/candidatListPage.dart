// lib/pages/candidat_list_page.dart
import 'package:flutter/material.dart';
import 'dart:ui'; // Import nécessaire pour BackdropFilter (effet de flou)
import 'dart:convert'; 

// Assurez-vous que les chemins d'importation sont corrects pour votre projet
import '../services/candidat_service.dart';
import '../models/candidat.dart'; 
import '../models/payment_details.dart'; 

// --- CONSTANTES DE PAIEMENT ---
const List<String> availablePaymentModes = [
  'mtn_open', 'moov', 'airtel', 't_money' 
];
const double defaultVoteAmount = 100.0; 
const String defaultCurrency = 'XOF';
const String defaultCountry = 'BJ'; 

// ----------------------------------------------------------------------
// --- WIDGET PRINCIPAL : CANDIDAT LIST PAGE (Aucune modification majeure) ---
// ----------------------------------------------------------------------
class CandidatListPage extends StatefulWidget {
  const CandidatListPage({super.key});

  @override
  State<CandidatListPage> createState() => _CandidatListPageState();
}

class _CandidatListPageState extends State<CandidatListPage> {
  late Future<List<Candidat>> _futureCandidats;
  final CandidatService _candidatService = CandidatService();

  @override
  void initState() {
    super.initState();
    _futureCandidats = _candidatService.fetchCandidats();
  }

  Future<void> _refreshCandidats() async {
    setState(() {
      _futureCandidats = _candidatService.fetchCandidats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toutes les candidates'), 
        elevation: 0,
      ),
      body: SingleChildScrollView( 
        child: Column(
          children: [
            RefreshIndicator(
              onRefresh: _refreshCandidats, 
              child: ConstrainedBox( 
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 50, 
                ),
                child: FutureBuilder<List<Candidat>>(
                  future: _futureCandidats,
                  builder: (context, snapshot) {
                    
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(30.0),
                        child: CircularProgressIndicator(),
                      ));
                    } 
                    
                    else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          '⚠️ Erreur de chargement: \n${snapshot.error}', 
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      );
                    } 
                    
                    else if (snapshot.hasData) {
                      final candidats = snapshot.data!;
                      
                      if (candidats.isEmpty) {
                        return const Center(
                          child: Text('Aucun candidat n\'a été créé dans le backend.', style: TextStyle(fontSize: 16)),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.all(12.0),
                        shrinkWrap: true, 
                        primary: false, 
                        itemCount: candidats.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, 
                          childAspectRatio: 0.55, 
                          crossAxisSpacing: 12.0, 
                          mainAxisSpacing: 12.0, 
                        ),
                        itemBuilder: (context, index) {
                          final candidat = candidats[index];
                          return CandidatCard(
                            candidat: candidat,
                            candidatService: _candidatService,
                          );
                        },
                      );
                    }
                    
                    return const Center(child: Text('Initialisation...'));
                  },
                ),
              ),
            ),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// --- WIDGET SÉPARÉ : CANDIDAT CARD (Gestion du clic pour le dialogue) ---
// ----------------------------------------------------------------------
class CandidatCard extends StatefulWidget {
  final Candidat candidat;
  final CandidatService candidatService;

  const CandidatCard({
    super.key, 
    required this.candidat,
    required this.candidatService,
  });

  @override
  State<CandidatCard> createState() => _CandidatCardState();
}

class _CandidatCardState extends State<CandidatCard> {
  // Décoration stylisée pour tous les champs du formulaire (conservée ici pour le dialogue)
  final InputDecoration _inputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.blue.shade700, width: 2.0),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Padding légèrement augmenté
    isDense: true,
    labelStyle: const TextStyle(fontSize: 12, color: Colors.grey),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
  );

  String _formatModeName(String mode) {
    return mode.replaceAll('_', ' ').toUpperCase();
  }

  // NOUVELLE FONCTION : Affiche le formulaire dans une boîte de dialogue centrée
  void _showPaymentDialog(Candidat candidat) {
    // Les variables d'état du formulaire sont maintenant locales au dialogue
    String name = 'Amiir OURO-AKPO';
    String email = 'amiirkhazri@gmail.com';
    String phoneNumber = '+22892646688';
    String mode = availablePaymentModes.first;
    bool isLoading = false; 

    showDialog(
      context: context,
      barrierDismissible: true, // Permet de fermer en cliquant à l'extérieur
      builder: (BuildContext context) {
        return StatefulBuilder( // Utilise StatefulBuilder pour gérer l'état local du dialogue (isLoading, mode)
          builder: (context, setDialogState) {
            final formKey = GlobalKey<FormState>();

            void submitPayment() async {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                
                setDialogState(() {
                  isLoading = true;
                });

                final paymentDetails = PaymentDetails(
                  candidatId: candidat.id,
                  voteId: candidat.voteId, 
                  name: name,
                  email: email,
                  phoneNumber: phoneNumber.replaceAll('', ''),
                  country: defaultCountry,
                  amount: defaultVoteAmount, 
                  currency: defaultCurrency,
                  description: 'Vote pour ${candidat.firstname} (${candidat.matricule})',
                  mode: mode,
                );

                final scaffoldMessenger = ScaffoldMessenger.of(context);
                
                try {
                  final response = await widget.candidatService.voteForCandidat(paymentDetails);
                  
                  // Ferme le dialogue
                  Navigator.of(context).pop(); 

                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(response['message'] ?? 'Paiement initié avec succès!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  
                } catch (e) {
                  // Ferme le dialogue
                  Navigator.of(context).pop(); 
                  print(e);

                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Échec du paiement/vote: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } finally {
                  // S'assure de réinitialiser l'état (bien que le dialogue soit fermé, c'est une bonne pratique)
                  setDialogState(() {
                    isLoading = false;
                  });
                }
              }
            }

            // --- WIDGET DU DIALOGUE (Boîte de notification centrée) ---
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              contentPadding: EdgeInsets.zero,
              // Utilisation de BackdropFilter pour l'effet de flou sur l'arrière-plan
              backgroundColor: Colors.transparent, // Rendre la couleur de l'arrière-plan du dialogue transparente
              elevation: 0, // Enlever l'ombre pour la mise en scène du flou
              
              // Le Container principal est placé dans le Center du Dialogue (c'est le secret du centrage)
              content: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: BackdropFilter(
                  // Configurer le flou
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4), 
                  child: Container(
                    width: 380, // Limiter la largeur du formulaire pour qu'il ne soit pas trop large
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95), // Fond blanc semi-transparent
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                      ],
                    ),
                    
                    // --- Contenu du Formulaire (Similaire à l'ancien secondChild) ---
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Text(
                                'Voter pour ${candidat.firstname}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            const Divider(height: 20, thickness: 1),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Text(
                                'Détails du Paiement (${defaultVoteAmount.toInt()} $defaultCurrency)', 
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14) 
                              ),
                            ),
                            
                            // --- NOM COMPLET ---
                            TextFormField(
                              initialValue: name,
                              decoration: _inputDecoration.copyWith(
                                labelText: 'Nom Complet',
                                prefixIcon: const Icon(Icons.person, size: 16, color: Colors.grey),
                              ),
                              keyboardType: TextInputType.name,
                              validator: (value) => value!.isEmpty ? 'Entrez votre nom.' : null,
                              onSaved: (value) => name = value!,
                            ),
                            const SizedBox(height: 12), 

                            // --- EMAIL ---
                            TextFormField(
                              initialValue: email,
                              decoration: _inputDecoration.copyWith(
                                labelText: 'Email',
                                prefixIcon: const Icon(Icons.email, size: 16, color: Colors.grey),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) => value!.isEmpty || !value.contains('@') ? 'Email invalide.' : null,
                              onSaved: (value) => email = value!,
                            ),
                            const SizedBox(height: 12), 

                            // --- NUMÉRO DE TÉLÉPHONE ---
                            TextFormField(
                              initialValue: phoneNumber,
                              decoration: _inputDecoration.copyWith(
                                labelText: 'Téléphone (+228...)',
                                prefixIcon: const Icon(Icons.phone, size: 16, color: Colors.grey),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) => value!.isEmpty || !RegExp(r'^\+?[0-9]{8,15}$').hasMatch(value) 
                                   ? 'Numéro invalide.' 
                                   : null,
                              onSaved: (value) => phoneNumber = value!,
                            ),
                            const SizedBox(height: 12), 

                            // --- MODE DE PAIEMENT (Menu déroulant) ---
                            DropdownButtonFormField<String>(
                              decoration: _inputDecoration.copyWith(
                                labelText: 'Mode de Paiement',
                                prefixIcon: const Icon(Icons.payment, size: 16, color: Colors.grey),
                              ),
                              style: const TextStyle(fontSize: 12, color: Colors.black),
                              dropdownColor: Colors.white,
                              value: mode,
                              items: availablePaymentModes.map((String m) {
                                return DropdownMenuItem<String>(
                                  value: m,
                                  child: Text(_formatModeName(m)), 
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setDialogState(() {
                                  mode = newValue!;
                                });
                              },
                              validator: (value) => value == null ? 'Sélectionnez un mode.' : null,
                              onSaved: (value) => mode = value!,
                            ),
                            const SizedBox(height: 20), 

                            // --- BOUTON DE SOUMISSION / ANNULER ---
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                                  child: const Text('ANNULER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton.icon(
                                  onPressed: isLoading ? null : submitPayment,
                                  icon: isLoading 
                                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                                    : const Icon(Icons.send, size: 16), 
                                  label: Text(
                                    isLoading ? 'TRAITEMENT...' : 'PAYER ${defaultVoteAmount.toInt()} $defaultCurrency', 
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)
                                  ), 
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade700,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15), 
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasPhotoUrl = widget.candidat.photo != null && widget.candidat.photo!.isNotEmpty;
    final Color buttonColor = const Color.fromRGBO(216, 44, 150, 1.0); 

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.stretch, 
        children: [
          // --- Image (Haut de la carte) ---
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                // ... (Reste du code de l'image)
                AspectRatio(
                  aspectRatio: 0.8 / 1, 
                  child: hasPhotoUrl
                      ? Image.network(
                          widget.candidat.photo!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey.shade200, 
                            child: const Center(child: Icon(Icons.person, size: 40, color: Colors.grey)),
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade200, 
                          child: const Center(child: Icon(Icons.person, size: 40, color: Colors.grey)),
                        ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '${(600 + widget.candidat.id * 50) % 1500 + 500} votes', 
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),

          // --- Détails du Candidat (Milieu de la carte) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max, 
              children: [
                Text(
                  widget.candidat.firstname, 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), 
                  textAlign: TextAlign.left,
                ),
                // Ligne de détails
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 10, color: Colors.grey.shade700), 
                    const SizedBox(width: 2),
                    Text(
                      widget.candidat.matricule ?? 'Lieu inconnu', 
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade700), 
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.person_outline, size: 10, color: Colors.grey), 
                    const SizedBox(width: 2),
                    Text(
                      '${(20 + widget.candidat.id) % 5 + 20} ans', 
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade700), 
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // Description (Tronquée)
                Text(
                  widget.candidat.description ?? 'Pas de description.',
                  style: const TextStyle(fontSize: 9), 
                  maxLines: 3, 
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          const Spacer(), 
          
          // --- Bouton VOTE (Bas de la carte) ---
          Padding(
            padding: const EdgeInsets.all(6.0), 
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // APPEL À LA NOUVELLE FONCTION DE DIALOGUE
                onPressed: () {
                  // _isFormExpanded n'est plus utilisé ici, on ouvre directement le dialogue
                  _showPaymentDialog(widget.candidat); 
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8), 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  backgroundColor: buttonColor, 
                  foregroundColor: Colors.white,
                  elevation: 5,
                ).copyWith(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return buttonColor.withOpacity(0.8); 
                      }
                      return buttonColor;
                    },
                  ),
                ),
                child: Text(
                  'Voter pour ${widget.candidat.firstname}', // Le bouton ANNULER est dans le dialogue
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10), 
                ),
              ),
            ),
          ),
          
          // --- L'ancienne section AnimatedCrossFade a été supprimée ---
        ],
      ),
    );
  }
}

// --- WIDGET : FOOTER (Pied de page, inchangé) ---
class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade900, 
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const Text(
            '© 2024 Plateforme de Vote. Tous droits réservés.',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 10),
          const Text(
            'Paiement sécurisé via',
            style: TextStyle(color: Colors.white54, fontSize: 10),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPaymentLogo('TMoney', Colors.green.shade700),
              const SizedBox(width: 10),
              _buildPaymentLogo('Flooz', Colors.orange.shade700),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentLogo(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}