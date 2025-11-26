// lib/screens/candidats_screen.dart
import 'package:dzumevimobile/core/services/concours_api.dart';
import 'package:flutter/material.dart';
import 'package:dzumevimobile/models/concours.dart';
import 'package:dzumevimobile/models/candidat.dart';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

class CandidatsScreen extends StatefulWidget {
  final Concours concours;

  const CandidatsScreen({Key? key, required this.concours}) : super(key: key);

  @override
  State<CandidatsScreen> createState() => _CandidatsScreenState();
}

class _CandidatsScreenState extends State<CandidatsScreen> {
  late ConcoursApiService apiService;
  List<Candidat> candidats = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    apiService = ConcoursApiService(client: http.Client());
    _loadCandidats();
  }

  Future<void> _loadCandidats() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      final data = await apiService.getCandidatesByConcours(widget.concours.id);
      setState(() {
        candidats = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _returnWithCandidats() {
    Navigator.pop(context, candidats); // renvoie la liste à HomeScreen
  }

  void _voteForCandidat(Candidat candidat) async {
    // Logique de vote locale (incrémentation temporaire)
    setState(() {
      // candidat.votes += 1; // attention: tu devras gérer l'API pour vrai vote
    });

    // SnackBar pour confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Vote pour ${candidat.fullName} enregistré !"),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    // TODO: Ici, appeler ton API pour enregistrer le vote réellement
    // await apiService.voteForCandidate(candidat.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.background,
      appBar: AppBar(
        title: Text(widget.concours.name),
        backgroundColor: AppConstants.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _returnWithCandidats, // bouton retour personnalisé
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadCandidats,
        backgroundColor: AppConstants.background,
        color: AppConstants.primary,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error.isNotEmpty) {
      return _buildEmptyState("Erreur de chargement", error, _loadCandidats);
    }

    if (candidats.isEmpty) {
      return _buildEmptyState(
        "Aucun candidat",
        "Ce concours n'a aucun candidat pour le moment",
        _loadCandidats,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: candidats.length,
      itemBuilder: (context, index) {
        final candidat = candidats[index];
        return _buildCandidatCard(candidat);
      },
    );
  }

  Widget _buildCandidatCard(Candidat candidat) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: AppConstants.primary.withOpacity(0.2),
          backgroundImage:
              candidat.photo != null && candidat.photo!.isNotEmpty
                  ? NetworkImage(candidat.photo!)
                  : null,
          child: (candidat.photo == null || candidat.photo!.isEmpty)
              ? const Icon(Icons.person, size: 28, color: Colors.white)
              : null,
        ),
        title: Text(
          candidat.fullName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (candidat.categorie.isNotEmpty)
              Text(
                candidat.categorie,
                style: TextStyle(
                  fontSize: 14,
                  color: AppConstants.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              "${candidat.votes} vote${candidat.votes > 1 ? 's' : ''}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _voteForCandidat(candidat),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Voter",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String message, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 80,
              color: AppConstants.primary.withOpacity(0.7),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Réessayer",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
