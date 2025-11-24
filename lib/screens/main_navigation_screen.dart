// lib/screens/main_navigation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dzumevimobile/screens/candidatListPage.dart';
import 'package:dzumevimobile/screens/voteListPage.dart';
import 'package:dzumevimobile/screens/login_page.dart';
import 'package:dzumevimobile/providers/navigation_provider.dart';

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationState = ref.watch(navigationProvider);
    final navigationNotifier = ref.read(navigationProvider.notifier);

    // Écrans fixes - tous accessibles sans authentification
    final List<Widget> _widgetOptions = <Widget>[
      CandidatListPage(), // Accessible à tous
      VoteScreen(),       // Accessible à tous  
      LoginPage(),        // Uniquement pour les admins
    ];

    return Scaffold(
      body: IndexedStack(
        index: navigationState.selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: 'Candidats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_vote),
            label: 'Votes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Admin',
          ),
        ],
        currentIndex: navigationState.selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: navigationNotifier.changeTab,
        backgroundColor: Colors.white,
        elevation: 5,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}