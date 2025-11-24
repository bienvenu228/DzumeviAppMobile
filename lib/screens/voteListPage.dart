// lib/pages/vote_screen.dart
import 'package:dzumevimobile/models/vote_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/vote_provider.dart';

class VoteScreen extends ConsumerStatefulWidget {
  const VoteScreen({super.key});

  @override
  ConsumerState<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends ConsumerState<VoteScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les résultats au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(voteNotifierProvider.notifier).loadVoteResults();
    });
  }

  Future<void> _refreshData() async {
    await ref.read(voteNotifierProvider.notifier).refreshVoteResults();
  }

  @override
  Widget build(BuildContext context) {
    final voteState = ref.watch(voteNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      appBar: AppBar(
        title: const Text(
          'Concours Miss Togo 2024',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: _buildBody(voteState),
    );
  }

  Widget _buildBody(VoteState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Erreur de chargement',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.error!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshData,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // 🔥 Encadré dégradé "Classement des votes"
            _buildHeader(state.totalVotes),

            const SizedBox(height: 20),

            // 🔱 TOP 3
            if (state.topThree.isNotEmpty) _buildTopThree(state.topThree),

            const SizedBox(height: 20),

            // 🔽 Liste complète
            if (state.voteResults.isNotEmpty) 
              _buildRankingList(state.voteResults),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int totalVotes) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff9b2cf0), Color(0xffe639c7)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bar_chart, color: Colors.white),
              SizedBox(width: 8),
              Text(
                "Classement des Votes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            "${totalVotes.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ')} votes au total",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTopThree(List<VoteResult> topThree) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (topThree.length > 1) 
            _buildTopCandidate(
              candidate: topThree[1],
              isWinner: false,
            ),
          if (topThree.isNotEmpty)
            _buildTopCandidate(
              candidate: topThree[0],
              isWinner: true,
            ),
          if (topThree.length > 2)
            _buildTopCandidate(
              candidate: topThree[2],
              isWinner: false,
            ),
        ],
      ),
    );
  }

  Widget _buildTopCandidate({
    required VoteResult candidate,
    bool isWinner = false,
  }) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: isWinner ? 45 : 40,
              backgroundImage: NetworkImage(candidate.image),
              onBackgroundImageError: (exception, stackTrace) {
                // Gérer l'erreur d'image
              },
            ),
            if (isWinner)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emoji_events, size: 18, color: Colors.white),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(
            candidate.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "${candidate.votes} votes",
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildRankingList(List<VoteResult> results) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final candidate = results[index];
        return _buildRankTile(candidate);
      },
    );
  }

  Widget _buildRankTile(VoteResult candidate) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Badge du rang
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: _getRankColor(candidate.rank),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                candidate.rank.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Photo
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(candidate.image),
            onBackgroundImageError: (exception, stackTrace) {
              // Gérer l'erreur d'image
            },
          ),
          const SizedBox(width: 12),

          // Informations
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  candidate.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  candidate.city,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: candidate.percent / 100,
                  minHeight: 6,
                  backgroundColor: Colors.pink.shade100,
                  valueColor: AlwaysStoppedAnimation(_getProgressColor(candidate.percent)),
                ),
                const SizedBox(height: 4),
                Text(
                  "${candidate.percent.toStringAsFixed(1)}%",
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Votes
          Column(
            children: [
              const Icon(Icons.favorite, color: Colors.pink, size: 20),
              const SizedBox(height: 2),
              Text(
                candidate.votes.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Or
      case 2:
        return const Color(0xFFC0C0C0); // Argent
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.grey;
    }
  }

  Color _getProgressColor(double percent) {
    if (percent >= 15) return Colors.pinkAccent;
    if (percent >= 10) return Colors.purpleAccent;
    if (percent >= 5) return Colors.blueAccent;
    return Colors.grey;
  }
}