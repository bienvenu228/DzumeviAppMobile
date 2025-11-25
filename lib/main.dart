// main.dart
import 'package:dzumevimobile/screens/main_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dzumevimobile/screens/Admin/admin.edit.dart';
import 'package:dzumevimobile/screens/Admin/dashboard.dart';
import 'package:dzumevimobile/screens/candidat.detail.dart';
import 'package:dzumevimobile/screens/candidatListPage.dart';
import 'package:dzumevimobile/screens/login_page.dart';
import 'package:dzumevimobile/screens/vote.detail.dart';
import 'package:dzumevimobile/screens/voteListPage.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dzumevi Vote',
      theme: ThemeData(
        primaryColor: const Color(0xFFE91E63),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: createMaterialColor(const Color(0xFFE91E63)),
        ).copyWith(
          secondary: const Color(0xFF9C27B0),
          background: Colors.grey[50],
        ),
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
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFFE91E63),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        useMaterial3: true,
      ),
      
      onGenerateRoute: (settings) {
        if (settings.name?.startsWith('/candidat/') ?? false) {
          final candidatId = settings.name!.split('/').last;
          return MaterialPageRoute(
            builder: (context) => CandidatDetailPage(candidatId: candidatId),
            settings: settings,
          );
        }

        if (settings.name?.startsWith('/vote/') ?? false) {
          final voteId = settings.name!.split('/').last;
          return MaterialPageRoute(
            builder: (context) => VoteDetailPage(voteId: voteId),
            settings: settings,
          );
        }

        if (settings.name?.startsWith('/admin/edit/') ?? false) {
          final itemId = settings.name!.split('/').last;
          return MaterialPageRoute(
            builder: (context) => AdminEditPage(itemId: itemId),
            settings: settings,
          );
        }

        return null;
      },
      
      routes: {
        '/': (context) => const MainNavigationScreen(),
        '/candidats': (context) => CandidatListPage(),
        '/votes': (context) => VoteScreen(),
        '/admin': (context) => AdminDashboard(),
      },
      initialRoute: '/',
    );
  }
}

// Fonction utilitaire pour créer une MaterialColor
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