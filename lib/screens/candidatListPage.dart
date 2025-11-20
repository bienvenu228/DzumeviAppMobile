import 'package:flutter/material.dart';
// Assurez-vous que les chemins d'importation sont corrects pour votre projet
import '../models/candidat.dart'; 
import '../services/candidat_service.dart';

// --- Modèle Candidat pour l'exemple (à supprimer si vous l'avez déjà dans candidat.dart) ---
class Candidat {
  final int id;
  final String nom;
  final String categorie; // Utilisé pour la ville/l'origine sur la capture
  final String descriptionShort;
  final String photo;
  final int votes; // Rendu non nullable car essentiel au classement
  final String firstname;
  final int age; // Ajouté pour l'âge
  
  Candidat({
    required this.id,
    required this.nom,
    required this.categorie,
    required this.descriptionShort,
    required this.photo,
    required this.votes, 
    required this.firstname,
    required this.age,
  });
}



// --- WIDGET PRINCIPAL : CANDIDAT LIST PAGE ---
class CandidatListPage extends StatefulWidget {
  const CandidatListPage({super.key});

  @override
  State<CandidatListPage> createState() => _CandidatListPageState();
}

class _CandidatListPageState extends State<CandidatListPage> {
  // Initialisation du Future et du Service
  late Future<List<Candidat>> _futureCandidats;
  final CandidatService _candidatService = CandidatService();

  @override
  void initState() {
    super.initState();
    // Lance la fonction de récupération des données
    _futureCandidats = _candidatService.fetchCandidats();
  }

  // Fonction pour rafraîchir la liste (utile si vous tirez vers le bas)
  Future<void> _refreshCandidats() async {
    setState(() {
      _futureCandidats = _candidatService.fetchCandidats();
    });
  }

  // Fonction centrale pour gérer l'action de vote
  void _handleVote(Candidat candidat) async {
    // Afficher une boîte de dialogue de confirmation (au lieu d'alert())
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer le Vote'),
          content: Text('Êtes-vous sûr de vouloir voter pour ${candidat.firstname} dans la catégorie ${candidat.categorie} ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annuler', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade800),
              child: const Text('Voter'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // Afficher un indicateur de chargement
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vote en cours...'), duration: Duration(seconds: 1)),
      );

      try {
        // 🚨 Note: On utilise candidat.voteId. Assurez-vous que cette ID est correcte pour la logique de vote.
        final response = await _candidatService.voteForCandidat(candidat.id, candidat.voteId);
        
        // Afficher le succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Vote enregistré avec succès!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        // Afficher l'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Échec du vote: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Candidats'),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshCandidats, // Permet de rafraîchir en tirant vers le bas
        child: FutureBuilder<List<Candidat>>(
          future: _futureCandidats,
          builder: (context, snapshot) {
            
            // 1. État de Chargement
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } 
            
            // 2. État d'Erreur
            else if (snapshot.hasError) {
              // Affiche l'erreur pour le débogage et l'utilisateur
              return Center(
                child: Text(
                  '⚠️ Erreur de chargement: \n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } 
            
            // 3. État des Données Prêtes
            else if (snapshot.hasData) {
              final candidats = snapshot.data!;
              
              // 3.1. Liste Vide
              if (candidats.isEmpty) {
                return const Center(
                  child: Text('Aucun candidat n\'a été créé dans le backend.', style: TextStyle(fontSize: 16)),
                );
              }

              // 3.2. Affichage des Données (Liste)
              return ListView.builder(
                itemCount: candidats.length,
                itemBuilder: (context, index) {
                  final candidat = candidats[index];
                  // Passe la fonction de vote au CandidatCard
                  return CandidatCard(
                    candidat: candidat,
                    onVote: _handleVote,
                  );
                },
              );
            }
            
            // 4. Fallback
            return const Center(child: Text('Initialisation...'));
          },
        ),
      ),
    );
  }
}

// Widget séparé pour l'affichage d'un seul candidat
class CandidatCard extends StatelessWidget {
  final Candidat candidat;
  // Définir la fonction de rappel pour le vote
  final Function(Candidat) onVote; 

  const CandidatCard({super.key, required this.candidat, required this.onVote});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image/Avatar
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue.shade100,
                  child: candidat.photo != null 
                      ? Image.network(candidat.photo!) // Affiche l'image
                      : Text(candidat.firstname[0], style: TextStyle(fontSize: 24, color: Colors.blue.shade900)), // Affiche l'initiale
                ),
                const SizedBox(width: 12),
                // Informations
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        candidat.firstname,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text('Matricule: ${candidat.maticule}', style: const TextStyle(fontSize: 14)),
                      Text('Catégorie: ${candidat.categorie}', style: const TextStyle(fontSize: 14)),
                      if (candidat.description != null && candidat.description!.isNotEmpty)
                        Text('Description: ${candidat.description}', style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            // NOUVEAU BOUTON DE VOTE
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => onVote(candidat), // Appel de la fonction de vote
                icon: const Icon(Icons.thumb_up_alt_rounded, size: 20),
                label: const Text('VOTER POUR CE CANDIDAT', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600, 
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}