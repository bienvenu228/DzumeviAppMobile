import 'package:flutter/material.dart';

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
// -----------------------------------------------------------------------------------


// --- WIDGET PRINCIPAL : CANDIDAT LIST PAGE ---
class CandidatListPage extends StatefulWidget {
  CandidatListPage({super.key});

  @override
  State<CandidatListPage> createState() => _CandidatListPageState();
}

class _CandidatListPageState extends State<CandidatListPage> {
  // Liste de données d'exemple (Remplacez ceci par votre appel API)
  late List<Candidat> candidats;

  @override
  void initState() {
    super.initState();
    // Initialisation et tri des candidats par votes
    candidats = [
      Candidat(id: 1, nom: 'Mensah', firstname: 'Akosua', categorie: 'Lomé', descriptionShort: 'Étudiante en commerce international, passionnée de mode et de développement communautaire...', photo: 'assets/akosua_mensah.png', votes: 1247, age: 22),
      Candidat(id: 2, nom: 'Koffi', firstname: 'Afi', categorie: 'Kara', descriptionShort: 'Artiste et danseuse traditionnelle, défenseure de la culture togolaise...', photo: 'assets/afi_koffi.png', votes: 892, age: 21),
      Candidat(id: 3, nom: 'Ablavi', firstname: 'Efua', categorie: 'Sokodé', descriptionShort: 'Entrepreneure sociale et militante pour l\'éducation des jeunes filles. Fondatrice d\'une association...', photo: 'assets/efua_ablavi.png', votes: 1156, age: 23),
      Candidat(id: 4, nom: 'Tetteh', firstname: 'Adjoa', categorie: 'Atakpamé', descriptionShort: 'Étudiante en médecine et bénévole dans les centres de santé ruraux. Passionnée par la santé maternelle...', photo: 'assets/adjoa_tetteh.png', votes: 743, age: 20),
      Candidat(id: 5, nom: 'Dzigbodi', firstname: 'Ama', categorie: 'Tsévié', descriptionShort: 'Ingénieure en informatique et développeuse d\'applications mobiles. Travaille sur des solutions...', photo: 'assets/ama_dzigbodi.png', votes: 634, age: 24),
      Candidat(id: 6, nom: 'Kpegba', firstname: 'Abla', categorie: 'Aného', descriptionShort: 'Journaliste et blogueuse, spécialisée dans les questions de développement durable. Couvre les enjeux...', photo: 'assets/abla_kpegba.png', votes: 987, age: 22),
      Candidat(id: 7, nom: 'Agbeko', firstname: 'Yawa', categorie: 'Dapaong', descriptionShort: 'Athlète de haut niveau en athlétisme, représentante du Togo dans les compétitions internationales...', photo: 'assets/yawa_agbeko.png', votes: 1089, age: 21),
      Candidat(id: 8, nom: 'Amegavi', firstname: 'Dela', categorie: 'Bassar', descriptionShort: 'Agricultrice moderne et promotrice de l\'agriculture durable. Développe des techniques agricoles innovantes...', photo: 'assets/dela_amegavi.png', votes: 567, age: 23),
    ]..sort((a, b) => b.votes.compareTo(a.votes)); // Tri décroissant pour le classement
  }

  void _handleVote(int id) {
    // Fonctionnalité de vote à implémenter (Appel API, rafraîchissement de l'état, etc.)
    print('Vote pour Candidat ID: $id');
    // Mettez à jour les votes et triez la liste si l'API est appelée ici
  }

  // Couleurs personnalisées pour le dégradé de l'en-tête
  final List<Color> _headerGradient = const [
    Color(0xFF8E24AA), // Violet foncé
    Color(0xFFE53935), // Rouge clair
  ];

  @override
  Widget build(BuildContext context) {
    // Calcul du total des votes pour l'affichage
    final int totalVotes = candidats.fold(0, (sum, item) => sum + item.votes);
    // Les trois meilleurs candidats
    final List<Candidat> topThree = candidats.take(3).toList();
    // Le reste des candidats pour la grille
    final List<Candidat> remainingCandidats = candidats.toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. En-tête (P1.png)
            _HeaderSection(gradientColors: _headerGradient),
            
            // 2. Classement des 3 meilleurs (P2.png)
            _RankingSection(
              topThree: topThree,
              totalVotes: totalVotes,
              allCandidats: candidats,
            ),
            
            // 3. Grille de tous les candidats (P3.png & P4.png)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Toutes les candidates',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // Important pour le SingleChildScrollView
                    itemCount: remainingCandidats.length,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300, // Adaptez le nombre de colonnes
                      childAspectRatio: 0.6, 
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemBuilder: (context, index) {
                      return CandidatCard(
                        candidat: remainingCandidats[index],
                        onVote: _handleVote,
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // 4. Pied de page (P4.png)
            const _FooterSection(),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------------
// --- WIDGETS DÉDIÉS ---
// -----------------------------------------------------------------------------------

// --- 1. EN-TÊTE (P1.png) ---
class _HeaderSection extends StatelessWidget {
  final List<Color> gradientColors;

  const _HeaderSection({required this.gradientColors});

  @override
  Widget build(BuildContext context) {
    return Container(
      // === MODIFICATION CLÉ ===
      // Garantit que le Container prend toute la largeur de son parent (l'écran, dans ce cas)
      width: double.infinity, 
      // === RÉINTÉGRATION DU PADDING ===
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, bottom: 40),
      // ==================================
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Icône Couronne
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.yellow[600],
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.star,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 15),
          
          // Titre
          const Text(
            'Concours Miss Togo',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const Text(
            '2024',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: Color(0xFFFDD835), // Jaune vif
            ),
          ),
          const SizedBox(height: 10),
          
          // Slogan
          const Text(
            'Votez pour votre candidate préférée',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          
          // Bloc Prix du vote
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.monetization_on, color: Colors.yellow, size: 18),
                SizedBox(width: 8),
                Text(
                  '1 vote = 100 FCFA',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          
          // Séparateur étoile
          const Icon(Icons.star, color: Colors.white38, size: 20),
        ],
      ),
    );
  }
}

// --- 2. CLASSEMENT DES TROIS MEILLEURS (P2.png) ---
class _RankingSection extends StatelessWidget {
  final List<Candidat> topThree;
  final int totalVotes;
  final List<Candidat> allCandidats;

  const _RankingSection({
    required this.topThree,
    required this.totalVotes,
    required this.allCandidats,
  });
  
  // Définit la couleur de l'icône de classement
  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFDD835); // Jaune or
      case 2:
        return const Color(0xFFB0BEC5); // Gris argent
      case 3:
        return const Color(0xFFA1887F); // Marron bronze
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Titre de la section de classement
          _buildRankingHeader(totalVotes),
          const SizedBox(height: 20),
          
          // 3 Meilleurs Candidats en haut (Vue "Hero")
          _buildTopThreeHero(topThree),
          const SizedBox(height: 20),
          
          // Liste détaillée du classement
          ...allCandidats.asMap().entries.map((entry) {
            int rank = entry.key + 1;
            Candidat candidat = entry.value;
            return _buildRankingItem(candidat, rank, totalVotes);
          }).toList(),
        ],
      ),
    );
  }
  
  // Widget pour l'en-tête de la carte de classement
  Widget _buildRankingHeader(int totalVotes) {
    return Row(
      children: [
        Icon(Icons.bar_chart, color: const Color(0xFF9C27B0)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Classement des Votes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                '$totalVotes votes au total',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        const Icon(Icons.keyboard_arrow_up, color: Colors.grey),
      ],
    );
  }

  // Widget pour l'affichage "Hero" des 3 premiers
  Widget _buildTopThreeHero(List<Candidat> topThree) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // 2e Place
        if (topThree.length > 1) _buildHeroCandidat(topThree[1], isChampion: false),
        // 1ère Place (Champion)
        if (topThree.isNotEmpty) _buildHeroCandidat(topThree[0], isChampion: true),
        // 3e Place
        if (topThree.length > 2) _buildHeroCandidat(topThree[2], isChampion: false),
      ],
    );
  }

  // Widget pour un candidat individuel dans la vue "Hero"
  Widget _buildHeroCandidat(Candidat candidat, {required bool isChampion}) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: isChampion ? 90 : 70,
              height: isChampion ? 90 : 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isChampion ? const Color(0xFFFDD835) : Colors.transparent,
                  width: 3,
                ),
                color: Colors.grey[300], // Placeholder
              ),
              child: ClipOval(
                child: Center(child: Text(candidat.firstname.substring(0, 1), style: TextStyle(fontSize: 24))), // Placeholder
              ),
            ),
            if (isChampion)
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(Icons.emoji_events, color: Color(0xFFFDD835), size: 24),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${candidat.firstname} ${candidat.nom}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isChampion ? 14 : 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isChampion ? const Color(0xFFFDD835) : Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${candidat.votes} votes',
            style: TextStyle(
              color: isChampion ? Colors.black : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  // Widget pour un élément de la liste détaillée de classement
  Widget _buildRankingItem(Candidat candidat, int rank, int totalVotes) {
    final double percentage = totalVotes > 0 ? (candidat.votes / totalVotes) : 0.0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Rang
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: _getRankColor(rank),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '#$rank',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),

          // Image
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200], // Placeholder
            ),
            child: ClipOval(
                child: Center(child: Text(candidat.firstname.substring(0, 1))),
            ),
          ),
          const SizedBox(width: 12),

          // Nom et Catégorie
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${candidat.firstname} ${candidat.nom}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  candidat.categorie,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Votes et pourcentage
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${candidat.votes}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF9C27B0)),
              ),
              Text(
                '${(percentage * 100).toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- 3. CARTE DE CANDIDAT (P3.png) ---
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
    // Hauteur totale fixe pour s'assurer que toutes les cartes s'alignent, 
    // en utilisant FractionallySizedBox ou SizedBox dans une grille maxExtent
    return SizedBox(
      height: 400, 
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zone de l'image
            Stack(
              children: [
                // Image du candidat (Placeholder)
                Container(
                  height: 180, 
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200], 
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${candidat.firstname} ${candidat.nom}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    // Ville et Âge
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${candidat.categorie} • ${candidat.age} ans',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Courte description
                    Text(
                      candidat.descriptionShort,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const Spacer(), 

                    // Bouton de vote (Dégradé)
                    _buildVoteButton(context, candidat),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Widget pour le bouton de vote en dégradé
  Widget _buildVoteButton(BuildContext context, Candidat candidat) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [Color(0xFFE91E63), Color(0xFF9C27B0)], // Rose à Violet
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextButton(
        onPressed: () => onVote(candidat.id),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          // overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.1)),
        ),
        child: Text(
          'Voter pour ${candidat.firstname}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

// --- 4. PIED DE PAGE (P4.png) ---
class _FooterSection extends StatelessWidget {
  const _FooterSection();

  Widget _buildPaymentLogo(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF303A58), // Couleur de fond du pied de page
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '© 2024 Plateforme de Vote. Tous droits réservés.',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 10),
          const Text(
            'Paiement sécurisé via',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPaymentLogo('TMoney', Colors.green[600]!),
              const SizedBox(width: 15),
              _buildPaymentLogo('Flooz', Colors.deepOrange[600]!),
            ],
          ),
        ],
      ),
    );
  }
}