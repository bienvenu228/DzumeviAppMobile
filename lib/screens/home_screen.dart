import 'package:dzumevimobile/core/services/concours_api.dart';
import 'package:flutter/material.dart';
import '../models/concours.dart';
import 'concours_detail_screen.dart';

class ConcoursListScreen extends StatefulWidget {
  const ConcoursListScreen({Key? key}) : super(key: key);

  @override
  State<ConcoursListScreen> createState() => _ConcoursListScreenState();
}

class _ConcoursListScreenState extends State<ConcoursListScreen> {
  List<Concours> _concours = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadConcours();
  }

  Future<void> _loadConcours() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final concours = await ApiService.getConcoursActifs();
      
      setState(() {
        _concours = concours;
      });
      
    } catch (e) {
      setState(() {
        _error = 'Erreur lors du chargement des concours: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onConcoursTap(Concours concours) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConcoursDetailScreen(concours: concours),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Concours Actifs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadConcours,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return _buildErrorState();
    }

    if (_concours.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadConcours,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _concours.length,
        itemBuilder: (context, index) {
          final concours = _concours[index];
          return _buildConcoursCard(concours);
        },
      ),
    );
  }

  Widget _buildConcoursCard(Concours concours) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: concours.imageUrl != null 
            ? CircleAvatar(
                backgroundImage: NetworkImage(concours.imageUrl!),
                radius: 25,
              )
            : const CircleAvatar(
                child: Icon(Icons.emoji_events),
              ),
        title: Text(
          concours.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(concours.description),
            const SizedBox(height: 4),
            Text(
              '${concours.nombreCandidats} candidats • ${concours.nombreVotes} votes',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _onConcoursTap(concours),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64),
          const SizedBox(height: 16),
          Text(_error),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadConcours,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events_outlined, size: 64),
          SizedBox(height: 16),
          Text('Aucun concours actif'),
        ],
      ),
    );
  }

  
}
