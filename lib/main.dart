import 'package:dzumevimobile/screens/Admin/admin.edit.dart';
import 'package:dzumevimobile/screens/Admin/dashboard.dart';
import 'package:dzumevimobile/screens/Admin/vote.liste.dart';
import 'package:dzumevimobile/screens/candidat.detail.dart';
import 'package:dzumevimobile/screens/candidatListPage.dart';
import 'package:dzumevimobile/screens/vote.detail.dart';
import 'package:dzumevimobile/screens/voteListPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Définition d'un thème plus professionnel et coloré
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dzumevi Vote',
      theme: ThemeData(
        // Couleur principale inspirée du dégradé rose/violet de la carte
        primaryColor: const Color(0xFFE91E63), 
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: createMaterialColor(const Color(0xFFE91E63)),
        ).copyWith(
          secondary: const Color(0xFF9C27B0), // Couleur secondaire (violet foncé)
          background: Colors.grey[50], // Fond légèrement gris
        ),
        // Style de l'AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFFE91E63),
          elevation: 1,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Style des boutons ElevatedButton
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFFE91E63), // Utiliser la couleur primaire
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        useMaterial3: true,
      ),
      
      // Configuration des routes (inchangée, mais importante)
      onGenerateRoute: (settings) {
        // Route avec argument: /candidat/123
        if (settings.name?.startsWith('/candidat/') ?? false) {
          final candidatId = settings.name!.split('/').last;
          return MaterialPageRoute(
            builder: (context) => CandidatDetailPage(candidatId: candidatId),
            settings: settings,
          );
        }

        // Route avec argument: /vote/456
        if (settings.name?.startsWith('/vote/') ?? false) {
          final voteId = settings.name!.split('/').last;
          return MaterialPageRoute(
            builder: (context) => VoteDetailPage(voteId: voteId),
            settings: settings,
          );
        }

        // Route avec plusieurs arguments: /admin/edit/789
        if (settings.name?.startsWith('/admin/edit/') ?? false) {
          final itemId = settings.name!.split('/').last;
          return MaterialPageRoute(
            builder: (context) => AdminEditPage(itemId: itemId),
            settings: settings,
          );
        }

        // Route par défaut (gérée par le BottomNavigationBar)
        return null; 
      },
      
      // Routes simples
      routes: {
        '/': (context) => const MainNavigationScreen(), // Nouveau point d'entrée
        '/candidats': (context) => CandidatListPage(),
        '/votes': (context) => VoteScreen(),
        '/admin': (context) => AdminDashboard(),
      },
      initialRoute: '/',
    );
  }
}

// Fonction utilitaire pour créer une MaterialColor à partir d'une seule couleur (pour primarySwatch)
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}


// --- Écran de navigation principal (remplace HomePage) ---
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // Liste des écrans accessibles par la barre de navigation
  final List<Widget> _widgetOptions = <Widget>[
    CandidatListPage(), // Écran 0: Candidats
    VoteScreen(),       // Écran 1: Votes
    AdminDashboard(),   // Écran 2: Dashboard Admin
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // L'AppBar sera maintenant affichée dans chaque écran (CandidatListPage, VoteScreen, etc.)
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
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
            icon: Icon(Icons.settings),
            label: 'Admin',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor, // Couleur principale
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 5,
        type: BottomNavigationBarType.fixed, // Maintient la position des icônes
      ),
    );
  }
}