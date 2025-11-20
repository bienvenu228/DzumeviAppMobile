import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/payment_service.dart'; // Assurez-vous que ce chemin est correct
import '../services/api_service.dart';    // Assurez-vous que ce chemin est correct


// ====================================================================
// --- MODÈLE CANDIDAT (CORRIGÉ) ---
// ====================================================================
class Candidat {
  final int id;
  final String? lastname; 
  final String firstname;
  final String maticule;
  final String categorie;
  final String? description;
  final String? photo;
  // ⭐️ CORRECTION : 'votes' n'est PLUS final pour pouvoir être mis à jour (même si le re-fetch est préféré)
  int votes; 
  final int age; 
  final int voteId;

  Candidat({
    required this.id,
    this.lastname,
    required this.firstname,
    required this.maticule,
    required this.categorie,
    this.description,
    this.photo,
    required this.votes,
    required this.age,
    required this.voteId,
  });

  factory Candidat.fromJson(Map<String, dynamic> json) {
    return Candidat(
      id: (json['id'] as num).toInt(),
      lastname: json['lastname'] as String?,
      firstname: json['firstname'] as String,
      maticule: json['maticule'] as String,
      categorie: json['categorie'] as String,
      description: json['description'] as String?,
      photo: json['photo'] as String?,
      // Utilisation de 'num' pour gérer int ou double dans le JSON
      votes: (json['votes'] as num? ?? 0).toInt(), 
      age: (json['age'] as num? ?? 20).toInt(),
      voteId: (json['vote_id'] as num).toInt(),
    );
  }
}

// ====================================================================
// --- SERVICE DE CANDIDAT MINIMAL (Gardé ici pour la simplicité) ---
// Note : Idéalement, ce code devrait être dans services/candidat_service.dart
// ====================================================================
class CandidatService {
  static Future<List<Candidat>> fetchAllCandidats() async {
    final url = Uri.parse('${ApiService.baseUrl}/candidats'); 
    final response = await http.get(url, headers: ApiService.getHeaders());

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      
      if (jsonResponse['status'] == 'success' && jsonResponse['data'] is List) {
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) => Candidat.fromJson(json)).toList();
      }
      throw Exception(jsonResponse['message'] ?? 'Format de réponse invalide.');
    } else {
      throw Exception('Échec du chargement des candidats: Statut ${response.statusCode}');
    }
  }
}


// ====================================================================
// --- WIDGET PRINCIPAL : CANDIDAT LIST PAGE ---
// ====================================================================
class CandidatListPage extends StatefulWidget {
  const CandidatListPage({super.key});

  @override
  State<CandidatListPage> createState() => _CandidatListPageState();
}

class _CandidatListPageState extends State<CandidatListPage> {
  
  List<Candidat> candidats = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCandidats(); 
  }

  // Fonction de récupération des données depuis l'API
  // DANS _CandidatListPageState
Future<void> _fetchCandidats() async {
  // ...
  try {
    // Si vous voulez tous les candidats (par défaut):
    final fetchedCandidats = await CandidatService.fetchAllCandidats(); 
    
    // OU si vous utilisez un ID de vote spécifique (ex: 1):
    // final fetchedCandidats = await CandidatService.getCandidatsByVote(1); 
    
    // ...
  } catch (e) {
    // ...
  }
}

  // --- Gestion du vote avec paiement ---
  Future<void> _handleVote(int candidatId) async {
    // Utilisation de firstWhere avec orElse pour éviter une exception si le candidat n'est pas trouvé
    final candidat = candidats.firstWhere(
      (c) => c.id == candidatId,
      orElse: () => throw Exception('Candidat non trouvé.'),
    );

    // 1️⃣ Choix du type de paiement
    String? paymentType = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choisir le moyen de paiement"),
        content: const Text("1 vote = 100 FCFA"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, "mtn_open"), 
            child: const Text("TMoney"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, "moov"), 
            child: const Text("Flooz"),
          ),
        ],
      ),
    );

    if (paymentType == null) return; 

    // 2️⃣ Demande des informations utilisateur
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Informations pour le paiement ($paymentType)"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nom Complet")),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email"), keyboardType: TextInputType.emailAddress),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Numéro de téléphone"), keyboardType: TextInputType.phone),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Annuler")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Payer et Voter")),
        ],
      ),
    );

    if (confirmed != true || nameController.text.isEmpty || phoneController.text.isEmpty || emailController.text.isEmpty) return;
    
    // 3️⃣ Paiement via PaymentService
    try {
      final transactionResult = await PaymentService.initiatePayment(
        name: nameController.text,
        email: emailController.text,
        phoneNumber: phoneController.text,
        country: "TG", 
        amount: 100.0,
        currency: "XOF",
        description: "Vote pour ${candidat.firstname} (ID: ${candidat.id})",
        mode: paymentType,
      );

      if (transactionResult['success'] == true) {
        // Affiche un message de succès du DÉMARRAGE de la transaction FedaPay
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Paiement initié. Suivez les instructions sur votre téléphone. Rafraîchissement des votes en cours...")),
        );

        // ⭐️ LOGIQUE SÉCURISÉE : Re-fetch des données depuis le serveur après un délai
        // (Assume que le webhook de confirmation FedaPay a eu le temps d'incrémenter le vote côté Laravel)
        await Future.delayed(const Duration(seconds: 4)); 
        await _fetchCandidats(); 
        
        // Afficher la confirmation après la mise à jour
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Vote pour ${candidat.firstname} confirmé et classement mis à jour !")),
        );
        
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Paiement échoué: ${transactionResult['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de transaction: $e")),
      );
    }
  }


  // ... (Méthode build et les classes de widgets dédiés non modifiées) ...

  final List<Color> _headerGradient = const [
    Color(0xFF8E24AA), // Violet foncé
    Color(0xFFE53935), // Rouge clair
  ];

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    if (_error != null || candidats.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Candidats')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error ?? 'Aucun candidat trouvé.', style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _fetchCandidats, child: const Text('Réessayer le chargement')),
            ],
          ),
        ),
      );
    }

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
                    physics: const NeverScrollableScrollPhysics(), 
                    itemCount: remainingCandidats.length,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300, 
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
      width: double.infinity, 
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, bottom: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
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
          const Text(
            'Votez pour votre candidate préférée',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
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
          _buildRankingHeader(totalVotes),
          const SizedBox(height: 20),
          _buildTopThreeHero(topThree),
          const SizedBox(height: 20),
          ...allCandidats.asMap().entries.map((entry) {
            int rank = entry.key + 1;
            Candidat candidat = entry.value;
            return _buildRankingItem(candidat, rank, totalVotes);
          }).toList(),
        ],
      ),
    );
  }
  
  Widget _buildRankingHeader(int totalVotes) {
    return Row(
      children: [
        const Icon(Icons.bar_chart, color: Color(0xFF9C27B0)),
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

  Widget _buildTopThreeHero(List<Candidat> topThree) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (topThree.length > 1) _buildHeroCandidat(topThree[1], isChampion: false),
        if (topThree.isNotEmpty) _buildHeroCandidat(topThree[0], isChampion: true),
        if (topThree.length > 2) _buildHeroCandidat(topThree[2], isChampion: false),
      ],
    );
  }

  Widget _buildHeroCandidat(Candidat candidat, {required bool isChampion}) {
    // Utilise le service pour charger l'image via le réseau
    final imageWidget = candidat.photo != null && candidat.photo!.isNotEmpty
        ? Image.network(
              '${ApiService.baseUrl}/${candidat.photo}', // ⚠️ Adaptez l'URL si nécessaire
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Center(child: Text(candidat.firstname.substring(0, 1), style: const TextStyle(fontSize: 24))),
            )
        : Center(child: Text(candidat.firstname.substring(0, 1), style: const TextStyle(fontSize: 24))); // Placeholder

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
                color: Colors.grey[300],
              ),
              child: ClipOval(child: imageWidget),
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
          candidat.firstname, // Affichage du prénom uniquement pour la vue Hero
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

  Widget _buildRankingItem(Candidat candidat, int rank, int totalVotes) {
    final double percentage = totalVotes > 0 ? (candidat.votes / totalVotes) : 0.0;
    
    // Utilise le service pour charger l'image via le réseau
    final imageWidget = candidat.photo != null && candidat.photo!.isNotEmpty
        ? Image.network(
              '${ApiService.baseUrl}/${candidat.photo}', // ⚠️ Adaptez l'URL si nécessaire
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Center(child: Text(candidat.firstname.substring(0, 1))),
            )
        : Center(child: Text(candidat.firstname.substring(0, 1))); // Placeholder

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
            child: ClipOval(child: imageWidget),
          ),
          const SizedBox(width: 12),

          // Nom et Catégorie
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${candidat.firstname} ${candidat.lastname ?? ''}',
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
    // Utilise le service pour charger l'image via le réseau
    final imageWidget = candidat.photo != null && candidat.photo!.isNotEmpty
        ? Image.network(
              '${ApiService.baseUrl}/${candidat.photo}', // ⚠️ Adaptez l'URL si nécessaire
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ));
              },
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Text(
                  'Image manquante',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
        : const Center(
            child: Text(
              'Image manquante',
              style: TextStyle(color: Colors.grey),
            ),
          );

    return SizedBox(
      height: 400, // Hauteur fixe pour alignement dans la grille
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
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Placeholder pour image
                  ),
                  child: imageWidget,
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
                      '${candidat.firstname} ${candidat.lastname ?? ''}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Ville et âge
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
                      candidat.description ?? 'Pas de description.',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    // --- Bouton de vote ---
                    Container(
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
                    ),
                  ],
                ),
              ),
            ),
          ],
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