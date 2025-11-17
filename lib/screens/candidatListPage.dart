import 'package:flutter/material.dart';
// Importez votre modèle Candidat si ce fichier n'est pas dans le même dossier
// import 'candidat.dart'; 

// --- Modèle Candidat pour l'exemple (à supprimer si vous l'avez déjà dans candidat.dart) ---
class Candidat {
  final int id;
  final String nom;
  final String categorie; // Utilisé pour la ville/l'origine sur la capture
  final String descriptionShort;
  final String photo;
  final int? votes;
  final String? firstname;
  final int? age; // Ajouté pour l'âge
  
  Candidat({
    required this.id,
    required this.nom,
    required this.categorie,
    required this.descriptionShort,
    required this.photo,
    this.votes, 
    this.firstname,
    this.age,
  });
  // J'ai enlevé les autres champs pour la simplicité de la liste, 
  // mais vous pouvez les conserver dans votre fichier candidat.dart
}
// -----------------------------------------------------------------------------------


class CandidatListPage extends StatefulWidget {
  CandidatListPage({super.key});

  @override
  State<CandidatListPage> createState() => _CandidatListPageState();
}

class _CandidatListPageState extends State<CandidatListPage> {
  // Liste de données d'exemple (Remplacez ceci par votre appel API)
  final List<Candidat> candidats = [
    Candidat(
      id: 1,
      nom: 'Mensah',
      firstname: 'Akosua',
      categorie: 'Lomé',
      descriptionShort: 'Étudiante en commerce international, passionnée de mode et de développement communautaire...',
      photo: 'assets/akosua_mensah.png', // Remplacez par le chemin réel de l'image
      votes: 1247,
      age: 22,
    ),
    Candidat(
      id: 2,
      nom: 'Koffi',
      firstname: 'Afi',
      categorie: 'Kara',
      descriptionShort: 'Artiste et danseuse traditionnelle, défenseure de la culture togolaise...',
      photo: 'assets/afi_koffi.png',
      votes: 892,
      age: 21,
    ),
    Candidat(
      id: 3,
      nom: 'Ablavi',
      firstname: 'Efua',
      categorie: 'Sokodé',
      descriptionShort: 'Entrepreneure sociale et militante pour l\'éducation des jeunes filles. Fondatrice d\'une association...',
      photo: 'assets/efua_ablavi.png',
      votes: 1156,
      age: 23,
    ),
    Candidat(
      id: 4,
      nom: 'Tetteh',
      firstname: 'Adjoa',
      categorie: 'Atakpamé',
      descriptionShort: 'Étudiante en médecine et bénévole dans les centres de santé ruraux. Passionnée par la santé maternelle...',
      photo: 'assets/adjoa_tetteh.png',
      votes: 743,
      age: 20,
    ),
    Candidat(
      id: 5,
      nom: 'Dzigbodi',
      firstname: 'Ama',
      categorie: 'Tsévié',
      descriptionShort: 'Ingénieure en informatique et développeuse d\'applications mobiles. Travaille sur des solutions...',
      photo: 'assets/ama_dzigbodi.png',
      votes: 634,
      age: 24,
    ),
    Candidat(
      id: 6,
      nom: 'Kpegba',
      firstname: 'Abla',
      categorie: 'Aného',
      descriptionShort: 'Journaliste et blogueuse, spécialisée dans les questions de développement durable. Couvre les enjeux...',
      photo: 'assets/abla_kpegba.png',
      votes: 987,
      age: 22,
    ),
    Candidat(
      id: 7,
      nom: 'Agbeko',
      firstname: 'Yawa',
      categorie: 'Dapaong',
      descriptionShort: 'Athlète de haut niveau en athlétisme, représentante du Togo dans les compétitions internationales...',
      photo: 'assets/yawa_agbeko.png',
      votes: 1089,
      age: 21,
    ),
    Candidat(
      id: 8,
      nom: 'Amegavi',
      firstname: 'Dela',
      categorie: 'Bassar',
      descriptionShort: 'Agricultrice moderne et promotrice de l\'agriculture durable. Développe des techniques agricoles innovantes...',
      photo: 'assets/dela_amegavi.png',
      votes: 567,
      age: 23,
    ),
    // ... Ajoutez d'autres candidats si nécessaire
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Concours Miss Togo 2024'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Titre/Description de la page
            const Text(
              'Votez pour votre candidate préférée • 1 vote = 100 FCFA',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            // Grille des candidats
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Important pour le SingleChildScrollView
              itemCount: candidats.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 colonnes comme dans l'image
                childAspectRatio: 0.6, // Ajustez pour que la carte tienne bien
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemBuilder: (context, index) {
                return CandidatCard(
                  candidat: candidats[index],
                  onVote: (id) {
                    // Fonctionnalité de vote à implémenter
                    print('Vote pour Candidat ID: $id');
                  },
                );
              },
            ),
          ],
        ),
      ),
      // Pied de page pour les informations de paiement
      bottomNavigationBar: Container(
        color: Colors.grey[900],
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '© 2024 Plateforme de Vote. Tous droits réservés.',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 8),
            const Text(
              'Paiement sécurisé via',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPaymentLogo('TMoney', Colors.green),
                const SizedBox(width: 15),
                _buildPaymentLogo('Flooz', Colors.deepOrange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentLogo(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

// --- Widget de la Carte de Candidat ---
class CandidatCard extends StatelessWidget {
  final Candidat candidat;
  final Function(int id) onVote;

  const CandidatCard({
    required this.candidat,
    required this.onVote,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, // Assure que les enfants (image) sont coupés
      child: InkWell(
        onTap: () {
          // Naviguer vers la page de détail du candidat
          Navigator.pushNamed(
            context,
            '/candidat/${candidat.id}',
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zone de l'image
            Stack(
              children: [
                // Image du candidat - Utilisez NetworkImage si l'image est en ligne
                // Pour l'exemple, j'utilise un Container. REMPLACEZ CECI par Image.asset(candidat.photo)
                // Assurez-vous d'avoir configuré vos assets dans pubspec.yaml
                Container(
                  height: 180, // Hauteur fixe pour l'image
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Couleur de placeholder
                    // Si vous utilisez Image.asset:
                    // image: DecorationImage(image: AssetImage(candidat.photo), fit: BoxFit.cover),
                  ),
                  child: Center(
                    child: Text('Image ${candidat.firstname}', style: TextStyle(color: Colors.grey)),
                  ),
                ),
                // Bulle des votes
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${candidat.votes} votes',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Détails du candidat
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom Complet
                  Text(
                    '${candidat.firstname} ${candidat.nom}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Ville et Âge
                  Text(
                    '${candidat.categorie} • ${candidat.age} ans',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Courte description
                  Text(
                    candidat.descriptionShort,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Bouton de vote (Dégradé comme dans la capture)
            // Utilisez Spacer() ou Align/Padding pour pousser le bouton vers le bas si la description est plus courte
            const Spacer(), 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE91E63), Color(0xFF9C27B0)], // Couleurs de dégradé
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: TextButton(
                  onPressed: () => onVote(candidat.id), // Fonctionnalité à implémenter
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: Text(
                    'Voter pour ${candidat.firstname}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}