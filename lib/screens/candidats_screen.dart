import 'package:dzumevimobile/core/services/concours_api.dart';
import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/concours.dart';
import '../models/candidat.dart';
import '../widgets/candidat_card.dart';
import 'vote_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _loadCandidats();
  }

  Future<void> _loadCandidats() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final candidats = await ApiService.getCandidatsByConcours(widget.concours.id);
      
      setState(() {
        _candidats = candidats;
      });
      
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
    final totalVotesConcours = _candidats.fold(0, (sum, c) => sum + c.votes);
    
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
      body: _buildBody(totalVotesConcours),
    );
  }

  Widget _buildBody(int totalVotes) {
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
        _buildHeader(totalVotes),
        Expanded(
          child: _buildCandidatsGrid(totalVotes),
        ),
      ],
    );
  }

  Widget _buildHeader(int totalVotes) {
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
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppConstants.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${widget.concours.prixParVote.toInt()} FCFA = 1 VOTE",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
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
                totalVotes.toString(),
                Icons.how_to_vote,
              ),
              _buildStatItem(
                "Recettes",
                "${(totalVotes * widget.concours.prixParVote).toInt()} FCFA",
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

  Widget _buildCandidatsGrid(int totalVotes) {
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
            totalVotesConcours: totalVotes > 0 ? totalVotes : 1,
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