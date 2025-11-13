import 'package:dzumevimobile/screens/Admin/Statistiques.dart';
import 'package:dzumevimobile/screens/Admin/gestion_candidats.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'gestion_concours.dart';
import 'transactions.dart';
import 'resultats.dart';
import 'votant.dart';
import 'admin.edit.dart';
import 'login.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;
  String adminName = "Admin";

  final List<Map<String, dynamic>> _pages = [
    {'title': 'Candidats', 'widget': const GestionCandidatsScreen(), 'icon': Icons.people},
    {'title': 'Concours', 'widget': const GestionConcoursScreen(), 'icon': Icons.emoji_events},
    {'title': 'Résultats', 'widget': const ResultatsScreen(), 'icon': Icons.bar_chart},
    {'title': 'Transactions', 'widget': const TransactionsScreen(), 'icon': Icons.receipt_long},
    {'title': 'Statistiques', 'widget': const StatistiqueScreen(), 'icon': Icons.analytics},
    {'title': 'Votants', 'widget': const VotantScreen(), 'icon': Icons.how_to_vote},
    {'title': 'Profil', 'widget': const AdminEditScreen(), 'icon': Icons.account_circle},
  ];

  @override
  void initState() {
    super.initState();
    _loadAdmin();
  }

  Future<void> _loadAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      adminName = prefs.getString('admin_name') ?? 'Admin';
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tableau de bord - $_currentTitle"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages.map((p) => p['widget'] as Widget).toList(),
      ),
    );
  }

  String get _currentTitle => _pages[_selectedIndex]['title'];

  Drawer _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(adminName),
            accountEmail: const Text("Administrateur"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.admin_panel_settings, color: Colors.blue),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _pages.length,
              itemBuilder: (context, i) {
                final page = _pages[i];
                return ListTile(
                  leading: Icon(page['icon']),
                  title: Text(page['title']),
                  selected: i == _selectedIndex,
                  onTap: () {
                    setState(() => _selectedIndex = i);
                    Navigator.pop(context); // ferme le drawer
                  },
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Déconnexion", style: TextStyle(color: Colors.red)),
            onTap: _logout,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
