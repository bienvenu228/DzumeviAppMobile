import 'package:flutter/material.dart';
import 'screens/candidatListPage.dart';
import 'screens/vote_overview_page.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dzumevi Vote',
      theme: ThemeData(
        primaryColor: const Color(0xFFE91E63),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink),
      ),
      routes: {
        '/': (context) => const MainNavigationScreen(),
        '/candidats': (context) => const CandidatListPage(),
        '/votes': (context) => const VoteOverviewPage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = const [
    CandidatListPage(),
    VoteOverviewPage(),
    LoginPage(),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people_alt), label: 'Candidats'),
          BottomNavigationBarItem(icon: Icon(Icons.how_to_vote), label: 'Votes'),
          BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Login'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
