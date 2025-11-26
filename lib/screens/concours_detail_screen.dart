import 'package:dzumevimobile/core/provider/concours.dart';
import 'package:dzumevimobile/screens/vote_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../models/concours.dart';
import '../models/candidat.dart';
import '../widgets/candidat_card.dart';

class ConcoursDetailScreen extends StatefulWidget {
  final Concours concours;
  const ConcoursDetailScreen({Key? key, required this.concours}) : super(key: key);

  @override
  State<ConcoursDetailScreen> createState() => _ConcoursDetailScreenState();
}

class _ConcoursDetailScreenState extends State<ConcoursDetailScreen> {
  List<Candidat> _candidats = [];
  bool _isLoading = true;
  String _error = '';
  int _totalVotes = 0;

  @override
  void initState() {
    super.initState();
    _loadCandidats();
  }

  Future<void> _loadCandidats() async {
    final provider = context.read<ConcoursProvider>();
    
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      // Simuler le chargement des candidats - À adapter avec votre API
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Données mockées - À remplacer par votre appel API
      _candidats = [
        Candidat(
          id: 1,
          firstname: "Jean",
          lastname: "Dupont",
          description: "Artiste talentueux passionné par la musique",
          categorie: "Musique",
          matricule: "MAT001",
          votes: 150,
          photo: "candidat1.jpg",
        ),
        Candidat(
          id: 2,
          firstname: "Marie",
          lastname: "Martin",
          description: "Danseuse étoile avec 10 ans d'expérience",
          categorie: "Danse",
          matricule: "MAT002",
          votes: 200,
          photo: "candidat2.jpg",
        ),
        Candidat(
          id: 3,
          firstname: "Pierre",
          lastname: "Durand",
          description: "Chanteur lyrique de renommée internationale",
          categorie: "Chant",
          matricule: "MAT003",
          votes: 180,
          photo: "candidat3.jpg",
        ),
        Candidat(
          id: 4,
          firstname: "Sophie",
          lastname: "Leroy",
          description: "Peintre contemporaine innovante",
          categorie: "Arts visuels",
          matricule: "MAT004",
          votes: 120,
          photo: "candidat4.jpg",
        ),
      ];

      _totalVotes = _candidats.fold(0, (sum, c) => sum + c.votes);
      
    } catch (e) {
      setState(() {
        _error = 'Erreur lors du chargement des candidats: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onCandidatTap(Candidat candidat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaiementScreen(
          candidat: candidat,
          concours: widget.concours,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.background,
      appBar: AppBar(
        title: Text(
          widget.concours.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppConstants.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCandidats,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error.isNotEmpty) {
      return _buildErrorState();
    }

    if (_candidats.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        // En-tête informatif
        _buildHeader(),
        
        // Liste des candidats
        Expanded(
          child: _buildCandidatsGrid(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.primary.withOpacity(0.1),
            AppConstants.secondary.withOpacity(0.05),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: AppConstants.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Titre
          Text(
            "Votez avec votre Mobile Money",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppConstants.primary,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 12),
          
          // Prix par vote
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppConstants.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "100 FCFA = 1 VOTE",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Statistiques
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                "Candidats",
                _candidats.length.toString(),
                Icons.people,
              ),
              _buildStatItem(
                "Total Votes",
                _totalVotes.toString(),
                Icons.how_to_vote,
              ),
              _buildStatItem(
                "Recettes",
                "${_totalVotes * 100} FCFA",
                Icons.attach_money,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppConstants.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildCandidatsGrid() {
    return RefreshIndicator(
      onRefresh: _loadCandidats,
      backgroundColor: AppConstants.background,
      color: AppConstants.primary,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _candidats.length,
        itemBuilder: (context, index) {
          final candidat = _candidats[index];
          return CandidatCard(
            candidat: candidat,
            onTap: () => _onCandidatTap(candidat),
            showProgress: true,
            totalVotesConcours: _totalVotes > 0 ? _totalVotes : 1,
          );
        },
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppConstants.error,
            ),
            const SizedBox(height: 16),
            const Text(
              "Erreur de chargement",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadCandidats,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Réessayer"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: AppConstants.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              "Aucun candidat inscrit",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Aucun candidat n'est encore inscrit à ce concours.\nRevenez plus tard.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadCandidats,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Actualiser"),
            ),
          ],
        ),
      ),
    );
  }
}