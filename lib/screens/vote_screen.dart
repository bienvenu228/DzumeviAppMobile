import 'package:dzumevimobile/core/services/api_service.dart';
import 'package:dzumevimobile/models/candidat.dart';
import 'package:dzumevimobile/screens/success_screen.dart';
import 'package:dzumevimobile/widgets/candidat_card.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VoteScreen extends StatefulWidget {
  final Candidat candidat;
  const VoteScreen({required this.candidat});

  @override
  _VoteScreenState createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  final _formKey = GlobalKey<FormState>();
  String nom = '';
  String telephone = '';
  int nombreVotes = 1;
  String operateur = 't-money';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    int montant = nombreVotes * 100; // 100 FCFA par vote (à rendre configurable)

    return Scaffold(
      appBar: AppBar(title: Text("Voter pour ${widget.candidat.prenom} ${widget.candidat.nom}")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Photo + infos candidat
              CandidatCard(candidat: widget.candidat, showVotes: true),
              SizedBox(height: 20),

              TextFormField(
                decoration: InputDecoration(labelText: "Votre nom complet"),
                validator: (v) => v!.isEmpty ? "Obligatoire" : null,
                onChanged: (v) => nom = v,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Téléphone (ex: 90112233)"),
                keyboardType: TextInputType.phone,
                validator: (v) => v!.length < 8 ? "Numéro invalide" : null,
                onChanged: (v) => telephone = v,
              ),

              SizedBox(height: 20),
              Text("Nombre de votes", style: TextStyle(fontSize: 18)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: () => setState(() => nombreVotes > 1 ? nombreVotes-- : null), icon: Icon(Icons.remove)),
                  Text("$nombreVotes vote(s)", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => setState(() => nombreVotes++), icon: Icon(Icons.add)),
                ],
              ),
              Text("Montant total : $montant FCFA", style: TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold)),

              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: operateur,
                items: [
                  DropdownMenuItem(value: "t-money", child: Text("TMoney (Togocel)")),
                  DropdownMenuItem(value: "flooz", child: Text("Flooz (Moov)")),
                ],
                onChanged: (v) => setState(() => operateur = v!),
              ),

              SizedBox(height: 30),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => isLoading = true);
                          try {
                            var result = await ApiService.initierPaiement(
                              candidatId: widget.candidat.id,
                              nomVotant: nom,
                              nombreVotes: nombreVotes,
                              telephone: telephone,
                              operateur: operateur,
                            );

                            // L'API te renvoie normalement une URL de paiement ou un code USSD
                            String paymentUrl = result['payment_url'];
                            // ou result['ussd_code']

                            if (paymentUrl.startsWith('http')) {
                              launchUrl(Uri.parse(paymentUrl));
                            } else {
                              // Afficher code USSD
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Composez $paymentUrl")));
                            }

                            // Optionnel : polling pour vérifier si paiement réussi
                            Navigator.push(context, MaterialPageRoute(builder: (_) => SuccessScreen(nombreVotes: nombreVotes, candidat: widget.candidat)));

                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur: $e")));
                          }
                          setState(() => isLoading = false);
                        }
                      },
                      child: Text("PAYER $montant FCFA ET VOTER", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}